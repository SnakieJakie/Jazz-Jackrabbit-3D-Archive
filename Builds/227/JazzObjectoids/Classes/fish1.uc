//=============================================================================
// fish1.
//=============================================================================
class fish1 expands JazzMeshes;

#exec MESH IMPORT MESH=fish1 ANIVFILE=MODELS\fish1_a.3d DATAFILE=MODELS\fish1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=fish1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=fish1 SEQ=All                      STARTFRAME=0 NUMFRAMES=29
#exec MESH SEQUENCE MESH=fish1 SEQ=fish1anim                STARTFRAME=0 NUMFRAMES=28
#exec MESH SEQUENCE MESH=fish1 SEQ=fish1still               STARTFRAME=28 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=fish1 MESH=fish1
#exec MESHMAP SCALE MESHMAP=fish1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jfish1_01 FILE=Textures\fish1_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=fish1 NUM=1 TEXTURE=Jfish1_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.fish1'
}
