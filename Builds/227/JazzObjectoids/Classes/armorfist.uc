//=============================================================================
// armorfist.
//=============================================================================
class armorfist expands JazzMeshes;

#exec MESH IMPORT MESH=armorfist ANIVFILE=MODELS\armorfist_a.3d DATAFILE=MODELS\armorfist_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=armorfist X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=armorfist SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=armorfist SEQ=armorfist                STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=armorfist MESH=armorfist
#exec MESHMAP SCALE MESHMAP=armorfist X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jarmorfist_01 FILE=Textures\armorfist_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=armorfist NUM=1 TEXTURE=Jarmorfist_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.armorfist'
}
