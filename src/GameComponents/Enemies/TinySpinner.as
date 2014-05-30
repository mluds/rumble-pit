package GameComponents.Enemies 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import GameComponents.Bullet;
	import GameComponents.Explosion;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class TinySpinner extends Sprite implements IEnemy
	{
		private var game:Game;
		private var spinner:Spinner;
		private var angleDegrees:int;
		private var origin:Point = new Point();
		private var distance:int;
		private var speed:int;
		private var health:int;
		private var score:int;
		private var _resistant:Boolean = false;
		public function resistant():Boolean
		{
			return _resistant;
		}
		
		private var _isDestroyed:Boolean;
		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		public function set isDestroyed(v:Boolean):void
		{
			_isDestroyed = v;
		}
		
		private var destroySound:Sound;
		
		public function TinySpinner(game:Game, spinner:Spinner, angleDegrees:int)
		{
			destroySound = new Main.spinnerbreak2();
			
			this.game = game;
			this.spinner = spinner;
			health = 1;
			score = 10;
			
			draw();
			
			distance = 15;
			speed = 5;
			
			this.angleDegrees = angleDegrees;
			origin.x = spinner.x;
			origin.y = spinner.y;
			
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		public function deactivate():void
		{
			removeEventListener(Event.ENTER_FRAME, move);
		}
		
		private function draw():void
		{
			var p:Sprite = new Sprite();
			var g:Graphics = p.graphics;
			
			g.lineStyle(1, 0xFF00FF);
			g.drawRect( -(Main.cellWidth / 8) , -(Main.cellHeight / 8), Main.cellWidth / 4, Main.cellHeight / 4);
			g.moveTo(-(Main.cellWidth / 8), -(Main.cellHeight / 8));
			g.lineTo(Main.cellWidth / 8, Main.cellHeight / 8);
			g.moveTo(-(Main.cellWidth / 8), (Main.cellHeight / 8));
			g.lineTo(Main.cellWidth / 8, -Main.cellHeight / 8);
			
			addChild(p);
		}
		
		private function move(e:Event):void
		{
			var angle:Number = angleDegrees * (Math.PI / 180);
			
			x = distance * Math.cos(angle) + spinner.x;
			y = distance * Math.sin(angle) + spinner.y;
			
			angleDegrees -= speed;
			
			rotation += 2;
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
			destroySound.play();
			
			var explosion:Explosion = new Explosion(x, y, 0xFF00FF, 0.5);
			game.explosions.push(explosion);
			game.addChild(explosion);
			
			visible = false;
			_isDestroyed = true;
			
			if (isPlayer)
			{
				game.gui.killCount += 1;
				game.gui.score = score;
			}
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