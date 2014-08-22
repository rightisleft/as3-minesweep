package com.rightisleft.controllers
{	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class GenericTextController
	{
			// This code would never make it production!
			
			private var _textFormat:TextFormat;
			
			[Embed(	source="/fonts/cheese.ttf", 
			    	fontName = "Cheese", 
			    	mimeType = "application/x-font", 
			    	fontStyle="normal", 
			    	unicodeRange="englishRange", 
			    	advancedAntiAliasing="true", 
			    	embedAsCFF="false")]
			private var myEmbeddedFont:Class;
			
			public function GenericTextController()
			{
				_textFormat = new TextFormat("Cheese", 32, 0x00FF6666);
			}
			
			private var _textField:TextField;
			public function setText(txt:String, textField:TextField):void {
				_textField = textField;
				_textField.embedFonts = true;
				_textField.autoSize = TextFieldAutoSize.LEFT;
				_textField.background = false;
				_textField.multiline = false;
				_textField.selectable = false;
				_textField.defaultTextFormat = _textFormat;
				_textField.text = txt;
			}
	}
}