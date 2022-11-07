//=============================================================================
// Bfly3.
//=============================================================================
class Bfly3 expands JazzMeshes;

#exec MESH IMPORT MESH=Bfly3 ANIVFILE=MODELS\Bfly3_a.3d DATAFILE=MODELS\Bfly3_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Bfly3 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Bfly3 SEQ=All                      STARTFRAME=0 NUMFRAMES=147
#exec MESH SEQUENCE MESH=Bfly3 SEQ=Bfly3fly                 STARTFRAME=0 NUMFRAMES=66
#exec MESH SEQUENCE MESH=Bfly3 SEQ=Bfly3idle                STARTFRAME=66 NUMFRAMES=80
#exec MESH SEQUENCE MESH=Bfly3 SEQ=Bfly3still               STARTFRAME=146 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Bfly3 MESH=Bfly3
#exec MESHMAP SCALE MESHMAP=Bfly3 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JBfly3_01 FILE=Textures\Bfly3_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=Bfly3 NUM=1 TEXTURE=JBfly3_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=Bfly3
}

