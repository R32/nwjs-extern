package;

import nw.Manifest;
import nw.App;
import nw.Clipboard;
import nw.Menu;
import nw.MenuItem;
import nw.Screen;
import nw.Shell;
import nw.Tray;
import nw.Shortcut;
import nw.Window;
import js.Node.process;

class Test {

	static function main() {
		var st = new Shortcut({
			key: "ctrl+alt+x",
			active: function (){
				trace("hello");
			}
		});
		App.registerGlobalHotKey(st);

		var c = Clipboard.getInstance();
		c.set("hello world");

		var screen = Screen.Init();

		var tbar = new Menu( { type: MENUBAR } );

		@:mergeBlock {
			var hello = new MenuItem( { label: "hello" } );
			hello.submenu = new Menu();
			hello.submenu.append(new MenuItem( { label: "world" } ));
			hello.submenu.append(new MenuItem( { type: SEPARATOR } ));
			hello.submenu.append(new MenuItem( { type: CHECKBOX, label: 'box' } ));
			tbar.append(hello);

			var tray = new Tray({
				icon: "cat.png",
				title: "how you doing!"
			});
			tray.menu = hello.submenu;

			tray.on(CLICK, function () {
				trace("click");
			});
		}
		var win = nw.Window.get();
		win.menu = tbar;
		win.show(true);

		for (f in process.versions.keys()) {
			trace(f + ": " + process.versions.get(f));
		}
	#if nw_old
		trace("use -D nw-old");
	#end
	}
}