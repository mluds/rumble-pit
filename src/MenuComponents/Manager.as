package MenuComponents 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.*;
	import flash.utils.Timer;
	import GameComponents.Explosion;
	import GameComponents.Grid;
	import MenuComponents.Menus.IScreen;
	import MenuComponents.Menus.GameScreen;
	import MenuComponents.Menus.Options;
	import MenuComponents.Menus.Pause;
	import MenuComponents.Menus.Start;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Manager extends Sprite 
	{
		private var main:Main;
		private var _titleFormat:TextFormat;
		private var _selectionFormat:TextFormat;
		private var cursor:Cursor;
		
		//{ Properties
		
		public function get titleFormat():TextFormat
		{
			return _titleFormat;
		}
		
		public function get selectionFormat():TextFormat
		{
			return _selectionFormat;
		}
		
		//}
		
		public function Manager(main:Main) 
		{
			this.main = main;
			
			_titleFormat = new TextFormat("Arial", 22, 0xFFFF00);
			titleFormat.align = TextFormatAlign.CENTER;
			_selectionFormat = new TextFormat("Arial", 16, 0xFFFF00);
			selectionFormat.align = TextFormatAlign.LEFT;
			
			cursor = new Cursor(this);
			addChild(cursor);
		}
		
		public function addScreen(screen:IScreen):void
		{
			var screenObject:* = GameScreen(screen);
			
			addChild(screenObject);
		}
		
		public function removeScreen(screen:IScreen):void
		{
			var screenObject:* = GameScreen(screen);
			
			removeChild(screenObject);
		}
	}

}