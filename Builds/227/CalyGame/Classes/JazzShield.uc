//=============================================================================
// JazzShield.
//=============================================================================
class JazzShield expands Projectile;

//
// Base class for shield effects that appear in front of Jazz and follow his motion.
//

var() bool		TouchDamagePawns;
var() bool		TouchAbsorbProjectiles;
var() int		ShieldCharges;
var() float		ShieldDuration;


//////////////////////////////////////////////////////////////////////////////////////
// Base Jazz weapon projectile attack
//////////////////////////////////////////////////////////////////////////////////////
//
// Level 1
//
	simulated function PostBeginPlay()
	{	
		Super.PostBeginPlay();
		Acceleration = vect(0,0,0);
		PlaySound(SpawnSound);
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		MakeNoise(1.0); //FIXME - set appropriate loudness
		PlaySound(ImpactSound);
		
		Destroy();
	}

/////////////////////////////////////////////////////
auto simulated state Flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		Log("ShieldTouch) Start "$Other);

		if ( Other != instigator )
		{
			ShieldTouch(Other);
		}
	}
	
	simulated event Tick (float DeltaTime)
	{
		SetRotation(Owner.Rotation);
		SetLocation(Owner.Location + (vect(1,0,0) >> Rotation)*20);
	}

	simulated function ShieldDie ()
	{
		Log("ShieldDie)");
		GotoState('Die');
	}
	
Begin:
	Log("ShieldActiveState)");
	Sleep(ShieldDuration);
	ShieldDie();
}

// Base nullifies ShieldDie so multiple requests cannot be made.
simulated function ShieldDie ();

// Something has touched the shield!
simulated function ShieldTouch ( actor Other );

// Shield Down
simulated state Die
{
	simulated event Tick ( float DeltaTime )
	{
		SetRotation(Owner.Rotation);
		SetLocation(Owner.Location + (vect(1,0,0) >> Rotation)*20);
	}
	
Begin:
	Destroy();
}

defaultproperties
{
}
