package com.rightisleft.vos
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class ContenderVO extends EventDispatcher
	{
		
		public static const STATE_LIVE:int = 1;
		public static const STATE_CLEARED:int = 2;
		public static const STATE_FLAGGED:int = 3;
		public static const STATE_EXPLODED:int = 4;
		
		public static const TYPE_OPEN:int = 0;
		public static const TYPE_MINE:int = 1;
		public static const TYPE_RISKY:int = 2;
		
		public var width:int;
		public var height:int;
		
		public var type:int = -1;
		public var id:String;
		public var danger_edges:int;
		public var bmpd:BitmapData;
		
		private var _state:int;
		
		public function ContenderVO()
		{
			type = TYPE_OPEN;
			state = STATE_LIVE;
		}
		
		public function addDangerEdge():void
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
				return 'F';
			}
			
			if(type == ContenderVO.TYPE_MINE)
			{
				return "M"
			} 
			
			if (danger_edges > 0) {
				return danger_edges.toString();
			}
			
			return '';
		}
		
		public function get color():uint {
			
			if(state == STATE_LIVE) {
				return ContenderColors.GRAY;
			}
			
			if(state == STATE_FLAGGED) {
				return ContenderColors.BLUE;
			}
			
			if(type == ContenderVO.TYPE_MINE)
			{
				return ContenderColors.RED;
			} 
			
			if (danger_edges > 0) {
				return ContenderColors.YELLOW;
			}
			
			return ContenderColors.GREEN;
		}

		public function get state():int
		{
			return _state;
		}
		
		public function set state(value:int):void
		{			
			_state = value;
		}
		
		public function destroy():void
		{
			_updateHandlers.length = 0;
			_updateHandlers = [];
		}
		
		public function updated():void 
		{
			for each(var closure:Function in _updateHandlers)
			{
				if(closure)
				{
					closure(this);
				}
			}
		}
		
		private var _updateHandlers:Array = [];
		public function addUpdateHanlder(value:Function):void
		{
			_updateHandlers.push(value);
		}
	}
}
class ContenderColors {
	public static const GREEN:uint = 0xFF336600;
	public static const YELLOW:uint = 0xFFFFC809;
	public static const RED:uint = 0xFFF80000;
	public static const BLUE:uint = 0xFF0000FF;
	public static const GRAY:uint = 0xFFCCCCCC;
}