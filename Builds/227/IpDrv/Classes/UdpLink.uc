//=============================================================================
// UdpLink: An Internet UDP connectionless socket.
//=============================================================================
class UdpLink expands InternetLink
	intrinsic
	transient;

//-----------------------------------------------------------------------------
// Variables.

var() const int BroadcastAddr;

//-----------------------------------------------------------------------------
// Intrinsics.

// BindPort: Binds a free port or optional port specified in argument one.
intrinsic function bool BindPort( optional int Port, optional bool bUseNextAvailable );

// SendText: Sends text string.  
// Appends a cr/lf if LinkMode=MODE_Line .
intrinsic function bool SendText( IpAddr Addr, coerce string[255] Str );

// SendBinary: Send data as a byte array.
intrinsic function bool SendBinary( IpAddr Addr, int Count, byte B[255] );

// ReadText: Reads text string.
// Returns number of bytes read.  
intrinsic function int ReadText( out IpAddr Addr, out string[255] Str );

// ReadBinary: Read data as a byte array.
intrinsic function int ReadBinary( out IpAddr Addr, int Count, out byte B[255] );

// ParseNextQuery: Takes a query string Text and outputs the first key/value
// pair as QueryType/QueryValue respectively.  Also outputs QueryRest, which is
// the remaining query minus the parsed key/value pair, and final a string
// indicating whether or not the key/value pair is the last in the query.
// If final is a null string, then it is not the last valid key/value pair.
intrinsic function bool ParseNextQuery( string[255] Text, out string[255] QueryType, out string[255] QueryValue, out string[255] QueryRest, out string[32] FinalPacket ); 

// Validate: Takes a challenge string and returns an encoded validation string.
intrinsic function string[128] Validate( string[128] ValidationString );

//-----------------------------------------------------------------------------
// Events.

// ReceivedText: Called when data is received and connection mode is MODE_Text.
event ReceivedText( IpAddr Addr, string[255] Text );

// ReceivedLine: Called when data is received and connection mode is MODE_Line.
event ReceivedLine( IpAddr Addr, string[255] Line );

// ReceivedBinary: Called when data is received and connection mode is MODE_Binary.
event ReceivedBinary( IpAddr Addr, int Count, byte B[255] );

defaultproperties
{
     BroadcastAddr=-1
     bAlwaysTick=True
}
