package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class XMLLoader 
	{
		//{ Fields
		
		private var game:Game;
		private var url:String;
		private var request:URLRequest;
		private var loader:URLLoader;
		private var result:XML;
		
		private var _difficulty:String;
		public function get difficulty():String
		{
			_difficulty = String(result..difficulty);
			
			return _difficulty;
		}
		public function set difficulty(v:String):void
		{
			result..difficulty = v;
		}
		
		public function XMLLoader(game:Game, url:String) 
		{
			this.game = game;
			this.url = url;
			
			request = new URLRequest(url);
			loader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, load);
		}
		
		private function load(e:Event):void
		{
			result = XML(loader.data);
			
			game.init();
		}
	}

}