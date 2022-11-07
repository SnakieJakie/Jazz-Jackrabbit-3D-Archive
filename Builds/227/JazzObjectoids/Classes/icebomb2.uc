//=============================================================================
// icebomb2.
//=============================================================================
class icebomb2 expands JazzMeshes;

#exec MESH IMPORT MESH=icebomb2 ANIVFILE=MODELS\icebomb2_a.3d DATAFILE=MODELS\icebomb2_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=icebomb2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=icebomb2 SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=icebomb2 SEQ=icebomb2                 STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=icebomb2 MESH=icebomb2
#exec MESHMAP SCALE MESHMAP=icebomb2 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jicebomb_01 FILE=Textures\icebomb_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=icebomb2 NUM=0 TEXTURE=Jicebomb_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.icebomb2'
}
