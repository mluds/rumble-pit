package GameComponents 
{
	//{ Imports
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import GameComponents.Enemies.*;
	
	//}
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Portal extends Sprite implements IEnemy
	{
		//{ Fields
		
		private var game:Game;
		private var health:int;
		private var _color:uint;
		private var position:Point;
		private var type:int;
		private var point:Point;
		private var spawnTimer:int;
		private var spawnDelay:int = 4 * 60;
		private var hitSound:Sound;
		private var _isDestroyed:Boolean;
		
		//}
		
		//{ Properties
		
		public function get color():uint
		{
			return _color;
		}
		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		public function set isDestroyed(v:Boolean):void
		{
			_isDestroyed = v;
		}
		
		//}
		
		public function Portal(game:Game, point:Point, type:int)
		{
			hitSound = new Main.hit();
			
			this.game = game;
			this.type = type;
			this.point = point;
			
			setType(type);
			position = point;
			
			health = 10;
			
			x = point.x * Main.cellWidth - Main.cellWidth / 2;
			y = point.y * Main.cellHeight - Main.cellHeight / 2;
			
			draw(_color, health);
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function deactivate():void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			game.portalPoints.push(point);
		}
		
		private function setType(type:int):void
		{
			switch(type)
			{
				case 1: 
					_color = 0x9E7BFF;
					break;
				case 2:
					_color = 0xFF00FF;
					break;
				case 3:
					_color = 0x00FFFF;
					break;
				case 4:
					_color = 0xFFFF00;
					break;
			}
		}
		
		private function draw(_color:uint, shields:int):void
		{
			var portal:Sprite = new Sprite();
			var g:Graphics = portal.graphics;
			
			g.lineStyle(1, _color);
			g.drawRect( -(Main.cellWidth / 4), -(Main.cellHeight / 4), (Main.cellWidth / 2), (Main.cellHeight / 2));
				
			addChild(portal);
		}
		
		private function spawnEnemy():void
		{
			switch(type)
			{
				case 1:
					var wanderer:Wanderer = new Wanderer(game, this);
					game.enemies.push(wanderer);
					game.addChild(wanderer);
					break;
				case 2:
					var spinner:Spinner = new Spinner(game, this);
					game.enemies.push(spinner);
					game.addChild(spinner);
					break;
				case 3:
					var grunt:Grunt = new Grunt(game, this);
					game.enemies.push(grunt);
					game.addChild(grunt);
					break;
				case 4:
					var weaver:Weaver = new Weaver(game, game.player, this);
					game.enemies.push(weaver);
					game.addChild(weaver);
					break;
			}
		}
		
		public function hit(bullet:Bullet):void
		{
			hitSound.play();
			
			health -= bullet.power;
			
			if (health <= 0)
			{
				destroy(true);
			}
		}
		
		public function destroy(isPlayer:Boolean):void
		{
			var explosion:Explosion = new Explosion(x, y, _color, 1.5);
			game.explosions.push(explosion);
			game.addChild(explosion);
			
			//game.portalTimer.start();
			game.portalPoints.push(position);
			
			removeEventListener(Event.ENTER_FRAME, update);
			visible = false;
			_isDestroyed = true;
			
			game.gui.killCount += 1;
		}
		
		public function pause():void
		{
			
		}
		
		public function resume():void
		{
			
		}
		
		private function update(e:Event):void
		{
			if (spawnTimer == spawnDelay)
			{
				spawnTimer = 0;
				spawnEnemy();
			}
			spawnTimer++;
		}
	}

}