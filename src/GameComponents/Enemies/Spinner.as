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
	import GameComponents.*;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Spinner extends Enemy implements IEnemy
	{
		private var tinySpinners:Vector.<TinySpinner> = new Vector.<TinySpinner>();
		private var cleanupTimer:Timer;
		private var breakSound:Sound;
		
		public function Spinner(game:Game, portal:Portal, position:Point = null) 
		{
			//breakSound = new Main.spinnerbreak();
			
			health = 2;
			score = 20;
			color = 0xFF00FF;
			
			draw(color);
			
			addEventListener(Event.ENTER_FRAME, move);
			
			super(game, portal, position);
		}
		
		override protected function draw(color:uint):void
		{
			var p:Sprite = new Sprite();
			var g:Graphics = p.graphics;
			
			g.lineStyle(1, color);
			g.drawRect( -(Main.cellWidth / 4) , -(Main.cellHeight / 4), Main.cellWidth / 2, Main.cellHeight / 2);
			g.moveTo(-(Main.cellWidth / 4), -(Main.cellHeight / 4));
			g.lineTo(Main.cellWidth / 4, Main.cellHeight / 4);
			g.moveTo(-(Main.cellWidth / 4), (Main.cellHeight / 4));
			g.lineTo(Main.cellWidth / 4, -Main.cellHeight / 4);
			
			addChild(p);
		}
		
		override protected function move(e:Event):void
		{	
			var xDiff:int = x - game.player.x;
			var yDiff:int = y - game.player.y;
			var angle:Number = Math.atan2(yDiff, xDiff);
			
			x -= Math.cos(angle) * 2;
			y -= Math.sin(angle) * 2;
			
			rotation += 1;
		}
		
		private function cleanup(e:TimerEvent):void
		{
			for (var i:int = 0; i < tinySpinners.length; i++)
			{
				if (tinySpinners[i].isDestroyed)
				{
					game.removeChild(tinySpinners[i]);
					tinySpinners.splice(i, 1);
				}
			}
		}
		
		override public function destroy(isPlayer:Boolean):void
		{
			//breakSound.play();
			
			var explosion:Explosion = new Explosion(x, y, color, 1);
			game.explosions.push(explosion);
			game.addChild(explosion);
			
			visible = false;
			_isDestroyed = true;
			
			if (isPlayer)
			{
				for (var i:int = 0; i < 360; i += 120)
				{
					var tiny:TinySpinner = new TinySpinner(game, this, i);
					game.enemies.push(tiny);
					game.addChild(tiny);
				}
				
				cleanupTimer = new Timer(1000);
				cleanupTimer.addEventListener(TimerEvent.TIMER, cleanup);
				cleanupTimer.start();
			}
			
			if (isPlayer)
			{
				game.gui.killCount += 1;
				game.gui.score = score;
			}
		}
	}

}