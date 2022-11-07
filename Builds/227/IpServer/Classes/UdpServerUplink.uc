//=============================================================================
// UdpServerUplink
//
// Version: 1.3
//
// This uplink is compliant with the GameSpy Uplink Specification.
// The specification is available at http://www.gamespy.com/developer
// and might be of use to progammers who want to adapt their own
// server uplinks.
//
// UdpServerUplink sends a heartbeat to the specified master server
// every five minutes.  The heartbeat is in the form:
//    \heartbeat\QueryPort\gamename\unreal
//
// Full documentation on this class is available at http://unreal.epicgames.com/
//
//=============================================================================
class UdpServerUplink expands UdpLink config;

// Master Uplink Config.
var() config bool		DoUplink;				// If true, do the uplink
var() config int		UpdateMinutes;			// Period of update (in minutes)
var() config string[64] MasterServerAddress;	// Address of the master server
var() config int		MasterServerPort;		// Optional port that the master server is listening on
var() config int 		Region;					// Region of the game server
var() name				TargetQueryName;		// Name of the query server object to use.
var IpAddr				MasterServerIpAddr;		// Master server's address.
var string[128]		    HeartbeatMessage;		// The message that is sent to the master server.
var UdpServerQuery      Query;					// The query object.

// Initialize.
function PreBeginPlay()
{
	// If master server uplink isn't wanted, exit.
	if( !DoUplink )
	{
		Log("DoUplink is not set.  Not connecting to GameSpy.");
		return;
	}

	// Find a the server query handler.
	foreach AllActors(class'UdpServerQuery', Query, TargetQueryName)
		break;

	if( Query==None )
	{
		Log("UdpServerUplink: Could not find a UdpServerQuery object, aborting.");
		return;
	}
	Log("UdpServerUplink: Using QueryPort "$Query.Port);

	// Set heartbeat message.
	HeartbeatMessage = "\\heartbeat\\"$Query.Port$"\\gamename\\unreal";

	// Set the Port.
	MasterServerIpAddr.Port = MasterServerPort;

	// Resolve the Address.
	if( MasterServerAddress=="" )
		MasterServerAddress = "master"$Region$".gamespy.com";
	Resolve( MasterServerAddress );
}

// When master server address is resolved.
function Resolved( IpAddr Addr )
{
	local bool Result;

	// Set the address
	MasterServerIpAddr.Addr = Addr.Addr;

	// Handle failure.
	if( MasterServerIpAddr.Addr == 0 )
	{
		Log("UdpServerUplink: Invalid master server address, aborting.");
		return;
	}

	// Display success message.
	Log("UdpServerUplink: Master Server is "$MasterServerAddress$":"$MasterServerIpAddr.Port);
	
	// Bind the local port.
	if( !BindPort(Query.GetServerPort(),true) )
	{
		Log( "UdpServerUplink: Error binding port, aborting." );
		return;
	}

	// Start transmitting.
	Result = SendText( MasterServerIpAddr, HeartbeatMessage );
	if ( !Result )
		Log( "Failed to send heartbeat to master server.");
	Resume();
}

// Host resolution failue.
function ResolveFailed()
{
	Log("UdpServerUplink: Failed to resolve master server address, aborting.");
}

// Notify the MasterServer we exist.
function Timer()
{
	local bool Result;

	Result = SendText( MasterServerIpAddr, HeartbeatMessage );
	if ( !Result )
		Log( "Failed to send heartbeat to master server.");
}

// Stop the uplink.
function Halt()
{
	Log("UdpServerUplink: Halting by request.");
	SetTimer(0.0, false);
}

// Resume the uplink.
function Resume()
{
	Log("UdpServerUplink: Resuming by request.");
	SetTimer(UpdateMinutes * 60, true);
	Timer();
}

defaultproperties
{
     UpdateMinutes=1
     MasterServerPort=27900
     TargetQueryName=MasterUplink
}
