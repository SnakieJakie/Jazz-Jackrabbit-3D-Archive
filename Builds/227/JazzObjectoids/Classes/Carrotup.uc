//=============================================================================
// Carrotup.
//=============================================================================
class Carrotup expands JazzMeshes;

#exec MESH IMPORT MESH=Carrotup ANIVFILE=MODELS\Carrotup_a.3d DATAFILE=MODELS\Carrotup_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Carrotup X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Carrotup SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Carrotup SEQ=carrotup                 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Carrotup MESH=Carrotup
#exec MESHMAP SCALE MESHMAP=Carrotup X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JCarrotup_01 FILE=Textures\Carrotup_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=Carrotup NUM=1 TEXTURE=JCarrotup_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.Carrotup'
}
