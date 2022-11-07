//=============================================================================
// rocket1.
//=============================================================================
class rocket1 expands JazzMeshes;

#exec MESH IMPORT MESH=rocket1 ANIVFILE=MODELS\rocket1_a.3d DATAFILE=MODELS\rocket1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=rocket1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=rocket1 SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=rocket1 SEQ=rocket1                  STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=rocket1 MESH=rocket1
#exec MESHMAP SCALE MESHMAP=rocket1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jrocket1_01 FILE=Textures\rocket1_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=rocket1 NUM=1 TEXTURE=Jrocket1_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.rocket1'
}
