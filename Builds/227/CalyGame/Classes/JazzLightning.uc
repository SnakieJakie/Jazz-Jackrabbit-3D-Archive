//=============================================================================
// JazzLightning.
//=============================================================================
class JazzLightning expands JazzProjectile;

var actor ActorHit;

//////////////////////////////////////////////////////////////////////////////////////
// Lightning Spark Attack
//////////////////////////////////////////////////////////////////////////////////////
//
// Level 1
//
	simulated function PostBeginPlay()
	{
		Super.PostBeginPlay();
		Acceleration = vect(0,0,0);
		Velocity = (Vector(Rotation) * 1500.0);
		SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
	}

/////////////////////////////////////////////////////
auto simulated state Flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;

		if ( ValidHit(Other) )
		{
			hitdamage = 8;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), 'Energy' );
				ActorHit = Other;
				
			Explode(HitLocation,vect(0,0,0));
		}
	}

Begin:
	Sleep(5.0);
	Explode(Location, vect(0,0,0));
}

// Default explosion class
//
simulated function PlayHitExplosion()
{
	local actor		s;

	s = spawn(class<actor>(ExplosionWhenHit),,,);
	JazzLightningEff1(s).SpellFocus = ActorHit;
	
	s.RemoteRole = ROLE_None;
}

defaultproperties
{
     InitialVelocity=1500.000000
     ImpactDamage=3
     ImpactDamageType=Energy
     RadialDamage=1
     RadialDamageRadius=100.000000
     ExplosionWhenHit=Class'CalyGame.JazzLightningEff1'
     Mesh=Mesh'UnrealShare.TazerProja'
     LightType=LT_Pulse
     LightEffect=LE_FastWave
     LightBrightness=102
     LightHue=51
     LightSaturation=153
     LightRadius=3
}
