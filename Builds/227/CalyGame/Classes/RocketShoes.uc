//=============================================================================
// RocketShoes.
//=============================================================================
class RocketShoes expands JazzVehicle;

function AcceptPlayerRotation( rotator NewRotation )
{
	NewRotation.Yaw += 16384;
	Super.AcceptPlayerRotation(NewRotation);
}

defaultproperties
{
     AnimSequence=Open
     Mesh=Mesh'UnrealI.CryopodM'
     DrawScale=0.500000
}
