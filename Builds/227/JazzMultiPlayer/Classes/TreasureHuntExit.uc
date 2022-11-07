//=============================================================================
// TreasureHuntExit.
//=============================================================================
class TreasureHuntExit expands NavigationPoint;


function Touch(actor Other)
{
	if(THPlayerReplicationInfo(JazzPlayer(Other).PlayerReplicationInfo).TreasureKey)
	{
		TreasureHunt(Level.Game).PlayerFinish(Other);
	}
	else
	{
		// TODO: Messaging to tell player they need a key
	}
}

function PostBeginPlay()
{
	// Force it to only exsist in treasure hunt games
	if(TreasureHunt(Level.Game) == None)
	{
		Self.Destroy();
	}
	else
	{
		Super.PostBeginPlay();
	}
}

defaultproperties
{
     bStatic=False
     bCollideActors=True
}
