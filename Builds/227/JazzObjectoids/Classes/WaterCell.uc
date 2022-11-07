//=============================================================================
// WaterCell.
//=============================================================================
class WaterCell expands JazzMeshes;

#exec MESH IMPORT MESH=WaterCell ANIVFILE=MODELS\WaterCell_a.3d DATAFILE=MODELS\WaterCell_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=WaterCell X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=WaterCell SEQ=All                      STARTFRAME=0 NUMFRAMES=44
#exec MESH SEQUENCE MESH=WaterCell SEQ=WaterCell                STARTFRAME=0 NUMFRAMES=44

#exec MESHMAP NEW   MESHMAP=WaterCell MESH=WaterCell
#exec MESHMAP SCALE MESHMAP=WaterCell X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JWaterCell_01 FILE=Textures\WaterCell_01.PCX GROUP=Skins FLAGS=2	//SKIN

#exec MESHMAP SETTEXTURE MESHMAP=WaterCell NUM=0 TEXTURE=JWaterCell_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.WaterCell'
}
