package com.rightisleft.controllers
{
	import com.rightisleft.views.GridView;
	import com.rightisleft.vos.GridCellVO;
	import com.rightisleft.vos.GridVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class GridController
	{
		private var _model:GridVO;
		private var _view:GridView;
		
		public function GridController() {}
		
		public function init(model:GridVO, view: GridView):void {

			_model = model;
			_model.generateNewGrid(8,6, 100, 100);
			
			_view = view;
			
			for each (var cell:GridCellVO in _model.collection) 
			{
				cell.addEventListener(Event.CHANGE, onVoChanged);
			}
			
			_view.addEventListener(MouseEvent.CLICK, onGridClicked);
		}
		
		private function onGridClicked(event:MouseEvent):void {
			var cell:GridCellVO = _model.getCellByLocalCoardinate(event.localX, event.localY);
			_view.updateCell(cell);
		}
		
		private function onVoChanged(event):void {
			//todo dispatch reference so we dont have to loop
			for each (var cell:GridCellVO in _model.collection) 
			{
				_view.updateCell(cell);
			}
		}
	}
}