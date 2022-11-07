//=============================================================================
// JazzWeaponPower.
//=============================================================================
class JazzWeaponPower expands Pickup;

var() int	Value;

var(SpecialItem)	string		ItemName;

//
// Do not use this item.  It is old and pending deletion.
//

//
// Note for inventory items:  Pickup message is now the item name
//

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
}

// Main Pickup State
//
auto state Pickup
{
	function Touch( actor Other )
	{
		if ( ValidTouch(Other) )
		{
			SpawnCopy(Pawn(Other));
			// No pickup message
			PlaySound (PickupSound);
			if ( Level.Game.Difficulty > 1 )
				Other.MakeNoise(0.1 * Level.Game.Difficulty);		
			SetOwner(Other);
			GotoState('DisplayNewItem');
		}
	}
}

// Override for specific carrot effect on player/pickupperson as 'Other'
//
// Pickup sound is in (Inventory) section of the actor properties.
//
function DoPickupEffect( pawn Other )
{
	JazzPlayer(Other).Carrots += Value;
}

state DisplayNewItem
{
}

defaultproperties
{
     ItemName="H2O POWERPACK"
     InventoryGroup=10
     PickupMessage="Water Power"
     PlayerViewMesh=Mesh'UnrealI.Moon1'
     PlayerViewScale=0.300000
     PickupViewMesh=Mesh'UnrealI.Moon1'
     PickupViewScale=0.300000
     PickupSound=Sound'JazzSounds.Items.item2'
     Style=STY_None
     Skin=WetTexture'Liquids.liquid3'
     Mesh=Mesh'UnrealI.Moon1'
     DrawScale=0.200000
}
