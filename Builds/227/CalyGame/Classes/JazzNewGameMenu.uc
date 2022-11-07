//=============================================================================
// JazzNewGameMenu.
//=============================================================================
class JazzNewGameMenu expands JazzMenu;

var		int			MenuSoundNum;
var()	sound		SwooshMenuInSound;
var()	localized string	NewGameStartMap;

var		int			MenuRightSide;

// Determines what map starts a new game.
//
// This is hardcoded right now until we have the capability to edit the C code.
//
var string StartMap;


// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	StartMap = NewGameStartMap;

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

	if ( (Selection == 1) )
	{
		Level.Game.Difficulty = Selection - 1;	// Easy
		Level.Game.SaveConfig();
		ChildMenu = spawn(class'JazzCharacterSelectMenu', owner);
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
		JazzCharacterSelectMenu(ChildMenu).StartMap = StartMap;
		//JazzCharacterSelectMenu(ChildMenu).SinglePlayerOnly = true;
	}
	else 
	if ( Selection == 2 )
	{
		// Not implemented
		ChildMenu = spawn(class'JazzServerMenu', owner);
		//JazzServerMenu(ChildMenu).bStandAlone = true;
	}
	else
	if ( Selection == 3 )
	{
		ChildMenu = spawn(class'JazzMultiPlayerMenu', owner);
	}
	else
	if ( Selection == 4 )
	{
		ExitMenu();
	}
	else
		return false;

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

//
function DrawMenu (canvas Canvas)
{
	local int	i,x,y,MinX;
	local int	spacing,StartY;
	
	MenuStart(Canvas);
	
	DrawBackgroundA(Canvas);
	
	DrawTitle(Canvas);		// 220 Version

	TextMenuLeft(Canvas);

	// Draw Jazz Graphic
	// 
	y = (Canvas.ClipY - MenuExistTime*100);
	if (y<Canvas.ClipY-80)
		y = Canvas.ClipY-80;
	Canvas.Style = 3;
	Canvas.SetPos(Canvas.SizeX-120,y);
	//Canvas.DrawIcon(Texture'JazzTitle3',0.25);	// Jazz3 Texture
	
	MenuEnd(Canvas);
}

defaultproperties
{
     MenuSelectSound=Sound'JazzSounds.Interface.menuhit'
     MenuEnterSound=Sound'JazzSounds.Interface.menuhit'
     MenuModifySound=Sound'JazzSounds.Interface.menuhit'
     MenuLength=4
     MenuTitle="NEW GAME"
}
