package GameComponents.Enemies 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import GameComponents.Bullet;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public interface IEnemy
	{
		function get isDestroyed():Boolean
		function set isDestroyed(v:Boolean):void
		
		function deactivate():void
		function hit(bullet:Bullet):void
		function destroy(isPlayer:Boolean):void
		function pause():void
		function resume():void
	}
	
}