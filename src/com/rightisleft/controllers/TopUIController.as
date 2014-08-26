package com.rightisleft.controllers
{
	
	import com.rightisleft.events.GameEvent;
	import com.rightisleft.models.GameOptionsVOs;
	import com.rightisleft.models.TileVOs;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class TopUIController
	{
		private var _mineCount:TextField = new TextField();
		private var _title:TextField = new TextField();
		private var _reset:TextField = new TextField();
		private var _ctrl:GenericTextController;
		
		private var _display:Sprite = new Sprite();
		
		private var _tileVOs:TileVOs
		
		public function TopUIController(parent:DisplayObjectContainer, tiles:TileVOs)
		{
			_ctrl = new GenericTextController("Akz", 16, 0xFFFFFF)
			_ctrl.setText('MineSweep', _title)
				
			_tileVOs = tiles;
				
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
			
			_tileVOs.addEventListener(GameEvent.GAME_DATA_EVENT_FLAGS, onDataChange);
			_tileVOs.addEventListener(GameEvent.GAME_STATE_EVENT, onStateChange);
			_tileVOs.options.addEventListener(GameEvent.GAME_STATE_EVENT, onStateChange);
			
		}
		
		private function onStateChange(event:GameEvent):void
		{
			switch(event.result)
			{
				case GameEvent.GAME_STATE_YOU_WON:
				case GameEvent.GAME_STATE_YOU_LOST:
					_ctrl.setText( event.result as String, _mineCount);
					break;
				
				case GameEvent.GAME_STATE_PLAYING:
					onDataChange(event)
					break;
			}
		}
		
		private function onDataChange(event:GameEvent):void
		{
			setCount(_tileVOs.flagsOnBoard, _tileVOs.options.board.mineCount);
		}
		
		private function onReset(event:MouseEvent):void 
		{
			_tileVOs.reset();
		}
		
		private function setCount(used:int, available:int):void
		{
			_ctrl.setText( 'Mines: ' + used +' / ' + available, _mineCount);
		}
		
		public function get height():int
		{
			return _display.height; 
		}
		
		public function get y():int
		{
			return _display.y; 
		}
		
		public function get flagvisible():Boolean
		{
			return _mineCount.visible;
		}
		
		public function set flagvisible(value:Boolean):void
		{
			_mineCount.visible = value;
		}
	}
}