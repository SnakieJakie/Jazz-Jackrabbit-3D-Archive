//=============================================================================
// DummyWaitingJazz.
//=============================================================================
class DummyWaitingJazz expands JazzPlainObjects;

//
// This is an unscripted dummy Jazz who just stands there.  Intended to be used for
// displays or something - not in-game.
// 
//

function PreBeginPlay()
{
	LoopAnim('JazzIdle1');
}

defaultproperties
{
     AnimSequence=jazzidle1
     AnimRate=1.000000
     DrawType=DT_Mesh
     Skin=Texture'Jazz3.Jjazz_01'
     Mesh=Mesh'Jazz3.Jazz'
     CollisionHeight=44.000000
}
