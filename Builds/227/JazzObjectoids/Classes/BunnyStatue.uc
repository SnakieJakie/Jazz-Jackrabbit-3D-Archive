//=============================================================================
// BunnyStatue.
//=============================================================================
class BunnyStatue expands JazzMeshes;

#exec MESH IMPORT MESH=BunnyStatue ANIVFILE=MODELS\BunnyStatue_a.3d DATAFILE=MODELS\BunnyStatue_d.3d X=0 Y=0 Z=0
#exec MESH LODPARAMS MESH=BunnyStatue STRENGTH=0.5
#exec MESH ORIGIN MESH=BunnyStatue X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=BunnyStatue SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=BunnyStatue SEQ=bunnystatue              STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=BunnyStatue MESH=BunnyStatue
#exec MESHMAP SCALE MESHMAP=BunnyStatue X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JBunnyStatue_01 FILE=Textures\BunnyStatue_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=BunnyStatue NUM=1 TEXTURE=JBunnyStatue_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.BunnyStatue'
}
