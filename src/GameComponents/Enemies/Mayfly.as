package GameComponents.Enemies 
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import GameComponents.Explosion;
	import GameComponents.Player;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Mayfly extends Enemy implements IEnemy 
	{
		private var speed:int;
		private var player:Player;
		
		public function Mayfly(game:Game, player:Player, position:Point) 
		{
			this.player = player;
			health = 1;
			color = 0x00FF00;
			score = 50;
			speed = 4;
			
			super(game, null, position);
		}
		
		override protected function draw(color:uint):void
		{
			var g:Graphics = graphics;
			
			g.lineStyle(1, color);
			g.drawCircle(0, 0, 4);
		}
		
		override protected function move(e:Event):void
		{	
			var xDiff:int = x - player.x;
			var yDiff:int = y - player.y;
			var angle:Number = Math.atan2(yDiff, xDiff);
			
			x -= Math.cos(angle) * speed;
			y -= Math.sin(angle) * speed;
		}
		
		override public function destroy(isPlayer:Boolean):void
		{
			var explosion:Explosion = new Explosion(x, y, color, 1);
			game.explosions.push(explosion);
			game.addChild(explosion);
			
			removeEventListener(Event.ENTER_FRAME, move);
			visible = false;
			_isDestroyed = true;
			
			if (isPlayer)
			{
				game.gui.killCount += 1;
				game.gui.score = score;
			}
		}
	}

}