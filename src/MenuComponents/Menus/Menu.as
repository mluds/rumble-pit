package MenuComponents.Menus 
{
	import flash.display.InterpolationMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import MenuComponents.Cursor;
	import MenuComponents.Manager;
	import MenuComponents.Selection;
	import flash.utils.Timer;
	import GameComponents.Explosion;
	import GameComponents.Grid;
	import Main;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Menu extends GameScreen
	{
		private var game:Game;
		private var _selections:Vector.<Selection> = new Vector.<Selection>();
		public function get selections():Vector.<Selection>
		{
			return _selections;
		}
		private var cursor:Cursor;
		protected var selection:int;
		private var _verticalSpacing:Number = Main.cellHeight;
		private var explosionTimer:Timer;
		private var explosions:Vector.<Explosion> = new Vector.<Explosion>();
		private var cleanupTimer:Timer;
		
		public function Menu(game:Game, cursor:Cursor, titleFormat:TextFormat, selectionFormat:TextFormat) 
		{
			this.game = game;
			this.cursor = cursor;
			
			cleanupTimer = new Timer(3000);
			cleanupTimer.addEventListener(TimerEvent.TIMER, cleanup);
			cleanupTimer.start();
			
			var random:int = Math.round(Math.random() * 2000);
			explosionTimer = new Timer(random);
			explosionTimer.addEventListener(TimerEvent.TIMER, generateExplosion);
			explosionTimer.start();
			
			game.addEventListener(MouseEvent.MOUSE_MOVE, highlight);
			game.addEventListener(MouseEvent.CLICK, select);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function generateExplosion(e:TimerEvent):void
		{
			var random:int = Math.round(Math.random() * 1000);
			explosionTimer.delay = random;
			
			var rdnX:Number = Math.random() * Main.screenWidth;
			var rdnY:Number = Math.random() * Main.screenHeight;
			var scale:Number = Math.random() * 2 + 1;
			var color:uint;
			var colorRdn:int = Math.round(Math.random() * 4);
			switch(colorRdn)
			{
				case 0: color = 0xFFFF00; break;
				case 1: color = 0xFF0000; break;
				case 2: color = 0xFF00FF; break;
				case 3: color = 0x9E7BFF; break;
				case 4: color = 0x00FFFF; break;
			}
			
			var explosion:Explosion = new Explosion(rdnX, rdnY, color, scale);
			addChild(explosion);
			explosions.push(explosion);
		}
		
		private function cleanup(e:TimerEvent):void
		{
			for (var i:int = 0; i < explosions.length; i++)
			{
				if (explosions[i].isDead)
				{
					removeChild(explosions[i]);
					explosions[i] = null;
					explosions.splice(i, 1);
				}
			}
		}
		
		private function background():void
		{
			var grid:Grid = new Grid(Main.screenWidth, Main.screenHeight, Main.cellWidth, Main.cellHeight, 0x0000FF, 0x000000, Main.lineThickness);
			addChild(grid);
		}
		
		private function highlight(e:MouseEvent):void
		{
			for (var i:int = 0; i < _selections.length; i++)
			{
				var marginTop:Number = _selections[i].y;
				var marginBot:Number = _selections[i].y + _selections[i].height;
				
				if (cursor.y > marginTop && cursor.y < marginBot)
				{
					_selections[i].select();
				}
				else
				{
					_selections[i].deselect();
				}
			}
		}
		
		private function select(e:MouseEvent):void
		{
			for (var i:int = 0; i < _selections.length; i++)
			{
				var selection:Selection = _selections[i];
				
				var marginTop:Number = selection.y;
				var marginBot:Number = selection.y + selection.height;
				
				if (cursor.y > marginTop && cursor.y < marginBot)
				{
					selection.selected();
					break;
				}
			}
		}
		
		public function addSelection(selection:Selection):void
		{
			_selections.push(selection);
			
			for (var i:int = 0; i < _selections.length; i++)
			{
				var currentSelection:Selection = _selections[i];
				
				addChild(selection);
				currentSelection.x = Main.screenWidth * 0.45;
				currentSelection.y = Main.screenHeight * 0.35 + i * _verticalSpacing;
			}
		}
		
		public function deactivate():void
		{
			visible = false;
			game.removeEventListener(MouseEvent.MOUSE_MOVE, highlight);
			game.removeEventListener(MouseEvent.CLICK, select);
			parent.removeChild(cursor);
		}
		
		public function update(e:Event):void
		{
			for each (var ex:Explosion in explosions)
			{
				ex.update();
			}
		}
	}

}