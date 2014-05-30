package GameComponents.Enemies 
{
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
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Snake extends Sprite implements ISnake
	{
		private var game:Game;
		private var target:Point;
		private var color:uint;
		private var score:int;
		private var bodyLength:int;
		private var _radius:int;
		public function get radius():int
		{
			return _radius;
		}
		private var speed:int;
		public function get xPos():Number
		{
			return x;
		}
		public function get yPos():Number
		{
			return y;
		}
		private var _isDestroyed:Boolean;
		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		private var _isDead:Boolean;
		public function get isDead():Boolean
		{
			return _isDead;
		}
		public function set isDestroyed(v:Boolean):void
		{
			_isDestroyed = v;
		}
		private var bodyParts:Vector.<SnakeBody>;
		private var angle:Number;
		private var explodeTimer:Timer;
		protected var _resistant:Boolean = true;
		public function get resistant():Boolean
		{
			return _resistant;
		}
		private var index:int;
		
		private var destroySound:Sound;
		
		public function Snake(game:Game, position:Point) 
		{
			destroySound = new Main.snake();
			
			this.game = game;
			color = 0xFF0000;
			speed = 3;
			score = 20;
			_radius = 8;
			bodyLength = 13;
			bodyParts = new Vector.<SnakeBody>();
			
			draw();
			
			x = position.x;
			y = position.y;
			
			target = setNextPoint();
			convertToPixels(target);
			
			angle = Math.atan2(target.y - y, target.x - x);
			createBody();
			
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function draw():void
		{
			var head:Sprite = new Sprite();
			var g:Graphics = head.graphics;
				
			g.lineStyle(1, color);
			g.drawCircle(0, 0, _radius);
				
			addChild(head);
		}
		
		private function createBody():void
		{
			for (var i:int = 0; i < bodyLength; i++)
			{
				var body:SnakeBody;
				
				if (i == 0)
				{
					body = new SnakeBody(game, this, new Point(x, y), angle)
				}
				else
				{
					body = new SnakeBody(game, bodyParts[i - 1], new Point(x, y), angle);
				}
				
				game.enemies.push(body);
				game.addChild(body);
				bodyParts.push(body);
			}
		}
		
		private function setNextPoint():Point
		{
			var x:int = Math.round(1 + (Math.random() * ((Main.screenWidth / Main.cellWidth) - 1)));
			var y:int = Math.round(1 + (Math.random() * ((Main.screenHeight / Main.cellHeight) - 1)));
			
			return new Point(x, y);
		}
		
		private function convertToPixels(point:Point):void
		{
			point.x = (point.x * Main.cellWidth) - (Main.cellWidth / 2);
			point.y = (point.y * Main.cellHeight) - (Main.cellHeight / 2);
		}
		
		private function move(e:Event):void
		{
			var xDiff:Number = target.x - x;
			var yDiff:Number = target.y - y;
			var angle:Number = Math.atan2(yDiff, xDiff);
			var vX:Number = Math.cos(angle) * speed;
			var vY:Number = Math.sin(angle) * speed;
			
			if (Math.abs(xDiff) > Math.abs(vX) && Math.abs(yDiff) > Math.abs(vY))
			{
				x += vX;
				y += vY;
			}
			else
			{
				target = setNextPoint();
				convertToPixels(target);
			}
		}
		
		public function deactivate():void
		{
			
		}
		
		public function hit(isPlayer:Boolean):void
		{
			destroy(isPlayer);
		}
		
		private function chainExplosion(e:TimerEvent):void
		{
			destroySound.play();
				
			bodyParts[index].destroy(false);
			index++;
				
			if (index > bodyParts.length - 1)
			{
				explodeTimer.stop();
				explodeTimer.removeEventListener(TimerEvent.TIMER, chainExplosion);
				_isDestroyed = true;
			}
		}
		
		public function destroy(isPlayer:Boolean):void
		{
			var explosion:Explosion = new Explosion(x, y, color, 2);
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
			
			explodeTimer = new Timer(50);
			explodeTimer.addEventListener(TimerEvent.TIMER, chainExplosion);
			explodeTimer.start();
		}
	}

}