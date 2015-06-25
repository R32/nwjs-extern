package nw;

/**
* 
 **Don'ts**

In summary, please DO NOT do following things:

 * Do not recreate UI elements, reuse them.

 * Do not reassign an element, such as `menu.items[0] = item or item = new gui.MenuItem({})`.

 * Do not delete an element, such `delete item`.

 * Do not change UI types' prototype.

 
 

*/
@:jsRequire("nw.gui")
extern class Gui {
	
	static var App:nw.gui.App;
	
	static var Shell:nw.gui.Shell;
	
	static var Screen:nw.gui.Screen;
	
	inline static var Clipboard = nw.gui.Clipboard;
	
	inline static var Window = nw.gui.Window;
	
	//@:deprecated("use 'nw.gui.Menu' instead of 'Gui.Menu'") static var Menu = nw.gui.Menu;
	//@:deprecated("use 'nw.gui.MenuItem' instead of 'Gui.MenuItem'")inline static var MenuItem = nw.gui.MenuItem;
	//@:deprecated("use 'nw.gui.Tray' instead of 'Gui.Tray'")inline static var Tray = nw.gui.Tray;
	//@:deprecated("use 'nw.gui.Shortcut' instead of 'Gui.Shortcut'")inline static var Shortcut = nw.gui.Shortcut;
}