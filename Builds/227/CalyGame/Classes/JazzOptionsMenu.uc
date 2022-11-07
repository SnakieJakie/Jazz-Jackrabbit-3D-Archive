//=============================================================================
// JazzOptionsMenu.
//=============================================================================
class JazzOptionsMenu expands JazzMenu;

var		int		MenuRightSide;

// Joystick Variable
var	  bool bJoystick;

// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	ResetMenu();

	// Detects if joystick in use	
	bJoystick =	bool(PlayerOwner.ConsoleCommand("get windrv.windowsclient usejoystick"));
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
	{
		bJoystick = !bJoystick;
		PlayerOwner.ConsoleCommand("set windrv.windowsclient usejoystick "$int(bJoystick));
	}
	else
	if (Selection == 2)
	{
		ChildMenu = spawn(class'JazzKeyboardMenu', owner);
	}
	else
	if (Selection == 3)
	{
		ChildMenu = spawn(class'JazzKeyboard2Menu', owner);
	}
	else
	if (Selection == 4)
	{
		PlayerOwner.ConsoleCommand("PREFERENCES");
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
	
	MenuRightSide = Canvas.SizeX;
	
	DrawBackgroundARight(Canvas);

	TextMenuRight(Canvas);

	MenuEnd(Canvas);
}

defaultproperties
{
     MenuSelectSound=Sound'JazzSounds.Weapons.shot1'
     MenuEnterSound=Sound'UnrealShare.Eightball.GrenadeFloor'
     MenuModifySound=Sound'JazzSounds.Weapons.shot1'
     SwooshMenuInSound=Sound'JazzSounds.Interface.menuhit'
     MenuLength=4
     MenuList(0)="USE JOYSTICK"
     MenuList(1)="CUSTOMIZE MOVEMENT"
     MenuList(2)="CUSTOMIZE ACTIONS"
     MenuList(3)="ADVANCED OPTIONS"
}
