//=============================================================================
// PlayerReplicationInfo.
//=============================================================================
class PlayerReplicationInfo expands ReplicationInfo
	intrinsic;

var string[20]	PlayerName;		// Player name, or blank if none.
var string[20]	TeamName;		// Team name, or blank if none.
var travel byte	Team;					// Player Team, 255 = None for player.
var int					TeamID;			// Player position in team.
var float				Score;			// Player's current score.
var float				Spree;			// Player is on a killing spree.
var class<VoicePack>	VoiceType;
var Decoration			HasFlag;
var int					Ping;

replication
{
	// Things the server should send to the client.
	reliable if ( Role == ROLE_Authority )
		PlayerName, TeamName, Team, TeamID, Score, VoiceType, 
		HasFlag, Ping;
}

function BeginPlay()
{
	if (PlayerPawn(Owner) != None)
		Ping = int(PlayerPawn(Owner).ConsoleCommand("GETPING"));
	SetTimer(2.0, true);
}

function Timer()
{
	if (PlayerPawn(Owner) != None)
		Ping = int(PlayerPawn(Owner).ConsoleCommand("GETPING"));
}

defaultproperties
{
}
