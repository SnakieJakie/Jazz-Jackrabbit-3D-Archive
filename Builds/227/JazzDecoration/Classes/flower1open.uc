//=============================================================================
// flower1open.
//=============================================================================
class flower1open expands JazzDecoration;

#exec MESH IMPORT MESH=flower1open ANIVFILE=MODELS\flower1open_a.3d DATAFILE=MODELS\flower1open_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=flower1open X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=flower1open SEQ=All                      STARTFRAME=0 NUMFRAMES=40
#exec MESH SEQUENCE MESH=flower1open SEQ=flower1open              STARTFRAME=0 NUMFRAMES=40

#exec MESHMAP NEW   MESHMAP=flower1open MESH=flower1open
#exec MESHMAP SCALE MESHMAP=flower1open X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jflower1a_01 FILE=Textures\flower1a_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=flower1open NUM=0 TEXTURE=Jflower1a_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jflower1a_01'
     Mesh=Mesh'JazzDecoration.flower1open'
}
