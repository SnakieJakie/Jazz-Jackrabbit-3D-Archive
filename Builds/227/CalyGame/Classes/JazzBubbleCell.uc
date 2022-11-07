//=============================================================================
// JazzBubbleCell.
//=============================================================================
class JazzBubbleCell expands JazzWeaponCell;

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
	// Bubble Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 0;
		ProjectileFire(class'JazzBubble', 800, true);
		AnimateWeapon(0);
	
		MainFireDelay(1.5);
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
	// Bubble Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 0;
		// ProjectileFire(class'JazzIceGrenade', 800, true);
		AnimateWeapon(0);
	
		AltFireDelay(2);
		//Sleep(0.5);
	break;
	}
	
	CheckContinueFire();	// Check if fire held down
}

defaultproperties
{
}
