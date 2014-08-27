package com.rightisleft.controllers
{
	import com.rightisleft.events.GameEvent;
	import com.rightisleft.models.GridVOs;
	import com.rightisleft.models.ContenderVOs;
	import com.rightisleft.views.GridView;
	import com.rightisleft.vos.GridCellVO;
	import com.rightisleft.vos.ContenderVO;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;


	public class MineSweepController extends EventDispatcher
	{
		//members objects
		private var _contenderVOs:ContenderVOs
		
		private var _gridView:GridView;
		private var _gridVOs:GridVOs;
		
		private var _parent:DisplayObjectContainer;
		private var _contenderController:ContenderController;
		
		public function MineSweepController(parent:DisplayObjectContainer, cvos:ContenderVOs)
		{		
			_contenderVOs = cvos;
			_parent = parent;
			
			//thise are state change listeners - do not remove since this will add the grid to the stage
			_contenderVOs.addEventListener(GameEvent.EVENT_STATE, onGameEvent);
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
			
			_contenderController = new ContenderController(_contenderVOs);
		}
				
		public function exit():void {
			
			turnOffPlayListeners();
			
			_parent.removeChild(_gridView);
			
			_gridVOs.destroy();	
			_gridView.destroy();			
			_contenderVOs.destroy();
		}
		
		public function enter():void {
			
			_gridView.init();

			_gridVOs.init( _contenderVOs.options.board.columns, _contenderVOs.options.board.rows, _contenderVOs.options.board.height, _contenderVOs.options.board.width)

			_gridView.lock();
			
			//Create & Bind GridCells to contenders
			for each (var cell:GridCellVO in _gridVOs.collection) 
			{
				var contender:ContenderVO = new ContenderVO();
				
				contender.id = cell.id;
				contender.addUpdateHanlder( onBmpd )
				cell.addUpdateHanlder( _gridView.updateCell );
					
				contender.width = _contenderVOs.options.board.width;
				contender.height = _contenderVOs.options.board.height;
				
				_contenderVOs.collectionOfContenders.push ( contender );
				
				_contenderController.paint(contender);
			}
			
			_gridView.unlock();
			
			//Select contenders to be hidden mines
			var acontender:ContenderVO;
			for (var i:int = 0; i < _contenderVOs.options.board.mineCount; i++) 
			{
				acontender = _contenderVOs.getRandomVO();
				while(acontender.type == ContenderVO.TYPE_MINE) {
					acontender = _contenderVOs.getRandomVO();
				}
				
				acontender.type = ContenderVO.TYPE_MINE;
				alertNeghborcontenders(acontender);
				
				_contenderVOs.collectionOfMines.push(acontender); 
			}
			
			
			_parent.addChild(_gridView);
			_parent.stage.focus = _parent.stage
			_gridView.x = (_gridView.stage.stageWidth * .5) - (_gridVOs.gridWidth * .5);
			
			turnOnPlayListeners();
		}
		
		//cheat
		public function showAll():void {
			_gridView.lock();
			for each(var acontender:ContenderVO in _contenderVOs.collectionOfContenders)
			{
				acontender.state = ContenderVO.STATE_CLEARED;
				_contenderController.paint(acontender);
			}
			_gridView.unlock();
		}
		
		private function showRemainingMines():void
		{
			_gridView.lock();
			for each(var acontender:ContenderVO in _contenderVOs.collectionOfMines)
			{
				if(acontender.type == ContenderVO.TYPE_MINE && acontender.state != ContenderVO.STATE_FLAGGED)
				{
					acontender.state = ContenderVO.STATE_EXPLODED;
					_contenderController.paint(acontender);
				}
			}
			_gridView.unlock();
		}
		
		private function onBmpd(contenderVO:ContenderVO):void
		{
			var cell:GridCellVO = _gridVOs.getCellByID(contenderVO.id);
			cell.bitmapData = contenderVO.bmpd;
			cell.updated();
		}
		
		private function alertNeghborcontenders(contender:ContenderVO):void
		{
			var nextCell:GridCellVO; 
			var originCell:GridCellVO = _gridVOs.getCellByID(contender.id);
			
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
			var nextcontender:ContenderVO;
			if(cell != null)
			{
				nextcontender = _contenderVOs.getVOByID(cell.id);		
				if(nextcontender && nextcontender.type != ContenderVO.TYPE_MINE)
				{
					nextcontender.addDangerEdge();
				}
			}
		}
		
		private function onClick(event:MouseEvent):void {
			var cell:GridCellVO = _gridVOs.getCellByLocalCoardinate(event.localX, event.localY);
			var vo:ContenderVO;

			if(cell) 
			{		
				vo = _contenderVOs.getVOByID(cell.id);
			}
			
			if(!vo)
			{
				return;
			}
			
			var oState:int = vo.state
			var oType:int = vo.type
			var nState:int;
			var isToggleFlag:Boolean = _contenderVOs.isFlagging;
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
					if(_contenderVOs.flaggedContenders >= _contenderVOs.options.board.mineCount) {
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
				_contenderVOs.flaggedContenders++
			}
			
			if(oState == ContenderVO.STATE_FLAGGED && newState == ContenderVO.STATE_LIVE)
			{
				_contenderVOs.flaggedContenders--
			}
			
				
			//only flood fill of the exposed contender is of type open
			if(newState)
			{
				if(vo.type == ContenderVO.TYPE_OPEN && newState == ContenderVO.STATE_CLEARED) {
					_gridView.lock();
						floodFill(vo, ['type', ContenderVO.TYPE_OPEN, 'state', ContenderVO.STATE_LIVE], ContenderVO.STATE_CLEARED, 'state', _contenderController.paint);
					_gridView.unlock();
				} else {
					vo.state = newState;
					_contenderController.paint(vo);
				}
			}

			_contenderController.checkFlags(vo)			
		}
		
		//multi property checking for a boundry fill
		//floodfill
		private var _directions:Array = ['w', 'e', 's', 'n']
		private var _nextcontender:ContenderVO;
		private var _nextCell:GridCellVO;
		
		public function floodFill(node:ContenderVO, values:Array, replacementValue:int, replacementProperty:String, closure:Function = null):void
		{
			_nextcontender = null;
			
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
					_nextcontender = _contenderVOs.getVOByID(_nextCell.id); 
					if(_nextcontender) 
					{
						floodFill(_nextcontender, values, replacementValue, replacementProperty, closure);	
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
				
				case GameEvent.RESULT_LOST:
				case GameEvent.RESULT_WON:
					showRemainingMines();
					turnOffPlayListeners();
					_gridView.addEventListener(MouseEvent.CLICK, onGotoLevelMenu);
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
		
		private function onGotoLevelMenu(e:MouseEvent):void
		{
			_gridView.removeEventListener(MouseEvent.CLICK, onGotoLevelMenu);
			_contenderVOs.newGame();
		}
		
		private function onKeyUp(event:KeyboardEvent):void{
			if (event.keyCode == 16)
			{
				_contenderVOs.isFlagging = false
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			//should store depressed keys			
			if (event.keyCode == 16)
			{
				_contenderVOs.isFlagging = true
			}
			
			//cheat key is c to showall
			if(event.keyCode == 67) {
				showAll();
			}
		}
	}
}