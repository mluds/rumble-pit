package GameComponents 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Wall extends Sprite 
	{
		
		public function Wall(position:Point, length:Number, angle:Number) 
		{
			draw(length);
			
			x = position.x;
			y = position.y;
			
			rotation = angle;
			visible = false;
		}
		
		private function draw(length:Number):void
		{
			var g:Graphics = graphics;
			
			g.lineStyle(1, 0xFFFF00);
			g.lineTo(length, 0);
		}
	}

}