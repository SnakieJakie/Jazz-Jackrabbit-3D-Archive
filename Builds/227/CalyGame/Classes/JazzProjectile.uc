//=============================================================================
// JazzProjectile.
//=============================================================================
class JazzProjectile expands Projectile;

var() float		InitialVelocity;
var() int		ImpactDamage;
var() name		ImpactDamageType;
var() int		RadialDamage;
var() name		RadialDamageType;
var() float		RadialDamageRadius;
var() class		ExplosionWhenHit;
var() class		ProjectileTrail;
var() class		ProjectileTail;

// Tracking capability
//
var() bool		Tracking;
var() float		TrackingAmount;
var() float		TrackingPingTime;
var   float		TrackingTimeSincePing;
var   actor		TrackingFocus;
var   vector	InitialDir;

var	  actor		LastHit;

// Default explosion class
//
simulated function PlayHitExplosion()
{
	local actor		s;
	
	s = spawn(class<actor>(ExplosionWhenHit),,,);
	s.RemoteRole = ROLE_None;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	MakeNoise(1.0); //FIXME - set appropriate loudness
	PlaySound(ImpactSound);
	PlayHitExplosion();
	Destroy();
}

// Check if other thing hit is allowed to be shot.
// Handle special case if we hit a shield.
//
simulated function bool ValidHit (actor Other)
{
	if (Other != Instigator)
	{
		if (JazzShield(Other) != None)
		{
			JazzShield(Other).ShieldTouch(Self);
			return false;
		}
		else
		return true;
	}
	else
	return false;
}

// Rotate projectile if RotationRate not (0,0,0)
//
simulated function Tick (float DeltaTime)
{
	local Pawn P;
	local float Range;
	local vector SeekingDir;
	local float MagnitudeVel;
	
	Super.Tick(DeltaTime);
	
	SetRotation(Rotation+RotationRate*DeltaTime);
	
	// Tracking
	//
	if (Tracking)
	{
		TrackingTimeSincePing += DeltaTime;

		// New radius ping		
		if (TrackingTimeSincePing < TrackingPingTime)
		{
			TrackingFocus = None;
			Range = 100000;
			
			foreach VisibleActors(class'Pawn',P,50000)
			{
				if (P != Instigator)
				{
					if (VSize(Location-P.Location) < Range)
					{
						TrackingFocus = P;
						Range = VSize(Location-P.Location);
					}
				}
			}
		}
	
		Log("TrackingFocus) "$TrackingFocus);
	
		// Turn Toward Focus
		if (TrackingFocus != None)
		{
			SeekingDir = Normal(TrackingFocus.Location - (Location + vect(0,0,-20)));
			if ( (SeekingDir Dot InitialDir) > 0 )
			{
				MagnitudeVel = VSize(Velocity);
				Velocity =  MagnitudeVel * Normal(SeekingDir * TrackingAmount * DeltaTime * MagnitudeVel + Velocity);
				SetRotation(rotator(Velocity));
			}
		}
	}
}

simulated function PostBeginPlay()
{
	local ParticleTrails P;

	Super.PostBeginPlay();

	// Play shot spawn sound
	PlaySound(SpawnSound, SLOT_Misc, 2.0);		
	
	Velocity = (Vector(Rotation) * InitialVelocity);
	InitialDir = vector(Rotation);	
	
	// Projectile Sparkle Trail
	//
	if (ProjectileTrail != None)
	{
	P = Spawn(class'SparkTrail',Self);
	P.TrailActor = ProjectileTrail;
	P.TrailRandomRadius = 10;
	P.Activate(0.1,99999);
	}
	
	// Projectile Tail special effect
	//
	if (ProjectileTail != None)
	{
	Spawn(class<actor>(ProjectileTail),Self);
	}
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     bUnlit=True
}
