//=============================================================================
// AirShip.
//=============================================================================
class AirShip expands JazzVehicle;

// HangGlider must rotate forward & down when pressing forward - increase forward speed
// and downward speed.
//
// HangGlider must rotate back & up when pressing forward - decrease forward speed and
// apply speed change to upward speed.
//

//var float NoseLevel;	// Up/down rotation of hangglider.
//var	float RollLevel;	// Left/right rotation of hangglider.

var float RollSpeed;
var float TurnSpeed;

var float CurrentVelocity;	// Velocity of vehicle
var rotator RiderRotation;		

function RideInitialize(actor Other)
{
	//JazzPlayer(Other).TutorialCheck(TutorialRocketBoard);
}

event PostBeginPlay ()
{
}

state RideVehicle
{
	function float FilterForwardBack( float aForward, float DeltaTime )
	{
		local rotator NewRotation;
	
		// Nose change 
		if (aForward<0)
		{
			RollSpeed += 1000 * DeltaTime;
		}
		else
		if (aForward>0)
		{
			RollSpeed -= 1000 * DeltaTime;
		}
		else
		{
			if (RollSpeed>0)
			{
			RollSpeed -= 500 * DeltaTime;
			if (RollSpeed<0) RollSpeed=0;
			}
			
			if (RollSpeed<0)
			{
			RollSpeed += 500 * DeltaTime;
			if (RollSpeed>0) RollSpeed=0;
			}
		}
		
		if (RollSpeed>500)
		RollSpeed=500;
		if (RollSpeed<-500)
		RollSpeed=-500;

		
		//RiderRotation.Pitch += cos(float(RiderRotation.Roll)/65536*2*Pi)*RollSpeed;
		//RiderRotation.Yaw += sin(float(RiderRotation.Roll)/65536*2*Pi)*RollSpeed;
		
		//RiderRotation.Pitch += RollSpeed;
		//Rider.ViewRotation.Pitch += RollSpeed;
		
		//Log("RollSpeed) "$RollSpeed$" "$Rider.Rotation.Pitch);

		CurrentVelocity -= RollSpeed*DeltaTime*8;
		if (CurrentVelocity>2000) CurrentVelocity=2000;
		if (CurrentVelocity<-1000) CurrentVelocity=-1000;
		Rider.AccelRate = CurrentVelocity;
		Rider.AirSpeed = CurrentVelocity;
		Rider.GroundSpeed = CurrentVelocity;
		
		//Log("CurrentVelocity) "$CurrentVelocity$" "$Rider.GroundSpeed$" "$Rider.AirSpeed$" "$VSize(Rider.Acceleration));
		
		return(CurrentVelocity);
		//return (aForward*ForwardAccelPct);
	}
	
	function		PlayerPressedJump( )
	{
		/*if (Rider.Physics != PHYS_Falling)
		if (JumpWithVehicle)
		{
			Rider.Velocity.Z = JumpZ;
			JazzPlayer(Rider).VelocityHistory.Z = JumpZ;
			//Log("RocketBoard) Jump "$VSize(Rider.Velocity)$" "$GroundSpeed);
			Rider.SetPhysics(PHYS_Falling);
				// Override - Decrease Jump velocity as speed decreases
			//PlaySound(JumpSound, SLOT_Talk, 1.5, true, 1200, 1.0 );
		}
		if (JumpLeaveVehicle)
		{
			// EndVehicle
			JazzPlayer(Rider).DoJump();

			EndRideVehicle();	// End VehicleRide state and return to normal status
		}*/
	}
	
	// Turn hangglider left or right
	//
	function float 	FilterTurn( float aTurn, float DeltaTime )
	{
		local rotator NewRotation;
	
		// Nose change 
		if (aTurn<0)
		{
			TurnSpeed += 1000 * DeltaTime;
		}
		else
		if (aTurn>0)
		{
			TurnSpeed -= 1000 * DeltaTime;
		}
		else
		{
			if (TurnSpeed>0)
			{
			TurnSpeed -= 500 * DeltaTime;
			if (TurnSpeed<0) TurnSpeed=0;
			}
			
			if (TurnSpeed<0)
			{
			TurnSpeed += 500 * DeltaTime;
			if (TurnSpeed>0) TurnSpeed=0;
			}
		}
		
		if (TurnSpeed>100)
		TurnSpeed=100;
		if (TurnSpeed<-100)
		TurnSpeed=-100;

		//NewRotation = Rider.Rotation;
		//NewRotation.Roll += TurnSpeed;
		//Rider.SetRotation(NewRotation);
		
		RiderRotation.Roll = -TurnSpeed*50;
		RiderRotation.Yaw -= TurnSpeed*DeltaTime*60*5;
		Rider.SetRotation(RiderRotation);
		
		//Rider.ViewRotation.Roll += TurnSpeed;
		//Rider.Rotation.Roll += TurnSpeed;
		
		//Log("TurnSpeed) "$TurnSpeed$" "$Rider.Rotation.Roll);
		
		return (0);
	}
	

	function HandleBumpForward ()
	{
		local vector NewVelocity;
		local int Speed;

		//Log("JazzVehicle) BumpForward");

		Rider.Velocity.Z -= 10;
				
		NewVelocity = Rider.Velocity;
		NewVelocity.Z = 0;
		Speed = VSize(NewVelocity);
		
		if (Speed>300)	// TOO FAST: Unseat rider!
		{
		Velocity = vect(0,0,0);

			// Retain Ride Velocity and Physics
			SetPhysics(Rider.Physics);
			bCollideWorld = true;
			//bCollideActors = true;
			
			// Return Rider to Normal
			JazzPlayer(Rider).LeaveVehicle();
			
			// Remove Rider
			OldRider = Rider;	OldRiderNoPickupWait = 3;
			Rider = None;
			GotoState('Waiting');
		}
		
		
		Rider.Velocity.X = Rider.Velocity.X * 0.8;
		Rider.Velocity.Y = Rider.Velocity.Y * 0.8;
	}
	
	
	// Main hangglider physics
	//
/*	function vector	FilterVelocityHistory( vector VelocityHistory, float DeltaTime )
	{
		local float OldVelocityKeep;
		local vector NewVelocity;
		local float	Momentum;
		local float LostMomentum;
		local float MomentumPctLoss;	
		local float Gravity;
		local rotator NewRotation;

		if (Rider.Physics == PHYS_Falling)
		{
		Momentum = abs(VSize(VelocityHistory));
		MomentumPctLoss = ((abs(NoseLevel+10)/110)*DeltaTime*2);
		LostMomentum = Momentum * MomentumPctLoss;
		
		// Add Gravity Now
		Gravity = 200*DeltaTime;
		
		// Change in forward Momentum due to nose pointing
		LostMomentum -= Gravity*(NoseLevel/100)*2;
		
		NewVelocity = (VelocityHistory) * (1-MomentumPctLoss)
			 + 	((LostMomentum * vect(1,0,0)) >> Rotation);
			 
		// Filter left/right turning
		//
		Momentum = abs(VSize(NewVelocity));
		MomentumPctLoss = ((abs(RollLevel)/100)*DeltaTime*2);
		LostMomentum = Momentum * MomentumPctLoss;
		
		NewRotation = Rotation;
		NewRotation.Yaw += RollLevel*100;
		
		NewVelocity = (NewVelocity) * (1-MomentumPctLoss)
			 + 	((LostMomentum * vect(1,0,0)) >> NewRotation);

		// Nose Pointed Up
		NewVelocity.Z -= Gravity*(NoseLevel/100);

		// Change rider rotation as vehicle changes
		//
		// !!! Bad reverese programming, but necessary to overcome modification of
		// base pawn class.
		//
		NewRotation = Rider.Rotation;
		NewRotation.Yaw += RollLevel*100*DeltaTime;
		Rider.SetRotation(NewRotation);
		Rider.ViewRotation = NewRotation;
		
		return( NewVelocity );
		}
		else
		{
		OldVelocityKeep = 1 - (DeltaTime);
		
		return( VelocityHistory * OldVelocityKeep );
		}
	}*/

	// Vehicle must appear above player's head.
	//
	function		AcceptVehicleLocation( vector Location, rotator NewRotation )
	{
		SetLocation(Location + (vect(0,0,0) >> Rotation) );
	}

	// Vehicle must have rotation altered by the NoseLevel variable
	//	
	function 		AcceptPlayerRotation( rotator NewRotation )
	{
		//Rider.SetRotation(NewRotation);
		Rider.SetRotation(RiderRotation);
		Rider.ViewRotation = RiderRotation;
		Rider.ViewRotation.Roll = 0;

		NewRotation = RiderRotation;
		NewRotation.Pitch = RollSpeed*5;
		SetRotation(NewRotation);
	}
	
	function EndRideVehicle ()
	{
		Rider.bRotateToDesired = true;
	}
	
	function BeginState()
	{
		Super.BeginState();
		RiderRotation = Rider.Rotation;
		Rider.bRotateToDesired = false;
		CurrentVelocity = 1000;
	}
}

defaultproperties
{
     GroundSpeed=600.000000
     JumpZ=200.000000
     NormalPhysics=PHYS_Flying
     FallingPhysics=PHYS_Flying
     Mesh=Mesh'JazzObjectoids.newcar'
     DrawScale=0.500000
}
