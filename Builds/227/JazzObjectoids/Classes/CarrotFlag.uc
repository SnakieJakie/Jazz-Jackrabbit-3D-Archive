//=============================================================================
// CarrotFlag.
//=============================================================================
class CarrotFlag expands JazzMeshes;

#exec MESH IMPORT MESH=CarrotFlag ANIVFILE=MODELS\CarrotFlag_a.3d DATAFILE=MODELS\CarrotFlag_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=CarrotFlag X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=CarrotFlag SEQ=All                      STARTFRAME=0 NUMFRAMES=50
#exec MESH SEQUENCE MESH=CarrotFlag SEQ=CarrotFlag               STARTFRAME=0 NUMFRAMES=50

#exec MESHMAP NEW   MESHMAP=CarrotFlag MESH=CarrotFlag
#exec MESHMAP SCALE MESHMAP=CarrotFlag X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JCarrotFlag_01 FILE=Textures\CarrotFlag_01.PCX GROUP=Skins FLAGS=2	//Material #1
#exec TEXTURE IMPORT NAME=JCarrotFlag_02 FILE=Textures\CarrotFlag_02.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=JCarrotFlag_03 FILE=Textures\CarrotFlag_03.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=CarrotFlag NUM=1 TEXTURE=JCarrotFlag_01
#exec MESHMAP SETTEXTURE MESHMAP=CarrotFlag NUM=2 TEXTURE=JCarrotFlag_02
#exec MESHMAP SETTEXTURE MESHMAP=CarrotFlag NUM=3 TEXTURE=JCarrotFlag_03

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.CarrotFlag'
}
