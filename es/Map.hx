package es;

import es.ES6Itor;

@:native("Map")
extern class IntMap<T> implements haxe.Constraints.IMap<Int,T> {
	function new();
	function set(key: Int, value: T): Void;
	function get( key: Int ): Null<T>;
	function exists( key: Int ): Bool;
	@:native("delete") function remove( key: Int ) : Bool;

	function forEach(callb: T->Int->Void): Void;
	function clear(): Void;

	inline function keys(): Iterator<Int> return new HXItor<Int>( nativeKeys() );
	inline function iterator(): Iterator<T> return new HXItor<T>( nativeValues());

	function toString() : String;

	@:native("keys") private function nativeKeys(): ES6Itor<Int>;
	@:native("values") private function nativeValues(): ES6Itor<T>;
}

@:native("Map")
extern class StringMap<T> implements haxe.Constraints.IMap<String,T> {
	function new();
	function set(key: String, value: T): Void;
	function get( key: String ): Null<T>;
	function exists( key: String ): Bool;
	@:native("delete") function remove( key: String ) : Bool;

	function forEach(callb: T->String->Void): Void;
	function clear(): Void;

	inline function keys(): Iterator<String> return new HXItor<String>( nativeKeys() );
	inline function iterator(): Iterator<T> return new HXItor<T>( nativeValues());

	function toString() : String;

	@:native("keys") private function nativeKeys(): ES6Itor<String>;
	@:native("values") private function nativeValues(): ES6Itor<T>;
}

@:native("Map")
extern class AnyMap<T> implements haxe.Constraints.IMap<Any,T> {
	function new();
	function set(key: Any, value: T): Void;
	function get( key: Any ): Null<T>;
	function exists( key: Any ): Bool;
	@:native("delete") function remove( key: Any ) : Bool;

	function forEach(callb: T->Any->Void): Void;
	function clear(): Void;

	inline function keys(): Iterator<Any> return new HXItor<Any>( nativeKeys() );
	inline function iterator(): Iterator<T> return new HXItor<T>( nativeValues());

	function toString() : String;

	@:native("keys") private function nativeKeys(): ES6Itor<Any>;
	@:native("values") private function nativeValues(): ES6Itor<T>;
}


@:multiType(@:followWithAbstracts K)
abstract Map<K,V>(IMap<K,V> ) {

	public function new();

	public inline function set(key:K, value:V) this.set(key, value);

	@:arrayAccess public inline function get(key:K) return this.get(key);


	public inline function exists(key:K) return this.exists(key);


	public inline function remove(key:K) return this.remove(key);

	public inline function forEach(callb: V->K->Void) untyped this.forEach(callb);
	public inline function clear() untyped this.clear();

	public inline function keys():Iterator<K> {
		return this.keys();
	}

	public inline function iterator():Iterator<V> {
		return this.iterator();
	}

	public inline function toString():String {
		return this.toString();
	}

	@:arrayAccess @:noCompletion public inline function arrayWrite(k:K, v:V):V {
		this.set(k, v);
		return v;
	}

	@:to static inline function toStringMap<K:String,V>(t:IMap<K,V>):StringMap<V> {
		return new StringMap<V>();
	}

	@:to static inline function toIntMap<K:Int,V>(t:IMap<K,V>):IntMap<V> {
		return new IntMap<V>();
	}

	@:from static inline function fromStringMap<V>(map:StringMap<V>):Map< String, V > {
		return cast map;
	}

	@:from static inline function fromIntMap<V>(map:IntMap<V>):Map< Int, V > {
		return cast map;
	}

}

@:dox(hide)
@:deprecated
typedef IMap<K, V> = haxe.Constraints.IMap<K, V>;
