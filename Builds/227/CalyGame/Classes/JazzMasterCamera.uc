//=============================================================================
// JazzMasterCamera.
//=============================================================================
class JazzMasterCamera expands JazzFixedCamera;

//
// Usage:
// Master fixed cameras take precedence over normal JazzFixedCameras.
//
// Use this camera when you want it to override other fixed camera placements in the level.
//

defaultproperties
{
     MasterCamera=True
}
