//=============================================================================
// IceCell.
//=============================================================================
class IceCell expands JazzMeshes;

#exec MESH IMPORT MESH=IceCell ANIVFILE=MODELS\IceCell_a.3d DATAFILE=MODELS\IceCell_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=IceCell X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=IceCell SEQ=All                      STARTFRAME=0 NUMFRAMES=60
#exec MESH SEQUENCE MESH=IceCell SEQ=IceCell                  STARTFRAME=0 NUMFRAMES=60

#exec MESHMAP NEW   MESHMAP=IceCell MESH=IceCell
#exec MESHMAP SCALE MESHMAP=IceCell X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JIceCell_01 FILE=Textures\IceCell_01.PCX GROUP=Skins FLAGS=2	//SKIN

#exec MESHMAP SETTEXTURE MESHMAP=IceCell NUM=0 TEXTURE=JIceCell_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.IceCell'
}
