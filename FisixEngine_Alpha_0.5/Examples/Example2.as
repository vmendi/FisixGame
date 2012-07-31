package
{
	import com.fileitup.fisixengine.collisions.DetectionModes;
	import com.fileitup.fisixengine.collisions.ReactionModes;
	import com.fileitup.fisixengine.core.FisixEngine;
	import com.fileitup.fisixengine.core.FisixObject;
	import com.fileitup.fisixengine.core.Vector;
	import com.fileitup.fisixengine.particles.CircleParticle;
	import com.fileitup.fisixengine.particles.WheelParticle;
	import com.fileitup.fisixengine.primitives.Surface;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**This example shows how to create multiple particles.
	 * 
	 * There are two ways of running a simulation in Fisix
	 * 		1. through a timer, implemented in the FisixEngine class
	 * 		2. through the ENTER_FRAME event
	 * 
	 * In this example, the second method will be used
	 */
	[SWF(width='800',height='600',backgroundColor='0x50464b',frameRate='30')]
	public class Example2 extends MovieClip{
		private var myEngine:FisixEngine
		private var txtFPS:TextField
		
		public function Example2(){
			//first, create an instance of the fisixengine object
			myEngine = new FisixEngine()
			//turn on physical collision reactions
			myEngine.setReactionMode(ReactionModes.PHYSICAL)
			
			//set the gravity to pull down at a rate of 1 pixel per second
			myEngine.setGravity(0,1)
			
			//first we'll create all the walls
			//instead of adding the walls directly to the engine, we'll add them to a FisixObject within the engine
			
			//create the walls 'group'
			var walls:FisixObject = myEngine.newFisixObject()
			walls.makeStatic() //tells the engine the objects in this group won't be moving--extra optimization
			//create the four walls
			walls.newSurface(new Vector(0,0),new Vector(800,0))
			walls.newSurface(new Vector(800,0),new Vector(800,600))
			walls.newSurface(new Vector(800,600),new Vector(0,600))
			walls.newSurface(new Vector(0,600),new Vector(0,0))
			
			//create some obstacles
			for(var i:int=0;i<20;i++){
				walls.newCircleParticle(Math.random()*800,Math.random()*600,Math.random()*10+10)
			}
			
			//add a circle particle to the surface at position 200,100 with a radius of 50 pixels
			var particle1:WheelParticle = myEngine.newWheelParticle(200,100,40)
			particle1.bounce = 0.7
			particle1.friction = 0.5
			
			//add another particle to the right
			myEngine.newWheelParticle(400,100,40)
			
			//turn on primitive rendering
			myEngine.setRender(true)
			//tell the engine where to render to
			myEngine.setRenderGraphics(graphics)

			addEventListener(Event.ENTER_FRAME,onEnterFrame)
			
			txtFPS = new TextField()
			addChild(txtFPS)
		}
		private function onEnterFrame(e:Event):void{
			//this method does everything you need to advance the simulation by one frame
			myEngine.mainLoop(1)

			txtFPS.text = int(myEngine.getRealFPS()).toString()
		}
	}
}