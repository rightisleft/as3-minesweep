package com.rightisleft.controllers
{
	import com.rightisleft.models.MineSweepModel;
	import com.rightisleft.views.GridView;
	import com.rightisleft.vos.GridCellVO;
	import com.rightisleft.vos.GridVO;
	import com.rightisleft.vos.TileVO;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class MineSweepController
	{
		//members objects
		private var _view:Sprite = new Sprite;
		private var _mineModel:MineSweepModel
		
		private var _gridView:GridView;
		private var _gridModel:GridVO;
		
		private var _textField:TextField;
		
		//private local performance variables
		private var _textHash:Dictionary = new Dictionary();
		private var _directions:Array = ['w', 'e', 's', 'n']
		private var _nextTile:TileVO;
		private var _bevelFilter:BevelFilter;
		
		public function MineSweepController()
		{
			_textField = new TextField();
			
			var format:TextFormat = new TextFormat('Verdana', null, 0x000000, true);
			_textField.defaultTextFormat = format;
			_textField.antiAliasType = 'advanced'; 
			
			_bevelFilter = new BevelFilter();
			_bevelFilter.blurX = 2;
			_bevelFilter.blurY = 2;
			_bevelFilter.strength = .1
		}
		
		public function init(gridModel:GridVO, gridView:GridView, mineModel:MineSweepModel):void {
			
			_mineModel = mineModel;
			_gridView = gridView;
			_gridModel = gridModel;
			
			_gridView.addEventListener(MouseEvent.CLICK, onClick);			
			_gridView.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
			_gridView.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp)
			
			start();
		}
		
		private function start():void {
			
			_gridView.lock();
			for each (var cell:GridCellVO in _gridModel.collection) 
			{
				var tile:TileVO = new TileVO();
				tile.id = cell.id;
				
				_mineModel.collectionOfTiles.push ( tile );
				paintTile(tile);
			}
			
			_gridView.unlock();
			
			//set titles to be mines
			var aTile:TileVO;
			for (var i:int = 0; i < _mineModel.mode.mineCount; i++) 
			{
				aTile = _mineModel.getRandomVO();
				while(aTile.type == TileVO.TYPE_MINE) {
					aTile = _mineModel.getRandomVO();
				}
				
				aTile.type = TileVO.TYPE_MINE;
				alertNeghborTiles(aTile);
			}
		}
		
		public function endGame():void {			
			_gridModel.destroy();
			_mineModel.destroy();
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			//should store depressed keys
			if (event.keyCode == 16)
			{
				_mineModel.isFlagging = true
			}
			
			//cheat key is c to showall
			if(event.keyCode == 67) {
				showAll();
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void 
		{
			if (event.keyCode == 16)
			{
				_mineModel.isFlagging = false
			}
		}
		
		public function showAll():void {
			_gridView.lock();
			for each(var atile:TileVO in _mineModel.collectionOfTiles)
			{
				atile.state = TileVO.STATE_CLEARED;
				paintTile(atile);
			}
			_gridView.unlock();
		}
		
		private function alertNeghborTiles(tile:TileVO):void
		{
			var nextCell:GridCellVO; 
			var originCell:GridCellVO = _gridModel.getCellByID(tile.id);
			var nextTile:TileVO;
			var doUpdate:Function = function (cell:GridCellVO):void
			{			
				if(cell != null)
				{
					nextTile = _mineModel.getItemByID(cell.id);		
					if(nextTile.type != TileVO.TYPE_MINE)
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
			
			if(cell) 
			{			
				var tileVO:TileVO = _mineModel.getItemByID(cell.id);
				if(!_mineModel.isFlagging) 
				{
					if(tileVO.type == TileVO.TYPE_OPEN) {
						_gridView.lock();
						floodFill(tileVO, 'type', TileVO.TYPE_OPEN, TileVO.STATE_CLEARED, 'state', paintTile);
						_gridView.unlock();
					} else {
						tileVO.state = TileVO.STATE_CLEARED;
						paintTile(tileVO);
					}
				} else 
				{
					tileVO.state = TileVO.STATE_FLAGGED;
					paintTile(tileVO);
				}
			}
			
		}
				
		private function paintTile(tileVO:TileVO):void
		{				
			var cell:GridCellVO = _gridModel.getCellByID(tileVO.id);

			//blit text
			var textValue:String = tileVO.text;
			var snapshot:BitmapData;
			
			//check if bitmapdata is cached so we dont have to draw a bunch of repeated text fields
			if(textValue.length) {
				if(_textHash[textValue]) {
					snapshot = _textHash[textValue]; //cached
				} else {
					_textField.text = textValue; 
					
					snapshot = new BitmapData(_textField.width, _textField.height, true, 0x00FFFFFF);
					snapshot.draw(_textField, new Matrix() );
					_textHash[textValue] = snapshot;
				}
			}

			//new fill
			var tileBitmapData:BitmapData = new BitmapData(_mineModel.mode.tileWidth, _mineModel.mode.tileHeight, true, tileVO.color);

			//compose text onto square
			if(snapshot) {
				var rect:Rectangle = new Rectangle(0, 0, _textField.width, _textField.height);
				var aPoint:Point = new Point();
				tileBitmapData.copyPixels(snapshot, rect, aPoint, null, null, true);	
			}
			
			//Apply Tile Bevel
			var bevelRect:Rectangle = new Rectangle(0,0, tileBitmapData.width,tileBitmapData.height)
			_bevelFilter.quality = BitmapFilterQuality.HIGH;
			tileBitmapData.applyFilter(tileBitmapData,bevelRect,new Point(0,0), _bevelFilter);
			
			cell.bitmapData = tileBitmapData;
			_gridView.updateCell(cell);
		}
		
		private function getNieghborTile(tile:TileVO, direction:String):TileVO		
		{
	
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
		
		private function floodFill(node:TileVO, currentProperty:String, currentValue:int, replacementValue:int, replacementProperty:String, closure:Function):void
		{
			_nextTile = null;
			
			//exit if netxt-node is already painted, exit of first node doesnt match
			if(!node || node[replacementProperty] == replacementValue || node[currentProperty] != currentValue)
			{
				return;
			}
			
			node[replacementProperty] = replacementValue;
			closure(node);
			
			//paint neighbors
			for each(var direction:String in _directions) 
			{
				_nextTile = getNieghborTile(node, direction);
				
				if(_nextTile) 
				{
					floodFill(_nextTile, currentProperty, currentValue, replacementValue, replacementProperty, closure);	
				}
			}			
		}
	}
}