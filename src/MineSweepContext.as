package
{
	import com.rightisleft.controllers.LevelController;
	import com.rightisleft.controllers.MineSweepController;
	import com.rightisleft.controllers.TopUIController;
	import com.rightisleft.models.ContenderModel;
	import com.rightisleft.models.GameOptionsModel;
	import com.rightisleft.models.GridModel;
	import com.rightisleft.views.GridView;
	import com.rightisleft.views.LevelUIView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width='800', height="600", frameRate="60", backgroundColor="0xe6e6e6")]
	
	public class MineSweepContext extends Sprite
	{				
		private var _gameModel:GameOptionsModel;

		private var _gridVO:GridModel;
		private var _gridView:GridView;

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
						
			_gridView = new GridView(this);			
			
			_gridVO = new GridModel();	
			
			_contenderModel = new ContenderModel(_gameModel);
			
			_titleBar = new TopUIController(this, _contenderModel);
			
			_mineSweepController = new MineSweepController(this, _contenderModel);
			
			_mineSweepController.init(_gridVO, _gridView);		
			
			_levelUIView = new LevelUIView(this);

			_levelController = new LevelController(this, _levelUIView)
			
			_levelController.init(_contenderModel);
			
			_levelController.enter();
			
			//quick positioning
			_levelUIView.y = _titleBar.y + _titleBar.height;
			_gridView.y = _titleBar.height + 10;
			_gridView.y = _titleBar.height + 10;
		}
	}
}