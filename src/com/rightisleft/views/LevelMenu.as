package com.rightisleft.views
{
	import com.rightisleft.controllers.GenericTextController;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class LevelMenu extends Sprite
	{
		private var _title:TextField
		private var _ctrl:GenericTextController = new GenericTextController();
		public function LevelMenu()
		{
			super();
			_title = new TextField();
			addChild(_title);
			
			_ctrl.setText('Title Here', _title);
		}
	}
}