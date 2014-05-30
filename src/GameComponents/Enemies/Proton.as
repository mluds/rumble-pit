package GameComponents.Enemies 
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import GameComponents.Explosion;
	import GameComponents.Player;
	import GameComponents.Portal;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Proton extends Enemy implements IEnemy 
	{
		private var speed:int;
		private var player:Player;
		private var protonSpawnSound:Sound;
		private var destroySound:Sound;
		
		public function Proton(game:Game, player:Player, position:Point) 
		{
			protonSpawnSound = new Main.proton();
			protonSpawnSound.play();
			
			destroySound = new Main.spinnerbreak2();
			
			this.player = player;
			health = 1;
			color = 0xFF0000;
			score = 50;
			speed = 4.5;
			
			super(game, null, position, false);
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
			destroySound.play();
			
			var explosion:Explosion = new Explosion(x, y, color, 0.5);
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