package
{
	import com.rightisleft.controllers.GameViewController;
	import com.rightisleft.controllers.LevelController;
	import com.rightisleft.controllers.MineSweepController;
	import com.rightisleft.controllers.TopUIController;
	import com.rightisleft.models.GameOptionsVOs;
	import com.rightisleft.models.GridVOs;
	import com.rightisleft.models.TileVOs;
	import com.rightisleft.views.GridView;
	import com.rightisleft.views.LevelUIView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width='800', height="600", frameRate="60", backgroundColor="0xe6e6e6")]
	
	public class MineSweepContext extends Sprite
	{				
		private var _gameOptions:GameOptionsVOs;

		private var _gridVO:GridVOs;
		private var _gridView:GridView;

		private var _mineSweepController:MineSweepController;
		private var _tileVOs:TileVOs;
		private var _levelController:LevelController;
		private var _levelUIView:LevelUIView;
		private var _titleBar:TopUIController;
		private var _gameViewController:GameViewController;
		
		public function MineSweepContext()
		{	
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			//Class of static config options
			_gameOptions = new GameOptionsVOs();
						
			_gridView = new GridView(this);			
			
			_gridVO = new GridVOs();	
			
			_tileVOs = new TileVOs(_gameOptions);
			
			_titleBar = new TopUIController(this, _tileVOs);
			
			_mineSweepController = new MineSweepController(this, _tileVOs);
			
			_mineSweepController.init(_gridVO, _gridView);		
			
			_levelUIView = new LevelUIView(this);

			_levelController = new LevelController(this, _levelUIView)
			
			_levelController.init(_tileVOs);
			
			_levelController.enter();
			
			//quick positioning
			_levelUIView.y = _titleBar.y + _titleBar.height;
			_gridView.y = _titleBar.height + 10;
		}
	}
}