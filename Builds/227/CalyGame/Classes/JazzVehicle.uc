//=============================================================================
// JazzVehicle.
//=============================================================================
class JazzVehicle expands JazzItem;

var(VehicleMotion)	bool	ForwardAllow;
var(VehicleMotion)	float	ForwardAccelPct;
var(VehicleMotion)	float	GroundSpeed;

var(VehicleMotion)	bool	TurnAllow;
var(VehicleMotion)	int		TurnRate;

var(VehicleMotion)	bool	JumpLeaveVehicle;
var(VehicleMotion)	bool	JumpWithVehicle;
var(VehicleMotion)  float	JumpZ;

var(VehicleMotion)  bool	BounceAllow;
var(VehicleMotion)  float	BounceZPct;

var(VehicleGravity) bool	ApplyZoneGravity;	// Reapply zone gravity manually if physics is wrong
var(VehicleGravity) vector  ArtificialGravity;	// Apply our own artificial gravity	
var(VehicleGravity) float	GravityPct;
var(VehicleMotion)  bool	Rotate360;		// Vehicle goes in any direction
var(VehicleMotion)	bool	FlyingVehicle;	// Switch to flying instead of falling physics
											// Should be phased out

var(VehicleDisplay) bool	HidePlayer;

var(VehicleMotion)	bool	SpecialMotionLeave;	// Special motion button leaves vehicle?

var(VehicleDisplay) bool	bAllowPlayerWalkAnimation;
// Note: There is no check to see if the player is touching the ground currently.
// It is assumed that if the player is walking he will be touching the ground.
// (PHYS_Walking is set)

var(VehicleDisplay) bool	bRollStaysFlat;
var(VehicleDisplay) bool	bRollWithPlayer;

var 				Pawn	Rider;

var					Pawn	OldRider;
var 				float	OldRiderNoPickupWait;

var(VehicleMotion)	bool	BumpForwardCheck;	// Disable this if you don't need it

var(VehicleMotion)	EPhysics NormalPhysics;		// Normal physics to set Rider to
												// Default should be PHYS_Walking
												
var(VehicleMotion)	EPhysics FallingPhysics;	// Physics to use when falling
												// Default should be PHYS_Falling
												
var(VehicleDisplay) bool	HideRider;



auto state Waiting
{
	function Tick ( float DeltaTime )
	{
		if (OldRiderNoPickupWait>0)
			OldRiderNoPickupWait-=DeltaTime;
	}

	function PickupFunction(Pawn Other)
	{
		Touch(Other);
	}

	function Touch( actor Other )
	{
		if (JazzPlayer(Other) != NONE)
		{
			if (!((OldRider == Other) && (OldRiderNoPickupWait>0)))	// Wait time for old rider leaving
			{
				PlaySound (PickupSound,,2.5);
				//Log("JazzVehicle) Ride On");
				JazzPlayer(Other).Vehicle = Self;
				JazzPlayer(Other).GotoState('RideVehicle');
				Rider = Pawn(Other);
				
				GotoState('RideVehicle');
			}
		}
	}
}

//
// Initialize Ride state when rideable object first in possession of player.
//
function RideInitialize(actor Other);

////
// Motion Filtering Functions
//
// Redefine these to alter motion system.
//
function float 	FilterTurn( float aTurn, float DeltaTime );
function float	FilterForwardBack( float aForward, float DeltaTime );
function 		AcceptPlayerRotation( rotator NewRotation );	// Called at PreRender
function vector	FilterVelocityHistory( vector VelocityHistory, float DeltaTime );
function float	FilterBounce( float VelocityZ );
function		PlayerPressedJump( );
function		AcceptVehicleLocation( vector Location, rotator NewRotation );
function		PlayerPressedSpecialMotion( float SpecialMotionHeldTime );
function		HandleBumpForward();
function 		FilterSpeed( out vector Acceleration, out vector Velocity, float DeltaTime );
//
//
	
