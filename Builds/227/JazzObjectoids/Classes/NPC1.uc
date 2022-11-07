//=============================================================================
// npc1.
//=============================================================================
class npc1 expands JazzMeshes;

#exec MESH IMPORT MESH=npc1 ANIVFILE=MODELS\npc1_a.3d DATAFILE=MODELS\npc1_d.3d X=0 Y=0 Z=0
#exec MESH LODPARAMS MESH=npc1 ZDisp=200
#exec MESH ORIGIN MESH=npc1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=npc1 SEQ=All                      STARTFRAME=0 NUMFRAMES=229
#exec MESH SEQUENCE MESH=npc1 SEQ=idle1                    STARTFRAME=0 NUMFRAMES=84
#exec MESH SEQUENCE MESH=npc1 SEQ=still                    STARTFRAME=84 NUMFRAMES=1
#exec MESH SEQUENCE MESH=npc1 SEQ=walk                     STARTFRAME=85 NUMFRAMES=30
#exec MESH SEQUENCE MESH=npc1 SEQ=starttalk                STARTFRAME=115 NUMFRAMES=30
#exec MESH SEQUENCE MESH=npc1 SEQ=talking                  STARTFRAME=145 NUMFRAMES=68
#exec MESH SEQUENCE MESH=npc1 SEQ=shotat                   STARTFRAME=213 NUMFRAMES=16

#exec MESHMAP NEW   MESHMAP=npc1 MESH=npc1
#exec MESHMAP SCALE MESHMAP=npc1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jnpc1_01 FILE=Textures\npc1_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=npc1 NUM=1 TEXTURE=Jnpc1_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.NPC1'
}
