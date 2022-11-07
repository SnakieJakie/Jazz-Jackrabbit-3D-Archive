//=============================================================================
// Jazz.
//=============================================================================
class Jazz expands JazzPlayer;


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

#exec MESHMAP SETTEXTURE MESHMAP=jazz NUM=0 TEXTURE=Jjazz_01
#exec MESHMAP SETTEXTURE MESHMAP=jazz NUM=1 TEXTURE=Jjazz_02

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
}

function PlayWalking()
{
		LoopAnim('JazzRun');
}

function PlayRunning()
{
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
	
function PlayInAir()
{
}

function PlayDuck()
{
}

function PlayCrawling()
{
}

function TweenToWaiting(float tweentime)
{
}
	
function PlayWaiting()
{
	LoopAnim('jazzrun');
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
     Mesh=jazz
     CollisionHeight=60.000000
     DrawType=DT_Mesh
}
