//=============================================================================
// RedFlower.
//=============================================================================
class RedFlower expands JazzDecoration;

#exec MESH IMPORT MESH=RedFlower ANIVFILE=MODELS\RedFlower_a.3d DATAFILE=MODELS\RedFlower_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=RedFlower X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=RedFlower SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=RedFlower SEQ=Redflower                STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=RedFlower MESH=RedFlower
#exec MESHMAP SCALE MESHMAP=RedFlower X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JRedFlower_01 FILE=Textures\RedFlower_01.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=JRedFlower_02 FILE=Textures\RedFlower_02.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=RedFlower NUM=1 TEXTURE=JRedFlower_01
#exec MESHMAP SETTEXTURE MESHMAP=RedFlower NUM=0 TEXTURE=JRedFlower_02

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.JRedFlower_02'
     Mesh=Mesh'JazzDecoration.RedFlower'
}
