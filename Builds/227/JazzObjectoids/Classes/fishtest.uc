//=============================================================================
// fishtest.
//=============================================================================
class fishtest expands JazzMeshes;

#exec MESH IMPORT MESH=fishtest ANIVFILE=MODELS\fishtest_a.3d DATAFILE=MODELS\fishtest_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=fishtest X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=fishtest SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=fishtest SEQ=fishtest                 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=fishtest MESH=fishtest
#exec MESHMAP SCALE MESHMAP=fishtest X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jfishtest_01 FILE=Textures\fishtest_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=fishtest NUM=1 TEXTURE=Jfishtest_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.fishtest'
}
