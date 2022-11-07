//=============================================================================
// CometTrail.
//=============================================================================
class CometTrail expands JazzEffects;

var() 	float		DistanceBehind;
var()	float		LifeTime;

function Tick ( float DeltaTime )
{
	local vector NewLocation;

	if (Owner==None)
	Destroy();

	// Each tick move to owner's location.
	NewLocation = Owner.Location - vector(Owner.Rotation)*DistanceBehind;
	
	SetLocation(NewLocation);
	
	// Fade in when created
	LifeTime += DeltaTime;
	if (LifeTime<1)
		ScaleGlow = LifeTime;
		else
		ScaleGlow = 1;
}

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'UnrealShare.DispM1'
     Fatness=255
}
