//=============================================================================
// JazzSoundCell.
//=============================================================================
class JazzSoundCell expands JazzWeaponCell;

var		int		ShotCounter;


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
	
	///////////////////////////
	// Sonic Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 0;

		for (ShotCounter=0; ShotCounter<1; ShotCounter++)
		{
			// Projectile JazzNormal / Speed 600 / Warns target
			ProjectileFire(class'JazzSonic', 600, true);
			Sleep(0.1);
		}
	
		MainFireDelay(0.6);		// Main reload 0.6 seconds
		//Sleep(0.6);			// Weapon reload time
	break;
		
	}
	
	CheckContinueFire();	// Check if fire held down
}

defaultproperties
{
     FireButtonDesc="Sonic Tunnel"
     WeaponCapable(1)=255
     PickupMessage="Sound Cell"
     PlayerViewScale=0.300000
     PickupViewScale=0.300000
     Icon=Texture'JazzArt.Weapons.WSonic'
     Skin=Texture'JazzArt.Effects.NWater4'
     DrawScale=0.200000
     LightType=LT_Steady
     LightEffect=LE_Shock
     LightBrightness=255
     LightHue=140
     LightRadius=4
}
