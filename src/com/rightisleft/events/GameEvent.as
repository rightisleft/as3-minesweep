package com.rightisleft.events
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const GAME_STATE_EVENT:String = "game_state";
		public static const GAME_DATA_EVENT_FLAGS:String = "game_data_flags";
		
		public static const GAME_STATE_NEW:String = 'new';
		public static const GAME_STATE_PLAYING:String = 'play';
		public static const GAME_STATE_YOU_LOST:String = 'you lost';
		public static const GAME_STATE_YOU_WON:String = 'you won';
		
		public static const GAME_DATA_ARRAY:Array = [GAME_STATE_NEW, GAME_STATE_PLAYING, GAME_STATE_YOU_LOST, GAME_STATE_YOU_WON]
		
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