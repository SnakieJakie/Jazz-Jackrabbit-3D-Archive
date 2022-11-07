//=============================================================================
// JazzPickupItem.
//=============================================================================
class JazzPickupItem expands JazzItem;

//
// Base class for items that are picked up and have an instant effect, such as coins
// or health restoration.
//

var float	PickupDelay;		// Wait for item to be picked up if generated from an enemy.

// This class implements the object pickup functions.
//



auto state Pickup
{	

	// Validate touch, and if valid trigger event.
	function bool ValidTouch( actor Other )
	{
		local Actor A;
		
		if( Pawn(Other)!=None && Level.Game.PickupQuery(Pawn(Other), self) )
		{
			/*if( Event != '' )
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( Other, Other.Instigator );*/
			return true;
		}
		return false;
	}

	function Touch( actor Other )
	{
		if ( ValidTouch(Other) ) 
		{
			if (PickupDelay<=0)
			{
			DoPickupEffect(Pawn(Other));
			PickupFunction(Pawn(Other));
			
			SetRespawn();
			}
		}
	}
	
	event Tick (float DeltaTime)
	{
		if (PickupDelay>=0)
		PickupDelay -= DeltaTime;
	}
}

// Override for specific carrot effect on player/pickupperson as 'Other'
//
// Pickup sound is in (Inventory) section of the actor properties.
//
function DoPickupEffect( pawn Other )
{
	PlaySound (PickupSound,,2.5);

	AddScore(Other);
}

function NewPickupDelay()
{
	PickupDelay = 1;	// Default is 1 second
}


function PreBeginPlay()
{
	PickupDelay = 0.5;	// Default is 1 second for non-specified items
}

////////////////////////////////////////////////////////////////////////////////////////
// Base function that determines the desirability of an item for a 'bot' (Thinker)
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesirability( pawn Bot )
{
	return (-1);	// Default Item type is totally undesirable - Override this function to create desirable item
}

defaultproperties
{
}
