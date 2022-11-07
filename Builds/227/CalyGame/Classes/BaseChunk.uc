//=============================================================================
// BaseChunk.
//=============================================================================
class BaseChunk expands JazzEffects;

var () float FadeTime;
var () float Life;
var 	bool Fading;
var	()	bool ShrinkAway;	// Object shrinks away instead of trying to fade

var float CurLife;

function PostBeginPlay()
{
	SetTimer(Life,false);
	Disable('Tick');
	
	SetRotation( RotRand(true) );
}

event Timer()
{
	Fading = true;
	
	if (!ShrinkAway)
	Style = STY_Modulated;
	
	enable('Tick');
}

event Tick(float DeltaTime)
{
	if (Fading)
	{
		CurLife += DeltaTime;
	
		if(CurLife > FadeTime)
		{
			Destroy();
		}
		else
		{
			if (ShrinkAway)
			{
				DrawScale = Default.DrawScale*(1-(CurLife/FadeTime));
				SetCollisionSize( Default.CollisionRadius * (1-(CurLife/FadeTime)),
								  Default.CollisionHeight * (1-(CurLife/FadeTime)) );
				SetPhysics(PHYS_Falling);
			}
			else
			ScaleGlow = 1 - (CurLife/FadeTime);
		}
	}
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
}

defaultproperties
{
     FadeTime=1.000000
     Life=10.000000
     Physics=PHYS_Falling
}
