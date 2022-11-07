//=============================================================================
// fish2.
//=============================================================================
class fish2 expands JazzMeshes;

#exec MESH IMPORT MESH=fish2 ANIVFILE=MODELS\fish2_a.3d DATAFILE=MODELS\fish2_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=fish2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=fish2 SEQ=All                      STARTFRAME=0 NUMFRAMES=29
#exec MESH SEQUENCE MESH=fish2 SEQ=fish2anim                STARTFRAME=0 NUMFRAMES=28
#exec MESH SEQUENCE MESH=fish2 SEQ=fish2still               STARTFRAME=28 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=fish2 MESH=fish2
#exec MESHMAP SCALE MESHMAP=fish2 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jfish2_01 FILE=Textures\fish2_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=fish2 NUM=1 TEXTURE=Jfish2_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.fish2'
}
