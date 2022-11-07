//=============================================================================
// plant1.
//=============================================================================
class plant1 expands JazzDecoration;

#exec MESH IMPORT MESH=plant1 ANIVFILE=MODELS\plant1_a.3d DATAFILE=MODELS\plant1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=plant1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=plant1 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=plant1 SEQ=plant1                   STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=plant1 MESH=plant1
#exec MESHMAP SCALE MESHMAP=plant1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jplant1_01 FILE=Textures\plant1_01.PCX GROUP=Skins FLAGS=2	//twosided

#exec MESHMAP SETTEXTURE MESHMAP=plant1 NUM=0 TEXTURE=Jplant1_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jplant1_01'
     Mesh=Mesh'JazzDecoration.plant1'
}
