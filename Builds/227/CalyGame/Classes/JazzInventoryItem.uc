//=============================================================================
// JazzInventoryItem.
//=============================================================================
class JazzInventoryItem expands JazzItem;

//
// Base class for items that go into the player's inventory.
//
//
var(JazzInventory)	string		ItemName;

//
// Become an inventory item.
//
function NewItemDisplay()
{
	local NewInventoryDisplay	Inv;
	Inv = spawn(class'NewInventoryDisplay',Instigator);
	Inv.DrawScale = DrawScale;
	Inv.DrawType = DrawType;
	Inv.AmbientGlow = AmbientGlow;
	Inv.AnimSequence = AnimSequence;
	Inv.AnimRate = AnimRate;
	Inv.AnimFrame = AnimFrame;
	Inv.Skin = Skin;
	Inv.Sprite = Sprite;
	Inv.Mesh = Mesh;
	Inv.ItemName = ItemName;
	
	//Inv.SetOwner(Instigator);
	//Inv.bOnlyOwnerSee = true;
}

function BecomeItem()
{
	NewItemDisplay();

	RemoteRole    = ROLE_DumbProxy;
	Mesh          = PlayerViewMesh;
	DrawScale     = PlayerViewScale;
	bOnlyOwnerSee = false;
	bHidden       = true;
	NetPriority   = 2;
	SetCollision( false, false, false );
	SetPhysics(PHYS_None);
	SetTimer(0.0,False);
	AmbientGlow = 0;

	// Location must be 	
	SetLocation(vect(-65535,-65535,-65535));
}

// Main Pickup State
// 
auto state Pickup
{	
	// Validate touch, and if valid trigger event.
	function bool ValidTouch( actor Other )
	{
		local Actor A;
		
		if( Pawn(Other)!=None && Level.Game.PickupQuery(Pawn(Other), self) )
		{
			return true;
		}
		return false;
	}

/*	function Touch( actor Other )
	{
		local Inventory Copy;
		if ( ValidTouch(Other) ) 
		{
			Copy = SpawnCopy(Pawn(Other));
			//Pawn(Other).ClientMessage(PickupMessage);
			PlaySound (PickupSound);		
			if ( Level.Game.Difficulty > 1 )
				Other.MakeNoise(0.1 * Level.Game.Difficulty);		
			SetOwner(Other);
			
			if (JazzPlayer(Other) != None)
			{
				JazzPlayer(Other).NewInventoryItem();
			}
			
			DoPickupEffect(Pawn(Other));
		}
	}*/
}

// Override for specific carrot effect on player/pickupperson as 'Other'
//
// Pickup sound is in (Inventory) section of the actor properties.
//
function PickupFunction( pawn Other )
{
	Super.PickupFunction(Other);
	
	AddScore(Other);
}

state DisplayNewItem
{
}

////////////////////////////////////////////////////////////////////////////////////////
// Base function that determines the desirability of an item for a 'bot' (Thinker)
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesirability( pawn Bot )
{
	return (-1);	// Default Item type is totally undesirable - Override this function to create desirable item
}

defaultproperties
{
}
