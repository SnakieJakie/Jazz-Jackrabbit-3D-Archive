//=============================================================================
// Turtle.  Set DrawScale to 0.57 
//=============================================================================
class Turtle expands Actor;

#exec MESH IMPORT MESH=Turtle ANIVFILE=MODELS\Turtle_a.3d DATAFILE=MODELS\Turtle_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Turtle X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Turtle SEQ=All                      STARTFRAME=0 NUMFRAMES=188
#exec MESH SEQUENCE MESH=Turtle SEQ=Turtlehide               STARTFRAME=0 NUMFRAMES=60
#exec MESH SEQUENCE MESH=Turtle SEQ=Turtlewalk               STARTFRAME=60 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Turtle SEQ=TurtleRunslow            STARTFRAME=89 NUMFRAMES=16
#exec MESH SEQUENCE MESH=Turtle SEQ=TurtleRunfast            STARTFRAME=105 NUMFRAMES=12
#exec MESH SEQUENCE MESH=Turtle SEQ=Turtleidle               STARTFRAME=117 NUMFRAMES=70
#exec MESH SEQUENCE MESH=Turtle SEQ=TurtleStill              STARTFRAME=187 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=Turtle MESH=Turtle
#exec MESHMAP SCALE MESHMAP=Turtle X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JTurtle_01 FILE=Textures\Turtle_01.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=JTurtle_02 FILE=Textures\Turtle_02.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=Turtle NUM=0 TEXTURE=JTurtle_01

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=Turtle
}

