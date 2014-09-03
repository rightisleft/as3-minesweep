package com.rightisleft.controllers
{
	import com.rightisleft.events.GameEvent;
	import com.rightisleft.events.GridEvent;
	import com.rightisleft.models.ContenderModel;
	import com.rightisleft.models.GridModel;
	import com.rightisleft.vos.ContenderVO;
	import com.rightisleft.vos.GridCellVO;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;


	public class MineSweepController
	{
		//members objects
		private var _contenderModel:ContenderModel
		
		private var _gridController:GridController;
		private var _gridModel:GridModel;
		
		private var _parent:DisplayObjectContainer;
		private var _contenderController:ContenderController;
		
		public function MineSweepController(parent:DisplayObjectContainer, cmodel:ContenderModel)
		{		
			_contenderModel = cmodel;
			_parent = parent;
			
			//this isa state change listeners - do not remove since this will add the grid to the stage
			_contenderModel.addEventListener(GameEvent.EVENT_STATE, onGameEvent);
		}
		
		//observer pattern would be better
		private function turnOnPlayListeners():void
		{
			_parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_parent.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_gridModel.addEventListener(GridEvent.CELL_CLICKED, onClick);
		}
		
		private function turnOffPlayListeners():void
		{			
			_parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_parent.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_gridModel.removeEventListener(GridEvent.CELL_CLICKED, onClick);
		}
		
		public function init(gridModel:GridModel, gridController:GridController):void {
			
			_gridController = gridController;
			_gridModel = gridModel;
			
			_contenderController = new ContenderController();
			_contenderController.init(_contenderModel);
		}
				
		public function exit():void {
			
			turnOffPlayListeners();
						
			_gridModel.destroy();	
			_gridController.destroy();			
			_contenderModel.destroy();
		}
		
		public function enter():void {
			

			_gridModel.init( _contenderModel.options.board.columns, _contenderModel.options.board.rows, _contenderModel.options.board.height, _contenderModel.options.board.width)

			_gridController.init(_gridModel);

			_gridController.lock();
			
			//Create & Bind GridCells to contenders
			for each (var cell:GridCellVO in _gridModel.collection) 
			{
				var contender:ContenderVO = new ContenderVO();
				
				contender.id = cell.id;
				contender.addUpdateHanlder( onBmpd )
				cell.addUpdateHanlder( _gridController.updateCell );
					
				contender.width = _contenderModel.options.board.width;
				contender.height = _contenderModel.options.board.height;
				
				_contenderModel.contenders.push ( contender );
				
				_contenderController.paint(contender);
			}
			
			_gridController.unlock();
					
			_parent.stage.focus = _parent.stage

			
			turnOnPlayListeners();
		}
		
		//cheat
		public function showAll():void {
			_gridController.lock();
			for each(var acontender:ContenderVO in _contenderModel.contenders)
			{
				acontender.state = ContenderVO.STATE_CLEARED;
				_contenderController.paint(acontender);
			}
			_gridController.unlock();
		}
		
		private function showRemainingMines():void
		{
			_gridController.lock();
			for each(var acontender:ContenderVO in _contenderModel.mines)
			{
				if(acontender.type == ContenderVO.TYPE_MINE && acontender.state != ContenderVO.STATE_FLAGGED)
				{
					acontender.state = ContenderVO.STATE_EXPLODED;
					_contenderController.paint(acontender);
				}
			}
			_gridController.unlock();
		}
		
		private function onBmpd(contenderVO:ContenderVO):void
		{
			var cell:GridCellVO = _gridModel.getCellByID(contenderVO.id);
			cell.bitmapData = contenderVO.bmpd;
			cell.updated();
		}
		
		private function alertNeighbors(contender:ContenderVO):void
		{
			var nextCell:GridCellVO; 
			var originCell:GridCellVO = _gridModel.getCellByID(contender.id);
			
			nextCell = _gridModel.getCellToNorthOf(originCell)
			incrementDanger(nextCell);
				
			nextCell = _gridModel.getCellToSouthOf(originCell)
			incrementDanger(nextCell);
				
			nextCell = _gridModel.getCellToEastOf(originCell)
			incrementDanger(nextCell);
				
			nextCell = _gridModel.getCellToWestOf(originCell)
			incrementDanger(nextCell);
			
			nextCell = _gridModel.getCellToNorthWestOf(originCell)
			incrementDanger(nextCell);
			
			nextCell = _gridModel.getCellToNorthEastOf(originCell)
			incrementDanger(nextCell);
			
			nextCell = _gridModel.getCellToSouthEastOf(originCell)
			incrementDanger(nextCell);
			
			nextCell = _gridModel.getCellToSouthWestOf(originCell)
			incrementDanger(nextCell);
		}
		
		private function incrementDanger(cell:GridCellVO):void
		{			
			var nextcontender:ContenderVO;
			if(cell != null)
			{
				nextcontender = _contenderModel.getVOByID(cell.id);		
				if(nextcontender && nextcontender.type != ContenderVO.TYPE_MINE)
				{
					nextcontender.addDangerEdge();
				}
			}
		}
		
		private function onClick(event:GridEvent):void 
		{
			var clickedCell:GridCellVO = event.result as GridCellVO;
			validateBoardMines(clickedCell)			
			toggleContender(clickedCell);
		}
		
		private function validateBoardMines(clickedCell:GridCellVO):void
		{
			//is new board? 
			if(_contenderModel.mines.length != _contenderModel.options.board.mineCount)
			{
				_contenderModel.generateMines(clickedCell, alertNeighbors);
			}
		}
		
		private function toggleContender(clickedCell:GridCellVO):void
		{
			var cvo:ContenderVO;
			
			if(clickedCell) 
			{		
				cvo = _contenderModel.getVOByID(clickedCell.id);
			}
			
			if(!cvo)
			{
				return;
			}
			
			var oState:int = cvo.state
			var oType:int = cvo.type
			var nState:int;
			var isToggleFlag:Boolean = _contenderModel.isFlagging;
			var newState:int;
			
			//get state
			
			//flag state
			if(isToggleFlag)
			{
				
				if(oState == ContenderVO.STATE_FLAGGED)
				{
					
					newState = ContenderVO.STATE_LIVE;
				}
				
				if(oState == ContenderVO.STATE_LIVE)
				{
					//enforce max flag count
					if(_contenderModel.flaggedContenders >= _contenderModel.options.board.mineCount) {
						return;
					}
					
					newState = ContenderVO.STATE_FLAGGED;
				}
			}
				//clear state
			else if(oState == ContenderVO.STATE_LIVE)
			{
				if(oState == ContenderVO.STATE_FLAGGED)
				{
					newState = 0;
				}
				
				if(oType == ContenderVO.TYPE_MINE)
				{
					newState = ContenderVO.STATE_EXPLODED;
				}
				
				if(oType == ContenderVO.TYPE_OPEN)
				{
					newState = ContenderVO.STATE_CLEARED;
				}
				
				if(oType == ContenderVO.TYPE_RISKY)
				{
					newState = ContenderVO.STATE_CLEARED;
				}
			}
			
			if(newState == ContenderVO.STATE_FLAGGED)
			{
				_contenderModel.flaggedContenders++
			}
			
			if(oState == ContenderVO.STATE_FLAGGED && newState == ContenderVO.STATE_LIVE)
			{
				_contenderModel.flaggedContenders--
			}
			
			
			//only flood fill of the exposed contender is of type open
			if(newState)
			{
				if(cvo.type == ContenderVO.TYPE_OPEN && newState == ContenderVO.STATE_CLEARED) {
					_gridController.lock();
						clearOpenFlood(cvo, _contenderController.paint);
					_gridController.unlock();
				} else {
					cvo.state = newState;
					_contenderController.paint(cvo);
				}
			}
			
			_contenderController.checkFlags(cvo)	
		}
		
		//multi property checking for a boundry fill
		//floodfill
		private var _directions:Array = ['w', 'e', 's', 'n']
		private var _nextcontender:ContenderVO;
		private var _nextCell:GridCellVO;
		
		public function clearOpenFlood(node:ContenderVO, closure:Function = null):void
		{
			_nextcontender = null;
			var canContinue:Boolean = false;
			if(node.type != ContenderVO.TYPE_MINE && node.state == ContenderVO.STATE_LIVE)
			{
				node.state = ContenderVO.STATE_CLEARED
				canContinue = (node.type != ContenderVO.TYPE_RISKY); //we want to show the 4 non-mine corners of an open tile
			}

			if(closure)
			{
				closure(node);	
			}
			
			//check neighbors
			if(canContinue)
			{
				for each(var direction:String in _directions) 
				{
					_nextCell = _gridModel.getNieghborCellByDirection(node.id, direction)
					
					if(_nextCell)
					{
						_nextcontender = _contenderModel.getVOByID(_nextCell.id); 
						if(_nextcontender) 
						{
							clearOpenFlood(_nextcontender, closure);	
						}
					}
				}		
			}
		}
		
		private function onGameEvent(event:GameEvent):void
		{
			switch(event.result)
			{
				case GameEvent.RESULT_PLAYING:
					enter();
					break
				
				case GameEvent.RESULT_CONTENDER_WON:
				case GameEvent.RESULT_PLAYER_WON:
					showRemainingMines();
					turnOffPlayListeners();
					_gridModel.addEventListener(GridEvent.CELL_CLICKED, onGotoLevelMenu);
					break;
				case GameEvent.RESULT_NEW:
					exit();
					break;
				case GameEvent.RESULT_RESTART:
					exit();
					enter();
					break;
			}
		}
		
		private function onGotoLevelMenu(e:GridEvent):void
		{
			_gridModel.removeEventListener(GridEvent.CELL_CLICKED, onGotoLevelMenu);
			_contenderModel.newGame();
		}
		
		private function onKeyUp(event:KeyboardEvent):void{
			if (event.keyCode == 16)
			{
				_contenderModel.isFlagging = false
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			//should store depressed keys			
			if (event.keyCode == 16)
			{
				_contenderModel.isFlagging = true
			}
			
			//cheat key is c to showall
			if(event.keyCode == 67) {
				showAll();
			}
		}
	}
}