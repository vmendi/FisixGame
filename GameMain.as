package
{
import flash.display.Sprite;
import flash.events.*;
import flash.display.MovieClip;
import flash.utils.Timer;
import flash.utils.getTimer;
import flash.geom.Point;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.system.ApplicationDomain;

import com.fileitup.fisixengine.constraints.*;
import com.fileitup.fisixengine.collisions.*;
import com.fileitup.fisixengine.particles.*;
import com.fileitup.fisixengine.primitives.*;
import com.fileitup.fisixengine.core.*;
import com.fileitup.fisixengine.utils.*;
import com.fileitup.fisixengine.graphics.SurfaceAttacher;
import com.fileitup.fisixengine.surfaces.DynamicSurface;

[SWF(width='1024',height='700',backgroundColor='0xFFFFFF',frameRate='60')]
public class GameMain extends Sprite
{
	private var mCharacter : Character = null;
	private var mRagdoll : Ragdoll = null;
	private var mBed : Bed = null;
	private var mLevel : Level = null;
	private var mLastTime : int = 0;
	private var mEngine : FisixEngine;
	private var mMouseAttacher : MouseAttacher;
	
	public function GameMain()
	{
		Run();
	}
		
	public function Run() : void
	{		 
		mBed = new Bed();
		mLevel = new Level();
		addChild(mLevel);		 
 		addChild(mBed);
 	
 		mEngine = new FisixEngine();
 		
 		mEngine.setGravity(0, GameConstants.GRAVITY * stage.frameRate);
 		mEngine.setDetectionMode(DetectionModes.HYBRID_RAYCAST);
		mEngine.setReactionMode(ReactionModes.PHYSICAL);
		
		mCharacter = new Character();	
 		mRagdoll = new Ragdoll(this); 
		mEngine.addObject(mRagdoll);

/*		
		var walls:FisixObject = mEngine.newFisixObject();
		walls.makeStatic();
		walls.bounce = 1;
		var surf : Surface = walls.newSurface(new Vector(600,-1000),new Vector(600,800),70)
		surf.bounce = 1.0;
		surf = walls.newSurface(new Vector(0,800),new Vector(0,-1000),70)
		surf.bounce = 1.0;

		for (var c:int = 0; c < walls.surfaces.length; c++)
		{
			walls.surfaces[c].friction = 0.1;
		}
*/
		mEngine.setRender(false);
		mEngine.setRenderGraphics(graphics);		

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(MouseEvent.CLICK, onMouseClick);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}
	
	private function onKeyDown(event:KeyboardEvent) : void
	{
		if (numToChar(event.charCode) == "m")
		{
			if (mMouseAttacher != null)
			{
				mEngine.removeMouseAttacher(mMouseAttacher);
				mMouseAttacher = null;
			}
			else
			{
				mMouseAttacher = mEngine.newMouseAttacher(mRagdoll.particles[0], root, 3);
			}
		}
	}
	
	private	function onMouseClick(event:Event) : void
	{
	}
	
	private	function onEnterFrame(event:Event) : void
	{
		onUpdate();
	}
	
	private function onUpdate() : void
	{
		var currentTime : int = flash.utils.getTimer();
		var elapsedTime : int = currentTime - mLastTime;
				
		mEngine.mainLoop(elapsedTime / 6000);

		// Rebote contra la cama?
		for (var c:int = 0; c < mRagdoll.particles.length; c++)
		{
			var part : CircleParticle = mRagdoll.particles[c];
			var pos:Point = new Point(part.pos.x, part.pos.y);
			
			if (mBed.IsCollision(pos, part.radius))
			{
				var normal:Point = mBed.GetNormal();
				normal.normalize(GameConstants.REBOUND_EXIT_VEL);
				mRagdoll.CenterBody.setVelocity(new Vector(normal.x, normal.y));

				mBed.onCollide();
				break;
			}
		}
		
		// A la lava?
		if (mRagdoll.getCenter().y >= stage.stageHeight - mLevel.LavaHeight)
		{
			mRagdoll.setCenter(stage.stageWidth/2, 0);
			mRagdoll.setVelocity(new Vector(0, 0));
		}
		
		// Rebote por la izquierda o por la derecha
		/*
		if(mRagdoll.getCenter().x <= 0)
			mRagdoll.CenterBody.setVelocity(new Vector(GameConstants.LEFT_EXIT_VEL, 0));
		*/
		if (mRagdoll.getCenter().x >= stage.stageWidth-100)
			mRagdoll.CenterBody.setVelocity(new Vector(-GameConstants.RIGHT_EXIT_VEL, 0));
		
		// La colision con los globos la delegamos
		mLevel.CollisionWithGlobos(mRagdoll);
		
		mRagdoll.onUpdate(elapsedTime);
		mBed.onUpdate(elapsedTime);
		mLevel.onUpdate(elapsedTime);
		
		// El ragdoll tambien podria sufrir desplazamiento hacia la izq
		// mRagdoll.setCenter(mRagdoll.getCenter().x-0.1, mRagdoll.getCenter().y, true);
		
		mLastTime = currentTime;
	}
	
	private function numToChar(num:int):String 
	{
        if (num > 47 && num < 58) {
            var strNums:String = "0123456789";
            return strNums.charAt(num - 48);
        } else if (num > 64 && num < 91) {
            var strCaps:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            return strCaps.charAt(num - 65);
        } else if (num > 96 && num < 123) {
            var strLow:String = "abcdefghijklmnopqrstuvwxyz";
            return strLow.charAt(num - 97);
        } else {
            return num.toString();
        }
    }
}	// class CGameMain

}	// package