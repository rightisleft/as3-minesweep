package com.rightisleft.controllers
{
	import com.rightisleft.events.GameEvent;
	import com.rightisleft.models.GridVOs;
	import com.rightisleft.models.TileVOs;
	import com.rightisleft.views.GridView;
	import com.rightisleft.vos.GridCellVO;
	import com.rightisleft.vos.TileVO;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;


	public class MineSweepController extends EventDispatcher
	{
		//members objects
		private var _tileVOs:TileVOs
		
		private var _gridView:GridView;
		private var _gridVOs:GridVOs;
		
		private var _parent:DisplayObjectContainer;
		private var _tileController:TileController;
		
		public function MineSweepController(parent:DisplayObjectContainer, tileVOs:TileVOs)
		{		
			_tileVOs = tileVOs;
			_parent = parent;
			
			//thise are state change listeners - do not remove since this will add the grid to the stage
			_tileVOs.options.addEventListener(GameEvent.GAME_STATE_EVENT, onGameEvent);
			_tileVOs.addEventListener(GameEvent.GAME_STATE_EVENT, onGameEvent);
		}
		
		//observer pattern would be better
		private function turnOnPlayListeners():void
		{
			_parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_parent.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_gridView.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function turnOffPlayListeners():void
		{			
			_parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_parent.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_gridView.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function init(gridVOs:GridVOs, gridView:GridView):void {
			
			_gridView = gridView;
			_gridVOs = gridVOs;
			
			_tileController = new TileController(_tileVOs);
		}
				
		public function exit():void {
			
			turnOffPlayListeners();
			
			_parent.removeChild(_gridView);
			
			_gridVOs.destroy();	
			_gridView.destroy();			
			_tileVOs.destroy();
		}
		
		public function enter():void {
			
			_gridView.init();

			_gridVOs.init( _tileVOs.options.board.columns, _tileVOs.options.board.rows, _tileVOs.options.board.tileHeight, _tileVOs.options.board.tileWidth)

			_gridView.lock();
			
			//Create & Bind GridCells to Tiles
			for each (var cell:GridCellVO in _gridVOs.collection) 
			{
				var tile:TileVO = new TileVO();
				
				tile.id = cell.id;
				tile.addUpdateHanlder( onBmpd )
				cell.addUpdateHanlder( _gridView.updateCell );
					
				tile.tileWidth = _tileVOs.options.board.tileWidth;
				tile.tileHeight = _tileVOs.options.board.tileHeight;
				
				_tileVOs.collectionOfTiles.push ( tile );
				
				_tileController.painTile(tile);
			}
			
			_gridView.unlock();
			
			//Select Tiles to be hidden mines
			var aTile:TileVO;
			for (var i:int = 0; i < _tileVOs.options.board.mineCount; i++) 
			{
				aTile = _tileVOs.getRandomVO();
				while(aTile.type == TileVO.TYPE_MINE) {
					aTile = _tileVOs.getRandomVO();
				}
				
				aTile.type = TileVO.TYPE_MINE;
				alertNeghborTiles(aTile);
				
				_tileVOs.collectionOfMines.push(aTile); 
			}
			
			
			_parent.addChild(_gridView);
			_parent.stage.focus = _parent.stage
			_gridView.x = (_gridView.stage.stageWidth * .5) - (_gridVOs.gridWidth * .5);
			
			turnOnPlayListeners();
		}
		
		//cheat
		public function showAll():void {
			_gridView.lock();
			for each(var atile:TileVO in _tileVOs.collectionOfTiles)
			{
				atile.state = TileVO.STATE_CLEARED;
				_tileController.painTile(atile);
			}
			_gridView.unlock();
		}
		
		private function showRemainingMines():void
		{
			_gridView.lock();
			for each(var atile:TileVO in _tileVOs.collectionOfMines)
			{
				if(atile.type == TileVO.TYPE_MINE && atile.state != TileVO.STATE_FLAGGED)
				{
					atile.state = TileVO.STATE_EXPLODED;
					_tileController.painTile(atile);
				}
			}
			_gridView.unlock();
		}
		
		private function onBmpd(tileVO:TileVO):void
		{
			var cell:GridCellVO = _gridVOs.getCellByID(tileVO.id);
			cell.bitmapData = tileVO.bmpd;
			cell.updated();
		}
		
		private function alertNeghborTiles(tile:TileVO):void
		{
			var nextCell:GridCellVO; 
			var originCell:GridCellVO = _gridVOs.getCellByID(tile.id);
			
			nextCell = _gridVOs.getCellToNorthOf(originCell)
			incrementDanger(nextCell);
				
			nextCell = _gridVOs.getCellToSouthOf(originCell)
			incrementDanger(nextCell);
				
			nextCell = _gridVOs.getCellToEastOf(originCell)
			incrementDanger(nextCell);
				
			nextCell = _gridVOs.getCellToWestOf(originCell)
			incrementDanger(nextCell);
			
			nextCell = _gridVOs.getCellToNorthWestOf(originCell)
			incrementDanger(nextCell);
			
			nextCell = _gridVOs.getCellToNorthEastOf(originCell)
			incrementDanger(nextCell);
			
			nextCell = _gridVOs.getCellToSouthEastOf(originCell)
			incrementDanger(nextCell);
			
			nextCell = _gridVOs.getCellToSouthWestOf(originCell)
			incrementDanger(nextCell);
		}
		
		private function incrementDanger(cell:GridCellVO):void
		{			
			var nextTile:TileVO;
			if(cell != null)
			{
				nextTile = _tileVOs.getItemByID(cell.id);		
				if(nextTile && nextTile.type != TileVO.TYPE_MINE)
				{
					nextTile.addDangerEdge();
				}
			}
		}
		
		private function onClick(event:MouseEvent):void {
			var cell:GridCellVO = _gridVOs.getCellByLocalCoardinate(event.localX, event.localY);
			var vo:TileVO;

			if(cell) 
			{		
				vo = _tileVOs.getItemByID(cell.id);
			}
			
			if(!vo)
			{
				return;
			}
			
			var oState:int = vo.state
			var oType:int = vo.type
			var nState:int;
			var isToggleFlag:Boolean = _tileVOs.isFlagging;
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
					if(_tileVOs.flagsOnBoard >= _tileVOs.options.board.mineCount) {
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
				_tileVOs.flagsOnBoard++
			}
			
			if(oState == TileVO.STATE_FLAGGED && newState == TileVO.STATE_LIVE)
			{
				_tileVOs.flagsOnBoard--
			}
			
				
			//only flood fill of the exposed tile is of type open
			if(newState)
			{
				if(vo.type == TileVO.TYPE_OPEN && newState == TileVO.STATE_CLEARED) {
					_gridView.lock();
						floodFill(vo, ['type', TileVO.TYPE_OPEN, 'state', TileVO.STATE_LIVE], TileVO.STATE_CLEARED, 'state', _tileController.painTile);
					_gridView.unlock();
				} else {
					vo.state = newState;
					_tileController.painTile(vo);
				}
			}

			_tileController.validateFlags(vo)			
		}
		
		//multi property checking for a boundry fill
		//floodfill
		private var _directions:Array = ['w', 'e', 's', 'n']
		private var _nextTile:TileVO;
		private var _nextCell:GridCellVO;
		
		public function floodFill(node:TileVO, values:Array, replacementValue:int, replacementProperty:String, closure:Function = null):void
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
			if(closure)
			{
				closure(node);	
			}
			
			//check neighbors
			for each(var direction:String in _directions) 
			{
				_nextCell = _gridVOs.getNieghborCellByDirection(node.id, direction)
					
				if(_nextCell)
				{
					_nextTile = _tileVOs.getItemByID(_nextCell.id); 
					if(_nextTile) 
					{
						floodFill(_nextTile, values, replacementValue, replacementProperty, closure);	
					}
				}
			}			
		}
		
		private function onGameEvent(event:GameEvent):void
		{
			switch(event.result)
			{
				case GameEvent.GAME_STATE_PLAYING:
					enter();
					break
				
				case GameEvent.GAME_STATE_YOU_LOST:
				case GameEvent.GAME_STATE_YOU_WON:
					showRemainingMines();
					turnOffPlayListeners();
					_gridView.addEventListener(MouseEvent.CLICK, onGotoLevelMenu);
					break;
				case GameEvent.GAME_STATE_NEW:
					exit();
					break;
			}
		}
		
		private function onGotoLevelMenu(e:MouseEvent):void
		{
			_gridView.removeEventListener(MouseEvent.CLICK, onGotoLevelMenu);
			_tileVOs.newGame();
		}
		
		private function onKeyUp(event:KeyboardEvent):void{
			if (event.keyCode == 16)
			{
				_tileVOs.isFlagging = false
				trace('isflagging false')

			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			//should store depressed keys			
			if (event.keyCode == 16)
			{
				_tileVOs.isFlagging = true
					trace('isflagging true')
			}
			
			//cheat key is c to showall
			if(event.keyCode == 67) {
				showAll();
			}
		}
	}
}