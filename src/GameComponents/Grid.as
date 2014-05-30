package GameComponents 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Grid extends Sprite 
	{
		
		public function Grid(width:int, height:int, spacingW:int, spacingH:int, color:uint, background:uint, lineThickness:int) 
		{
			draw(width, height, spacingW, spacingH, color, background, lineThickness);
		}
		
		private function draw(width:int, height:int, spacingW:int, spacingH:int, color:uint, background:uint, lineThickness:int):void
		{
			var grid:Sprite = new Sprite();
			var g:Graphics = grid.graphics;
			
			g.beginFill(background);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			g.lineStyle(lineThickness, color);
			
			for (var i:Number = 0; i < width; i += spacingW)
			{
				for (var j:Number = 0; j < height; j += spacingH)
				{
					g.drawRect(i - 0.5, j - 0.5, spacingW, spacingH);
				}
			}
			
			addChild(grid);
		}
	}

}