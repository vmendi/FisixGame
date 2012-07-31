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
	
	/**This app was created to show how different collision/detection modes affect the simulation
	 */
	[SWF(width='700',height='500',backgroundColor='0xBBBBBB',frameRate='30')]
	public class Example4 extends MovieClip{
		private var myEngine:FisixEngine
		private var txtFPS:TextField
		private var cDMode:int = 0
		private var cRMode:int = 0
		var txtDetectionMode:TextField
		var txtReactionMode:TextField
		
		public function Example4(){
			//first, create an instance of the fisixengine object
			myEngine = new FisixEngine()
			
			//bound all of the objects in the simulation within a box
			myEngine.setBounds(new BoundingBox(0,0,700,500))
			//enable collisions with the bounding box
			myEngine.boundsCollisions=false
			
			//set the gravity to pull down at a rate of 1 pixel per second
			myEngine.setGravity(0,2)
			
			//create some surfaces
			myEngine.newSurface(new Vector(100,350),new Vector(300,300),4)
			myEngine.newSurface(new Vector(300,300),new Vector(500,350),4)
			
			//turn on primitive rendering
			myEngine.setRender(true)
			//tell the engine where to render to
			myEngine.setRenderGraphics(graphics)

			addEventListener(Event.ENTER_FRAME,onEnterFrame)

			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			
			txtFPS = new TextField()
			addChild(txtFPS)
			
			//create some gui
			txtDetectionMode = new TextField()
			txtReactionMode = new TextField()
			
			txtDetectionMode.x = 20
			txtDetectionMode.width = 200
			
			txtReactionMode.x = 300
			txtReactionMode.width = 200
			
			var txtInstructions:TextField = new TextField()
			txtInstructions.text = "Instructions: Press 1-4 to cycle through collision detection modes.\nPress 5-6 to cycle through collision reaction modes."
			txtInstructions.y=450
			txtInstructions.width = 500
			
			addChild(txtDetectionMode)
			addChild(txtReactionMode)
			addChild(txtInstructions)
			
			//myEngine.setDetectionMode(DetectionModes.RAYCAST)
		}
		private function onEnterFrame(e:Event):void{
			//create particles randomly
			var rnd:Number = Math.round(Math.random()*5)
			if(rnd==1){
				var rad:Number = Math.random()*10+1
				var cParticle:AutoRemoveParticle = new AutoRemoveParticle(Math.random()*700,rad,rad)
				myEngine.addObject(cParticle)
			}
			
			myEngine.mainLoop(1)

			txtFPS.text = int(myEngine.getRealFPS()).toString()
			
			cDMode = myEngine.getDetectionMode()
			//update the detection and reaction mode text
			txtDetectionMode.text = "Detection Mode: "
			if(cDMode==DetectionModes.PENETRATION){
				txtDetectionMode.appendText("PENETRATION")
			}else if(cDMode==DetectionModes.LIMIT_VELOCITY){
				txtDetectionMode.appendText("LIMIT_VELOCITY")
			}else if(cDMode==DetectionModes.RAYCAST){
				txtDetectionMode.appendText("RAYCAST")
			}else if(cDMode==DetectionModes.HYBRID_RAYCAST){
				txtDetectionMode.appendText("HYBRID_RAYCAST")
			}
			
			
			cRMode = myEngine.getReactionMode()
			txtReactionMode.text = "Reaction Mode: "
			if(cRMode==ReactionModes.NONE){
				txtReactionMode.appendText("NONE")
			}else if(cRMode==ReactionModes.PHYSICAL){
				txtReactionMode.appendText("PHYSICAL")
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void{
			if(e.keyCode==49){
				myEngine.setAllDetectionModes(DetectionModes.PENETRATION)
			}else if(e.keyCode==50){
				myEngine.setAllDetectionModes(DetectionModes.LIMIT_VELOCITY)
			}else if(e.keyCode==51){
				myEngine.setAllDetectionModes(DetectionModes.RAYCAST)
			}else if(e.keyCode==52){
				myEngine.setAllDetectionModes(DetectionModes.HYBRID_RAYCAST)
			}
			
			if(e.keyCode==53){
				myEngine.setAllReactionModes(ReactionModes.NONE)
			}else if(e.keyCode==54){
				myEngine.setAllReactionModes(ReactionModes.PHYSICAL)
			}
		}
	}
}