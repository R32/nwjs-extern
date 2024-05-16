package nw;

#if nw_old
@:jsRequire("nw.gui","Shortcut")
#end
extern class Shortcut extends EventEmitter<ShortcutEvent>{

	var key : String;

	var active : Void->Void;

	var failed : String->Void;

	function new( option : {
		key : String,
		?active : Void->Void,
		?failed : String->Void
	});
}

extern enum abstract ShortcutEvent(String) to String {

	var ACTIVE = "active";

	var FAILED = "failed";
}
