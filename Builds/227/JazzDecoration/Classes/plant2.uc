//=============================================================================
// plant2.
//=============================================================================
class plant2 expands JazzDecoration;

#exec MESH IMPORT MESH=plant2 ANIVFILE=MODELS\plant2_a.3d DATAFILE=MODELS\plant2_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=plant2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=plant2 SEQ=All                      STARTFRAME=0 NUMFRAMES=2
#exec MESH SEQUENCE MESH=plant2 SEQ=plant2                   STARTFRAME=0 NUMFRAMES=2

#exec MESHMAP NEW   MESHMAP=plant2 MESH=plant2
#exec MESHMAP SCALE MESHMAP=plant2 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jplant2_01 FILE=Textures\plant2_01.PCX GROUP=Skins FLAGS=2	//twosided

#exec MESHMAP SETTEXTURE MESHMAP=plant2 NUM=0 TEXTURE=Jplant2_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jplant2_01'
     Mesh=Mesh'JazzDecoration.plant2'
}
