//=============================================================================
// JazzFixedCamera.
//=============================================================================
class JazzFixedCamera expands NavigationPoint;

//
// Fixed Camera Point
//
// Place this actor somewhere in a level.  If it sees a player, it will use this camera start
// location instead of the normal camera system.
//

//
// A master camera takes precedence over any secondary cameras that may also be visible.  Keep in
// mind that a master camera may conflict with another master camera.  That's why secondary
// cameras should be used anywhere near a master camera instead.  The most important view should
// be the master.
//
//
var()	bool	MasterCamera;
var()	float	DistanceLoss;		// Not implemented - Intended to be maximum range camera will follow

defaultproperties
{
     Texture=Texture'Engine.S_Weapon'
}
