//=============================================================================
// JazzWeapon.
//=============================================================================
class JazzWeapon expands Weapon;

// Orb Weapon Types
//
var 	name	OrbSubState;	// Secondary state type called for 'NormalFire'

// Weapon power level - standard
//
var 	travel int		CurrentPowerLevel;		// Base power level is 0
var		travel float	CurrentExperience;		// Experience level of item
var() 	int				MaxPowerLevel;			// Maximum power level to stop at
var()	int				ExperienceNeeded[8];	// Experience points needed to go to certain level
var()	string		FireButtonDesc;			// Weapon name for main fire button
var()	string		AltFireButtonDesc;		// Weapon name for secondary fire button

var()	class			NormalWeaponCell;		// Automatically give this cell to pawn
var()	bool			bCanHaveMultipleCopies;	// Can Jazz pick this up again when already in Inventory?

// Weapon Type (determines the group of weaponry to use)
//
// See Pickup.JazzInventoryItem.JazzWeaponCell DetectWeapon() for details.
//
// No weapon ......	0	: None
// Jazz's weapon .. 1	: Inventory.Weapon.JazzWeapon.JackrabbitGun
// Spaz's weapon .. 2	: Not implemented yet
// Eva's weapon ... 3	: Eva Removed from game
// Lori's weapon .. 4	: Not implemented yet
// Electro Shiv.... 5   : Inventory.Weapon.JazzWeapon.ElectroShiv
// 
var()	int				WeaponTypeNumber;

// Inventory cell list
//
var	Inventory 	CurrentSelection;
var	Inventory 	Inv;
var	Inventory 	InventoryItems[20];
var	int			InventoryItemListNum;
var	int			InventoryItemSelect;

