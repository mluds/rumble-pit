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
	public class Pause extends Menu implements IMenu 
	{
		private var cursor:Cursor;
		private var manager:Manager;
		private var titleFormat:TextFormat
		private var selectionFormat:TextFormat;
		
		public function Pause(manager:Manager, cursor:Cursor, titleFormat:TextFormat, selectionFormat:TextFormat) 
		{
			super(manager, cursor, titleFormat, selectionFormat);
		}
		
		private function resume():void
		{
			
		}
	}

}