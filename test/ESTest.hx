package;

import es.Macros.*;
using es.pch.Chrome;
import js.Map;

class ESTest {

	static function main() {

		var s = "abcdefg";

		var p = JREG(~/cd/i);

		trace("s = " + s + ", p = " + p);

		trace( "s.slice(0): " + s.slice(0, s.length));

		trace( "s.search(p): " + s.search(p) );

		trace( "s.match(p): " + s.match(p) );

		trace( "s.replace(p, \"xy\"): " + s.replace(p, "xy") );

		trace( "s.slice(1): " + s.slice(1, s.length) );

		trace( "s.trim(): " + s.trim() );

		trace( "s.endsWith(\"efg\"): " + s.endsWith("efg") );

		trace( "s.startsWith(\"abc\"): " + s.startsWith("abc") );

		trace( "s.includes(\"cde\"): " + s.includes("cde") );

		trace( "s.normalize(): " + s.normalize() );

		trace( "s.repeat(2): " + s.repeat(2) );

		var a = [1, 2, 3, 4, 5];

		trace ("a.some(biggerthan3): " + a.some(biggerthan3));

		trace ("a.every(biggerthan3): " + a.every(biggerthan3));

		a.forEach(function(v, i){
			trace("forEach " + i + ": " + v);
		});

		trace ("a.reduce(): " + a.reduce(function(acc, curval, curindex) {
			return acc + curval;
		}, 0));

		trace ("a.reduceRight(): " + a.reduceRight(function(acc, curval, curindex) {
			return acc + curval;
		}, 0));

		trace ("a.find(biggerthan3): " + a.find(biggerthan3));

		trace ("a.findIndex(biggerthan3): " + a.findIndex(biggerthan3));

		trace ("a.copyWithin(1, 2): " + a.copyWithin(1, 2, a.length));

		trace ("a.fill(0): " + a.fill(0));


		// Map
		trace("------ es5 Map ------");

		var m3 = JMAP([
			"one" => 1,
			"two" => 2
		]);
		//$type(m3);
		m3.set("three", 3);
		var m4 = m3.copy();
		m4.set("one", 101);
		for (k in m3.keys()) trace(k + ": " + m3.get(k));
		for (v in m4) trace(v);
		m4.clear();
	}

	static function biggerthan3(v:Int, i:Int):Bool {
		return v >= 3;
	}
}