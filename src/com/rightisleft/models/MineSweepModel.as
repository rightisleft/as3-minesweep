package com.rightisleft.models
{
	import com.rightisleft.vos.TileVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class MineSweepModel extends EventDispatcher
	{
		
		public var collectionOfTiles:Array = []
		public var collectionOfMines:Array = [];	
			
		private var _mode:BoardVO;
		public var isFlagging:Boolean = false;
		
		private var _easyMode:BoardVO;
		private var _mediumMode:BoardVO;
		private var _hardMode:BoardVO;
		
		
		public static const MODE_EASY:String = 'easy';
		public static const MODE_MEDIUM:String = 'medium';
		public static const MODE_HARD:String = 'hard'; 
		public static const MODES:Array = [MODE_EASY, MODE_MEDIUM, MODE_HARD]
			
		public static const GAME_STATE_NEW:String = 'new';
		public static const GAME_STATE_PLAYING:String = 'play';
		public static const GAME_STATE_YOU_LOST:String = 'you lost';
		public static const GAME_STATE_YOU_WON:String = 'you won';
		
		private var _flagsOnBoard:int;
		
		private var _gameState:String;
		
		public static const GAME_STATES:Array = [GAME_STATE_NEW, GAME_STATE_PLAYING, GAME_STATE_YOU_LOST, GAME_STATE_YOU_WON] 
		
		public function MineSweepModel()
		{
			_easyMode = new BoardVO();
			_easyMode.columns = 9
			_easyMode.rows = 9
			_easyMode.tileHeight = 25 
			_easyMode.tileWidth = 25 
			_easyMode.mineCount = 9
				
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
				
			_gameState = GAME_STATE_NEW;
		}
		
		private var _closure:Array = [];
		public function addGameStateChangeHandler(aFunction:Function):void 
		{
			_closure.push(aFunction);
		}
		
		public var incrementHandlers:Array = []
		
		public function setGameState(state:String):void
		{
			for each(var st:String in GAME_STATES)
			{
				if(state == st)
				{
					for each(var aFunc:Function in _closure)
					{
						_gameState = st;
						aFunc(this);
					}
				}
			}
		}
		
		public function get gameState():String
		{
			return _gameState;
		}
		
		public function setMode(value:String):void {
			switch(value) 
			{
				case MODE_EASY:
					this.mode = _easyMode;
				break;
				
				case MODE_MEDIUM:
					this.mode = _mediumMode;
				break;
				
				case MODE_HARD:
					this.mode = _hardMode;
				break;
			}
			
			setGameState(MineSweepModel.GAME_STATE_PLAYING);
		}
		
		public function getRandomVO():TileVO 
		{
			var index:int = int ( Math.random() * collectionOfTiles.length );
			return collectionOfTiles[index] as TileVO;
		}
		
		private var _hash:Dictionary = new Dictionary();
		public function getItemByID(id:String):TileVO
		{
			if(_hash[id]) {
				return _hash[id];
			}
			
			for each(var tile:TileVO in collectionOfTiles)
			{
				_hash[tile.id] = tile;
				if(tile.id == id)
				{
					return tile;
				}
			}
			
			return null;
		}
		
		public function destroy():void 
		{
			for each(var tile:TileVO in collectionOfTiles)
			{
				tile = null;
			}
			_hash = new Dictionary();
			flagsOnBoard = 0;
			collectionOfTiles = []
			collectionOfMines = []
		}

		public function get mode():BoardVO
		{
			return _mode;
		}

		public function set mode(value:BoardVO):void
		{
			_mode = value;
			this.dispatchEvent(new Event(Event.CHANGE) );
		}

		public function get flagsOnBoard():int
		{
			return _flagsOnBoard;
		}

		public function set flagsOnBoard(value:int):void
		{
			_flagsOnBoard = value;
			for each(var func:Function in incrementHandlers)
			{
				func();
			}
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
