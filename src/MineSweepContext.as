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
	
	[SWF(width='800', height="600", frameRate="60")]
	
	public class MineSweepContext extends Sprite
	{
		private static const COLOR:uint = 0x007D26CD;
		private static const SHOW_DEBUG_MODE:Boolean = true;
				
		private var _gridModel:GridVO;
		private var _gridView:GridView;
		private var _gridController:GridController;
		
		private var _mineSweepController:MineSweepController;
		
		public function MineSweepContext()
		{	
			//set stage properties
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var mineModel:MineSweepModel  = new MineSweepModel();
			
			//Grid Setup
			_gridModel = new GridVO(mineModel.collumns,mineModel.rows, mineModel.tileHeight, mineModel.tileWidth);	
			
			_gridView = new GridView();
			_gridView.init(this);
			
			_gridController = new GridController();
			_gridController.init(_gridModel, _gridView);
			
			_mineSweepController = new MineSweepController(_gridModel, _gridView, mineModel);			

			this.addChild(_gridView);
			
			
			//Game Setup
			
		}
	}
}