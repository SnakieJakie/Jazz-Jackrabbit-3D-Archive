//=============================================================================
// JazzPump.
//=============================================================================
class JazzPump expands JazzProjectile;

var int PrevLength;
// The maximum distance the pump cord can reach
var () float MaxLength;
// The current Victim
var pawn Victim;

var bool bDestroyed;


simulated function Pump(float Amount);

simulated event Tick(float DeltaTime)
{
	CheckContact();
}

simulated singular function Touch(Actor Other)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, TestLocation;
	
	if ( Other.isa('pawn') && (other != instigator))
	{
		Victim = pawn(Other);
		GotoState('Pumping');
	}
}

simulated state Pumping
{
	simulated singular function Touch(Actor Other);
	
	simulated function BeginState()
	{
		SetPhysics(Phys_None);
	}
	
	simulated function Pump(float Amount)
	{
		if ((JazzPawn(Victim) != None) && (JazzPawn(Victim).FatnessReversed))
		{
			if(Victim.Fatness<=Amount)
			{
				//TODO: Explode Victim in funky way
				Victim.GotoState('Dying');
				Destroy();
			}
			else
			{
				Victim.Fatness -= Amount;
			}
		}
		else
		{
			if(Victim.Fatness+Amount >= 255)
			{
				//TODO: Explode Victim in funky way
				Victim.GotoState('Dying');
				Destroy();
			}
			else
			{
				Victim.Fatness += Amount;
			}
		}
	}
	
	simulated event Tick(float DeltaTime)
	{
		if(Victim == None)
		{
			Destroy();
		}
	
		SetLocation(Victim.Location);
	}
}

simulated function HitWall (vector HitNormal, actor wall)
{
	Destroy();
}


simulated function Landed(Vector HitNormal)
{
	Destroy();
}


simulated function KillCord()
{
	local PumpCord Cord;
	foreach ChildActors ( class'PumpCord', Cord )
			{
				Cord.Destroy();
			}
}

simulated function Timer()
{
	local PumpCord r;
	local actor Other;
	local vector HitLocation,HitNormal;
	
	bRotateToDesired=True;

	if(vsize(Location-Instigator.Location) > MaxLength)
	{
		Destroy();
		return;
	}
	
	if (vsize(Location-Instigator.Location) > prevlength * 35)
	{
		r = spawn(class'PumpCord', self,, location * vector(rotation) * 5);
		r.SegNum = prevlength * 35;
		prevlength +=2;
	}
}

simulated event Destroyed()
{
	bDestroyed = true;
	
	if(Victim != None)
	{
		Victim.Fatness = Victim.Default.Fatness;
	}
	
	KillCord();
}

simulated function PostBeginPlay()
{
	SetTimer(0.01, True);
	Velocity = (Vector(Rotation) * 1000.0);
	bDestroyed = false;	
}

simulated function CheckContact()
{
	local actor Other;
	local vector HitLocation, HitNormal;
	
	Other = Trace(HitLocation, HitNormal, Instigator.Location+vect(0,0,1),Location+vect(0,0,1));
	
	if(Other != Instigator)
	{
		if(Victim != None && Victim == Other)
		{
			return;
		}
		Self.Destroy();
	}
}

defaultproperties
{
     MaxLength=2500.000000
     InitialVelocity=900.000000
     speed=800.000000
     Mesh=Mesh'JazzObjectoids.pumptip'
     bUnlit=False
}
