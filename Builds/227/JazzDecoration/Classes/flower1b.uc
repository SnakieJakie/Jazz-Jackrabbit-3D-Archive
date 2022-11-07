//=============================================================================
// flower1b.
//=============================================================================
class flower1b expands JazzDecoration;

#exec MESH IMPORT MESH=flower1b ANIVFILE=MODELS\flower1b_a.3d DATAFILE=MODELS\flower1b_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=flower1b X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=flower1b SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=flower1b SEQ=flower1b                 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=flower1b MESH=flower1b
#exec MESHMAP SCALE MESHMAP=flower1b X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jflower1a_01 FILE=Textures\flower1a_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=flower1b NUM=0 TEXTURE=Jflower1a_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jflower1a_01'
     Mesh=Mesh'JazzDecoration.flower1b'
}
