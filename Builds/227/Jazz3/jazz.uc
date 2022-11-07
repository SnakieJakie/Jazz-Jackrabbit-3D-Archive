//=============================================================================
// jazz.
//=============================================================================
class jazz expands human;

#exec MESH IMPORT MESH=jazz ANIVFILE=MODELS\jazz_a.3d DATAFILE=MODELS\jazz_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=jazz X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=jazz SEQ=All                      STARTFRAME=0 NUMFRAMES=168
#exec MESH SEQUENCE MESH=jazz SEQ=jazzidle1                STARTFRAME=0 NUMFRAMES=29
#exec MESH SEQUENCE MESH=jazz SEQ=jazzrunshooting          STARTFRAME=29 NUMFRAMES=19
#exec MESH SEQUENCE MESH=jazz SEQ=jazzrun                  STARTFRAME=48 NUMFRAMES=19
#exec MESH SEQUENCE MESH=jazz SEQ=jazzforwardjump          STARTFRAME=67 NUMFRAMES=17
#exec MESH SEQUENCE MESH=jazz SEQ=jazzfall                 STARTFRAME=84 NUMFRAMES=19
#exec MESH SEQUENCE MESH=jazz SEQ=jazzfallshooting         STARTFRAME=103 NUMFRAMES=19
#exec MESH SEQUENCE MESH=jazz SEQ=jazzledgegrab            STARTFRAME=122 NUMFRAMES=10
#exec MESH SEQUENCE MESH=jazz SEQ=jazzledgehang            STARTFRAME=132 NUMFRAMES=1
#exec MESH SEQUENCE MESH=jazz SEQ=jazzledgepullup          STARTFRAME=133 NUMFRAMES=35

#exec MESHMAP NEW   MESHMAP=jazz MESH=jazz
#exec MESHMAP SCALE MESHMAP=jazz X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jjazz_01 FILE=Textures\jazz_01.PCX GROUP=Skins FLAGS=2	//twosided
#exec TEXTURE IMPORT NAME=Jjazz_02 FILE=Textures\jazz_02.PCX GROUP=Skins FLAGS=2	//weapon

#exec MESHMAP SETTEXTURE MESHMAP=jazz NUM=1 TEXTURE=Jjazz_01
#exec MESHMAP SETTEXTURE MESHMAP=jazz NUM=2 TEXTURE=Jjazz_02

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=jazz
}

