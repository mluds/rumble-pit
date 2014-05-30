package GameComponents.Enemies 
{
	import Collisions.CollisionList;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import GameComponents.*;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Wanderer extends Enemy implements IEnemy
	{
		private var speed:Number;
		
		public function Wanderer(game:Game, portal:Portal, position:Point = null)
		{
			health = 1;
			color = 0x9E7BFF;
			score = 5;
			speed = 1.5;
			
			angle = Math.round(Math.random() * 360);
			angleRad = angle  * (Math.PI / 180);
			
			super(game, portal, position);
		}
		
		override protected function draw(color:uint):void
		{
			var p:Sprite = new Sprite();
			var g:Graphics = p.graphics;
			
			g.lineStyle(1, 0x9E7BFF);
			g.moveTo(0, -(Main.cellHeight / 4));
			g.lineTo(0, Main.cellHeight / 4);
			g.lineTo( -(Main.cellWidth / 4), Main.cellHeight / 4);
			
			g.moveTo( -(Main.cellWidth / 4), 0);
			g.lineTo( Main.cellWidth / 4, 0);
			g.lineTo(Main.cellWidth / 4, Main.cellHeight / 4);
			
			g.moveTo(-(Main.cellWidth / 4), -(Main.cellHeight / 4));
			g.lineTo(Main.cellWidth / 4, Main.cellHeight / 4);
			g.moveTo(-(Main.cellWidth / 4), (Main.cellHeight / 4));
			g.lineTo(Main.cellWidth / 4, -Main.cellHeight / 4);
			g.lineTo(0, -Main.cellHeight / 4);
			g.moveTo( -Main.cellWidth / 4, -Main.cellHeight / 4);
			g.lineTo( -Main.cellWidth / 4, 0);
			
			addChild(p);
		}
		
		override protected function move(e:Event):void
		{	
			var collisions:CollisionList;
			var wallHit:Array;
			
			for (var i:int = 0; i < game.walls.length; i++)
			{
				collisions = new CollisionList(this, game.walls[i]);
				wallHit = collisions.checkCollisions();
			
				if (wallHit[0])
				{
					switch (i)
					{
						case 0: direction.y *= -1; break;
						case 1: direction.y *= -1; break;
						case 2: direction.x *= -1; break;
						case 3: direction.x *= -1; break;
					}
				}
			}
			
			x += Math.cos(angleRad) * direction.x * speed;
			y += Math.sin(angleRad) * direction.y * speed;
			
			rotation += 1;
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