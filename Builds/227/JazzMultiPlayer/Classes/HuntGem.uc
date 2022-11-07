//=============================================================================
// HuntGem.
//=============================================================================
class HuntGem expands JazzPickupItem;

var actor OldOwner;

var() int GemValue;

simulated function PostBeginPlay()
{
	if(TreasureHunt(Level.Game) == None)
	{
		Self.Destroy();
	}
}

function DoPickupEffect( pawn Other )
{
	THPlayerReplicationInfo(JazzPlayer(Other).PlayerReplicationInfo).GemNumber += GemValue;
	Self.Destroy();

	Super.DoPickupEffect(Other);
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
     ItemScoreValue=100
     PickupViewMesh=Mesh'UnrealI.Moon1'
     PickupViewScale=0.500000
     bCollideWhenPlacing=True
     Texture=Texture'JazzObjectoids.Skins.Jgem_01'
     Mesh=Mesh'JazzObjectoids.gem'
     DrawScale=0.500000
}
