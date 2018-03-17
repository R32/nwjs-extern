package es.pch;


extern class ES6Array {

	static inline function fill<T>(a: Array<T>, value: T): Array<T>
		return (a: Dynamic).fill(value);

	static inline function find<T>(a: Array<T>, callb: T->Int->Bool): Null<T>
		return (a: Dynamic).find(callb);

	static inline function findIndex<T>(a: Array<T>, callb: T->Int->Bool): Int
		return (a: Dynamic).findIndex(callb);

	static inline function copyWithin<T>(a: Array<T>, target: T, start: Int, end: Int): Array<T>
		return (a: Dynamic).copyWithin(target, start, end);
}

// extends ES5String
extern class ES6String {
	static inline function endsWith(s: String, sub: String): Bool
		return (s: Dynamic).endsWith(sub);

	static inline function startsWith(s: String, sub: String, pos: Int = 0): Bool
		return (s: Dynamic).startsWith(sub, pos);

	static inline function includes(s: String, sub: String, pos: Int = 0): Bool
		return (s: Dynamic).includes(sub, pos);

	static inline function normalize(s: String, from: String = "NFC"): String
		return (s: Dynamic).normalize(from);

	static inline function repeat(s: String, count: Int = 0): String
		return (s: Dynamic).repeat(count);
}
