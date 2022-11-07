//=============================================================================
// JazzFloatingPlatform.
//=============================================================================
class JazzFloatingPlatform expands Decoration;

// Does not work.  Fix it some time I have more patience...
//
//

/*auto state Buoy
{
	function BeginState ()
	{
		if( Region.Zone.bWaterZone && (Buoyancy > Mass) )
		{
			bBobbing = true;
			if( Buoyancy > 1.1 * Mass )
				Buoyancy = 0.95 * Buoyancy; // waterlog
			else if( Buoyancy > 1.03 * Mass )
				Buoyancy = 0.99 * Buoyancy;
		}
		
		SetPhysics(PHYS_Falling);
	}
}

*/

defaultproperties
{
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Mesh=Mesh'UnrealShare.ChestM'
     DrawScale=4.000000
     CollisionRadius=60.000000
     CollisionHeight=44.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     Mass=50.000000
     Buoyancy=60.000000
}
