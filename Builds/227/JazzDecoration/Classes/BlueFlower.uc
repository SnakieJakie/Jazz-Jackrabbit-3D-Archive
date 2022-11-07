//=============================================================================
// BlueFlower.
//=============================================================================
class BlueFlower expands JazzDecoration;

#exec MESH IMPORT MESH=BlueFlower ANIVFILE=MODELS\BlueFlower_a.3d DATAFILE=MODELS\BlueFlower_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=BlueFlower X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=BlueFlower SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=BlueFlower SEQ=BlueFlower               STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=BlueFlower MESH=BlueFlower
#exec MESHMAP SCALE MESHMAP=BlueFlower X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JBlueFlower_01 FILE=Textures\BlueFlower_01.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=JBlueFlower_02 FILE=Textures\BlueFlower_02.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=BlueFlower NUM=1 TEXTURE=JBlueFlower_01
#exec MESHMAP SETTEXTURE MESHMAP=BlueFlower NUM=0 TEXTURE=JBlueFlower_02

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.JBlueFlower_02'
     Mesh=Mesh'JazzDecoration.BlueFlower'
}
