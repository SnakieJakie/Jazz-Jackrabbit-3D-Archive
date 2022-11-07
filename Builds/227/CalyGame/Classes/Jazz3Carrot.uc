//=============================================================================
// Jazz3Carrot.
//=============================================================================
class Jazz3Carrot expands Pickup;

var(JazzItem) int	ItemScoreValue;

//
// Do not use this class.  It's old and is pending deletion.
//

/*
auto state Pickup
{	
	function Touch( actor Other )
	{
		Log("CarrotPickup)");
	
		if ( ValidTouch(Other) ) 
		{		
			PlaySound (PickupSound,,2.5);
			DoPickupEffect(Pawn(Other));
			
			JazzPlayer(Other).AddScore(ItemScoreValue);
			SetRespawn();
		}
	}
}

// Override for specific carrot effect on player/pickupperson as 'Other'
//
// Pickup sound is in (Inventory) section of the actor properties.
//
function DoPickupEffect( pawn Other );
*/

defaultproperties
{
     PickupMessage="Yah!"
     PickupSound=Sound'JazzSounds.Items.item1'
     DrawType=DT_Sprite
     Style=STY_Masked
     Sprite=Texture'JazzArt.Item.carrot'
     Texture=Texture'JazzArt.Item.carrot'
     DrawScale=8.000000
}
