//=============================================================================
// UdpServerQuery
//
// Version: 1.5
//
// This query server is compliant with the GameSpy Uplink Specification.
// The specification is available at http://www.gamespy.com/developer
// and might be of use to progammers who are writing or maintaining
// their own stat gathering/game querying software.
//
// Note: Currently, SendText returns false if successful.
//
// Full documentation on this class is available at http://unreal.epicgames.com/
//
//=============================================================================
class UdpServerQuery expands UdpLink config;

// Game Server Config.
var() name					QueryName;			// Name to set this object's Tag to.
var int					    CurrentQueryNum;	// Query ID Number.

// Initialize.
function PreBeginPlay()
{
	// Set the Tag
	Tag = QueryName;

	// Bind the listen socket
	if( !BindPort(GetServerPort(), true) )
	{
		Log("UdpServerQuery: Port failed to bind.");
		return;
	}
	Log("UdpServerQuery: Port "$Port$" succesfully bound.");
}

// Return the server's port number.
function int GetServerPort()
{
	local string[64] S;
	local int i;

	// Figure out the server's port.
	S = Level.GetAddressURL();
	i = InStr( S, ":" );
	assert(i>=0);
	return int(Mid(S,i+1));
}

// Received a query request.
event ReceivedText(IpAddr Addr, string[255] Text)
{
	local string[255] Query;
	local bool QueryRemaining;
	local int  QueryNum, PacketNum;

	// Assign this packet a unique value from 1 to 100
	CurrentQueryNum++;
	if (CurrentQueryNum > 100)
		CurrentQueryNum = 1;
	QueryNum = CurrentQueryNum;

	Query = Text;
	if (Query == "")		// If the string is empty, don't parse it
		QueryRemaining = false;
	else
		QueryRemaining = true;
	
	while (QueryRemaining) {
		Query = ParseQuery(Addr, Query, QueryNum, PacketNum);
		if (Query == "")
			QueryRemaining = false;
		else
			QueryRemaining = true;
	}
}

function string[255] ParseQuery(IpAddr Addr, coerce string[240] Query, int QueryNum, out int PacketNum)
{
	local string[255] QueryType, QueryValue, QueryRest, ValidationString;
	local bool Result;
	local string[32] FinalPacket;
	
	Result = ParseNextQuery(Query, QueryType, QueryValue, QueryRest, FinalPacket);
	if( !Result )
		return "";

	switch( QueryType )
	{
		case "basic":
			Result = SendQueryPacket(Addr, GetBasic(), QueryNum, ++PacketNum, FinalPacket);
			break;
		case "info":
			Result = SendQueryPacket(Addr, GetInfo(), QueryNum, ++PacketNum, FinalPacket);
			break;
		case "rules":
			Result = SendQueryPacket(Addr, GetRules(), QueryNum, ++PacketNum, FinalPacket);
			break;
		case "players":
			if( Level.Game.NumPlayers > 0 )
				Result = SendPlayers(Addr, QueryNum, PacketNum, FinalPacket);
			else
				Result = SendQueryPacket(Addr, "", QueryNum, PacketNum, FinalPacket);
			break;
		case "status":
			Result = SendQueryPacket(Addr, GetBasic(), QueryNum, ++PacketNum, "");
			Result = SendQueryPacket(Addr, GetInfo(), QueryNum, ++PacketNum, "");
			if( Level.Game.NumPlayers == 0 )
			{
				Result = SendQueryPacket(Addr, GetRules(), QueryNum, ++PacketNum, FinalPacket);
			}
			else
			{
				Result = SendQueryPacket(Addr, GetRules(), QueryNum, ++PacketNum, "");
				Result = SendPlayers(Addr, QueryNum, PacketNum, FinalPacket);
			}
			break;
		case "echo":
			// Respond to an echo with the same string
			Result = SendQueryPacket(Addr, "\\echo\\"$QueryValue, QueryNum, ++PacketNum, FinalPacket);
			break;
		case "secure":
			ValidationString = "\\validate\\"$Validate(QueryValue);
			Log(ValidationString);
			Result = SendQueryPacket(Addr, ValidationString, QueryNum, ++PacketNum, FinalPacket);
			break;
		case "level_property":
			Result = SendQueryPacket(Addr, GetLevelProperty(QueryValue), QueryNum, ++PacketNum, FinalPacket);
			break;
		case "game_property":
			Result = SendQueryPacket(Addr, GetGameProperty(QueryValue), QueryNum, ++PacketNum, FinalPacket);
			break;
		case "player_property":
			Result = SendQueryPacket(Addr, GetPlayerProperty(QueryValue), QueryNum, ++PacketNum, FinalPacket);
			break;
		default:
			break;
	}
	if( !Result )
		Log("UdpServerQuery: Error responding to query.");
	return QueryRest;
}

// SendQueryPacket is a wrapper for SendText that allows for packet numbering.
function bool SendQueryPacket(IpAddr Addr, coerce string[220] SendString, int QueryNum, int PacketNum, string[32] FinalPacket)
{
	local bool Result;
	if (FinalPacket == "final") {
		SendString = SendString$"\\final\\";
	}
	SendString = SendString$"\\queryid\\"$QueryNum$"."$PacketNum;

	Result = SendText(Addr, SendString);

	return Result;
}

