package com.rightisleft.views
{
	import com.rightisleft.controllers.GenericTextController;
	import com.rightisleft.models.MineSweepModel;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class LevelMenu extends Sprite
	{		
		private var _leveltext:Array;
		
		private var _ctrl:GenericTextController;
		private var _model:MineSweepModel;
		
		public function LevelMenu():void {
			
		}
		
		public function init(parent:DisplayObject, mineModel:MineSweepModel):void
		{
			_leveltext = [];
			
			_ctrl = new GenericTextController('Akz', 20);
			
			_model = mineModel
			
			for(var i:int = 0; i < MineSweepModel.MODES.length; i++)
			{
				var title:String = MineSweepModel.MODES[i]
				var tf:TextField = new TextField();
				addChild(tf)
				_ctrl.setText(title.slice(0,1).toUpperCase() + title.slice(1, title.length).toLowerCase(), tf);
				_leveltext.push(tf);

				var prevTf:TextField;
				if(_leveltext[i-1])
				{
					prevTf = _leveltext[i-1];	
				}
				
				//height increment
				tf.y = (i == 0) ? 50 : (prevTf) ? prevTf.y + prevTf.textHeight : 0;
				
				//center
				tf.x = (parent.stage.stageWidth * .5) - (tf.textWidth * .5);
				
				tf.addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		private function onClick(event:MouseEvent):void
		{
			var tf:TextField = event.currentTarget as TextField;
			var st:String = tf.text;
			for each(var mode:String in MineSweepModel.MODES)
			{
				if(st.toLowerCase().indexOf(mode.toLowerCase()) >= 0) 
				{
					_model.setMode(mode);
				}
			}
		}
		
		private function onHover(event:MouseEvent):void{
			
		}
	}
}