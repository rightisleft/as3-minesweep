package com.rightisleft.controllers
{	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class GenericTextController
	{
			// This code would never make it production!
			
			private var _textFormat:TextFormat = new TextFormat("Cheese", 16, 0x00FF3366);
			private var _view:DisplayObjectContainer;
			
			[Embed(source="/fonts/ufonts.com_grilledcheese-btn.ttf", fontName = "Cheese", mimeType = "application/x-font-truetype",embedAsCFF="false", advancedAntiAliasing="true")]
			private var embeddedCheeseFont:Class;
			
			public function GenericTextController()
			{
			}
			
			private var _textField:TextField;
			public function setText(txt:String, textField:TextField):void {
				_textField = textField;
				_textField.setTextFormat( _textFormat );			
				_textField.autoSize = TextFieldAutoSize.LEFT;
				_textField.background = false;
				_textField.multiline = false;
				_textField.selectable = false;
				_textField.defaultTextFormat = _textFormat;
				_textField.text = txt;
			}
	}
}