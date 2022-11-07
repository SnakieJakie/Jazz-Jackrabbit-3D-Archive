//=============================================================================
// FlyingSnowBoard.
//=============================================================================
class FlyingSnowBoard expands JazzVehicle;

event PostBeginPlay ()
{
}

state RideVehicle
{
	function 		AcceptPlayerRotation( rotator NewRotation )
	{
		SetRotation(NewRotation);
	}
	
	function float FilterForwardBack( float aForward, float DeltaTime )
	{
		//Log("Velocity) "$Rider.Velocity$" "$Rider$" "$Rider.Acceleration);
		
		// Remove motion up the track - try to go only in Y direction.
		if (Rider.Velocity.Y < 0) 
		{
			Rider.Acceleration.Y /= 10;
			Rider.Velocity.Y /= 10;
		}
		//Rider.Velocity.Y += 500*DeltaTime;
	
		return (aForward*ForwardAccelPct);
	}
	
	function		PlayerPressedJump( )
	{
		if (Rider.Physics != PHYS_Falling)
		if (JumpWithVehicle)
		{
			Rider.Velocity.Z = JumpZ * ( (VSize(Rider.Velocity)+200)/(GroundSpeed+200) );
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
}

function RideInitialize(actor Other)
{
	JazzPlayer(Other).TutorialCheck(TutorialRocketBoard);
}

defaultproperties
{
     ForwardAllow=True
     ForwardAccelPct=0.500000
     GroundSpeed=400.000000
     TurnAllow=True
     JumpWithVehicle=True
     JumpZ=280.000000
     BounceAllow=True
     BounceZPct=0.100000
     ArtificialGravity=(Z=-850.000000)
     NormalPhysics=PHYS_Flying
     FallingPhysics=PHYS_Flying
     Texture=Texture'JazzObjectoids.Skins.Jairboard_01'
     Mesh=Mesh'JazzObjectoids.airboard'
     DrawScale=3.000000
}
