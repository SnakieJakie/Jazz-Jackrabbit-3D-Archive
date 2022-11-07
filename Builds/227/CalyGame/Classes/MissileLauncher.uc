//=============================================================================
// MissileLauncher.
//=============================================================================
class MissileLauncher expands JazzWeapon;

function WeaponAnimationNormal()
{
	PlayAnim('WeaponAnim',1.0);
}

defaultproperties
{
     NormalWeaponCell=Class'CalyGame.JazzNormalCell'
     WeaponTypeNumber=2
     PlayerViewMesh=Mesh'JazzObjectoids.Jazzweapon2'
     PickupViewMesh=Mesh'JazzObjectoids.Jazzweapon2'
     ThirdPersonMesh=Mesh'JazzObjectoids.Jazzweapon2'
     Icon=Texture'JazzArt.Interface.GunGizmo'
     Texture=Texture'JazzObjectoids.Skins.Jpumptip_01'
     Mesh=Mesh'JazzObjectoids.Jazzweapon2'
     LightType=LT_SubtlePulse
     LightBrightness=102
     LightRadius=4
}
