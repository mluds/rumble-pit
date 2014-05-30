package GameComponents 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Particle extends Sprite
	{
		private var direction:Number;
		private var speed:int;
		private var _isDead:Boolean;
		public function get isDead():Boolean
		{
			return _isDead;
		}
		
		public function Particle(explosion:Explosion, color:uint)
		{
			draw(color);
			
			direction = Math.random() * 360 * (Math.PI / 180);
			speed = Math.round(Math.random() * 6) + 4;
			
			cacheAsBitmap = true;
		}
		
		private function draw(color:uint):void
		{
			graphics.lineStyle(1, color);
			graphics.drawCircle(0, 0, 2);
		}
		
		public function update():void
		{
			x += Math.cos(direction) * speed;
			y += Math.sin(direction) * speed;
			
			alpha -= 0.02;
			
			if (alpha <= 0)
			{
				removeEventListener(Event.ENTER_FRAME, update);
				_isDead = true;
				visible = false;
			}
		}
	}

}