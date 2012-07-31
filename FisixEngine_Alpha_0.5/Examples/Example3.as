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
	import com.fileitup.fisixengine.constraints.SpringConstraint;
	import com.fileitup.fisixengine.utils.MouseAttacher;
	import com.fileitup.fisixengine.utils.BoundingBox;
	
	/**In this example, a jello-type object is created and manipulated by the mouse
	 */
	[SWF(width='700',height='500',backgroundColor='0x50464b',frameRate='30')]
	public class Example3 extends MovieClip{
		private var myEngine:FisixEngine
		private var txtFPS:TextField
		
		public function Example3(){
			//first, create an instance of the fisixengine object
			myEngine = new FisixEngine()
			
			//bound all of the objects in the simulation within a box
			myEngine.setBounds(new BoundingBox(0,0,700,500))
			//enable collisions with the bounding box
			myEngine.boundsCollisions=true
			
			//set the gravity to pull down at a rate of 1 pixel per second
			myEngine.setGravity(0,1)
			
			//create a jello cube
			var jello:FisixObject = myEngine.newFisixObject()
				for(var j:int=0;j<3;j++){
					for(var i:int=0;i<3;i++){
						jello.newCircleParticle(i*80,j*80,10)
					}
				}
				//constraint all of the particles together, using SpringConstraint's static constraining functions
				SpringConstraint.constraintAll(jello,jello.particles,.3)
				
				jello.innerCollisions=false //disable collisions between all the particles of the jello
				jello.setIterations(1) //the higher the iterations, the more 'rigid' the constraints are
				jello.setCenter(100,100)
			
			//attach the corner of the jello to the mouse
			myEngine.newMouseAttacher(jello.particles[0],root,3)

			//turn on primitive rendering
			myEngine.setRender(true)
			//tell the engine where to render to
			myEngine.setRenderGraphics(graphics)

			addEventListener(Event.ENTER_FRAME,onEnterFrame)
			
			txtFPS = new TextField()
			addChild(txtFPS)
		}
		private function onEnterFrame(e:Event):void{
			myEngine.mainLoop(1)

			txtFPS.text = int(myEngine.getRealFPS()).toString()
		}
	}
}