//=============================================================================
// JazzQuitMenu.
//=============================================================================
class JazzQuitMenu expands JazzMenu;

var	float	MenuLocations[24];

// Menu drawing locations/etc.
//
var int MenuCenter;
var int MenuLeftSpace;

var bool bResponse;
var() font DSFont;

function bool ProcessYes()
{
	bResponse = true;
	return true;
}

function bool ProcessNo()
{
	bResponse = false;
	return true;
}

function bool ProcessLeft()
{
	bResponse = !bResponse;
	return true;
}

function bool ProcessRight()
{
	bResponse = !bResponse;
	return true;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;

	ChildMenu = None;

	if ( bResponse )
	{
		PlayerOwner.SaveConfig();
		if ( Level.Game != None )
			Level.Game.SaveConfig();
		PlayerOwner.ConsoleCommand("Exit");
	}
	else 
		ExitMenu();
}

function DrawValues(canvas Canvas, Font RegFont, int Spacing, int StartX, int StartY)
{
	local int i;

	Canvas.Font = RegFont;

	for (i=0; i< MenuLength; i++ )
	{
		Canvas.SetPos(StartX-(Len(MenuList[i])*4), MenuLocations[i]+4);
		Canvas.DrawText(Caps(MenuList[i]), false);
	}
}

function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing,I;

	MenuStart(Canvas);
	
	// Background
	MenuCenter = Canvas.SizeX / 2;
	DrawBackground(Canvas);
	
	DrawTitle(Canvas);
	
	Spacing = Clamp(0.07 * Canvas.ClipY, 10, 40);	// Vertical spacing (0.04 = 1/25)

	MenuLeftSpace = (0.3 * Canvas.SizeX) + 40;
	StartX = Max(8, 0.5 * Canvas.SizeX - MenuLeftSpace);
	StartY = Max(28, 0.5 * (Canvas.ClipY - MenuLength * Spacing));

	// Menu Locations (Animation)
	for (I=0; I<24; I++)
	{
	MenuLocations[I] = 
	   Min(StartY + Spacing * i , (MenuExistTime * Canvas.ClipY) - Canvas.ClipY - i*30);
	}
	
	StartX = Max(8, 0.5 * Canvas.SizeX);	
	DrawValues(Canvas, DSFont, Spacing, StartX, StartY);

	// Yes/No Selection Text
	FontMenuMedium(Canvas);
	SetFontBrightness(Canvas, true);
	
	StartY = Canvas.ClipY+100-500*MenuExistTime;
	if (StartY<Canvas.ClipY*0.9) StartY=Canvas.ClipY*0.9;
	
	StartX = Canvas.SizeX*0.5 - 70;
	Canvas.SetPos(StartX, StartY );
	Canvas.DrawText("QUIT?", False);
	Canvas.SetPos(StartX + 100, StartY);
	if ( bResponse )
		Canvas.DrawText("YES", False);
	else
		Canvas.DrawText("NO", False);
	Canvas.DrawColor = Canvas.Default.DrawColor;

	bMenuReadyForInput = true;
	
	MenuEnd(Canvas);
}

// Background
//
function DrawBackGround(canvas Canvas)
{
	DrawBackGroundACenter(Canvas);
}


function DrawTitle(canvas Canvas)
{
	Canvas.Style = 1;
	Canvas.DrawColor.r = 220; 	Canvas.DrawColor.g = 220;
	Canvas.DrawColor.b = 220;;
	
	FontMenu(Canvas);
	if ( Canvas.ClipY < 300 )
	{
		Canvas.SetPos(Max(8, 0.5 * Canvas.SizeX - 4 * Len(MenuTitle)), 4 );
	}
	else
	{
		Canvas.SetPos(Max(8, 0.5 * Canvas.SizeX - 8 * Len(MenuTitle)), 4 );
	}
	Canvas.DrawText(MenuTitle, False);
}

defaultproperties
{
     MenuSelectSound=Sound'JazzSounds.Weapons.shot1'
     MenuEnterSound=Sound'UnrealShare.Eightball.GrenadeFloor'
     MenuModifySound=Sound'JazzSounds.Weapons.shot1'
     MenuLength=8
     MenuList(0)="Jazz Jackrabbit 3"
     MenuList(2)="Adventures"
     MenuList(3)="of"
     MenuList(4)="A"
     MenuList(5)="Mean"
     MenuList(6)="Green"
     MenuList(7)="Hare"
     MenuTitle="QUIT JAZZ 3?"
     DSFont=Texture'JazzFonts.DSFont'
}
