package es;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.Tools;
#end

class Macros {

	macro static public function JREG(expr) {
		var ret = "";
		switch (expr.expr) {
		case EConst(CRegexp(r, opt)):
				ret = "/" + r + "/" + opt;
		case _: Context.error(ERROR_PREFIX + "Invalid format", expr.pos);
		}
		return macro ((untyped __js__($v{ret})): js.RegExp);
	}


	macro static public function JMAP(expr) {
		var K:Type = null, V:Type = null;
		var items:Array<Expr> = []; // [ [k, v], [k, v], ... ]
		if (ctype_any == null) {
			ctype_any = macro :Any;
			ctype_int = macro :Int;
			ctype_string = macro :String;
		}

		var expectedType = Context.getExpectedType().followWithAbstracts();
		var hasExpectedType = true;

		switch (expectedType) {
		case TMono(_):
			hasExpectedType = false;
		case TInst(_.toString() => "es.StringMap", [vt]):
			K = ctype_string.toType();
			V = vt;

		case TInst(_.toString() => "es.IntMap", [vt]):
			K = ctype_int.toType();
			V = vt;
		case TInst(_.toString() => "es.AnyMap", [vt]):
			K = ctype_any.toType();
			V = vt;
		case _:
			Context.error(ERROR_PREFIX + "only used for \"es.Map.hx\"", Context.currentPos());
		}

		switch (expr.expr) {
		case EArrayDecl(a):
			for (i in 0...a.length) {
				switch (a[i].expr) {
				case EBinop(OpArrow, e1, e2):
					var tk = Context.typeExpr(e1).t;
					var tv = Context.typeExpr(e2).t;

					if (K == null) {
						K = tk;
					}else if (!Context.unify(K, tk)) {
						 Context.error(ERROR_PREFIX + tk.toString() + " should be " + K.toString(), e1.pos);
					}
					if (isMono(tk)) Context.error(ERROR_PREFIX + "Illegal value", e1.pos);

					if (V == null || isMono(V))
						V = tv;  //TODO: maybe is `TInst(Array,[TMono(_)])`
					else if (!Context.unify(V, tv))
						Context.error(ERROR_PREFIX + tv.toString() + " should be " + V.toString(), e2.pos);

					items.push(macro [ $e1, $e2 ]);
				case _: Context.error(ERROR_PREFIX + "Invalid format", a[i].pos);
				}
			}

			if (!hasExpectedType) {
				if (useAnyType(K)) K = ctype_any.toType();
			}
		case _: Context.error(ERROR_PREFIX + "Invalid format", expr.pos);
		}
		var cK = K.toComplexType();
		var cV = V.toComplexType();

		return macro ((untyped __js__("new Map({0})", $a{ items } )): es.Map<$cK, $cV>);
	}

#if macro
	static inline var ERROR_PREFIX = "(from es.Macors): ";
	static var ctype_any: ComplexType;
	static var ctype_int: ComplexType;
	static var ctype_string: ComplexType;

	static function isMono(t: Type): Bool {
		return switch(t) {
		case TMono(_): true;
		case _: false;
		}
	}

	static function useAnyType(t: Type): Bool {
		var ts = Context.follow(t).toString();
		return !(ts == "Int" || ts == "String");
	}
#end
}
