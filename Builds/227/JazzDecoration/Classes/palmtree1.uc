//=============================================================================
// palmtree1.
//=============================================================================
class palmtree1 expands JazzDecoration;

#exec MESH IMPORT MESH=palmtree1 ANIVFILE=MODELS\palmtree1_a.3d DATAFILE=MODELS\palmtree1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=palmtree1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=palmtree1 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=palmtree1 SEQ=palmtree1                STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=palmtree1 MESH=palmtree1
#exec MESHMAP SCALE MESHMAP=palmtree1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jpalmtree1_01 FILE=Textures\palmtree1_01.PCX GROUP=Skins FLAGS=2	//SKIN
#exec TEXTURE IMPORT NAME=Jpalmtree1_02 FILE=Textures\palmtree1_02.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=palmtree1 NUM=0 TEXTURE=Jpalmtree1_01
#exec MESHMAP SETTEXTURE MESHMAP=palmtree1 NUM=2 TEXTURE=Jpalmtree1_02

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jpalmtree1_01'
     Mesh=Mesh'JazzDecoration.palmtree1'
     DrawScale=2.000000
     CollisionHeight=44.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
