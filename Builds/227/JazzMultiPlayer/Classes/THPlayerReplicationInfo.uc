//=============================================================================
// THPlayerReplicationInfo.
//=============================================================================
class THPlayerReplicationInfo expands JazzPlayerReplicationInfo;

// How many gems the player has (used for Treasure Hunt mode)
var		int			GemNumber;
// If the player has the key (used for Treasure Hunt mode)
var		bool		TreasureKey;
// The time the player spent in the level
var		float		TreasureTime;
// If the player has finished or not (used for Treasure Hunt mode)
var		bool		TreasureFinish;


// The player's final score
var		int			Score;


replication
{
	// Things the server should send to the client.
	reliable if ( Role == ROLE_Authority )
		GemNumber, TreasureKey, TreasureTime, TreasureFinish, Score;
}

defaultproperties
{
}
