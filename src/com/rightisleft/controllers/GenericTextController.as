package com.rightisleft.controllers
{	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class GenericTextController
	{
			// This code would never make it production!
			
			private var _textFormat:TextFormat;
			
			[Embed(	source="/fonts/akzidenz-grotesk-bold.ttf", 
			    	fontName = "Akz", 
			    	mimeType = "application/x-font-truetype", 
					fontStyle="Bold", 
			    	advancedAntiAliasing="true", 
			    	embedAsCFF="false")]
			private static const myEmbeddedFont:Class;
			
			public function GenericTextController(font:String = "Akz", size:int = 16, color:uint = 0x00333333)
			{
				_textFormat = new TextFormat(font, size, color);
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