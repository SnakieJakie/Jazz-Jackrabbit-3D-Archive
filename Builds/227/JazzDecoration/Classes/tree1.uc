//=============================================================================
// tree1.
//=============================================================================
class tree1 expands jazzdecoration;

#exec MESH IMPORT MESH=tree1 ANIVFILE=MODELS\tree1_a.3d DATAFILE=MODELS\tree1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=tree1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=tree1 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=tree1 SEQ=tree1                    STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=tree1 MESH=tree1
#exec MESHMAP SCALE MESHMAP=tree1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jtree1_01 FILE=Textures\tree1_01.PCX GROUP=Skins FLAGS=2	//twosided

#exec MESHMAP SETTEXTURE MESHMAP=tree1 NUM=1 TEXTURE=Jtree1_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jtree1_01'
     Mesh=Mesh'JazzDecoration.tree1'
}
