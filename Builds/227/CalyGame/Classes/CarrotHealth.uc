//=============================================================================
// CarrotHealth.
//=============================================================================
class CarrotHealth expands Jazz3Carrot;

// Orange Carrot		Common
// -------------
//
// Increases Player's Health
// +5 HP
//
var(JazzCarrot) int	HealingAmount;

/*
function DoPickupEffect( pawn Other )
{
	// Is a player?
	if (JazzPlayer(Other)!=None)
	{	
		JazzPlayer(Other).AddHealth(HealingAmount);
	}
}
*/

defaultproperties
{
     HealingAmount=10
     PlayerViewMesh=Texture'JazzArt.Item.carrot'
     PlayerViewScale=3.000000
     PickupViewMesh=Texture'JazzArt.Item.carrot'
     PickupViewScale=3.000000
}
