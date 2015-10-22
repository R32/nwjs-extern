package helps;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.PositionTools;

using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using haxe.macro.MacroStringTools;
/**
**Deprecated**, use Compiler.exclude, https://github.com/elsassph/modular-haxe-example

用于 JS 模块化编程, 自动将一个 haxe 类导出为 extern 类,仅用于语法提示. 

 - 设定为 extern class
 
 - 字段过滤: 
  * main 方法
  * 以 _ 字符开始的字段
  * 非 public
 
 - 通过 `@:expose` 获得导出名,然后设置为 `@:native`
 
 - 防止"被导出类"生成代码


 
How to Use:

 * original-class need to inherit the "helps.AutoExtern":
	
	```haxe
	@:expose("bg")
	class Background #if (display || (auto_extern != "Background" )) extends helps.AutoExtern #end{
		//...
	}
	```
 
 * define `-D auto-extern[=callerMainClassName]` in import-side, `[=callerMainClassName]` is used to prevent conflicts
 
 * import original-class in import-side, and then use the "Zx" as prefix

	Example: Popup.hx
 
	```haxe
	import Background;				//导入原类, 这个类需要继承 helps.AutoExtern

	class Popup{
		public static function main(){
			ZxBackground.init(chrome.extension.getBackgroundPage()); 	// optional in Browser:
			trace(ZxBackground);
			var inst = new ZxBackground();
		}
	}
	```
	
	build.hxml:
	
	```bash	
	-main Background
	-js build/js/bg.js
	
	--next
	-D auto-extern=Popup
	-main Popup
	-js build/js/popup.js
	```

issue: 如上示例
 
 * conflict: 感觉解决的方法有些繁锁.
  
 * does not deal with `@:overload`
*/
#if !macro
@:autoBuild(helps.AutoExtern.build())
#end
@:deprecated("Just use the \"Compiler.exclude()\" do it") class AutoExtern {
	static public function build(){
	#if (macro && (auto_extern || display))	
		var cls:ClassType = Context.getLocalClass().get();

		// prevent confilict
		if (Context.definedValue("auto_extern") == cls.name) return null;

		var pos = Context.currentPos();

		var fields = Lambda.filter(Context.getBuildFields(), function(f:Field){
			if (f.name == "main" || StringTools.fastCodeAt(f.name, 0) == "_".code) return false;
			if (f.access.indexOf(APublic) == -1) return false;
			return true;
		});

		var expose = cls.name;
		switch(cls.meta.extract(":expose")){
			case [ { name:_, pos:_, params:[t] } ]: 
				expose = t.toString();	// with quotes: e.g: "aaa" or 'aaa';
				expose = expose.substr(1, expose.length - 2);
				
			default:
		}
		
		td = {
			isExtern: true,
			pack: [],
			name: "Zx" + cls.name,
			pos: pos,
			kind: TDClass(null, [], false),
			fields: null,	// later
			meta: [ { name:":native", pos: cls.pos, params:[(macro $v { expose } )] }]
		};

		td.fields = rec(cls.name, Lambda.array(fields));
		// add static init method	
		td.fields.push({
			name: "init",
			doc: "e.g: init(chrome.extension.getBackgroundPage());",
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
					untyped $i { "window." + expose } = $i { "context." + expose };
					#end
				}
			})
		});
		
		cls.meta.remove(":keep");
		haxe.macro.Compiler.exclude(cls.pack.toDotPath(cls.name));
		haxe.macro.Compiler.exclude("helps.AutoExtern");
		
		Context.defineModule(td.name, [td]);
		Context.registerModuleDependency(td.name, Context.resolvePath((cls.pack.length == 0 ? cls.name : (cls.pack.join("/") + "/" + cls.name )) + ".hx"));
		Context.registerModuleDependency(td.name, Context.getPosInfos(pos).file);	// current file name
	#end
		return null;
	}
	#if macro
	static var td:TypeDefinition;

	/**
	e.g: typeFull("DOMElement") => "js.html.DOMElement"
	*/
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
		var ret = c;
		switch(c){
			case TPath(t):
				if (t.name == eq){ 
					ret = TPath( { pack:td.pack, name: td.name } );
				}else {
					ret = typeFull(t.name, t.pack).toComplex();	
				}	

			case TFunction(a, r): 
					ret = recFunc(eq, { args:a, ret:r } );

			case TAnonymous(a):
					ret = TAnonymous( rec(eq, a) );

			// TODO: ???add more ComplexType
			default:
				ret = macro :Dynamic;
		}
		return ret;
	}

	static function rec(eq:String, fields:Array<Field>):Array<Field> {
		var ret:Array<Field> = [];
		var kind:Null<FieldType>;

		for (f in fields) {
			switch(f.kind){
				case FVar(t = TPath(_), _):
					kind = FVar( recType(eq, t ));

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
	#end
}