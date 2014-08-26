package
{
	import com.rightisleft.controllers.GameViewController;
	import com.rightisleft.controllers.LevelController;
	import com.rightisleft.controllers.MineSweepController;
	import com.rightisleft.controllers.TileBarController;
	import com.rightisleft.models.GameOptionsVOs;
	import com.rightisleft.models.GridVOs;
	import com.rightisleft.models.TileVOs;
	import com.rightisleft.views.GridView;
	import com.rightisleft.views.LevelMenuView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width='800', height="600", frameRate="60")]
	
	public class MineSweepContext extends Sprite
	{				
		private var _gridVO:GridVOs;
		private var _gridView:GridView;
		private var _mineSweepController:MineSweepController;
		private var _tileVOs:TileVOs;
		private var _levelController:LevelController;
		private var _menuView:LevelMenuView;
		private var _titleBar:TileBarController;
		private var _gameViewController:GameViewController;
		private var _gameOptions:GameOptionsVOs;
		
		public function MineSweepContext()
		{	
			//Global Params
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			_gameOptions = new GameOptionsVOs();

			// UIs Managers
			_titleBar = new TileBarController(this);
						
			_gridView = new GridView(this);
			
			_gridView.y = _titleBar.height + 10;
			
			_gridVO = new GridVOs();	
			
			_tileVOs = new TileVOs(_gameOptions);
			
			_mineSweepController = new MineSweepController(this, _tileVOs);
			_mineSweepController.init(_gridVO, _gridView);		
			
			_menuView = new LevelMenuView(this);
			_menuView.y = _titleBar.y + _titleBar.height;
			
			_levelController = new LevelController(this, _menuView)
			_levelController.init(_tileVOs);
			_levelController.enter();
		}
	}
}