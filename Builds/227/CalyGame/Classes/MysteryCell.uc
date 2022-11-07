//=============================================================================
// MysteryCell.
//=============================================================================
class MysteryCell expands JazzWeaponCell;

// Use this item.
//
var JazzObject TransmuteObject;

///////////////////////////////////////////////////////////////////////////////////////
// Mystery Fire : Weapon JackrabbitGun									FIRE
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

///////////////////////////////////////////////////////////////////////////////////////
// Mystery Fire : Weapon JackrabbitGun									FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state AltFireStateJazz			// Jazz Jackrabbit's Weapon
{
	// Trace to vector V and see if anything is in the way.
	//
	function bool VectorTrace( vector V )
	{
		local vector 	HitLocation,HitNormal;
		local actor 	Result;
		local bool		ActorFound;
		local float		NewDist;
		local float 	TraceDistance;
		local vector 	TraceLocation;
	
		Result = Trace( HitLocation, HitNormal,	V, Location );

		TraceDistance = VSize(HitLocation-Location);
		TraceLocation = HitLocation;

		// Return true if trace is not blocked.
	
		return(HitLocation == V);
	}

	function FindTransmuteObject()
	{
		local float Distance;
		local JazzObject O;
	
		// Scan for nearby JazzObjects
		Distance = 15000;
		TransmuteObject = None;
		
		SetLocation(Owner.Location);
		foreach VisibleActors(class'JazzObject',O,15000)
		{
			if (O.DrawType!=DT_Sprite)
			if (VSize(Owner.Location-O.Location)<Distance)
			{
				TransmuteObject = O;
				Distance = VSize(Owner.Location-O.Location);
			}
		}
	}

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
		// Transmute Self
		//
		// Find an object somewhere in the vicinity and shimmer Jazz a bit, 
		// then turn him into that object.
		//
		
		// (1) Find nearby object visible to transmute to.
		FindTransmuteObject();

		// (2) Transmute player command
		if ((TransmuteObject!=None) && (TransmuteObject.Mesh!=None))
		{
			// Successful transmutation
			JazzPlayer(Owner).TransmuteToMesh(TransmuteObject.Mesh,TransmuteObject.Skin,TransmuteObject.AnimSequence,TransmuteObject.AnimFrame,10);
		}
		else
		{
			Log("Transmute Failed)");
			// Failed Transmutation - Nothing nearby to scan
			JazzPlayer(Owner).TransmuteToMesh(Owner.Mesh,Owner.Skin,Owner.AnimSequence,Owner.AnimFrame,-1);
		}

		MainFireDelay(1.0);	// Main reload 1.0 seconds
	break;
	
	}
	
	CheckContinueFire();	// Check if fire held down
}

defaultproperties
{
     WeaponCapable(1)=255
     PickupMessage="Mystery Cell"
     PickupViewScale=0.300000
     Icon=Texture'JazzArt.Weapons.Weaprock'
     Skin=Texture'JazzArt.Effects.NRock'
     DrawScale=0.300000
}
