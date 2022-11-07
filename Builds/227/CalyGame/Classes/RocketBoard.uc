//=============================================================================
// RocketBoard.
//=============================================================================
class RocketBoard expands JazzVehicle;


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
		return (aForward);
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
     GroundSpeed=1000.000000
     TurnAllow=True
     JumpLeaveVehicle=True
     GravityPct=0.500000
     bRollStaysFlat=True
     bRollWithPlayer=True
     NormalPhysics=PHYS_None
     FallingPhysics=PHYS_None
     AnimSequence=still
     Rotation=(Pitch=16384)
     Texture=Texture'JazzObjectoids.Skins.Jairboard_01'
     Mesh=Mesh'JazzObjectoids.airboard'
     DrawScale=3.000000
}
