//=============================================================================
// minecart.
//=============================================================================
class minecart expands JazzMeshes;

#exec MESH IMPORT MESH=minecart ANIVFILE=MODELS\minecart_a.3d DATAFILE=MODELS\minecart_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=minecart X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=minecart SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=minecart SEQ=minecart                 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=minecart MESH=minecart
#exec MESHMAP SCALE MESHMAP=minecart X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jminecart_01 FILE=Textures\minecart_01.PCX GROUP=Skins FLAGS=2	//skin

#exec MESHMAP SETTEXTURE MESHMAP=minecart NUM=0 TEXTURE=Jminecart_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzObjectoids.Skins.Jminecart_01'
     Mesh=Mesh'JazzObjectoids.minecart'
}
