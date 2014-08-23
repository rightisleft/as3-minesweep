package com.rightisleft.vos
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	public class GridCellVO extends EventDispatcher
	{
		private var _coardinate:Point;
		private var _width:int;
		private var _height:int;
		private var _tileValue:int;
		
		public var bitmapData:BitmapData;

		public var array_x_index:int;
		public var array_y_index:int;
		
		
		public function GridCellVO(x:int, y:int, width:int, height:int)
		{
			_coardinate = new Point(x,y);
			_height = height;
			_width = width;
			array_x_index = x;
			array_y_index = y;
		}
		
		public function get x():int {
			return _coardinate.x;
		}
		
		public function get y():int {
			return _coardinate.y;
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}
		
		public function get id():String {
			return "" + x + y;
		}
		
		public function destroy():void
		{
			bitmapData = null;
			this.dispatchEvent(new Event(Event.REMOVED) );
		}
	}
}