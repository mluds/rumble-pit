package  
{
	//{ Import Statements
	
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.text.engine.GroupElement;
	import flash.utils.Proxy;
	import flash.utils.Timer;
	import GameComponents.*;
	import GameComponents.Enemies.BlackHole;
	import GameComponents.Enemies.Enemy;
	import GameComponents.Enemies.Grunt;
	import GameComponents.Enemies.IEnemy;
	import GameComponents.Enemies.Snake;
	import GameComponents.Enemies.Wanderer;
	import GameComponents.Enemies.Weaver;
	import GameComponents.PowerUps.AdditionalBomb;
	import GameComponents.PowerUps.AdditionalLife;
	import MenuComponents.Menus.GameScreen;
	
	//}
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Game extends GameScreen
	{
		//{ Fields
		
		private var spawningEnemies:Boolean;
		private var spawningPortals:Boolean;
		private var spawningBlackHoles:Boolean;
		private var portalTimer:int = 0;
		private var portalDelay:int = 13 * 30;
		private var blackHoleTimer:int = 0;
		private var blackHoleDelay:int = 32 * 30;
		private var enemyTimer:int = 0;
		private var enemyDelay:int = 8 * 30;
		private var enemyTimerCount:int = 0;
		private var _player:Player;
		private var _boundary:Object = new Object();
		private var _bullets:Vector.<Bullet> = new Vector.<Bullet>();
		private var _portalPoints:Vector.<Point> = new Vector.<Point>();
		private var _powerupPoints:Vector.<Point> = new Vector.<Point>();
		private var _portals:Vector.<Portal> = new Vector.<Portal>();
		private var _blackHoles:Vector.<BlackHole> = new Vector.<BlackHole>();
		private var _blackHolePoints:Vector.<Point> = new Vector.<Point>();
		private var _powerups:Array = new Array();
		private var _enemies:Array = new Array();
		private var _explosions:Vector.<Explosion> = new Vector.<Explosion>();
		private var _spawnRings:Vector.<SpawnRing> = new Vector.<SpawnRing>();
		private var _groupSpawns:Vector.<GroupSpawn> = new Vector.<GroupSpawn>();
		private var _gui:Gui;
		private var maxPortals:int;
		private var currentEnemies:Vector.<String> = new Vector.<String>();
		private var enemyOrder:Vector.<String> = new Vector.<String>();
		private var wandererBase:int;
		private var wandererInc:int;
		private var spinnerBase:int;
		private var spinnerInc:int;
		private var weaverBase:int;
		private var weaverInc:int;
		private var snakeBase:int;
		private var snakeInc:Number;
		private var gruntBase:int;
		private var gruntInc:int;
		private var _walls:Vector.<Wall> = new Vector.<Wall>();
		private var _blackHoleTimer:Timer;
		private var maxBlackHoles:int;
		private var initialEnemyDelay:int;
		private var main:Main;
		private var pauseKey:Boolean;
		private var previousPauseKey:Boolean;
		
		//}
		
		//{ Properties
		
		public function get player():Player
		{
			return _player;
		}
		public function get boundary():Object
		{
			return _boundary;
		}
		public function get bullets():Vector.<Bullet>
		{
			return _bullets;
		}
		public function get portalPoints():Vector.<Point>
		{
			return _portalPoints;
		}
		public function get portals():Vector.<Portal>
		{
			return _portals;
		}
		public function get blackHolePoints():Vector.<Point>
		{
			return _blackHolePoints;
		}
		public function get powerups():Array
		{
			return _powerups;
		}
		public function get enemies():Array
		{
			return _enemies;
		}
		public function get explosions():Vector.<Explosion>
		{
			return _explosions;
		}
		public function get spawnRings():Vector.<SpawnRing>
		{
			return _spawnRings;
		}
		public function get groupSpawns():Vector.<GroupSpawn>
		{
			return _groupSpawns;
		}
		public function get gui():Gui
		{
			return _gui;
		}
		/*public function get portalTimer():Timer
		{
			return _portalTimer;
		}*/
		public function get walls():Vector.<Wall>
		{
			return _walls;
		}
		/*public function get blackHoleTimer():Timer
		{
			return _blackHoleTimer;
		}*/
		
		//}
		
		public function Game(main:Main) 
		{
			this.main = main;
			
			var random:int = Math.ceil(Math.random() * 2);
			var music:Sound;
			switch (random)
			{
				case 1: music = new Main.Music1(); break;
				case 2: music = new Main.Music2(); break;
			}
			
			music.play(0, 99999);
			
			initialEnemyDelay = 5000; // Set the starting delay for spawning enemies
			
			maxBlackHoles = 2; // Max amount of black holes and the points where they spawn
			_blackHolePoints.push(
				new Point(3, 6),
				new Point(13, 6));
				
			//loadBoundary();
			
			// Start the game with just wanderers
			currentEnemies.push("wanderer"); 
			
			// Choose the order in which enemies will be added to the spawn list
			enemyOrder.push("grunt", "weaver", "spinner", "snake");
			
			wandererBase = 10;
			wandererInc = 1;
			
			gruntBase = 10;
			gruntInc = 1;
			
			spinnerBase = 6;
			spinnerInc = 1;
			
			weaverBase = 8;
			weaverInc = 1;
			
			snakeBase = 2;
			snakeInc = 0.5;
			
			_portalPoints.push(new Point(2, 2));
			_portalPoints.push(new Point(15, 2));
			_portalPoints.push(new Point(2, 11));
			_portalPoints.push(new Point(15, 11));
			maxPortals = _portalPoints.length;
			
			_powerupPoints.push(new Point(8, -1));
			_powerupPoints.push(new Point(8, 13));
			_powerupPoints.push(new Point( -1, 6));
			_powerupPoints.push(new Point(17, 6));
			
			var grid:Grid = new Grid(Main.screenWidth, Main.screenHeight, Main.cellWidth, Main.cellHeight, 0x0000FF, 0x000000, Main.lineThickness);
			addChild(grid);
			
			var topWall:Wall = new Wall(new Point(0, -1), Main.screenWidth, 0);
			var bottomWall:Wall = new Wall(new Point(0, Main.screenHeight), 
											Main.screenWidth, 0);
			var leftWall:Wall = new Wall(new Point(-1, 0), Main.screenHeight, 90);
			var rightWall:Wall = new Wall(new Point(Main.screenWidth, 0), 
											Main.screenHeight, 90);
			
			_walls.push(topWall, bottomWall, leftWall, rightWall);
			for (var i:int = 0; i < _walls.length; i++)
			{
				addChild(_walls[i]);
			}
		}
		
		private function update(e:Event):void
		{
			checkPause();
			
			for each (var explosion:Explosion in _explosions)
			{
				explosion.update();
			}
			
			if (enemyTimer == enemyDelay && spawningEnemies)
			{
				enemyTimerCount++;
				enemyTimer = 0;
				pickEnemyType();
			}
			
			if (portalTimer == portalDelay && spawningPortals)
			{
				portalTimer = 0;
				generatePortal();
			}
			
			if (blackHoleTimer == blackHoleDelay && spawningBlackHoles)
			{
				blackHoleTimer = 0;
				generateBlackHole();
			}
			
			enemyTimer++;
			portalTimer++;
			blackHoleTimer++;
		}
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, update);
			
			_player = new Player(Main.cellWidth * 0.65, Main.cellHeight * 0.65, this);
			addChild(_player);
			
			var target:CrossHairs = new CrossHairs(this);
			addChild(target);
			
			var cleanupTimer:Timer = new Timer(500);
			cleanupTimer.addEventListener(TimerEvent.TIMER, cleanup);
			cleanupTimer.start();
			
			_gui = new Gui(this, 3, 3, _player);
			addChild(gui);
			
			spawningEnemies = true;
			spawningPortals = true;
			spawningBlackHoles = true;
		}
		
		private function loadBoundary():void
		{
			var top:Sprite = new Sprite();
			top.graphics.moveTo(0, 0);
			top.graphics.lineTo(Main.screenWidth, 0);
			_boundary.top = top;
		}
		
		private function cleanup(e:TimerEvent):void
		{
			for (var i:int = 0; i < _bullets.length; i++)
			{
				if (!(_bullets[i].isActive))
				{
					removeChild(_bullets[i]);
					_bullets[i] = null;
					_bullets.splice(i, 1);
				}
			}
			
			for (var j:int = 0; j < _enemies.length; j++)
			{
				if (_enemies[j].isDestroyed)
				{
					removeChild(_enemies[j]);
					_enemies[j] = null;
					_enemies.splice(j, 1);
				}
			}
			
			for (var k:int = 0; k < _portals.length; k++)
			{
				if (_portals[k].isDestroyed)
				{
					removeChild(_portals[k]);
					_portals[k] = null;
					_portals.splice(k, 1);
				}
			}
			
			for (var q:int = 0; q < _explosions.length; q++)
			{
				if (_explosions[q].isDead)
				{
					removeChild(_explosions[q]);
					_explosions[q] = null;
					_explosions.splice(q, 1);
				}
			}
			
			for (var l:int = 0; l < _spawnRings.length; l++)
			{
				if (_spawnRings[l].isDead)
				{
					removeChild(_spawnRings[l]);
					_spawnRings[l] = null;
					_spawnRings.splice(l, 1);
				}
			}
			
			for (var p:int = 0; p < _groupSpawns.length; p++)
			{
				if (_groupSpawns[p].isDead)
				{
					_groupSpawns[p] = null;
					_groupSpawns.splice(p, 1);
				}
			}
		}
		
		private function generatePortal():void
		{
			if (_portalPoints.length > 0)
			{
				var random:int = Math.round(Math.random() * (_portalPoints.length - 1));
				var randomType:int = Math.round(Math.random() * 3) + 1;
				
				var portal:Portal = new Portal(this, _portalPoints[random], randomType);
				_portalPoints.splice(random, 1);
				addChild(portal);
				
				_portals.push(portal);
				
				if (_portals.length == maxPortals)
				{
					spawningPortals = false;
				}
			}
		}
		
		private function generateBlackHole():void
		{
			if (_blackHolePoints.length > 0)
			{
				var random:int = Math.round(Math.random() * (_blackHolePoints.length - 1));
				
				var blackHole:BlackHole = new BlackHole(_player, this, _blackHolePoints[random]);
				_blackHolePoints.splice(random, 1);
				addChild(blackHole);
				
				_blackHoles.push(blackHole);
				_enemies.push(blackHole);
				
				if (_blackHoles.length == maxBlackHoles)
				{
					//_blackHoleTimer.stop();
				}
			}
		}
		
		public function generatePowerup():void
		{
			var random:int = Math.round(Math.random() * (_powerupPoints.length - 1));
			
			var powerup:AdditionalLife = new AdditionalLife(gui, _player, _powerupPoints[random]);
			addChild(powerup);
			
			_powerups.push(powerup);
		}
		
		public function showDeath(enemy:IEnemy, gameOver:Boolean):void
		{
			//_portalTimer.stop();
			//enemyTimer.stop();
			_blackHoleTimer.stop();
			enemy.deactivate();
			
			for (var i:int = 0; i < _enemies.length; i++)
			{
				if (_enemies[i] != enemy)
				{
					_enemies[i].deactivate();
					_enemies[i].visible = false;
					_enemies[i].isDestroyed = true;
				}
			}
			
			for (var j:int = 0; j < _portals.length; j++)
			{
				if (_portals[j] != enemy)
				{
					_portals[j].deactivate();
					_portals[j].visible = false;
					_portals[j].isDestroyed = true;
				}
			}
			
			for (var k:int = 0; k < _groupSpawns.length; k++)
			{
				_groupSpawns[k].isDead = true;
			}
		}
		
		public function reset(e:MouseEvent):void
		{
			_player.reset();
			_gui.multiplier = 1;
			
			for (var i:int = 0; i < _enemies.length; i++)
			{
				try
				{
					removeChild(_enemies[i]);
				}
				catch (e:Error)
				{
					
				}
			}
			for (var k:int = 0; k < _portals.length; k++)
			{
				try 
				{
					removeChild(_portals[k]);
				}
				catch (e:Error)
				{
					
				}
			}
			for (var j:int = 0; j < _powerups.length; j++)
			{
				try
				{
					removeChild(_powerups[j]);
				}
				catch (e:Error)
				{
					
				}
			}
			
			_enemies.splice(0, _enemies.length);
			_portals.splice(0, _portals.length);
			_powerups.splice(0, _powerups.length);
			
			//_portalTimer.start();
			//enemyTimer.start();
			_blackHoleTimer.start();
			removeEventListener(MouseEvent.CLICK, reset);
		}
		
		private function pickEnemyType():void
		{
			if (enemyDelay > 3 * 30)
			{
				enemyDelay -= 3;
			}

			if (enemyTimerCount % 5 == 0 && enemyTimerCount / 5 <= enemyOrder.length)
			{
				currentEnemies.push(enemyOrder[(enemyTimerCount / 5) - 1]);
			}
			
			var randomType:int = Math.round(Math.random() * (currentEnemies.length - 1));
			
			for (;;)
			{
				var randomX:int = Math.round(Math.random() * (Main.screenWidth - Main.cellWidth * 2) + Main.cellWidth);
				var randomY:int = Math.round(Math.random() * (Main.screenHeight - Main.cellHeight * 2) + Main.cellHeight);
				var rPoint:Point = new Point(randomX, randomY);
				var isOccupied:Boolean = false;
				
				var xDiff:Number = rPoint.x - _player.x;
				var yDiff:Number = rPoint.y - _player.y;
				var distance:Number = Math.sqrt(Math.pow(xDiff, 2) + Math.pow(yDiff, 2));
				
				if (distance < _player.enemyBoundaryRadius)
				{
					isOccupied = true;
				}
				
				if (!isOccupied)
				{
					break;
				}
			}
			
			switch (currentEnemies[randomType])
			{
				case "wanderer" : 
					var wanderers:int = wandererBase + (Math.floor(enemyTimerCount / 5) * wandererInc);
					var wandererSwarm:GroupSpawn = new GroupSpawn(this, "wanderer", rPoint, wandererBase, Main.cellWidth / 2);
					_groupSpawns.push(wandererSwarm);
					break;
				case "grunt" : 
					var grunts:int = gruntBase + (Math.floor(enemyTimerCount / 5) * gruntInc);
					var gruntSwarm:GroupSpawn = new GroupSpawn(this, "grunt", rPoint, gruntBase, Main.cellWidth / 2); 
					_groupSpawns.push(gruntSwarm);
					break;
				case "weaver" :
					var weavers:int = weaverBase + (Math.floor(enemyTimerCount / 5) * weaverInc);
					var weaverSwarm:GroupSpawn = new GroupSpawn(this, "weaver", rPoint, weaverBase, Main.cellWidth / 2);
					_groupSpawns.push(weaverSwarm);
					break;
				case "spinner" :
					var spinners:int = spinnerBase + (Math.floor(enemyTimerCount / 5) * spinnerInc);
					var spinnerSwarm:GroupSpawn = new GroupSpawn(this, "spinner", rPoint, spinnerBase, Main.cellWidth / 2);
					_groupSpawns.push(spinnerSwarm);
					break;
				case "snake" :
					var snakes:int = snakeBase + (Math.floor(enemyTimerCount / 5) * spinnerInc);
					var snakeSwarm:GroupSpawn = new GroupSpawn(this, "snake", rPoint, snakeBase, Main.cellWidth / 2);
					_groupSpawns.push(snakeSwarm);
					break;
			}
		}
		
		private function checkPause():void
		{
			pauseKey = Key.isDown(27);
			
			if (pauseKey && !previousPauseKey)
			{
			}
			
			previousPauseKey = pauseKey;
		}
		
		public function pause():void
		{
			spawningEnemies = false;
			spawningPortals = false;
			spawningBlackHoles = false;
			
			try
			{
				for (var i:int = 0; i < _enemies.length; i++)
				{
					_enemies[i].pause();
				}
				
				for (var k:int = 0; k < _portals.length; k++)
				{
					_portals[i].pause();
				}
			}
			catch (e:Error)
			{
				
			}
		}
		
		public function resume():void
		{
			for (var i:int = 0; i < _enemies.length; i++)
			{
				_enemies[i].resume();
			}
			
			for (var k:int = 0; k < _portals.length; k++)
			{
				_portals[i].resume();
			}
		}
	}

}