//=============================================================================
// icebomb.
//=============================================================================
class icebomb expands JazzMeshes;

#exec MESH IMPORT MESH=icebomb ANIVFILE=MODELS\icebomb_a.3d DATAFILE=MODELS\icebomb_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=icebomb X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=icebomb SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=icebomb SEQ=icebomb                  STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=icebomb MESH=icebomb
#exec MESHMAP SCALE MESHMAP=icebomb X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jicebomb_01 FILE=Textures\icebomb_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=icebomb NUM=0 TEXTURE=Jicebomb_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.icebomb'
}
