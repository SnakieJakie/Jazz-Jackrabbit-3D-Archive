//=============================================================================
// CinFemaleOne.
//=============================================================================
class CinFemaleOne expands FemaleOne;

var bool bCamActive;

var vector FadeColor;
var float FadeDepth;
var float FadeRate;

var bool bLostControl; // Might not need this - its here so other actors can check if needed

var	actor	Target;
var actor	MoveTarget;
var actor	LastMoveTarget;

var bool    ForceTurning;

var bool 	bForceDoing;
var	name	ThingToDo;

///////////////////////////////////////////////////////////////////////////////////////////

function PreBeginPlay()
{	
	Super.PreBeginPlay();
	
	FadeRate = 100; // Set the basic fade rate
}

// This console function lets you choose which camera to
// view from. If you don't specify a camera name, the last
// camera in the list will be used. I should add error checking
// for no cameras found, but Nawwwwwww... its a cheat, not
// a feature. :o)
exec function vc(optional Name CamName)
{
	local CinCamera AC;

	if(CamName=='')
		bCamActive = !bCamActive;
	else 
		bCamActive = true;
	
	if(!bCamActive)
		ViewTarget = none;	
	else if(bCamActive)
		foreach AllActors(class 'CinCamera', AC)
			if ((AC.Name==CamName)||(CamName==''))
				ViewTarget = AC;
}

// Overridden so I could keep track of fading as well
// as normal ViewFlashes
function ViewFlash(float DeltaTime)
{
	local vector goalFog;
	local float goalscale, delta;
	
	
	//log("---------------------------> Called ViewFlash");
	delta = FMin(0.1, DeltaTime); //<--- the most amount of delta per tick is 0.1
	goalScale = 1 
				+ DesiredFlashScale 
				+ ConstantGlowScale 
				+ HeadRegion.Zone.ViewFlash.X
				+ FadeDepth; 
	goalFog = DesiredFlashFog 
				+ ConstantGlowFog 
				+ HeadRegion.Zone.ViewFog
				+ FadeColor;
	DesiredFlashScale -= DesiredFlashScale * 2 * delta;  
	DesiredFlashFog -= DesiredFlashFog * 2 * delta;
	FlashScale.X += (goalScale - FlashScale.X) * 0.1 * delta * FadeRate;
	FlashFog += (goalFog - FlashFog) * 0.1 * delta * FadeRate;

	if ( FlashScale.X > 0.981 )
		FlashScale.X = 1; // AHA! This is why > 1 didn't do anything
	FlashScale = FlashScale.X * vect(1,1,1);

	if ( FlashFog.X < 0.019 )
		FlashFog.X = 0;
	if ( FlashFog.Y < 0.019 )
		FlashFog.Y = 0;
	if ( FlashFog.Z < 0.019 )
		FlashFog.Z = 0;


}



