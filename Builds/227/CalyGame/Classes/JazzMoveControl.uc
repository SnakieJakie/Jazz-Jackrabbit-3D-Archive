//=============================================================================
// JazzMoveControl.
//=============================================================================
class JazzMoveControl expands JazzEffects;

//
// Intended as a controller to move special effects from one location to another in interesting motion patterns.
//
// Example:
//	Player picks up an item, which adds experience to his weapon.  Experience increase is displayed as sparkles
//  which fly into the HUD and into his weapon display.
//
//

var bool	LocationStartHUD,LocationEndHUD;	// If hud, choose location start / end as relative to the HUD as per the weapon orb
var vector	LocationStartOrigin,LocationEndOrigin;
var vector	LocationStart,LocationEnd;
var actor	ActorToMove;

var enum	MotionModelType
{
	motionNormal
} MotionModel;

var enum	MotionEndType
{
	endDestroy
} MotionEnd;


function Start ( actor Other, vector VEnd, optional vector VStart, optional bool VEndHud, optional bool VStartHud )
{
	Log("ReadyActorControl) "$VStart$" "$VEnd);
	
	// Location Start in HUD?
	if (VStartHud)
	{
		LocationStartOrigin = VStart;
		LocationStart = VStart;
		LocationStartHud = true;
	}
	else
	// If LocationStart not specified, use Other.Location as starting location
	if (LocationStart != vect(0,0,0))
	LocationStart = VStart;
	else
	LocationStart = Other.Location;
	
	// Set location end
	LocationEnd = VEnd;

		
	// Location End in HUD?
	if (VEndHud)
	{
		LocationEndOrigin = LocationEnd;
		LocationEndHUD = true;
	}

	// Set actor to control
	ActorToMove = Other;

	Log("ReadyActorControl) "$LocationStart$" "$LocationEnd);

	GotoState('RemoteControl');
}

//
//
state RemoteControl
{
	function Tick( float DeltaTime )
	{
		local vector	Vec;
		local float		VS;
		
		// Location End in HUD?	
		if (LocationEndHUD)
		{
		//NewRotation = JazzPlayer(Owner).MyCameraRotation;
		//NewRotation.Yaw += 16384;
		//NewRotation.Pitch = 0;
		LocationEnd = JazzPlayer(Owner).MyCameraLocation;
//				100 * vector(JazzPlayer(Owner).MyCameraRotation) +
//				70 * vector(NewRotation);
		Log("ActorControl) "$Owner);
		}

		Vec = LocationEnd - ActorToMove.Location;

		VS = VSize(Vec);
		
		Log("ActorControl) "$VS$" "$LocationStart$" "$LocationEnd$" "$LocationEndHUD);
		
		if (VS<20)
		{
			//EndMotion();
		}
		else
		{
		Vec	= Vec / VS;
		
		ActorToMove.SetLocation(ActorToMove.Location + Vec*DeltaTime*300);
		}
	}

	function EndMotion ()
	{
		switch (MotionEnd)
		{
		case endDestroy :
			ActorToMove.Destroy();
			Destroy();
			return;
		}

		// Default : Just destroy it
		ActorToMove.Destroy();
		Destroy();
	}

Begin:
	ActorToMove.SetLocation(LocationStart);

}

defaultproperties
{
     bHidden=True
     DrawType=DT_None
}
