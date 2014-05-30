package GameComponents 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class FPSCounter extends Sprite 
	{
		private var last:uint;
		private var ticks:uint;
		private var textField:TextField = new TextField();
		
		public function FPSCounter(position:Point, format:TextFormat) 
		{
			x = position.x;
			y = position.y;
			
			textField.defaultTextFormat = format;
			textField.selectable = false;
			textField.text = "30 fps";
			addChild(textField);
			
			last = getTimer();
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void
		{
			ticks++;
			var now:uint = getTimer();
			var difference:uint = now - last;
			
			if (difference >= 1000)
			{
				var fps:int = Math.floor(ticks / difference * 1000);
				ticks = 0;
				last = now;
				textField.text = String(fps) + " fps";
			}
		}
	}

}