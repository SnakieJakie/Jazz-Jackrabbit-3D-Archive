//=============================================================================
// airboard4.
//=============================================================================
class airboard4 expands JazzMeshes;

#exec MESH IMPORT MESH=airboard ANIVFILE=MODELS\airboard_a.3d DATAFILE=MODELS\airboard_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=airboard X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=airboard SEQ=All                     STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=airboard SEQ=airboard                STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=airboard MESH=airboard
#exec MESHMAP SCALE MESHMAP=airboard X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jairboard_01 FILE=Textures\airboard_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=airboard NUM=1 TEXTURE=Jairboard_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.airboard'
}
