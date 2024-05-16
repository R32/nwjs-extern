package nw;

#if nw_old
@:jsRequire("nw.gui","Shell")
#end
extern class Shell {

	static function openExternal( uri : String ) : Void;

	static function openItem( file_path : String ) : Void;

	static function showItemInFolder( file_path : String ) : Void;
}
