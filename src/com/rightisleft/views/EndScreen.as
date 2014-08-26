package com.rightisleft.views
{
	import com.rightisleft.controllers.GenericTextController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class EndScreen extends Sprite
	{
		private var _text:TextField;
		private var _ctrl:GenericTextController
		private var _timer:Timer;
		
		public function EndScreen(title:String)
		{
			_text = new TextField();
			_ctrl = new GenericTextController();
			_ctrl.setText(title, _text);	
			
			_timer = new Timer(3000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
		}
		
		public function enter():void
		{
			this.addChild(_text);
			
			_timer.start();
		}
		
		public function exit():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE) );
		}
		
		private function onComplete(event:TimerEvent):void {
			_timer.stop();
			this.removeChild(_text);
		}
	}
}