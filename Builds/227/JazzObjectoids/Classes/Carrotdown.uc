//=============================================================================
// Carrotdown.
//=============================================================================
class Carrotdown expands JazzMeshes;

#exec MESH IMPORT MESH=Carrotdown ANIVFILE=MODELS\Carrotdown_a.3d DATAFILE=MODELS\Carrotdown_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Carrotdown X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Carrotdown SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Carrotdown SEQ=carrotdown               STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Carrotdown MESH=Carrotdown
#exec MESHMAP SCALE MESHMAP=Carrotdown X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JCarrotdown_01 FILE=Textures\Carrotdown_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=Carrotdown NUM=1 TEXTURE=JCarrotdown_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.Carrotdown'
}
