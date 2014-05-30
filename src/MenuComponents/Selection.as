package MenuComponents 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.media.SoundLoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Selection extends Sprite 
	{
		private var textField:TextField = new TextField();
		private var _selected:Function;
		
		//{ Properties
		
		public function set selected(v:Function):void
		{
			_selected = v;
		}
		
		public function get selected():Function
		{
			return _selected;
		}
		
		//}
		
		public function set text(v:String):void
		{
			textField.text = v;
		}
		
		public function Selection(text:String, format:TextFormat) 
		{
			draw(text, format);
		}
		
		private function draw(text:String, format:TextFormat):void
		{
			textField.defaultTextFormat = format;
			textField.text = text;
			textField.height = textField.textHeight + 3;
			textField.selectable = false;
			addChild(textField);
		}
		
		public function select():void
		{
			textField.textColor = 0xFFFFFF;
		}
		
		public function deselect():void
		{
			textField.textColor = 0xFFFF00;
		}
	}

}