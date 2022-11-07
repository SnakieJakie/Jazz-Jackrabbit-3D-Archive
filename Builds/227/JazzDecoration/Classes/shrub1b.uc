//=============================================================================
// shrub1b.
//=============================================================================
class shrub1b expands jazzdecoration;

#exec MESH IMPORT MESH=shrub1b ANIVFILE=MODELS\shrub1b_a.3d DATAFILE=MODELS\shrub1b_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=shrub1b X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=shrub1b SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=shrub1b SEQ=shrub1b                  STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=shrub1b MESH=shrub1b
#exec MESHMAP SCALE MESHMAP=shrub1b X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jshrub1a_01 FILE=Textures\shrub1a_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=shrub1b NUM=0 TEXTURE=Jshrub1a_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jshrub1a_01'
     Mesh=Mesh'JazzDecoration.shrub1b'
}
