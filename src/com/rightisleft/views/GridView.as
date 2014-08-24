package com.rightisleft.views
{
	import com.rightisleft.vos.GridCellVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class GridView extends Sprite
	{
		private var _bmpContainer:Bitmap;
		private var _bmpData:BitmapData;
		private var _bytes:ByteArray;
		private var _rect:Rectangle;
		private var _point:Point;
		
		public function GridView()
		{
			_rect = new Rectangle();
			_bytes = new ByteArray();
			_point = new Point();
			_rect = new Rectangle();
			_rect.x = 0;
			_rect.y = 0;
		}
		
		public function lock():void {
			_bmpData.lock();
		}
		
		public function unlock():void {
			_bmpData.unlock();
		}
		
		public function init(parent:DisplayObject):void {	
			_bmpData = new BitmapData(parent.stage.stageWidth, parent.stage.stageHeight, false, 0xFFFFFFFF);			
			_bmpContainer = new Bitmap(_bmpData);
			this.addChild(_bmpContainer);
		}
		
		//Todo: convert to array and use lock / unlock for performance improvements
		public function updateCell(cell:GridCellVO):void {		
			_rect.width = cell.width;
			_rect.height = cell.height;
			_point.x = cell.x;
			_point.y = cell.y;
			_bmpData.copyPixels(cell.bitmapData, _rect, _point);
		}
	}
}