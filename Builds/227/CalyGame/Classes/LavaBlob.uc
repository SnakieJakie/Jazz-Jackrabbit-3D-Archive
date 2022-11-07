//=============================================================================
// LavaBlob.
//=============================================================================
class LavaBlob expands BasicBlob;

defaultproperties
{
     TriggerHappy=INT_Pacifist
     WaitStyle=WAT_Motionless
     ProjAttack=True
     ProjAttackType(0)=Class'CalyGame.JazzFire'
     ProjAttackDesire(0)=10
     FindFriendDesire=5
     WanderDesire=10
     WaitingDesire=2
     ScoreForDefeating=150
     JumpOnDamage=0
     JumpOnTakeDamage=False
     JumperDamage=10
     JumperTakeDamage=True
     JumpedOnEffect=None
     ToucherDamage=15
     DropItemDead=Class'CalyGame.JazzItemLevel1'
     bFreezeable=False
     bPetrify=False
     Skin=Texture'JazzArt.Effects.NLava4'
     AmbientGlow=200
     LightType=LT_Steady
     LightBrightness=255
     LightRadius=15
}
