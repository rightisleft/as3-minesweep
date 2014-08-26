package com.rightisleft.events
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const GAME_STATE_EVENT:String = "game_state";
		public static const GAME_DATA_EVENT_FLAGS:String = "game_data_flags";
		
		public static const GAME_STATE_NEW:String = 'New!';
		public static const GAME_STATE_PLAYING:String = 'Play!';
		public static const GAME_STATE_YOU_LOST:String = 'You Lost!';
		public static const GAME_STATE_YOU_WON:String = 'You Won!';
		public static const GAME_STATE_RESTART:String = 'restart!';
				
		public var result:Object;
		
		public function GameEvent(type:String, result:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.result = result;
		}
		
		public override function clone():Event
		{
			return new GameEvent(type, result, bubbles, cancelable);
		}
	}
}