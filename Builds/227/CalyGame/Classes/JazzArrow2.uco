//=============================================================================
// JazzArrow2.
//=============================================================================
class JazzArrow2 expands JazzArrow;


simulated function PostBeginPlay()
{
	local SparkTrail P;
	
	Super.PostBeginPlay();
	Acceleration = vect(0,0,0);
	Velocity = (Vector(Rotation) * InitialVelocity);
	SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
	PlaySound(SpawnSound);
		
	// Arrow Trail
	P = Spawn(class'SparkTrail',Self);
	P.TrailActor = class'DiamondPoofie';
	P.TrailRandomRadius = 20;
	P.Activate(0.1,99999);
}


simulated event Tick (float DeltaTime)
{
	local rotator NewRotation;
	local int Tot,A,B;
	
	if (Velocity.Z < 0)
	Velocity.Z -= ((90-Velocity.Z)*DeltaTime);
	else
	Velocity.Z -= ((90)*DeltaTime);
		
	// Arrow rotation
	//B = (abs(Velocity.Z) / (abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z)))*16535;
	B = (Velocity.Z) * 100 / 10;
	if (B<-16000) B =-16000;
	if (B>16000) B = 16000;
		
	NewRotation = Rotation;
	NewRotation.Pitch = B;
	SetRotation(NewRotation);
}

defaultproperties
{
     InitialVelocity=900.000000
     ImpactDamage=25
     ExplosionWhenHit=Class'CalyGame.TwoHExplo1'
}
