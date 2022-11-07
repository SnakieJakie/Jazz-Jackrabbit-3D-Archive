//=============================================================================
// expring.
//=============================================================================
class expring expands Actor;

#exec MESH IMPORT MESH=expring ANIVFILE=MODELS\expring_a.3d DATAFILE=MODELS\expring_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=expring X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=expring SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=expring SEQ=expring                  STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=expring MESH=expring
#exec MESHMAP SCALE MESHMAP=expring X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jexpring_01 FILE=Textures\expring_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=expring NUM=1 TEXTURE=Jexpring_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=expring
}

