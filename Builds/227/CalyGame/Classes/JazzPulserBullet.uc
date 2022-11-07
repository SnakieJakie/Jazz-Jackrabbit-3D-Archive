//=============================================================================
// JazzPulserBullet.
//=============================================================================
class JazzPulserBullet expands Projectile;

//<DEVCHANGE>
	simulated function PostBeginPlay()
	{
		Super.PostBeginPlay();
		Acceleration = vect(0,0,0);
		Velocity = (Vector(Rotation) * 1500.0);
		SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		MakeNoise(1.0); //FIXME - set appropriate loudness
		//spawn(class'Spark34',,,);
		Destroy();
	}

/////////////////////////////////////////////////////
auto simulated state Flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;

		if ( Other != instigator )
		{
			hitdamage = 10;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), 'zapped' );
			Explode(Location, vect(0,0,0));
		}
	}

Begin:
	Sleep(7.0);
	Explode(Location, vect(0,0,0));
}
//</DEVCHANGE>

defaultproperties
{
     Mesh=Mesh'UnrealShare.DispM1'
     DrawScale=0.500000
}
