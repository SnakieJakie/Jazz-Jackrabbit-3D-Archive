//=============================================================================
// flower1a.
//=============================================================================
class flower1a expands JazzDecoration;

#exec MESH IMPORT MESH=flower1a ANIVFILE=MODELS\flower1a_a.3d DATAFILE=MODELS\flower1a_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=flower1a X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=flower1a SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=flower1a SEQ=flower1a                 STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=flower1a MESH=flower1a
#exec MESHMAP SCALE MESHMAP=flower1a X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jflower1a_01 FILE=Textures\flower1a_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=flower1a NUM=0 TEXTURE=Jflower1a_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jflower1a_01'
     Mesh=Mesh'JazzDecoration.flower1a'
}
