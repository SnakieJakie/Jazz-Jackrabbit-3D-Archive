//=============================================================================
// JazzJazzThinker.
//=============================================================================
class JazzJazzThinker expands JazzThinker;


////////////////////////////////////////////////////////////////////////////////////
//
// Jazz Jackrabbit Bot
//


////////////////////////////////////////////////////////////////////////////////////
// Animations
//

function PlaySlowWalk()
{
}

function PlayWarnFriends()
{
}

function PlayRunning()
{
	LoopAnim('jazzrun');
}

function PlayWalking()
{
}

function PlayWaiting()
{
}

function PlayStationaryFiring()
{
}

defaultproperties
{
     Intelligence=INT_Tactful
     WaitStyle=WAT_LoneWanderer
     CombatStyle=COM_Rusher
     ProjAttackType(0)=Class'CalyGame.JazzNormal2'
     ProjAttackType(1)=Class'CalyGame.JazzFire'
     ProjAttackType(2)=Class'CalyGame.JazzArrowLightning'
     ProjAttackDesire(0)=10
     ProjAttackDesire(1)=5
     ProjAttackDesire(2)=3
     WalkingSpeed=325.000000
     FindFriendDesire=0
     WaitingDesire=0
     GoHidePointDesire=5
     GoAmbushPointDesire=5
     CanUseWeapons=True
     FatnessReversed=True
     DeathEffect=Class'CalyGame.ParticleExplosion'
     bBurnable=True
     GroundSpeed=400.000000
     AirSpeed=400.000000
     AccelRate=2048.000000
     AnimSequence=jazzidle1
     Texture=Texture'Jazz3.Jjazz_01'
     Mesh=Mesh'Jazz3.Jazz'
     DrawScale=1.000000
     CollisionRadius=20.000000
     CollisionHeight=40.000000
     Buoyancy=0.016000
     RotationRate=(Pitch=3072,Yaw=30000,Roll=2048)
}
