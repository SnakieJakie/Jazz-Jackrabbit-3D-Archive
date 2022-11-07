//=============================================================================
// JazzBridgeHandler.
//=============================================================================
class JazzBridgeHandler expands JazzMotionObjects;

// The JazzBridge is placed down so that pieces are facing forward towards the next piece.
// Each piece is, of course, directional, and *must* face in the direction of the next one.
// No exceptions, otherwise it won't work.
//
// Important:
// In addition, the first bridge section must have the 'ThisIsFirstSection' set to true.  This
// is the piece that will initialize all the rest for play.
//

// Tag of each bridge piece in order of travel
//

var()	float	BridgeBendFactor;

var()	int		BridgePieceNum;
var()	name	BridgePieceTags[30];
var		actor	BridgePieces[30];
var		float	BridgeOptimalZ[30];
var		float	BridgeMassApplied[30];

var		int		ActorsTouchingNum;
var 	actor	ActorsTouching[10];
var		int		ActorTouchingPiece[10];
var		byte	ActorJustTouched[10];

function PreBeginPlay()
{
	ActorsTouchingNum = -1;

	SetupAllBridge();
}

function SetupAllBridge()
{
	local actor	P;
	local int	I;
	
	for (i=0; i<BridgePieceNum; i++)
	{
		ForEach AllActors(class'Actor',P)
		{
			if (P.Tag == BridgePieceTags[i])
			{
				BridgePieces[i] = P;
				BridgeOptimalZ[i] = P.Location.Z;
				P.Event = Tag;
			}
		}
	}
}

function bool TouchValid( actor B, actor P )
{
	if (P.Location.Z > B.Location.Z)
	return(true);
	
	return(false);
}

// Trigger - Actor has stepped on a bridge piece
//
function Trigger( actor Other, pawn EventInstigator )
{
	local 	int		A;

	if (TouchValid(Other,EventInstigator)==false)
	return;

	A = SearchForActor(EventInstigator);

	// Add Actor Touching Piece
	//
	if (A>=0)
	{
	//	Log("BridgeOldActor) "$ActorsTouchingNum);
		if (ActorJustTouched[A]==0)
		AssignActorPiece(A,Other);
	}
	else
	{
		//Log("BridgeNewActor) "$ActorsTouchingNum);
		if (ActorsTouchingNum<9)
		{
		ActorsTouchingNum++;
		ActorsTouching[ActorsTouchingNum]=EventInstigator;
		AssignActorPiece(ActorsTouchingNum,Other);
		}
	}

	//Log("BridgeSteppedOn) "$Other);
}

function AssignActorPiece ( int A, actor Other )
{
	local int P;
	
	P = SearchForPiece(Other);
	
	if (P>=0)
	{
		ActorTouchingPiece[A]=P;
		ActorJustTouched[A]=1;
		Other.Velocity.Z = 0;
	}
}

function int SearchForActor ( actor Other )
{
	local int	i;
	
	for (i=0; i<=ActorsTouchingNum; i++)
	{
		//Log("SearchForActor) "$ActorsTouching[i]$" "$Other);
		if (ActorsTouching[i]==Other)
		{
		//Log("SearchActor) "$i);
		return(i);
		}
	}
	return(-1);
}

function int SearchForPiece ( actor Other )
{
	local int	i;
	for (i=0; i<BridgePieceNum; i++)
	{
		if (BridgePieces[i]==Other)
		return(i);
	}
	return(-1);
}

function bool	ActorNotOnBridge ( int A )
{
	local vector	ActorLocation,PieceLocation;

	// Check if actor is on bridge
	
	// Get locations
	ActorLocation = ActorsTouching[A].Location;
	PieceLocation = BridgePieces[ActorTouchingPiece[A]].Location;
	
	// Actor Z greather than piece Z
	if (ActorLocation.Z < (PieceLocation.Z-10))
		return true;

	if (abs(ActorLocation.X - PieceLocation.X) + abs(ActorLocation.Y - PieceLocation.Y) > 
		BridgePieces[ActorTouchingPiece[A]].CollisionRadius*1.5)
		return true;

	if (ActorLocation.Z > PieceLocation.Z + 50)
		return true;

return false;
}

