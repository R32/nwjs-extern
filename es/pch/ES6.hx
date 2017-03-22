package es.pch;


extern class ES6Array {

	static inline function fill<T>(a: Array<T>, value: T): Array<T>
		return untyped __js__("{0}.fill({1})", a, value);

	static inline function find<T>(a: Array<T>, callb: T->Int->Bool): Null<T>
		return untyped __js__("{0}.find({1})", a, callb);

	static inline function findIndex<T>(a: Array<T>, callb: T->Int->Bool): Int
		return untyped __js__("{0}.findIndex({1})", a, callb);

	static inline function copyWithin<T>(a: Array<T>, target: T, start: Int = 0, end: Int = 0x7fffffff): Array<T>
		return untyped __js__("{0}.copyWithin({1},{2},{3})", a, target, start, end);
}

// extends ES5String
extern class ES6String {
	static inline function endsWith(s: String, sub: String): Bool
		return untyped __js__("{0}.endsWith({1})", s, sub);

	static inline function startsWith(s: String, sub: String, pos: Int = 0): Bool
		return untyped __js__("{0}.startsWith({1}, {2})", s, sub, pos);

	static inline function includes(s: String, sub: String, pos: Int = 0): Bool
		return untyped __js__("{0}.includes({1}, {2})", s, sub, pos);

	static inline function normalize(s: String, from: String = "NFC"): String
		return untyped __js__("{0}.normalize({1})", s, from);

	static inline function repeat(s: String, count: Int = 0): String
		return untyped __js__("{0}.repeat({1})", s, count);

}
