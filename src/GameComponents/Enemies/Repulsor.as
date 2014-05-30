package GameComponents.Enemies 
{
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Repulsor extends Enemy implements IEnemy 
	{
		private var chargeDistance:Number;
		
		public function Repulsor(game:Game, position:Point) 
		{
			color = 0xFF0000;
			chargeDistance = 50;
			
			super(game, null, position);
		}
		
		override protected function draw():void
		{
			
		}
		
		override protected function move(e:Event):void
		{
			var xDiff:Number = x - game.Player.x;
			var yDiff:Number = y - game.Player.y;
			var angle:Number = Math.atan2(yDiff, xDiff);
			
			var distance:Number = Math.sqrt(Math.pow(xDiff, 2) + Math.pow(yDiff, 2));
			
			if (distance < chargeDistance)
			{
				
			}
			
			x -= Math.cos(angle) * 1.5;
			y -= Math.sin(angle) * 1.5;
		}
		
		override public function destroy(isPlayer:Boolean):void
		{
			
		}
	}

}