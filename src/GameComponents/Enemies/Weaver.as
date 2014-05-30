package GameComponents.Enemies 
{
	import Collisions.CollisionList;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import GameComponents.Explosion;
	import GameComponents.Player;
	import GameComponents.Portal;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Weaver extends Enemy implements IEnemy
	{
		private var player:Player;
		private var speed:int;
		private var onWall:Boolean;
		
		public function Weaver(game:Game, player:Player, portal:Portal, position:Point = null) 
		{
			this.player = player;
			health = 1;
			score = 20;
			color = 0xFFFF00;
			speed = 2;
			
			super(game, portal, position);
		}
		
		override protected function draw(color:uint):void
		{
			var g:Graphics = graphics;
			
			g.lineStyle(1, color);
			g.drawRect( -(Main.cellWidth / 4) , -(Main.cellHeight / 4), 
				Main.cellWidth / 2, Main.cellHeight / 2);
			g.moveTo(0, -Main.cellHeight / 4)
			g.lineTo( - Main.cellWidth / 4, 0);
			g.lineTo(0, Main.cellHeight / 4);
			g.lineTo(Main.cellWidth / 4, 0);
			g.lineTo(0, -Main.cellHeight / 4);
		}
		
		override protected function move(e:Event):void
		{
			var xDiff:int = x - player.x;
			var yDiff:int = y - player.y;
			var mAngle:Number = Math.atan2(yDiff, xDiff);
			
			var angle:Number = Math.atan2(yDiff, xDiff) * (180 / Math.PI);
			var PlayerAngle:Number = player.mouseAngle;
			
			if (PlayerAngle < 0)
			{
				PlayerAngle += 360;
			}
			if (angle < 0)
			{
				angle += 360;
			}
		
			var collisions:CollisionList = new CollisionList(this, game.walls[0], game.walls[1], game.walls[2], game.walls[3]);
			var wallsHit:Array = collisions.checkCollisions();
			
			if (wallsHit[0] || wallsHit[1] || wallsHit[2] || wallsHit[3])
			{
				onWall = true;
			}
			else
			{
				onWall = false;
			}
			
			if (angle - 30 <= PlayerAngle && PlayerAngle <= angle && player.isFiring && !onWall)
			{
				mAngle -= Math.PI / 2;
				speed = 3;
				rotation += 1;
			}
			if (angle <= PlayerAngle && PlayerAngle < angle + 30 && player.isFiring && !onWall)
			{
				mAngle += Math.PI / 2;
				speed = 3;
				rotation -= 1;
			}
			
			x -= Math.cos(mAngle) * speed;
			y -= Math.sin(mAngle) * speed;
			
			speed = 2;
		}
		
		override public function destroy(isPlayer:Boolean):void
		{
			explodeSound.play();
			
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