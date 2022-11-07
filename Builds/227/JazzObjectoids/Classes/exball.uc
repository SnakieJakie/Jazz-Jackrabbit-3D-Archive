//=============================================================================
// exball.
//=============================================================================
class exball expands Actor;

#exec MESH IMPORT MESH=exball ANIVFILE=MODELS\exball_a.3d DATAFILE=MODELS\exball_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=exball X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=exball SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#exec MESH SEQUENCE MESH=exball SEQ=exball                   STARTFRAME=0 NUMFRAMES=100

#exec MESHMAP NEW   MESHMAP=exball MESH=exball
#exec MESHMAP SCALE MESHMAP=exball X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jexball_01 FILE=Textures\exball_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=exball NUM=1 TEXTURE=Jexball_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=exball
}

