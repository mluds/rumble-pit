package GameComponents.PowerUps 
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import GameComponents.Player;
	import flash.events.Event;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class AdditionalBomb extends PowerUp implements IPowerUp 
	{
		
		public function AdditionalBomb(gui:Gui, Player:Player, point:Point) 
		{
			title = "+1 Bomb";
			super(gui, Player, point);
		}
		
		override protected function drawIcon():void
		{
			var width:int = Main.cellWidth / 3;
			var height:int = Main.cellHeight / 3;
			
			var g:Graphics = icon.graphics;
			
			g.lineStyle(1, color);
			g.drawCircle(0, 0, width / 2);
			g.drawCircle(0, 0, width / 3);
			g.moveTo( -width / 2, 0);
			g.lineTo(width / 2, 0);
			
			addChild(icon);
		}
		
		override public function activate():void
		{
			//activateSound.play();
			
			removeEventListener(Event.ENTER_FRAME, update);
			
			gui.fadeStrings.push(title);
			visible = false;
			_isDestroyed = true;
			
			gui.bombs++;
		}
	}

}