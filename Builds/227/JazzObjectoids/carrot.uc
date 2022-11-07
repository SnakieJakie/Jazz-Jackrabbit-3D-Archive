//=============================================================================
// carrot.
//=============================================================================
class carrot expands JazzMeshes;

#exec MESH IMPORT MESH=carrot ANIVFILE=MODELS\carrot_a.3d DATAFILE=MODELS\carrot_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=carrot X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=carrot SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=carrot SEQ=carrot                   STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=carrot MESH=carrot
#exec MESHMAP SCALE MESHMAP=carrot X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jcarrot_01 FILE=Textures\carrot_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=carrot NUM=0 TEXTURE=Jcarrot_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.carrot'
}
