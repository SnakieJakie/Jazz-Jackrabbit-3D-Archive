//=============================================================================
// TimeDemoInterpolationPoint - used to time one cycle of a flyby
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class TimeDemoInterpolationPoint expands InterpolationPoint;

var TimeDemo T;

function InterpolateEnd( actor Other ) {
	T.StartCycle();
	Super.InterpolateEnd(Other);
}

defaultproperties
{
}
