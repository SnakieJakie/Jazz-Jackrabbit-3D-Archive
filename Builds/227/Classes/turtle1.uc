//=============================================================================
// turtle1.
//=============================================================================
class turtle1 expands actor;

#exec MESH IMPORT MESH=turtle1 ANIVFILE=MODELS\turtle1_a.3d DATAFILE=MODELS\turtle1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=turtle1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=turtle1 SEQ=All                      STARTFRAME=0 NUMFRAMES=30
#exec MESH SEQUENCE MESH=turtle1 SEQ=turtle1                  STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW   MESHMAP=turtle1 MESH=turtle1
#exec MESHMAP SCALE MESHMAP=turtle1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jturtle1_01 FILE=Textures\turtle1_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=turtle1 NUM=1 TEXTURE=Jturtle1_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=turtle1
}

