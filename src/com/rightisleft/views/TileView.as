package com.rightisleft.views
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class TileView extends Sprite
	{
		private var _bmd:BitmapData;
		
		public function TileView(){}
		
		public function update(color:uint, number:int, width:int, height:int):Sprite
		{
			var aColor:uint;
			_bmd = new BitmapData(width, height, false, aColor);	
			return null;
		}
	}
}