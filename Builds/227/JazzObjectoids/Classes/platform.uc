//=============================================================================
// platform.
//=============================================================================
class platform expands JazzMeshes;

#exec MESH IMPORT MESH=platform ANIVFILE=MODELS\platform_a.3d DATAFILE=MODELS\platform_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=platform X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=platform SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=platform SEQ=platform                 STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=platform MESH=platform
#exec MESHMAP SCALE MESHMAP=platform X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jplatform_01 FILE=Textures\platform_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=platform NUM=0 TEXTURE=Jplatform_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.platform'
}
