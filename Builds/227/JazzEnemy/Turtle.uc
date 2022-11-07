//=============================================================================
// Turtle.  Set Drawscale to 0.57
//=============================================================================
class Turtle expands Actor;

#exec MESH IMPORT MESH=Turtle ANIVFILE=MODELS\Turtle_a.3d DATAFILE=MODELS\Turtle_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Turtle X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Turtle SEQ=All                      STARTFRAME=0 NUMFRAMES=310
#exec MESH SEQUENCE MESH=Turtle SEQ=Turtlehide               STARTFRAME=0 NUMFRAMES=60
#exec MESH SEQUENCE MESH=Turtle SEQ=Turtlewalk               STARTFRAME=60 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Turtle SEQ=TurtleRun                STARTFRAME=89 NUMFRAMES=16
#exec MESH SEQUENCE MESH=Turtle SEQ=Turtleidle               STARTFRAME=105 NUMFRAMES=70
#exec MESH SEQUENCE MESH=Turtle SEQ=TurtleStill              STARTFRAME=175 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Turtle SEQ=Turtlehit                STARTFRAME=176 NUMFRAMES=38
#exec MESH SEQUENCE MESH=Turtle SEQ=TurtleUnhide             STARTFRAME=214 NUMFRAMES=96

#exec MESHMAP NEW   MESHMAP=Turtle MESH=Turtle
#exec MESHMAP SCALE MESHMAP=Turtle X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JTurtle_01 FILE=Textures\Turtle_01.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=JTurtle_02 FILE=Textures\Turtle_02.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=Turtle NUM=1 TEXTURE=JTurtle_01
#exec MESHMAP SETTEXTURE MESHMAP=Turtle NUM=2 TEXTURE=JTurtle_02

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=Turtle
}

