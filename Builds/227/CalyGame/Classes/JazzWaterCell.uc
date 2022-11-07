//=============================================================================
// JazzWaterCell.
//=============================================================================
class JazzWaterCell expands JazzWeaponCell;

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
	// Water Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 0;
		ProjectileFire(class'JazzWater', 400, true);
		AnimateWeapon(0);
		
		MainFireDelay(0.6);	// Main reload 0.45 seconds
		//Sleep(0.6);			// Weapon reload time
	break;
	
	
	///////////////////////////
	// Water Orb : Level 1
	//
	//
	//
	case 1:
		AimError = 0;
		ProjectileFire(class'JazzWater2', 400, true);
		AnimateWeapon(0);
		
		Sleep(0.6);			// Weapon reload time
	break;
		
	}
	
	CheckContinueFire();	// Check if fire held down
}

defaultproperties
{
     MaxPowerLevel=1
     ExperienceNeeded(0)=250
     FireButtonDesc="Water Bomb"
     WeaponCapable(1)=255
     PickupMessage="Water Cell"
     PickupViewMesh=Mesh'JazzObjectoids.WaterCell'
     Icon=Texture'JazzArt.Weapons.WWater'
     AnimSequence=WaterCell
     AnimRate=1.000000
     Style=STY_None
     Skin=Texture'JazzArt.Effects.NWater2'
     Mesh=Mesh'JazzObjectoids.WaterCell'
     LightType=LT_Steady
     LightEffect=LE_Shock
     LightBrightness=255
     LightHue=140
     LightRadius=5
}
