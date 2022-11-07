//=============================================================================
// JazzCoin.
//=============================================================================
class JazzCoin expands JazzPickupItem;

var(JazzItem) int	ItemMoneyValue;

// Override for specific carrot effect on player/pickupperson as 'Other'
//
// Pickup sound is in (Inventory) section of the actor properties.
//
function DoPickupEffect( pawn Other )
{
	PlaySound (PickupSound,,2.5);
	
	if (JazzPlayer(Other) != None)
	{
	JazzPlayer(Other).AddScore(ItemScoreValue);
	JazzPlayer(Other).Carrots += ItemMoneyValue;
	JazzPlayer(Other).UpdateCarrot();
	}
	else
	{
	Other.PlayerReplicationInfo.Score += ItemScoreValue;	// 220 Version

	if (JazzPawnAI(Other) != None)
	{
	JazzPawnAI(Other).Carrots += ItemMoneyValue;
	}
	}
	SetRespawn();
}

////////////////////////////////////////////////////////////////////////////////////////
// Base function that determines the desirability of an item for a 'bot' (Thinker)
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesireability( pawn Bot )
{
	return (2);	// Coins aren't really very desirable for thinkers right now - just enough to think about getting one
}

defaultproperties
{
     ItemMoneyValue=1
     PlayerViewMesh=Mesh'JazzObjectoids.coin'
     PlayerViewScale=0.400000
     PickupViewMesh=Mesh'JazzObjectoids.coin'
     PickupViewScale=0.400000
     PickupSound=Sound'JazzSounds.Items.coingrab'
     bDirectional=True
     Physics=PHYS_Rotating
     Texture=Texture'JazzObjectoids.Skins.Jcoin_01'
     Mesh=Mesh'JazzObjectoids.coin'
     DrawScale=0.400000
     RotationRate=(Yaw=20000)
}
