package {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.MovieClip;
import flash.geom.Point;


import com.fileitup.fisixengine.constraints.*;
import com.fileitup.fisixengine.collisions.*;
import com.fileitup.fisixengine.particles.*;
import com.fileitup.fisixengine.primitives.*;
import com.fileitup.fisixengine.core.*;
import com.fileitup.fisixengine.utils.*;
import com.fileitup.fisixengine.surfaces.*;
import com.fileitup.fisixengine.graphics.*;

public class FisixBed extends Sprite
{
	private var mPoints : Array = new Array();
	private var mFirstPoint : Point;
	private var mSecondPoint : Point;
	private var mState : String  = "NULL";
	private var mVibratingParam:Number = 0;
	private var mVibratingTime:Number = 0;
	
	private var mEngine:FisixEngine = null;
	private var mSurfaceObject:InternalBed = null;
	
	
	public function FisixBed(engine:FisixEngine)
	{
		// Nos subscribimos a los eventos de la stage. La stage durante el constructor no está asignada todavía, así que hay que
		// esperar a que la asignen para poder hacer la subscripcion a sus eventos.
		addEventListener(Event.ADDED_TO_STAGE, function():void { stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown); } );
		addEventListener(Event.ADDED_TO_STAGE, function():void { stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove); } );
		addEventListener(Event.ADDED_TO_STAGE, function():void { stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp); } );
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		mEngine = engine;
		mSurfaceObject = new InternalBed();
		mEngine.addObject(mSurfaceObject);
	}
	
	public function onStageMouseDown(event:MouseEvent) : void
	{
		switch(mState)
		{
			case "NULL":
			case "IDLE":
			case "VIBRATING":
				mPoints.length = 0;
				graphics.clear();
				mPoints.push(new Point(event.localX, event.localY));
				mState = "DRAWING";
			break;
		}
	}
	
	public function onStageMouseMove(event:MouseEvent) : void
	{
		if (mState == "DRAWING")
		{
			mPoints.push(new Point(event.localX, event.localY));
			
			// Vigilamos el tamaño maximo.
			while (GetLenght() > GameConstants.BED_MAX_LENGHT)
			{
				mPoints.shift();
			}
			
			// Movemos la superficie fisica
			mSurfaceObject.SetParticleAPos(mPoints[0]);
			
			if (mPoints.length > 1)
			{
				mSurfaceObject.SetParticleBPos(mPoints[mPoints.length-1]);
			}
			else
			{
				mSurfaceObject.SetParticleBPos(mPoints[0]);
			}
		}
	}
	
	public function onStageMouseUp(event:MouseEvent) : void
	{
		if (mState == "DRAWING")
		{
			mPoints.push(new Point(event.localX, event.localY));
			mState = "IDLE";
		}
	}

	public function onCollide() : void
	{
		mState = "VIBRATING";
	}
	
	public function onEnterFrame(event:Event) : void
	{
		graphics.clear();
		
		switch (mState)
		{
			case "IDLE":
			case "DRAWING":
				DrawNormal();
			break;
			case "VIBRATING":
				DrawVibrating();
			break;
		}
	}
	
	public function onUpdate(elapsedTime:int) : void
	{
		if (mState == "VIBRATING")
		{
			mVibratingParam = (GameConstants.BED_VIBRATING_TIME - mVibratingTime)*0.1*Math.cos((mVibratingTime + Math.PI*0.5) / 10);
			mVibratingTime += elapsedTime;
			
			if (mVibratingTime >= GameConstants.BED_VIBRATING_TIME)
			{
				mVibratingTime = 0;
				mPoints.length = 0;
				mState = "NULL";
			}
		}
	}
	
	public function DrawNormal() : void
	{
		var nPoints:int = mPoints.length;

		if (nPoints > 0)
		{
			graphics.moveTo(mPoints[0].x, mPoints[0].y);
			graphics.lineStyle(10, 0x0000FF);
			graphics.drawCircle(mPoints[0].x, mPoints[0].y, 4);
			
			for (var c:int = 1; c < nPoints; c++)
			{
				graphics.lineTo(mPoints[c].x, mPoints[c].y);
			}
			
			graphics.drawCircle(mPoints[nPoints-1].x, mPoints[nPoints-1].y, 4);
		}
	}
	
	public function DrawVibrating() : void
	{
		var nPoints:int = mPoints.length;

		if (nPoints > 1)
		{
			var firstPoint:Point = mPoints[0];
			var secondPoint:Point = mPoints[mPoints.length-1];
			var centralPoint:Point = new Point((firstPoint.x + secondPoint.x)*0.5, (firstPoint.y + secondPoint.y)*0.5);
			var normal:Point = GetNormal();
			normal.normalize(mVibratingParam);
			var controlPoint:Point = centralPoint.add(normal);
			
			graphics.moveTo(firstPoint.x, secondPoint.y);			
			graphics.lineStyle(10, 0x0000FF, 1 - mVibratingTime/GameConstants.BED_VIBRATING_TIME);
			
			graphics.drawCircle(firstPoint.x, firstPoint.y, 4);			
			graphics.curveTo(controlPoint.x, controlPoint.y, secondPoint.x, secondPoint.y);	
			graphics.drawCircle(secondPoint.x, secondPoint.y, 4);
		}
	}
	
	public function IsCollision(point:Point, rad:Number) : Boolean
	{
		if (!mPoints.length || mState == "VIBRATING")
			return false;
			
		// Distancia de un punto a una recta http://mathworld.wolfram.com/Point-LineDistance2-Dimensional.html
		var pOne:Point = mPoints[0];
		var pTwo:Point = mPoints[mPoints.length-1];		
		var dist:Number = 0;

		var denom:Number = Point.distance(pTwo, pOne);		
		
		if (denom != 0)
			dist = Math.abs(((pTwo.x-pOne.x)*(pOne.y-point.y)) - ((pOne.x-point.x)*(pTwo.y-pOne.y))) / denom;
		else
			dist = Point.distance(pOne, point);
		
		// Si hay colision...
		if (dist < rad)
		{
			// Calculamos ahora si esta distancia está dentro de la recta viendo que el prod. scalar de la tangente y el vector
			// que une los puntos de la recta con el otro punto tiene que ser 0 (ambos vectores tienen q ser perpendiculares entre sí)
			var tangent:Point = pTwo.subtract(pOne);
			var t:Number = (point.x-pOne.x)*tangent.x + (point.y-pOne.y)*tangent.y;
			t = t / (tangent.x*tangent.x + tangent.y*tangent.y);
		
			// El punto de distancia puede estar fuera del segmento y aún así haber colision, puesto que se trata de un circulo.
			// Para solucionarlo, miramos la distancia a los puntos extremos del segmento
			var distPoint:Point = new Point(pOne.x + (tangent.x*t), pOne.y + (tangent.y*t));
			if (t < 0)
			{
				dist = Point.distance(distPoint, pOne);
			}
			else if (t > 1)
			{
				dist = Point.distance(distPoint, pTwo);
			}
		}
		
		return dist < rad;
	}
	
	public function GetNormal() : Point
	{
		var ret:Point = new Point(0, -1);
		
		if (mPoints.length > 1)
		{
			var tangent:Point = mPoints[mPoints.length-1].subtract(mPoints[0]);
			ret.x = tangent.y;
			ret.y = -tangent.x;
			
			// Si la normal va hacia abajo (pq la linea va hacia la izquierda), hay que darle la vuelta
			if (ret.y > 0)
			{
				ret.y = -ret.y;
				ret.x = -ret.x;
			}
		}
		
		ret.normalize(1);
		
		return ret;
	}
	
	private function GetFromStartToEndLenght() : Number
	{
		var ret:Number = 0;
		
		if (mPoints.length > 1)
		{
			ret = Point.distance(mPoints[mPoints.length-1], mPoints[0]);
		}
		
		return ret;
	}
	
	private function GetLenght() : Number
	{
		var ret:Number = 0;
		
		if (mPoints.length > 1)
		{
			var maxPoints:int = mPoints.length-1;
			for (var i:int = 0; i < maxPoints; i++)
			{
				ret += Point.distance(mPoints[i+1], mPoints[i]);
			}
		}
		
		return ret;
	}
	
}	// class FisixBed

}	// package