// This is kinda lame programming.
// For some reason ViewFlash and ViewShake are called
// from here instead of in the Players state code.
// Hmmm...
// I need this for Updating the camera rotaion anyway.
function UpdateRotation(float DeltaTime, float maxPitch)
{
	local rotator newRotation;
	
	DesiredRotation = ViewRotation; //save old rotation
	ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
	ViewRotation.Pitch = ViewRotation.Pitch & 65535;
	If ((ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152))
	{
		If (aLookUp > 0) 
			ViewRotation.Pitch = 18000;
		else
			ViewRotation.Pitch = 49152;
	}
	ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
	ViewShake(deltaTime);
	ViewFlash(deltaTime);
		
	newRotation = Rotation;
	newRotation.Yaw = ViewRotation.Yaw;
	newRotation.Pitch = ViewRotation.Pitch;
	
	
	If ( (newRotation.Pitch > maxPitch * RotationRate.Pitch) && (newRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
	{
		If (ViewRotation.Pitch < 32768) 
			newRotation.Pitch = maxPitch * RotationRate.Pitch;
		else
			newRotation.Pitch = 65536 - maxPitch * RotationRate.Pitch;
	}
	
	setRotation(newRotation);
	
}


////////////////////////////////////////////////////////////////////////////
// Camera stuff
//
// View settings I wanted access to
function SetCameraView(CinCamera NewCam)
{
	
	bCamActive = true;
	ViewTarget = NewCam;
	MyHUD.Crosshair = 6; // remove crosshair for all "other" cam views
}

// POVFirstPerson - This function also was a part of the original Omni-Cam.  

function SetPlayerView()
{

	log("-------------------> CinFemaleOne: SetPlayerView()");
	bBehindView = false;
	bCamActive = false;
	//ActiveCamera = none; // Unnecessary reseting of pointer
	ViewTarget = none;
	
	// if not letter boxed
	if(MyHUD.HUDMode!= 6)
		MyHUD.Crosshair = MyHUD.Default.Crosshair;
	

}

////////////////////////////////////////////////////////////////////////////
// Movement Stuff
//

// Source: ScriptedPawn
function bool NeedToTurn(vector targ)
{
	local int YawErr;

	DesiredRotation = Rotator(targ - location);
	DesiredRotation.Yaw = DesiredRotation.Yaw & 65535;
	YawErr = (DesiredRotation.Yaw - (Rotation.Yaw & 65535)) & 65535;
	if ( (YawErr < 4000) || (YawErr > 61535) )
		return false;

	return true;
}

// RotateTowards updates the actor rotation to try to face the target rotation
//
// Returns 'true' if done.
//
function bool RotateTowards (rotator TargetRot)
{
	local int A,B;
	local rotator NewRotation;
	
	// Compare Respective Rotations
	A = Rotation.Yaw & 65535;
	B = TargetRot.Yaw & 65535; 
	if (B<A) B += 65535;
	
	NewRotation = Rotation;
	
	// Check if rotations are close enough to match
	if (abs(B-A)<2000)
	{
	Log("PlayerForce) Rotate Done");
	
	NewRotation = TargetRot;
	SetRotation(NewRotation);
	return true;
	}
	
	// If desired rotation is more than half-circle, go the other way
	if ((B-A)>(65535/2))
	{
	Log("PlayerForce) Rotate R");
	
	NewRotation.Yaw -= 2000;
	}
	else
	{
	Log("PlayerForce) Rotate L");
	
	NewRotation.Yaw += 2000;
	}
	SetRotation(NewRotation);
	return false;
}


//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
// My Special States
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

state LostControl
{
ignores PlayerInput
		, Fire, AltFire
		//,SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling
		;

	event PlayerTick( float DeltaTime )
	{
		DoNothing(DeltaTime);
	}
	function AnimEnd()
	{	//log("================================> Got to AnimEnd");
		PlayWaiting();
	}
	function DoNothing(Float DeltaTime)
	{
		// Player does nothing except 
		// - updates the view rotation (for the camera) 
		// - Updates the ViewFlash (and Fade)
		// - updates the simulated breathing bob
		UpdateRotation(DeltaTime, 1);
		
		// Keep Bobbing while waiting - simulates breathing
		BobTime += 0.2 * DeltaTime;
		WalkBob.Z = Bob * 30 * sin(12 * BobTime);
	}

	function BeginState()
	{
		bLostControl = true;
	}
	
	function EndState()
	{
		bLostControl= false;
	}
begin:
	// Here, I really want the player to go into a default stance
	// and continue breathing, etc.
	// Need to:
	// - Stop Player from moving (probably zero all accelerations?)
	// - Finish the current animation
	// - Move the player to default stance
	// - Continue updating the view (needed for cameras) while
	//   not in the player view.
	// - Do random "waiting" activities (breathing, cock weapon, etc.)
	
	Acceleration = vect(0,0,0);
	FinishAnim();
	TweentoWaiting(0.01); // fixme - to fast?
	
	//PlayWaiting(); // anim continues, but not cool for multiple state movement like waiting
	BeginState();

}

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
// My CinAction States
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// Auto-Animation
//
state LostControlAnimate
{
ignores PlayerInput
		, Fire, AltFire
		//,SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling
		;

begin:
	Acceleration = vect(0,0,0);
	bForceDoing=true;
	FinishAnim();

	PlayAnim(ThingToDo);
	
	FinishAnim();
	TweentoWaiting(0.01); // fixme - to fast?
	
	bForceDoing=false;
	GotoState('LostControl');
}

// Auto-Duck / Crouch
//
state LostControlDuck
{
ignores PlayerInput
		, Fire, AltFire
		//,SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling
		;

begin:
	Acceleration = vect(0,0,0);
	bForceDoing=true;
	FinishAnim();

	PlayDuck();
	
	FinishAnim();
	
	Sleep(1);
	
	PlayRising();
	FinishAnim();
	TweentoWaiting(0.01); // fixme - to fast?
	
	bForceDoing=false;
	GotoState('LostControl');
}

// Auto-FeignDeath
//
state LostControlFeignDeath
{
ignores PlayerInput
		, Fire, AltFire
		//,SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling
		;

begin:
	Acceleration = vect(0,0,0);
	bForceDoing=true;
	FinishAnim();

	PlayFeignDeath();
	
	FinishAnim();
	
	Sleep(1);
	
	PlayRising();
	FinishAnim();
	TweentoWaiting(0.01); // fixme - to fast?
	
	bForceDoing=false;
	GotoState('LostControl');
}

// Auto-Fire Current Weapon
//
state LostControlFiring
{
ignores PlayerInput
		, Fire, AltFire
		//,SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling
		;

begin:
	Acceleration = vect(0,0,0);
	bForceDoing=true;
	FinishAnim();

	Super.Fire();
	
	FinishAnim();
	
	TweentoWaiting(0.01); // fixme - too fast?
	
	bForceDoing=false;
	GotoState('LostControl');
}

// Auto-Fire Current Weapon
//
state LostControlSpawn
{
ignores PlayerInput
		, Fire, AltFire
		//,SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling
		;

begin:
	Acceleration = vect(0,0,0);
	bForceDoing=true;
	FinishAnim();

	Summon(string(ThingToDo));

	TweentoWaiting(0.01); // fixme - too fast?
	
	bForceDoing=false;
	GotoState('LostControl');
}


// Auto-Walking
//
state LostControlWalkToward
{
ignores PlayerInput
		, Fire, AltFire
		//,SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling
		;

	event PlayerTick( float DeltaTime )
	{
		DoNothing(DeltaTime);
		
		if (ForceTurning)
			if (RotateTowards(DesiredRotation))
				ForceTurning = false;		
	}
	function AnimEnd()
	{	//log("================================> Got to AnimEnd");
	}
	function DoNothing(Float DeltaTime)
	{
		// Player does nothing except 
		// - updates the view rotation (for the camera) 
		// - Updates the ViewFlash (and Fade)
		// - updates the simulated breathing bob
		//UpdateRotation(DeltaTime, 1);
		
		// Keep Bobbing while waiting - simulates breathing
		//BobTime += 0.2 * DeltaTime;
		//WalkBob.Z = Bob * 30 * sin(12 * BobTime);
		ViewRotation = Rotation;

	}

	function BeginState()
	{
		bLostControl = true;
	}
	
	function EndState()
	{
	}
	
// Source:  ScriptedPawn
function bool PickDestination()
{
	local Actor path;
	local vector destpoint;
	
	destpoint = Target.Location;
	destpoint.Z += CollisionHeight - Target.CollisionHeight;
	if (pointReachable(destpoint))
	{
		MoveTarget = Target;
		Destination = destpoint;
	}
	else
	{
		if (SpecialGoal != None)
			path = FindPathToward(SpecialGoal);
		else
			path = FindPathToward(Target);
		if (path != None)
		{
			MoveTarget = path;
			Destination = path.Location;
		}
		else
		return (false);
	}
	return (true);
}

begin:
	bForceDoing = true;
	ForceTurning = false;
	BeginState();
	
	Acceleration = vect(0,0,0);
	FinishAnim();
	TweentoWalking(0.01); // fixme - to fast?
	FinishAnim();
	PlayWalking();
	
	
	Log("PlayerForce) FindPath To "$Target.Tag);
	
	LastMoveTarget = None;
	
	while (PickDestination() && (MoveTarget != LastMoveTarget))
	{
	
	if (NeedToTurn(MoveTarget.Location))
	{	
		ForceTurning = true;
		Log("PlayerForce) Turn To "$MoveTarget.Tag);
		
		while (ForceTurning == true)
		{
		Sleep(0.1);
		}
	}
	
	LastMoveTarget = MoveTarget;
	MoveToward(MoveTarget,GroundSpeed);
	Log("PlayerForce) Move To "$MoveTarget.Tag);
	}
	
	Acceleration = vect(0,0,0);
	TweenToPatrolStop(0.3);
	FinishAnim();

	bForceDoing = false;
	GotoState('LostControl');
	//PlayWaiting(); // anim continues, but not cool for multiple state movement like waiting
}

defaultproperties
{
}
