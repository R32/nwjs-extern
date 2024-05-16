package nw;

#if nw_old
@:jsRequire("nw.gui", "Clipboard")
#end
extern class Clipboard {

	overload function set( data : String, ?type : ClipboardType, ?raw : Bool ) : Void;
	overload function set( a : Array<ClipboardDataSet> ) : Void;
	overload function set( c : ClipboardDataSet ) : Void;

	overload function get( ?type: ClipboardType, ?raw : Bool ) : String;
	overload function get( a : Array<ClipboardData> ) : Array<String>;
	overload function get( c : ClipboardData ) : String;

	function clear() : Void;

	static function readAvailableTypes() : Array<ClipboardType>;

	static function get() : Clipboard;
}

extern enum abstract ClipboardType(String) to String {
	var TEXT = "text";
	var PNG = "png";
	var JPEG = "jpeg";
	var HTML = "html";
	var RTF = "rtf";
}

private typedef ClipboardDataSet = {
	> ClipboardData,
	data : String
}

private typedef ClipboardData = {
	?type : ClipboardType,
	?raw : Bool
}
