//=============================================================================
// JazzLightningCell.
//=============================================================================
class JazzLightningCell expands JazzWeaponCell;

state FireStateJazz			// Jazz Jackrabbit's Weapon
{
	///////////////////////////////////////////////////////////////////////////////////////
	// Normal Fire : Weapon Electro Shiv
	///////////////////////////////////////////////////////////////////////////////////////
	//
	// Perform actual firing here
	//
	Shiv:

	switch (CurrentPowerLevel)
	{
	
	///////////////////////////
	// Lightning Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 0;
		ProjectileFire(class'JazzLightning', 400, true);
		
		MainFireDelay(0.2);		// Main Reload 0.2 seconds
		//Sleep(0.4);				// Weapon reload time
	break;

	}
	CheckContinueFire();	// Check if fire held down
}



state AltFireStateJazz			// Jazz Jackrabbit's Weapon
{
	///////////////////////////////////////////////////////////////////////////////////////
	// Alt Fire : Weapon Electro Shiv
	///////////////////////////////////////////////////////////////////////////////////////
	//
	// Perform actual firing here
	//
	Shiv:

	switch (CurrentPowerLevel)
	{
	
	///////////////////////////
	// Lightning Orb : Level 0
	//
	//
	//
	case 0:
		//Log("LightningWeaponAlt");
		AimError = 0;
		ShieldEffect(class'LightningShield');
		
		MainFireDelay(0.2);		// Main Reload 0.2 seconds
	break;
	
	}
	
	CheckContinueFire();	// Check if fire held down
}

defaultproperties
{
     FireButtonDesc="Lightning"
     ItemName="Storm Cell"
     PickupMessage="Storm Cell"
     PlayerViewScale=0.200000
     PickupViewScale=0.200000
     Texture=Texture'JazzArt.Interface.Jazzgem'
     Skin=Texture'JazzArt.Interface.Jazzgem'
     DrawScale=0.200000
     bCollideWorld=True
}
