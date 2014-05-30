package GameComponents.PowerUps 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import GameComponents.Player;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class PowerUp extends Sprite 
	{
		protected var title:String;
		protected var gui:Gui;
		protected var _isDestroyed:Boolean;
		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
		private var player:Player;
		private var speed:int;
		private var barrierDelay:int;
		private var barrierSpeed:int;
		private var barrierDirection:int;
		private var maxRadius:int;
		private var minRadius:int;
		protected var color:uint;
		private var radius:int;
		
		private var barrier:Sprite;
		protected var icon:Sprite;
		
		protected var activateSound:Sound;
		
		public function PowerUp(gui:Gui, player:Player, startPoint:Point) 
		{
			//activateSound = Main.powerup();
			
			this.gui = gui;
			this.player = player;
			speed = 2;
			barrierDelay = 0;
			barrierSpeed = 1;
			barrierDirection = 1;
			maxRadius = 1.01 * (Main.cellWidth / 2);
			minRadius = 0.99 * (Main.cellWidth / 2);
			color = 0xFFFF00;
			radius = Main.cellWidth / 2;
			barrier = new Sprite();
			icon = new Sprite();
			
			drawBarrier();
			addChild(barrier);
			
			drawIcon();
			addChild(icon);
			
			x = startPoint.x * Main.cellWidth;
			y = startPoint.y * Main.cellHeight;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function drawBarrier():void
		{
			barrier.graphics.clear();
			barrier.graphics.lineStyle(1, color);
			barrier.graphics.drawCircle(0, 0, radius);
		}
		
		protected function drawIcon():void
		{
			
		}
		
		protected function update(e:Event):void
		{
			barrierDelay += 1;
			
			var xDiff:int = x - player.x;
			var yDiff:int = y - player.y;
			var angle:Number = Math.atan2(yDiff, xDiff);
			
			if (barrierDelay % 3 == 0)
			{
				radius += barrierSpeed * barrierDirection;
				if (radius > maxRadius || radius < minRadius)
				{
					barrierDirection *= -1;
				}
				drawBarrier();
			}
			
			x -= Math.cos(angle) * speed;
			y -= Math.sin(angle) * speed;
		}
		
		public function activate():void
		{
			
		}
	}

}