//=============================================================================
// JazzButterfly.
//=============================================================================
class JazzButterfly expands JazzPawnAI;

var () float MaxHeight;
var () float LookRadius;
var () float FearDistance;

var int CurrentLike;
var int CurrentFear;

var rotator Rotat;

var JazzDecoration Flower;

event SeePlayer(actor Seen)
{
}

function bool LookForFlowers()
{
	local JazzDecoration Other;
	
	foreach RadiusActors ( class'JazzDecoration', Other, LookRadius*4)
	{
		if(!Other.bInUse)
		{
			if(Other.IsA('BlueFlower') || Other.IsA('flower1a') || Other.IsA('flower1b') || Other.IsA('flower1open') || Other.IsA('YellowFlower'))
			{
				if(Flower == None)
				{
					Flower = Other;
					Flower.bInUse = true;
				}
				else if(VSize(Location - Flower.Location) > VSize(Location - Other.Location))
				{
					Flower.bInUse = false;
					Flower = Other;
					Flower.bInUse = true;
				}
			}
		}
	}
	
	if(Flower != None)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function int Eval(pawn Other)
{
	if(Other.IsA('JazzFairy'))
	{
		return 5;
	}
	else if(Other.IsA('JazzPlayer'))
	{
		return 5;
	}
	else if(Other.IsA('JazzThinker'))
	{
		return 4;
	}
	else if(Other.IsA('Turtle1'))
	{
		return 5;
	}
	else if(Other.IsA('Lizard'))
	{
		return 8;
	}
	
	return 0;
}

function LookAround()
{
	local pawn Other;
	local pawn OldFear;
	
	OldFear = pawn(AfraidTarget);

	foreach RadiusActors ( class'Pawn', Other, LookRadius)
	{
		if(Other != Self)
		{
			if(Other.IsA('JazzFairy') || Other.IsA('JazzPlayer') || Other.IsA('JazzThinker'))
			{
				if(FriendTarget == None)
				{
					FriendTarget = Other;
					CurrentLike = Eval(Other);
				}
				else if(Eval(Other)*(LookRadius - VSize(Other.Location - Location)) > CurrentLike*(LookRadius - VSize(FriendTarget.Location - Location)))
				{
					FriendTarget = Other;
					CurrentLike = Eval(Other);
				}
			}
			else if(JazzPawnAI(Other) != None)
			{
				if(AfraidTarget == None)
				{
					AfraidTarget = Other;
					CurrentFear = Eval(Other);
				}
				else if(Eval(Other)*(LookRadius - VSize(Other.Location - Location)) > CurrentFear*(LookRadius - VSize(AfraidTarget.Location - Location)))
				{
					AfraidTarget = Other;
					CurrentFear = Eval(Other);
				}
				
				if(CurrentFear == 0)
				{
					AfraidTarget = None;
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
	// Super.Tick(DeltaTime);
	LookAround();
	
	if(AfraidTarget != None)
	{
		if(Flower != None)
		{
			Flower.bInUse = false;
			Flower = None;
			LoopAnim('Bfly1afly');
		}
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
	
	if(FRand() < 0.1)
	{
		if(LookForFlowers())
		{
			GotoState('Wander','Flowerland');
		}
	}	
	
	if (Flower != None)
	{
		GotoState('Wander','Flowerland');
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

/////////////////////////////////////////////////////////////////////////////////////
// LIFE		 															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
auto state Life
{
	Begin:
	SetPhysics(PHYS_Flying);
	Velocity = vect(0,0,0);
	FriendTarget = None;
	AfraidTarget = None;
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////
// Wander - Fly around aimlessly									STATES
/////////////////////////////////////////////////////////////////////////////////
//
state Wander
{
	function bool CheckFloor()
	{
		local vector HitLocation, HitNormal;
		local actor Hit;
		
		Hit = Trace(HitLocation,HitNormal, Vect(0,0,-1) * MaxHeight + Location,,false);
		
		if(Hit != None)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	Begin:
	
	Random:
	
		if(LookForFlowers())
		{
			Goto('FlowerLand');
		}
		
		// Check to see how far from the ground we are
		if(CheckFloor())
		{
			// We are close enough to the ground
			MoveTo(Location + (100 * (VRand() + vect(0,0,0.3))),WalkingSpeed);
		}
		else
		{
			// We should move down a bit
			MoveTo(Location + (100 * (VRand() + vect(0,0,-0.5))),WalkingSpeed);
		}
		
		GotoState('Decision');
		
	Fear:
	
		// Check to see how far from the ground we are
	
		Destination = (Location + (-1 * (Location - AfraidTarget.Location) / VSize(Location - AfraidTarget.Location)) * ((FearDistance*CurrentFear) - VSize(Location - AfraidTarget.Location)));
		
		if(CheckFloor())
		{
			// We are close enough to the ground
			Destination.Z = Location.Z + (100 * (VRand() + vect(0,0,0.3))).Z;
		}
		else
		{
			// We should move down a bit
			Destination.Z = Location.Z + (100 * (VRand() + vect(0,0,-0.5))).Z;
		}

		MoveTo(Destination,RushSpeed);		
		
		GotoState('Decision');	
	
	Friend:
		// Check to see how far from the ground we are
		
		if(CheckFloor())
		{
			// We are close enough to the ground
			MoveTo(FriendTarget.Location + (15 * (VRand() + vect(0,0,0.3))),WalkingSpeed);
		}
		else
		{
			// We should move down a bit
			MoveTo(FriendTarget.Location + (15 * (VRand() + vect(0,0,-0.7))),WalkingSpeed);
		}
		
		GotoState('Decision');	
		
	FlowerLand:
		MoveTo(Flower.Location+Vect(0,0,6.5),WalkingSpeed);
		
		SetLocation(Flower.Location+Vect(0,0,6.5));
		
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		Rotat = rot(0,0,0);
		Rotat.Yaw = Rotation.Yaw;
		SetRotation(Rotat);
		
		Flower.bInUse = false;
		Flower = None;
		
		LoopAnim('Bfly1aidle');

		Sleep(4+(5*Frand()));
		
		GotoState('Decision');
}

defaultproperties
{
     MaxHeight=100.000000
     LookRadius=300.000000
     FearDistance=10.000000
     WalkingSpeed=25.000000
     RushSpeed=75.000000
     AfraidDuration=0.000000
     AirSpeed=225.000000
     bStasis=False
     DrawType=DT_Mesh
     Skin=Texture'JazzObjectoids.Skins.JBfly1a_01'
     Mesh=Mesh'JazzObjectoids.Bfly1a'
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     RotationRate=(Pitch=8000,Roll=7000)
}
