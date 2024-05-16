package nw;

import nw.Window;

extern class Manifest {

	// Required Fields

	var main : String;

	var name : String;

	// Features Control Fields

	var window : WindowSubFields;

	var webkit : WebKitSubFields;

	var domain : String;

	var nodejs : Null<Bool>;

	@:native("node-main") var node_main : String;

	@:native("bg-script") var bg_script : String;

	@:native("user-agent") var user_agent : String;

	@:native("node-remote") var node_remote : Array<String>;

	@:native("chromium-args") var chromium_args : String;

	@:native("js-flags") var js_flags : String;

	var inject_js_start : String;

	var inject_js_end : String;

	var additional_trust_anchors : Array<String>;

	var dom_storage_quota : Null<Int>;
}

extern class WindowSubFields {

	var id : String;

	var title : String;

	var width : Null<Int>;

	var min_width : Null<Int>;

	var max_width : Null<Int>;

	var height : Null<Int>;

	var min_height : Null<Int>;

	var max_height : Null<Int>;

	var icon : String;

	var position : WindowPostion;

	var as_desktop : Null<Bool>; // Linux

	var resizable : Null<Bool>;

	var always_on_top : Null<Bool>;

	var visible_on_all_workspaces : Null<Bool>; // Mac & Linux

	var fullscreen : Null<Bool>;

	var show_in_taskbar : Null<Bool>;

	var frame : Null<Bool>;

	var show : Null<Bool>;

	var kiosk: Null<Bool>;

	var transparent : Null<Bool>;
}

extern class WebKitSubFields {

	var double_tap_to_zoom_enabled : Null<Bool>;

	var plugin : Null<Bool>;
}
