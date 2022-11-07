//=============================================================================
// arrow.
//=============================================================================
class arrow expands Actor;

#exec MESH IMPORT MESH=arrow ANIVFILE=MODELS\arrow_a.3d DATAFILE=MODELS\arrow_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=arrow X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=arrow SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=arrow SEQ=arrow                    STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=arrow MESH=arrow
#exec MESHMAP SCALE MESHMAP=arrow X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jarrow_01 FILE=Textures\arrow_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=arrow NUM=0 TEXTURE=Jarrow_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=arrow
}

