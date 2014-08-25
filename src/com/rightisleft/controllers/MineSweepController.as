package com.rightisleft.controllers
{
	import com.rightisleft.models.MineSweepModel;
	import com.rightisleft.views.GridView;
	import com.rightisleft.vos.GridCellVO;
	import com.rightisleft.vos.GridVO;
	import com.rightisleft.vos.TileVO;
	
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class MineSweepController
	{
		//members objects
		private var _mineModel:MineSweepModel
		
		private var _gridView:GridView;
		private var _gridVO:GridVO;
		
		private var _textField:TextField;
		
		//private local performance variables
		private var _textHash:Dictionary = new Dictionary();
		private var _directions:Array = ['w', 'e', 's', 'n']
		private var _nextTile:TileVO;
		private var _bevelFilter:BevelFilter;
		
		public function MineSweepController()
		{
			_textField = new TextField();
			var txtCtrl:GenericTextController = new GenericTextController();
			txtCtrl.setText('', _textField)
			
			_bevelFilter = new BevelFilter();
			_bevelFilter.blurX = 2;
			_bevelFilter.blurY = 2;
			_bevelFilter.strength = .1
		}
		
		public function init(gridModel:GridVO, gridView:GridView, mineModel:MineSweepModel):void {
			
			_mineModel = mineModel;
			_gridView = gridView;
			_gridVO = gridModel;
			
			_gridView.addEventListener(MouseEvent.CLICK, onClick);			
			_gridView.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
			_gridView.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp)
			
			start();
		}
		
		private function start():void {
			
			_gridView.lock();
			for each (var cell:GridCellVO in _gridVO.collection) 
			{
				var tile:TileVO = new TileVO();
				tile.id = cell.id;
				tile.tileWidth = _mineModel.mode.tileWidth;
				tile.tileHeight = _mineModel.mode.tileHeight;
				
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
				
				_mineModel.collectionOfMines.push(aTile);
			}
			
			_gridView.x = (_gridView.stage.stageWidth * .5) - (_gridVO.gridWidth * .5);
		}
		
		public function endGame():void {
			if(_gridVO)
			{
				_gridVO.destroy();	
			}
			
			if(_gridView)
				_gridView.destroy();

			
			if(_mineModel) {
				_mineModel.destroy();	
			}
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
		
		//cheat
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
			var originCell:GridCellVO = _gridVO.getCellByID(tile.id);
			
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
			
			nextCell = _gridVO.getCellToNorthOf(originCell)
			doUpdate(nextCell);
				
			nextCell = _gridVO.getCellToSouthOf(originCell)
			doUpdate(nextCell);
				
			nextCell = _gridVO.getCellToEastOf(originCell)
			doUpdate(nextCell);
				
			nextCell = _gridVO.getCellToWestOf(originCell)
			doUpdate(nextCell);
			
			nextCell = _gridVO.getCellToNorthWestOf(originCell)
			doUpdate(nextCell);
			
			nextCell = _gridVO.getCellToNorthEastOf(originCell)
			doUpdate(nextCell);
			
			nextCell = _gridVO.getCellToSouthEastOf(originCell)
			doUpdate(nextCell);
			
			nextCell = _gridVO.getCellToSouthWestOf(originCell)
			doUpdate(nextCell);
		}
		
		private function onClick(event:MouseEvent):void {
			var cell:GridCellVO = _gridVO.getCellByLocalCoardinate(event.localX, event.localY);
			var vo:TileVO;

			if(cell) 
			{		
				vo = _mineModel.getItemByID(cell.id);
			}
			
			if(!vo)
			{
				return;
			}
			
			var oState:int = vo.state
			var oType:int = vo.type
			var nState:int;
			var isToggleFlag:Boolean = _mineModel.isFlagging;
			var newState:int;
			
			//get state
			
			//flag state
			if(isToggleFlag)
			{
								
				if(oState == TileVO.STATE_FLAGGED)
				{
					
					newState = TileVO.STATE_LIVE;
				}
				
				if(oState == TileVO.STATE_LIVE)
				{
					//enforce max flag count
					if(_mineModel.flagsOnBoard >= _mineModel.mode.mineCount) {
						return;
					}
					
					newState = TileVO.STATE_FLAGGED;
				}
			}
			//clear state
			else if(oState == TileVO.STATE_LIVE)
			{
				if(oState == TileVO.STATE_FLAGGED)
				{
					newState = 0;
				}
				
				if(oType == TileVO.TYPE_MINE)
				{
					newState = TileVO.STATE_EXPLODED;
				}
				
				if(oType == TileVO.TYPE_OPEN)
				{
					newState = TileVO.STATE_CLEARED;
				}
				
				if(oType == TileVO.TYPE_RISKY)
				{
					newState = TileVO.STATE_CLEARED;
				}
			}
			
			if(newState == TileVO.STATE_FLAGGED)
			{
				_mineModel.flagsOnBoard++
			}
			
			if(oState == TileVO.STATE_FLAGGED && newState == TileVO.STATE_LIVE)
			{
				_mineModel.flagsOnBoard--
			}
			
				
			//only flood fill of the exposed tile is of type open
			if(newState)
			{
				if(vo.type == TileVO.TYPE_OPEN && newState == TileVO.STATE_CLEARED) {
					_gridView.lock();
						floodFill(vo, ['type', TileVO.TYPE_OPEN, 'state', TileVO.STATE_LIVE], TileVO.STATE_CLEARED, 'state', paintTile);
					_gridView.unlock();
				} else {
					vo.state = newState;
					paintTile(vo);
				}
			}

			validateFlags(vo)			
		}
		
		private function validateFlags(tileVO:TileVO):void {
			
			if(tileVO && tileVO.type == TileVO.TYPE_MINE && tileVO.state == TileVO.STATE_EXPLODED)
			{
				_mineModel.setGameState(MineSweepModel.GAME_STATE_YOU_LOST);
				return;
			}
			
			var isAMineStillActive:Boolean = false; //could increment a count instead of looping - insignificant performance at this stage
			
			for each(var tile:TileVO in _mineModel.collectionOfMines)
			{
				if(tile.state != TileVO.STATE_FLAGGED)
				{
					isAMineStillActive = true;
					break;
				}
			}
			
			if(isAMineStillActive == false)
			{
				_mineModel.setGameState(MineSweepModel.GAME_STATE_YOU_WON);
			}
		}
			
		//Todo: move to TileVO getUpdatedBitmapData()
		
		private function paintTile(tileVO:TileVO):void
		{				
			var cell:GridCellVO = _gridVO.getCellByID(tileVO.id);

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
			var tileBitmapData:BitmapData = new BitmapData(tileVO.tileWidth, tileVO.tileHeight, true, tileVO.color);

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
		
		//Todo: do we need a TileController to manage tvos?
		private function getNieghborTile(tile:TileVO, direction:String):TileVO		
		{
	
			var neighborCell:GridCellVO; 
			var originCell:GridCellVO = _gridVO.getCellByID(tile.id);
			
			switch(direction) {
				case "n":
					neighborCell = _gridVO.getCellToNorthOf(originCell);
				break;
				
				case "s":
					neighborCell = _gridVO.getCellToSouthOf(originCell);
					break;
				
				case "e":
					neighborCell = _gridVO.getCellToEastOf(originCell);
					break;
				case "w":
					neighborCell = _gridVO.getCellToWestOf(originCell);
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
		
		//multi property checking for a boundry fill
		private function floodFill(node:TileVO, values:Array, replacementValue:int, replacementProperty:String, closure:Function):void
		{
			_nextTile = null;
			
			
			//multi property checking
			
			var index:int
			while(index < values.length)
			{
				var currentProperty:String = values[index++]
				var currentValue:int = values[index++]
					
				//exit function if netxt-node is already painted, exit of first node doesnt match
				if(!node || node[replacementProperty] == replacementValue || node[currentProperty] != currentValue)
				{
					return;
				}
			}
			
			//set value  & render
			
			node[replacementProperty] = replacementValue;
			closure(node);
			
			//check neighbors
			for each(var direction:String in _directions) 
			{
				_nextTile = getNieghborTile(node, direction);
				
				if(_nextTile) 
				{
					floodFill(_nextTile, values, replacementValue, replacementProperty, closure);	
				}
			}			
		}
	}
}