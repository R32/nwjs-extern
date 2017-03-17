package nw;

import js.node.events.EventEmitter;

#if nw_old
@:jsRequire("nw.gui","Shortcut")
#end
extern class Shortcut extends EventEmitter<Shortcut>{

	var key:String;

	var active:Void->Void;

	var failed:String->Void;

	function new(option:{
		key: String,
		?active: Void->Void,
		?failed: String->Void
	});
}

@:enum abstract ShortcutEvent<T:haxe.Constraints.Function>(Event<T>) to Event<T> {

	var ACTIVE:ShortcutEvent<Void->Void> = "active";

	var FAILED:ShortcutEvent<String->Void> = "failed";
}
