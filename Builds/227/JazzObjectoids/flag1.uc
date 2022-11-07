//=============================================================================
// flag1.
//=============================================================================
class flag1 expands JazzMeshes;

#exec MESH IMPORT MESH=flag1 ANIVFILE=MODELS\flag1_a.3d DATAFILE=MODELS\flag1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=flag1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=flag1 SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=flag1 SEQ=flag1                    STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=flag1 MESH=flag1
#exec MESHMAP SCALE MESHMAP=flag1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jflag1_01 FILE=Textures\flag1_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=flag1 NUM=1 TEXTURE=Jflag1_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.flag1'
}
