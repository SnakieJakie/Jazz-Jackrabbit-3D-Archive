//=============================================================================
// keygold.
//=============================================================================
class keygold expands JazzMeshes;

#exec MESH IMPORT MESH=keygold ANIVFILE=MODELS\keygold_a.3d DATAFILE=MODELS\keygold_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=keygold X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=keygold SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=keygold SEQ=keygold                  STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=keygold MESH=keygold
#exec MESHMAP SCALE MESHMAP=keygold X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jkeygold_01 FILE=Textures\keygold_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=keygold NUM=1 TEXTURE=Jkeygold_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.keygold'
}
