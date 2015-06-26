package helps;


#if !macro
/**
* Assets top dir: default is dir(Compiler.getOutput()) or -D nwroot=dir
* 
* Stolen from: https://github.com/ncannasse/heaps/blob/master/hxd/res/FileTree.hx
*/
@:build(helps.AssetsAuto.build())
class AssetsPath{
	//static inline var assert_name:String = "path/to/assert_name.ext";
}

/**
No need To Call this Class. 
*/
@:noDoc class AssetsAuto{//private access issue: https://github.com/HaxeFoundation/haxe/issues/3589
	public static function build(){
		throw "No need To Call this Class";
	}
}
#else

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.io.Path;
import sys.FileSystem;

private typedef Pair = {
	name:String,
	relUrl:String
}

@:noDoc class AssetsAuto{
	
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
				pos: this.pos
			});
		}
		
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
		
		if ( dir == null ) {
			//dir = haxe.io.Path.directory(haxe.macro.Compiler.getOutput());  // in --display, these can not use Compiler.xxxxxx()
			dir = "bin";
		}
		
		dir = haxe.io.Path.Path.normalize( sys.FileSystem.fullPath(dir) );
		
		var pos = Context.currentPos();
		
		if( !sys.FileSystem.exists(dir) || !sys.FileSystem.isDirectory(dir) )
			Context.error("Resource directory does not exists '" + dir + "'", pos);
		return dir;
	}

	static var invalidChars = ~/[^A-Za-z0-9_]/g;
	
	static public function build() {
		return new AssetsAuto().scan();
	}
}
#end