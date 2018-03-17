package es.pch;

// extends Std.String
extern class IE8String {

	static inline function search(s: String, pat: js.RegExp): Int
		return (s:Dynamic).search(pat);


	static inline function match(s: String, pat: js.RegExp): Array<String>
		return (s:Dynamic).match(pat);

	static inline function replace(
		s: String,
		pat: js.RegExp,
		by: haxe.extern.EitherType<String, haxe.Constraints.Function>
	): String {
		return (s:Dynamic).replace(pat, by);
	}

	static inline function slice(s: String, start: Int, end: Int): String
		return (s:Dynamic).slice(start, end);
}
