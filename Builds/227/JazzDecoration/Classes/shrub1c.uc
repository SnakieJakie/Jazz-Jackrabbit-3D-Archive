//=============================================================================
// shrub1c.
//=============================================================================
class shrub1c expands jazzdecoration;

#exec MESH IMPORT MESH=shrub1c ANIVFILE=MODELS\shrub1c_a.3d DATAFILE=MODELS\shrub1c_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=shrub1c X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=shrub1c SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=shrub1c SEQ=shrub1c                  STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=shrub1c MESH=shrub1c
#exec MESHMAP SCALE MESHMAP=shrub1c X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jshrub1a_01 FILE=Textures\shrub1a_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=shrub1c NUM=0 TEXTURE=Jshrub1a_01

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jshrub1a_01'
     Mesh=Mesh'JazzDecoration.shrub1c'
}
