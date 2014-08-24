package com.rightisleft.views
{
	import com.rightisleft.controllers.GenericTextController;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class TileBarController
	{
		private var _mineCount:TextField = new TextField();
		private var _title:TextField = new TextField();
		private var _reset:TextField = new TextField();
		private var _ctrl:GenericTextController;
		
		private var _display:Sprite = new Sprite();
		
		private var _resetHandler:Function;
		
		public function TileBarController(parent:DisplayObjectContainer, resetHandler:Function = null)
		{
			
			
			
			_resetHandler = resetHandler;
			_ctrl = new GenericTextController("Akz", 16, 0xFFFFFF)
			_ctrl.setText('MineSweep', _title)
				
			parent.addChild( _display );
			
			
			_title.x = (parent.stage.stageWidth * .5) - (_title.textWidth * .5);
			
			_display.graphics.beginFill(0xFFCCCCCC);
			_display.graphics.drawRect(0,0, parent.stage.stageWidth, _title.textHeight + 5);
			_display.graphics.endFill();
			
			setCount(0,0);
			
			_ctrl.setText('Reset', _reset);
			_reset.x = parent.stage.stageWidth - _reset.textWidth -10;
			_reset.addEventListener(MouseEvent.CLICK, onReset);
			
			_display.addChild(_title)
			_display.addChild(_mineCount)
			_display.addChild(_reset);
		}
		
		private function onReset(event:MouseEvent):void 
		{
			if(_resetHandler){
				_resetHandler()	
			}
		}
		
		public function setCount(used:int, available:int):void
		{
			_ctrl.setText( 'Mines: ' + used +' / ' + available, _mineCount);
		}
		
		public function get height():int
		{
			return _display.height; 
		}
	}
}