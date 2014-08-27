package com.rightisleft.models
{
	import com.rightisleft.events.GameEvent;
	import com.rightisleft.vos.TileVO;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class TileVOs extends EventDispatcher
	{
		
		public var collectionOfTiles:Array = []
		public var collectionOfMines:Array = [];	
			
		public var isFlagging:Boolean = false;
		
		private var _flagsOnBoard:int;
		
		public var options:GameOptionsVOs
		
		public function TileVOs(mode:GameOptionsVOs)
		{				
			options = mode;
			options.addEventListener(GameEvent.EVENT_STATE, onGameOptionEvent);
		}
		
		public var incrementHandlers:Array = []		

		
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
			
			for each(var mine:TileVO in collectionOfMines)
			{
				mine = null;
			}
			
			_flagsOnBoard = 0;
			
			_hash = new Dictionary();	
						
			collectionOfTiles = []
			
			collectionOfMines = []				
		}

		public function get flagsOnBoard():int
		{
			return _flagsOnBoard;
		}

		public function set flagsOnBoard(value:int):void
		{
			_flagsOnBoard = value;
			this.dispatchEvent(new GameEvent(GameEvent.EVENT_DATA, _flagsOnBoard) );
		}
		
		private var _state:GameEvent;
		public function win():void
		{
			_state = new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_WON);
			this.dispatchEvent( _state );
		}
		
		public function lose():void
		{
			_state = new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_LOST);
			this.dispatchEvent( _state );		
		}
		
		public function newGame():void
		{
			_state = new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_NEW);
			this.dispatchEvent( _state );		
		}
		
		public function reset():void
		{
			switch(_state.result)
			{
				case GameEvent.RESULT_WON:
				case GameEvent.RESULT_LOST:
					return; //Cant reset a game you already finished
				break;
				
				default:
					_state = new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_RESTART);
					this.dispatchEvent(new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_RESTART) );
				break;
			}

		}
		
		private function onGameOptionEvent(event:GameEvent):void {
			//redispatch gameoptions to simpify listeners, but maintain object hierarchy
			_state = event;
			this.dispatchEvent(event);
		}
	}
}
