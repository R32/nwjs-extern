package helps;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.PositionTools;

using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using haxe.macro.MacroStringTools;
#end

/**
Example: Popup.hx

```haxe

typedef Bg = helps.AutoExtern<Background>;	// 

class Popup{
	public static function main(){
		Bg.init(chrome.Extension.getBackgroundPage());	// or Bg.init(js.Browser.window);
	}
}
```

------------------------
------- conflict -------

Issue: for conflict if `Aclass -> Bclass` and `Aclass <- Bclass`:

build.hxml

```bash
-D nwroot=build
-lib hxnwjs
-lib chrome-extension
-lib chrome-app
-cp src
--each

-main Background
-D auto_extern=Background
-js build/js/bg.js

--next
-main Popup
-D auto_extern=Popup
-js build/js/popup.js
```

Background.hx

```haxe
#if (auto_extern == "Background")
typedef Po = helps.AutoExtern<Popup>;
#else
typedef Po = Popup;
#end
@:expose("bg") class Background{
	public static var inst:Background;
	public static function main() {
		#if (auto_extern == "Background")
		var view = chrome.Extension.getViews({type:"popup"});
		if(view.length != 0){
			Po.init(view[0]);
			trace(Po.name);
		}
		#end
	}
}
```

Popup.hx

```haxe
#if (auto_extern == "Popup")
typedef Bg = helps.AutoExtern<Background>;
#else
typedef Bg = Background;
#end
@:expose class Popup{
	public inline static var name = "popup";
	public static function main() {
		#if (auto_extern == "Popup")
		Bg.init(chrome.Extension.getBackgroundPage());
		#end
		trace(Bg.inst);
	}
}
```

*/
#if !macro
@:genericBuild(helps.AutoExtern.gen())
#end
@:dce class AutoExtern<Expose>{
	static public function gen(){
	#if macro
		var pos = Context.currentPos();
		var cls:ClassType;
		var gen:ClassType;

		switch(Context.getLocalType()){
			case TInst(g, [TInst(c, _)]):
				gen = g.get();
				cls = c.get();
			default:
				Context.error("Class expected", pos);
		}

		var fields = new List<Field>();
		for(kf in getAllFields(cls)){
			if (StringTools.fastCodeAt(kf.name, 0) == "_".code) continue;
			if (kf.isPublic) fields.push( toField(kf, false) );
		}

		for (kf in cls.statics.get()) {	
			if (kf.name == "main" || StringTools.fastCodeAt(kf.name, 0) == "_".code) continue;
			fields.push(toField(kf, true));
		}

		var expose = cls.name;
		switch(cls.meta.extract(":expose")) {
			case []:
				Context.error("must set meta: \"@:expose\"", cls.pos);
			case [ { name:_, pos:_, params:[t] } ]: 
				expose = t.toString();	// with quotes: e.g: "aaa" or 'aaa';
				expose = expose.substr(1, expose.length - 2);			
			default:
		}

		td = {
			isExtern: true,
			pack: gen.pack,
			name: cls.name,
			pos: pos,
			kind: TDClass(null, [], false),
			fields: null,	
			meta: [ { name:":native", pos: pos, params:[(macro $v { expose } )] },
				{name:":dce",pos:pos, params: []}
			]
		};

		if (cls.constructor != null){
			var fc = toField(cls.constructor.get());
			switch(fc.kind){
				case FFun(f):
					fc.kind = FFun({
						args: f.args, 
						ret: null,
						expr: null
					});
				default:
					Context.error("", fc.pos);
			}
			fields.push(fc);
		}

		td.fields = rec(cls.name, Lambda.array(fields));

		// add static method "init"
		td.fields.push({
			name: "init",
			doc: "e.g: init(chrome.Extension.getBackgroundPage());",
			access: [AStatic, APublic, AInline],
			pos: pos,
			kind: FFun( {
				ret: macro :Void,
				args: [{
					name: "context",
					type: macro :Dynamic
				}],
				expr: macro {
					#if !nodejs
					untyped window[$v{ expose }] = context[$v{ expose } ];
					#end
				}
			})
		});
		
		cls.meta.remove(":keep");
		cls.meta.add(":dce", [], cls.pos);

		//Context.defineType(td);
		Context.defineModule(gen.module, [td]);
		Context.registerModuleDependency(gen.module, Context.resolvePath((cls.pack.length == 0 ? cls.name : (cls.pack.join("/") + "/" + cls.name )) + ".hx"));	
		//Context.registerModuleDependency(gen.module, Context.getPosInfos(gen.pos).file);	// current file name
		return Context.getType(gen.module + "." +td.name).toComplexType();
	#end
	}
	
	#if macro
	static var td:TypeDefinition;

	// e.g: typeFull("DOMElement") => "js.html.DOMElement"
	static function typeFull(type_name:String, ?pack:Array<String>):String {	
		if (pack != null && pack.length > 0) {
			return pack.toDotPath(type_name);
		}
		return Context.getType(type_name).toString();
	}

	static function recFuncArg(eq:String, f:Function, ext:Field):Null<FieldType> {			
		var ret:Null<ComplexType> = recType(eq, f.ret);
		var args:Array<FunctionArg> = [];
		var type:Null<ComplexType>;
		for (p in f.args) {
			args.push({
				name: p.name,
				opt: p.opt,
				value: p.value,
				type: recType(eq, p.type)
			});
		}

		if(f.ret == null) {
			ret = macro :Void;	// for extern function
			#if debug
			Context.warning('The return value of the "function ${ext.name}()" has been set to ":Void", Type required for extern classes.', ext.pos);
			#end
		}
		return FFun({ args: args, ret:ret, expr: null });
	}

	static function recFunc(eq:String, f: { args:Array<ComplexType>, ret:Null<ComplexType> } ):Null<ComplexType> {

		var r:Null<ComplexType> = recType(eq, f.ret);

		var a:Array<ComplexType> = [];
		for(p in f.args){
			a.push(recType(eq, p));
		}

		return TFunction(a, r);
	}

	static function recType(eq:String, c:Null<ComplexType>):Null<ComplexType> {	
		return
		switch(c){
			case TPath(t):				
				if (t.name == "StdTypes") {	
					//TPath( { pack:[], name:t.sub } );
					c;
				}else if (t.name == eq) {
					TPath( { pack:td.pack, name: td.name } );
				}else {
					typeFull(t.name, t.pack).toComplex();
				}
			case TFunction(a, r): 
					recFunc(eq, { args:a, ret:r } );

			case TAnonymous(a):
					TAnonymous( rec(eq, a) );

			// TODO: ???add more ComplexType
			default:
				macro :Dynamic;
		}
	}

	static function rec(eq:String, fields:Array<Field>):Array<Field> {
		var ret:Array<Field> = [];
		var kind:Null<FieldType>;

		for (f in fields) {
			switch(f.kind) {	
				case FVar(t = TPath(_), e):
					kind = FVar( recType(eq, t ), e);

				case FVar(TFunction(a, r), _):
					kind = FVar( recFunc(eq, { args:a, ret:r } ));

				case FVar(TAnonymous(a), _):
					kind = FVar( TAnonymous(rec(eq, a)));

				case FProp(g, s, t = TPath(_), _):
					kind = FProp(g, s, recType(eq, t));

				case FProp(g, s, TFunction(a, r), _):
					kind = FProp(g, s, recFunc(eq, { args:a, ret:r } ));

				case FProp(g, s, TAnonymous(a), _):
					kind = FProp(g, s, TAnonymous( rec(eq, a) ) );

				case FFun(t): kind = recFuncArg(eq, t, f);

				default:
					kind = f.kind;
			}
			ret.push({
				name: f.name,
				pos: f.pos,
				doc: f.doc,
				access: f.access,
				meta: f.meta,
				kind: kind
			});
		}
		return ret;
	}	
	
	// member fields, not have static
	static function getAllFields(ct:ClassType):Array<ClassField> {
		var ret:Array<ClassField> = ct.fields.get();
		
		return ct.superClass == null ? ret : ret.concat( getAllFields(ct.superClass.t.get()) );
	}
	
	static function varAccessToString(va : VarAccess, getOrSet : String) : String{
		return
		switch (va) {
			case AccNormal: "default";
			case AccNo: "null";
			case AccNever: "never";
			case AccResolve: throw "Invalid TAnonymous";
			case AccCall: getOrSet;
			case AccInline: "default";
			case AccRequire(_, _): "default";
		}
	}

	//TFun -> FFun
	static function tf2f(tf:Type):FieldType {
		return
		switch(tf){
			case TFun(args, ret):
				FFun({
					args: [
						for (a in args) {
							name: a.name,
							opt: a.opt,
							type: a.t.toComplexType(),
						}
					],
					ret: ret.toComplexType(),
					expr: null,
				});

			default:
				Context.error("Invalid Type", Context.currentPos());
				null;
		}
	}

	// copy from haxe.macro.TypeTools.toField
	static function toField(cf:ClassField, isStatic:Bool = false):Field {
		var acc:Array<Access> = cf.isPublic ? [ APublic ] : [ APrivate ];
		if (isStatic) acc.push(AStatic);
		return {
			name: cf.name,
			doc: cf.doc,
			meta: cf.meta.get(),
			pos: cf.pos,
			kind: switch([ cf.kind, cf.type ]) {
					case [FVar(AccInline, AccNever), ret]:
						acc.push(AInline);
						FVar( ret.toComplexType(), Context.getTypedExpr({
								expr: cf.expr().expr,
								pos:cf.pos,
								t:ret
						}));
				
					case [ FVar(read, write), ret ]:
						FProp(
							varAccessToString(read, "get"),
							varAccessToString(write, "set"),
							ret.toComplexType(),
							null
						);

					case [ FMethod(_), ret = TFun(_, _) ]:
						tf2f(ret);

					case [FMethod(_), TLazy(_)]:
						tf2f(cf.expr().t);

					default:
						Context.error("Invalid TAnonymous", cf.pos);
				},
			access: acc
		};
	}
	#end
}