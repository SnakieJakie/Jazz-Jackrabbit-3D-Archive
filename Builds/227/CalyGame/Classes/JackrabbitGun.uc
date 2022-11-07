//=============================================================================
// JackrabbitGun.
//=============================================================================
//
// Jazz Jackrabbit's signature weapon, whatever that may be.
//
class JackrabbitGun expands JazzWeapon;

function WeaponAnimationNormal()
{
	PlayAnim('WeaponAnim',1.0);
}

function AnimEnd()
{
	PlayAnim('Weaponidle',1.0);
}

function PlayIdleAnim()
{
	PlayAnim('Weaponidle',1.0);
}

defaultproperties
{
     MaxPowerLevel=1
     ExperienceNeeded(0)=100
     FireButtonDesc="Jazz Pulser"
     NormalWeaponCell=Class'CalyGame.JazzNormalCell'
     WeaponTypeNumber=1
     AIRating=1.000000
     bDisplayableInv=True
     PickupMessage="Jazz Pulser"
     PlayerViewOffset=(Y=-5.000000,Z=22.000000)
     PlayerViewMesh=Mesh'JazzObjectoids.JazzWeapon1'
     PickupViewMesh=Mesh'JazzObjectoids.JazzWeapon1'
     ThirdPersonMesh=Mesh'JazzObjectoids.JazzWeapon1'
     Icon=Texture'JazzArt.Interface.Gunnorm'
     AnimSequence=weaponidle
     Mesh=Mesh'JazzObjectoids.JazzWeapon1'
     bNoSmooth=False
     DesiredRotation=(Yaw=0)
}
