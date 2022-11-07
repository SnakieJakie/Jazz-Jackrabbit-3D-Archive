//=============================================================================
// CaptureTheFlag.
//=============================================================================
class CaptureTheFlag expands TeamBattleMode;

// The score bonus for capturing the flag
var () config int CaptureBonus;

// WPlayer has stolen LTeam's flag
function FlagStolen( PlayerReplicationInfo WPlayer, int LTeam)
{
	BroadcastMessage(WPlayer.PlayerName $ " has stolen " $ Teams[LTeam].TeamName $ "'s flag!", false);
}

// WPlayer has dropped LTeam's flag
function FlagDropped( PlayerReplicationInfo WPlayer, int LTeam)
{
	BroadcastMessage(WPlayer.PlayerName $ " has dropped " $ Teams[LTeam].TeamName $ "'s flag!", false);
}

// LPlayer has regained his team's flag (if LPlayer is none, then the timer did it)
function FlagReturned( optional PlayerReplicationInfo LPlayer)
{
	if(LPlayer != None)
	{
		BroadcastMessage(LPlayer.PlayerName $ " has recovered " $ LPlayer.TeamName $ "'s flag!", false);
	}
}

// WPlayer has brought the LTeam's flag back home
function FlagCapture( PlayerReplicationInfo WPlayer, int LTeam)
{
	BroadcastMessage(WPlayer.PlayerName $ " has captured " $ Teams[LTeam].TeamName $ "'s flag!", false);
	Teams[WPlayer.Team].Score += CaptureBonus;
}

defaultproperties
{
     CaptureBonus=10
     bRestartLevel=False
     bPauseable=False
     BeaconName="CTF"
}
