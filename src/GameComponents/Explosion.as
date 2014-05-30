package GameComponents 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Mike Ludwig
	 */
	public class Explosion extends Sprite 
	{
		private var cleanupTimer:Timer;
		private var _particles:Vector.<Particle> = new Vector.<Particle>();
		private var _isDead:Boolean;
		public function get isDead():Boolean
		{
			return _isDead;
		}
		
		public function Explosion(xPosition:int, yPosition:int, color:uint, scale:Number) 
		{
			x = xPosition;
			y = yPosition;
			
			createParticles(color, scale);
			
			cleanupTimer = new Timer(100);
			cleanupTimer.addEventListener(TimerEvent.TIMER, cleanup);
			cleanupTimer.start();
		}
		
		private function createParticles(color:uint, scale:Number):void
		{
			for (var i:int = 0; i < 10 * scale; i++)
			{
				var particle:Particle = new Particle(this, color);
				addChild(particle);
				_particles.push(particle);
			}
		}
		
		private function cleanup(e:TimerEvent):void
		{
			if (_particles.length == 0)
			{
				removeEventListener(TimerEvent.TIMER, cleanup);
				_isDead = true;
			}
			
			for (var i:int = 0; i < _particles.length; i++)
			{
				if (_particles[i].isDead)
				{
					removeChild(_particles[i]);
					_particles[i] = null;
					_particles.splice(i, 1);
				}
			}
		}
		
		public function update():void
		{
			for each (var particle:Particle in _particles)
			{
				particle.update();
			}
		}
	}

}