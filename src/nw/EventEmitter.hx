package nw;

import haxe.Constraints.Function;
import haxe.extern.EitherType;
import haxe.extern.Rest;

/*
 * https://nodejs.org/api/events.html#events_class_eventemitter
 */
extern class EventEmitter<T> {

	function addListener( event : T, listener : Function ) : Void; // TODO : returns SELF

	function emit( event : T, args : Rest<Dynamic> ) : Bool;

	function eventNames() : Array<String>;

	function getMaxListeners() : Int;

	function listenerCount( event : T ) : Int;

	function listeners( event : T ) : Array<Function>;

	function off( event : T, listener : Function ) : Void;

	function on( event : T, listener : Function ) : Void;

	function once( event : T, listener : Function ) : Void;

	function prependListener( event : T, listener : Function ) : Void;

	function prependOnceListener( event : T, listener : Function ) : Void;

	function removeAllListeners( event : T ) : Void;

	function removeListener( event : T, listener : Function ) : Void;

	function setMaxListeners( n : Int ) : Void;

	function rawListeners( event : T ) : Array<Function>;
}
