//=============================================================================
// ItemRandomizer.
//=============================================================================
class ItemRandomizer expands Inventory;

var()	byte	ChanceOfNoItem;
var()	byte	ItemFrequency[10];
var()	class	Item[10];


//
// What is this?
//
// - The item randomizer class is intended to take over item creation in the event that
//   the creator wants to have a randomized item generated.  In other words, 10% of the
//   time no item, 80% of the time a health carrot, and 10% of the time a coin.
//
// - With this class, a simple change can be made to a specific item randomizer, altering
//   the item generation for every enemy using that randomizer.  Items can be added or
//   removed from the game easily, as can the difficulty of obtaining certain types of
//   items like money to tweak the balance the game.
//
// - Other actors only need to make a call to create this one, instead of handling
//   randomization in every class.
//


function PreBeginPlay()
{
	local int RandomTotal,i;
	local actor A;

	// Check for no item first.
	if (FRand()*255<ChanceOfNoItem)
	{
		// No item
		Destroy();
		return;
	}
	
	// Create Random Item
	//
	for (i=0; i<10; i++)
	{
		RandomTotal += ItemFrequency[i];
	}
	
	
	RandomTotal = FRand()*RandomTotal;
	
	if (RandomTotal>0)
	{
		for (i=0; i<10; i++)
		{
			if (RandomTotal<=ItemFrequency[i])
			{
				// Generate This Item
	
				A = spawn(class<actor>(Item[i]));
				A.Velocity = VRand()*100;
				A.Velocity.Z = 300;
				A.SetLocation(Location+vect(0,0,100));
				A.bBounce = true;
				A.SetPhysics(PHYS_Falling);
								
				if (JazzPickupItem(A) != None)
				{
				JazzPickupItem(A).NewPickupDelay();	// Set delay for pickup items to be grabbed
				}
				
				Destroy();
				return;
			}
		
			RandomTotal -= ItemFrequency[i];		
		}
	}
	
	Destroy();
}

defaultproperties
{
}
