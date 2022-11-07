//=============================================================================
// InventorySpot.
//=============================================================================
class InventorySpot expands NavigationPoint
	intrinsic;

var Inventory markedItem;

defaultproperties
{
     bEndPointOnly=True
     bHiddenEd=True
     bCollideWhenPlacing=False
     CollisionRadius=20.000000
     CollisionHeight=40.000000
}
