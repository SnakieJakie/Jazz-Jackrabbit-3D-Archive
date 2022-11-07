//=============================================================================
// HangGlider.
//=============================================================================
class HangGlider expands JazzVehicle;

// HangGlider must rotate forward & down when pressing forward - increase forward speed
// and downward speed.
//
// HangGlider must rotate back & up when pressing forward - decrease forward speed and
// apply speed change to upward speed.
//

var float NoseLevel;	// Up/down rotation of hangglider.
var	float RollLevel;	// Left/right rotation of hangglider.


function RideInitialize(actor Other)
{
	JazzPlayer(Other).TutorialCheck(TutorialRocketBoard);
}

event PostBeginPlay ()
{
}

state RideVehicle
{
	function float FilterForwardBack( float aForward, float DeltaTime )
	{
		if (Rider.Physics == PHYS_Falling)
		{
			// Nose change 
			if (aForward<0)
			{
			NoseLevel += 50 * DeltaTime;
			if (NoseLevel > 100) NoseLevel = 100;
			}
			else
			if (aForward>0)
			{
			NoseLevel -= 50 * DeltaTime;
			if (NoseLevel < -100) NoseLevel = -100;
			}
			else
			{
				if (NoseLevel>-5)
				{
				NoseLevel -= 5 * DeltaTime;
				}
				else
				{
				NoseLevel += 5 * DeltaTime;
				}
			}
		
		return (0);
		}
		else
		{
			if (abs(NoseLevel) < (50*DeltaTime))
			NoseLevel = 0;
			else
			if (NoseLevel>0)
			{
			NoseLevel -= 50 * DeltaTime;
			}
			else
			{
			NoseLevel += 50 * DeltaTime;
			}
				
		return (aForward*ForwardAccelPct);
		}
	}
	
	function		PlayerPressedJump( )
	{
		if (Rider.Physics != PHYS_Falling)
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
		}
	}
	
	// Turn hangglider left or right
	//
	function float 	FilterTurn( float aTurn, float DeltaTime )
	{
		if (Rider.Physics == PHYS_Falling)
		{
			// Nose change 
			if (aTurn>0)
			{
			RollLevel += 50 * DeltaTime;
			if (RollLevel > 100) RollLevel = 100;
			}
			else
			if (aTurn<0)
			{
			RollLevel -= 50 * DeltaTime;
			if (RollLevel < -100) RollLevel = -100;
			}
			else
			{
				if (abs(RollLevel) < (5*DeltaTime))
				RollLevel = 0;
				if (RollLevel>0)
				{
				RollLevel -= 5 * DeltaTime;
				}
				else
				{
				RollLevel += 5 * DeltaTime;
				}
			}
		
		return (0);
		}
		else
		{
			if (abs(RollLevel) < (50*DeltaTime))
			RollLevel = 0;
			else
			if (RollLevel>0)
			{
			RollLevel -= 50 * DeltaTime;
			}
			else
			{
			RollLevel += 50 * DeltaTime;
			}
				
		return (aTurn);
		}
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
	function vector	FilterVelocityHistory( vector VelocityHistory, float DeltaTime )
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
	}

	// Vehicle must appear above player's head.
	//
	function		AcceptVehicleLocation( vector Location, rotator NewRotation )
	{
		SetLocation(Location + (vect(0,0,50) >> Rotation) );
	}

	// Vehicle must have rotation altered by the NoseLevel variable
	//	
	function 		AcceptPlayerRotation( rotator NewRotation )
	{
		NewRotation.Roll 	= RollLevel*100;
		NewRotation.Pitch 	= NoseLevel*100;

		Rider.SetRotation(NewRotation);

		SetRotation(NewRotation);
	}
}

defaultproperties
{
     NormalPhysics=PHYS_None
     FallingPhysics=PHYS_None
     Mesh=Mesh'UnrealShare.Bird'
     DrawScale=1.500000
     CollisionRadius=80.000000
     CollisionHeight=60.000000
     bCollideWorld=True
}
