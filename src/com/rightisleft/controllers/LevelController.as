package com.rightisleft.controllers
{
	import com.rightisleft.events.GameEvent;
	import com.rightisleft.models.ContenderModel;
	import com.rightisleft.models.GameOptionsModel;
	import com.rightisleft.views.LevelView;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	public class LevelController
	{		
		private var _leveltext:Array;
		
		private var _parent:DisplayObjectContainer;
		private var _view:LevelView;
		private var _gameOptions:GameOptionsModel;
		private var _imgLoader:ImageLoadController;
		
		public function LevelController(parent:DisplayObjectContainer, view:LevelView):void {
			_parent = parent;
			_view = view;			
			
			//init key command graphic
			_imgLoader = new ImageLoadController('flagging_instructions.png', onLegendLoaded);
		}	
		
		private function onLegendLoaded(item:Bitmap):void
		{
			item.y = _parent.y - _view.y + _parent.stage.stageHeight - item.height;
			item.x = (_parent.stage.stageWidth * .5) - (item.width * .5);
			_view.addChild(item);
		}
		
		public function enter():void 
		{
			_parent.addChild(_view);
			_parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			for each (var tf:TextField in _leveltext) 
			{
				tf.addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		public function exit():void 
		{			
			_parent.removeChild(_view);	
			_parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			for each (var tf:TextField in _leveltext) 
			{
				tf.removeEventListener(MouseEvent.CLICK, onClick);
			}			
		}
		
		public function init(cmodel:ContenderModel):void 
		{
			_gameOptions = cmodel.options;
			
			_view.init(GameOptionsModel.MODES);
			
			for each(var tf:TextField in _view.rows)
			{
				tf.addEventListener(MouseEvent.CLICK, onClick);
			}
			
			cmodel.addEventListener(GameEvent.EVENT_STATE, onContenderStateChange);
		}
		
		private function onContenderStateChange(event:GameEvent):void
		{
			switch(event.result)
			{
				case GameEvent.RESULT_NEW:
					enter();
					break;
				
				case GameEvent.RESULT_PLAYING:
					exit();
					break;
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == 49)
			{
				_gameOptions.setMode(GameOptionsModel.MODE_EASY);
			}
			
			if(event.keyCode == 50)
			{
				_gameOptions.setMode(GameOptionsModel.MODE_MEDIUM);
			}
			
			if(event.keyCode == 51)
			{
				_gameOptions.setMode(GameOptionsModel.MODE_HARD);
			}
		}
	
		private function onClick(event:MouseEvent):void
		{
			var tf:TextField = event.currentTarget as TextField;
			
			//pass through clicked text
			_gameOptions.setMode(tf.text);
		}
	}
}