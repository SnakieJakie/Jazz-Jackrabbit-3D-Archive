//=============================================================================
// lightbulb.
//=============================================================================
class lightbulb expands JazzDecoration;

#exec MESH IMPORT MESH=lightbulb ANIVFILE=MODELS\lightbulb_a.3d DATAFILE=MODELS\lightbulb_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=lightbulb X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=lightbulb SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=lightbulb SEQ=lightbulb                STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=lightbulb MESH=lightbulb
#exec MESHMAP SCALE MESHMAP=lightbulb X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jlightbulb_01 FILE=Textures\lightbulb_01.PCX GROUP=Skins FLAGS=2	//skin

#exec MESHMAP SETTEXTURE MESHMAP=lightbulb NUM=0 TEXTURE=Jlightbulb_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzDecoration.lightbulb'
}
