package com.rightisleft.controllers
{
	import com.rightisleft.models.TileVOs;
	import com.rightisleft.vos.TileVO;
	
	import flash.display.BitmapData;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class TileController
	{
		private var _tileVOs:TileVOs;
		
		private var _textField:TextField;
		private var _textHash:Dictionary = new Dictionary();
		private var _bevelFilter:BevelFilter;
		
		public function TileController(tileVOs:TileVOs)
		{
			_tileVOs = tileVOs;

			_textField = new TextField();
			new GenericTextController('Akz', 10, 0x000000).setText('', _textField);
			
			_bevelFilter = new BevelFilter();
			_bevelFilter.blurX = 2;
			_bevelFilter.blurY = 2;
			_bevelFilter.strength = .1
		}
		
		public function painTile(tileVO:TileVO):void 
		{

			//blit text
			var textValue:String = tileVO.text;
			var snapshot:BitmapData;
			
			//check if bitmapdata is cached so we dont have to draw a bunch of repeated text fields
			if(textValue.length) {
				if(_textHash[textValue]) {
					snapshot = _textHash[textValue]; //cached
				} else {
					_textField.text = textValue; 
					
					snapshot = new BitmapData(_textField.width, _textField.height, true, 0x00FFFFFF);
					snapshot.draw(_textField, new Matrix() );
					_textHash[textValue] = snapshot;
				}
			}
			
			//new fill
			tileVO.bmpd = new BitmapData(tileVO.tileWidth, tileVO.tileHeight, true, tileVO.color);
			
			//compose text onto square
			if(snapshot) {
				var rect:Rectangle = new Rectangle(0, 0, _textField.width, _textField.height);
				var aPoint:Point = new Point();
				tileVO.bmpd.copyPixels(snapshot, rect, aPoint, null, null, true);	
			}
			
			//Apply Tile Bevel
			var bevelRect:Rectangle = new Rectangle(0,0, tileVO.bmpd.width,tileVO.bmpd.height)
			_bevelFilter.quality = BitmapFilterQuality.HIGH;
			tileVO.bmpd.applyFilter(tileVO.bmpd,bevelRect,new Point(0,0), _bevelFilter);
			tileVO.updated();
		}
		
		public function validateFlags(tileVO:TileVO):void {
			
			if(tileVO && tileVO.type == TileVO.TYPE_MINE && tileVO.state == TileVO.STATE_EXPLODED)
			{
				_tileVOs.lose();
				return;
			}
			
			var isAMineStillActive:Boolean = false; //could increment a count instead of looping - insignificant performance at this stage
			
			for each(var tile:TileVO in _tileVOs.collectionOfMines)
			{
				if(tile.state != TileVO.STATE_FLAGGED)
				{
					isAMineStillActive = true;
					break;
				}
			}
			
			if(isAMineStillActive == false)
			{
				_tileVOs.win();
			}
		}
	}
}

