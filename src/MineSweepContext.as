package
{
	import com.rightisleft.controllers.GridController;
	import com.rightisleft.controllers.MineSweepController;
	import com.rightisleft.models.MineSweepModel;
	import com.rightisleft.views.GridView;
	import com.rightisleft.vos.GridVO;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	
	[SWF(width='800', height="600", frameRate="60")]
	
	public class MineSweepContext extends Sprite
	{				
		private var _gridModel:GridVO;
		private var _gridView:GridView;
		private var _gridController:GridController;
		
		private var _mineSweepController:MineSweepController;
		private var _mineSweepModel:MineSweepModel;
		
		public function MineSweepContext()
		{	
			//set stage properties
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_mineSweepModel = new MineSweepModel();
			_mineSweepModel.setMode(MineSweepModel.MODE_EASY);


			//Grid Setup
			_gridModel = new GridVO(_mineSweepModel.mode.columns, _mineSweepModel.mode.rows, _mineSweepModel.mode.tileHeight, _mineSweepModel.mode.tileWidth);	
			
			_gridView = new GridView();
			_gridView.init(this);
			
			_gridController = new GridController();
			_gridController.init(_gridModel, _gridView);
			
			_mineSweepController = new MineSweepController(_gridModel, _gridView, _mineSweepModel);			

			this.addChild(_gridView);	
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp)
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			//should store depressed keys
			if (event.keyCode == 9)
			{
				_mineSweepModel.isFlagging = true
			}
			
			//cheat key is c to showall
			if(event.keyCode == 67) {
				_mineSweepController.showAll();
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void 
		{
			if (event.keyCode == 9)
			{
				_mineSweepModel.isFlagging = false
			}
		}
	}
}