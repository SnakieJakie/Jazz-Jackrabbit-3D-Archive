//=============================================================================
// Willtree1.
//=============================================================================
class Willtree1 expands JazzDecoration;

#exec MESH IMPORT MESH=Willtree1 ANIVFILE=MODELS\Willtree1_a.3d DATAFILE=MODELS\Willtree1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Willtree1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Willtree1 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Willtree1 SEQ=Willtree1                STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Willtree1 MESH=Willtree1
#exec MESHMAP SCALE MESHMAP=Willtree1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JWilltree1_01 FILE=Textures\Willtree1_01.PCX GROUP=Skins FLAGS=2	//SKIN
#exec TEXTURE IMPORT NAME=JWilltree1_02 FILE=Textures\Willtree1_02.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=Willtree1 NUM=0 TEXTURE=JWilltree1_01
#exec MESHMAP SETTEXTURE MESHMAP=Willtree1 NUM=2 TEXTURE=JWilltree1_02

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.JWilltree1_01'
     Mesh=Mesh'JazzDecoration.Willtree1'
     DrawScale=3.000000
     CollisionHeight=82.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
