//=============================================================================
// JazzSinglePlayer.
//=============================================================================
class JazzSinglePlayer expands JazzGameInfo;
//	config;


function PreBeginPlay ()
{
	Super.PreBeginPlay();
	TutorialsInMode = true;			// So I don't need to update JazzMultiPlayer
	SinglePlayerGame = true;		// Ditto
}

// Old Unreal Stuff
//
function Killed(pawn killer, pawn Other, name damageType)
{
	super.Killed(killer, Other, damageType);
}	

function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)
{
	if ( Incoming.IsA('JazzPlayer') )
	{
		Spawn(class'JazzActorLighting',Incoming);
		
		//Incoming.PlaySound(sound'Teleport1',, 10.0);
	}
}

function DiscardInventory(Pawn Other)
{
	local Inventory I;

	if ( Other.Weapon != None )
		Other.Weapon.PickupViewScale *= 0.7;
		
	// Discard Pawn Inventory
	//
	I = Other.Inventory;
	
	while (I != None)
	{
		if (I != None)
		{
			I.DropFrom(Other.Location);
		
//			I.Velocity = VRand()*100;
//			I.Velocity.Z = 300;
//			I.bBounce = true;
//			I.SetPhysics(PHYS_Falling);
			
			// Assign velocity to object dropping
		}
	
		I = I.Inventory;
	}
}


//
// Called when pawn has a chance to pick Item up (i.e. when 
// the pawn touches a weapon pickup). Should return true if 
// he wants to pick it up, false if he does not want it.
//
function bool PickupQuery( Pawn Other, Inventory item )
{
	// JazzPawnAI Check
	if ( JazzPawnAI(Other) != None)
		{
		//Log("JazzPawnAICheck) "$JazzPawnAI(Other).CanPickupItems);
		return (JazzPawnAI(Other).CanPickupItems);
		}

	if ( Other.Inventory == None )
		return true;
//	if ( bCoopWeaponMode && item.IsA('Weapon') && !Weapon(item).bHeldItem && (Other.FindInventoryType(item.class) != None) )
//		return false;
	else
		return !Other.Inventory.HandlePickupQuery(Item);
}

//
// Return the 'best' player start for this player to start from.
// Re-implement for each game type.
//
function NavigationPoint FindPlayerStart(byte Team, optional string incomingName )
{
	local PlayerStart Dest;
	local Teleporter Tel;
	
	if( incomingName!="" )
		foreach AllActors( class 'Teleporter', Tel )
			{
			if( string(Tel.Tag)~=incomingName )
				return Tel;
			}
			
	if( incomingName!="" )
		foreach AllActors( class 'PlayerStart', Dest )
			if( string(Dest.Tag)~=incomingName )
				return Dest;
			
	foreach AllActors( class 'PlayerStart', Dest )
		if( Dest.bSinglePlayerStart )
			return Dest;
	log( "No single player start found" );
	return None;
}

defaultproperties
{
     DefaultPlayerClass=Class'DudeGame.DudeJazz'
     DefaultWeapon=Class'CalyGame.JackrabbitGun'
     WaterZoneType=Class'UnrealShare.WaterZone'
}
