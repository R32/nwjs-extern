package helps;


import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.PositionTools;



using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using haxe.macro.MacroStringTools;
/**
**Experimental**

用于 JS 模块化编程, 自动将一个 haxe 类导出为 extern 类,仅用于语法提示. 

 - 设定为 extern class
 
 - 字段过滤: 
  * main 方法
  * 以 _ 字符开始的字段
  * 非 public
 
 - 通过 `@:expose` 获得导出名,然后设置为 `@:native`
 
 - 防止"被导出类"生成代码
 
如何使用:

 * 需要在类中使用 import 引导原类就行了. 然后使用 Zx 为前缀的类就行了
 
	```haxe
	import Background;				//导入原类, 这个类需要继承 helps.AutoExtern

	class Popup{
		public static function main(){
			trace(ZxBackground);
			var inst = new ZxBackground();	// if have
		}
	}
	``` 
 
*/
#if !macro
@:autoBuild(helps.AutoExtern.build())
#end
class AutoExtern {	
	static public function build(){
	#if macro
		var pos = Context.currentPos();
		
		var fields = Lambda.filter(Context.getBuildFields(), function(f:Field){
			if (f.name == "main" || StringTools.fastCodeAt(f.name, 0) == "_".code) return false;
			if (f.access.indexOf(APublic) == -1) return false;
			return true;
		});
		
		var cls:ClassType = Context.getLocalClass().get();
		var self:String = cls.name;
		
		//当这个类不是 main 类时, 尝试 cls.meta.remove(":keep"); 
		// 但是似乎没有方法能获得 -main 指定的参数
		
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
			name: "Zx" + self,
			pos: pos,
			kind: TDClass(null, [], false),
			fields: [],
			meta: [ { name:":native", pos: cls.pos, params:[(macro $v { expose } )] }]
		};
		//trace(cls.meta.extract(":expose"));		
		//trace(td.meta[0]);
		
		var kind:Null<FieldType>;
	
		
		for (f in fields) {
			switch(f.kind){
				case FVar(t = TPath(_), _): 
					kind = FVar( recField(self, t ));
						
				case FVar(TFunction(a, r), _):
					kind = FVar( recFunc(self, { args:a, ret:r } ));
						
				case FProp(g, s, t = TPath(_), _):
					kind = FProp(g, s, recField(self, t));
				
				case FProp(g, s, TFunction(a, r), _):
					kind = FProp(g, s, recFunc(self, { args:a, ret:r } ));
						
				case FFun(t): kind = recFuncArg(self, t, f);
				
				default:
					kind = null;
					Context.warning("unsupported type: " + f.name, f.pos);
			}
			
			td.fields.push({
				name: f.name,
				pos: f.pos,
				doc: f.doc,
				access: f.access,
				meta: f.meta,
				kind: kind == null ? f.kind : kind
			});
		}
		
		//Context.defineType(td);
		Context.defineModule(td.name, [td]);
		Context.registerModuleDependency(td.name, Context.resolvePath(cls.name + ".hx"));
	#end
		return null;
	}
	#if macro
	static var td:TypeDefinition;
	
	static function typeFull(type:String, ?pack:Array<String>):String {	
		if (pack != null && pack.length > 0) {			
			return pack.toDotPath(type);	
		}
		return Context.getType(type).toString();
	}
	
	static function recFuncArg(name:String, f:Function, ext:Field):Null<FieldType> {	
		var ret:Null<ComplexType> = recField(name, f.ret);
		var args:Array<FunctionArg> = [];
		var type:Null<ComplexType>;
		for (p in f.args) {
			type = recField(name, p.type);
			args.push({
				name: p.name,
				opt: p.opt,
				value: p.value,
				type: type != null ? type :(macro :Dynamic)
			});
		}
		
		if(ret == null) {
			ret = macro :Void;	// for extern function
			#if debug
			Context.warning('The return value of the "function ${ext.name}()" has been set to ":Void", Type required for extern classes.', ext.pos);
			#end
		}
		return FFun({ args: args, ret:ret, expr: null });
	}
	
	static function recFunc(name:String, f: { args:Array<ComplexType>, ret:Null<ComplexType> } ):Null<ComplexType> {
		
		var r:Null<ComplexType> = recField(name, f.ret);
		
		var a:Array<ComplexType> = [];
		for(p in f.args){
			a.push(recField(name, p));
		}
		
		return TFunction(a, r);
	}
	
	static function recField(name:String, c:Null<ComplexType>):Null<ComplexType> {	
		var ret = c;
		switch(c){
			case TPath(t): 
				if (t.name == name){ 
					ret = TPath( { pack:td.pack, name: td.name } );
				}else {
					ret = typeFull(t.name, t.pack).toComplex();	
				}	
	
			case TFunction(a, r): 
					ret = recFunc(name, { args:a, ret:r } );
					
			default:
				ret = null;	
		}
		return ret;
	}
	
	#end
}