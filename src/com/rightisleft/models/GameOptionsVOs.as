package com.rightisleft.models
{
	import com.rightisleft.events.GameEvent;
	
	import flash.events.EventDispatcher;

	public class GameOptionsVOs extends EventDispatcher
	{
		public static const MODE_EASY:String = 'easy';
		public static const MODE_MEDIUM:String = 'medium';
		public static const MODE_HARD:String = 'hard'; 
		public static const MODES:Array = [MODE_EASY, MODE_MEDIUM, MODE_HARD]
			
		private var _easyMode:BoardVO;
		private var _mediumMode:BoardVO;
		private var _hardMode:BoardVO;
		
		public var board:BoardVO;
		public var mode:String;
			
		public function GameOptionsVOs()
		{
			_easyMode = new BoardVO();
			_easyMode.columns = 9
			_easyMode.rows = 9
			_easyMode.tileHeight = 25 
			_easyMode.tileWidth = 25 
			_easyMode.mineCount = 10
			
			_mediumMode = new BoardVO();
			_mediumMode.columns = 16
			_mediumMode.rows = 16
			_mediumMode.tileHeight = 25 
			_mediumMode.tileWidth = 25
			_mediumMode.mineCount = 20
			
			_hardMode = new BoardVO();
			_hardMode.columns = 32
			_hardMode.rows = 16
			_hardMode.tileHeight = 25
			_hardMode.tileWidth = 25
			_hardMode.mineCount = 50	
				
			board = _easyMode;
		}
		
		public function setMode(value:String):void {
			switch( value.toLowerCase() ) 
			{
				case MODE_EASY:
					this.board = _easyMode;
					onChange();
					break;
				
				case MODE_MEDIUM:
					this.board = _mediumMode;
					onChange();
					break;
				
				case MODE_HARD:
					this.board = _hardMode;
					onChange();
					break;
			}
			
			mode = value;
		}
		
		private function onChange(value:* = null):void
		{
			this.dispatchEvent(new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_PLAYING) );
		}
	}
}

class BoardVO {
	//default game values
	public var columns:int
	public var rows:int
	public var tileHeight:int
	public var tileWidth:int
	public var mineCount:int
	
	public function BoardVO():void {}
}