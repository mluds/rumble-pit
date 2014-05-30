package 
{
	//{ Import Statements
	
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	import flash.events.Event;
	import MenuComponents.Cursor;
	import MenuComponents.Manager;
	import MenuComponents.Menus.Pause;
	import MenuComponents.Menus.Start;
	
	//}
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Main extends Sprite 
	{
		//{ Embed Sources
		
		[Embed(source = '../lib/Music/rumblePit1.mp3')]
		public static const Music1:Class;
		
		[Embed(source = '../lib/Music/rumblePit2.mp3')]
		public static const Music2:Class;
		
		[Embed(source = '../lib/SFX/blackHoleExplode.mp3')]
		public static const blackHoleExplode:Class;
		
		[Embed(source = '../lib/SFX/explosion.mp3')]
		public static const explosion:Class;
		
		[Embed(source = '../lib/SFX/hit.mp3')]
		public static const hit:Class;
		
		[Embed(source = '../lib/SFX/laser.mp3')]
		public static const laser:Class;
		
		[Embed(source = '../lib/SFX/PlayerExplode.mp3')]
		public static const PlayerExplode:Class;
		
		[Embed(source = '../lib/SFX/powerup.mp3')]
		public static const powerup:Class;
		
		[Embed(source = '../lib/SFX/proton.mp3')]
		public static const proton:Class;
		
		[Embed(source = '../lib/SFX/snake.mp3')]
		public static const snake:Class;
		
		[Embed(source = '../lib/SFX/spinnerbreak.mp3')]
		public static const spinnerbreak:Class;
		
		[Embed(source = '../lib/SFX/spinnerbreak2.mp3')]
		public static const spinnerbreak2:Class;
		
		//}
		
		//{ Static Fields
		
		public static var screenWidth:int;
		public static var screenHeight:int;
		public static var cellWidth:int;
		public static var cellHeight:int;
		public static var lineThickness:int;
		
		//}
		
		//{ Fields
		//}
		
		public function Main():void 
		{
			screenWidth = stage.stageWidth;
			screenHeight = stage.stageHeight;
			
			cellWidth = screenWidth / 16;
			cellHeight = screenHeight / 12;
			
			lineThickness = screenWidth * 0.0025;
			
			Key.initialize(stage);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Mouse.hide();
			
			// Initialize a new game
			var game:Game = new Game(this);
			addChild(game);
			
			// Create cursor for use with the menus
			var cursor:Cursor = new Cursor(game);
			addChild(cursor);
			
			// Create text formats for the menus
			var titleFormat:TextFormat = new TextFormat("Arial", 22, 0xFFFF00);
			titleFormat.align = TextFormatAlign.CENTER;
			var selectionFormat:TextFormat = new TextFormat("Arial", 16, 0xFFFF00);
			selectionFormat.align = TextFormatAlign.LEFT;
			
			// Create a new start menu
			var startMenu:Start = new Start(game, cursor, titleFormat, selectionFormat);
			addChild(startMenu);
		}
	}
}