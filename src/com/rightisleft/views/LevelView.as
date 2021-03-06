package com.rightisleft.views
{
	import com.rightisleft.controllers.GenericTextController;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class LevelView extends Sprite
	{
		private var _parent:DisplayObjectContainer;

		public function LevelView(parent:DisplayObjectContainer)
		{
			_parent = parent;
		}
		
		private var _leveltext:Array;
		private var _ctrl:GenericTextController;
		
		public function init(names:Array):void
		{
			_leveltext = [];
			
			_ctrl = new GenericTextController('Akz', 20, 0x505050);
			
			for(var i:int = 0; i < names.length; i++)
			{
				var title:String = names[i]
				var tf:TextField = new TextField();
				this.addChild(tf)
				_ctrl.setText(title.slice(0,1).toUpperCase() + title.slice(1, title.length).toLowerCase(), tf);
				
				//store 
				_leveltext.push(tf);
				
				//get iterative height
				var prevTf:TextField;
				if(_leveltext[i-1])
				{
					prevTf = _leveltext[i-1];	
				}
				
				//height increment
				tf.y = (i == 0) ? 50 : (prevTf) ? prevTf.y + prevTf.textHeight : 0;
				
				//center
				tf.x = (_parent.stage.stageWidth * .5) - (tf.textWidth * .5);	
			}
		}
		
		public function get rows():Array 
		{
			return _leveltext;
		}
	}
}