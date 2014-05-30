package GameComponents 
{
	//{ Import Statements
	
	import Collisions.CollisionGroup;
	import Collisions.CollisionList;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.ui.*;
	import GameComponents.Enemies.IEnemy;
	
	//}
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Player extends Sprite 
	{
		//{ Fields
		
		private var game:Game;
		private var speed:int = 6;
		private var _isFiring:Boolean;
		private var fireCount:int;
		private var fireDelay:int = 6;
		private var fireTimer:Timer = new Timer(150);
		private var _isDead:Boolean;
		private var explosionTimer:Timer;
		private var isSpacePressed:Boolean;
		private var collisions:CollisionList;
		private var _mouseAngle:Number;
		private var _enemyBoundaryRadius:Number;
		private var explodeSound:Sound;
		
		//}
		
		//{ Properties
		
		public function get isFiring():Boolean
		{
			return _isFiring;
		}
		public function get mouseAngle():Number
		{
			return _mouseAngle;
		}
		public function get enemyBoundaryRadius():Number
		{
			return _enemyBoundaryRadius;
		}
		
		//}
		
		public function Player(width:int, height:int, game:Game) 
		{
			explodeSound = new Main.PlayerExplode();
			
			this.game = game;
			_enemyBoundaryRadius = Main.cellWidth * 2;
			
			draw(width, height);
			
			x = Main.screenWidth / 2;
			y = Main.screenHeight / 2;
			
			game.addEventListener(Event.ENTER_FRAME, followMouse);
			addEventListener(Event.ENTER_FRAME, move);
			addEventListener(Event.ENTER_FRAME, checkCollision);
			game.addEventListener(MouseEvent.MOUSE_DOWN, fire);
			
			game.addEventListener(MouseEvent.MOUSE_UP, stopFire);
			
			cacheAsBitmap = true;
		}
		
		private function draw(width:int, height:int):void
		{
			var ship:Sprite = new Sprite();
			var g:Graphics = ship.graphics;
			
			g.lineStyle(1, 0xFFFF00);
			
			g.moveTo(1, -(height / 2));
			g.lineTo( -(width / 2), -(height / 4));
			
			g.lineTo( -(width / 4), (height / 2));
			g.lineTo( -(width / 4), 0);
			g.lineTo( 1, -(height / 6));
			g.lineTo( (width / 4), 0);
			g.lineTo( (width / 4), (height / 2));
			g.lineTo( (width / 2) + 1, -(height / 4));
			g.lineTo(1, -(height / 2));
			
			addChild(ship);
		}
		
		private function followMouse(e:Event):void
		{
			var p1:Point = new Point(x, y);
			var p2:Point = new Point(game.mouseX, game.mouseY);
			rotation = findAngle(p1, p2);
			
			var xDiff:int = game.mouseX - x;
			var yDiff:int = game.mouseY - y;
			_mouseAngle = Math.atan2(yDiff, xDiff) * (180 / Math.PI);
		}
		
		private function findAngle(p1:Point, p2:Point):Number
		{
			var deltaX:Number = p1.x - p2.x;
			var deltaY:Number = p1.y - p2.y;
			var angle:Number = Math.atan2(deltaY, deltaX);
			var degrees:Number = angle * (180 / Math.PI) + 90;
			
			return degrees;
		}
		
		private function move(e:Event):void
		{
			if (_isFiring && fireCount == fireDelay)
			{
				continueFiring();
				fireCount = 0;
			}
				
			fireCount++;
			
			var xCoord:int = Math.round (x / Main.cellWidth);
			
			if (x < 0)
			{
				x = 0;
			}
			if (x > Main.screenWidth)
			{
				x = Main.screenWidth;
			}
			if (y < 0)
			{
				y = 0;
			}
			if (y > Main.screenHeight)
			{
				y = Main.screenHeight;
			}
			
			if (Key.isDown(87))
			{
				y -= speed;
			}
			if (Key.isDown(65))
			{
				x -= speed;
			}
			if (Key.isDown(83))
			{
				y += speed;
			}
			if (Key.isDown(68))
			{
				x += speed;
			}
			if (Key.isDown(Keyboard.SPACE) && !isSpacePressed)
			{
				bomb();
				isSpacePressed = true;
			}
			if (!Key.isDown(Keyboard.SPACE))
			{
				isSpacePressed = false;
			}
		}
		
		private function checkCollision(e:Event):void
		{
			try
			{
				for (var i:int = 0; i < game.enemies.length; i++)
				{
					collisions = new CollisionList(this, game.enemies[i]);
					var enemiesHit:Array = collisions.checkCollisions();
					
					if (enemiesHit[0] && !_isDead && !game.enemies[i].isDestroyed)
					{
						destroy(game.enemies[i]);
					}
				}
				
				for (var j:int = 0; j < game.portals.length; j++)
				{
					collisions = new CollisionList(this, game.portals[j]);
					var portalsHit:Array = collisions.checkCollisions();
					
					if (portalsHit[0] && !_isDead)
					{
						destroy(game.portals[j]);
					}
				}
				
				for (var k:int = 0; k < game.powerups.length; k++)
				{
					collisions = new CollisionList(this, game.powerups[k]);
					var powerupsHit:Array = collisions.checkCollisions();
					
					if (powerupsHit[0] && !_isDead && !game.powerups[k].isDestroyed)
					{
						game.powerups[k].activate();
					}
				}
			}
			
			catch (e:Error)
			{
				
			}
		}
		
		private function bomb():void
		{
			if (game.gui.bombs > 0)
			{
				for (var i:int = 0; i < game.enemies.length; i++)
				{
 					game.enemies[i].destroy(false);
				}
				
				for (var j:int = 0; j < game.portals.length; j++)
				{
					game.portals[j].destroy(false);
				}
				
				game.gui.bombs -= 1;
			}
		}
		
		public function destroy(enemy:IEnemy):void
		{
			explosionTimer = new Timer(1000);
			explosionTimer.addEventListener(TimerEvent.TIMER, explode);
			explosionTimer.start();
			
			if (fireTimer.hasEventListener(TimerEvent.TIMER))
			{
				fireTimer.removeEventListener(TimerEvent.TIMER, continueFiring);
			}
				
			game.gui.lives -= 1;
			_isDead = true;
			
			if (game.gui.lives > 0)
			{
				game.removeEventListener(Event.ENTER_FRAME, followMouse);
				removeEventListener(Event.ENTER_FRAME, move);
				game.removeEventListener(MouseEvent.MOUSE_DOWN, fire);
				game.removeEventListener(MouseEvent.MOUSE_UP, stopFire);
				
				game.showDeath(enemy, false);
			}
			else
			{
				game.removeEventListener(Event.ENTER_FRAME, followMouse);
				removeEventListener(Event.ENTER_FRAME, move);
				game.removeEventListener(MouseEvent.MOUSE_DOWN, fire);
				game.removeEventListener(MouseEvent.MOUSE_UP, stopFire);
				
				game.showDeath(enemy, true);
			}
		}
		
		private function explode(e:TimerEvent):void
		{
			explosionTimer.removeEventListener(TimerEvent.TIMER, explode);
			
			explodeSound.play();
			
			var explosion:Explosion = new Explosion(x, y, 0xFFFF00, 4);
			game.explosions.push(explosion);
			game.addChild(explosion);
			
			visible = false;
			
			if (game.gui.lives > 0)
			{
				game.addEventListener(MouseEvent.CLICK, game.reset);
			}
			else
			{
				
			}
		}
		
		private function fire(e:MouseEvent):void
		{
			if (!_isFiring)
			{
				var b1:Bullet = new Bullet(game, this, "left");
				game.bullets.push(b1);
				game.addChild(b1);
			
				var b2:Bullet = new Bullet(game, this, "right");
				game.bullets.push(b2);
				game.addChild(b2);
				
				_isFiring = true;
				fireCount = 0;
			}
		}
		
		private function continueFiring():void
		{
			var b1:Bullet = new Bullet(game, this, "left");
			game.bullets.push(b1);
			game.addChild(b1);
			
			var b2:Bullet = new Bullet(game, this, "right");
			game.bullets.push(b2);
			game.addChild(b2);
		}
		
		private function stopFire(e:MouseEvent):void
		{
			_isFiring = false;
		}
		
		public function reset():void
		{
			_isDead = false;
			visible = true;
			x = Main.screenWidth / 2;
			y = Main.screenHeight / 2;
			
			game.addEventListener(Event.ENTER_FRAME, followMouse);
			addEventListener(Event.ENTER_FRAME, move);
			game.addEventListener(MouseEvent.MOUSE_DOWN, fire);
			
			game.addEventListener(MouseEvent.MOUSE_UP, stopFire);
		}
	}

}