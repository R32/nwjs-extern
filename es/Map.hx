package es;

@:native("Map")
extern class IntMap<T> implements haxe.Constraints.IMap<Int,T> {
	@:overload(function(sm: IntMap<T>): IntMap<T>{})
	function new();
	function set(key: Int, value: T): Void;
	function get( key: Int ): Null<T>;
	@:native("has") function exists( key: Int ): Bool;
	@:native("delete") function remove( key: Int ) : Bool;

	function forEach(callb: T->Int->Void): Void;
	function clear(): Void;

	inline function copy(): IntMap<T>  return new IntMap(this);
	inline function keys(): Iterator<Int> return (untyped Array.from(nativeKeys()): Array<Int>).iterator();
	inline function iterator(): Iterator<T> return (untyped Array.from(nativeValues()): Array<T>).iterator();

	function toString() : String;

	var size(default, null): Int;
	@:native("keys") function nativeKeys(): ES6Itor<Int>;
	@:native("values") function nativeValues(): ES6Itor<T>;
}

@:native("Map")
extern class StringMap<T> implements haxe.Constraints.IMap<String,T> {
	@:overload(function(sm: StringMap<T>): StringMap<T>{})
	function new();
	function set(key: String, value: T): Void;
	function get( key: String ): Null<T>;
	@:native("has") function exists( key: String ): Bool;
	@:native("delete") function remove( key: String ) : Bool;

	function forEach(callb: T->String->Void): Void;
	function clear(): Void;

	inline function copy(): StringMap<T>  return new StringMap(this);
	inline function keys(): Iterator<String> return (untyped Array.from(nativeKeys()): Array<String>).iterator();
	inline function iterator(): Iterator<T> return (untyped Array.from(nativeValues()): Array<T>).iterator();

	function toString() : String;

	var size(default, null): Int;
	@:native("keys") function nativeKeys(): ES6Itor<String>;
	@:native("values") function nativeValues(): ES6Itor<T>;
}

@:native("Map")
extern class AnyMap<T> implements haxe.Constraints.IMap<Any,T> {
	@:overload(function(sm: AnyMap<T>): AnyMap<T>{})
	function new();
	function set(key: Any, value: T): Void;
	function get( key: Any ): Null<T>;
	@:native("has") function exists( key: Any ): Bool;
	@:native("delete") function remove( key: Any ) : Bool;

	function forEach(callb: T->Any->Void): Void;
	function clear(): Void;

	inline function copy(): AnyMap<T>  return new AnyMap(this);
	inline function keys(): Iterator<Any> return (untyped Array.from(nativeKeys()): Array<Any>).iterator();
	inline function iterator(): Iterator<T> return (untyped Array.from(nativeValues()): Array<T>).iterator();

	function toString() : String;

	var size(default, null): Int;
	@:native("keys") function nativeKeys(): ES6Itor<Any>;
	@:native("values") function nativeValues(): ES6Itor<T>;
}


@:multiType(@:followWithAbstracts K)
abstract Map<K,V>(IMap<K,V> ) {

	public function new();

	public inline function set(key:K, value:V) this.set(key, value);

	@:arrayAccess public inline function get(key:K) return this.get(key);

	@:arrayAccess @:noCompletion public inline function arrayWrite(k:K, v:V):V {
		this.set(k, v);
		return v;
	}

	public inline function exists(key:K) return this.exists(key);

	public inline function remove(key:K) return this.remove(key);

	public inline function forEach(callb: V->K->Void) untyped this.forEach(callb);

	public inline function clear() untyped this.clear();

	public inline function copy():Map<K,V> return untyped this.copy();

	public inline function keys():Iterator<K> return this.keys();

	public inline function iterator():Iterator<V> return this.iterator();

	public inline function toString():String return this.toString();

	@:to static inline function toStringMap<K:String,V>(t:IMap<K,V>):StringMap<V> {
		return new StringMap<V>();
	}

	@:to static inline function toIntMap<K:Int,V>(t:IMap<K,V>):IntMap<V> {
		return new IntMap<V>();
	}

	@:to static inline function toAnyMap<K:Any,V>(t:IMap<K,V>):AnyMap<V> {
		return new AnyMap<V>();
	}

	@:from static inline function fromStringMap<V>(map:StringMap<V>):Map< String, V > {
		return cast map;
	}

	@:from static inline function fromIntMap<V>(map:IntMap<V>):Map< Int, V > {
		return cast map;
	}

	@:from static inline function fromAnyMap<K:{ }, V>(map: AnyMap<V>):Map<Any, V> {
		return cast map;
	}

	// native
	public var size(get, never): Int;
	inline function get_size(): Int return untyped this.size;
	public inline function nativeKeys(): ES6Itor<K> return untyped this.nativeKeys();
	public inline function nativeValues(): ES6Itor<V> return untyped this.nativeValues();
}

@:dox(hide)
@:deprecated
private typedef IMap<K, V> = haxe.Constraints.IMap<K, V>;

private typedef ES6Itor<T> = {
	next: Void -> {
		value: T,
		done: Bool
	}
}
