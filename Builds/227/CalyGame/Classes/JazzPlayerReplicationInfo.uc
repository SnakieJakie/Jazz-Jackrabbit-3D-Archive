//=============================================================================
// JazzPlayerReplicationInfo.
//=============================================================================
class JazzPlayerReplicationInfo expands PlayerReplicationInfo;

// If the jazz player is a spectator
var bool bSpectate;


replication
{
	// Things the server should send to the client.
	reliable if ( Role == ROLE_Authority )
		bSpectate;
}

defaultproperties
{
}
