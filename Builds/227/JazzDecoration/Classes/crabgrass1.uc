//=============================================================================
// crabgrass1.
//=============================================================================
class crabgrass1 expands JazzDecoration;

#exec MESH IMPORT MESH=crabgrass1 ANIVFILE=MODELS\crabgrass1_a.3d DATAFILE=MODELS\crabgrass1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=crabgrass1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=crabgrass1 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=crabgrass1 SEQ=crabgrass1               STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=crabgrass1 MESH=crabgrass1
#exec MESHMAP SCALE MESHMAP=crabgrass1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jcrabgrass1_01 FILE=Textures\crabgrass1_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=crabgrass1 NUM=0 TEXTURE=Jcrabgrass1_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jcrabgrass1_01'
     Mesh=Mesh'JazzDecoration.crabgrass1'
}
