package
{
	import com.fileitup.fisixengine.constraints.*;
	import com.fileitup.fisixengine.collisions.*;
	import com.fileitup.fisixengine.particles.*;
	import com.fileitup.fisixengine.primitives.*;
	import com.fileitup.fisixengine.core.*;
	import com.fileitup.fisixengine.utils.*;
	import com.fileitup.fisixengine.surfaces.*;
	import com.fileitup.fisixengine.graphics.*
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	
	public class Ragdoll extends FisixObject
	{
		private var mParent : Sprite = null;
		private var mCenterBody : CircleParticle = null;
		
		public function get CenterBody() : Particle { return mCenterBody; }
		
		public function Ragdoll(parent:Sprite)
		{
			mParent = parent;
			name = "PARENT";
			
			iterations = 20;
			drag = 0;
			bounce = 1;
			friction = 0.0;
			innerCollisions = false;
			
			mCenterBody = newCircleParticle(100, 90, 20);
			mCenterBody.name = "CenterBody";
			mCenterBody.mass = 1000000;

 			var daHead : CircleParticle = newCircleParticle(100, 0, 20);
			daHead.name = "Head";
			daHead.mass = 0;

			var upperBody : CircleParticle = newCircleParticle(100, 60, 20);
			upperBody.name = "UpperBody";
			upperBody.mass = 0;
						
 			var lowerBodyLeft : CircleParticle = newCircleParticle(100, 110, 20);
			lowerBodyLeft.name = "LowerLeft";
			lowerBodyLeft.mass = 0.0;
			
 			var lowerBodyRight : CircleParticle = newCircleParticle(100, 110, 20);
			lowerBodyRight.name = "LowerRight";
			lowerBodyRight.mass = 0;

			// Piernas
			var leftKnee : CircleParticle = newCircleParticle(100, 160, 5);
			leftKnee.name = "leftKnee"; 
			leftKnee.mass = 0;

 			var rightKnee : CircleParticle = newCircleParticle(100, 160,5);
			rightKnee.name = "rightKnee";
			rightKnee.mass = 0;

			var leftFoot : CircleParticle = newCircleParticle(100, 220, 5);
			leftFoot.name = "leftFoot";
			leftFoot.mass = 0;

			var rightFoot : CircleParticle = newCircleParticle(100, 220, 5);
			rightFoot.name = "rightFoot";
			rightFoot.mass = 0;

			// Brazos
			var leftArm : CircleParticle = newCircleParticle(120, 90, 5);
			leftArm.name = "LeftArm";
			leftArm.mass = 0;

 			var rightArm : CircleParticle = newCircleParticle(120, 90, 5);
			rightArm.name = "RightArm";
			rightArm.mass = 0;

 			var leftHand : CircleParticle = newCircleParticle(150, 130, 5);
			leftHand.name = "LeftHand"; 
			leftHand.mass = 0.0;

 			var rightHand : CircleParticle = newCircleParticle(150, 130, 5);
			rightHand.name = "RightHand";
			rightHand.mass = 0.0;

			var stick1 : StickConstraint = newStickConstraint(daHead, upperBody);
			var stick21 : StickConstraint = newStickConstraint(upperBody, mCenterBody);
			var stick22 : StickConstraint = newStickConstraint(upperBody, lowerBodyLeft);
			var stick23 : StickConstraint = newStickConstraint(upperBody, lowerBodyRight);
			var stick24: StickConstraint = newStickConstraint(mCenterBody, lowerBodyLeft);
			var stick25 : StickConstraint = newStickConstraint(mCenterBody, lowerBodyRight);
			var stick3 : StickConstraint = newStickConstraint(lowerBodyLeft, lowerBodyRight);
			
 			var stick4 : StickConstraint = newStickConstraint(lowerBodyLeft, leftKnee);
			var stick5 : StickConstraint = newStickConstraint(lowerBodyRight, rightKnee);
			var stick6 : StickConstraint = newStickConstraint(leftKnee, leftFoot);
			var stick7 : StickConstraint = newStickConstraint(rightKnee, rightFoot);
			
			var stick8 : StickConstraint = newStickConstraint(upperBody, leftArm);
			var stick9 : StickConstraint = newStickConstraint(upperBody, rightArm);
			var stick10 : StickConstraint = newStickConstraint(leftArm, leftHand);
			var stick11 : StickConstraint = newStickConstraint(rightArm, rightHand);

			var ang0 : AngularConstraint = newAngularConstraint(lowerBodyLeft, upperBody, daHead, 150, 230);
			ang0.stiffness = 0.05;
						
			var ang1 : AngularConstraint = newAngularConstraint(lowerBodyLeft, upperBody, leftArm, 200, 350);
			ang1.stiffness = 0.05;
			var ang2 : AngularConstraint = newAngularConstraint(lowerBodyRight, upperBody, rightArm, 200, 340);
			ang2.stiffness = 0.05;
			
			var ang15 : AngularConstraint = newAngularConstraint(upperBody, leftArm, leftHand, 80, 200);
			ang15.stiffness = 0.05;
			var ang25 : AngularConstraint = newAngularConstraint(upperBody, rightArm, rightHand, 80, 200);
			ang25.stiffness = 0.05;

			var ang3 : AngularConstraint = newAngularConstraint(upperBody, lowerBodyLeft, leftKnee, 50, 250);
			ang3.stiffness = 0.05;
			var ang4 : AngularConstraint = newAngularConstraint(upperBody, lowerBodyRight, rightKnee, 60, 240);			
			ang4.stiffness = 0.05;
			var ang5 : AngularConstraint = newAngularConstraint(lowerBodyLeft, leftKnee, leftFoot, 170, 320);
			ang5.stiffness = 0.05;
			var ang6 : AngularConstraint = newAngularConstraint(lowerBodyRight, rightKnee, rightFoot, 170, 320);
			ang6.stiffness = 0.05;

			var headSprite : Sprite = new Resources.HeadClass();
			parent.addChild(headSprite);
			var dispAttacher2 : DisplayAttacher2 = new DisplayAttacher2(headSprite, daHead.pos, upperBody.pos, 270);
			addDisplayAttacher(dispAttacher2);

			var upperBodySprite : Sprite = new Resources.UpperBodyClass();
			parent.addChild(upperBodySprite);
			dispAttacher2 = new DisplayAttacher2(upperBodySprite, upperBody.pos, mCenterBody.pos, 270);
			addDisplayAttacher(dispAttacher2);

			var upperLegSprite : Sprite = new Resources.UpperLegClass();
			parent.addChild(upperLegSprite);
			dispAttacher2 = new DisplayAttacher2(upperLegSprite, lowerBodyLeft.pos, leftKnee.pos, 270);
			addDisplayAttacher(dispAttacher2);

			upperLegSprite = new Resources.UpperLegClass();
			parent.addChild(upperLegSprite);
			dispAttacher2 = new DisplayAttacher2(upperLegSprite, lowerBodyRight.pos, rightKnee.pos, 270);
			addDisplayAttacher(dispAttacher2);

			var lowerLegSprite : Sprite = new Resources.LowerLegClass();
			parent.addChild(lowerLegSprite);
			dispAttacher2 = new DisplayAttacher2(lowerLegSprite, leftKnee.pos, leftFoot.pos, 270);
			addDisplayAttacher(dispAttacher2);

			lowerLegSprite = new Resources.LowerLegClass();
			parent.addChild(lowerLegSprite);
			dispAttacher2 = new DisplayAttacher2(lowerLegSprite, rightKnee.pos, rightFoot.pos, 270);
			addDisplayAttacher(dispAttacher2);

			var lowerBodySprite : Sprite = new Resources.LowerBodyClass();
			parent.addChild(lowerBodySprite);
			dispAttacher2 = new DisplayAttacher2(lowerBodySprite, mCenterBody.pos, lowerBodyLeft.pos, 270);
			addDisplayAttacher(dispAttacher2);
			
			var upperArmSprite : Sprite = new Resources.UpperArmClass();
			parent.addChild(upperArmSprite);
			dispAttacher2 = new DisplayAttacher2(upperArmSprite, upperBody.pos, leftArm.pos, 270);
			addDisplayAttacher(dispAttacher2);

			upperArmSprite = new Resources.UpperArmClass();
			parent.addChild(upperArmSprite);
			dispAttacher2 = new DisplayAttacher2(upperArmSprite, upperBody.pos, rightArm.pos, 270);
			addDisplayAttacher(dispAttacher2);

			var lowerArmSprite : Sprite = new Resources.LowerArmClass();
			parent.addChild(lowerArmSprite);
			dispAttacher2 = new DisplayAttacher2(lowerArmSprite, leftArm.pos, leftHand.pos, 270);
			addDisplayAttacher(dispAttacher2);

			lowerArmSprite = new Resources.LowerArmClass();
			parent.addChild(lowerArmSprite);
			dispAttacher2 = new DisplayAttacher2(lowerArmSprite, rightArm.pos, rightHand.pos, 270);
			addDisplayAttacher(dispAttacher2);

			setCenter(200, 200);
		}
		
		public function onUpdate(elapsedTime:int) : void
		{
		}
	}
}
