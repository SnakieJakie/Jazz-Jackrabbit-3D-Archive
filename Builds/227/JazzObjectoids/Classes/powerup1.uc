//=============================================================================
// powerup1.
//=============================================================================
class powerup1 expands JazzMeshes;

#exec MESH IMPORT MESH=powerup1 ANIVFILE=MODELS\powerup1_a.3d DATAFILE=MODELS\powerup1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=powerup1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=powerup1 SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=powerup1 SEQ=powerup1                 STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=powerup1 MESH=powerup1
#exec MESHMAP SCALE MESHMAP=powerup1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jpowerup1_01 FILE=Textures\powerup1_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=powerup1 NUM=1 TEXTURE=Jpowerup1_01

defaultproperties
{
     Mesh=Mesh'JazzObjectoids.powerup1'
}
