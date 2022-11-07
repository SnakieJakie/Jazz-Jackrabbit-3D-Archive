//=============================================================================
// UdpBeacon: Base class of beacon sender and receiver.
//=============================================================================
class UdpBeacon expands UdpLink
	config
	transient;

var() globalconfig bool       DoBeacon;
var() globalconfig int        ServerBeaconPort;
var() globalconfig int        BeaconPort;
var() globalconfig float      BeaconTimeout;
var() globalconfig string[32] BeaconProduct;

function BeginPlay()
{
	if( BindPort(ServerBeaconPort) )
	{
		log( "ServerBeacon initialized." );
	}
	else
	{
		log( "ServerBeacon failed: Could not bind port." );
	}
	BroadcastBeacon(); // Initial notification.
}

function BroadcastBeacon()
{
	local IpAddr Addr;
	local string[240] BeaconText;

	Log( "Broadcasting Beacon" );

	Addr.Addr = BroadcastAddr;
	Addr.Port = BeaconPort;
	Level.Game.GetBeaconText( BeaconText );
	SendText( Addr, BeaconProduct $ " " $ Mid(Level.GetAddressURL(),InStr(Level.GetAddressURL(),":")+1) $ " " $ BeaconText );
}

event ReceivedText( IpAddr Addr, string[255] Text )
{
	if( Text == "REPORT" )
	{
		BroadcastBeacon();
	}
}

defaultproperties
{
     DoBeacon=True
     ServerBeaconPort=7775
     BeaconPort=7776
     BeaconTimeout=5.000000
     BeaconProduct="Unreal"
}
