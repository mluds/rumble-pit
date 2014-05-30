package GameComponents.Enemies 
{
	//{ Import Statements
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import GameComponents.Bullet;
	import GameComponents.Explosion;
	import GameComponents.GroupSpawn;
	import GameComponents.Player;
	import GameComponents.VortexParticle;
	
	//}
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class BlackHole extends Sprite implements IEnemy
	{
		//{ Fields
		
		private var _health:int;
		private var position:Point;
		private var radius:int;
		private var enemies:Array;
		private var color:uint;
		private var player:Player;
		private var _isDestroyed:Boolean;
		private var particles:Vector.<VortexParticle>;
		private var _resistant:Boolean = true;
		private var explodeSound:Sound;
		private var hitSound:Sound;
		private var particleTimer:Timer;
		private var game:Game;
		private var _particleTimer:int;
		private var _particleDelay:int = 3;
		private var _overloadTimer:int;
		private var _overloadDelay:int = 60 * 30;
		
		//}
		
		//{ Properties
		
		public function set health(v:int):void
		{
			
		}
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
			removeEventListener(Event.ENTER_FRAME, attractEnemies);
			removeEventListener(Event.ENTER_FRAME, attractPlayer);
		}
		
		//}
		
		public function BlackHole(player:Player, game:Game, position:Point) 
		{
			explodeSound = new Main.blackHoleExplode();
			hitSound = new Main.hit();
			
			color = 0xFF0000;
			this.position = position;
			this.game = game;
			enemies = game.enemies;
			this.player = player;
			_health = 25;
			radius = _health;
			
			draw();
		
			x = position.x * Main.cellWidth;
			y = position.y * Main.cellHeight;
			particles = new Vector.<VortexParticle>();
			
			var cleanupTimer:Timer = new Timer(100);
			cleanupTimer.addEventListener(TimerEvent.TIMER, cleanup);
			cleanupTimer.start();
		}
		
		private function draw():void
		{
			graphics.clear();
			graphics.lineStyle(1, color);
			graphics.drawCircle(0, 0, radius);
		}
		
		private function attractEnemies():void
		{	
			for (var i:int = 0; i < enemies.length; i++)
			{
				if (!enemies[i].resistant)
				{
					var xDiff:int = enemies[i].x - x;
					var yDiff:int = enemies[i].y - y;
					var angle:Number = Math.atan2(yDiff, xDiff);
					var distance:int = Math.sqrt((xDiff * xDiff) + (yDiff * yDiff));
					
					var gravity:Number = 10 * _health / distance;
					
					enemies[i].x -= Math.cos(angle) * gravity;
					enemies[i].y -= Math.sin(angle) * gravity;
					
					if (distance < radius)
					{
						enemies[i].destroy(false);
						_health += 2;
						if (5 < _health && _health < 60)
						{
							radius = _health;
							draw();
						}
						if (_health > 100)
						{
							overload();
						}
					}
				}
			}
		}
		
		private function attractPlayer():void
		{
			var xDiff:int = player.x - x;
			var yDiff:int = player.y - y;
			var angle:Number = Math.atan2(yDiff, xDiff);
			var distance:int = Math.sqrt((xDiff * xDiff) + (yDiff * yDiff));
				
			var gravity:Number = 10 * _health / distance;
			
			player.x -= Math.cos(angle) * gravity;
			player.y -= Math.sin(angle) * gravity;
			
			if (distance < radius)
			{
				player.destroy(this);
			}
		}
		
		private function generateParticle():void
		{
			var pOrigin:Point = new Point(0, 0);
			var pDistance:int = (radius * 0.6) + (Math.random() * radius * 0.8);
			var pAngle:Number = Math.random() * 360;
			
			var particle:VortexParticle = new VortexParticle(pOrigin, pDistance, pAngle, 3, color);
			particles.push(particle);
			addChild(particle);
		}
		
		private function cleanup(e:TimerEvent):void
		{
			for (var i:int = 0; i < particles.length; i++)
			{
				if (particles[i].isDestroyed)
				{
					removeChild(particles[i]);
					particles[i] = null;
					particles.splice(i, 1);
				}
			}
		}
		
		private function overload():void
		{
			destroy(false);
			
			var quantity:int = _health / 4;
			var posX:Number = position.x * Main.cellWidth;
			var posY:Number = position.y * Main.cellHeight;
			var point:Point = new Point(posX, posY);
			
			var particles:GroupSpawn = new GroupSpawn(game, "proton", point, quantity, 20, 50);
			game.groupSpawns.push(particles);
		}
		
		public function pause():void
		{
			particleTimer.stop();
			removeEventListener(Event.ENTER_FRAME, attractEnemies);
			removeEventListener(Event.ENTER_FRAME, attractPlayer);
		}
		
		public function resume():void
		{
			particleTimer.start();
			addEventListener(Event.ENTER_FRAME, attractEnemies);
			addEventListener(Event.ENTER_FRAME, attractPlayer);
		}
		
		public function hit(bullet:Bullet):void
		{
			hitSound.play();
			
			_health -= bullet.power;
			radius = _health;
			
			if (5 < _health && _health < 60)
			{
				draw();
			}
			
			if (_health <= 0)
			{
				destroy(false);
			}
		}
		
		public function destroy(isPlayer:Boolean):void
		{
			explodeSound.play();
			
			var explosion:Explosion = new Explosion(x, y, color, 3);
			game.explosions.push(explosion);
			game.addChild(explosion);
			
			_isDestroyed = true;
			visible = false;
			
			game.blackHolePoints.push(position);
			//ame.blackHoleTimer.start();
			
			removeEventListener(Event.ENTER_FRAME, attractEnemies);
			removeEventListener(Event.ENTER_FRAME, attractPlayer);
		}
		
		private function update(e:Event):void
		{
			attractEnemies();
			attractPlayer();
			
			if (_particleTimer == _particleDelay)
			{
				_particleTimer = 0;
				generateParticle();
			}
			_particleTimer++;
			
			if (_overloadTimer == _overloadDelay)
			{
				_overloadTimer = 0;
				overload();
			}
			_overloadTimer++;
		}
	}

}