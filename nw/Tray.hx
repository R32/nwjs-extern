package nw;

import js.node.events.EventEmitter;

#if nw_old
@:jsRequire("nw.gui","Tray")
#end
extern class Tray extends EventEmitter<Tray>{

	var title: String;

	var tooltip: String;

	var icon: String;

	var alticon: String; // Mac

	var iconsAreTemplates: Bool; // Mac

	var menu: Menu;

	function remove(): Void;

	function new(?option: TrayOption);
}

@:enum abstract TrayEvent<T:haxe.Constraints.Function>(Event<T>) to Event<T> {
	var CLICK: TrayEvent<Void->Void> = "click";
}

typedef TrayOption = {

	?title: String,

	?icon: String,

	?tooltip: String,

	?enabled: Bool,

	?menu: Menu
}

