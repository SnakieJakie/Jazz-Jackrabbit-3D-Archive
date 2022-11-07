//=============================================================================
// Turtleexplode.
//=============================================================================
class Turtleexplode expands Actor;

#exec MESH IMPORT MESH=Turtleexplode ANIVFILE=MODELS\Turtleexplode_a.3d DATAFILE=MODELS\Turtleexplode_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Turtleexplode X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Turtleexplode SEQ=All                      STARTFRAME=0 NUMFRAMES=34
#exec MESH SEQUENCE MESH=Turtleexplode SEQ=Turtleexplode            STARTFRAME=0 NUMFRAMES=34

#exec MESHMAP NEW   MESHMAP=Turtleexplode MESH=Turtleexplode
#exec MESHMAP SCALE MESHMAP=Turtleexplode X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JTurtleexplode_01 FILE=Textures\Turtleexplode_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#exec MESHMAP SETTEXTURE MESHMAP=Turtleexplode NUM=1 TEXTURE=JTurtleexplode_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=Turtleexplode
}

