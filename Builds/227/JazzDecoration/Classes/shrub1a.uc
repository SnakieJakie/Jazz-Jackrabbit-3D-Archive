//=============================================================================
// shrub1a.
//=============================================================================
class shrub1a expands jazzdecoration;

#exec MESH IMPORT MESH=shrub1a ANIVFILE=MODELS\shrub1a_a.3d DATAFILE=MODELS\shrub1a_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=shrub1a X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=shrub1a SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=shrub1a SEQ=shrub1a                  STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=shrub1a MESH=shrub1a
#exec MESHMAP SCALE MESHMAP=shrub1a X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jshrub1a_01 FILE=Textures\shrub1a_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=shrub1a NUM=1 TEXTURE=Jshrub1a_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jshrub1a_01'
     Mesh=Mesh'JazzDecoration.shrub1a'
}
