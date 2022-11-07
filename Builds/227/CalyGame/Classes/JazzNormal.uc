//=============================================================================
// JazzNormal.
//=============================================================================
class JazzNormal expands JazzProjectile;


//////////////////////////////////////////////////////////////////////////////////////
// Base Jazz weapon projectile attack
//////////////////////////////////////////////////////////////////////////////////////
//
// Level 1
//
	simulated function PostBeginPlay()
	{
		// Projectile works for some reason when a log is here.
		
		Super.PostBeginPlay();
		Velocity = (Vector(Rotation) * InitialVelocity);
		SetLocation( Location + vect(0,0,30) );	// - Velocity offsets initial start location error in Unreal
	}

/////////////////////////////////////////////////////
auto simulated state Flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;

		//Log("NormalShot) "$Other$" "$Instigator);
		if ( ValidHit(Other) )
		{
			hitdamage = ImpactDamage;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), 'Energy' );
			Explode(Location, vect(0,0,0));
		}
	}

Begin:
	Sleep(7.0);
	Explode(Location, vect(0,0,0));
}

defaultproperties
{
     InitialVelocity=1500.000000
     ImpactDamage=10
     ImpactDamageType=Energy
     ExplosionWhenHit=Class'CalyGame.YellowCircleTiny'
     SpawnSound=Sound'JazzSounds.Weapons.gun1'
     ImpactSound=Sound'JazzSounds.Interface.menuhit'
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'JazzArt.Particles.Jazzp10'
     DrawScale=0.200000
     bUnlit=False
     CollisionRadius=5.000000
     CollisionHeight=5.000000
}
