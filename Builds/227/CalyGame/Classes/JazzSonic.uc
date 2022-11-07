//=============================================================================
// JazzSonic.
//=============================================================================
class JazzSonic expands JazzProjectile;


//////////////////////////////////////////////////////////////////////////////////////
// Jazz Sonic Cannon
//////////////////////////////////////////////////////////////////////////////////////
//
// Level 1
//

	simulated function PostBeginPlay()
	{
		local CopyTrail C;

		C = spawn(class'CopyTrail',Self);
		C.Activate(0.1,999);
		
		Super.PostBeginPlay();
		Acceleration = vect(0,0,0);
		Velocity = (Vector(Rotation) * 1400.0);
		SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
		PlaySound(SpawnSound);
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		//MakeNoise(1.0); //FIXME - set appropriate loudness
		PlaySound(ImpactSound);
		//spawn(class'Spark34',,,);
		Destroy();
	}

/////////////////////////////////////////////////////
auto simulated state Flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;

		if ( ValidHit(Other) )
		{
			hitdamage = Damage;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), 'Sound' );
			//Explode(Location, vect(0,0,0));
		}
		Log("Touch) ");
	}
	
	simulated event Tick (float DeltaTime)
	{
		DrawScale += DeltaTime/4+0.5;
		// Can't change collision height.  Annoying.
	}
	
	simulated function HitWall( vector HitNormal, actor Wall )
	{
		Log("Velocity) "$Velocity);
		//Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		//Velocity = (( Velocity dot HitNormal ) * HitNormal);   // Reflect off Wall w/damping
		Velocity = 300 * HitNormal;
		Log("Velocity) "$Velocity);
		SetPhysics(PHYS_Projectile);
	}

Begin:
	Sleep(7.0);
	Explode(Location, vect(0,0,0));
}

defaultproperties
{
     InitialVelocity=300.000000
     ImpactDamage=10
     ImpactDamageType=Sound
     Damage=10.000000
     Style=STY_None
     Mesh=Mesh'UnrealShare.Ringex'
     DrawScale=2.000000
     ScaleGlow=1.100000
     AmbientGlow=255
     bUnlit=False
     CollisionRadius=2.000000
     CollisionHeight=20.000000
     bBounce=True
}
