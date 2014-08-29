package
{
	import com.rightisleft.controllers.LevelController;
	import com.rightisleft.controllers.MineSweepController;
	import com.rightisleft.controllers.TopUIController;
	import com.rightisleft.models.ContenderModel;
	import com.rightisleft.models.GameOptionsModel;
	import com.rightisleft.models.GridModel;
	import com.rightisleft.views.GridController;
	import com.rightisleft.views.LevelUIView;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width='800', height="600", frameRate="60", backgroundColor="0xe6e6e6")]
	
	public class MineSweepContext extends Sprite
	{				
		private var _gameModel:GameOptionsModel;

		private var _gridModel:GridModel;
		private var _gridController:GridController;
		private var _gridView:Bitmap;

		private var _mineSweepController:MineSweepController;
		private var _contenderModel:ContenderModel;
		private var _levelController:LevelController;
		private var _levelUIView:LevelUIView;
		private var _titleBar:TopUIController;
		
		public function MineSweepContext()
		{	
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			//Class of static config options
			_gameModel = new GameOptionsModel();
				
			_gridView = new Bitmap();
			_gridModel = new GridModel();	
			_gridController = new GridController(this, _gridView);						
			
			_contenderModel = new ContenderModel(_gameModel);
			
			_titleBar = new TopUIController(this, _contenderModel);
			
			_mineSweepController = new MineSweepController(this, _contenderModel);
			
			_mineSweepController.init(_gridModel, _gridController);		
			
			_levelUIView = new LevelUIView(this);

			_levelController = new LevelController(this, _levelUIView)
			
			_levelController.init(_contenderModel);
			
			_levelController.enter();
			
			//quick positioning
			_levelUIView.y = _titleBar.y + _titleBar.height;
			_gridController.y = _titleBar.height + 10;
			_gridController.y = _titleBar.height + 10;
		}
	}
}