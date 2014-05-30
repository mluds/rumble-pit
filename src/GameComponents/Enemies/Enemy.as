package GameComponents.Enemies 
{
	//{ Import Statements
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import GameComponents.Bullet;
	import GameComponents.Portal;
	import GameComponents.SpawnRing;
	
	//}
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Enemy extends Sprite 
	{
		//{ Fields
		
		protected var game:Game;
		protected var portal:Portal;
		protected var score:int;
		protected var health:int;
		protected var angle:int;
		protected var angleRad:int;
		protected var color:uint;
		protected var direction:Point = new Point(1, 1);
		protected var _resistant:Boolean = false;
		protected var _isDestroyed:Boolean;
		protected var explodeSound:Sound;
		
		//}
		
		//{ Properties
		
		public function get resistant():Boolean
		{
			return _resistant;
		}
		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		public function set isDestroyed(v:Boolean):void
		{
			_isDestroyed = v;
		}
		public function deactivate():void
		{
			removeEventListener(Event.ENTER_FRAME, move);
		}
		
		//}
		
		public function Enemy(game:Game, portal:Portal, position:Point = null, createRing:Boolean = true) 
		{
			explodeSound = new Main.explosion();
			
			this.game = game;
			if (portal)
			{
				this.portal = portal;
				color = portal.color;
			}
			
			if (position)
			{
				x = position.x;
				y = position.y;
			}
			else
			{
				x = portal.x;
				y = portal.y;
			}
			
			draw(color);
			
			if (createRing)
			{
				var spawnRing:SpawnRing = new SpawnRing(new Point(x, y), 4, color);
				game.addChild(spawnRing);
				game.spawnRings.push(spawnRing);
			}
			
			addEventListener(Event.ENTER_FRAME, move);
			
			cacheAsBitmap = true;
		}
		
		protected function draw(color:uint):void
		{
			
		}
		
		protected function move(e:Event):void
		{
			
		}
		
		public function hit(bullet:Bullet):void
		{
			health -= bullet.power;
			
			if (health <= 0)
			{
				destroy(true);
			}
		}
		
		public function destroy(isPlayer:Boolean):void
		{
			
		}
		
		public function pause():void
		{
			removeEventListener(Event.ENTER_FRAME, move);
		}
		
		public function resume():void
		{
			addEventListener(Event.ENTER_FRAME, move);
		}
	}

}