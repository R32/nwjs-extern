package nw;

import js.node.events.EventEmitter;

#if nw_old
@:jsRequire("nw.gui","Screen")
#end
extern class Screen extends EventEmitter<Screen> {

	var screens(default, null): Array<ScreenData>;

	function chooseDesktopMedia (sources: Array<SourceType>, callback: String->Void): Bool;

	  // Note: Screen is a singleton object, and init must be called once during startup
	static function Init(): Screen;

	static var instance(get, never): Screen;
	static inline function get_instance(): Screen { return untyped Screen; }

	static var DesktopCaptureMonitor: DCMonitor; // TODO: Incomplete
}

@:enum abstract SourceType(String) to String {

	var DCWINDOW = "window";

	var DCSCREEN = "screen";
}

@:enum abstract ScreenEvent<T:haxe.Constraints.Function>(Event<T>) to Event<T> {

	var DISPLAYBOUNDSCHANGED: ScreenEvent<ScreenData->Void> = "displayBoundsChanged";

	var DISPLAYADDED: ScreenEvent<ScreenData->Void> = "displayAdded";

	var DISPLAYREMOVED: ScreenEvent<ScreenData->Void> = "displayRemoved";
}

typedef ScreenData = {

	id: Int,

	bounds: Rect,

	work_area: Rect,

	scaleFactor: Float,

	isBuiltIn: Bool,

	rotation: Int,

	touchSupport: Int
}

typedef Rect = {
	x:Int,
	y:Int,
	width:Int,
	height:Int
}

extern class DCMonitor extends EventEmitter<DCMonitor> {

	var started: Bool;

	function start(should_include_screens: Bool, should_include_windows: Bool): Array<Dynamic>; // TODO: unknown

	function stop(): Array<Dynamic>;

	function registerStream(id: String): Void;
}

@:enum abstract DCMonitorEvent<T:haxe.Constraints.Function>(Event<T>) to Event<T> {

	                        // (id, name, order, type, primary)
	var ADDED: DCMonitorEvent<String->String->Int->String->Bool->Void> = "added";
	                        // (order)
	var REMOVED: DCMonitorEvent<Int->Void> = "removed";
	                        // (id, new_order, old_order)
	var ORDERCHANGED: DCMonitorEvent<String->Int->Int->Void> = "orderchanged";
	                        // (id, name)
	var NAMECHANGED: DCMonitorEvent<String->String->Void> = "namechanged";
	                        // (id, thumbnail)
	var THUMBNAILCHANGED: DCMonitorEvent<String->String->Void> = "thumbnailchanged";
}