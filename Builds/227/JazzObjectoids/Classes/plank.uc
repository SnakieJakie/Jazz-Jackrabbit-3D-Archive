//=============================================================================
// plank.
//=============================================================================
class plank expands JazzMeshes;

#exec MESH IMPORT MESH=plank ANIVFILE=MODELS\plank_a.3d DATAFILE=MODELS\plank_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=plank X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=plank SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=plank SEQ=plank                    STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=plank MESH=plank
#exec MESHMAP SCALE MESHMAP=plank X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jplank_01 FILE=Textures\plank_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=plank NUM=0 TEXTURE=Jplank_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.plank'
}
