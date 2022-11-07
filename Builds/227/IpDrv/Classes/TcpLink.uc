//=============================================================================
// TcpLink: An Internet TCP/IP connection.
//=============================================================================
class TcpLink expands InternetLink
	intrinsic
	transient;

//-----------------------------------------------------------------------------
// Variables.

// LinkState is only valid for TcpLink at this time.
var enum ELinkState
{
	STATE_Initialized,	// Sockets is initialized
	STATE_Ready,		// Port bound, ready for activity
	STATE_Listening,	// Listening for connections
	STATE_Connecting,	// Attempting to connect
	STATE_Connected,	// Open and connected
} LinkState;

var IpAddr	  RemoteAddr;	// Contains address of peer connected to from a Listen()

//-----------------------------------------------------------------------------
// Intrinsics.

// BindPort: Binds a free port or optional port specified in argument one.
intrinsic function bool BindPort( optional int Port, optional bool bUseNextAvailable );

// Listen: Listen for connections.  Can handle up to 5 simultaneous connections.
// Returns false if failed to place socket in listen mode.
intrinsic function bool Listen();

// Open: Open a connection to a foreign host.
intrinsic function bool Open( IpAddr Addr );

// Close: Closes the current connection.   
intrinsic function bool Close();

// IsConnected: Returns true if connected.
intrinsic function bool IsConnected();

// SendText: Sends text string. 
// Appends a cr/lf if LinkMode=MODE_Line.  Returns number of bytes sent.
intrinsic function int SendText( coerce string[255] Str );

// SendBinary: Send data as a byte array.
intrinsic function int SendBinary( int Count, byte B[255] );

// ReadText: Reads text string.
// Returns number of bytes read.  
intrinsic function int ReadText( out string[255] Str );

// ReadBinary: Read data as a byte array.
intrinsic function int ReadBinary( int Count, out byte B[255] );

//-----------------------------------------------------------------------------
// Events.

// Accepted: Called during STATE_Listening when a new connection is accepted.
event Accepted();

// Opened: Called when socket successfully connects.
event Opened();

// Closed: Called when Close() completes or the connection is dropped.
event Closed();

// ReceivedText: Called when data is received and connection mode is MODE_Text.
event ReceivedText( string[255] Text );

// ReceivedLine: Called when data is received and connection mode is MODE_Line.
event ReceivedLine( string[255] Line );

// ReceivedBinary: Called when data is received and connection mode is MODE_Binary.
event ReceivedBinary( int Count, byte B[255] );

defaultproperties
{
     bAlwaysTick=True
}
