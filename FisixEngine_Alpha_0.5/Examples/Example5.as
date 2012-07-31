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
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import com.fileitup.fisixengine.resources.Rope;
	import flash.events.MouseEvent;
	import com.fileitup.fisixengine.constraints.StickConstraint;
	
	/**In this example, we'll create a tire swing and attach a movieclip to it
	 */
	[SWF(width='700',height='500',backgroundColor='0xBBBBBB',frameRate='30')]
	public class Example5 extends MovieClip{
		
		[Embed(source="Tire.swf")]
		private var TireSWF:Class;
		
		private var myEngine:FisixEngine
		private var txtFPS:TextField
		private var mouseDown:Boolean

		public function Example5(){
			//first, create an instance of the fisixengine object
			myEngine = new FisixEngine()
			
			//set the gravity to pull down at a rate of 1 pixel per second
			myEngine.setGravity(0,1)
			
			//turn on primitive rendering
			myEngine.setRender(true)
			//tell the engine where to render to
			myEngine.setRenderGraphics(graphics)

			addEventListener(Event.ENTER_FRAME,onEnterFrame)
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			
			txtFPS = new TextField()
			addChild(txtFPS)
			
			
			//create the tire swing
			var swing:FisixObject = myEngine.newFisixObject()
				swing.innerCollisions = false
				//use the rope resource class
				var rope:Rope = new Rope(new Vector(350,10),new Vector(350,200),6,3,1,0,1)
				rope.setIterations(10)
				rope.head.fix()
				swing.addObject(rope)
				
				//add the tire
				var tire:CircleParticle=swing.newCircleParticle(350,200+50,50)
				//attach the tire to the rope
				var stick1:StickConstraint = swing.newStickConstraint(tire,rope.tail)
				
				var tireMC:MovieClip = new TireSWF()
				addChild(tireMC)
				
				//attach the movieclip to the tire
				swing.newConstraintAttacher(tireMC,stick1)

		}
		private function onEnterFrame(e:Event):void{
			
			if(mouseDown){
				/*if the mouse is down, an implosion (an explosion with a negative force
				  will occur where the mouse is, attracting all of the objects in the world to it.
				*/
				myEngine.explode(new Vector(stage.mouseX,stage.mouseY),-200)
			}
			
			myEngine.mainLoop(1)
			txtFPS.text = int(myEngine.getRealFPS()).toString()
		}
		private function onMouseDown(e:MouseEvent):void{
			mouseDown=true
		}
		private function onMouseUp(e:MouseEvent):void{
			mouseDown=false
		}
	}
}