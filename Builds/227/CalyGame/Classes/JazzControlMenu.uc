//=============================================================================
// JazzControlMenu.
//=============================================================================
class JazzControlMenu expands JazzMenu;

// Joystick Variable
var	  bool bJoystick;

// Name of the camera types
var() localized string CameraName[2];

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
		JazzPlayer(PlayerOwner).NextCameraType();
	}
	else
	if (Selection == 3)
	{
		ChildMenu = spawn(class'JazzKeyboardMenu', owner);
	}
	else
	if (Selection == 4)
	{
		ExitMenu();
		return(false);
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
	
	DrawBackgroundARight(Canvas);

	TextMenuRight(Canvas);
	
	if (bJoystick)
	MenuSelections[0]="USED";
	else
	MenuSelections[0]="NOT USED";

	// Camera Name
	MenuSelections[1]=CameraName[JazzPlayer(PlayerOwner).CameraInUse];
	
	TextMenuLeftSelections(Canvas);

	MenuEnd(Canvas);
}

defaultproperties
{
     MenuLength=3
}
