package com.rightisleft.vos
{
	
	public class TileVO
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
		
		
		//Todo: should be set
		public function get text():String {
			if(state == STATE_LIVE) {
				return '';
			}
			
			if(state == STATE_FLAGGED)
			{
				return 'Flagged!';
			}
			
			if(type == TileVO.TYPE_MINE)
			{
				return "Mine!"
			} 
			
			if (danger_edges > 0) {
				return danger_edges.toString();
			}
			
			return '';
		}
		
		public function get color():uint {
			
			if(state == STATE_LIVE) {
				return TileColors.GRAY;
			}
			
			if(state == STATE_FLAGGED) {
				return TileColors.BLUE;
			}
			
			if(type == TileVO.TYPE_MINE)
			{
				return TileColors.RED;
			} 
			
			if (danger_edges > 0) {
				return TileColors.YELLOW;
			}
			
			return TileColors.GREEN;
		}

		public function get state():int
		{
			return _state;
		}
		
		public function set state(value:int):void
		{			
			_state = value;
		}
		
	}
}

class TileColors {
	public static const GREEN:uint = 0xFF336600;
	public static const YELLOW:uint = 0xFFFFC809;
	public static const RED:uint = 0xFFF80000;
	public static const BLUE:uint = 0xFF0000FF;
	public static const GRAY:uint = 0xFFCCCCCC;
}