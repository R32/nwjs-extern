package nw;

#if nw_old
@:jsRequire("nw.gui","Menu")
#end
extern class Menu{

	var items(default, null): Array<MenuItem>;

	function new(?option: {
		type: MenuTypes
	});

	function append(it: MenuItem): Void;

	function insert(it: MenuItem, index: Int): Void;

	function remove(it: MenuItem): Void;

	function removeAt(index: Int): Void;

	function popup(x: Int, y: Int): Void;

	function createMacBuiltin(appname: String, ?options: {
		?hideEdit: Bool,
		?hideWindow: Bool
	}): Void; // Mac
}

@:enum abstract MenuTypes(String) to String{
	var MENUBAR = "menubar";
	var CONTEXTMENU = "contextmenu";
}