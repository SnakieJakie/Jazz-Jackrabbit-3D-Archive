//=============================================================================
// jazz.
//=============================================================================
class jazz expands JazzPlayer;

#exec MESH IMPORT MESH=jazz ANIVFILE=MODELS\jazz_a.3d DATAFILE=MODELS\jazz_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=jazz X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Jazz SEQ=All                      STARTFRAME=0 NUMFRAMES=355
#exec MESH SEQUENCE MESH=Jazz SEQ=runbackshoot             STARTFRAME=0 NUMFRAMES=19	GROUP=Running
#exec MESH SEQUENCE MESH=Jazz SEQ=runbacknoshoot           STARTFRAME=19 NUMFRAMES=19	GROUP=Running
#exec MESH SEQUENCE MESH=Jazz SEQ=runleftshoot             STARTFRAME=38 NUMFRAMES=19	GROUP=Running
#exec MESH SEQUENCE MESH=Jazz SEQ=runrightshoot            STARTFRAME=57 NUMFRAMES=19	GROUP=Running
#exec MESH SEQUENCE MESH=Jazz SEQ=runrightnoshoot          STARTFRAME=76 NUMFRAMES=19	GROUP=Running
#exec MESH SEQUENCE MESH=Jazz SEQ=runleftnoshoot           STARTFRAME=95 NUMFRAMES=19	GROUP=Running
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzledgepullup          STARTFRAME=114 NUMFRAMES=35	GROUP=Ledge
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzfallshooting         STARTFRAME=149 NUMFRAMES=19	GROUP=Falling
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzforwardjump          STARTFRAME=168 NUMFRAMES=17	GROUP=Falling
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzidle1                STARTFRAME=185 NUMFRAMES=29	GROUP=Waiting
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzledgegrab            STARTFRAME=214 NUMFRAMES=10	GROUP=Ledge
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzledgehang            STARTFRAME=224 NUMFRAMES=1	GROUP=Ledge
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzfall                 STARTFRAME=225 NUMFRAMES=19	GROUP=Falling
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzrun                  STARTFRAME=244 NUMFRAMES=19	GROUP=Running
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzrunshooting          STARTFRAME=263 NUMFRAMES=19	GROUP=Running
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzstill                STARTFRAME=282 NUMFRAMES=1	GROUP=Waiting
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzswimforward          STARTFRAME=283 NUMFRAMES=39	GROUP=Swimming
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzidle1shoot           STARTFRAME=322 NUMFRAMES=29	GROUP=Waiting
#exec MESH SEQUENCE MESH=Jazz SEQ=jazzstillshoot           STARTFRAME=351 NUMFRAMES=4	GROUP=Waiting

#exec MESHMAP NEW   MESHMAP=jazz MESH=jazz
#exec MESHMAP SCALE MESHMAP=jazz X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jjazz_01       FILE=Textures\jazz_01.PCX        FLAGS=2	//twosided
#exec TEXTURE IMPORT NAME=Jjazz_02       FILE=Textures\jazz_02.PCX        FLAGS=2	//weapon
#exec TEXTURE IMPORT NAME=jazz_blue_bb 	 FILE=Textures\jazz_blue_bb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_blue_gb 	 FILE=Textures\jazz_blue_gb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_blue_pb 	 FILE=Textures\jazz_blue_pb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_blue_rb 	 FILE=Textures\jazz_blue_rb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_blue_yb 	 FILE=Textures\jazz_blue_yb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_bb  FILE=Textures\jazz_green_bb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_gb  FILE=Textures\jazz_green_gb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_pb  FILE=Textures\jazz_green_pb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_rb  FILE=Textures\jazz_green_rb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_yb  FILE=Textures\jazz_green_yb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_bb 	 FILE=Textures\jazz_grey_bb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_gb 	 FILE=Textures\jazz_grey_gb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_pb 	 FILE=Textures\jazz_grey_pb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_rb 	 FILE=Textures\jazz_grey_rb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_yb 	 FILE=Textures\jazz_grey_yb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_bb FILE=Textures\jazz_purple_bb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_gb FILE=Textures\jazz_purple_gb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_pb FILE=Textures\jazz_purple_pb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_rb FILE=Textures\jazz_purple_rb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_yb FILE=Textures\jazz_purple_yb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_bb 	 FILE=Textures\jazz_red_bb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_gb 	 FILE=Textures\jazz_red_gb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_pb 	 FILE=Textures\jazz_red_pb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_rb 	 FILE=Textures\jazz_red_rb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_yb 	 FILE=Textures\jazz_red_yb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_bb 	 FILE=Textures\jazz_teal_bb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_gb 	 FILE=Textures\jazz_teal_gb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_pb 	 FILE=Textures\jazz_teal_pb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_rb 	 FILE=Textures\jazz_teal_rb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_yb 	 FILE=Textures\jazz_teal_yb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_bb FILE=Textures\jazz_yellow_bb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_gb FILE=Textures\jazz_yellow_gb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_pb FILE=Textures\jazz_yellow_pb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_rb FILE=Textures\jazz_yellow_rb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_yb FILE=Textures\jazz_yellow_yb.pcx FLAGS=2


#exec MESHMAP SETTEXTURE MESHMAP=jazz NUM=0 TEXTURE=Jjazz_01
#exec MESHMAP SETTEXTURE MESHMAP=jazz NUM=2 TEXTURE=Jjazz_02

//
// Defines the animation and any overridden motion systems Jazz needs.
//
//

//-----------------------------------------------------------------------------
// Animation functions

function PlayTurning()
{
}

function TweenToWalking(float tweentime)
{
}

function TweenToRunning(float tweentime)
{
	TweenAnim('JazzRun',tweentime);
}

function PlayWalking()
{
	LoopAnim('JazzRun');
}

function PlayRunning()
{
	LoopAnim('JazzRun');
}

function PlayRising()
{
}

function PlayFeignDeath()
{
}

function PlayDying(name DamageType, vector HitLoc)
{
}

function PlayGutHit(float tweentime)
{
}

function PlayHeadHit(float tweentime)
{
}

function PlayLeftHit(float tweentime)
{
}

function PlayRightHit(float tweentime)
{
}
	
function PlayLanded(float impactVel)
{	
}
	
function PlayFlyingUp()
{
	LoopAnim('JazzFall');
}

function PlayFallingDown()
{
	LoopAnim('JazzFall');
}

function PlayDuck()
{
}

function PlayCrawling()
{
}

function TweenToWaiting(float tweentime)
{
	TweenAnim('JazzIdle1',tweentime);
}
	
function PlayWaiting()
{
	if (AnimSequence != 'JazzIdle1')
	LoopAnim('JazzIdle1');
}	

function PlayFiring()
{
}

function PlayWeaponSwitch(Weapon NewWeapon)
{
}

function PlaySwimming()
{
}

function TweenToSwimming(float tweentime)
{
}

defaultproperties
{
     HealthMaximum=100
     VoicePack=Class'CalyGame.VoiceJazzJackrabbit'
     EnergyDamage=1.000000
     FireDamage=1.000000
     WaterDamage=1.000000
     SoundDamage=1.000000
     SharpPhysicalDamage=1.000000
     BluntPhysicalDamage=1.000000
     JumpZ=700.000000
     BaseEyeHeight=-20.000000
     AnimSequence=jazzidle1
     AnimRate=0.200000
     DrawType=DT_Mesh
     Texture=Texture'Jazz3.Skins.Jjazz_01'
     Mesh=Mesh'Jazz3.Jazz'
     CollisionRadius=20.000000
     CollisionHeight=40.000000
}
