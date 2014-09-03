package com.rightisleft.events
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const EVENT_STATE:String = "game_state";
		public static const EVENT_DATA:String = "game_data";
		
		public static const RESULT_NEW:String = 'New!';
		public static const RESULT_PLAYING:String = 'Play!';
		public static const RESULT_CONTENDER_WON:String = 'You Lost!';
		public static const RESULT_PLAYER_WON:String = 'You Won!';
		public static const RESULT_RESTART:String = 'restart!';
		
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