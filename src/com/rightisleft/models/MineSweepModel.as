package com.rightisleft.models
{
	import com.rightisleft.vos.TileVO;
	
	import flash.utils.Dictionary;

	public class MineSweepModel
	{
		
		public var collectionOfTiles:Array = []
		
		//default game values
		public var collumns:int = 32
		public var rows:int = 24;
		public var tileHeight:int = 25;
		public var tileWidth:int = 25;
		public var mineCount:int = 100;
		
		public function MineSweepModel()
		{
			
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