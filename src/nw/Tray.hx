package nw;

#if nw_old
@:jsRequire("nw.gui","Tray")
#end
extern class Tray extends EventEmitter<TrayEvent> {

	var title : String;

	var tooltip : String;

	var icon : String;

	var alticon : String; // Mac

	var iconsAreTemplates : Bool; // Mac

	var menu : Menu;

	function remove() : Void;

	function new( ?option : TrayOption );
}

extern enum abstract TrayEvent(String) to String {
	var CLICK = "click";
}

typedef TrayOption = {

	?title : String,

	?icon : String,

	?tooltip : String,

	?enabled : Bool,

	?menu : Menu
}
