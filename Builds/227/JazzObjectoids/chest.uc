//=============================================================================
// chest.
//=============================================================================
class chest expands JazzMeshes;

#exec MESH IMPORT MESH=chest ANIVFILE=MODELS\chest_a.3d DATAFILE=MODELS\chest_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=chest X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=chest SEQ=All                      STARTFRAME=0 NUMFRAMES=9
#exec MESH SEQUENCE MESH=chest SEQ=chest1                   STARTFRAME=0 NUMFRAMES=9

#exec MESHMAP NEW   MESHMAP=chest MESH=chest
#exec MESHMAP SCALE MESHMAP=chest X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jchest_01 FILE=Textures\chest_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=chest NUM=0 TEXTURE=Jchest_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.chest'
}
