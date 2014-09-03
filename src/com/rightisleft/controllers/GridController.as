package com.rightisleft.controllers
{
	import com.rightisleft.models.GridModel;
	import com.rightisleft.vos.GridCellVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class GridController
	{
		private var _bmp:Bitmap;
		private var _view:Sprite;
		private var _bmpData:BitmapData;
		private var _bytes:ByteArray;
		private var _rect:Rectangle;
		private var _point:Point;
		private var _parent:DisplayObjectContainer;
		private var _model:GridModel;
		
		public function GridController(parent:DisplayObjectContainer, view:Sprite)
		{
			_view = view;
			_rect = new Rectangle();
			_bytes = new ByteArray();
			_point = new Point();
			_rect = new Rectangle();
			_bmp = new Bitmap();
			_rect.x = 0;
			_rect.y = 0;
			_parent = parent;
			
			_view.addChild(_bmp);
		}
		
		public function lock():void {
			_bmp.bitmapData.lock();
		}
		
		public function unlock():void {
			_bmp.bitmapData.unlock();
		}
		
		public function init(model:GridModel):void {
			_model = model;
			
			_parent.addChild(_view);
			_bmp.bitmapData = new BitmapData(_parent.stage.stageWidth, _parent.stage.stageHeight, true, 0x00FF3366);

			_view.x = (_parent.stage.stageWidth * .5) - (_model.gridWidth * .5);

			_view.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void
		{
			var cell:GridCellVO = _model.getCellByLocalCoardinate(event.localX, event.localY);
			_model.click(cell);
		}
		
		public function updateCell(cell:GridCellVO):void {		
			_rect.width = cell.width;
			_rect.height = cell.height;
			_point.x = cell.x;
			_point.y = cell.y;
			_bmp.bitmapData.copyPixels(cell.bitmapData, _rect, _point);
		}
		
		public function destroy():void
		{
			_bmp.removeEventListener(MouseEvent.CLICK, onClick);
			_parent.removeChild(_view);
			_bmp.bitmapData.dispose();
		}
	}
}