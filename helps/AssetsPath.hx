package helps;


#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.io.Path;
import sys.FileSystem;

private typedef Pair = {
	name:String,
	relUrl:String
}

@:noDoc 
private class Zz{
	
	var path:String;
	
	var currentModule:String;	
	
	var pos : Position;
	
	function new() {
		this.path = getOutPath();
		currentModule = Std.string(Context.getLocalClass());
		pos = Context.currentPos();
	}
	
	function scan():Array<haxe.macro.Expr.Field> {
		var fields = Context.getBuildFields();
		var col:Array<Pair> = [];
		
		scanRec("", col);
		
		for(it in col){	
			fields.push({
				name: it.name,
				doc: "filepath: " + it.relUrl,
				access: [APublic, AStatic, AInline],
				kind:  FVar(macro :String, Context.makeExpr(it.relUrl, pos)),
				pos: pos
			});
		}
		Context.registerModuleDependency(currentModule, path);
		return fields;
	}
	
	function scanRec(relPath:String, out:Array<Pair>):Void {
		
		var dir = this.path + (relPath == "" ? "" : "/" + relPath);
		
		var allFiles = FileSystem.readDirectory(dir).filter(function(f) {
			return !(f.charCodeAt(0) == ".".code || f.charCodeAt(0) == "_".code);	// filter
		});
		
		for (name in allFiles) {
			
			var tp = dir + "/" + name;
			
			if (!FileSystem.isDirectory(tp)) {
				out.push( handFile(relPath, name) );
			}else {
				var subdir = (relPath == "" ? "" : relPath + "/") + name;
				scanRec(subdir ,out);
			}
			
		}
	}
	
	
	/**
	e.g:
	
		relPath: `path/to/sub`
		
		name: `log.txt` or `data.bin`
		
		return: `TXT_path_to_sub__log => path/to/sub/log.txt`
	*/
	function handFile(relPath:String, name:String):Pair {	
		var p = new Path(name);
		var noExt = p.file;
		var ext = p.ext.toUpperCase() + "_";
		
		var relUrl = name;
		
		var ident = invalidChars.replace(noExt, "_");
		
		if(relPath != ""){
			relUrl = relPath + "/" + name;
			ident = invalidChars.replace(relPath,"_") + "__" + ident;
		}
		
		if (ext != "") ident = ext + ident;
		
		if ( ident.charCodeAt(0) >= "0".code && ident.charCodeAt(0) <= "9".code ){
			ident = "_" + ident;
		}
		
		return { name:ident, relUrl:relUrl };
	}
		
	public static function getOutPath() {
		var dir = Context.definedValue("nwroot");
		
		if ( dir == null ) dir = "bin";
		
		dir = haxe.io.Path.Path.normalize( sys.FileSystem.fullPath(dir) );
		
		var pos = Context.currentPos();
		
		if( !sys.FileSystem.exists(dir) || !sys.FileSystem.isDirectory(dir) )
			Context.error("Resource directory does not exists '" + dir + "'", pos);
		return dir;
	}
	static var invalidChars = ~/[^A-Za-z0-9_]/g;
}
#else
/**
Assets top dir: default is `bin` or -D nwroot=bin 
*/
@:build(helps.AssetsPath.build())
#end
class AssetsPath{
	#if macro
	public static function build() {	
		return @:privateAccess new Zz().scan();
	}
	#end
}

