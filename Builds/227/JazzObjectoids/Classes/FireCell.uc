//=============================================================================
// FireCell.
//=============================================================================
class FireCell expands JazzMeshes;

#exec MESH IMPORT MESH=FireCell ANIVFILE=MODELS\FireCell_a.3d DATAFILE=MODELS\FireCell_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=FireCell X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=FireCell SEQ=All                      STARTFRAME=0 NUMFRAMES=25
#exec MESH SEQUENCE MESH=FireCell SEQ=FireCell                 STARTFRAME=0 NUMFRAMES=25

#exec MESHMAP NEW   MESHMAP=FireCell MESH=FireCell
#exec MESHMAP SCALE MESHMAP=FireCell X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JFireCell_01 FILE=Textures\FireCell_01.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=JFireCell_02 FILE=Textures\FireCell_02.PCX GROUP=Skins FLAGS=2	//Translucent

#exec MESHMAP SETTEXTURE MESHMAP=FireCell NUM=1 TEXTURE=JFireCell_01
#exec MESHMAP SETTEXTURE MESHMAP=FireCell NUM=2 TEXTURE=JFireCell_02

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.FireCell'
}
