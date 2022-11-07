//=============================================================================
// pump.
//=============================================================================
class pump expands JazzMeshes;

#exec MESH IMPORT MESH=pump ANIVFILE=MODELS\pump_a.3d DATAFILE=MODELS\pump_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=pump X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=pump SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=pump SEQ=pump                     STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=pump MESH=pump
#exec MESHMAP SCALE MESHMAP=pump X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jpump_01 FILE=Textures\pump_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=pump NUM=1 TEXTURE=Jpump_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.pump'
}
