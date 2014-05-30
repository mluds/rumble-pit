package GameComponents 
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import GameComponents.Enemies.Grunt;
	import GameComponents.Enemies.IEnemy;
	import GameComponents.Enemies.Mayfly;
	import GameComponents.Enemies.Proton;
	import GameComponents.Enemies.Snake;
	import GameComponents.Enemies.Spinner;
	import GameComponents.Enemies.Wanderer;
	import GameComponents.Enemies.Weaver;
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class GroupSpawn extends Sprite
	{
		//{ Fields
		
		private var timer:Timer;
		private var game:Game;
		private var position:Point;
		private var quantity:int;
		private var type:String;
		private var separation:Number;
		private var _isDead:Boolean;
		private var spawnTimer:int;
		private var spawnDelay:int;
		
		//}
		
		//{ Properties
		
		public function get isDead():Boolean
		{
			return _isDead;
		}
		public function set isDead(v:Boolean):void
		{
			_isDead = v;
			
			if (_isDead)
			{
				timer.removeEventListener(TimerEvent.TIMER, spawn);
			}
		}
		
		//}
		
		public function GroupSpawn(game:Game, type:String, position:Point, quantity:int, separation:Number, timeInterval:int = 0) 
		{
			this.game = game;
			this.position = position;
			this.quantity = quantity;
			this.type = type;
			this.separation = separation;
			
			if (timeInterval)
			{
				spawnDelay = timeInterval / 1000 * 30;
			}
			else
			{
				spawnDelay = 10;
			}
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function spawn():void
		{
			var newPosition:Point = new Point();
			var ticks:int = Math.floor(spawnTimer / spawnDelay);
			
			if (ticks == 1)
			{
				newPosition = position;
			}
			else
			{
				var randomAngle:Number = (Math.random() * 360) * (Math.PI / 180);
				
				newPosition.x = position.x + Math.cos(randomAngle) * separation;
				newPosition.y = position.y + Math.sin(randomAngle) * separation;
			}
			
			switch (type)
			{
				case "wanderer" : var wanderer:Wanderer = new Wanderer(game, null, newPosition);
					game.addChild(wanderer);
					game.enemies.push(wanderer);
					break;
				case "grunt" : var grunt:Grunt = new Grunt(game, null, newPosition);
					game.addChild(grunt);
					game.enemies.push(grunt);
					break;
				case "weaver" : var weaver:Weaver = new Weaver(game, game.player, null, newPosition);
					game.addChild(weaver);
					game.enemies.push(weaver);
					break;
				case "spinner" : var spinner:Spinner = new Spinner(game, null, newPosition);
					game.addChild(spinner);
					game.enemies.push(spinner);
					break;
				case "snake" : var snake:Snake = new Snake(game, newPosition);
					game.addChild(snake);
					game.enemies.push(snake);
					break;
				case "mayfly" : var mayfly:Mayfly = new Mayfly(game, game.player, newPosition);
					game.addChild(mayfly);
					game.enemies.push(mayfly);
					break;
				case "proton" : var proton:Proton = new Proton(game, game.player, newPosition);
					game.addChild(proton);
					game.enemies.push(proton);
					break;
			}
			
			if (ticks == quantity)
			{
				isDead = true;
			}
		}
		
		private function update(e:Event):void
		{
			if (spawnTimer == spawnDelay)
			{
				spawnTimer = 0;
				spawn();
			}
			spawnTimer++;
		}
	}

}