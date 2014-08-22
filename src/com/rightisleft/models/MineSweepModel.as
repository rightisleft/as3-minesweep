package com.rightisleft.models
{
	import com.rightisleft.vos.TileVO;
	
	import flash.utils.Dictionary;

	public class MineSweepModel
	{
		
		public var collectionOfTiles:Array = []
		public var mode:GameMode;
		public var isFlagging:Boolean = false;
		
		private var _easyMode:GameMode;
		private var _mediumMode:GameMode;
		private var _hardMode:GameMode;
		
		public static const MODE_EASY:String = 'easy';
		public static const MODE_MEDIUM:String = 'medium';
		public static const MODE_HARD:String = 'hard';
		
		public function MineSweepModel()
		{
			_easyMode = new GameMode();
			_easyMode.columns = 9
			_easyMode.rows = 9
			_easyMode.tileHeight = 16 
			_easyMode.tileWidth = 16 
			_easyMode.mineCount = 16
				
			_mediumMode = new GameMode();
			_mediumMode.columns = 16
			_mediumMode.rows = 16
			_mediumMode.tileHeight = 16 
			_mediumMode.tileWidth = 16 
			_mediumMode.mineCount = 40
				
			_hardMode = new GameMode();
			_hardMode.columns = 32
			_hardMode.rows = 16
			_hardMode.tileHeight = 16 
			_hardMode.tileWidth = 16 
			_hardMode.mineCount = 99				
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
	}
}

class GameMode {
	//default game values
	public var columns:int
	public var rows:int
	public var tileHeight:int
	public var tileWidth:int
	public var mineCount:int
	
	public function GameMode():void {}
}
