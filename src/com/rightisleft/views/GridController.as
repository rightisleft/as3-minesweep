package com.rightisleft.views
{
	import com.rightisleft.models.GridModel;
	import com.rightisleft.vos.GridCellVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class GridController extends Sprite
	{
		private var _view:Bitmap;
		private var _bmpData:BitmapData;
		private var _bytes:ByteArray;
		private var _rect:Rectangle;
		private var _point:Point;
		private var _parent:DisplayObjectContainer;
		private var _model:GridModel;
		
		public function GridController(parent:DisplayObjectContainer, view:Bitmap)
		{
			_view = view;
			_rect = new Rectangle();
			_bytes = new ByteArray();
			_point = new Point();
			_rect = new Rectangle();
			_rect.x = 0;
			_rect.y = 0;
			_parent = parent;
		}
		
		public function lock():void {
			_bmpData.lock();
		}
		
		public function unlock():void {
			_bmpData.unlock();
		}
		
		public function init(model:GridModel):void {
			_model = model;
			
			_bmpData = new BitmapData(_parent.stage.stageWidth, _parent.stage.stageHeight, true, 0x00FF3366);			
			_view.bitmapData = _bmpData;
			this.addChild(_view);
		}
		
		public function updateCell(cell:GridCellVO):void {		
			_rect.width = cell.width;
			_rect.height = cell.height;
			_point.x = cell.x;
			_point.y = cell.y;
			_bmpData.copyPixels(cell.bitmapData, _rect, _point);
		}
		
		public function destroy():void
		{
			_bmpData.dispose();
		}
	}
}