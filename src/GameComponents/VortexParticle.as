package GameComponents 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class VortexParticle extends Sprite 
	{
		private var fadeMag:int;
		private var speed:int;
		private var angle:Number;
		private var origin:Point;
		private var _isDestroyed:Boolean;
		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		
		public function VortexParticle(origin:Point, distance:int, angle:Number, speed:int, color:uint) 
		{
			angle *= Math.PI / 180;
			this.angle = angle;
			this.speed = speed;
			this.origin = origin;
			fadeMag = 8;
			
			draw(color);
			
			x = origin.x + (Math.cos(angle) * distance);
			y = origin.y + (Math.sin(angle) * distance);
			
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function draw(color:uint):void
		{
			graphics.lineStyle(1, color);
			graphics.drawCircle(0, 0, 2);
		}
		
		
		private function move(e:Event):void
		{
			alpha -= fadeMag * 0.01;
			var xDiff:int = origin.x - x;
			var yDiff:int = origin.y - y;
			var distance:Number = Math.sqrt((xDiff * xDiff) + (yDiff * yDiff));
			
			if (distance > speed)
			{
				x -= Math.cos(angle) * speed;
				y -= Math.sin(angle) * speed;
			}
			else
			{
				destroy();
			}
		}
		
		private function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, move);
			_isDestroyed = true;
			visible = false;
		}
	}

}