//=============================================================================
// gem.
//=============================================================================
class gem expands JazzMeshes;

#exec MESH IMPORT MESH=gem ANIVFILE=MODELS\gem_a.3d DATAFILE=MODELS\gem_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=gem X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=gem SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=gem SEQ=gem                      STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=gem MESH=gem
#exec MESHMAP SCALE MESHMAP=gem X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jgem_01 FILE=Textures\gem_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=gem NUM=0 TEXTURE=Jgem_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.gem'
}
