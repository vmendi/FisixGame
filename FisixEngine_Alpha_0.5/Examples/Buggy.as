package
{
	import com.fileitup.fisixengine.core.FisixObject;
	import com.fileitup.fisixengine.particles.WheelParticle;
	import com.fileitup.fisixengine.particles.CircleParticle;
	import com.fileitup.fisixengine.constraints.StickConstraint;
	import com.fileitup.fisixengine.constraints.SpringConstraint;
	import flash.display.MovieClip;
	import com.fileitup.fisixengine.collisions.ReactionModes;
	
	public class Buggy extends FisixObject{
		
		[Embed(source="Tire.swf")]
		private var TireSWF:Class;
		
		public var leftWheel:WheelParticle, rightWheel:WheelParticle
		public var body:FisixObject
		public var rear:CircleParticle, front:CircleParticle
		
		public function Buggy(x:Number,y:Number,mainMovie:MovieClip){
			
			//set some variables
			innerCollisions = false
			
			/*
			when creating these objects, its important to remember that all
			of the positions of objects in the engine are global.
			Even though these particles belong in this FisixObject, their positions are in relation to the world.
			
			Therefore, where we create the particles initially doesn't really matter because
			we recenter ourselves at the end (using setCenter())
			*/			
			
			//body
			body = newFisixObject()
			body.setReactionMode(ReactionModes.PHYSICAL)
			
			//all objects added to the body will have a friction of 0.7
			body.setFriction(0.7)
			
			//create a new circle particle, setting its mass to 3 at the same time.
			//note that the default mass value is 1
			body.newCircleParticle(0,0,50).mass=3
			front = body.newCircleParticle(40,20,30)
			rear = body.newCircleParticle(-40,20,30)
			
			//this angular constraint it used to keep the body's particles from moving apart
			body.newAngularConstraint(rear,body.particles[0],front)
			
			//disable collisions between all of the particles within the body			
			body.innerCollisions = false
			
			//use the StickConstraint's static method to constraint an array of particles
			//in our case, we are constraining all of theh particles in 'body'
			StickConstraint.constraintAll(body,body.particles) // (the fisix object in which the constraints will be created, the array of particles to constraint)
			
			//wheels
			leftWheel = new WheelParticle(-60,70,40)
			rightWheel = new WheelParticle(60,70,40)
			
			//connect the two wheels together
			newStickConstraint(leftWheel,rightWheel)
			
			//connect the wheels to the car
			newSpringConstraint(leftWheel,front,1)
			newSpringConstraint(rightWheel,rear,1)
			
			//Shock absorbers
			var shock1:SpringConstraint = newSpringConstraint(leftWheel,rear,.3) //change 0.3 to a different value between 0-1 to change the shock absorbence of the car
			var shock2:SpringConstraint = newSpringConstraint(rightWheel,front,.3)
			
			//add the wheel objects objects to the car.
			//this could have also been done like so:
			/*
				//this creates and adds the wheel in one line
				leftWheel = newWheelParticle(.....)
			*/
						
			addObject(leftWheel)
			addObject(rightWheel)
			
			//now we'll create 2 movieclips which will represent the tires
			var wheelMC1:MovieClip = new TireSWF()			
			//add the movieclip to the display tree
			mainMovie.addChild(wheelMC1)
			//adjust the size to fit the tires
			wheelMC1.width = leftWheel.radius*2
			wheelMC1.height = leftWheel.radius*2
			//create a wheel attacher to connect the MC to the left wheel
			newWheelAttacher(wheelMC1,leftWheel)
			
			var wheelMC2:MovieClip = new TireSWF()
			mainMovie.addChild(wheelMC2)
			wheelMC2.width = leftWheel.radius*2
			wheelMC2.height = leftWheel.radius*2
			newWheelAttacher(wheelMC2,rightWheel)
			
			//set the center of the car to the values specified in the constructor args
			setCenter(x,y)
		}
		
		public function drive(speed:Number):void{
			leftWheel.rotateWheel(speed)
			rightWheel.rotateWheel(speed)
		}
	}
}