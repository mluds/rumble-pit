package GameComponents.PowerUps 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import GameComponents.Player;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class AdditionalLife extends PowerUp implements IPowerUp 
	{
		public function AdditionalLife(gui:Gui, player:Player, point:Point) 
		{
			title = "+1 Life";
			super(gui, player, point);
		}
		
		override protected function drawIcon():void
		{
			var width:int = Main.cellWidth / 3;
			var height:int = Main.cellHeight / 3;
			
			var g:Graphics = icon.graphics;
			
			g.lineStyle(1, color);
			
			g.moveTo(1, -(height / 2));
			g.lineTo( -(width / 2), -(height / 4));
			
			g.lineTo( -(width / 4), (height / 2));
			g.lineTo( -(width / 4), 0);
			g.lineTo( 1, -(height / 6));
			g.lineTo( (width / 4), 0);
			g.lineTo( (width / 4), (height / 2));
			g.lineTo( (width / 2) + 1, -(height / 4));
			g.lineTo(1, -(height / 2));
			
			addChild(icon);
		}
		
		override public function activate():void
		{
			//activateSound.play();
			
			removeEventListener(Event.ENTER_FRAME, update);
			
			gui.fadeStrings.push(title);
			visible = false;
			_isDestroyed = true;
			
			gui.lives++;
		}
	}

}