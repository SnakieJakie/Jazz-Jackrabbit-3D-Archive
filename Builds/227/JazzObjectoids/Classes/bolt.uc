//=============================================================================
// bolt.
//=============================================================================
class bolt expands JazzMeshes;

#exec MESH IMPORT MESH=bolt ANIVFILE=MODELS\bolt_a.3d DATAFILE=MODELS\bolt_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=bolt X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=bolt SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=bolt SEQ=bolt1                    STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=bolt MESH=bolt
#exec MESHMAP SCALE MESHMAP=bolt X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jbolt_01 FILE=Textures\bolt_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=bolt NUM=1 TEXTURE=Jbolt_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=bolt
}

