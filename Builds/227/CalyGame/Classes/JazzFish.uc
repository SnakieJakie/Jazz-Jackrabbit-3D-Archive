//=============================================================================
// JazzFish.
//=============================================================================
class JazzFish expands JazzPawnAI;

const FearDistance = 10;
const CurrentFear = 5;
const LookRadius = 500;

function LookAround()
{
	local pawn Other;
	local pawn OldFear;
	
	OldFear = pawn(AfraidTarget);

	foreach RadiusActors ( class'Pawn', Other, LookRadius)
	{
		if(Other != Self)
		{
			if(Other.IsA('JazzFish'))
			{
				if(FriendTarget == None)
				{
					FriendTarget = Other;
				}
				else if((LookRadius - VSize(Other.Location - Location)) > (LookRadius - VSize(FriendTarget.Location - Location)))
				{
					FriendTarget = Other;
				}
			}
			else
			{
				if(AfraidTarget == None)
				{
					AfraidTarget = Other;
				}
				else if((LookRadius - VSize(Other.Location - Location)) > (LookRadius - VSize(AfraidTarget.Location - Location)))
				{
					AfraidTarget = Other;
				}
			}
		}
	}
	
	if(AfraidTarget != OldFear)
	{
		GotoState('Wander','Fear');
	}
}

event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	LookAround();
}

auto state Life
{
	Begin:
	SetPhysics(PHYS_Swimming);
	FriendTarget = None;
	AfraidTarget = None;
	GotoState('Decision');
}

function ZoneChange( ZoneInfo NewZone )
{
	local rotator newRotation;
	if (NewZone.bWaterZone)
	{
		if ( !Region.Zone.bWaterZone && (Physics != PHYS_Swimming) )
		{
			newRotation = Rotation;
			newRotation.Roll = 0;
			SetRotation(newRotation);
			MoveTimer = -1.0;
		}
		SetPhysics(PHYS_Swimming);
	}
	else if (Physics != PHYS_Falling)
	{
		MoveTimer = -1;
		SetPhysics(PHYS_Falling);
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// DECISION 															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state Decision
{
	// Choose an action when there's nothing to do.
	//

	Begin:
	CheckTargetLife();

	// Special : Are we really afraid of something?
	// Do we have a target?
	if (AfraidTarget != None)
	{
		if(VSize(Location - AfraidTarget.Location) < FearDistance * CurrentFear)
		{
			GotoState('Wander','Fear');
		}
		else
		{
			AfraidTarget = None;
		}
	}
	
	// Do we have a friend?
	if (FriendTarget != None)
	{
		if (CanSee(pawn(FriendTarget)))
		{
			GotoState('Wander','Friend');
		}
		else
		{
			FriendTarget = None;
		}
	}

	//Sleep(1);		// Originally here to avoid infinite Decision loop
	GotoState('Wander','Random');
}

/////////////////////////////////////////////////////////////////////////////////
// Wander - Fly around aimlessly									STATES
/////////////////////////////////////////////////////////////////////////////////
//
state Wander
{
	Begin:
	
	Random:

		MoveTo(Location + (100 * VRand()),WalkingSpeed);
		
		GotoState('Decision');
		
	Fear:
	
		Destination = (Location + (-1 * (Location - AfraidTarget.Location) / VSize(Location - AfraidTarget.Location)) * ((FearDistance*CurrentFear) - VSize(Location - AfraidTarget.Location)));
		
		Destination.Z = Location.Z + (100 * VRand()).Z;
		
		MoveTo(Destination,RushSpeed);		
		
		GotoState('Decision');	
	
	Friend:

		MoveTo(FriendTarget.Location + (15 * VRand() + (FRand()*100 - 50)*Vect(0,0,1)),WalkingSpeed);
		
		GotoState('Decision');	
}

defaultproperties
{
     WalkingSpeed=40.000000
     RushSpeed=80.000000
     GroundSpeed=100.000000
     WaterSpeed=100.000000
     Physics=PHYS_Swimming
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.Jfish1_01'
     Mesh=Mesh'JazzObjectoids.fish1'
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     RotationRate=(Pitch=200,Yaw=20000,Roll=2000)
}
