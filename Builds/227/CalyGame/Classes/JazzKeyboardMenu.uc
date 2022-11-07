//=============================================================================
// JazzKeyboardMenu.
//=============================================================================
class JazzKeyboardMenu expands JazzMenu;

var string MenuValues1[24];
var string MenuValues2[24];
var string AliasNames[24];
var string PendingCommands[30];
var int Pending;
var bool bSetUp;
var	float	MenuLocations[24];

var bool WaitingForNewKey;

// Menu drawing locations/etc.
//
var int MenuCenter;
var int MenuLeftSpace;

var() font DSFont;


function SaveConfigs()
{
	ProcessPending();
}

function ProcessPending()
{
	local int i;

	for ( i=0; i<Pending; i++ )
		PlayerOwner.ConsoleCommand(PendingCommands[i]);

	Pending = 0;
}

function AddPending(string newCommand)
{
	PendingCommands[Pending] = newCommand;
	Pending++;
	if ( Pending == 30 )
		ProcessPending();
}
	
function SetUpMenu()
{
	local int i, j, pos;
	local string KeyName;
	local string Alias;

	// THEORY: Unreal has built-in functions in the UnrealKeyboardMenu to place the
	// input command Aliasnames into the AliasNames array.  This is horrid and we'll
	// have to go and do our own custom bad workaround right here.  'Tis life. :)
	//
	AliasNames[1] = "MoveForward";
	AliasNames[2] = "MoveBackward";
	AliasNames[3] = "TurnLeft";
	AliasNames[4] = "TurnRight";
	AliasNames[5] = "StrafeLeft";
	AliasNames[6] = "StrafeRight";
	AliasNames[7] = "Jump";
	
	bSetup = true;

	for ( i=0; i<255; i++ )
	{
		KeyName = PlayerOwner.ConsoleCommand ( "KEYNAME "$i );
		if ( KeyName != "" )
		{	
			Alias = PlayerOwner.ConsoleCommand ( "KEYBINDING "$KeyName );
			if ( Alias != "" )
			{
				pos = InStr(Alias, " " );
				if ( pos != -1 )
					Alias = Left(Alias, pos);
				for ( j=1; j<MenuLength; j++ )
				{
					if ( AliasNames[j] == Alias )
					{
						if ( MenuValues1[j] == "" )
							MenuValues1[j] = KeyName;
						else if ( MenuValues2[j] == "" )
							MenuValues2[j] = KeyName;
					}
				}
			}
		}
	}
}

function ProcessMenuKey( int KeyNo, string KeyName )
{
	local int i;

	if ( (KeyName == "") || (KeyName == "Escape")  
		|| ((KeyNo >= 0x70 ) && (KeyNo <= 0x79)) ) //function keys
		return;

	// make sure no overlapping
	for ( i=1; i<20; i++ )
	{
		if ( MenuValues2[i] == KeyName )
			MenuValues2[i] = "";
		if ( MenuValues1[i] == KeyName )
		{
			MenuValues1[i] = MenuValues2[i];
			MenuValues2[i] = "";
		}
	}
	if ( MenuValues1[Selection] != "_" )
		MenuValues2[Selection] = MenuValues1[Selection];
	else if ( MenuValues2[Selection] == "_" )
		MenuValues2[Selection] = "";

	MenuValues1[Selection] = KeyName;
	AddPending("SET Input "$KeyName$" "$AliasNames[Selection]);
	WaitingForNewKey = false;
}

function ProcessMenuEscape();
function ProcessMenuUpdate( coerce string InputString );

function bool ProcessSelection()
{
	local int i;

	if ( Selection == MenuLength )
	{
		Pending = 0;
		PlayerOwner.ResetKeyboard();
		for ( i=0; i<24; i++ )
		{
			MenuValues1[i] = "";
			MenuValues2[i] = "";
		}
		SetupMenu();
		return true;
	}
	if ( MenuValues2[Selection] != "" )
	{
		AddPending( "SET Input "$MenuValues2[Selection]$" ");
		AddPending( "SET Input "$MenuValues1[Selection]$" ");
		MenuValues1[Selection] = "_";
		MenuValues2[Selection] = "";
	}
	else
		MenuValues2[Selection] = "_";
		
	PlayerOwner.Player.Console.GotoState('KeyMenuing');
	WaitingForNewKey = true;
	return true;
}

