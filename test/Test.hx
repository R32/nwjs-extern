package;




import haxe.Constraints.Function;

import js.html.MouseEvent;
import js.Lib;
import js.Node;
import js.html.VideoElement;
import nw.Gui;

import nw.gui.App;
import nw.gui.Clipboard;
import nw.gui.Menu;
import nw.gui.MenuItem;
import nw.gui.Screen;
import nw.gui.Shell;
import nw.gui.Shortcut;
import nw.gui.Tray;
import nw.gui.Window;
import helps.AssetsPath;

class Test{
	
	function testMenu() {
		var items:Array<nw.gui.MenuItem> = [];
		
		items.push(new nw.gui.MenuItem( { label:"hello",tooltip:"say hello"} ));
		
		items.push(new nw.gui.MenuItem( { type:MenuItemType.Separator } ));
		
		items.push(new nw.gui.MenuItem( { 
			label:"click me",
			click:function(){
				trace("i'm clicked");
			},
			key: "s",
			modifiers:"ctrl"
			}
		));
		
		var mfiles = new Menu();
		for(it in items){
			mfiles.append(it);
		}
		
		var tfile = new nw.gui.MenuItem( { label:"文件"} );
		tfile.submenu = mfiles;
		
		var menu = new Menu({type:MenuTypes.MenuBar});
		menu.append(tfile);
		
		var win = nw.gui.Window.get();
		win.menu = menu;
		
		// context menu
		var pops:Array<nw.gui.MenuItem> = [];
		
		pops.push(new nw.gui.MenuItem( { 
			label:"paste",
			click:function(){
				js.Browser.document.execCommand("paste");
			}
		}));
		
		pops.push(new nw.gui.MenuItem( { 
			label:"copy",
			click:function(){
				js.Browser.document.execCommand("copy");
			}
		}));
		
		pops.push(new nw.gui.MenuItem( { 
			label:"cut",
			click:function(){
				js.Browser.document.execCommand("cut");
			}
		}));
		
		pops.push(new nw.gui.MenuItem( { type:MenuItemType.Separator } ));
		
		pops.push(new nw.gui.MenuItem( { 
			label:"about",
			click:function(){
				js.Browser.window.alert("about 1.0");
			}
		}));
		var mpop = new Menu({type:MenuTypes.Contextmenu});
		for(it in pops){
			mpop.append(it);
		}
	
		js.Browser.document.oncontextmenu = function(e:MouseEvent) {
			e.stopPropagation();
			e.preventDefault();
			mpop.popup(e.clientX, e.clientY);
			trace('clientX:${e.clientX}, screenX:${e.screenX}, pageX:${e.pageX}, layerX:${e.layerX}');
			trace([e.target, e.originalTarget, e.originalTarget, e.currentTarget, e.explicitOriginalTarget]);
		}
		
		//-=-=-=-=-=-=-=-=-=-=-= Tray -=-=-=-=-=-=-=-=-=-=--=
		var tray = new Tray( {
			title:"托盘",
			tooltip:"show help",
			icon:"cat.png"
		});
		tray.on(TrayEvent.Click, function() {
			win.focus();
		} );
		
		var tray_menu = new Menu({type:MenuTypes.Contextmenu});
		
		tray_menu.append(new nw.gui.MenuItem( { label:"turbo", type:MenuItemType.Checkbox } ));
		tray_menu.append(new nw.gui.MenuItem( { type:MenuItemType.Separator } ));
		tray_menu.append(new nw.gui.MenuItem( { label:"connect" } ));
		tray_menu.append(new nw.gui.MenuItem( { label:"exit", click:function(){
			tray.remove();
			win.close();
		}}));
		tray.menu = tray_menu;
	}
	
	function testShortcut() {
		var win = Gui.Window.get();
		var shortcut = new Shortcut({
			key: "Ctrl+Shift+P",
			
			active:function() {
				
				 trace("Global desktop keyboard shortcut: " + Lib.nativeThis.key + " active.");
			},
			
			failed:function(msg){
				trace(msg);
			}
		});
		
		trace(Gui.App.registerGlobalHotKey(shortcut));
	}
	
	function testCookie(){
		
		var NAME = "XXX";
		
		var win = nw.gui.Window.get();
			
		win.cookies.set( { name:NAME, value:"668",url:js.Browser.location.href,expirationDate:3582424262}, function(a) {
			 trace(a);
		});
		
		win.cookies.get( {name:NAME,url:""}, function(d) {
			 trace(d);
		});
		
		win.cookies.getAll( {}, function(a) {
			 trace(a);
		});
		
		win.cookies.remove( { name:NAME,url:js.Browser.location.href}, function(d){
			 trace(d);
		});
		
		win.cookies.onChanged.addListener(function(info) {
			trace(info);
		} );
		
		Node.setTimeout(function() { 
			win.cookies.get( {name:NAME, url:""}, function(d) {
				trace(d);
			});
		}, 1000);
		
	}
	
	function testClip(){
		var clip = nw.gui.Clipboard.getInstance();
		clip.set("hello wolrd!");
		trace(clip.get());
	}
	
	
	function testScreen() {
		
		var s = Gui.Screen.Init();
		
		
		function successCb(stream:{ended:Bool, id:String, label:String,onremovetrack:Dynamic,onaddtrack:Dynamic, onended:Dynamic}){
			trace(stream);
			var vedio:VideoElement = cast js.Browser.document.getElementById("share_screen");
			vedio.src = untyped Browser.window.webkitURL.createObjectURL(stream);
			vedio.play();
		}
		
		 function errorCb(err:{message:String, name:String, constraintName:String}){
			 trace(err);
		}
		
		s.chooseDesktopMedia([DesktopCaptureSourceType.DCWindow, DesktopCaptureSourceType.DCScreen],
			function (streamId){	
				var vid_constraint = {
				  mandatory: {
					chromeMediaSource: 'desktop', 
					chromeMediaSourceId: streamId, 
					maxWidth: 1440, 
					maxHeight: 872
				  }, 
				  optional:[]
				};
				untyped navigator.webkitGetUserMedia( { audio: false, video: vid_constraint }, successCb, errorCb);
			}
		);
		
	}
	public function new() {
		nw.gui.Window.get().show(true);
		testShortcut();
		testMenu();
		testScreen();
		testClip();
		testCookie();
		trace(AssetsPath.JSON_package);
	}
	
	static public function main(){
		new Test();		
	}
}