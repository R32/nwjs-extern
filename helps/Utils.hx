package;


class Utils {
	
	/**
	e.g:  eventFire(document.getElementById('mytest1'), 'click');
	*/
	static public function eventFire(el:js.html.DOMElement, etype:String) {	
		if (Reflect.hasField(el, "fireEvent") } {
			untyped el.fireEvent("on" + etype);
		}else{
			var evObj = js.Browser.document.createEvent("Events");
			evObj.initEvent(etype, true, false);
			el.dispatchEvent(evObj);
		}
	}	
}