//=============================================================================
// CameraZone.
//=============================================================================
class CameraZone expands ZoneInfo;

var() enum		CameraFacingType		// Select the basic function of the camera.
{
	CAM_Above
} CameraFacing;

var() float		CameraDistance;			// Distance the camera is from the player in world units.

var() bool		CameraFixedYaw;			// If this is set to true, the camera will never turn
										// and the yaw (horizontal rotation) will always equal
										// the value in CameraRotation.  Only a top view will
										// really work with this setting, though.
										
var() rotator	CameraRotation;			// Rotate the camera in any direction from the
										// CameraFacing direction.  (Allows for manual tweaking
										// to make it a little tilted or whatnot.)

defaultproperties
{
}
