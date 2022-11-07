//=============================================================================
// wcell.
//=============================================================================
class wcell expands JazzMeshes;

#exec MESH IMPORT MESH=wcell ANIVFILE=MODELS\wcell_a.3d DATAFILE=MODELS\wcell_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=wcell X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=wcell SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=wcell SEQ=wcell                    STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=wcell MESH=wcell
#exec MESHMAP SCALE MESHMAP=wcell X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jwcell_01 FILE=Textures\wcell_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=wcell NUM=0 TEXTURE=Jwcell_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.wcell'
}
