//=============================================================================
// fireblast.
//=============================================================================
class fireblast expands JazzMeshes;

#exec MESH IMPORT MESH=fireblast ANIVFILE=MODELS\fireblast_a.3d DATAFILE=MODELS\fireblast_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=fireblast X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=fireblast SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=fireblast SEQ=fireblast                STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=fireblast MESH=fireblast
#exec MESHMAP SCALE MESHMAP=fireblast X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jfireblast_01 FILE=Textures\fireblast_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=fireblast NUM=1 TEXTURE=Jfireblast_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.fireblast'
}
