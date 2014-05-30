package GameComponents
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class CrossHairs extends Sprite 
	{
		private var game:Game;
		
		public function CrossHairs(game:Game) 
		{
			this.game = game;
			
			draw();
			game.addEventListener(MouseEvent.MOUSE_MOVE, followMouse);
			addEventListener(Event.ENTER_FRAME, rotate);
		}
		
		private function draw():void
		{
			var crossHairs:Sprite = new Sprite();
			var c:Graphics = crossHairs.graphics;
			
			var corner:int = Math.round((Main.screenWidth * 0.015) * Math.cos(Math.sqrt(2) / 2));
			
			c.lineStyle(1, 0xFFFF00, 0.8);
			c.moveTo(0, -(Main.screenWidth * 0.015));
			c.lineTo(0, Main.screenWidth * 0.015);
			c.moveTo(-(Main.screenWidth * 0.015), 0);
			c.lineTo(Main.screenWidth * 0.015, 0);
			c.moveTo( -corner, corner);
			c.lineTo(corner, -corner);
			c.moveTo( -corner, -corner);
			c.lineTo(corner, corner);
			
			addChild(crossHairs);
		}
		
		private function followMouse(e:MouseEvent):void
		{
			x = game.mouseX;
			y = game.mouseY;
		}
		
		private function rotate(e:Event):void
		{
			rotation += 4;
		}
	}

}