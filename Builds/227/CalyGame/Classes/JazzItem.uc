//=============================================================================
// JazzItem.
//=============================================================================
class JazzItem expands Pickup;

// Basic values
// 
var(JazzItem) int	ItemScoreValue;
var(JazzItem) name  PickupEventSet;		// Set game level event when this is picked up?
var(JazzItem) bool	LevelSpecialItem;	// This is an item that belongs to a level.
var(JazzItem) name	LevelName;			// Set this to the name of the level to be used in.
//var(JazzItem) bool  Tutorial;			// Display the tutorial text
//var(JazzItem) string[200] TutorialText;	// Text to display when item found.

// Add ItemScoreValue to a pawn's scores
//
function AddScore ( pawn Other )
{
	if (JazzPlayer(Other) != None)
	{
		JazzPlayer(Other).AddScore(ItemScoreValue);
	}
	else
	if (JazzPawn(Other) != None)
	{
		JazzPawn(Other).PlayerReplicationInfo.Score += ItemScoreValue;	// 220 Version
	}
}

//
// Advanced function which lets existing items in a pawn's inventory
// prevent the pawn from picking something up. Return true to abort pickup
// or if item handles the pickup
//
function bool HandlePickupQuery( inventory Item )
{
	if (item.class == class) 
	{
		if (bCanHaveMultipleCopies) 
		{   // for items like Artifact
			NumCopies++;
			Item.PlaySound (Item.PickupSound,,2.0);
			Item.SetRespawn();
		}
		else if ( bDisplayableInv ) 
		{		
			if ( Charge<Item.Charge )	
				Charge= Item.Charge;
			Item.PlaySound (PickupSound,,2.0);
			Item.SetReSpawn();
		}
		return true;				
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}


function PickupFunction( pawn Other )
{
	// Add Event?
	
	if (PickupEventSet != '')
	{
		if (JazzPlayer(Other) != None)
			JazzPlayer(Other).AddEventDone(PickupEventSet);
	}
}

defaultproperties
{
}
