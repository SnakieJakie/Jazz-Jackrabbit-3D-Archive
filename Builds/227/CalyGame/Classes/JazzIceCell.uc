//=============================================================================
// JazzIceCell.
//=============================================================================
class JazzIceCell expands JazzWeaponCell;

///////////////////////////////////////////////////////////////////////////////////////
// Normal Fire : Weapon JackrabbitGun									FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state FireStateJazz			// Jazz Jackrabbit's Weapon
{
	// Perform actual firing here
	Begin:

	switch (CurrentPowerLevel)
	{
	
	//////////////////////////
	// Ice Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 0;
		ProjectileFire(class'JazzIce', 800, true);
		AnimateWeapon(0);
	
		MainFireDelay(0.5);
		//Sleep(0.5);
	break;
	}
	
	CheckContinueFire();	// Check if fire held down
}

///////////////////////////////////////////////////////////////////////////////////////
// Alt Fire : Weapon JackrabbitGun										ALTFIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state AltFireStateJazz			// Jazz Jackrabbit's Weapon
{
	// Perform actual firing here
	Begin:

	switch (CurrentPowerLevel)
	{
	
	//////////////////////////
	// Ice Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 0;
		ProjectileFire(class'JazzIceGrenade', 800, true);
		AnimateWeapon(0);
	
		AltFireDelay(2);
		//Sleep(0.5);
	break;
	}
	
	CheckContinueFire();	// Check if fire held down
}

defaultproperties
{
     WeaponCapable(1)=255
     PickupMessage="Ice Cell"
     PickupViewMesh=Mesh'JazzObjectoids.IceCell'
     Icon=Texture'JazzArt.Interface.Drmice'
     AnimSequence=IceCell
     AnimRate=1.000000
     Skin=Texture'JazzObjectoids.Skins.Jicebomb_01'
     Mesh=Mesh'JazzObjectoids.IceCell'
     LightType=LT_Steady
     LightBrightness=255
     LightHue=143
     LightRadius=10
}