// Return a string of basic information.
function string[255] GetBasic() {
	local string[255] ResultSet;

	// The name of this game.
	ResultSet = "\\gamename\\unreal";

	// The version of this game.
	ResultSet = ResultSet$"\\gamever\\"$Level.EngineVersion;

	// The regional location of this game.
	ResultSet = ResultSet$"\\location\\"$Level.Game.GameReplicationInfo.Region;
	
	return ResultSet;
}

// Return a string of important system information.
function string[255] GetInfo() {
	local string[255] ResultSet;
	
	// The server name, i.e.: Bob’s Server
	ResultSet = "\\hostname\\"$Level.Game.GameReplicationInfo.ServerName;

	// The short server name
	ResultSet = ResultSet$"\\shortname\\"$Level.Game.GameReplicationInfo.ShortName;

	// The server port.
	ResultSet = ResultSet$"\\hostport\\"$GetServerPort();

	// (optional) The server IP
	// if (ServerIP != "")
	//	ResultSet = ResultSet$"\\hostip\\"$ServerIP;

	// The map/level name
	ResultSet = ResultSet$"\\mapname\\"$Level.Title;

	// The mod or game type
	ResultSet = ResultSet$"\\gametype\\"$Level.Game.GameName;

	// The number of players
	ResultSet = ResultSet$"\\numplayers\\"$Level.Game.NumPlayers;

	// The maximum number of players
	ResultSet = ResultSet$"\\maxplayers\\"$Level.Game.MaxPlayers;

	// The game mode: openplaying
	ResultSet = ResultSet$"\\gamemode\\openplaying";

	return ResultSet;
}

// Return a string of miscellaneous information.
// Game specific information, user defined data, custom parameters for the command line.
function string[255] GetRules()
{
	local string[255] ResultSet;

	ResultSet = "";
	Level.Game.GetRules(ResultSet);

	// Admin's Name
	if( Level.Game.GameReplicationInfo.AdminName != "" )
		ResultSet = ResultSet$"\\AdminName\\"$Level.Game.GameReplicationInfo.AdminName;
	
	// Admin's Email
	if( Level.Game.GameReplicationInfo.AdminEmail != "" )
		ResultSet = ResultSet$"\\AdminEMail\\"$Level.Game.GameReplicationInfo.AdminEmail;

	return ResultSet;
}

// Return a string of information on a player.
function string[255] GetPlayer( PlayerPawn P, int PlayerNum )
{
	local string[255] ResultSet;

	// Name
	ResultSet = "\\player_"$PlayerNum$"\\"$P.PlayerReplicationInfo.PlayerName;

	// Frags
	ResultSet = ResultSet$"\\frags_"$PlayerNum$"\\"$int(P.PlayerReplicationInfo.Score);

	// Ping
	ResultSet = ResultSet$"\\ping_"$PlayerNum$"\\"$P.ConsoleCommand("GETPING");

	// Team
	ResultSet = ResultSet$"\\team_"$PlayerNum$"\\"$P.PlayerReplicationInfo.Team;

	// Skin
	ResultSet = ResultSet$"\\skin_"$PlayerNum$"\\"$P.Skin;

	// Mesh
	ResultSet = ResultSet$"\\mesh_"$PlayerNum$"\\"$P.Mesh;

	// Time Playing

	return ResultSet;
}

// Send data for each player
function bool SendPlayers(IpAddr Addr, int QueryNum, out int PacketNum, string[32] FinalPacket)
{
	local Pawn P;
	local int i;
	local bool Result, SendResult;
	
	Result = false;

	P = Level.PawnList;
	while( i < Level.Game.NumPlayers )
	{
		if (P.IsA('PlayerPawn'))
		{
			if( i==Level.Game.NumPlayers-1 && FinalPacket=="final" )
				SendResult = SendQueryPacket(Addr, GetPlayer(PlayerPawn(P), i), QueryNum, ++PacketNum, "final");
			else
				SendResult = SendQueryPacket(Addr, GetPlayer(PlayerPawn(P), i), QueryNum, ++PacketNum, "");
			Result = SendResult || Result;
			i++;
		}
		P = P.nextPawn;
	}

	return Result;
}

// Get an arbitrary property from the level object.
function string[255] GetLevelProperty(string[255] Prop)
{
	local string[255] ResultSet;
	
	ResultSet = "\\"$Prop$"\\"$Level.GetPropertyText(Prop);
	
	return ResultSet;
}

// Get an arbitrary property from the game object.
function string[255] GetGameProperty(string[255] Prop)
{
	local string[255] ResultSet;

	ResultSet = "\\"$Prop$"\\"$Level.Game.GetPropertyText(Prop);
	
	return ResultSet;
}

// Get an arbitrary property from the players.
function string[255] GetPlayerProperty(string[255] Prop)
{
	local string[255] ResultSet;
	local int i;
	local PlayerPawn P;

	foreach AllActors(class'PlayerPawn', P) {
		i++;
		ResultSet = ResultSet$"\\"$Prop$"_"$i$"\\"$P.GetPropertyText(Prop);
	}
	
	return ResultSet;
}

defaultproperties
{
     QueryName=MasterUplink
}
