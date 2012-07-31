package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.utils.Timer;
	
	import com.fileitup.fisixengine.core.FisixEngine;
	import com.fileitup.fisixengine.particles.*;
	import com.fileitup.fisixengine.core.*;
	import com.fileitup.fisixengine.utils.*;

		
	public class Level extends Sprite
	{
		private var mLava : Array = new Array();
		private var mMarcador : Sprite;
		private var mCurrentPixel:Number = 0;
		private var mGlobos : Array = new Array();
		private var mTimer : Timer;
				
		public function Level()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		public function get LavaHeight() : Number { return mLava[0].height; }
		
		private function onAddedToStage(event:Event) : void
		{
			mMarcador = new Resources.Marcador();
			addChild(mMarcador);
			
			mLava.push(new Resources.Lava());
			mLava.push(new Resources.Lava());
			addChild(mLava[0]);
			addChild(mLava[1]);
			
			mLava[0].y = stage.stageHeight - mLava[0].height;
			mLava[1].y = mLava[0].y;
			
			// Generacion de globos
			mTimer =  new Timer(3000);
			mTimer.addEventListener(TimerEvent.TIMER, onGlobosTimer);
			mTimer.start();
			onGlobosTimer(null);
		}
		
		public function onGlobosTimer(event:TimerEvent) : void
		{
			var globoSprite : Sprite = new Resources.GloboAzul();
			globoSprite.x = stage.stageWidth - 100;
			globoSprite.y = Math.random() * stage.stageHeight * 0.7;
			globoSprite.scaleX = 0.3;
			globoSprite.scaleY = 0.3;
			addChild(globoSprite);
			
			mGlobos.push(globoSprite);
			
			mTimer.delay = Math.random()*2000 + 500;
		}
		
		public function CollisionWithGlobos(ragDoll:Ragdoll) : void
		{
			for (var c:int = 0; c < ragDoll.particles.length; c++)
			{
				var part : CircleParticle = ragDoll.particles[c];
				var pos:Point = new Point(part.pos.x, part.pos.y);
				
				for (var d:int = 0; d < mGlobos.length; d++)
				{
					var diff : Point = new Point(pos.x - mGlobos[d].x - (mGlobos[d].width*0.5),
												 pos.y - mGlobos[d].y - (mGlobos[d].height*0.5));
												 
					if (diff.length < (mGlobos[d].width*0.5) + part.radius)
					{
						diff.normalize(GameConstants.REBOUND_EXIT_VEL_GLOBO);
						ragDoll.CenterBody.setVelocity(new Vector(diff.x, diff.y));	
						break;
					}
				}
				
				if (d != mGlobos.length)
				{
					removeChild(mGlobos[d]);
					mGlobos.splice(d, 1);
				}
			}
		}		
		
		public function onUpdate(elapsedTime:int):void
		{
			var	scrollWidth : int = mLava[0].width;
			mCurrentPixel -= GameConstants.SCROLL_SPEED_LAVA * elapsedTime;
			
			if (mCurrentPixel <= -scrollWidth)
				mCurrentPixel += scrollWidth;

			mLava[0].x = mCurrentPixel;
			mLava[1].x = mCurrentPixel + scrollWidth;
			
			// Movimiento de los globos por salida por la izquierda
			for (var c:int=0; c < mGlobos.length; c++)
			{
				mGlobos[c].x -= GameConstants.SCROLL_SPEED_GLOBO * elapsedTime;
				mGlobos[c].y += (Math.random() - 0.5);
				
				// Muerte si ya no son visibles
				if (mGlobos[c].x < -mGlobos[c].width)
				{
					removeChild(mGlobos[c]);
					mGlobos.splice(c, 1);
					c--;
				}
			}
		}
	}
}