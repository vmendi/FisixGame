package
{
	import com.fileitup.fisixengine.particles.CircleParticle;
	
	public class AutoRemoveParticle extends CircleParticle{
		public function AutoRemoveParticle(x:Number,y:Number,rad:Number){
			super(x,y,rad)
		}
		override protected function afterIntegrate(dt:Number):void{
			if(pos.y>500+radius)
				unload()
		}
	}
}