//=============================================================================
// Jazzplayer.
//=============================================================================
class Jazzplayer expands Actor;

#exec MESH IMPORT MESH=Jazzplayer ANIVFILE=MODELS\Jazzplayer_a.3d DATAFILE=MODELS\Jazzplayer_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Jazzplayer X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Jazzplayer SEQ=All                      STARTFRAME=0 NUMFRAMES=355
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=runbackshoot             STARTFRAME=0 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=runbacknoshoot           STARTFRAME=19 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=runleftshoot             STARTFRAME=38 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=runrightshoot            STARTFRAME=57 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=runrightnoshoot          STARTFRAME=76 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=runleftnoshoot           STARTFRAME=95 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzledgepullup          STARTFRAME=114 NUMFRAMES=35
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzfallshooting         STARTFRAME=149 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzforwardjump          STARTFRAME=168 NUMFRAMES=17
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzidle1                STARTFRAME=185 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzledgegrab            STARTFRAME=214 NUMFRAMES=10
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzledgehang            STARTFRAME=224 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzfall                 STARTFRAME=225 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzrun                  STARTFRAME=244 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzrunshooting          STARTFRAME=263 NUMFRAMES=19
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzstill                STARTFRAME=282 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzswimforward          STARTFRAME=283 NUMFRAMES=39
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzidle1shoot           STARTFRAME=322 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Jazzplayer SEQ=jazzstillshoot           STARTFRAME=351 NUMFRAMES=4

#exec MESHMAP NEW   MESHMAP=Jazzplayer MESH=Jazzplayer
#exec MESHMAP SCALE MESHMAP=Jazzplayer X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JJazzplayer_01 FILE=Textures\Jazzplayer_01.PCX GROUP=Skins FLAGS=2	//twosided
#exec TEXTURE IMPORT NAME=JJazzplayer_02 FILE=Textures\Jazzplayer_02.PCX GROUP=Skins FLAGS=2	//weapon

#exec MESHMAP SETTEXTURE MESHMAP=Jazzplayer NUM=1 TEXTURE=JJazzplayer_01
#exec MESHMAP SETTEXTURE MESHMAP=Jazzplayer NUM=2 TEXTURE=JJazzplayer_02

defaultproperties
{
	DrawType=DT_Mesh
	Mesh=Jazzplayer
}

