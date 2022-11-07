//=============================================================================
// JazzBoulder.
//=============================================================================
class JazzBoulder expands JazzPlainObjects;

defaultproperties
{
     ObjectMaterial=OBJ_Mineral
     Health=20
     Destroyable=True
     ChunkClass=Class'CalyGame.RockChunk'
     NumberOfChunks=4
     bPushable=True
     bGlides=True
     bRotates=True
     FrictionSlowdown=3.000000
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.Jplatform_01'
     Mesh=Mesh'JazzObjectoids.rock1'
     CollisionRadius=30.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