event Tick ( float DeltaTime )
{
	// Place all actors at correct location
	//
	local int i,P;
	local vector NewLocation;
	local rotator NewRotation;
	local float ShiftToZ;
	local float ZChange;

	if (BridgePieceNum==0)
	return;

	for (i=0; i<BridgePieceNum; i++)
	{
		BridgeMassApplied[i] = 0;
	}
	
	for (i=0; i<=ActorsTouchingNum; i++)
	{
		if ((ActorsTouching[i]==None) || (Pawn(ActorsTouching[i]).Health<0))
			RemoveActor(i);

		// Check if actor not on bridge.
		//			
		if (ActorJustTouched[i]!=1)
			RemoveActor(i);

		//if (ActorNotOnBridge(i)==true)
	//		RemoveActor(i);
			
		ActorJustTouched[i] = 0;
			
		// Check if not over bridge piece anymore
	
		P =	(ActorTouchingPiece[i]);
		
		if ((P>=0) && (P<30))
		{
			ApplyMass(P,ActorsTouching[i].Mass);
		}
	}

	// Apply Z positional change
	//
	for (i=0; i<BridgePieceNum; i++)
	{
		NewLocation = BridgePieces[i].Location;
		ShiftToZ = BridgeOptimalZ[i] - BridgeMassApplied[i]*BridgeBendFactor;
		NewLocation.Z += (ShiftToZ - NewLocation.Z)*0.5;
		BridgePieces[i].SetLocation(NewLocation);
		
		// Rotation from previous piece
		if (i==0)
		ZChange = (BridgePieces[i+1].Location.Z - BridgePieces[i].Location.Z)*2;
		else
		if (i==BridgePieceNum-1)
		ZChange = (BridgePieces[i].Location.Z - BridgePieces[i-1].Location.Z)*2;
		else
		ZChange = (BridgePieces[i+1].Location.Z - BridgePieces[i-1].Location.Z);
		
		NewRotation = BridgePieces[i].Rotation;
		NewRotation.Pitch = -ZChange*50;
		BridgePieces[i].SetRotation(NewRotation);
		//Log("BridgePieces) "$i$" - "$ZChange);
	}
	
	// Apply Pitch rotation based on Z change between pieces
	//
	for (i=0; i<BridgePieceNum; i++)
	{
	}
	
}

function RemoveActor ( int A )
{
	local int i;
	for (i=A+1; i<=ActorsTouchingNum; i++)
	{
	ActorsTouching[i-1] = ActorsTouching[i];
	ActorTouchingPiece[i-1] = ActorTouchingPiece[i];
	}
	
	ActorsTouchingNum--;
}

function ApplyMass(int S, int Mass)
{
	local float	LeftNode,RightNode,CenterDistance;
	local int	i;
	
	LeftNode = S-1+1;
	RightNode = BridgePieceNum-S+1;
	
	//Log("ApplyMass) "$LeftNode$" "$RightNode);
	
	// Center Mass
	if (LeftNode<RightNode)
	CenterDistance = LeftNode/BridgePieceNum;
	else
	CenterDistance = RightNode/BridgePieceNum;
	
	Mass = Mass*CenterDistance*2;
	
	BridgeMassApplied[S] += Mass;
	
	//Log("ApplyMass) "$S$" "$Mass$" "$CenterDistance);
	
	// Left Mass
	if (LeftNode>0)
	for (i=S-1; i>=0; i--)
		BridgeMassApplied[i]=Mass*(i/LeftNode);
	
	// Right Mass
	if (RightNode>0)
	for (i=S+1; i<BridgePieceNum; i++)
	{
		//Log("BridgeRight) "$(BridgePieceNum-i+1)$" "$RightNode$" "$i);
		BridgeMassApplied[i]=Mass*((BridgePieceNum-i+1)/RightNode);
	}
}

defaultproperties
{
     Texture=Texture'Engine.S_Interp'
}
