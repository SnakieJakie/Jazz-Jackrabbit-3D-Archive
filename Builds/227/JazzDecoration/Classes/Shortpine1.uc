//=============================================================================
// Shortpine1.
//=============================================================================
class Shortpine1 expands JazzDecoration;

#exec MESH IMPORT MESH=Shortpine1 ANIVFILE=MODELS\Shortpine1_a.3d DATAFILE=MODELS\Shortpine1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Shortpine1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Shortpine1 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Shortpine1 SEQ=shortpine1               STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Shortpine1 MESH=Shortpine1
#exec MESHMAP SCALE MESHMAP=Shortpine1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JShortpine1_01 FILE=Textures\Shortpine1_01.PCX GROUP=Skins FLAGS=2	//SKIN
#exec TEXTURE IMPORT NAME=JShortpine1_02 FILE=Textures\Shortpine1_02.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=Shortpine1 NUM=0 TEXTURE=JShortpine1_01
#exec MESHMAP SETTEXTURE MESHMAP=Shortpine1 NUM=2 TEXTURE=JShortpine1_02

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.JShortpine1_01'
     Mesh=Mesh'JazzDecoration.Shortpine1'
     DrawScale=3.000000
     CollisionHeight=150.000000
}
