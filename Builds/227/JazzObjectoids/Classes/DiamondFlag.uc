//=============================================================================
// DiamondFlag.
//=============================================================================
class DiamondFlag expands JazzMeshes;

#exec MESH IMPORT MESH=DiamondFlag ANIVFILE=MODELS\DiamondFlag_a.3d DATAFILE=MODELS\DiamondFlag_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DiamondFlag X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=DiamondFlag SEQ=All                      STARTFRAME=0 NUMFRAMES=50
#exec MESH SEQUENCE MESH=DiamondFlag SEQ=DiamondFlag              STARTFRAME=0 NUMFRAMES=50

#exec MESHMAP NEW   MESHMAP=DiamondFlag MESH=DiamondFlag
#exec MESHMAP SCALE MESHMAP=DiamondFlag X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JDiamondFlag_01 FILE=Textures\DiamondFlag_01.PCX GROUP=Skins FLAGS=2	//Material #1
#exec TEXTURE IMPORT NAME=JDiamondFlag_02 FILE=Textures\DiamondFlag_02.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=JDiamondFlag_03 FILE=Textures\DiamondFlag_03.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=DiamondFlag NUM=1 TEXTURE=JDiamondFlag_01
#exec MESHMAP SETTEXTURE MESHMAP=DiamondFlag NUM=2 TEXTURE=JDiamondFlag_02
#exec MESHMAP SETTEXTURE MESHMAP=DiamondFlag NUM=3 TEXTURE=JDiamondFlag_03

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.DiamondFlag'
}
