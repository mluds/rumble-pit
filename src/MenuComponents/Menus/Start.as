package MenuComponents.Menus 
{
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import MenuComponents.Cursor;
	import MenuComponents.Manager;
	import MenuComponents.Selection;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Start extends Menu 
	{
		private var cursor:Cursor;
		private var titleFormat:TextFormat;
		private var selectionFormat:TextFormat;
		private var game:Game;
		
		public function Start(game:Game, cursor:Cursor, titleFormat:TextFormat, selectionFormat:TextFormat) 
		{
			this.cursor = cursor;
			this.titleFormat = titleFormat;
			this.selectionFormat = selectionFormat;
			this.game = game;
			
			super(game, cursor, titleFormat, selectionFormat);
			
			var arcade:Selection = new Selection("Arcade", selectionFormat);
			var options:Selection = new Selection("Options", selectionFormat);
			
			arcade.selected = startGame;
			options.selected = optionsMenu;
			
			addSelection(arcade);
			addSelection(options);
		}
		
		private function startGame():void
		{
			game.start();
			deactivate();
		}
		
		private function optionsMenu():void
		{
			
		}
	}

}