package GameComponents.Enemies 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import GameComponents.Bullet;
	import GameComponents.Explosion;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class SnakeBody extends Sprite implements ISnake
	{
		private var game:Game;
		private var snake:ISnake;
		private var speed:int;
		private var color:uint;
		private var _radius:int;
		public function get radius():int
		{
			return _radius;
		}
		private var _isDestroyed:Boolean;
		public function get xPos():Number
		{
			return x;
		}
		public function get yPos():Number
		{
			return y;
		}
		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		public function set isDestroyed(v:Boolean):void
		{
			_isDestroyed = v;
		}
		protected var _resistant:Boolean = true;
		public function get resistant():Boolean
		{
			return _resistant;
		}
		
		public function SnakeBody(game:Game, snake:ISnake, position:Point, angle:Number) 
		{
			this.game = game;
			this.snake = snake;
			color = 0xFFFF00;
			x = position.x;
			y = position.y;
			speed = 3;
			_radius = 6;
			
			draw();
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function draw():void
		{
			var body:Sprite = new Sprite();
			var g:Graphics = body.graphics;
				
			g.lineStyle(1, color);
			g.drawCircle(0, 0, _radius);
				
			addChild(body);
		}
		
		private function move(e:Event):void
		{
			var xDiff:Number= snake.xPos - x;
			var yDiff:Number = snake.yPos - y;
			var angle:Number = Math.atan2(yDiff, xDiff);
			
			var vX:Number = Math.cos(angle) * speed;
			var vY:Number = Math.sin(angle) * speed;
			
			var centerDistX:Number = Math.cos(angle) * (snake.radius + _radius);
			var centerDistY:Number = Math.sin(angle) * (snake.radius + _radius);
			
			if (Math.abs(xDiff) > Math.abs(centerDistX) && Math.abs(yDiff) > Math.abs(centerDistY))
			{
				if (Math.abs(xDiff) > Math.abs(vX) && Math.abs(yDiff) > Math.abs(vY))
				{
					x += vX;
					y += vY;
				}
				else 
				{
					x += xDiff;
					y += yDiff;
				}
			}
			
		}
		
		public function deactivate():void
		{
			
		}
		
		public function hit(bullet:Bullet):void
		{
			
		}
		
		public function destroy(isPlayer:Boolean):void
		{
			var explosion:Explosion = new Explosion(x, y, color, 0.5);
			game.explosions.push(explosion);
			game.addChild(explosion);
			
			removeEventListener(Event.ENTER_FRAME, move);
			
			visible = false;
			_isDestroyed = true;
		}
	}

}