///////////////////////////////////////////////////////////////////////////////////////
// Override function for weapon effectiveness rating
//
function Weapon RecommendWeapon( out float rating, out int bUseAltMode )
{
	// Override this in subclasses of JazzWeapon.  This is a null item which should not
	// exist.
	
	if ((JazzPawnAI(Owner).Weapon==None) || (JazzPawnAI(Owner).Weapon.AIRating<AIRating))
	{
		//Log("Inventory) Switch "$Owner$" to weapon "$Self);
		// Switch to this weapon
		JazzPawnAI(Owner).Weapon = Self;
	}

	if ( inventory != None )
		return inventory.RecommendWeapon(rating, bUseAltMode);
	else
	{
		rating = -1;
		return None;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Weapon Powerup													WEAPON POWERUP
///////////////////////////////////////////////////////////////////////////////////////////////
//
function AddPowerLevel ()
{
	if (JazzPlayer(Owner).InventorySelections[0] != None)
	{
		JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).AddPowerLevel();
	}
/*	else
	{
		CurrentPowerLevel++;
		if (CurrentPowerLevel>MaxPowerLevel) 
			CurrentPowerLevel = MaxPowerLevel;
	}*/
}

function int ExperienceNeededNext ()
{
	if (CurrentPowerLevel==MaxPowerLevel)
	return (9999);
	else
	return (ExperienceNeeded[CurrentPowerLevel]);
}

function AddWeaponExperience ( int XP )
{
	if (JazzPlayer(Owner).InventorySelections[0] != None)
	{
		JazzWeaponCell(JazzPlayer(Owner).InventorySelections[0]).AddWeaponExperience(XP);
	}
/*	else
	{
		CurrentExperience += XP;

		if ((CurrentExperience >= ExperienceNeeded[CurrentPowerLevel]) &&
		    (CurrentPowerLevel < MaxPowerLevel))
		{
			// Level Up
			spawn(class'JazzWeaponLevelUp',Owner);
			
			CurrentExperience -= ExperienceNeeded[CurrentPowerLevel];
			CurrentPowerLevel++;
			
			// Send event message to player
			JazzPlayer(Owner).DoEvent(1,20,PickupMessage$": LEVEL "$CurrentPowerLevel);
		}
	}*/
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Firing Code																WEAPON
///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Weapon cells will now be self-contained firing systems which have all the code necessary to
// perform fire and alt-fire sequences for the various attacks.  Base firing functions that can
// be used for all the cells should be placed here, as well as base functions that are meant to
// be overridden.
//
// Todo: Must check for which weapon is being used and switch to different firing code.	(Owner.Weapon class)
//
//

// Fire projectile
//
function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z, OwnerVel;
	local Projectile da;
	local int OffsetMax;
	local rotator AdjustedAim;
	
	//Log("Projectile Fire) "$Owner$" "$ProjClass$" "$Rotation$" "$Owner.Rotation);

	GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	
	Start = Owner.Location + /*CalcDrawOffset() +*/ FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, (3.5*FRand()-1<1));
	AdjustedAim.Yaw += (frand()*AimError)-AimError/2;
	AdjustedAim.Pitch += (frand()*AimError)-AimError/2;
	
	da = Spawn(ProjClass,,,Start,AdjustedAim);
	
	Owner.MakeNoise(Pawn(Owner).SoundDampening);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Base function to detect the weapon in use.  Each weapon is given a # corresponding to its type.
//
// No weapon ......	0	: None
// Jazz's weapon .. 1	: Inventory.Weapon.JazzWeapon.JackrabbitGun
// Spaz's weapon .. 2	: Not implemented yet
// Eva's weapon ... 3	: Not implemented yet
// Lori's weapon .. 4	: Not implemented yet
// 
//
function int DetectWeapon()
{
	if (Pawn(Owner).Weapon == None)
	return (0);
	else
	return (JazzWeapon(Pawn(Owner).Weapon).WeaponTypeNumber);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Continue weapon firing
//
function CheckContinueFire ()
{
	GotoState('Idle');
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Function called when player has first pressed fire.
//
function Fire( float Value )	// Change DoFire instead
{
	GotoState('FireState');
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Function called when player has first pressed alt-fire.
//
function AltFire( float Value )	// Change DoAltFire
{
	GotoState('AltFireState');
}

// State when fire is active with no base weapon type
//
state FireState				// Jazz Jackrabbit's Weapon
{
ignores Fire,AltFire;		// Ignore Fire or AltFire commands while currently firing.

Begin:
	// Perform actual firing here
	
	// Return to idle state after fire sequence is done and button not held down.
	CheckContinueFire();
}

// State when fire is active
//
state AltFireState			// Jazz Jackrabbit's Weapon
{
ignores Fire,AltFire;		// Ignore Fire or AltFire commands while currently firing.

Begin:
	// Perform actual firing here
	
	// Return to idle state after fire sequence is done and button not held down.
	CheckContinueFire();
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// State when inactive
///////////////////////////////////////////////////////////////////////////////////////////////////
//
state Idle
{
Begin:
/*	if (JazzPlayer(Owner) != None)
	{
		if (( JazzPlayer(Owner).bFire!=0 ) 		|| (JazzPlayer(Owner).bLeft!=0)) 	
		{ 
		Fire(0);
		}
		
		if (( JazzPlayer(Owner).bAltFire!=0 ) 	|| (JazzPlayer(Owner).bRight!=0)) 	
		AltFire(0);
	}*/
	
DeSelected:

}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Weapon Select / Deselect
///////////////////////////////////////////////////////////////////////////////////////////////////
//
function SelectWeapon()
{
	ChangeCell(0);
}

function DeSelectWeapon()
{
	GotoState('Idle','DeSelected');
}


// Ignore old Finish() function.
//
function Finish()
{
	GotoState('Idle');
}


// When a weapon is added to a character, add the normal cell as well for that player.
//
/*function GiveTo( pawn Other )
{
	Super.GiveTo(Other);
	
	AddDefaultNormalCell(Other);
}*/

//
// Advanced function which lets existing items in a pawn's inventory
// prevent the pawn from picking something up. Return true to abort pickup
// or if item handles the pickup
//
/*function bool HandlePickupQuery( inventory Item )
{
	//Log("WeaponPickup) "$Self$" "$Owner);

	Super.HandlePickupQuery(Item);
}*/
function bool HandlePickupQuery( inventory Item )
{
	if (item.class == class) 
	{
		if (bCanHaveMultipleCopies) 
		{   
			// Handle pickup when we already have the item.
			Item.PlaySound (Item.PickupSound,,2.0);
			Item.SetRespawn();
		}
		else
		{		
		}
		return true;	// Cannot pick item up.
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

//=============================================================================
// Pickup state: this inventory item is sitting on the ground.

auto state Pickup
{
	// When touched by an actor.
	function Touch( actor Other )
	{
		if (Other==None) return;
	
		// If touched by a player pawn, let him pick this up.
		if( ValidTouch(Other) )
		{
			SpawnCopy(Pawn(Other));
			Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
			PlaySound (PickupSound);		
			if ( Level.Game.Difficulty > 1 )
				Other.MakeNoise(0.1 * Level.Game.Difficulty);	
				
			if (JazzPlayer(Owner) != None)
			{
			// Tutorial Command
			JazzPlayer(Owner).TutorialCheck(TutorialGetWeapon);
			}
		}
	}
}

function AddDefaultNormalCell ( pawn Other )
{
	local JazzWeaponCell C;

	if (NormalWeaponCell != None)
	{
	// IMPORTANT!
	// Todo: Check for this cell already in inventory.
	
	C = JazzWeaponCell(spawn(class<actor>(NormalWeaponCell)));
	Log("AddNormalWeaponCell) "$C$" to "$Other);
	C.SetOwner(Other);
	C.GiveTo(Other);
	C.Mesh = None;

	// Set other's inventory selection [0] to this new cell
	if (JazzPawn(Other) != None)
	{
	if (JazzPawn(Other).InventorySelections[0]==None)
	JazzPawn(Other).InventorySelections[0]=C;
	}
	else
	if (JazzPlayer(Other) != None)
	{
	if (JazzPlayer(Other).InventorySelections[0]==None)
	JazzPlayer(Other).InventorySelections[0]=C;
	}
	
	//ChangeCell(0);
	}
}

// Players have GiveAmmo called instead of 'GiveTo'.  Dunno why it's done differently.
//
function GiveAmmo( Pawn Other )
{
	AddDefaultNormalcell(Other);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Cell Selection Functions
///////////////////////////////////////////////////////////////////////////////////////////////////
//
// This was originally in JazzPlayer and JazzHud but has been moved here to centralize the code
// where it's actually used.
//

function ExtractCellList ()
{
	local bool	ValidCell;

	// Get current cell in use
	//
	InventoryItemSelect = 0;
	if (JazzPlayer(Owner) != None)
	{
	CurrentSelection = JazzPlayer(Owner).InventorySelections[0];
	}
	else
	{
	CurrentSelection = JazzPawn(Owner).InventorySelections[0];
	}
	
	// Looking For Matching Weapon Type - InventoryGroup variable
	InventoryItemListNum = -1;
	
	// Extract items
	//
	Inv = Owner.Inventory;
		
	while (Inv != None)
	{
		ValidCell = true;
		if (JazzWeaponCell(Inv) != None)
		{
			//Log("ValidCall) "$Self$" "$JazzWeaponCell(Inv)$" "$JazzWeapon(PlayerPawn(Owner).Weapon).WeaponTypeNumber$" "$PlayerPawn(Owner).Weapon);
			if (JazzWeaponCell(Inv).WeaponCapable[JazzWeapon(PlayerPawn(Owner).Weapon).WeaponTypeNumber]==0)
			ValidCell = false;
		}
	
		if ((Inv.InventoryGroup == 10) && (ValidCell))
		{
			InventoryItemListNum++;
			InventoryItems[InventoryItemListNum]=Inv;
			
			if (Inv==CurrentSelection)
				InventoryItemSelect = InventoryItemListNum;
		}
		Inv = Inv.Inventory;
	}
}

// Move up/down in cell list for next/prev cell commands.
//
function ChangeCell( int Change )
{
	// -1 previous
	// 1 next
	
	// Get List of Weapons (including main weapon)
	//
	ExtractCellList();
	
	if (InventoryItemListNum<0)
	{
		AddDefaultNormalCell(Pawn(Owner));
		ExtractCellList();
	}

	// Deselect current cell.
	JazzWeaponCell(CurrentSelection).DeSelectWeapon();

	// Change selection #.
	InventoryItemSelect += Change;
	if (InventoryItemSelect<0) 						InventoryItemSelect = InventoryItemListNum;
	if (InventoryItemSelect>InventoryItemListNum) 	InventoryItemSelect = 0;
	
	//Log("ChangeCell) Select:"$InventoryItemSelect$" "$InventoryItems[InventoryItemSelect]$" "$InventoryItemListNum);
	//Log("ChangeCell) Self:"$Self);

	// Set new selection in player/pawn.
	//	
	CurrentSelection = InventoryItems[InventoryItemSelect];
	JazzWeaponCell(CurrentSelection).SelectWeapon();
	
	//Log("ChangeCell) "$InventoryItems[InventoryItemSelect]$" "$InventoryItemListNum);
	
	if (JazzPlayer(Owner) != None)
	{
	JazzPlayer(Owner).InventorySelections[0]=InventoryItems[InventoryItemSelect];
	}
	else
	{
	JazzPawn(Owner).InventorySelections[0]=InventoryItems[InventoryItemSelect];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Weapon Selection Functions
///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Select a different weapon.
//

// Extract list of weapons available to the player class.
//
function ExtractWeaponList ()
{
	local bool	ValidWeapon;

	// Deselect current weapon
	InventoryItemSelect = 0;
	if (JazzPlayer(Owner) != None)
	{
	CurrentSelection = JazzPlayer(Owner).Weapon;
	}
	else
	{
	CurrentSelection = JazzPawn(Owner).Weapon;
	}
	
	// Looking For Matching Weapon Type - InventoryGroup variable
	InventoryItemListNum = -1;
	
	// Extract items
	//
	Inv = Owner.Inventory;
		
	while (Inv != None)
	{
		ValidWeapon = true;
		/*if (JazzWeaponCell(Inv) != None)
		{
			if (JazzWeaponCell(Inv).WeaponCapable[JazzWeapon(PlayerPawn(Owner).Weapon).WeaponTypeNumber]==0)
			ValidCell = false;
		}*/

		if ((Inv.InventoryGroup == 11) && (ValidWeapon))
		{
			InventoryItemListNum++;
			InventoryItems[InventoryItemListNum]=Inv;
			
			if (Inv==CurrentSelection)
				InventoryItemSelect = InventoryItemListNum;
		}
		Inv = Inv.Inventory;
	}
}

// Move up/down in weapon list for next/prev weapon commands.
//
function ChangeWeapon( int Change )
{
	// -1 previous
	// 1 next
	
	// Get List of Weapons (including main weapon)
	//
	ExtractWeaponList();
	
	// Deselect current weapon.  (Which is self, actually.)
	DeSelectWeapon();

	// Change selection #.
	InventoryItemSelect += Change;
	if (InventoryItemSelect<0) 						InventoryItemSelect = InventoryItemListNum;
	if (InventoryItemSelect>InventoryItemListNum) 	InventoryItemSelect = 0;
	
	//Log("WeaponSelect) "$InventoryItemSelect$" "$InventoryItems[InventoryItemSelect]$" "$InventoryItemListNum);
	
	// Set new selection in player/pawn.
	//	
	Pawn(Owner).Weapon=Weapon(InventoryItems[InventoryItemSelect]);
	JazzWeapon(Pawn(Owner).Weapon).SelectWeapon();
}

//
//
function TweenDown()
{

}

function TweenSelect()
{

}

function PlaySelect()
{

}

// Animations
//
function WeaponAnimationNormal();

event AnimEnd()
{
	PlayAnim('WeapIdle');
}

function BeginPlay()
{
	Super.BeginPlay();
}


//	Log("Hello I have been spawned) "$Self$" "$Owner$" "$Pawn(Owner).Weapon);
//	AddDefaultNormalCell(Pawn(Owner));

defaultproperties
{
     InventoryGroup=11
     PickupSound=Sound'JazzSounds.Items.item4'
}
