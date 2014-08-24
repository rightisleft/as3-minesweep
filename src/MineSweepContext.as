package
{
	import com.rightisleft.controllers.MineSweepController;
	import com.rightisleft.models.MineSweepModel;
	import com.rightisleft.views.EndScreen;
	import com.rightisleft.views.GridView;
	import com.rightisleft.views.LevelMenu;
	import com.rightisleft.views.TileBarController;
	import com.rightisleft.vos.GridVO;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	[SWF(width='800', height="600", frameRate="60")]
	
	public class MineSweepContext extends Sprite
	{				
		private var _gridModel:GridVO;
		private var _gridView:GridView;

		
		private var _mineSweepController:MineSweepController;
		private var _mineSweepModel:MineSweepModel;
		private var _menu:LevelMenu;
		
		private var _textWon:EndScreen;
		private var _textFailed:EndScreen;
		
		private var _titleBar:TileBarController;
		
		public function MineSweepContext()
		{	
			//set stage properties
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_gridView = new GridView();
			addChild(_gridView);
			
			_titleBar = new TileBarController(this);

			
			_mineSweepModel = new MineSweepModel();
			_mineSweepController = new MineSweepController();			
			
			_menu= new LevelMenu();
			_menu.init(this, _mineSweepModel);

			this.addChild(_menu);
			
			_textWon = new EndScreen('You Won!');
			_textFailed = new EndScreen('You blew up! FAIL');
			_textFailed.mouseEnabled = _textWon.mouseEnabled = false;
			
			_textFailed.addEventListener(Event.COMPLETE, onEndScreenComplete);
			_textWon.addEventListener(Event.COMPLETE, onEndScreenComplete);
			
			_mineSweepModel.addEventListener(Event.CHANGE, onActivate);

			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
			_mineSweepModel.addGameStateChangeHandler( ghettoStateHandler );
			_mineSweepModel.setGameState(MineSweepModel.GAME_STATE_NEW);
			_mineSweepModel.incrementHandlers.push( incrementMines ); 
			
			_gridView.y = _titleBar.height + 10;

			this.addChild(_textWon);
			this.addChild(_textFailed);
		}
		
		private function incrementMines():void 
		{
			_titleBar.setCount(_mineSweepModel.flagsOnBoard, _mineSweepModel.mode.mineCount);
		}
		
		private function onEndScreenComplete(event:Event):void 
		{
			_mineSweepModel.setGameState(MineSweepModel.GAME_STATE_NEW);
		}
		
		private function ghettoStateHandler(model:MineSweepModel):void 
		{		
			_menu.visible = false;
			_gridView.visible = true;
			
			switch(model.gameState)
			{
				case MineSweepModel.GAME_STATE_NEW:
					_gridView.visible = false;
					_menu.visible = true;
				break;
				
				case MineSweepModel.GAME_STATE_PLAYING:
					_gridView.visible = true;
				break;
				
				case MineSweepModel.GAME_STATE_YOU_LOST:
					_textFailed.start();
				break;
				
				case MineSweepModel.GAME_STATE_YOU_WON:
					_textWon.start();					
				break;
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void 
		{
			//cheat end game
			if(event.keyCode == 49 || event.keyCode == 50 || event.keyCode == 51) 
			{
				var mode:String;
				
				switch(event.keyCode) {
					case 49:
						mode = MineSweepModel.MODE_EASY;
						break;
					
					case 50:
						mode = MineSweepModel.MODE_MEDIUM;
						break;
					
					case 51:
						mode = MineSweepModel.MODE_HARD;
						break;					
				}
				
				_mineSweepController.endGame();
				_mineSweepModel.setMode(mode);
			}
		}
		
		private function onActivate(event:Event):void 
		{
			_mineSweepController.endGame();
			_gridModel = new GridVO(_mineSweepModel.mode.columns, _mineSweepModel.mode.rows, _mineSweepModel.mode.tileHeight, _mineSweepModel.mode.tileWidth);	
			_gridView.init(this);
			_mineSweepController.init(_gridModel, _gridView, _mineSweepModel);
		}
	}
}