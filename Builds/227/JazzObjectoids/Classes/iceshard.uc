//=============================================================================
// iceshard.
//=============================================================================
class iceshard expands JazzMeshes;

#exec MESH IMPORT MESH=iceshard ANIVFILE=MODELS\iceshard_a.3d DATAFILE=MODELS\iceshard_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=iceshard X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=iceshard SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=iceshard SEQ=iceshard                 STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=iceshard MESH=iceshard
#exec MESHMAP SCALE MESHMAP=iceshard X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jicebomb_01 FILE=Textures\icebomb_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=iceshard NUM=1 TEXTURE=Jicebomb_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.iceshard'
}
