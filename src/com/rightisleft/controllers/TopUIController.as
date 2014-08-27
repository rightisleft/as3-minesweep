package com.rightisleft.controllers
{
	
	import com.rightisleft.events.GameEvent;
	import com.rightisleft.models.ContenderVOs;
	
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
		
		private var _contenderVOs:ContenderVOs
		
		public function TopUIController(parent:DisplayObjectContainer, contenders:ContenderVOs)
		{
			_ctrl = new GenericTextController("Akz", 16, 0xFFFFFF)
			_ctrl.setText('MineSweep', _title)
				
			_contenderVOs = contenders;
				
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
			
			_contenderVOs.addEventListener(GameEvent.EVENT_DATA, onDataChange);
			_contenderVOs.addEventListener(GameEvent.EVENT_STATE, onStateChange);
			
		}
		
		private function onStateChange(event:GameEvent):void
		{
			switch(event.result)
			{
				case GameEvent.RESULT_PLAYER_WON:
				case GameEvent.RESULT_CONTENDER_WON:
					_ctrl.setText( event.result as String, _mineCount);
					_display.removeChild(_reset);
					break;
				
				case GameEvent.RESULT_PLAYING:
					onDataChange(event)
					_display.addChild(_reset);
					break;
			}
		}
		
		private function onDataChange(event:GameEvent):void
		{
			setCount(_contenderVOs.flaggedContenders, _contenderVOs.options.board.mineCount);
		}
		
		private function onReset(event:MouseEvent):void 
		{
			_contenderVOs.reset();
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