//=============================================================================
// JazzFairy.
//=============================================================================
class JazzFairy expands JazzPawnAI;

var ParticleTrails ParticleTrail;
var () float MaxHeight;
var () float LookRadius;
var () float FearDistance;

var () texture NormalTexture;
var () texture FearTexture;
var () texture FriendTexture;

var int CurrentLike;
var int CurrentFear;

function int Eval(pawn Other)
{
	if(Other.IsA('JazzFairy'))
	{
		return 10;
	}
	else if(Other.IsA('JazzButterfly'))
	{
		return 4;
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
			if(Other.IsA('JazzFairy') || Other.IsA('JazzPlayer') || Other.IsA('JazzThinker') || Other.IsA('JazzButterFly'))
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

/////////////////////////////////////////////////////////////////////////////////////
// LIFE		 															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
auto state Life
{
	Begin:
	SetPhysics(PHYS_Flying);
	ParticleTrail = Spawn(class'ParticleTrails',self);
	ParticleTrail.TrailActor = class'CalyGame.FairyTrail';
	ParticleTrail.TrailRandomRadius = 0;
	ParticleTrail.Activate(0.3);
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
	
		// Check to see how far from the ground we are
		
		Texture = NormalTexture;
		ParticleTrail.TrailActor = class'CalyGame.FairyTrail';
		LightHue = 35;
		
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
		
		Texture = FearTexture;
		ParticleTrail.TrailActor = class'CalyGame.FairyTrailFear';
		LightHue = 0;
		
		MoveTo(Destination,RushSpeed);		
		
		GotoState('Decision');	
	
	Friend:
		// Check to see how far from the ground we are
		
		Texture = FriendTexture;
		ParticleTrail.TrailActor = class'CalyGame.FairyTrailFriend';
		LightHue = 170;
		
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
}

defaultproperties
{
     MaxHeight=100.000000
     LookRadius=500.000000
     FearDistance=10.000000
     AttitudeVsPlayer=ATT_Uncaring
     WalkingSpeed=25.000000
     RushSpeed=75.000000
     AfraidDuration=0.000000
     AirSpeed=325.000000
     SightRadius=2000.000000
     PeripheralVision=-10.000000
     AttitudeToPlayer=ATTITUDE_Friendly
     bStasis=False
     Physics=PHYS_Flying
     Style=STY_Translucent
     Sprite=Texture'JazzArt.Particles.Jazzp10'
     Texture=Texture'JazzArt.Particles.Jazzp10'
     Skin=Texture'JazzArt.Particles.Jazzp10'
     DrawScale=0.100000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     LightType=LT_Steady
     LightEffect=LE_WateryShimmer
     LightBrightness=255
     LightHue=170
     LightRadius=6
     LightPeriod=32
     LightCone=6
     VolumeBrightness=255
     RotationRate=(Pitch=4096)
     NormalTexture=Texture'JazzArt.Particles.Jazzp10'
     FearTexture=Texture'JazzArt.Jazzp13'
     FriendTexture=Texture'JazzArt.Jazzp1'
}
