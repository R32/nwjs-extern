package;

import nw.App;
import nw.Clipboard;
import nw.Menu;
import nw.MenuItem;
import nw.Manifest;
import nw.Screen;
import nw.Shell;
import nw.Tray;
import nw.Shortcut;
import nw.Window;

class Test {
	static function main() {
		var shortcut = new Shortcut({
			key : "ctrl+alt+x",
			active : function() {
				trace("hello");
			}
		});
		App.registerGlobalHotKey(shortcut);

		var clipboard = Clipboard.get();
		clipboard.set("hello world");
		trace(clipboard.get(TEXT));

		var screen = Screen.Init();
		trace(screen == Screen.get());

		var menu = new Menu({ type : MENUBAR });

		var hello = new MenuItem({ label : "hello" });
		hello.submenu = new Menu();
		hello.submenu.append(new MenuItem({ label: "world" }));
		hello.submenu.append(new MenuItem({ type: SEPARATOR }));
		hello.submenu.append(new MenuItem({ type: CHECKBOX, label: 'box' }));
		menu.append(hello);

		var tray = new Tray({
			icon : "cat.png",
			title : "how you doing!"
		});
		tray.menu = hello.submenu;

		tray.on(CLICK, function() {
			trace("tray clicked");
		});

		var nwwin = nw.Window.get();
		nwwin.menu = menu;
		nwwin.show(true);
	}
}
