//=============================================================================
// JazzTreasureKey.
//=============================================================================
class JazzTreasureKey expands JazzPickupItem;

// The actor who will be using this key
var actor User;

auto state Pickup
{	
	function Touch( actor Other )
	{
		if ( ValidTouch(Other) ) 
		{	
			if(Other == User)
			{
				if (JazzPlayer(Other) != None)	// Player touched
				{
					JazzPlayer(Other).TreasureKey = true;
				}
				else
				if (JazzPawnAI(Other) != None) 	// Pawn AI touched
				{
					JazzPawnAI(Other).TreasureKey = true;
				}
				
				// TODO: Messaging to tell player that they have the key
				
				Self.Destroy();
			}
			else
			{
				if(!JazzPlayer(Other).TreasureKey)
				{
					// TODO: Messaging to tell player they need different key
				}
			}
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////
// Desirability of the Item
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesireability( pawn Bot )
{
	// Hey, we really want this.
	return (100);
}

defaultproperties
{
     PickupViewMesh=Mesh'UnrealI.Flag1M'
     bCollideWorld=True
}