state RideVehicle
{
	ignores Touch,PickupFunction;
	
	// Default Filtering
	
	// This is where artificial gravity, forced zone gravity, and other variables
	// are applied to the acceleration and velocity of a vehicle manually to
	// override the physics model in use.
	//
	function 	FilterSpeed( out vector Acceleration, out vector Velocity, float DeltaTime )
	{
		Acceleration += ArtificialGravity;
	
		// Apply the current zone's gravity settings manually.
		if (ApplyZoneGravity)
		{
			Acceleration += Rider.Region.Zone.ZoneGravity;
		}
	}
	
	// Change the turning input from a player.  (aTurn)
	//
	// Here you can alter the speed of rotating a vehicle generally along the Yaw
	// from the player's input.
	//
	function float FilterTurn ( float aTurn, float DeltaTime )
	{
		return (aTurn);
	}
	
	// Change the forward/backward input from a player.  (aForward)
	// 
	// Here you can alter the speed applied by the player pushing in a certain
	// direction.
	//
	function float FilterForwardBack( float aForward, float DeltaTime )
	{
		return (aForward);
	}
	
	// Set the angle (rotation) of the player displayed on top of the board.
	//
	// Also angle the board's rotation as well.
	// Called right before rendering an image, so it's always accurate for that moment.
	//
	function 		AcceptPlayerRotation( rotator NewRotation )
	{
		if (bRollStaysFlat)
			NewRotation.Roll = 0;

		if (bRollWithPlayer)
			NewRotation.Roll = Rider.Rotation.Roll*2;

		SetRotation(NewRotation);
	}

	// Affect gravity of vehicle in various directions.
	//
	// I don't entirely remember how this works...
	//
	function vector	FilterVelocityHistory( vector VelocityHistory, float DeltaTime )
	{
		local float OldVelocityKeep;
		local vector NewVelocity;
		
		//return(VelocityHistory);
		
		OldVelocityKeep = 1 - (DeltaTime);
		
		if (GravityPct == 1.0)
		{
			return( VelocityHistory * OldVelocityKeep );
		}
		else
		{
			NewVelocity.x = VelocityHistory.x * OldVelocityKeep;
			NewVelocity.y = VelocityHistory.y * OldVelocityKeep;
			if (VelocityHistory.Z<0)
			NewVelocity.z = VelocityHistory.z * OldVelocityKeep * GravityPct;
			else
			NewVelocity.z = VelocityHistory.z * OldVelocityKeep;
			return( NewVelocity );
		}
	}

	// Amount of bounce velocity applied.
	//
	// When going downhill, this will continuously bounce the player, so set it low.
	//
	function float	FilterBounce( float VelocityZ )
	{
		if (BounceAllow)
		return( abs(VelocityZ)*BounceZPct );		
		else
		return(0);
	}

	// Just handle a request to leave the vehicle or whatnot by a button press.
	//
	function		PlayerPressedSpecialMotion( float SpecialMotionHeldTime )
	{
		if (SpecialMotionLeave)
		{
			// EndVehicle
			JazzPlayer(Rider).Velocity.Z += 50;

			EndRideVehicle();	// End VehicleRide state and return to normal status
		}
	}

	// Player pressed jump.  What do we do?
	//
	function		PlayerPressedJump( )
	{
		if (JumpWithVehicle)
		{
			Rider.Velocity.Z = JumpZ;
			JazzPlayer(Rider).VelocityHistory.Z = JumpZ;
			//PlaySound(JumpSound, SLOT_Talk, 1.5, true, 1200, 1.0 );
		}
		if (JumpLeaveVehicle)
		{
			// EndVehicle
			JazzPlayer(Rider).DoJump();

			if (Velocity.Z < -500) Velocity.Z = -500;
			if (Velocity.Z > 500) Velocity.Z = 500;

			EndRideVehicle();	// End VehicleRide state and return to normal status
		}
	}
	
	// Player has requested to jump off the vehicle.
	//
	function		EndRideVehicle()
	{
			// Retain Ride Velocity and Physics
			Velocity = Rider.Velocity;
			SetPhysics(Rider.Physics);
			bCollideWorld = true;
			//bCollideActors = true;
			
			// Return Rider to Normal
			JazzPlayer(Rider).LeaveVehicle();
			//Rider.GotoState('PlayerWalking');
			//JazzPlayer(Rider).Vehicle = NONE;
			
			// Remove Rider
			OldRider = Rider;	OldRiderNoPickupWait = 3;
			Rider.bHidden = false;
			Rider = None;
			GotoState('Waiting');
	}
	
	// Default vehicle location beneath player's feet.
	//
	// This alters the vehicle location under the player (or over).  It's usually
	// based on the rotation the player is at so the board will display at an angle
	// downward from his torso.
	//
	function		AcceptVehicleLocation( vector Location, rotator NewRotation )
	{
		//NewRotation.Roll *= 2;
	
		if (bRollWithPlayer)
		{
		SetLocation(Location - (vect(0,0,40) >> NewRotation) );
		}
		else
		SetLocation(Location - (vect(0,0,40) ) );
		
	}

	// Animation
	function PlayFallingDown()
	{
	}
	
	// Animation
	function PlayInAir()
	{
	}

	// Animation
	function Falling()
	{
		// Change 'falling' animation
		//PlayInAir();
	}
	
	function RideInitialize( actor Rider )
	{
		if (HideRider)
		{
			Rider.bHidden = true;
		}
	}
	
	// Initialize the vehicle.
	//
	function BeginState()
	{
		RideInitialize(Rider);
	}
	
Begin:
	bCollideWorld = false;
	//bCollideActors = false;
	Velocity = vect(0,0,0);
}

defaultproperties
{
     NormalPhysics=PHYS_Walking
     FallingPhysics=PHYS_Falling
}
