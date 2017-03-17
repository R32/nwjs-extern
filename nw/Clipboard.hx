package nw;


#if nw_old
@:jsRequire("nw.gui", "Clipboard")
#end
extern class Clipboard {

	@:overload(function(ld: Array<ClipboardDataSet>): Void {})
	@:overload(function(d: ClipboardDataSet):Void {})
	function set(data: String, ?type: ClipboardType, ?row: Bool): Void;

	@:overload(function(ld: Array<ClipboardData>): Array<String> {})
	@:overload(function(d: ClipboardData): String {})
	function get(?type: ClipboardType, ?row: Bool): String;

	function clear(): Void;

	static function readAvailableTypes(): Array<ClipboardType>;

	@:native("get") static function getInstance(): Clipboard;
}

@:enum abstract ClipboardType(String) to String {
	var TEXT = "text";
	var PNG = "png";
	var JPEG = "jpeg";
	var HTML = "html";
	var RTF = "rtf";
}

private typedef ClipboardDataSet = {
	> ClipboardData,
	data: String
}

private typedef ClipboardData = {
	?type: ClipboardType,
	?row : Bool
}