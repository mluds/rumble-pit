package MenuComponents.Menus 
{
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import MenuComponents.Cursor;
	import MenuComponents.Manager;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Options extends Menu 
	{
		private var cursor:Cursor;
		private var manager:Manager;
		private var titleFormat:TextFormat;
		private var selectionFormat:TextFormat;
		
		public function Options(manager:Manager, cursor:Cursor, titleFormat:TextFormat, selectionFormat:TextFormat) 
		{
			this.manager = manager;
			this.cursor = cursor;
			this.titleFormat = titleFormat;
			this.selectionFormat = selectionFormat;
			
			super(manager, cursor, titleFormat, selectionFormat);
		}
		
		private function changeDifficulty():void
		{
			
		}
		
		private function changeSFX():void
		{
			
		}
		
		private function changeMusic():void
		{
			
		}
		
		private function back():void
		{
			var start:Start = new Start(manager);
		}
	}

}