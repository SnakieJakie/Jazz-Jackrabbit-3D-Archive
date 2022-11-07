//=============================================================================
// IceChunk.
//=============================================================================
class IceChunk expands BaseChunk;

function Tick ( float DeltaTime )
{
	DrawScale = (LifeSpan / Default.LifeSpan * 0.8);
}

defaultproperties
{
     LifeSpan=5.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'JazzObjectoids.Skins.Jicebomb_01'
     Mesh=Mesh'JazzObjectoids.iceshard'
     DrawScale=0.800000
     CollisionRadius=4.000000
     CollisionHeight=4.000000
     bCollideActors=True
     bCollideWorld=True
     bBounce=True
     bFixedRotationDir=True
}
