//=============================================================================
// TreasureChest.
//=============================================================================
class TreasureChest expands ItemContainer;

// Item Container opened by trigger
//
function OpenTrigger ()
{
	if (!Open)
	{
		ReleaseAll();
	
		// Open animation
		//
		PlayAnim('ChestOpen');
		Open = true;
	}
}

// Item Container opened by shooting/attacking
//
function OpenDestroy ()
{
	OpenTrigger();
}

defaultproperties
{
     Health=20
     Release=REL_Left
     ActivationObject=True
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.JChest1_01'
     Mesh=Mesh'JazzObjectoids.Chest1'
     DrawScale=1.500000
     CollisionRadius=40.000000
     CollisionHeight=35.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