function DrawValues(canvas Canvas, Font RegFont, int Spacing, int StartX, int StartY)
{
	local int i;

	Canvas.Font = RegFont;

	for (i=0; i< MenuLength; i++ )
	{
		if ( MenuValues1[i+1] != "" )
		{
			SetFontBrightness( Canvas, (i == Selection - 1) );
			Canvas.SetPos(StartX, MenuLocations[i]+4);
			if ( MenuValues2[i+1] == "" )
				Canvas.DrawText(Caps(MenuValues1[i + 1]), false);
			else
				Canvas.DrawText(Caps(MenuValues1[i + 1]$" / "$MenuValues2[i+1]), false);
				
			if ((Selection-1 == i) && (WaitingForNewKey))
			{
				Canvas.Style = 1;
				Canvas.SetPos(StartX-10, MenuLocations[i]+4);
				//Canvas.DrawIcon(Texture'Jazzsd1e',1.0);
			}
		}
		Canvas.DrawColor = Canvas.Default.DrawColor;
	}
}

function DrawValuesLarge(canvas Canvas, Font RegFont, int Spacing, int StartX, int StartY)
{
	local int i;

	Canvas.Font = RegFont;

	for (i=0; i< MenuLength; i++ )
	{
		if ( MenuValues1[i+1] != "" )
		{
			SetFontBrightness( Canvas, (i == Selection - 1) );
			Canvas.SetPos(StartX, MenuLocations[i] + 4);
			Canvas.DrawText(MenuValues1[i+1], false);
			
			if (MenuValues2[i+1] != "")
			Canvas.SetPos(StartX+100, MenuLocations[i] + 4);
			Canvas.DrawText(MenuValues2[i+1], false);
		}
		Canvas.DrawColor = Canvas.Default.DrawColor;
	}
}

function DrawKeyOptions(canvas Canvas, int Spacing, int StartX, int StartY)
{
	local int i;

	if ( Spacing < 30 )
	{
		Canvas.Font = DSFont;
	}
	else
		Canvas.Font = DSFont;

	for (i=0; i< (MenuLength); i++ )
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
		Canvas.SetPos(StartX, MenuLocations[i]);
		Canvas.DrawText(MenuList[i], false);
	}
	Canvas.DrawColor = Canvas.Default.DrawColor;
}

function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing,I;
	
	MenuStart(Canvas);
	
	// Background
	MenuCenter = Canvas.SizeX / 2;
	DrawBackground(Canvas);
	DrawTitle(Canvas);
	
	Spacing = Clamp(0.06 * Canvas.ClipY, 20, 40);	// Vertical spacing (0.04 = 1/25)

	MenuLeftSpace = (0.3 * Canvas.SizeX) + 50;
	StartX = Max(8, 0.5 * Canvas.SizeX - MenuLeftSpace);

	StartY = Max(20, 0.5 * (Canvas.ClipY - MenuLength * Spacing));

	// Menu Locations (Animation)
	for (I=0; I<24; I++)
	{
	MenuLocations[I] = 
	   Min(StartY + Spacing * i , (MenuExistTime * Canvas.ClipY) - Canvas.ClipY - i*30);
	}
	
	if ( !bSetup )	SetupMenu();

	DrawKeyOptions(Canvas, Spacing, StartX, StartY); 
	
	if (Canvas.SizeX>500)
	DrawValuesLarge(Canvas, DSFont, Spacing, StartX+MenuLeftSpace, StartY);
	else
	DrawValues(Canvas, DSFont, Spacing, StartX+MenuLeftSpace, StartY);

	bMenuReadyForInput = true;
	
	MenuEnd(Canvas);
}

// Background
//
function DrawBackGround(canvas Canvas)
{
	DrawBackGroundACenter(Canvas);
}


/*function DrawTitle(canvas Canvas)
{
	Canvas.Style = 1;
	Canvas.DrawColor.r = 220;
	Canvas.DrawColor.g = 220;
	Canvas.DrawColor.b = 220;;
	
	if ( Canvas.ClipY < 300 )
	{
		Canvas.Font = Canvas.BigFont;
		Canvas.SetPos(Max(8, 0.5 * Canvas.SizeX - 4 * Len(MenuTitle)), 4 );
	}
	else
	{
		Canvas.Font = Canvas.LargeFont;
		Canvas.SetPos(Max(8, 0.5 * Canvas.SizeX - 8 * Len(MenuTitle)), 4 );
	}
	Canvas.DrawText(MenuTitle, False);
}*/

defaultproperties
{
     MenuSelectSound=Sound'JazzSounds.Weapons.shot1'
     MenuEnterSound=Sound'UnrealShare.Eightball.GrenadeFloor'
     MenuModifySound=Sound'JazzSounds.Weapons.shot1'
     MenuLength=8
     MenuList(0)="FORWARD"
     MenuList(1)="BACKWARD"
     MenuList(2)="TURN LEFT"
     MenuList(3)="TURN RIGHT"
     MenuList(4)="STRAFE LEFT"
     MenuList(5)="STRAFE RIGHT"
     MenuList(6)="JUMP"
     MenuList(7)="RESET TO DEFAULT"
     MenuTitle="MOVEMENT CONTROLS"
     DSFont=Texture'JazzFonts.DSFont'
}
