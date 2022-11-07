//=============================================================================
// qumark.
//=============================================================================
class qumark expands Actor;

#exec MESH IMPORT MESH=qumark ANIVFILE=MODELS\qumark_a.3d DATAFILE=MODELS\qumark_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=qumark X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=qumark SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=qumark SEQ=qumark                   STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=qumark MESH=qumark
#exec MESHMAP SCALE MESHMAP=qumark X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jqumark_01 FILE=Textures\qumark_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=qumark NUM=1 TEXTURE=Jqumark_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=qumark
}

