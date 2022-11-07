//=============================================================================
// rocket2.
//=============================================================================
class rocket2 expands JazzMeshes;

#exec MESH IMPORT MESH=rocket2 ANIVFILE=MODELS\rocket2_a.3d DATAFILE=MODELS\rocket2_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=rocket2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=rocket2 SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=rocket2 SEQ=rocket2                  STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=rocket2 MESH=rocket2
#exec MESHMAP SCALE MESHMAP=rocket2 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jrocket2_01 FILE=Textures\rocket2_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=rocket2 NUM=1 TEXTURE=Jrocket2_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.rocket2'
}
