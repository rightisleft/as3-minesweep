package com.rightisleft.controllers
{
	import com.rightisleft.models.MineSweepModel;
	import com.rightisleft.views.GridView;
	import com.rightisleft.vos.GridCellVO;
	import com.rightisleft.vos.GridVO;
	import com.rightisleft.vos.TileVO;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class MineSweepController
	{
		private var _view:Sprite = new Sprite;
		private var _mineModel:MineSweepModel
		
		private var _gridView:GridView;
		private var _gridModel:GridVO;
		
		private var _tileView:BitmapData;
		private var _textField:TextField;
		
		public function MineSweepController(gridModel:GridVO, gridView:GridView, mineModel:MineSweepModel)
		{
			
			_mineModel = mineModel;
			_gridView = gridView;
			_gridModel = gridModel;
			_textField = new TextField();
			
			//bind grid cell id to tile vo
			for each (var cell:GridCellVO in gridModel.collection) 
			{
				var tile:TileVO = new TileVO();
				tile.id = cell.id;
				tile.addEventListener(Event.CHANGE, onChange);
				
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
					nextTile.incrementNeighbors();
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
			clearTile(tileVO, cell);
			
			if(tileVO.type == TileVO.TYPE_OPEN)
			{
				floodFill(tileVO, 'type', TileVO.TYPE_OPEN, TileVO.STATE_CLEARED, 'state');
			}
		}
		
		private function onChange(event:Event):void {
			var tileVO:TileVO = event.currentTarget as TileVO
			var cell:GridCellVO = _gridModel.getCellByID(tileVO.id);
			clearTile(tileVO, cell);
		}
		
		private function clearTile(tileVO:TileVO, cell:GridCellVO):void
		{
			tileVO.state == TileVO.STATE_CLEARED;
				
			//blit text
			_textField.text = tileVO.text
			var snapshot:BitmapData = new BitmapData(_textField.width, _textField.height, true, 0x00000000);
			snapshot.draw(_textField, new Matrix() );
			
			//compose to square
			var newData:BitmapData = new BitmapData(_mineModel.tileWidth, _mineModel.tileHeight, false, tileVO.color);
			var rect:Rectangle = new Rectangle(0, 0, _textField.width, _textField.height);
			var aPoint:Point = new Point();
			newData.copyPixels(snapshot, rect, aPoint);
			
			cell.bitmapData = newData; 	
		}
		
		private function getNieghborTile(tile:TileVO, direction:String):TileVO		{
			
			var neighborCell:GridCellVO; 
			var originCell:GridCellVO = _gridModel.getCellByID(tile.id);
			
			switch(direction) {
				case "n":
					neighborCell = _gridModel.getCellToNorthOf(originCell);
				break;
				
				case "s":
					neighborCell = _gridModel.getCellToSouthOf(originCell);
					break;
				
				case "e":
					neighborCell = _gridModel.getCellToEastOf(originCell);
					break;
				case "w":
					neighborCell = _gridModel.getCellToWestOf(originCell);
					break;
			}
			
			if(neighborCell)
			{
				var nextTile:TileVO = _mineModel.getItemByID(neighborCell.id);
				return nextTile;
			} else {
				return null
			}
		}
		
		private var _directions:Array = ['w', 'e', 's', 'n']
		private var _nextTile:TileVO;
		private function floodFill(node:TileVO, currentProperty:String, currentValue:int, replacementValue:int, replacementProperty:String):void
		{
			_nextTile = null;
			
			if(!node)
			{
				return;
			}
			
			if(node[replacementProperty] == replacementValue || node[currentProperty] != currentValue)
			{
				return;
			}
			
			node[replacementProperty] = replacementValue;
			
			for each(var direction:String in _directions) {
				_nextTile = getNieghborTile(node, direction);
				if(_nextTile)
				floodFill(_nextTile, currentProperty, currentValue, replacementValue, replacementProperty);
			}
			
		}
	}
}