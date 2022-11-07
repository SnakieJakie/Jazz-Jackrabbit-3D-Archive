//=============================================================================
// WavingFlag.
//=============================================================================
class WavingFlag expands JazzPlainObjects;

function PreBeginPlay()
{
	LoopAnim('CarrotFlag');
}

defaultproperties
{
     AnimSequence=CarrotFlag
     AnimRate=1.000000
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.CarrotFlag'
     CollisionRadius=5.000000
     CollisionHeight=30.000000
}
