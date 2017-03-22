package es.pch;

// extends Std.String
extern class IE8String {

	static inline function search(s: String, pat: js.RegExp): Int
		return untyped __js__("{0}.search({1})", s, pat);

	static inline function match(s: String, pat: js.RegExp): Array<String>
		return untyped __js__("{0}.match({1})", s, pat);

	static inline function replace(
		s: String,
		pat: js.RegExp,
		by: haxe.extern.EitherType<String, haxe.Constraints.Function>
	): String {
		return untyped __js__("{0}.replace({1}, {2})", s, pat, by);
	}

	// TODO: 0x7fffffff
	static inline function slice(s: String, start: Int = 0, end: Int = 0x7fffffff): String
		return untyped __js__("{0}.slice({1}, {2})", s, start, end);

}
