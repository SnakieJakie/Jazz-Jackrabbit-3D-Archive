//=============================================================================
// CTFFlag.
//=============================================================================
class CTFFlag expands JazzGameObjects;

// The base of where the flag goes and is held
var CTFBase FlagBase;

// Who has the flag
var actor Carry;

// The team that owns this flag
var () const int TeamNumber;

var() mesh TeamMesh[2];

replication
{
	// Things the client should send to the server
	reliable if ( Role<ROLE_Authority )
		TeamNumber;

	// Functions client can call.
	reliable if( Role<ROLE_Authority )
		FlagTouch, GoHome;
}

function PostBeginPlay()
{
	if(CaptureTheFlag(Level.Game) == None)
	{
		Self.Destroy();
		return;
	}

	if(TeamNumber == 0)
	{
		Self.Mesh = TeamMesh[0];
		LoopAnim('CarrotFlag');
	}
	else if(TeamNumber == 1)
	{
		self.Mesh = TeamMesh[1];
		LoopAnim('DiamondFlag');
	}
	else
	{
		log("Unsuppored team number in flag: " $ self);
		// self.mesh = mesh'jazz';
	}

	if(FlagBase == None)
	{
		FlagBase = spawn(class'CTFBase',self,,self.location);
		SetBase(FlagBase);
	}
	
	Carry = None;
}


event Bump(actor Other)
{
	if(pawn(Other).Health > 0)
	{
		FlagTouch(Other);
	}
}

event Touch(actor Other)
{
	if(pawn(Other).Health > 0)
	{
		FlagTouch(Other);
	}
}


state Carried
{
	event Touch(actor Other);
	event Bump(actor other);
	event Tick(float DetlaTime)
	{
		if(Base != Carry)
		{
			SetLocation(Carry.Location);
			SetBase(Carry);
		}
	}
	
	function BeginState()
	{
		Disable('touch');
		Disable('bump');	
	}
}

state OnGround
{
	function FlagTouch(actor Other)
	{
	
		// Make sure it is a player that touched us
		if(JazzPlayer(other) != None)
		{
			// Make sure the player is on a different team
			if(JazzPlayer(Other).PlayerReplicationInfo.Team != TeamNumber)
			{
				JazzPlayer(Other).PickUpFlag(self);
				Disable('Touch');
				Disable('Bump');
				SetLocation(Other.Location);
				SetRotation(Other.Rotation);
				GotoState('Carried');
				CaptureTheFlag(Level.Game).FlagStolen(JazzPlayer(Other).PlayerReplicationInfo, TeamNumber);
				SetBase(Other);
				Carry = Other;
			}
			else
			{
				// This is our flag and we just recovered it
				CaptureTheFlag(Level.Game).FlagReturned(JazzPlayer(Other).PlayerReplicationInfo);
				Disable('Touch');
				Disable('Bump');
				GoHome();
			}
		}
		// See if it's a bot that's touched the flag
		else if(JazzThinker(Other) != None)
		{
			if(JazzThinker(Other).PlayerReplicationInfo.Team != TeamNumber)
			{
				JazzThinker(Other).PickUpFlag(self);
				Disable('Touch');
				Disable('Bump');
				SetLocation(Other.Location);
				SetRotation(Other.Rotation);
				GotoState('Carried');
				CaptureTheFlag(Level.Game).FlagStolen(JazzThinker(Other).PlayerReplicationInfo, TeamNumber);
				SetBase(Other);
				Carry = Other;
			}
			else
			{
				// Recover the flag
				CaptureTheFlag(Level.Game).FlagReturned(JazzThinker(Other).PlayerReplicationInfo);
				Disable('Touch');
				Disable('Bump');				
				GoHome();
			}
		}
	}
	
	function BeginState()
	{
		SetTimer(10,false);
		Carry = None;
		SetBase(None);
		Enable('Touch');
		Enable('Bump');
	}
	
	event Tick(float DeltaTime)
	{
	}
	
	event Timer()
	{
		Disable('touch');
		Disable('bump');	
		GoHome();
	}
	
	function EndState()
	{
		Disable('Timer');
	}
}

function FlagTouch(actor Other)
{

	// Make sure it is a player that touched us
	if(JazzPlayer(other) != None)
	{
		// Make sure the player is on a different team
		if(JazzPlayer(Other).PlayerReplicationInfo.Team != TeamNumber)
		{
			JazzPlayer(Other).PickUpFlag(self);
			Disable('touch');
			Disable('bump');
			SetLocation(Other.Location);
			SetRotation(Other.Rotation);
			GotoState('Carried');
			CaptureTheFlag(Level.Game).FlagStolen(JazzPlayer(Other).PlayerReplicationInfo, TeamNumber);
			SetBase(Other);
			Carry = other;
		}
		else
		{
			// See if we are returning a team's flag
			if(JazzPlayer(Other).bHasFlag)
			{
				CaptureTheFlag(Level.Game).FlagCapture(JazzPlayer(Other).PlayerReplicationInfo, JazzPlayer(Other).TeamFlag.TeamNumber);
				JazzPlayer(Other).bHasFlag = false;
				JazzPlayer(Other).TeamFlag.GoHome();
				JazzPlayer(Other).TeamFlag = None;
			}
		}
	}
	else if(JazzThinker(Other) != None)
	{
		if(JazzThinker(other).PlayerReplicationInfo.Team != TeamNumber)
		{
			JazzThinker(other).PickUpFlag(self);
			Disable('touch');
			Disable('bump');
			SetLocation(Other.Location);
			SetRotation(Other.Rotation);
			GotoState('Carried');
			CaptureTheFlag(Level.Game).FlagStolen(JazzThinker(Other).PlayerReplicationInfo, TeamNumber);
			SetBase(Other);
			Carry = Other;
		}
		else
		{
			if(JazzThinker(Other).bHasFlag)
			{
				CaptureTheFlag(Level.Game).FlagCapture(JazzThinker(Other).PlayerReplicationInfo, JazzThinker(Other).TeamFlag.TeamNumber);
				JazzThinker(Other).bHasFlag = false;
				JazzThinker(Other).TeamFlag.GoHome();
				JazzThinker(Other).TeamFlag = None;
			}
		}
	}
}

event Tick(float DeltaTime)
{
	if(Location != FlagBase.Location)
	{
		Disable('Bump');
		Disable('Touch');
		GoHome();
	}
}

function GoHome()
{
	SetLocation(FlagBase.Location);
	GotoState('');
	Carry = None;
	SetBase(FlagBase);
	Enable('Touch');
	Enable('Bump');
}

defaultproperties
{
     bCanTeleport=True
     bCollideWhenPlacing=True
     Physics=PHYS_Trailer
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.CarrotFlag'
     bAlwaysRelevant=True
     bGameRelevant=True
     bCollideActors=True
     bCollideWorld=True
     TeamMesh[0]=mesh'jazzobjectoids.carrotflag'
     TeamMesh[1]=mesh'jazzobjectoids.diamondflag'
}
