

package com.rightisleft.events
{
	import flash.events.Event;
	
	public class GridEvent extends Event
	{
		public static const CELL_CLICKED:String = "grid_cell_clicked";
		
		public var result:Object;
		
		public function GridEvent(type:String, result:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.result = result;
		}
		
		public override function clone():Event
		{
			return new GridEvent(type, result, bubbles, cancelable);
		}
	}
}

