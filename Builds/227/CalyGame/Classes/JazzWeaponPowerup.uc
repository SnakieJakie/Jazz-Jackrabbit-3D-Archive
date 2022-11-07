//=============================================================================
// JazzWeaponPowerUp.
//=============================================================================
class JazzWeaponPowerUp expands JazzPickupItem;

var() int	ItemWeaponExperience;


// Override for specific carrot effect on player/pickupperson as 'Other'
//
// Pickup sound is in (Inventory) section of the actor properties.
//
function DoPickupEffect( pawn Other )
{
	local JazzMoveControl C;
	local SingleSparklies P;

	//Log("Powerup) Pickup Effect");
	
	PlaySound (PickupSound,,2.5);
			
	if (JazzPlayer(Other) != None)
	{
		JazzPlayer(Other).AddWeaponExperience(ItemWeaponExperience);
		JazzPlayer(Other).UpdateCarrot();
	}
	
	// Send particle from the player to the box
	//
/*	P = spawn(class'SingleSparklies');
	P.MaxLifeSpan = 0;
	P.LifeSpan = 0;
	
	C = spawn(class'JazzMoveControl',Other);
	C.Start(P,vect(0,0,0),Self.Location,true,false);*/
	
	Super.DoPickupEffect(Other);
}


function PreBeginPlay()
{
	PickupDelay = 0.5;	// Default is 1 second for non-specified items
}


////////////////////////////////////////////////////////////////////////////////////////
// Desirability of the Item
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesireability( pawn Bot )
{
	return (30);	// This is pretty desirable.
}

defaultproperties
{
     ItemWeaponExperience=50
     RespawnTime=30.000000
     PickupViewMesh=Mesh'JazzObjectoids.powerup1'
     PickupSound=Sound'JazzSounds.Items.item4'
     Texture=None
     Mesh=Mesh'JazzObjectoids.powerup1'
     DrawScale=0.500000
     LightType=LT_Steady
     LightBrightness=153
     LightHue=51
     LightRadius=5
}
