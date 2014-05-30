package MenuComponents 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Main;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Cursor extends Sprite 
	{
		private var game:Game;
		
		public function Cursor(game:Game) 
		{
			x = Main.cellWidth * 6;
			y = 100;
			
			this.game = game;
			
			draw();
			
			game.addEventListener(MouseEvent.MOUSE_MOVE, move);
			addEventListener(Event.ENTER_FRAME, rotate);
		}
		
		private function draw():void
		{
			var cursor:Sprite = new Sprite();
			var c:Graphics = cursor.graphics;
			
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
			
			addChild(cursor);
		}
		
		private function move(e:MouseEvent):void
		{
			y = game.mouseY;
		}
		
		private function rotate(e:Event):void
		{
			rotation += 4;
		}
	}

}