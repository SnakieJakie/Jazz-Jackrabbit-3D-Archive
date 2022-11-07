//=============================================================================
// JazzFireCell.
//=============================================================================
class JazzFireCell expands JazzWeaponCell;


///////////////////////////////////////////////////////////////////////////////////////
// Normal Fire : Weapon JackrabbitGun									FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state FireStateJazz			// Jazz Jackrabbit's Weapon
{
	// Missile launcher
	// Perform actual firing here
	Gizmo:
	
		// Projectile JazzNormal / Speed 600 / Warns target
		ProjectileFire(class'JazzMissile', 600, true);
		AnimateWeapon(0);
		Sleep(0.3);
	
		MainFireDelay(0.85);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time	
	
	CheckContinueFire();	// Check if fire held down
	

	ChargeFire1A:
		AimError = 0;
		ProjectileFire(class'JazzFire', 400, true);
		AnimateWeapon(0);
		MainFireDelay(0.4);		// Main Reload 0.4 seconds
		CheckContinueFire();

	ChargeFire1B:
		AimError = 0;
		ProjectileFire(class'JazzFire', 400, true, rot(0,-5000,0));
		ProjectileFire(class'JazzFire', 400, true, rot(0, 5000,0));
		ProjectileFire(class'JazzFire', 400, true, rot(0, 0   ,0));
		AnimateWeapon(0);
		MainFireDelay(0.4);		// Main Reload 0.4 seconds
		CheckContinueFire();
	
	// Perform actual firing here
	Begin:

	switch (CurrentPowerLevel)
	{
	
	///////////////////////////
	// Fire Orb : Level 0
	//
	//
	//
	case 0:
		ChargeStart('ChargeFire1A',class'FireChargeEffect1',	false, 0.0 , 1, 0.05);
		Sleep(1);
		ChargeStart('ChargeFire1B',class'FireChargeEffect1',	false, 0.05, 1, 0.15);
		Sleep(20);
		Goto('ChargeNormalB');
	break;
	
	}
	
	CheckContinueFire();	// Check if fire held down
}

defaultproperties
{
     FireButtonDesc="Sticky Fireball"
     WeaponCapable(1)=255
     WeaponCapable(5)=255
     ItemName="Fire Cell"
     PickupMessage="Fire Cell"
     PlayerViewMesh=Mesh'JazzObjectoids.FireCell'
     PickupViewMesh=Mesh'JazzObjectoids.FireCell'
     Icon=Texture'JazzArt.Interface.Drmfire'
     Physics=PHYS_Rotating
     AnimSequence=FireCell
     AnimRate=10.000000
     Mesh=Mesh'JazzObjectoids.FireCell'
     LightType=LT_Pulse
     LightBrightness=255
     LightRadius=5
     RotationRate=(Pitch=500,Yaw=500,Roll=500)
}
