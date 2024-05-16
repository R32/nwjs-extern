package nw;

import haxe.extern.EitherType;

#if nw_old
@:jsRequire("nw.gui","Window")
#end
extern class Window extends EventEmitter<WindowEvent> {

	var window : js.html.Window;

	var x : Int;

	var y : Int;

	var width : Int;

	var height : Int;

	var title : String;

	var menu : Menu;

	var isFullscreen : Bool;

	var isTransparent : Bool;

	var isKioskMode : Bool;

	var zoomLevel : Float;

	var cookies(default, null) : Cookie;

	function moveTo( x : Int, y : Int ) : Void;

	function moveBy( x : Int, y : Int ) : Void;

	function resizeTo( width : Int, height : Int ) : Void;

	function resizeBy( width : Int, height : Int ) : Void;

	function focus() : Void;

	function blur() : Void;

	function show( ?b : Bool ) : Void;

	function hide() : Void;

	function close( ?force : Bool ) : Void;

	function reload() : Void;

	function reloadDev() : Void;

	function reloadIgnoringCache() : Void;

	function maximize() : Void;

	function minimize() : Void;

	@:deprecated("since 0.13.0") function unmaximize() : Void;

	function restore() : Void;

	function enterFullscreen() : Void;

	function leaveFullscreen() : Void;

	function toggleFullscreen() : Void;

	function enterKioskMode() : Void;

	function leaveKioskMode() : Void;

	function toggleKioskMode() : Void;

	@:deprecated("since 0.13.0") function setTransparent( t : Bool ) : Void;

	// only available on SDK build flavor.
	function showDevTools( ?iframe : EitherType<String, Frame>, ?callback : Window->Void ) : Void;

	function closeDevTools() : Void;

	function getPrinters( callback : Array<Printer> ->Void ) : Void;

	function print( opt : PrintOpt ) : Void;

	function setMaximumSize( width : Int, height : Int ) : Void;

	function setMinimumSize( width : Int, height : Int ) : Void;

	function setResizable( resizable : Bool ) : Void;

	function setAlwaysOnTop( top : Bool ) : Void;

	function setVisibleOnAllWorkspaces( v : Bool ) : Void;

	function canSetVisibleOnAllWorkspaces() : Bool;

	function setPosition( pos : WindowPostion ) : Void;

	function setShowInTaskbar( show : Bool ) : Void;

	function requestAttention( attension : EitherType<Bool, Int> ) : Void;

	overload function capturePage( callback : Dynamic->Void, ?options : {?foramt: FormatImage, datatype: DataType} ) : Void;
	overload function capturePage( callback : String->Void, ?format : FormatImage ) : Void;

	function setProgressBar( progress : Float ) : Void;

	function setBadgeLabel( label : String ) : Void;

	function eval( ?frame : Frame, script : String ) : Dynamic;

	function evalNWBin( ?frame : Frame, path : String ) : Dynamic;

	static function get( ?window_object : js.html.Window ) : Window;

	static function open( url : String, ?options : {}, ?callback : Void->Void ) : Void; // see Manifest.WindowSubFields
}

private typedef Frame = js.html.IFrameElement;

typedef Printer = {
	cupsEnterprisePrinter : Bool,
	deviceName : String,
	printerDescription : String,
	printerName : String,
	printerOptions : Dynamic, // TODO:
}

typedef PrintOpt = {
	?autoprint : Bool,
	?printer : String,
	?pdf_path : String,
	?headerFooterEnabled : String,
	?landscape : Bool,
	?mediaSize : {
		?name : String,
		?width_microns : Int,
		?height_microns : Int,
		?custom_display_name : String,
		?is_default : Bool
	},
	?shouldPrintBackgrounds : Bool,
	?marginsType : Int,
	?marginsCustom : {
		?marginBottom : Int,
		?marginLeft : Int,
		?marginRight : Int,
		?marginTop : Int
	},
	?copies : Int,
	?headerString : String,
	?footerString : String,
}


extern enum abstract WindowPostion(String) to String {
	var PNULL = null;
	var PCENTER = "center";
	var PMOUSE = "mouse";
}


extern enum abstract WindowEvent(String) to String {

	var CLOSE = "close";

	var CLOSED = "closed";

	var LOADING = "loading";

	var LOADED = "loaded";

	var DOCUMENT_START = "document-start";

	var DOCUMENT_END = "document-end";

	var FOCUS = "focus";

	var BLUR = "blur";

	var MINIMIZE = "minimize";

	var RESTORE = "restore";

	var MAXIMIZE = "maximize";

	var MOVE = "move";

	var RESIZE = "resize";

	var ENTER_FULLSCREEN = "enter-fullscreen";

	var LEAVE_FULLSCREEN = "leave-fullscreen";

	var ZOOM = "zoom";

	var NEW_WIN_POLICY = "new-win-policy";

	var NAVIGATION = "navigation";

	@:deprecated("since 0.13.0") var CAPTUREPAGEDONE = "capturepagedone";

	@:deprecated("since 0.13.0") var DEVTOOLS_OPENED = "devtools-opened";

	@:deprecated("since 0.13.0") var DEVTOOLS_CLOSED = "devtools-closed";

}


extern enum abstract FormatImage(String) to String {
	var JPEG = "jpeg";
	var PNG = "png";
}

extern enum abstract DataType(String) to String {
	var RAW = "raw";
	var BUFFER = "buffer";
	var DATAURI = "datauri";
}

// TEST: https://github.com/nwjs/nw.js/pull/1361/files, https://developer.chrome.com/extensions/cookies
extern class Cookie {

	var onChanged : {

		function addListener( callback: CookieChangeInfo->Void ) : Void;

		function removeListener( callback : CookieChangeInfo->Void ) : Void;
	};

	function get( details : CookieDTGet, callback : CookieDTOut->Void ) : Void;

	function getAll( details : CookieDT, callback : Array<CookieDTOut>->Void ): Void;

	function set( details : CookieDTSet, callback : Array<CookieDTOut>->Void ): Void;

	function remove( details : CookieDTGet, callback : CookieDTGet->Void ): Void;
}

private typedef CookieChangeInfo = {
	removed : Bool,
	cookie : CookieDTOut,
	cause : CookieOnChangedCause
}

extern enum abstract CookieOnChangedCause(String) to String {
	var EVICTED = "evicted";
	var EXPIRED = "expired";
	var EXPLICIT = "explicit";
	var OVERWRITE = "overwrite";
}

private typedef CookieDTGet = {
	name : String,
	url : String
}

private typedef CookieDT = {
	?url : String,
	?name : String,
	?domain : String,
	?path : String,
	?secure : Bool,
	?session : Bool,
}

private typedef CookieDTOut = {
	> CookieDT,
	host_only : Bool,
	http_only : Bool,
	expiration_date : Float,
	value : String,
}

private typedef CookieDTSet = {
	> CookieDT,
	name : String,
	value : String,
	url : String,
	?hostOnly : Bool,
	?httpOnly : Bool,
	?expirationDate : Float
}
