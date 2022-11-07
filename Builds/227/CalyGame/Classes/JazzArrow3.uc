//=============================================================================
// JazzArrow3.
//=============================================================================
class JazzArrow3 expands JazzArrow;

simulated function PostBeginPlay()
{
	local SparkTrail P;
	
	Super.PostBeginPlay();
	Acceleration = vect(0,0,0);
	Velocity = (Vector(Rotation) * InitialVelocity);
	SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
	PlaySound(SpawnSound);
		
	// Arrow Attachment
	Spawn(class'AttachElecBolt',Self);
		
	// Arrow Trail
	P = Spawn(class'SparkTrail',Self);
	P.TrailActor = class'SpritePoofieRing';
	//P.TrailRandomRadius = 0;
	P.Activate(0.05,99999);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local ParticleFadeUp	P;

	MakeNoise(1.0); //FIXME - set appropriate loudness
	PlaySound(ImpactSound);
		
	spawn(class<actor>(ExplosionWhenHit),LastHit,,);
	
	P = spawn(class'ParticleFadeUp',LastHit,,,RotRand(false));
	//P.Texture = texture'jazzp5';	// JAZZ3 TEXTURING
	
	Destroy();
}
	
/*function ReDistribute ()
{
	local Actor			 	S;
	local int 				X;
	local rotator			NewRotation,NewRotation2;
	
	NewRotation = Rotation;
	NewRotation.Pitch += 3000;
	
	for (x=0; x<5; x++)
	{
	NewRotation.Yaw += 65536/5;
	//NewRotation.Pitch += 65536/5;
	
	S = spawn(class'JazzArrowLightning',Owner,,,NewRotation);
	S.SetPhysics(PHYS_Projectile);
	S.SetRotation(NewRotation);
	S.Velocity = vect(500,0,0) >> NewRotation;
	}
	
	Destroy();
}*/

simulated event Tick (float DeltaTime)
{
	local rotator NewRotation;
	local int Tot,A,B;
	
	if (Velocity.Z < 0)
	Velocity.Z -= ((80-Velocity.Z)*DeltaTime);
	else
	Velocity.Z -= ((80)*DeltaTime);
		
	// Arrow rotation
	//B = (abs(Velocity.Z) / (abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z)))*16535;
	B = (Velocity.Z) * 100 / 10;
	if (B<-16000) B =-16000;
	if (B>16000) B = 16000;
		
	NewRotation = Rotation;
	NewRotation.Pitch = B;
	SetRotation(NewRotation);
}

auto simulated state flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;

		if ( ValidHit(Other) )
		{
			LastHit = Other;
			
			hitdamage = ImpactDamage;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), ImpactDamageType );

			Explode(HitLocation,vect(0,0,0));
		}
	}
}

defaultproperties
{
}
