//=============================================================================
// Pointer.
//=============================================================================
class Pointer expands JazzMeshes;

#exec MESH IMPORT MESH=Pointer ANIVFILE=MODELS\Pointer_a.3d DATAFILE=MODELS\Pointer_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Pointer X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Pointer SEQ=All                      STARTFRAME=0 NUMFRAMES=11
#exec MESH SEQUENCE MESH=Pointer SEQ=Pointeranim              STARTFRAME=0 NUMFRAMES=10
#exec MESH SEQUENCE MESH=Pointer SEQ=Pointerstill             STARTFRAME=10 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Pointer MESH=Pointer
#exec MESHMAP SCALE MESHMAP=Pointer X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JPointer_01 FILE=Textures\Pointer_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=Pointer NUM=1 TEXTURE=JPointer_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.Pointer'
}
