package com.rightisleft.models
{	
	import com.rightisleft.vos.GridCellVO;
	
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class GridVOs extends EventDispatcher
	{
		private var _rowCount:int;
		private var _columnCount:int;
		public var collection:Array = [];
		private var _columns:Array;
		
		private var _cellHeight:int;
		private var _cellWidth:int;
		
		private var _idHash:Dictionary = new Dictionary();

		public function GridVOs()
		{
			_columns = [];			
		}
		
		public function get gridWidth():int
		{
			return _cellWidth * _columnCount
		}
		
		public function init(columns:int, rows:int, cellHeight:int, cellWidth:int):void {
			
			_rowCount = rows;
			
			_columnCount = columns;
			
			_cellHeight = cellHeight;
			
			_cellWidth = cellWidth;	
			
			clearColumns();
			
			//turn this into a recursive function?
			for(var i:int = 0; i < _rowCount; i++) {
				
				var aColumn:Array = [];
				var _previousCell:GridCellVO

				for (var j:int = 0; j < _columnCount; j++) 
				{					
					if(j == 0) {
						if(i > 0) {
							_previousCell = _columns[i - 1][_columns[i - 1].length -1];
						}
					} else {
						_previousCell = (j != 0) ? aColumn[j-1] : null;
					}
					
					var location:Point = getNextCellLocation(_previousCell);
					
					var newCell:GridCellVO = new GridCellVO(location.x, location.y, _cellWidth, _cellHeight);
					newCell.array_x_index = j;
					newCell.array_y_index = i;
					
					_idHash[newCell.id] = newCell;
					
					aColumn[j] = newCell;
					
					collection.push(newCell);
				}
				
				_columns[i] = aColumn; 
			}
		}
		
		private var _targetX:int;
		private var _targetY:int;
		private function getNextCellLocation(previousCell:GridCellVO = null):Point {
			
			_targetX = 0;
			_targetY = 0;
			
			if(previousCell == null){
				return new Point();
			} else {
				_targetX = previousCell.x + previousCell.width;
				_targetY = previousCell.y;
				
				if(_targetX >= (_cellWidth * _columnCount) ) {
					_targetX = 0;
					_targetY = previousCell.y + previousCell.height;
				}
			}
			
			return new Point(_targetX, _targetY);
		}

		
		public function getRandomCell():GridCellVO {
			var aColIndex:int = int(_columns.length * Math.random() );
			var aRowIndex:int = int(_columns[aColIndex].length * Math.random() );
			
			return _columns[aColIndex][aRowIndex] as GridCellVO;
		}	
		
		public function getCellByLocalCoardinate(x:int, y:int):GridCellVO {
			for each (var cell:GridCellVO in collection) 
			{
				if(cell.x <= x && x <= (cell.x + cell.width) )
				{
					if(y >= cell.y && y <= (cell.y + cell.height) )
					{
						return cell;
					}
				}
			}
			
			return null;
		}
		
		public function getCellToNorthOf(cell:GridCellVO):GridCellVO {
			return getByArrayIndex(cell.array_x_index, cell.array_y_index - 1);
		}
		
		public function getCellToNorthWestOf(cell:GridCellVO):GridCellVO {
			return getByArrayIndex(cell.array_x_index -1, cell.array_y_index - 1);
		}
		
		public function getCellToNorthEastOf(cell:GridCellVO):GridCellVO {
			return getByArrayIndex(cell.array_x_index +1, cell.array_y_index - 1);
		}
		
		
		public function getCellToSouthOf(cell:GridCellVO):GridCellVO {
			return getByArrayIndex(cell.array_x_index, cell.array_y_index + 1);
		}
		
		public function getCellToSouthWestOf(cell:GridCellVO):GridCellVO {
			return getByArrayIndex(cell.array_x_index -1, cell.array_y_index + 1);
		}
		
		public function getCellToSouthEastOf(cell:GridCellVO):GridCellVO {
			return getByArrayIndex(cell.array_x_index +1, cell.array_y_index + 1);
		}
		
		
		public function getCellToWestOf(cell:GridCellVO):GridCellVO {
			return getByArrayIndex(cell.array_x_index -1, cell.array_y_index);
		}
		
		public function getCellToEastOf(cell:GridCellVO):GridCellVO {
			return getByArrayIndex(cell.array_x_index + 1, cell.array_y_index);
		}
		
		public function getByArrayIndex(x:int, y:int):GridCellVO {
			if(y >= 0 && x>= 0 && y < _columns.length && x < _columns[y].length) {
				return _columns[y][x] as GridCellVO;	
			}
			
			return null;
		}
		
		public function getCellByID(id:String):GridCellVO {
			return _idHash[id];
		}
		
		public function getNieghborCellByDirection(id:String, direction:String):GridCellVO
		{
			var neighborCell:GridCellVO; 
			var originCell:GridCellVO = getCellByID(id);
			
			switch(direction) {
				case "n":
					neighborCell = getCellToNorthOf(originCell);
					break;
				
				case "s":
					neighborCell = getCellToSouthOf(originCell);
					break;
				
				case "e":
					neighborCell = getCellToEastOf(originCell);
					break;
				case "w":
					neighborCell = getCellToWestOf(originCell);
					break;
			}
			
			return neighborCell
		}
		
		private function clearColumns():void {
			for each(var cell:GridCellVO in collection) 
			{
				cell.destroy();
				
				cell = null;
			}
			
			collection = [];
			
			_idHash = new Dictionary();
		}
		
		public function destroy():void 
		{
			clearColumns();
		}
	}
}