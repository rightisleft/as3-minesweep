package com.rightisleft.vos
{	
	import flash.geom.Point;

	public class GridVO
	{
		private var _rowCount:int;
		private var _columnCount:int;
		private var _collection:Array = [];
		private var _columns:Array;
		
		private var _cellHeight:int;
		private var _cellWidth:int;
		
		public function GridVO()
		{

		}
		
		public function generateNewGrid(columns:int, rows:int, cellHeight:int, cellWidth:int):void {
			
			_columns = [];
			_rowCount = rows;
			_columnCount = columns;
			
			_cellHeight = cellHeight;
			_cellWidth = cellWidth;
			
			//turn this into a recursive function?
			for(var i:int = 0; i < rows; i++) {
				
				var aColumn:Array = [];
				var _previousCell:GridCellVO

				for (var j:int = 0; j < columns; j++) 
				{					
					if(j == 0) {
						if(i > 0) {
							_previousCell = _columns[i - 1][_columns[i - 1].length -1];
						}
					} else {
						_previousCell = (j != 0) ? aColumn[j-1] : null;
					}
					
					var nextLocation:Point = getNextCellLocation(_previousCell);
					var next2DArray:Point = getNext2DCoordinate(_previousCell);
					
					var newCell:GridCellVO = new GridCellVO(nextLocation.x, nextLocation.y, _cellWidth, _cellHeight);
					newCell.array_x_index = next2DArray.x;
					newCell.array_y_index = next2DArray.y;
					
					aColumn[j] = newCell;
					
					_collection.push(newCell);
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
		
		private function getNext2DCoordinate(previousCell:GridCellVO = null):Point {
			
			_targetX = 0;
			_targetY = 0;
			
			if(previousCell == null){
				return new Point();
			} else {
				_targetX = previousCell.array_x_index + 1;
				_targetY = previousCell.array_y_index;
				
				if(_targetX >= _columnCount ) {
					_targetX = 0;
					_targetY = previousCell.array_y_index + 1;
				}
			}
			
			return new Point(_targetX, _targetY);
		}

		//test function
		public function getRandomCell():GridCellVO {
			var aColIndex:int = int(_columns.length * Math.random() );
			var aRowIndex:int = int(_columns[aColIndex].length * Math.random() );
			
			return _columns[aColIndex][aRowIndex] as GridCellVO;
		}
		// end test function
	
		
		public function getCellByLocalCoardinate(x:int, y:int):GridCellVO {
			for each (var cell:GridCellVO in _collection) 
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
			for each(var cell:GridCellVO in _collection) {
				if(cell.id == id)
				{
					return cell;
				}
			}
			return null;
		}

		public function get collection():Array
		{
			return _collection;
		}
	}
}