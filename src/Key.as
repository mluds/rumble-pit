package 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Key 
	{
		private static var initialized:Boolean = false;		// marks whether or not the class has been initialized
		private static var keysDown:Object = new Object();	// stores key codes of all keys pressed
		
		/**
		 * Initializes the key class creating assigning event
		 * handlers to capture necessary key events from the stage
		 */
		public static function initialize(stage:Stage):void {
			if (!initialized) {
				// assign listeners for key presses and deactivation of the Player
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
				stage.addEventListener(Event.DEACTIVATE, clearKeys);
				
				// mark initialization as true so redundant
				// calls do not reassign the event handlers
				initialized = true;
			}
		}
		
		/**
		 * Returns true or false if the key represented by the
		 * keyCode passed is being pressed
		 */
		public static function isDown(keyCode:uint):Boolean {
			if (!initialized) {
				// throw an error if isDown is used
				// prior to Key class initialization
				throw new Error("Key class has yet been initialized.");
			}
			return Boolean(keyCode in keysDown);
		}
		
		/**
		 * Event handler for capturing keys being pressed
		 */
		private static function keyPressed(event:KeyboardEvent):void {
			// create a property in keysDown with the name of the keyCode
			keysDown[event.keyCode] = true;
		}
		
		/**
		 * Event handler for capturing keys being released
		 */
		private static function keyReleased(event:KeyboardEvent):void {
			if (event.keyCode in keysDown) {
				// delete the property in keysDown if it exists
				delete keysDown[event.keyCode];
			}
		}
		
		/**
		 * Event handler for Flash Player deactivation
		 */
		private static function clearKeys(event:Event):void {
			// clear all keys in keysDown since the Player cannot
			// detect keys being pressed or released when not focused
			keysDown = new Object();
		}
	}
}