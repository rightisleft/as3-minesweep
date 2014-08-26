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
			this.dispatchEvent(new GameEvent(GameEvent.GAME_DATA_EVENT_FLAGS, _flagsOnBoard) );
		}
		
		public function win():void
		{
			this.dispatchEvent(new GameEvent(GameEvent.GAME_STATE_EVENT, GameEvent.GAME_STATE_YOU_WON) );
		}
		
		public function lose():void
		{
			this.dispatchEvent(new GameEvent(GameEvent.GAME_STATE_EVENT, GameEvent.GAME_STATE_YOU_LOST) );
		}
	}
}
