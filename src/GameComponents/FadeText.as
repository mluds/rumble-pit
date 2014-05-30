package GameComponents 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class FadeText extends Sprite 
	{
		private var direction:int;
		private var speed:Number;
		private var _isDestroyed:Boolean;
		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		private var gui:Gui;
		private var player:Player;
		
		public function FadeText(gui:Gui, player:Player, text:String, format:TextFormat) 
		{
			this.gui = gui;
			
			this.player = player;
			alpha = 0;
			speed = 0.02;
			direction = 1;
			
			draw(text, format);
			x = player.x - width / 2;
			y = player.y - 90;
			
			addEventListener(Event.ENTER_FRAME, fade);
		}
		
		private function draw(text:String, format:TextFormat):void
		{
			var textField:TextField = new TextField();
			textField.defaultTextFormat = format;
			textField.text = text;
			textField.selectable = false;
			
			addChild(textField);
		}
		
		private function fade(e:Event):void
		{
			x = player.x - width / 2;
			y = player.y - 50;
			alpha += speed * direction;
			
			if (alpha >= 1)
			{
				direction *= -1;
			}
			if (alpha < 0)
			{
				
				if (gui.fadeStrings.length > 0)
				{
					gui.displayFadeText(gui.fadeStrings[0]);
				}
				removeEventListener(Event.ENTER_FRAME, fade);
				gui.cleanup(this);
			}
		}
	}

}