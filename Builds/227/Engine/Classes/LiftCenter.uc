//=============================================================================
// LiftCenter.
//=============================================================================
class LiftCenter expands NavigationPoint
	intrinsic;

var() name LiftTag;
var	 mover MyLift;
var() name LiftTrigger;
var trigger RecommendedTrigger;
var float LastTriggerTime;

function PostBeginPlay()
{
	if ( LiftTag != '' )
		ForEach AllActors(class'Mover', MyLift, LiftTag )
		{
			MyLift.myMarker = self;
			SetBase(MyLift);
			break;
		}
	if ( LiftTrigger != '' )
		ForEach AllActors(class'Trigger', RecommendedTrigger, LiftTrigger )
			break;
	Super.PostBeginPlay();
}

/* SpecialHandling is called by the navigation code when the next path has been found.  
It gives that path an opportunity to modify the result based on any special considerations
*/

function Actor SpecialHandling(Pawn Other)
{
	local float dist2d;

	if ( Other.base == MyLift )
	{
		if ( (RecommendedTrigger != None) 
		&& (myLift.SavedTrigger == None)
		&& (Level.TimeSeconds - LastTriggerTime > 5) )
		{
			Other.SpecialGoal = RecommendedTrigger;
			LastTriggerTime = Level.TimeSeconds;
			return RecommendedTrigger;
		}

		return self;
	}

	if ( (LiftExit(Other.MoveTarget) != None) 
		&& (LiftExit(Other.MoveTarget).RecommendedTrigger != None)
		&& (LiftExit(Other.MoveTarget).LiftTag == LiftTag)
		&& (Level.TimeSeconds - LiftExit(Other.MoveTarget).LastTriggerTime > 5)
		&& (MyLift.SavedTrigger == None)
		&& (Abs(Other.Location.X - Other.MoveTarget.Location.X) < Other.CollisionRadius)
		&& (Abs(Other.Location.Y - Other.MoveTarget.Location.Y) < Other.CollisionRadius)
		&& (Abs(Other.Location.Z - Other.MoveTarget.Location.Z) < Other.CollisionHeight) )
	{
		LiftExit(Other.MoveTarget).LastTriggerTime = Level.TimeSeconds;
		Other.SpecialGoal = LiftExit(Other.MoveTarget).RecommendedTrigger;
		return LiftExit(Other.MoveTarget).RecommendedTrigger;
	}

	dist2d = square(Location.X - Other.Location.X) + square(Location.Y - Other.Location.Y);
	if ( (Location.Z - CollisionHeight < Other.Location.Z - Other.CollisionHeight + Other.MaxStepHeight)
		&& (Location.Z - CollisionHeight > Other.Location.Z - Other.CollisionHeight - 1200)
		&& ( dist2D < 90000) )
		return self;

	if ( MyLift.BumpType == BT_PlayerBump && !Other.bIsPlayer )
		return None;
	Other.SpecialGoal = None;
		
	MyLift.HandleDoor(Other);
	MyLift.RecommendedTrigger = None;

	if ( (Other.SpecialGoal == MyLift) || (Other.SpecialGoal == None) )
		Other.SpecialGoal = self;
	return Other.SpecialGoal;
}

defaultproperties
{
     ExtraCost=400
     bStatic=False
}
