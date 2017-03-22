extern of [nw.js](https://github.com/nwjs/nw.js) for haxe
-------

DOCS: <http://docs.nwjs.io>

Note: `-D nw-old` is used for old version of nw.js.

### DIR(nw)

nw.js state:

- [x] App
- [x] Clipboard
- [x] Menu
- [x] MenuItem
- [x] Screen, TODO: maybe incorrectly
- [x] Shell
- [x] Shortcut
- [x] Tray
- [x] Window

dependencies: [hxnodejs](https://github.com/HaxeFoundation/hxnodejs)


### DIR(es)

**WIP**

Some arguments may not be correct,
Since haxe(v3.4) currently does not correctly handle the optional-arguments for extern-static-extension).

usage:

```haxe
using es.pch.Chrome;           // using
import es.Macros.*;

class Main {
    static function main() {
        var s = "abcdefg";
        var p = JREG(~/cd/i);  // js.RegExp
        s.replace(p, "xy");    // extended std.String
        s.trim();              // es5

        var a = [1, 2, 3];
        a.fill(0);             // es6

        var map = JMAP([
            "one" => 1,
            "two" => 2
        ]);
        map.set("three", 3);
        for (k in map.keys()) trace(k + ": " + map.get(k));
    }
}
```

output:

```js
Main.main = function() {
    var s = "abcdefg";
    var p = /cd/i;
    s.replace(p, "xy");
    s.trim();
    var a = [1,2,3];
    a.fill(0);
    var map = new Map([["one",1],["two",2]]);
    map.set("three",3);
    var k = new HXItor(map.keys());
    while(k.hasNext()) {
        var k1 = k.next();
        console.log(k1 + ": " + map.get(k1));
    }
};
var HXItor = function(etor) {
    this.cur = 0;
    this.data = Array.from(etor);
    this.max = this.data.length;
};
HXItor.prototype = {
    hasNext: function() {
        return this.cur < this.max;
    }
    ,next: function() {
        return this.data[this.cur++];
    }
};
```
