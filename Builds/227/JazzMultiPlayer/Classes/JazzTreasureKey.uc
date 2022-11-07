//=============================================================================
// JazzTreasureKey.
//=============================================================================
class JazzTreasureKey expands JazzPickupItem;

// The actor who will be using this key
var actor User;


auto state Pickup
{	
	simulated function Touch( actor Other )
	{
		if ( ValidTouch(Other) ) 
		{	
			if(Other == User)
			{
				if (JazzPlayer(Other) != None)	// Player touched
				{
					THPlayerReplicationInfo(JazzPlayer(Other).PlayerReplicationInfo).TreasureKey = true;
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
				if(!THPlayerReplicationInfo(JazzPlayer(Other).PlayerReplicationInfo).TreasureKey)
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
     PickupViewMesh=Mesh'JazzObjectoids.keygold'
     bCollideWorld=True
}
