//=============================================================================
// Springboard.
//=============================================================================
class Springboard expands JazzMotionObjects;

var() sound		BounceSound;


function Touch( actor Other )
{
/*	local rotator NewRotation,RotToOther;
	local int PitchChange,YawChange;
	
	NewRotation = Rotation;
	NewRotation.Pitch -= 16384;
	NewRotation.Roll -= 16384;

	// Location must be in direction of rotation
	RotToOther = rotator(Location - Other.Location);
	RotToOther.Roll = 0;
	
	PitchChange = abs(RotToOther.pitch - NewRotation.pitch);
	YawChange 	= abs(RotToOther.yaw - NewRotation.yaw);

	Log("Springboard) Pitch "$PitchChange$" "$YawChange);

	// Other actor is within reaonable range.
	//
	// NOTE: This is questionable math.  The premise seems sound, but at this point I don't know how to
	// translate to a correct circular radial variation based on the collision height...
	// I'd probably have to draw it for anyone reading this to really understand. ;)
	//
	// However, I'm going to just guess.
	//
	if ((PitchChange + YawChange) < 16384)
	{*/
		// For the moment, just bounce the player by deflecting off the springboard.
		//
		// Wish I had a Physics book...
		//
		
		// (1) Transfer momentum to spring.
		// (2) Return momentum in the form of energy.
		
		// Here's a dumb test routine...
		//
	if (Pawn(Other) != None)
	{	
		Other.Velocity.Z = abs(Other.Velocity.Z)*2;
		Other.SetLocation(Other.Location + vect(0,0,50));
		Other.SetPhysics(PHYS_Falling);
		Other.PlaySound(BounceSound);
		
		// Special effect trail
		JazzPlayer(Other).PlayerTrailTime(2);
		
		Log("Springboard) "$Other.Velocity.Z);
	}
		
	//}
}

defaultproperties
{
     bDirectional=True
     DrawType=DT_Mesh
     Mesh=Mesh'UnrealShare.BarrelM'
     DrawScale=3.000000
     CollisionRadius=44.000000
     CollisionHeight=87.000000
     bCollideActors=True
     bCollideWorld=True
}
