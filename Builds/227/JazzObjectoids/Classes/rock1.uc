//=============================================================================
// rock1.
//=============================================================================
class rock1 expands JazzMeshes;

#exec MESH IMPORT MESH=rock1 ANIVFILE=MODELS\rock1_a.3d DATAFILE=MODELS\rock1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=rock1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=rock1 SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=rock1 SEQ=rock1                    STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=rock1 MESH=rock1
#exec MESHMAP SCALE MESHMAP=rock1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jrock1_01 FILE=Textures\rock1_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=rock1 NUM=1 TEXTURE=Jrock1_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.rock1'
}
