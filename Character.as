package {
	
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.MovieClip;
import flash.geom.Point;

[Embed(source='assets/Main.swf', symbol='DaBola')]
public class Character extends Sprite
{
	private var m_Vel : Point = new Point(0, 0);
	private var m_Pos : Point = new Point(0, 0);
		
	public function Character()
	{
	}
	
	public function Reset() : void
	{
		m_Vel = new Point(0, 0);
		m_Pos = new Point(stage.stageWidth * 0.5, 0);
	}

	public function onUpdate(elapsedTime:int) : void
	{
		m_Pos = GetNextPos(elapsedTime);
		m_Vel = GetNextVel(elapsedTime);
		
		// Nos salimos por abajo?
		if (m_Pos.y >= stage.stageHeight)
		{
			Reset();
		}
		
		// Comprobamos colisiones con las paredes
		if (m_Pos.x - (width*0.5) < 0)
		{			
			m_Pos.x = width*0.5;
			m_Vel.x = -m_Vel.x;
		}
		else if (m_Pos.x + (width*0.5) > stage.stageWidth)
		{
			m_Pos.x = stage.stageWidth - (width*0.5);
			m_Vel.x = -m_Vel.x;
		}
		
		// El sprite tiene como origen de coordenas la esquina izquierda, hacemos la conversion
		x = m_Pos.x - (width*0.5);
		y = m_Pos.y - (height*0.5);
	}
	
	public function GetNextVel(elapsedTime:int) : Point
	{
		var test : Number = GameConstants.GRAVITY * elapsedTime / 1000.0;
		var accel : Point = new Point(0, test);		
		return m_Vel.add(accel);
	}
	
	public function GetNextPos(elapsedTime:int) : Point
	{
		return m_Pos.add(GetNextVel(elapsedTime));
	}
	
	public function ApplyForce(dir:Point) : void
	{
		m_Vel =	dir;
		m_Vel.normalize(GameConstants.REBOUND_EXIT_VEL);
	}
	
	public function get Pos() : Point
	{
		return m_Pos;
	}
	
	public function get Radius():Number 
	{
		var biggest:Number = width > height? width*0.5 : height*0.5;
		return biggest;
	}
	
}

}	// package