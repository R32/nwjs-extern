package nw;

#if nw_old
@:jsRequire("nw.gui","Screen")
#end
extern class Screen extends EventEmitter<ScreenEvent> {

	static var screens(default, null) : Array<ScreenData>;

	static var DesktopCaptureMonitor : DesktopCaptureMonitor;

	inline static function get() : Screen return untyped Screen;
	/*
	 * Note: Screen is a singleton object, and init must be called once during startup
	 */
	static function Init() : Screen;

	static function chooseDesktopMedia( sources : Array<SourceType>, callback : String->Void ) : Bool;
}

extern enum abstract SourceType(String) to String {

	var DCWINDOW = "window";

	var DCSCREEN = "screen";
}

extern enum abstract ScreenEvent(String) to String {

	var DISPLAYBOUNDSCHANGED = "displayBoundsChanged";

	var DISPLAYADDED = "displayAdded";

	var DISPLAYREMOVED = "displayRemoved";
}

typedef ScreenData = {

	id : Int,

	bounds : Rect,

	work_area : Rect,

	scaleFactor : Float,

	isBuiltIn : Bool,

	rotation : Int,

	touchSupport : Int
}

typedef Rect = {
	x : Int,
	y : Int,
	width : Int,
	height : Int
}

extern class DesktopCaptureMonitor extends EventEmitter<DesktopCaptureMonitorEvent> {

	var started : Bool;

	function start( should_include_screens : Bool, should_include_windows : Bool ) : Array<Dynamic>; // TODO: unknown

	function stop() : Array<Dynamic>;

	function registerStream( id : String ) : Void;
}

extern enum abstract DesktopCaptureMonitorEvent(String) to String {
	// (id, name, order, type, primary)
	var ADDED = "added";
	// (order)
	var REMOVED = "removed";
	// (id, new_order, old_order)
	var ORDERCHANGED = "orderchanged";
	// (id, name)
	var NAMECHANGED = "namechanged";
	// (id, thumbnail)
	var THUMBNAILCHANGED = "thumbnailchanged";
}
