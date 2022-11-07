//=============================================================================
// JazzMedievalCell.
//=============================================================================
class JazzMedievalCell expands JazzWeaponCell;

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
	// Medieval Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 0;
		ProjectileFire(class'JazzArrow', 400, true);
		
		MainFireDelay(0.9);	// Main reload 0.9 seconds
		//Sleep(0.9);			// Weapon reload time
	break;

	///////////////////////////
	// Medieval Orb : Level 1
	//
	//
	//
	case 1:
		AimError = 0;
		ProjectileFire(class'JazzArrow2', 400, true);
		
		MainFireDelay(0.9);	// Main reload 0.9 seconds
		//Sleep(0.9);			// Weapon reload time
	break;

	///////////////////////////
	// Medieval Orb : Level 2
	//
	//
	//
	case 2:
		AimError = 0;
		ProjectileFire(class'JazzArrow3', 400, true);
		
		MainFireDelay(0.9);	// Main reload 0.9 seconds
		//Sleep(0.9);			// Weapon reload time
	break;

	}
	
	CheckContinueFire();
}

defaultproperties
{
     MaxPowerLevel=2
     ExperienceNeeded(0)=150
     ExperienceNeeded(1)=500
     FireButtonDesc="Magic Arrow"
     WeaponCapable(1)=255
     PickupMessage="Medieval Cell"
     PlayerViewScale=0.200000
     PickupViewScale=0.200000
     Icon=Texture'JazzArt.Weapons.WMedieval'
     Skin=Texture'JazzArt.Effects.NMurky'
     DrawScale=0.200000
     LightType=LT_Steady
     LightEffect=LE_Shock
     LightBrightness=204
     LightHue=19
     LightRadius=5
}
