package nw;

import haxe.Constraints.Function;

/*
 * https://docs.nwjs.io/en/latest/References/App/
 */
#if nw_old
@:jsRequire("nw.gui","App")
#end
extern class App {

	static var argv : Array<String>;

	static var fullArgv : Array<String>;

	static var filteredArgv : Array<String>;

	static var startPath : String;

	static var dataPath : String;

	static var manifest : Manifest;

	static function clearCache() : Void;

	static function clearAppCache( manifest_url : String ) : Void;

	static function closeAllWindows() : Void;

	static function crashBrowser() : Void;

	static function crashRenderer() : Void;

	static function getProxyForURL( url : String ) : String;

	static function setProxyConfig( config : String, pac_url : String ) : Void;

	static function quit() : Void;

	static function addOriginAccessWhitelistEntry(
		sourceOrigin : String,
		destinationProtocol : String,
		destinationHost : String,
		allowDestinationSubdomains : Bool
	) : Void;

	static function removeOriginAccessWhitelistEntry(
		sourceOrigin : String,
		destinationProtocol : String,
		destinationHost : String,
		allowDestinationSubdomains : Bool
	) : Void;

	static function registerGlobalHotKey( shortcut : Shortcut ) : Void;

	static function unregisterGlobalHotKey( shortcut : Shortcut ) : Void;

	static function on( event : AppEvent, listener : Function ) : Void;

	static function once( event : AppEvent, listener : Function ) : Void;

	static function removeListener( event : AppEvent, listener : Function ) : Void;

	static function removeAllListeners( event : AppEvent ) : Void;
}

extern enum abstract AppEvent(String) to String {
	/*
	 * Emitted when users opened a file with your app.
	 *
	 * Event:open(args) - (args : String) : the full command line of the program
	 */
	var OPEN = "open";

	/*
	 * This is a Mac specific feature. This event is sent when the user clicks the dock icon for an already running application.
	 */
	var REOPEN = "reopen"; // This is a Mac specific feature
}
