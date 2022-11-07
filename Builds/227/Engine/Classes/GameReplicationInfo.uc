//=============================================================================
// GameReplicationInfo.
//=============================================================================
class GameReplicationInfo expands ReplicationInfo;

var string[32] GameName;				// Assigned by GameInfo.
var bool bTeamGame;						// Assigned by GameInfo.

var() config string[128] ServerName;	// Name of the server, i.e.: Bob's Server.
var() config string[128] ShortName;		// Abbreviated name of server, i.e.: B's Serv (stupid example)
var() config string[128] AdminName;		// Name of the server admin.
var() config string[128] AdminEmail;	// Email address of the server admin.
var() config int 		 Region;		// Region of the game server.

var() config bool ShowMOTD;				// Whether or not to display the MOTD.
var() config string[64] MOTDLine1;		// Message
var() config string[64] MOTDLine2;		// Of
var() config string[64] MOTDLine3;		// The
var() config string[64] MOTDLine4;		// Day

replication
{
	reliable if ( Role == ROLE_Authority )
		GameName, bTeamGame, ServerName, ShortName, AdminName,
		AdminEmail, Region, ShowMOTD, MOTDLine1, MOTDLine2, 
		MOTDLine3, MOTDLine4;
}

defaultproperties
{
     ServerName="Another Unreal Server"
     ShortName="Unreal Server"
}
