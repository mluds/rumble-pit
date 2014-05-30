package GameComponents.Enemies 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import GameComponents.Explosion;
	import GameComponents.Portal;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Grunt extends Enemy implements IEnemy
	{
		private var speed:Number;
		
		public function Grunt(game:Game, portal:Portal, position:Point = null)
		{
			health = 1;
			score = 10;
			color = 0x00FFFF;
			speed = 2;
			
			super(game, portal, position);
		}
		
		override protected function draw(color:uint):void
		{
			var p:Sprite = new Sprite();
			var g:Graphics = p.graphics;
			
			g.lineStyle(1, color);
			g.drawRect( -(Main.cellWidth / 4) , -(Main.cellHeight / 4), Main.cellWidth / 2, Main.cellHeight / 2);
			
			addChild(p);
		}
		
		override protected function move(e:Event):void
		{	
			var xDiff:int = x - game.player.x;
			var yDiff:int = y - game.player.y;
			var angle:Number = Math.atan2(yDiff, xDiff);
			
			x -= Math.cos(angle) * speed;
			y -= Math.sin(angle) * speed;
			
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