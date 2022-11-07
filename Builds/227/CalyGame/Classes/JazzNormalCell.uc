//=============================================================================
// JazzNormalCell.
//=============================================================================
class JazzNormalCell expands JazzWeaponCell;

// Use this item.
//

//
// This is the 'normal' weapon for Jazz Jackrabbit to use.
//
// NOTE: This cell dies when the actor is killed.  It does not drop.  It should also only
// be added or found when starting a game, as it's actually (while not in code) the actual
// weapon.  It's merely broken into a cell to make coding a heckuva lot easier to support one
// cell type.  When a weapon is spawned, a weapon cell is also spawned and added to the
// inventory to reflect the weapon's firing capability.
//

var 	int		ShotCounter;


// Destroy item if it is to become a pickup item.
//
function DropFrom(vector StartLocation)
{
	//Log("DestroyPickup)");
	Destroy();
}

///////////////////////////////////////////////////////////////////////////////////////
// Normal Fire : Weapon JackrabbitGun									FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state FireStateJazz
{
	// Missile launcher
	// Perform actual firing here
	Missile:
	
		// Projectile JazzNormal / Speed 600 / Warns target
		ProjectileFire(class'JazzMissile', 600, true);
		AnimateWeapon(0);
		Sleep(0.1);
	
		AltFireDelay(0.85);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time	
	
	CheckContinueFire();	// Check if fire held down
	
	// Gizmo
	Gizmo:
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
		AnimateWeapon(0);
		
		MainFireDelay(0.2);		// Main Reload 0.2 seconds
		//Sleep(0.4);				// Weapon reload time
	break;

	}
	CheckContinueFire();	// Check if fire held down
	
	// Perform actual firing here
	Begin:

	switch (CurrentPowerLevel)
	{
	
	///////////////////////////
	// No Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 500;

		//for (ShotCounter=0; ShotCounter<3; ShotCounter++)
		//{
			// Projectile JazzNormal / Speed 600 / Warns target
			ProjectileFire(class'JazzNormal', 600, true);
			AnimateWeapon(0);
			//Sleep(0.1);
		//}
	
		MainFireDelay(0.2);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time
	break;


	///////////////////////////
	// No Orb : Level 1
	//
	//
	//
	case 1:
		AimError = 600;

		for (ShotCounter=0; ShotCounter<5; ShotCounter++)
		{
			// Projectile JazzNorma2 / Speed 700 / Warns target
			ProjectileFire(class'JazzNormal2', 700, true);
			AnimateWeapon(0);
			Sleep(0.09);
		}
	
		MainFireDelay(0.5);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time
	break;
	
	///////////////////////////
	// No Orb : Level 2
	//
	//
	//
	case 2:
		AimError = 700;

		for (ShotCounter=0; ShotCounter<7; ShotCounter++)
		{
			// Projectile JazzNorma2 / Speed 700 / Warns target
			ProjectileFire(class'JazzNormal3', 700, true);
			AnimateWeapon(0);
			Sleep(0.08);
		}
	
		MainFireDelay(0.5);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time
	break;
	
	///////////////////////////
	// No Orb : Level 3
	//
	//
	//
	case 3:
		AimError = 600;

		for (ShotCounter=0; ShotCounter<9; ShotCounter++)
		{
			// Projectile JazzNorma2 / Speed 700 / Warns target
			ProjectileFire(class'JazzNormal4', 700, true);
			AnimateWeapon(0);
			Sleep(0.07);
		}
	
		MainFireDelay(0.5);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time
	break;
	
	}
	
	CheckContinueFire();	// Check if fire held down
}

///////////////////////////////////////////////////////////////////////////////////////
// Alt Fire : Weapon JackrabbitGun										FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state AltFireStateJazz
{
	// Level 1
	ChargeNormalA:
		AimError=0;
		ProjectileFire(class'JazzCharge1', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	ChargeNormalB:
		AimError=0;
		ProjectileFire(class'JazzCharge2', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
		
	ChargeNormalC:
		AimError=0;
		ProjectileFire(class'JazzCharge3', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
		
	// Level 2
	ChargeNormal2A:
		AimError=0;
		ProjectileFire(class'JazzCharge1B', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	ChargeNormal2B:
		AimError=0;
		ProjectileFire(class'JazzCharge2B', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	// Level 3
	ChargeNormal3A:
		AimError=0;
		ProjectileFire(class'JazzCharge1C', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	ChargeNormal3B:
		AimError=0;
		ProjectileFire(class'JazzCharge2C', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	// Level 4
	ChargeNormal4A:
		AimError=0;
		ProjectileFire(class'JazzCharge1D', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	ChargeNormal4B:
		AimError=0;
		ProjectileFire(class'JazzCharge2D', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();

	// Normal weapon
	// Perform actual firing here
	Begin:
	
	switch (CurrentPowerLevel)
	{
	
	///////////////////////////
	// No Orb : Level 0
	//
	case 0:
		ChargeStart('ChargeNormalA',class'ChargeEffect1',true,0.0,1,0.05);
		Sleep(1);
		ChargeStart('ChargeNormalB',class'ChargeEffect1',true,0.05,1,0.15);
		Sleep(1);
		ChargeStart('ChargeNormalC',class'ChargeEffect1',true,0.15);
		Sleep(20);
		Goto('ChargeNormalB');
	break;

	///////////////////////////
	// No Orb : Level 1
	//
	case 1:
		ChargeStart('ChargeNormal2A',class'ChargeEffect1B',true,0.02,3,0.1);
		Sleep(3);
		ChargeStart('ChargeNormal2B',class'ChargeEffect1B',true,0.1);
		Sleep(20);
		Goto('ChargeNormal2B');
	break;

	///////////////////////////
	// No Orb : Level 2
	//
	case 2:
		ChargeStart('ChargeNormal3A',class'ChargeEffect1C',true,0.02,3,0.1);
		Sleep(3);
		ChargeStart('ChargeNormal3B',class'ChargeEffect1C',true,0.1);
		Sleep(20);
		Goto('ChargeNormal3B');
	break;

	///////////////////////////
	// No Orb : Level 4
	//
	case 3:
		ChargeStart('ChargeNormal4A',class'ChargeEffect1D',true,0.02,3,0.1);
		Sleep(3);
		ChargeStart('ChargeNormal4B',class'ChargeEffect1D',true,0.1);
		Sleep(20);
		Goto('ChargeNormal4B');
	break;
	}
	
	CheckContinueFire();	// Check if fire held down
}


// Special for Normal cell
//
function Touch ( actor Other )
{
	// Just ignore it - there's no way it should be an item and we don't want
	// misplaced displays or messages occurring.
	bHidden = true;
}

function BecomeItem()
{
	Super.BecomeItem();
	bHidden = true;
}

function NewItemDisplay()
{
	bHidden = true;
}

// Rate Cell
//
function float	RateCell ()
{
	// Override this function in subclasses
	return (1);
}

defaultproperties
{
     MaxPowerLevel=3
     ExperienceNeeded(0)=500
     ExperienceNeeded(1)=2000
     ExperienceNeeded(2)=10000
     FireButtonDesc="Jazz Pulser"
     WeaponCapable(1)=255
     WeaponCapable(2)=255
     WeaponCapable(5)=255
     PickupMessage="Normal Cell"
     Icon=Texture'JazzArt.Interface.Drmnorm'
     DrawType=DT_None
     Mesh=None
}
