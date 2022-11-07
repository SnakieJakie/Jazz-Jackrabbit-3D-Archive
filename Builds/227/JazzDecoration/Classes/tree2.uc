//=============================================================================
// tree2.
//=============================================================================
class tree2 expands jazzdecoration;

#exec MESH IMPORT MESH=tree2 ANIVFILE=MODELS\tree2_a.3d DATAFILE=MODELS\tree2_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=tree2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=tree2 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=tree2 SEQ=tree2                    STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=tree2 MESH=tree2
#exec MESHMAP SCALE MESHMAP=tree2 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jtree2_01 FILE=Textures\tree2_01.PCX GROUP=Skins FLAGS=2	//twosided

#exec MESHMAP SETTEXTURE MESHMAP=tree2 NUM=0 TEXTURE=Jtree2_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jtree2_01'
     Mesh=Mesh'JazzDecoration.tree2'
}
