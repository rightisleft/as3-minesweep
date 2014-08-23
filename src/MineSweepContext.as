package
{
	import com.rightisleft.controllers.MineSweepController;
	import com.rightisleft.models.MineSweepModel;
	import com.rightisleft.views.GridView;
	import com.rightisleft.views.LevelMenu;
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
		
		private var _uiLayer:Sprite;
		
		public function MineSweepContext()
		{	
			//set stage properties
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_uiLayer = new Sprite();
			_gridView = new GridView();
			
			this.addChild(_gridView);	
			this.addChild(_uiLayer);
			
			_mineSweepModel = new MineSweepModel();
			_mineSweepModel.addEventListener(Event.CHANGE, onActivate);
			_mineSweepController = new MineSweepController();			
			
			var menu:LevelMenu = new LevelMenu();
			_uiLayer.addChild(menu);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
			_mineSweepModel.setMode(MineSweepModel.MODE_EASY);
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
			_gridModel = new GridVO(_mineSweepModel.mode.columns, _mineSweepModel.mode.rows, _mineSweepModel.mode.tileHeight, _mineSweepModel.mode.tileWidth);	
			_gridView.init(this);
			
			_mineSweepController.init(_gridModel, _gridView, _mineSweepModel);
		}
	}
}