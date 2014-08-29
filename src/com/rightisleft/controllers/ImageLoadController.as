package com.rightisleft.controllers
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class ImageLoadController
	{
		private var _loader:Loader;
		private var _urlRequest:URLRequest;
		
		private var _url:String;
		private var _closure:Function;
		private var _context:LoaderContext;
		
		//NOT FOR PRODUCTION
		public function ImageLoadController(url:String, closure:Function)
		{
			_closure = closure;
			_url = '../assets/images/' + url;
			
			_urlRequest = new URLRequest(_url)
			_loader = new Loader()
			_context = new LoaderContext(false); //local web server - again not a production solution
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.load(_urlRequest, _context);	
		}
		
		private function onComplete(event:Event):void
		{
			_closure(event.target.loader.content);
			destroy();
		}
		
		private function onError(error:IOErrorEvent):void
		{
			destroy();
		}
		
		private function destroy():void
		{
			_closure = null;
			_url = null;
			_urlRequest = null;
			_loader = null;
			
		}
	}
}