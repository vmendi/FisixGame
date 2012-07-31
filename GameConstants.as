package {
	
public class GameConstants
{
	public static const GRAVITY:Number = 2.0;			// Pixeles/s^2

	public static const BED_MAX_LENGHT:Number = 200;	// Pixeles
	public static const BED_VIBRATING_TIME:Number = 600;// Tiempo que la cama vibra antes de desaparecer. Milisecs
	
	public static const REBOUND_EXIT_VEL:Number = 20;		// Módulo de la velocidad de salida de la bola después del rebote en la cama. Pixeles
	public static const REBOUND_EXIT_VEL_GLOBO:Number = 10;	// Idem con globos...
	public static const LEFT_EXIT_VEL:Number = 4;			// Idem por la izquierda
	public static const RIGHT_EXIT_VEL:Number = 4;			// Idem por la derecha
	
	public static const SCROLL_SPEED_LAVA:Number = 0.05;		// pixels / milisec
	public static const SCROLL_SPEED_GLOBO:Number = 0.1;		// pixels / milisec
}

}