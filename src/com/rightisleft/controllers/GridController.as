package com.rightisleft.controllers
{
	import com.rightisleft.views.GridView;
	import com.rightisleft.vos.GridCellVO;
	import com.rightisleft.vos.GridVO;
	
	import flash.events.Event;

	public class GridController
	{
		private var _model:GridVO;
		private var _view:GridView;
		
		public function GridController() {}
		
		public function init(model:GridVO, view: GridView):void {

			_model = model;			
			_view = view;
			
			for each (var cell:GridCellVO in _model.collection) 
			{
				cell.addEventListener(Event.CHANGE, onVoChanged);
			}			
		}
		
		private function onVoChanged(event:Event):void {
			var cell:GridCellVO = _model.getCellByID(event.currentTarget.id);
			_view.updateCell(cell);
		}
	}
}