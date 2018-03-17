package es.pch;

  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference

extern class ES5Array {

	static inline function some<T>(a: Array<T>, callb: T->Int->Bool): Bool
		return (a: Dynamic).some(callb);

	static inline function every<T>(a: Array<T>, callb: T->Int->Bool): Bool
		return (a: Dynamic).every(callb);

	static inline function forEach<T>(a: Array<T>, callb: T->Int->Void): Void
		(a: Dynamic).forEach(callb);
		// (acc, curval, curindex)
	static inline function reduce<T,S>(a: Array<T>, callb: S->T->Int->S, init: S): S
		return (a: Dynamic).reduce(callb, init);

	static inline function reduceRight<T,S>(a: Array<T>, callb: S->T->Int->S, init: S): S
		return (a: Dynamic).reduceRight(callb, init);
}

// extends IE8String
extern class ES5String {
	static inline function trim(s: String): String
		return (s: Dynamic).trim();
}
