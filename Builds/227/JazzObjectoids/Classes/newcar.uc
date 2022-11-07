//=============================================================================
// newcar.
//=============================================================================
class newcar expands JazzMeshes;

#exec MESH IMPORT MESH=newcar ANIVFILE=MODELS\newcar_a.3d DATAFILE=MODELS\newcar_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=newcar X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=newcar SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=newcar SEQ=newcar                   STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=newcar MESH=newcar
#exec MESHMAP SCALE MESHMAP=newcar X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jnewcar_01 FILE=Textures\newcar_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=newcar NUM=1 TEXTURE=Jnewcar_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.newcar'
}