import com.fileitup.fisixengine.core.FisixObject;
import com.fileitup.fisixengine.constraints.*;
import com.fileitup.fisixengine.collisions.*;
import com.fileitup.fisixengine.particles.*;
import com.fileitup.fisixengine.primitives.*;
import com.fileitup.fisixengine.core.*;
import com.fileitup.fisixengine.utils.*;
import com.fileitup.fisixengine.surfaces.*;
import com.fileitup.fisixengine.graphics.*;

import flash.geom.Point;
import flash.utils.Timer;
import flash.events.TimerEvent;
	

class InternalBed extends FisixObject
{
	private var mSurface:Surface = null;
	private var mParticleA:CircleParticle = null;
	private var mParticleB:CircleParticle = null;
	private var mTimer:Timer = new Timer(1000);
	
	public function SetParticleAPos(pos:Point) : void
	{
		CopyPointToVector(mParticleA.pos, pos);
	}
	
	public function SetParticleBPos(pos:Point) : void
	{
		CopyPointToVector(mParticleB.pos, pos);
	}
	

	public function InternalBed() : void
	{
		makeStatic();
		mParticleA = newCircleParticle(100, 300, 5);
		mParticleB = newCircleParticle(200, 300, 5);
		mParticleA.active = false;
		mParticleB.active = false;
		mParticleA.name = "A";
		mParticleB.name = "B";
		mSurface = newSurface(mParticleA.pos, mParticleB.pos, 10);
		mSurface.name = "Surface";
		mSurface.bounce = 1;
		mSurface.friction = 1;
		setCenter(300, 500);
	}

	private function CopyPointToVector(vec:Vector, point:Point) : void
	{
		vec.x = point.x; vec.y = point.y;
	}
	
	
	protected override function onChildCollision(child:CollisionObject, data:CollisionData) : void
	{
<<<<<<< .mine
		data.object.thrust(0, -10, true);
=======
		var parent : FisixObject = data.object.parent;
		for (var c : int = 0; c < parent.particles.length; c++)
		{
			if (parent.particles[c].name == "CenterBody")
			{
//				parent.particles[c].applyForce(new Vector(0, -10000), false);
				parent.particles[c].setVelocity(new Vector(0, -20));
				break;
			}
		}
>>>>>>> .r12
	}
}