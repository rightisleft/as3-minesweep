package com.rightisleft.controllers
{
	import com.rightisleft.events.GameEvent;
	import com.rightisleft.models.GameOptionsVOs;
	import com.rightisleft.models.TileVOs;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;	

	public class GameViewController
	{
		private var _delays:Dictionary = new Dictionary();
		private var _controllers:Dictionary = new Dictionary();
		private var _gameState:String;
		private var _tileVOs:TileVOs;
		private var _parent:DisplayObjectContainer;
		private var _menuDispatcher:EventDispatcher;
		private var _bar:TileBarController;
		
		public function GameViewController(parent:DisplayObjectContainer, tileVOs:TileVOs, menuDispatcher:EventDispatcher, titleBar:TileBarController):void
		{			
			_parent = parent;
			_tileVOs = tileVOs;
			_menuDispatcher = menuDispatcher;
			_bar = titleBar;
//			onFlagChange();
		}
	}
}
		
//		public function addState(controller:IStateController, key:String, delayOut:int = 0):void
//		{
//			_controllers[key] = controller
//			_delays[key] = delayOut
//		}
//		
//		public function start():void
//		{
//			_parent.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
//			_parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//			
//			_menuDispatcher.addEventListener(GameEvent.GAME_STATE_EVENT, onGameEvent);
//			_tileVOs.addEventListener(GameEvent.GAME_STATE_EVENT, onGameEvent);
//			_tileVOs.addEventListener(GameEvent.GAME_DATA_EVENT_FLAGS, onFlagChange);
//			
//			setState(GameEvent.GAME_STATE_NEW);
//		}
//		
//		private function onFlagChange(event:GameEvent = null):void
//		{
//			_bar.flagvisible = (_gameState == GameEvent.GAME_STATE_PLAYING)
//			_bar.setCount(_tileVOs.flagsOnBoard, _tileVOs.options.board.mineCount);
//		}
//		
//		private function onGameEvent(event:GameEvent):void 
//		{
//			setState(event.result as String);
//			onFlagChange();
//		}
//		
//		public function setCurrentView():void
//		{
//			if(_previousState)
//			{
//				var delay:int = _delays[_previousState]
//				var timer:Timer = new Timer(delay, 1);
//				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTime);
//				timer.start()
//			} else {
//				doSet();
//			}
//		}
//		
//		private function onTime(event:TimerEvent):void
//		{
//			doSet();
//		}
//		
//		private function doSet():void
//		{
//			if(_previousState)
//			{
//				IStateController(_controllers[_previousState]).exit();
//				_previousState = null;
//			}
//			
//			IStateController(_controllers[_gameState]).enter()
//		}
//		
//		private var _previousState:String;
//		private function setState(newState:String):void
//		{			
//			_previousState = _gameState;
//			_gameState = newState;
//			setCurrentView();
//		}
//		
//		//cheat
//		//Todo: move to MS Controller
//		private function showAll():void
//		{
//			if(_gameState == GameEvent.GAME_STATE_PLAYING)
//			{
//				var ctrl:MineSweepController = _controllers[_gameState] as MineSweepController;
//				ctrl.showAll();
//			}
//		}
//		
//		//Todo: move to MS Controller
//		private function onKeyDown(event:KeyboardEvent):void
//		{
//			//should store depressed keys			
//			if (event.keyCode == 16)
//			{
//				_tileVOs.isFlagging = true
//			}
//			
//			//cheat key is c to showall
//			if(event.keyCode == 67) {
//				showAll();
//			}
//			
//			//cheat end game
//			if(event.keyCode == 49 || event.keyCode == 50 || event.keyCode == 51) 
//			{
//				var mode:String;
//				
//				switch(event.keyCode) {
//					case 49:
//						mode = GameOptionsVOs.MODE_EASY;
//						break;
//					
//					case 50:
//						mode = GameOptionsVOs.MODE_MEDIUM;
//						break;
//					
//					case 51:
//						mode = GameOptionsVOs.MODE_HARD;
//						break;					
//				}	
//			}
//			
//			if(mode)
//			{
//				_tileVOs.options.setMode(mode);
//				onGameEvent(new GameEvent(GameEvent.GAME_STATE_EVENT, GameEvent.GAME_STATE_PLAYING) );
//			}
//		}
//		
//		//Todo: move to MS Controller
//		private function onKeyUp(event:KeyboardEvent):void 
//		{
//			if (event.keyCode == 16)
//			{
//				_tileVOs.isFlagging = false
//			}
//		}
//	