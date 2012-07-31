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
	import com.fileitup.fisixengine.resources.FractalTerrain;
	
	/**In this example, we'll create landscape using the FractalTerrain resource class
	 * and also create a custom 'car' object located in the class "Car.as"
	 */
	[SWF(width='700',height='500',backgroundColor='0xCCBBBB',frameRate='30')]
	public class Example6 extends MovieClip{
		
		private var myEngine:FisixEngine
		private var txtFPS:TextField
		private var mouseDown:Boolean
		
		private var driveSpeed:Number
		private var car:Buggy

		public function Example6(){
			
			driveSpeed=0
				
			//first, create an instance of the fisixengine object
			myEngine = new FisixEngine()
			
			//set the gravity to pull down at a rate of 1 pixel per second
			myEngine.setGravity(0,1)
			
			myEngine.setReactionMode(ReactionModes.PHYSICAL)
			
			myEngine.boundsCollisions = true
			
			//turn on primitive rendering
			myEngine.setRender(true)
			//tell the engine where to render to
			myEngine.setRenderGraphics(graphics)

			addEventListener(Event.ENTER_FRAME,onEnterFrame)
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp)
			
			txtFPS = new TextField()
			addChild(txtFPS)
			
			var terrain:FractalTerrain = new FractalTerrain(new Vector(0,300),new Vector(700,300),-30,2,2,0)
			terrain.setFriction(1)
			myEngine.addObject(terrain)
			
			car = new Buggy(200,200,this)
			myEngine.addObject(car)
		}
		private function onEnterFrame(e:Event):void{
			car.drive(driveSpeed)
			myEngine.mainLoop(1)
			txtFPS.text = int(myEngine.getRealFPS()).toString()
		}
		private function onMouseDown(e:MouseEvent):void{
			mouseDown=true
		}
		private function onMouseUp(e:MouseEvent):void{
			mouseDown=false
		}
		private function onKeyDown(e:KeyboardEvent){
			if(e.keyCode==Keyboard.RIGHT) driveSpeed=3
			if(e.keyCode==Keyboard.LEFT) driveSpeed=-3
		}
		private function onKeyUp(e:KeyboardEvent){
			driveSpeed=0
		}
	}
}