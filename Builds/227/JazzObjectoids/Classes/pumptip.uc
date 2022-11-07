//=============================================================================
// pumptip.
//=============================================================================
class pumptip expands JazzMeshes;

#exec MESH IMPORT MESH=pumptip ANIVFILE=MODELS\pumptip_a.3d DATAFILE=MODELS\pumptip_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=pumptip X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=pumptip SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=pumptip SEQ=pumptip                  STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=pumptip MESH=pumptip
#exec MESHMAP SCALE MESHMAP=pumptip X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jpumptip_01 FILE=Textures\pumptip_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=pumptip NUM=1 TEXTURE=Jpumptip_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.pumptip'
}
