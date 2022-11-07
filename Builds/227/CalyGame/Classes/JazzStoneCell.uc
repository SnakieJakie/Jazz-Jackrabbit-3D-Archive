//=============================================================================
// JazzStoneCell.
//=============================================================================
class JazzStoneCell expands JazzWeaponCell;

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
	// Petrify Orb : Level 0
	//
	//
	//
	//
	case 0:
		AimError = 0;
		ProjectileFire(class'JazzStone', 800, true);
	
		MainFireDelay(0.45);	// Main reload 0.45 seconds
		//Sleep(0.45);
	break;
	
	}
	
	CheckContinueFire();	// Check if fire held down
}

defaultproperties
{
     WeaponCapable(1)=255
     PickupMessage="Petrify Cell"
     PickupViewScale=0.300000
     Icon=Texture'JazzArt.Weapons.Weaprock'
     Skin=Texture'JazzArt.Effects.NRock'
     DrawScale=0.300000
}
