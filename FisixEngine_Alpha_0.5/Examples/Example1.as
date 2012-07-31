package
{
	import com.fileitup.fisixengine.collisions.ReactionModes;
	import com.fileitup.fisixengine.core.FisixEngine;
	import com.fileitup.fisixengine.core.Vector;
	import com.fileitup.fisixengine.particles.CircleParticle;
	import com.fileitup.fisixengine.particles.WheelParticle;
	import com.fileitup.fisixengine.primitives.Surface;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**This example shows how to create a basic simulation and run it.
	 * 
	 * There are two ways of running a simulation in Fisix
	 * 		1. through a timer, implemented in the FisixEngine class
	 * 		2. through the ENTER_FRAME event
	 * 
	 * In this example, the built in timer will be used.
	 * For some reason, flash's timers cause some choppiness, so in future examples the event method will be used...
	 */
	[SWF(width='600',height='400',backgroundColor='0xe50464b',framerate='30')]
	public class Example1 extends MovieClip{		
		public function Example1(){
			//first, create an instance of the fisixengine object
			var myEngine:FisixEngine = new FisixEngine()
			//turn on physical collision reactions
			myEngine.setReactionMode(ReactionModes.PHYSICAL)
			
			//set the gravity to pull down at a rate of 1 pixel per second
			myEngine.setGravity(0,30)
			
			//next, add a surface to the engine
			var surface1:Surface = myEngine.newSurface(new Vector(0,200),new Vector(500,350),10)
			//set the surface's physical properties
			surface1.bounce = 0.9
			surface1.friction = 0.5		
			
			//add a circle particle to the surface at position 200,100 with a radius of 50 pixels
			var particle1:WheelParticle = myEngine.newWheelParticle(200,100,50)
			particle1.bounce = 0.7
			particle1.friction = 0.5
			
			//turn on primitive rendering
			myEngine.setRender(true)
			//tell the engine where to render to
			myEngine.setRenderGraphics(graphics)
			
			//start the engine
			myEngine.startEngine(30)
		}
	}
}