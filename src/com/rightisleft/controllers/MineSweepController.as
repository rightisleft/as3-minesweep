package com.rightisleft.controllers
{
	import com.rightisleft.models.MineSweepModel;
	import com.rightisleft.views.GridView;
	import com.rightisleft.vos.GridCellVO;
	import com.rightisleft.vos.GridVO;
	import com.rightisleft.vos.TileVO;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class MineSweepController
	{
		private var _view:Sprite = new Sprite;
		private var _mineModel:MineSweepModel = new MineSweepModel();
		
		private var _gridView:GridView;
		private var _gridModel:GridVO;
		
		private var _tileView:BitmapData;
		private var _textField:TextField;
		
		public function MineSweepController(gridModel:GridVO, gridView:GridView)
		{
			
			_gridView = gridView;
			_gridModel = gridModel;
			_textField = new TextField();
			
			//bind grid cell id to tile vo
			for each (var cell:GridCellVO in gridModel.collection) 
			{
				var tile:TileVO = new TileVO();
				tile.id = cell.id;
				_mineModel.collectionOfTiles.push ( tile );
			}
			
			
			//set titles to be mines
			for (var i:int = 0; i < _mineModel.mineCount; i++) 
			{
				var aTile:TileVO = _mineModel.getRandomVO();
				while(aTile.type == TileVO.TYPE_MINE) {
					aTile = _mineModel.getRandomVO();
				}
				
				aTile.type = TileVO.TYPE_MINE;
				updateNieghbors(aTile);
			}
			
			_gridView.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function updateNieghbors(tile:TileVO):void
		{
			var nextCell:GridCellVO; 
			var originCell:GridCellVO = _gridModel.getCellByID(tile.id);
			var nextTile:TileVO;
			var doUpdate:Function = function (cell:GridCellVO):void
			{			
				if(cell != null)
				{
					nextTile = _mineModel.getItemByID(cell.id);				
					nextTile.incrementNeighbors()
				}
			}	
			
			nextCell = _gridModel.getCellToNorthOf(originCell)
			doUpdate(nextCell);
				
			nextCell = _gridModel.getCellToSouthOf(originCell)
			doUpdate(nextCell);
				
			nextCell = _gridModel.getCellToEastOf(originCell)
			doUpdate(nextCell);
				
			nextCell = _gridModel.getCellToWestOf(originCell)
			doUpdate(nextCell);
			
			nextCell = _gridModel.getCellToNorthWestOf(originCell)
			doUpdate(nextCell);
			
			nextCell = _gridModel.getCellToNorthEastOf(originCell)
			doUpdate(nextCell);
			
			nextCell = _gridModel.getCellToSouthEastOf(originCell)
			doUpdate(nextCell);
			
			nextCell = _gridModel.getCellToSouthWestOf(originCell)
			doUpdate(nextCell);
		}
		
		private function onClick(event:MouseEvent):void {
			var cell:GridCellVO = _gridModel.getCellByLocalCoardinate(event.localX, event.localY);
			var tileVO:TileVO = _mineModel.getItemByID(cell.id);
			
			tileVO.printDangerEdges();
						
			var aColor:uint;
			_textField.text = "";
			
			if(tileVO.type == TileVO.TYPE_MINE)
			{
				aColor = 0xFFF80000;
			} else if (tileVO.danger_edges > 0) {
				aColor = 0xFFFFC809;
				_textField.text = tileVO.danger_edges + "";
			} else {
				aColor = 0xFF336600;
			}
		
			//blit text
			var snapshot:BitmapData = new BitmapData(_textField.width, _textField.height, true, 0x00000000);
			snapshot.draw(_textField, new Matrix());
			
			//compose to square
			var newData:BitmapData = new BitmapData(_mineModel.tileWidth, _mineModel.tileHeight, false, aColor);
			var rect:Rectangle = new Rectangle(0, 0, _textField.width, _textField.height);
			var aPoint:Point = new Point();
			newData.copyPixels(snapshot, rect, aPoint);
			
			cell.bitmapData = newData; 						
		}
	}
}