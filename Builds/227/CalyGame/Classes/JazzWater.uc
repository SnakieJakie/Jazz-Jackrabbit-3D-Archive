//=============================================================================
// JazzWater.
//=============================================================================
class JazzWater expands JazzProjectile;

var() int	Rebounce;
var	float	DelayToExplode;

//////////////////////////////////////////////////////////////////////////////////////
// Jazz Water Attack
//////////////////////////////////////////////////////////////////////////////////////
//
// Level 1
//
	simulated function PostBeginPlay()
	{
		Super.PostBeginPlay();
		Acceleration = vect(0,0,0);
		Velocity = (Vector(Rotation) * 1000.0) + vect(0,0,50);
		SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
		PlaySound(SpawnSound);
		
		DelayToExplode = 0.2;
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local JazzWaterSpray Bounce;
		//local RingExplosion Explosion;
	
		if ((DelayToExplode>0))
		return;

		PlaySound(ImpactSound);
		
		// SplashOut
		Log("JazzWater) "$Rebounce);
		if (Rebounce > 0)
		{
			Bounce = spawn(class'JazzWaterSpray');
			Bounce.Velocity = Velocity;
			Bounce.Velocity.Z = -Velocity.Z*0.3;
			Bounce.Rebounce = Rebounce-1;
		}
		
		//Explosion = spawn(class'RingExplosion',,,);
		//Explosion.DrawScale = Rebounce*0.1;
		Destroy();
	}

/////////////////////////////////////////////////////
auto simulated state Flying
{
	function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;
	
		if ( ValidHit(Other) )
		{
			hitdamage = 10;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), 'Water' );
			Explode(Location, vect(0,0,0));
		}
	}
	
	simulated function Tick ( float DeltaTime )
	{
		Acceleration += vect(0,0,-200)*DeltaTime;
		//Velocity += Acceleration;
		
		// Do not explode at first
		DelayToExplode -= DeltaTime;
		
		DrawScale = Rebounce*0.5;
	}
	

Begin:
	Sleep(7.0);
	Explode(Location, vect(0,0,0));
}

defaultproperties
{
     Rebounce=2
     InitialVelocity=1000.000000
     ImpactDamage=10
     ImpactDamageType=Water
     Damage=30.000000
     SpawnSound=Sound'JazzSounds.Interface.whoosh'
     Skin=Texture'JazzArt.Effects.NWater2'
     Mesh=Mesh'UnrealShare.ngel'
     ScaleGlow=2.000000
     AmbientGlow=255
     bUnlit=False
     LightType=LT_Pulse
     LightBrightness=255
     LightHue=153
     LightRadius=2
     bBounce=True
}
