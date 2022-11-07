//=============================================================================
// HuntGem.
//=============================================================================
class HuntGem expands JazzPickupItem;

var actor OldOwner;

var() int GemValue;

auto state Pickup
{	
	function Touch( actor Other )
	{
		if ( ValidTouch(Other) ) 
		{	
			if(Other != OldOwner || Physics != PHYS_Falling)
			{
				JazzPlayer(Other).GemNumber += GemValue;
				
				Self.Destroy();
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
	// For now let's give the desiHealth Desirability
	//
	return (10);
}

defaultproperties
{
     PickupViewMesh=Mesh'UnrealI.Moon1'
     PickupViewScale=0.500000
     bCollideWhenPlacing=True
     Mesh=Mesh'UnrealI.Moon1'
     DrawScale=0.500000
}
