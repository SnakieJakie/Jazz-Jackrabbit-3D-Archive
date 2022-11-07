//=============================================================================
// InternetInfo: Parent class for Internet connection classes
//=============================================================================
class InternetInfo expands Info
	intrinsic
	transient;

function string[255] GetBeaconAddress( int i );
function String[255] GetBeaconText(int i);

defaultproperties
{
}
