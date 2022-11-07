//=============================================================================
// WavingFlagTwo.
//=============================================================================
class WavingFlagTwo expands WavingFlag;

function PreBeginPlay()
{
	LoopAnim('DiamondFlag');
}

defaultproperties
{
     AnimSequence=DiamondFlag
     Mesh=Mesh'JazzObjectoids.DiamondFlag'
}
