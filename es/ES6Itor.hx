package es;

typedef ES6ItorValue<T> = {
	value: T,
	done: Bool
};

typedef ES6Itor<T> = {
	next: Void -> ES6ItorValue<T>
};

@:native("HXItor")
class HXItor<T> {

	var cur: Int;
	var max: Int;
	var data: Array<T>;

	public function new (etor: ES6Itor<T>) {
		cur = 0;
		data = untyped Array.from(etor);
		max = data.length;
	}
	public inline function hasNext ( ):Bool return cur < max;

	public inline function next (): T return data[cur++];
}
