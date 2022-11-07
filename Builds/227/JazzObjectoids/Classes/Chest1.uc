//=============================================================================
// Chest1.
//=============================================================================
class Chest1 expands JazzMeshes;

#exec MESH IMPORT MESH=Chest1 ANIVFILE=MODELS\Chest1_a.3d DATAFILE=MODELS\Chest1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Chest1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Chest1 SEQ=All                      STARTFRAME=0 NUMFRAMES=25
#exec MESH SEQUENCE MESH=Chest1 SEQ=chestopen                STARTFRAME=0 NUMFRAMES=24
#exec MESH SEQUENCE MESH=Chest1 SEQ=Chestclose               STARTFRAME=24 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Chest1 MESH=Chest1
#exec MESHMAP SCALE MESHMAP=Chest1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JChest1_01 FILE=Textures\Chest1_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=Chest1 NUM=0 TEXTURE=JChest1_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.Chest1'
}
