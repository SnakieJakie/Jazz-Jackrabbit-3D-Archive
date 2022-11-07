//=============================================================================
// JazzJoinGameMenu.
//=============================================================================
class JazzJoinGameMenu expands JazzMenu;

var		int		MenuSoundNum;
var()	sound	SwooshMenuInSound;
	
var		int		MenuRightSide;


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

function bool ProcessLeft()
{
	local int NewSpeed;

	if ( Selection == 2 )
	{
		if ( PlayerOwner.NetSpeed <= 3000 )
			NewSpeed = 20000;
		else if ( PlayerOwner.NetSpeed < 12500 )
			NewSpeed = 2600;
		else
			NewSpeed = 5000;

		PlayerOwner.ConsoleCommand("NETSPEED "$NewSpeed);
	}
	else
		ProcessRight();

	return true;
}

function bool ProcessRight()
{
	local int NewSpeed;

	if ( Selection == 4 )
	{
		if ( PlayerOwner.NetSpeed <= 3000 )
			NewSpeed = 5000;
		else if ( PlayerOwner.NetSpeed < 12500 )
			NewSpeed = 20000;
		else
			NewSpeed = 2600;

		PlayerOwner.ConsoleCommand("NETSPEED "$NewSpeed);
	}

	return true;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;
	local class<Menu> ListenMenuClass;

	ChildMenu = None;
	if ( ! bBegun )
	{
		PlayEnterSound();
		bBegun = true;
	}

	if (Selection == 1) // Listen for Connection
	{
		SaveConfigs();
		ListenMenuClass = class<Menu>(DynamicLoadObject("CalyGame.JazzListenMenu", class'Class'));
		ChildMenu = spawn(ListenMenuClass, owner);
		Log("Listen Menu) "$ListenMenuClass);
	}
	else
	if (Selection == 2)	// Connection Speed
	{
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
	
	DrawBackGroundARight(Canvas);

	TextMenuRight(Canvas);

	MenuEnd(Canvas);
}

defaultproperties
{
     MenuLength=2
     MenuList(0)="FIND LOCAL SERVERS"
     MenuList(1)="CONNECTION SPEED"
}
