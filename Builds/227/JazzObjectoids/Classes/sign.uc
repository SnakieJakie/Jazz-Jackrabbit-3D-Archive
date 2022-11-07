//=============================================================================
// sign.
//=============================================================================
class sign expands JazzMeshes;

#exec MESH IMPORT MESH=sign ANIVFILE=MODELS\sign_a.3d DATAFILE=MODELS\sign_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=sign X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=sign SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=sign SEQ=sign                     STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=sign MESH=sign
#exec MESHMAP SCALE MESHMAP=sign X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jsign_01 FILE=Textures\sign_01.PCX GROUP=Skins FLAGS=2	//skin

#exec MESHMAP SETTEXTURE MESHMAP=sign NUM=0 TEXTURE=Jsign_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.sign'
}
