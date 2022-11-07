//=============================================================================
// TestJazzPlayer.
//=============================================================================
class TestJazzPlayer expands JazzPlayer;

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
     DashSpeed=800.000000
     MaxSwimmingJumpDuration=2.000000
     VoicePack=Class'CalyGame.VoiceJazzJackrabbit'
     EnergyDamage=1.000000
     FireDamage=1.000000
     WaterDamage=1.000000
     SoundDamage=1.000000
     SharpPhysicalDamage=1.000000
     BluntPhysicalDamage=1.000000
     Mesh=Mesh'Jazz3.Jazz'
     DrawScale=1.500000
     CollisionHeight=60.000000
}
