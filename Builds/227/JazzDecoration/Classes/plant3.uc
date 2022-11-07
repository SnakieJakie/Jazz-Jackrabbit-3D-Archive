//=============================================================================
// plant3.
//=============================================================================
class plant3 expands JazzDecoration;

#exec MESH IMPORT MESH=plant3 ANIVFILE=MODELS\plant3_a.3d DATAFILE=MODELS\plant3_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=plant3 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=plant3 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=plant3 SEQ=plant3                   STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=plant3 MESH=plant3
#exec MESHMAP SCALE MESHMAP=plant3 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jplant3_01 FILE=Textures\plant3_01.PCX GROUP=Skins FLAGS=2	//twosided

#exec MESHMAP SETTEXTURE MESHMAP=plant3 NUM=0 TEXTURE=Jplant3_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jplant3_01'
     Mesh=Mesh'JazzDecoration.plant3'
}
