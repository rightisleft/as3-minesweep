package com.rightisleft.vos
{
	

	public class TileVO
	{
		public static const TYPE_OPEN:int = 0;
		public static const TYPE_MINE:int = 1;
		public static const TYPE_ADJACENT_ONE:int = 2;
		public static const TYPE_ADJACENT_TWO:int = 3;
		public static const TYPE_ADJACENT_THREE:int = 4;
		public static const TYPE_ADJACENT_FOUR:int = 5;
		public static const TYPE_ADJACENT_FIVE:int = 6;
		public static const TYPE_ADJACENT_SIZ:int = 7;
		public static const TYPE_ADJACENT_SEVEN:int = 8;
		public static const TYPE_ADJACENT_EIGHT:int = 9;
		
		public static const STATE_LIVE:int = 0;
		public static const STATE_SPENT:int = 1;
		public static const STATE_CLEARED:int = 2;
		
		public var type:int = -1;
		public var state:int;
		public var id:String;
		public var danger_edges:int;
		
		public function TileVO()
		{
			type = TYPE_OPEN;
			state = STATE_LIVE;
		}
		
		public function incrementNeighbors():void
		{
			danger_edges++;
		}
		
		public function printDangerEdges():void {
			trace('danger_edges:' + danger_edges);
		}
		
	}
}