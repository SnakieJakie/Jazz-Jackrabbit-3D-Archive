//=============================================================================
// InternetLink: Parent class for Internet connection classes
//=============================================================================
class InternetLink expands InternetInfo
	intrinsic
	transient;

//-----------------------------------------------------------------------------
// Types & Variables.

// An IP address.
struct IpAddr
{
	var int Addr;
	var int Port;
};

// Data receive mode.
// Cannot be set in default properties.
var enum ELinkMode
{
	MODE_Text, 
	MODE_Line,
	MODE_Binary
} LinkMode;

// Internal
var	const int Socket;
var const int Port;
var	const int RemoteSocket;
var private intrinsic const int PrivateResolveInfo;
var const int DataPending;

// Receive mode.
// If mode is MODE_Manual, received events will not be called.
// This means it is your responsibility to check the DataPending
// var and receive the data.
// Cannot be set in default properties.
var enum EReceiveMode
{
	RMODE_Manual,
	RMODE_Event
} ReceiveMode;

//-----------------------------------------------------------------------------
// Intrinsics

// IsDataPending: Returns true if data is pending on the socket.
intrinsic function bool IsDataPending();

// ParseURL: Parses an Unreal URL into its component elements.
// Returns false if the URL was invalid.
intrinsic function bool ParseURL
(
	coerce string[64] URL, 
	out string[64] Addr, 
	out int Port, 
	out string[64] LevelName,
	out string[64] EntryName
);

// Resolve: Resolve a domain or dotted IP.
// Nonblocking operation.  
// Triggers Resolved event if successful.
// Triggers ResolveFailed event if unsuccessful.
intrinsic function Resolve( coerce string[128] Domain );

// Returns most recent winsock error.
intrinsic function int GetLastError();

// Convert an IP address to a string.
intrinsic function string[64] IpAddrToString( IpAddr Arg );

//-----------------------------------------------------------------------------
// Events.

// Resolved: Called when domain resolution is successful.
// The IpAddr struct Addr contains the valid address.
event Resolved( IpAddr Addr );

// ResolveFailed: Called when domain resolution fails.
event ResolveFailed();

defaultproperties
{
}
