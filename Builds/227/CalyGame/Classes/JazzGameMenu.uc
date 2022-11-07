//=============================================================================
// JazzGameMenu.
//=============================================================================
class JazzGameMenu expands JazzMenu;

var		int		MenuSoundNum;
var()	sound	SwooshMenuInSound;
	
var		int		MenuRightSide;

// Joystick Variable
//var	  bool bJoystick;


// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	ResetMenu();

	// Detects if joystick in use	
	//bJoystick =	bool(PlayerOwner.ConsoleCommandResult("get windrv.windowsclient usejoystick"));
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

	if ( (Selection == 1) && (Level.NetMode == NM_Standalone)
				&& !Level.Game.IsA('BattleMode') )
		ChildMenu = spawn(class'JazzSaveMenu', owner);
	else if ( Selection == 2 ) 
		ChildMenu = spawn(class'JazzLoadMenu', owner);
	else if ( Selection == 3 )
		ChildMenu = spawn(class'JazzNewGameMenu', owner);
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
function DrawMenu (canvas Canvas)
{
	MenuStart(Canvas);
	
	DrawBackground(Canvas);

	TextMenuRight(Canvas);
	
	MenuEnd(Canvas);
}

// Background
//
function DrawBackGround(canvas Canvas)
{
	DrawBackGroundARight(Canvas);
}

defaultproperties
{
     SwooshMenuInSound=Sound'JazzSounds.Interface.menuhit'
     MenuSelectSound=Sound'JazzSounds.Weapons.shot1'
     MenuEnterSound=Sound'UnrealShare.Eightball.GrenadeFloor'
     MenuModifySound=Sound'JazzSounds.Weapons.shot1'
     MenuLength=3
     MenuList(0)="SAVE GAME"
     MenuList(1)="LOAD GAME"
     MenuList(2)="NEW GAME"
}
