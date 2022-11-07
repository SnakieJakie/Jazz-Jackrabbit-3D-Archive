//=============================================================================
// BasicBlob.
//=============================================================================
class BasicBlob expands JazzPawnAI;


/////////////////////////////////////////////////////////////////////////////////////
// 																	ANIMATIONS
/////////////////////////////////////////////////////////////////////////////////////
//
// Waiting animation
//
function PlayWaiting()
{
	LoopAnim('Glob1',0.2);
}

// Slow walk Animation
//
function PlaySlowWalk()
{
	LoopAnim('Glob2',0.3);
}

// Normal walk Animation
function PlayWalking()
{
	LoopAnim('Glob3',0.5);
}

defaultproperties
{
     TriggerHappy=INT_Moderate
     WaitStyle=WAT_LoneWanderer
     WarnFriendsWhenFirstAttacking=True
     WalkingSpeed=300.000000
     RushSpeed=400.000000
     WanderDesire=3
     WanderRange=10.000000
     WaitingDesire=5
     GreedOverrideHostility=0.000000
     ScoreForDefeating=100
     DeathEffect=Class'CalyGame.JazzParticles'
     JumpOnDamage=100
     JumpOnTakeDamage=True
     JumpedOnEffect=Class'UnrealShare.RingExplosion'
     JumpedOnEffectPitch=16384.000000
     ToucherDamage=5
     ToucherTakeDamage=True
     EnergyDamage=2.000000
     FireDamage=5.000000
     WaterDamage=1.500000
     SoundDamage=0.500000
     BluntPhysicalDamage=0.500000
     SoundAnimation=True
     bFreezeable=True
     bPetrify=True
     VoicePack=None
     AccelRate=150.000000
     SightRadius=1000.000000
     PeripheralVision=-10.000000
     bForceStasis=True
     DrawType=DT_Mesh
     Mesh=Mesh'UnrealI.MiniBlob'
     DrawScale=3.000000
     CollisionRadius=66.000000
     CollisionHeight=60.000000
     RotationRate=(Pitch=3000,Yaw=3000,Roll=3000)
}
