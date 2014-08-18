package com.rightisleft.models
{
	import com.rightisleft.vos.TileVO;

	public class MineSweepModel
	{
		
		public var collectionOfTiles:Array = []
		
		//default game values
		public var collumns:int = 8
		public var rows:int = 6;
		public var tileHeight:int = 100;
		public var tileWidth:int = 100;
		public var mineCount:int = 10;
		
		public function MineSweepModel()
		{
			trace("Error: need to link this in GridModel");
		}
		
		public function getRandomVO():TileVO 
		{
			var index:int = int ( Math.random() * collectionOfTiles.length );
			return collectionOfTiles[index] as TileVO;
		}
		
		public function getItemByID(id:String):TileVO
		{
			for each(var tile:TileVO in collectionOfTiles)
			{
				if(tile.id == id)
				{
					return tile;
				}
			}
			
			return null;
		}
	}
}