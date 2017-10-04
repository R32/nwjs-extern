package es;

import haxe.Constraints.Function;
import js.html.ArrayBuffer;
import js.Promise;

private typedef Buffer = haxe.extern.EitherType<ArrayBuffer, js.html.ArrayBufferView>;

/**
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly

only for Browser
*/
@:native("WebAssembly")
extern class WebAssembly {
	static function compile(buff: Buffer): Promise<WasmModule>;
	static function instantiate(buff: Buffer, ?importObject: Dynamic<Any>): Promise<{module: WasmModule, instance: WasmInstance}>;
	static function validate(buff: Buffer): Bool;
}

@:native("WebAssembly.Module")
extern class WasmModule {
	function new(buff: Buffer);
	function toString(): String;
	static function customSections(mod: WasmModule, sec_name: String): Array<ArrayBuffer>; // ???
	static function exports(mod: WasmModule): Array<{name: String, kind: String}>;
	static function imports(mod: WasmModule): Array<{name: String, kind: String, module: String}>;
}

@:native("WebAssembly.Instance")
extern class WasmInstance {
	var exports(default, null): Dynamic<Function>;
	function new(mod: WasmModule, ?importObject: Dynamic<Any>);
	function toString(): String;
}

@:native("WebAssembly.Memory")
extern class WasmMemory {
	var buffer(default, null): ArrayBuffer;

	function new(desc: {                          // each 1 is 64KB in size)
		initial: Int,
		?maximum: Int }
	);

	function grow(n: Int): Int;
	function toString(): String;
}

@:native("WebAssembly.Table")
extern class WasmTable {
	var length(default, null): Int;

	function new(desc: {
		element: WasmTableElement,
		initial: Int,
		?maximum: Int,
	});
	function get(i: Int): Function;               // return a WebAssembly function
	function set(i: Int, value: Function): Void;  // the value must be null or WebAssembly function
	function grow(n: Int): Int;
	function toString(): String;
}

@:enum private extern abstract WasmTableElement(String) to String {
	var Anyfunc = "anyfunc";
}

@:native("WebAssembly.CompileError")
extern class WasmCompileError extends js.Error {
	var fileName(default, null): String;
	var lineNumber(default, null): Int;
	var columnNumber(default, null): Int;
	function new(?message: String, ?fileName: String, ?lineNumber: Int);
}

@:native("WebAssembly.LinkError")
extern class WasmLinkError extends js.Error {
	var fileName(default, null): String;
	var lineNumber(default, null): Int;
	var columnNumber(default, null): Int;
	function new(?message: String, ?fileName: String, ?lineNumber: Int);
}

@:native("WebAssembly.RuntimeError")
extern class WasmRuntimeError extends js.Error {
	var fileName(default, null): String;
	var lineNumber(default, null): Int;
	var columnNumber(default, null): Int;
	function new(?message: String, ?fileName: String, ?lineNumber: Int);
}
