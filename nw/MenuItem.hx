package nw;
import js.node.events.EventEmitter;

#if nw_old
@:jsRequire("nw.gui","MenuItem")
#end
extern class MenuItem extends EventEmitter<MenuItem>{

	var type(default, null): MenuItemType;

	var label: String;

	var icon: String;

	var iconIsTemplate: Bool; // Mac

	var tooltip: String;      // Mac

	var checked: Bool;

	var enabled: Bool;

	var submenu: Menu;

	var click: Void->Void;

	var key:String;

	var modifiers:String;

	function new(option:MenuItemOption);
}

@:enum abstract MenuItemEvent<T:haxe.Constraints.Function>(Event<T>) to Event<T> {
	var Click:MenuItemEvent<Void->Void> = "click";
}

@:enum abstract MenuItemType(String) to String {
	var NORMAL = "normal";
	var SEPARATOR = "separator";
	var CHECKBOX = "checkbox";
}

typedef MenuItemOption = {

	?label: String,

	?icon: String,         // path

	?tooltip: String,

	?type: MenuItemType,   // default: Normal

	?click: Void->Void,    // on click

	?enabled: Bool,

	?checked: Bool,        // check box

	?submenu: Menu,        // sub Menu

	?key: String,          // shortcut key

	?modifiers: String,    // ctrl,shift,alt, ctrl-alt, ctrl-alt-shift

	?iconIsTemplate: Bool  // Mac, default: true,
}