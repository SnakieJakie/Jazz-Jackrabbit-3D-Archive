//=============================================================================
// expoint.
//=============================================================================
class expoint expands Actor;

#exec MESH IMPORT MESH=expoint ANIVFILE=MODELS\expoint_a.3d DATAFILE=MODELS\expoint_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=expoint X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=expoint SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=expoint SEQ=expoint                  STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=expoint MESH=expoint
#exec MESHMAP SCALE MESHMAP=expoint X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jexpoint_01 FILE=Textures\expoint_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=expoint NUM=1 TEXTURE=Jexpoint_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=expoint
}

