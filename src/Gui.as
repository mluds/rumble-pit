package  
{
	//{ Import Statements
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.events.WeakFunctionClosure;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.*;
	import flash.utils.Timer;
	import GameComponents.FadeText;
	import GameComponents.FPSCounter;
	import GameComponents.Player;
	
	//}
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Gui extends Sprite 
	{
		//{ Fields
		
		private var _score:int;
		private var _multiplier:int;
		private var _lives:int;
		private var _bombs:int;
		private var _fadeStrings:Vector.<String> = new Vector.<String>();
		private var scoreText:TextField = new TextField();
		private var livesText:TextField = new TextField();
		private var multText:TextField = new TextField();
		private var bombsText:TextField = new TextField();
		private var _killCount:int;
		private var format:TextFormat;
		private var formatC:TextFormat;
		private var player:Player;
		private var game:Game;
		
		//}
		
		//{ Properties
		
		public function set score(v:int):void
		{
			_score += v * _multiplier;
			scoreText.text = String(_score);
		}
		public function set multiplier(v:int):void
		{
			_multiplier = v;
			_killCount = 0;
			multText.text = "x" + String(_multiplier);
		}
		public function get lives():int
		{
			return _lives;
		}
		public function set lives(v:int):void
		{
			_lives = v;
			livesText.text = String(_lives);
		}
		public function get killCount():int
		{
			return _killCount;
		}
		public function set killCount(v:int):void
		{
			_killCount = v;
			
			if (_multiplier < 5)
			{
				_multiplier = 1 + Math.floor(_killCount / 50);
				multText.text = "x" + String(_multiplier);
				
				if (_killCount % 50 == 0 && _killCount != 0)
				{
					_fadeStrings.push("x" + _multiplier + " Score");
				}
				
				if (_killCount % 275 == 0 && _killCount != 0)
				{
					_fadeStrings.push("Powerup");
					game.generatePowerup();
				}
			}
		}
		public function get bombs():int
		{
			return _bombs;
		}
		public function set bombs(v:int):void
		{
			_bombs = v;
			bombsText.text = String(_bombs);
		}
		public function set fadeString(v:String):void
		{
			_fadeStrings.push(v);
		}
		public function get fadeStrings():Vector.<String>
		{
			return _fadeStrings;
		}
		
		//}
		
		public function Gui(game:Game, lives:int, bombs:int, player:Player) 
		{
			this.game = game;
			format = new TextFormat("Arial", 14, 0xFFFF00);
			format.align = TextFormatAlign.RIGHT;
			
			formatC = format;
			formatC.align = TextFormatAlign.CENTER;
			
			this.player = player;
			
			killCount = 0;
			_score = 0;
			_multiplier = 1;
			
			_lives = lives;
			_bombs = bombs;
			
			drawScore();
			drawMultiplier();
			
			drawLives();
			drawBombs();
			drawFPS();
			drawVersion();
			
			addEventListener(Event.ENTER_FRAME, checkFadeStrings);
		}
		
		public function cleanup(fadeText:FadeText):void
		{
			removeChild(fadeText);
			fadeText = null;
		}
		
		private function checkFadeStrings(e:Event):void
		{
			if (_fadeStrings.length > 0)
			{
				removeEventListener(Event.ENTER_FRAME, checkFadeStrings);
				
				displayFadeText(_fadeStrings[0]);
			}
		}
		
		public function displayFadeText(text:String):void
		{
			_fadeStrings.shift();
			if (_fadeStrings.length == 0)
			{
				addEventListener(Event.ENTER_FRAME, checkFadeStrings);
			}
			
			var fadeText:FadeText = new FadeText(this, player, text, formatC);
			addChild(fadeText);
		}
		
		private function drawScore():void
		{
			scoreText.defaultTextFormat = format;
			scoreText.text = String(_score);
			scoreText.x = Main.cellWidth * 2;
			scoreText.selectable = false;
			
			addChild(scoreText);
		}
		
		private function drawMultiplier():void
		{
			multText.defaultTextFormat = format;
			multText.text = "x" + String(_multiplier);
			multText.x = Main.cellWidth * 3;
			multText.selectable = false;
			
			addChild(multText);
		}
		
		private function drawLives():void
		{
			var icon:Sprite = new Sprite();
			var width:int = Main.cellWidth / 3;
			var height:int = Main.cellHeight / 3;
			
			var g:Graphics = icon.graphics;
			
			g.lineStyle(1, 0xFFFF00);
			
			g.moveTo(1, -(height / 2));
			g.lineTo( -(width / 2), -(height / 4));
			
			g.lineTo( -(width / 4), (height / 2));
			g.lineTo( -(width / 4), 0);
			g.lineTo( 1, -(height / 6));
			g.lineTo( (width / 4), 0);
			g.lineTo( (width / 4), (height / 2));
			g.lineTo( (width / 2) + 1, -(height / 4));
			g.lineTo(1, -(height / 2));
			
			addChild(icon);
			icon.x = Main.cellWidth * 5.2;
			icon.y = Main.cellHeight / 4;
			icon.rotation = 180;
			
			livesText.defaultTextFormat = format;
			livesText.text = String(_lives);
			livesText.x = Main.cellWidth * 4.3;
			livesText.selectable = false;
			
			addChild(livesText);
		}
		
		private function drawBombs():void
		{
			var icon:Sprite = new Sprite();
			
			var width:int = Main.cellWidth / 3;
			var height:int = Main.cellHeight / 3;
			
			var g:Graphics = icon.graphics;
			
			g.lineStyle(1, 0xFFFF00);
			g.drawCircle(0, 0, width / 2);
			g.drawCircle(0, 0, width / 3);
			g.moveTo( -width / 2, 0);
			g.lineTo(width / 2, 0);
			
			addChild(icon);
			icon.x = Main.cellWidth * 6.2;
			icon.y = Main.cellHeight / 4;
			
			bombsText.defaultTextFormat = format;
			bombsText.text = String(_bombs);
			bombsText.x = Main.cellWidth * 5.3;
			bombsText.selectable = false;
			
			addChild(bombsText);
		}
		
		private function drawFPS():void
		{
			var fpsX:Number = Main.screenWidth - (Main.cellWidth * 2);
			var fpsY:Number = Main.screenHeight - (Main.cellHeight / 2);
			var fps:FPSCounter = new FPSCounter(new Point(fpsX, fpsY), format);
			addChild(fps);
		}
		
		private function drawVersion():void
		{
			var version:TextField = new TextField();
			version.defaultTextFormat = format;
			version.x = -Main.cellWidth / 2;
			version.y = Main.screenHeight - (Main.cellHeight / 2);
			version.text = "v0.2";
			addChild(version);
		}
	}

}