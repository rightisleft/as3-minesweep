package com.rightisleft.vos
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	

	public class TileVO extends EventDispatcher
	{
		
		public static const STATE_LIVE:int = 0;
		public static const STATE_CLEARED:int = 1;
		public static const STATE_FLAGGED:int = 2;
		
		
		public static const TYPE_OPEN:int = 0;
		public static const TYPE_MINE:int = 1;
		public static const TYPE_RISKY:int = 2;
		

		
		public var type:int = -1;
		private var _state:int;
		public var id:String;
		public var danger_edges:int;
		
		public function TileVO()
		{
			type = TYPE_OPEN;
			state = STATE_LIVE;
		}
		
		public function incrementNeighbors():void
		{
			type = TYPE_RISKY;
			danger_edges++;
		}
		
		public function get text():String {
			if(state == STATE_FLAGGED)
			{
				return 'Flagged!';
			}
			if(type == TileVO.TYPE_MINE)
			{
				return "Mine!"
			} else if (danger_edges > 0) {
				return danger_edges.toString();
			} else {
				return "";
			}
		}
		
		public function get color():uint {
			if(state == STATE_FLAGGED) {
				return 0xFF0000FF;
			}
			if(type == TileVO.TYPE_MINE)
			{
				return 0xFFF80000;
			} else if (danger_edges > 0) {
				return 0xFFFFC809;
			} else {
				return 0xFF336600;
			}
		}

		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			_state = value;
			dispatchEvent(new Event(Event.CHANGE) );
		}
		
	}
}