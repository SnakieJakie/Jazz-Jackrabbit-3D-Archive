//=============================================================================
// JazzMultiPlayerMenu.
//=============================================================================
class JazzMultiPlayerMenu expands JazzMenu;

var		int		MenuSoundNum;
var()	sound	SwooshMenuInSound;
	
var string ClassString;
var string StartMap;

var() class PlayerClasses[8];

// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	ResetMenu();
}

function ResetMenu()
{
	// Plays sounds as menus move across the screen
	MenuSoundNum = 0;
	MenuExistTime = 0;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;

	ChildMenu = None;
	if ( ! bBegun )
	{
		PlayEnterSound();
		bBegun = true;
	}

	if ( Selection == 1 )
		ChildMenu = spawn(class'JazzJoinGameMenu', owner);
	else if ( Selection == 2 )
		ChildMenu = spawn(class'JazzServerMenu', owner);
	else if ( Selection == 3)
	{
		//ChildMenu = spawn(class'UnrealPlayerMenu', owner);
	}

	if ( ChildMenu != None )
	{
		// Reset Menu Movement in preparation for return to this menu
		ResetMenu();
	
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
	return true;
}
function DrawMenu (canvas Canvas)
{
	local int	i,x,MinX;
	local int	spacing,StartY;
	
	MenuStart(Canvas);
	
	DrawBackgroundA(Canvas);
	
	DrawTitle(Canvas);		// 220 Version

	TextMenuLeft(Canvas);
	
	MenuEnd(Canvas);
}

defaultproperties
{
     MenuLength=2
     MenuList(0)="JOIN SERVER"
     MenuList(1)="CREATE SERVER"
     MenuTitle="MULTIPLAYER GAME"
}
