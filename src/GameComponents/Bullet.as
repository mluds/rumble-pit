package GameComponents
{
	import Collisions.CollisionList;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Bullet extends Sprite 
	{
		private var game:Game;
		private var speed:int = 10;
		private var _isActive:Boolean = true;
		private var collisions:CollisionList;
		private var _power:int;
		private var side:String;
		private var sound:Sound;
		
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		public function get power():int
		{
			return _power;
		}
		
		
		public function Bullet(game:Game, player:Player, side:String) 
		{
			this.game = game;
			this.side = side;
			
			sound = new Main.laser();
			sound.play();
			
			_power = 1;
			
			x = player.x;
			y = player.y;
			
			if (side == "left")
			{
				rotation = player.rotation - 1;
			}
			else
			{
				rotation = player.rotation + 1;
			}
			
			draw(player, side);
			
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function draw(player:Player, side:String):void
		{
			graphics.lineStyle(1, 0xFFFF00);
			graphics.moveTo(0, player.height / 2);
			graphics.lineTo(0, (player.height / 2) + (player.height / 4));
		}
		
		private function move(e:Event):void
		{
			if (side == "left")
			{
				x += Math.cos((rotation + 89) * (Math.PI / 180)) * speed;
				y += Math.sin((rotation + 89) * (Math.PI / 180)) * speed;
			}
			else 
			{
				x += Math.cos((rotation + 91) * (Math.PI / 180)) * speed;
				y += Math.sin((rotation + 91) * (Math.PI / 180)) * speed;
			}
			
			if (x > Main.screenWidth * 1.5 ||
				x < -(Main.screenWidth * 0.5) ||
				y > Main.screenWidth * 1.5 ||
				y < -(Main.screenWidth * 0.5))
			{
				_isActive = false;
				removeEventListener(Event.ENTER_FRAME, move);
			}
			
			if (_isActive)
			{
				for (var i:int = 0; i < game.enemies.length; i++)
				{
					collisions = new CollisionList(this, game.enemies[i]);
					var enemiesHit:Array = collisions.checkCollisions();
					
					if (enemiesHit[0] && !game.enemies[i].isDestroyed)
					{
						game.enemies[i].hit(this);
						
						_isActive = false;
						visible = false;
					}
				}
				
				for (var j:int = 0; j < game.portals.length; j++)
				{
					collisions = new CollisionList(this, game.portals[j]);
					var portalsHit:Array = collisions.checkCollisions();
					
					if (portalsHit[0] && !game.portals[j].isDestroyed)
					{
						game.portals[j].hit(this);
						
						_isActive = false;
						visible = false;
					}
				}
			}
		}
	}

}