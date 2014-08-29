package com.rightisleft.models
{
	import com.rightisleft.events.GameEvent;
	import com.rightisleft.vos.ContenderVO;
	import com.rightisleft.vos.GridCellVO;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class ContenderModel extends EventDispatcher
	{
		
		public var contenders:Vector.<ContenderVO> = new Vector.<ContenderVO>();
		public var mines:Vector.<ContenderVO> = new Vector.<ContenderVO>();
		public var isFlagging:Boolean = false;
		public var options:GameOptionsModel
		
		private var _state:GameEvent;
		private var _flaggedContenders:int;
		
		public function ContenderModel(mode:GameOptionsModel)
		{				
			options = mode;
			options.addEventListener(GameEvent.EVENT_STATE, onGameOptionEvent);
		}
		
		public var incrementHandlers:Array = []		

		public function generateMines(cell:GridCellVO, closure:Function):void
		{
			//Select contenders to be hidden mines
			var acontender:ContenderVO;
			for (var i:int = 0; i < options.board.mineCount; i++) 
			{
				acontender = getRandomVO();
				
				//cant be a previously placed mine
				//cent be the first selected square
				
				while(acontender.type == ContenderVO.TYPE_MINE) {
					acontender = getRandomVO();
					if(cell && cell.id == acontender.id)
					{
						acontender = getRandomVO();
					}
				}
				
				acontender.type = ContenderVO.TYPE_MINE;
				mines.push(acontender);
				if(closure)
				{
					closure(acontender);
				}
			}
		}
		
		public function getRandomVO():ContenderVO 
		{
			var index:int = int( Math.round( ( Math.random() * (contenders.length - 1) ) ) )
			return contenders[index] as ContenderVO;
		}
		
		private var _hash:Dictionary = new Dictionary();
		public function getVOByID(id:String):ContenderVO
		{
			if(_hash[id]) {
				return _hash[id];
			}
			
			for each(var contender:ContenderVO in contenders)
			{
				_hash[contender.id] = contender;
				if(contender.id == id)
				{
					return contender;
				}
			}
			
			return null;
		}
		
		public function destroy():void 
		{
			for each(var contender:ContenderVO in contenders)
			{
				contender = null;
			}
			
			for each(var mine:ContenderVO in mines)
			{
				mine = null;
			}
			
			_flaggedContenders = 0;
			
			_hash = new Dictionary();	
						
			contenders.length = 0;
			
			mines.length = 0;				
		}

		public function get flaggedContenders():int
		{
			return _flaggedContenders;
		}

		public function set flaggedContenders(value:int):void
		{
			_flaggedContenders = value;
			this.dispatchEvent(new GameEvent(GameEvent.EVENT_DATA, _flaggedContenders) );
		}
		
		public function loseToPlayer():void
		{
			_state = new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_PLAYER_WON);
			this.dispatchEvent( _state );
		}
		
		public function defeatPlayer():void
		{
			_state = new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_CONTENDER_WON);
			this.dispatchEvent( _state );		
		}
		
		public function newGame():void
		{
			_state = new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_NEW);
			this.dispatchEvent( _state );		
		}
		
		public function reset():void
		{
			switch(_state.result)
			{
				case GameEvent.RESULT_PLAYER_WON:
				case GameEvent.RESULT_CONTENDER_WON:
					return; //Cant reset a game you already finished
				break;
				
				default:
					_state = new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_RESTART);
					this.dispatchEvent(new GameEvent(GameEvent.EVENT_STATE, GameEvent.RESULT_RESTART) );
				break;
			}

		}
		
		private function onGameOptionEvent(event:GameEvent):void {
			//redispatch gameoptions to simpify listeners, but maintain object hierarchy
			_state = event;
			this.dispatchEvent(event);
		}
	}
}
