package GameComponents 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class SpawnRing extends Sprite 
	{
		private var color:uint;
		private var size:int;
		private var speed:Number;
		private var fadeSpeed:Number;
		private var _isDead:Boolean;
		public function get isDead():Boolean
		{
			return _isDead;
			
		}
		public function set isDead(v:Boolean):void
		{
			_isDead = v;
			
			if (_isDead)
			{
				visible = false;
			}
		}
		
		public function SpawnRing(position:Point, speed:Number, color:uint) 
		{
			this.color = color;
			size = 1;
			this.speed = speed;
			fadeSpeed = 0.02;
			
			draw(color, size);
			
			x = position.x;
			y = position.y;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function draw(color:uint, size:int):void
		{
			var g:Graphics = graphics;
			
			g.clear();
			g.lineStyle(1, color);
			g.drawCircle(0, 0, size / 2);
		}
		
		private function update(e:Event):void
		{
			size += speed;
			draw(color, size);
			alpha -= fadeSpeed;
			
			if (alpha < 0)
			{
				isDead = true;
				removeEventListener(Event.ENTER_FRAME, update);
			}
		}
	}

}