//=============================================================================
// coin.
//=============================================================================
class coin expands JazzMeshes;

#exec MESH IMPORT MESH=coin ANIVFILE=MODELS\coin_a.3d DATAFILE=MODELS\coin_d.3d X=0 Y=0 Z=0
#exec MESH LODPARAMS MESH=coin ZDisp=200
#exec MESH ORIGIN MESH=coin X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=coin SEQ=All                      STARTFRAME=0 NUMFRAMES=15
#exec MESH SEQUENCE MESH=coin SEQ=coin                    STARTFRAME=0 NUMFRAMES=15

#exec MESHMAP NEW   MESHMAP=coin MESH=coin
#exec MESHMAP SCALE MESHMAP=coin X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jcoin_01 FILE=Textures\coin_01.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=Jcoin_02 FILE=Textures\coin_02.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=Jcoin_03 FILE=Textures\coin_03.PCX GROUP=Skins FLAGS=2
//Material #3

#exec MESHMAP SETTEXTURE MESHMAP=coin NUM=0 TEXTURE=Jcoin_01

//
//
//
// Arrow

#exec MESH IMPORT MESH=arrow ANIVFILE=MODELS\arrow_a.3d DATAFILE=MODELS\arrow_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=arrow X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=arrow SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=arrow SEQ=arrow                    STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=arrow MESH=arrow
#exec MESHMAP SCALE MESHMAP=arrow X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=arrow NUM=0 TEXTURE=Jcoin_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.coin'
}
