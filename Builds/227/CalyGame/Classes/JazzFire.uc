//=============================================================================
// JazzFire.
//=============================================================================
class JazzFire expands JazzProjectile;

var() sound	WaterFizzleSound;


//////////////////////////////////////////////////////////////////////////////////////
// Jazz Fire Attack
//////////////////////////////////////////////////////////////////////////////////////
//
// Level 1
//

	simulated function PostBeginPlay()
	{
		local ParticleTrails P;
	
		Super.PostBeginPlay();

		Velocity = (Vector(Rotation) * 1000.0) - vect(0,0,100);

/*		Acceleration = vect(0,0,0);
		SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
		PlaySound(SpawnSound);*/
		
		// Arrow Trail
		P = Spawn(class'SparkTrail',Self);
		P.TrailActor = class'SpritePoofieFireSpark';
		P.TrailRandomRadius = 10;
		P.Activate(0.05,99999);
	}

	simulated function ZoneChange( ZoneInfo NewZone )
	{
		local JazzSmokeGenerator S;
		if (NewZone.bWaterZone)
		{
			S = spawn(class'JazzSmokeGenerator');
			S.TotalNumPuffs = 5;
			S.RisingVelocity = 50;
			S.GenerationType = class'JazzSmoke';
			S.Trigger(None,None);
			
			PlaySound(WaterFizzleSound);
			GotoState('Fizzling');
		}
	}

simulated function HitWall (vector HitNormal, actor Wall)
{
	if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
	{
		Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');
		MakeNoise(1.0);
		Explode(Location + ExploWallOut * HitNormal, HitNormal);
	}
	Velocity = vect(400,0,0) >> Rotation;
	Velocity.Z = -25;
	//Velocity.Z = -Velocity.Z
	SetLocation(Location + vect(0,0,4)); 
}

auto simulated state Flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;

		if ( Other == None )			// Continue rolling
		{
			Velocity += vect(50,0,0) << Rotation;
			SetPhysics(PHYS_Falling);
		}
		else
		if ( ValidHit(Other) )
		{
			hitdamage = 10;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), 'Fire' );
			Explode(Location, vect(0,0,0));
		}
	}
	
	simulated function Tick ( float DeltaTime )
	{
		Acceleration += vect(0,0,-400)*DeltaTime;
		//Velocity += Acceleration;
	}
	
Begin:
	Sleep(7.0);
	Explode(Location, vect(0,0,0));
}

simulated state Fizzling
{
	Begin:
	bHidden = true;
	Sleep(2);
	Destroy();
}

defaultproperties
{
     ImpactDamage=10
     ImpactDamageType=Fire
     ExplosionWhenHit=Class'UnrealShare.RingExplosion2'
     Damage=30.000000
     SpawnSound=Sound'JazzSounds.Weapons.fireshot'
     Skin=Texture'JazzArt.Effects.NLava4'
     Mesh=Mesh'UnrealShare.ngel'
     DrawScale=1.200000
     AmbientGlow=255
     bUnlit=False
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     LightType=LT_Pulse
     LightBrightness=255
     LightRadius=4
}
