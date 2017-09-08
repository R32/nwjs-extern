package es;

import haxe.Constraints.Function;
import js.html.ArrayBuffer;
import js.Promise;

private typedef Buffer = haxe.extern.EitherType<ArrayBuffer, js.html.ArrayBufferView>;

/**
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly

`node --expose-wasm` for nodejs
*/
@:native("WebAssembly")
extern class WebAssembly {
	static function compile(buff: Buffer): Promise<Module>;
	static function instantiate(buff: Buffer, ?importObject: Dynamic<Any>): Promise<{module: Module, instance: Instance}>;
	static function validate(buff: Buffer): Bool;
}

@:native("WebAssembly.Module")
extern class Module {
	function new(buff: Buffer);
	function toString(): String;
	static function customSections(mod: Module, sec_name: String): Array<ArrayBuffer>; // ???
	static function exports(mod: Module): Array<{name: String, kind: String}>;
	static function imports(mod: Module): Array<{name: String, kind: String, module: String}>;
}

@:native("WebAssembly.Instance")
extern class Instance {
	var exports(default, null): Dynamic<Function>;
	function new(mod: Module, ?importObject: Dynamic<Any>);
	function toString(): String;
}

@:native("WebAssembly.Memory")
extern class Memory {
	var buffer(default, null): ArrayBuffer;

	function new(desc: {                          // each 1 is 64KB in size)
		initial: Int,
		?maximum: Int }
	);

	function grow(n: Int): Int;
	function toString(): String;
}

@:native("WebAssembly.Table")
extern class Table {
	var length(default, null): Int;

	function new(desc: {
		element: TableElement,
		initial: Int,
		?maximum: Int,
	});
	function get(i: Int): Function;               // return a WebAssembly function
	function set(i: Int, value: Function): Void;  // the value must be null or WebAssembly function
	function grow(n: Int): Int;
	function toString(): String;
}

@:enum private extern abstract TableElement(String) to String {
	var Anyfunc = "anyfunc";
}

@:native("WebAssembly.CompileError")
extern class CompileError extends js.Error {
	var fileName(default, null): String;
	var lineNumber(default, null): Int;
	var columnNumber(default, null): Int;
	function new(?message: String, ?fileName: String, ?lineNumber: Int);
}

@:native("WebAssembly.LinkError")
extern class LinkError extends js.Error {
	var fileName(default, null): String;
	var lineNumber(default, null): Int;
	var columnNumber(default, null): Int;
	function new(?message: String, ?fileName: String, ?lineNumber: Int);
}

@:native("WebAssembly.RuntimeError")
extern class RuntimeError extends js.Error {
	var fileName(default, null): String;
	var lineNumber(default, null): Int;
	var columnNumber(default, null): Int;
	function new(?message: String, ?fileName: String, ?lineNumber: Int);
}
