//=============================================================================
// JazzDeadMenu.
//=============================================================================
class JazzDeadMenu expands JazzMenu;

var		int		MenuSoundNum;
var()	sound	SwooshMenuInSound;
	
var		int		MenuRightSide;

// Joystick Variable
var	  bool bJoystick;


// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	Log("JazzMenu) PostBeginPlay");

	ResetMenu();

	// Detects if joystick in use	
	//bJoystick =	bool(PlayerOwner.ConsoleCommandResult("get windrv.windowsclient usejoystick"));
	// 220 Version
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

	if (Selection == 1)
	{
		PlayerOwner.ReStartLevel(); 
		return true;
	}
	else if ( Selection == 2 ) 
		ChildMenu = spawn(class'JazzLoadMenu', owner);
	else if ( Selection == 3 )
		ChildMenu = spawn(class'JazzGameMenu', owner);
	else if ( Selection == 4 )
		ChildMenu = spawn(class'JazzQuitMenu', owner);
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
	local int	i,x,MinX;
	local int	spacing,StartY;
	
	MenuStart(Canvas);

	MenuRightSide = Canvas.SizeX;
	
	DrawBackground(Canvas);

	spacing = 35;
	StartY = 20;

	FontMenu(Canvas);		// Set typical Menu font

	if (Canvas.ClipY>384)
	{
		spacing = 45;
		StartY = 60;
	}

	for (i=0; i<=MenuLength; i++)
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
		x = (MenuExistTime*500)-200-(i*40);
		if (x>20) x=20;
		
		// Check if menu across x threshold point to make a sound
		if ((x>-50) && (MenuSoundNum<i+1))
		{
			PlayerOwner.PlaySound(SwooshMenuInSound);
			MenuSoundNum = i+1;
		}
		
		// Menu is ready once all motion done
		if ((x>=20) && (i>=MenuLength))
			bMenuReadyForInput = true;
		
		TextRight(Canvas, MenuRightSide-x,20 + Spacing * i, MenuList[i]);
		
/*		if (Canvas.ClipY>384)
		Canvas.SetPos(MenuRightSide-x-Len(MenuList[i])*17, 20 + Spacing * i);
		else
		Canvas.SetPos(MenuRightSide-x-Len(MenuList[i])*10, 20 + Spacing * i);
		
		Canvas.DrawText(MenuList[i], false);*/
	}
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	
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
     MenuSelectSound=Sound'JazzSounds.Interface.menuhit'
     MenuEnterSound=Sound'JazzSounds.Interface.menuhit'
     MenuModifySound=Sound'JazzSounds.Interface.menuhit'
     MenuLength=4
     MenuList(0)="RESTART LEVEL"
     MenuList(1)="LOAD GAME"
     MenuList(2)="NEW GAME"
     MenuList(3)="QUIT"
}
