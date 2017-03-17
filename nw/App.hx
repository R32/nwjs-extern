package nw;

import js.node.events.EventEmitter;

#if nw_old
@:jsRequire("nw.gui", "App")
#end
extern class App extends EventEmitter<App> {

	static var argv: Array<String>;

	static var fullArgv: Array<String>;

	static var filteredArgv: Array<String>;

	static var dataPath: String;

	static var manifest: Manifest;

	static function clearCache(): Void;

	static function clearAppCache(manifest_url: String): Void;

	static function closeAllWindows(): Void;

	static function crashBrowser(): Void;

	static function crashRenderer(): Void;

	static function getProxyForURL(url:String): String;

	static function setProxyConfig(config: String, pac_url: String): Void;

	static function quit(): Void;

	static function addOriginAccessWhitelistEntry(
		sourceOrigin: String,
		destinationProtocol: String,
		destinationHost: String,
		allowDestinationSubdomains: Bool
	): Void;

	static function removeOriginAccessWhitelistEntry(
		sourceOrigin: String,
		destinationProtocol: String,
		destinationHost: String,
		allowDestinationSubdomains: Bool
	): Void;

	static function registerGlobalHotKey(shortcut: Shortcut): Bool;

	static function unregisterGlobalHotKey(shortcut:Shortcut): Void;
}

@:enum abstract AppEvent<T:haxe.Constraints.Function>(Event<T>) to Event<T> {

	var OPEN:AppEvent<String->Void> = "open";

	var REOPEN: AppEvent<Void->Void> = "reopen";
}
