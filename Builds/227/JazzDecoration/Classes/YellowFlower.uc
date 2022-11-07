//=============================================================================
// YellowFlower.
//=============================================================================
class YellowFlower expands JazzDecoration;

#exec MESH IMPORT MESH=YellowFlower ANIVFILE=MODELS\YellowFlower_a.3d DATAFILE=MODELS\YellowFlower_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=YellowFlower X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=YellowFlower SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=YellowFlower SEQ=Yellowflower             STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=YellowFlower MESH=YellowFlower
#exec MESHMAP SCALE MESHMAP=YellowFlower X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JYellowFlower_01 FILE=Textures\YellowFlower_01.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=JYellowFlower_02 FILE=Textures\YellowFlower_02.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=YellowFlower NUM=1 TEXTURE=JYellowFlower_01
#exec MESHMAP SETTEXTURE MESHMAP=YellowFlower NUM=0 TEXTURE=JYellowFlower_02

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.JYellowFlower_02'
     Mesh=Mesh'JazzDecoration.YellowFlower'
}
