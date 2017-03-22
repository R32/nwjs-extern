package es.pch;

  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference

extern class ES5Array {

	static inline function some<T>(a: Array<T>, callb: T->Int->Bool): Bool
		return untyped __js__("{0}.some({1})", a, callb);

	static inline function every<T>(a: Array<T>, callb: T->Int->Bool): Bool
		return untyped __js__("{0}.every({1})", a, callb);

	static inline function forEach<T>(a: Array<T>, callb: T->Int->Void): Void
		return untyped __js__("{0}.forEach({1})", a, callb);
		// (acc, curval, curindex)
	static inline function reduce<T,S>(a: Array<T>, callb: S->T->Int->S, init: S): S
		return untyped __js__("{0}.reduce({1}, {2})", a, callb, init);

	static inline function reduceRight<T,S>(a: Array<T>, callb: S->T->Int->S, init: S): S
		return untyped __js__("{0}.reduceRight({1}, {2})", a, callb, init);
}

// extends IE8String
extern class ES5String {
	static inline function trim(s: String): String
		return untyped __js__("{0}.trim()", s);
}
