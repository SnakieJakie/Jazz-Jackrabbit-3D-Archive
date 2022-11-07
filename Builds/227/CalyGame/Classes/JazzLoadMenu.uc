//=============================================================================
// JazzLoadMenu.
//=============================================================================
class JazzLoadMenu expands JazzMenu
	config(user);

var globalconfig string SlotNames[9];
var localized string MonthNames[12];

var int MenuNumReady;

var() texture MenuBckR;
var() texture MenuBck;

var() font DSFont;
var() font DLFont;

function PostBeginPlay()
{
	local int i;
	for (i=0; i<9; i++)
	{
		if (SlotNames[i]=="") SlotNames[i]="EMPTY SLOT";
	}
}

event MenuTick (float DeltaTime)
{
	MenuExistTime += DeltaTime;	
	
	if (bEntrySound==false)
	{
		PlayEntrySound();
		bEntrySound = true;
	}
}

function Menu ExitMenu()
{
	Hud(Owner).MainMenu = ParentMenu;
	if ( bConfigChanged )
		SaveConfigs();
	if ( ParentMenu == None )
	{
		PlayerOwner.bShowMenu = false;
		PlayerOwner.Player.Console.GotoState('');
		if( Level.Netmode == NM_Standalone )
			PlayerOwner.SetPause(False);
	}
	else
	{
		JazzMenu(ParentMenu).bEntrySound = false;
		JazzMenu(ParentMenu).MenuExistTime = 0;
	}

	Destroy();
}

// Menu Input
//
function MenuProcessInput( byte KeyNum, byte ActionNum )
{
	if (bMenuReadyForInput)
	{
		if ( KeyNum == EInputKey.IK_Escape )
		{
			JazzEnterSound();
			ExitMenu();
			return;
		}	
	
		if ( KeyNum == EInputKey.IK_Up )
		{
			JazzSelectSound();
			Selection--;
			if ( Selection < 1 )
				Selection = MenuLength;
		}
		else if ( KeyNum == EInputKey.IK_Down )
		{
			JazzSelectSound();
			Selection++;
			if ( Selection > MenuLength )
				Selection = 1;
		}
		else if ( KeyNum == EInputKey.IK_Enter )
		{
			bConfigChanged=true;
			if ( ProcessSelection() )
				JazzEnterSound();
		}
		else if ( KeyNum == EInputKey.IK_Left )
		{
			bConfigChanged=true;
			if ( ProcessLeft() )
				JazzModifySound();
		}
		else if ( KeyNum == EInputKey.IK_Right )
		{
			bConfigChanged=true;
			if ( ProcessRight() )
				JazzModifySound();
		}
		else if ( KeyNum == EInputKey.IK_Y )
		{
			bConfigChanged=true;
			if ( ProcessYes() )
				JazzModifySound();
		}
		else if ( KeyNum == EInputKey.IK_N )
		{
			bConfigChanged=true;
			if ( ProcessNo() )
				JazzModifySound();
		}
	}

	if ( bExitAllMenus )
		ExitAllMenus(); 
}


// Default Sound Effects
//
function PlayEntrySound()
{
	PlayerOwner.PlaySound(MenuEntrySound,,2.0);
}

function JazzSelectSound()
{
	PlayerOwner.PlaySound(MenuSelectSound,,2.0);
}

function JazzEnterSound()
{
	PlayerOwner.PlaySound(MenuEnterSound,,2.0);
}

function JazzModifySound()
{
	PlayerOwner.PlaySound(MenuModifySound,,2.0);
}

function PlayEnterSound()
{
	PlayerOwner.PlaySound(MenuEnterSound,,2.0);
}

function bool ProcessSelection()
{
	if (MenuNumReady<10)
	{

	if ( Selection == 1 )
	{
		PlayerOwner.ReStartLevel(); 
		return true;
	}
	if ( SlotNames[Selection - 2] ~= "EMPTY SLOT" )
		return false;
	bExitAllMenus = true;
	PlayerOwner.ClientMessage("");
	if ( Left(SlotNames[Selection - 2], 4) == "Net:" )
		Level.ServerTravel( "?load=" $ (Selection - 2), false);
	else
		PlayerOwner.ClientTravel( "?load=" $ (Selection - 2), TRAVEL_Absolute, false);
		
	return true;
	}
	return false;
}

function PreBeginPlay()
{
	MenuNumReady = -1;
}

function DrawSlots(canvas Canvas)
{
	local int StartX, StartY, Spacing, i;
	local float XPos;
			
	Spacing = Clamp(0.05 * Canvas.ClipY, 12, 32);
	StartX = Max(20, 0.5 * (Canvas.ClipX - 206));
	StartY = Max(40, 0.5 * (Canvas.ClipY - MenuLength * Spacing-40));
	FontMenuMedium(Canvas);

	For ( i=0; i<10; i++ )
	{
		if (i%2 == 0)
		{
			XPos = ((MenuExistTime-(float(i)*0.05))*500)-1000;
			if (XPos>StartX) 
			{
				XPos = StartX;
				if (MenuNumReady<i) 
				{
				MenuNumReady=i;
				JazzModifySound();
				}
			}
		}
		else
		{
			XPos = 1000-((MenuExistTime-(float(i)*0.05))*500);
			if (XPos<StartX) 
			{
				XPos = StartX;
				if (MenuNumReady<i) 
				{
				MenuNumReady=i;
				JazzModifySound();
				}
			}
		}
		
		SetFontBrightness(Canvas, (i == Selection - 1) );
		Canvas.SetPos(XPos, StartY + i * Spacing - ((XPos-StartX)/50) );
		Canvas.bCenter = false;
		
		if (i>0)
		{
		Canvas.DrawText(SlotNames[i-1], False);
		}
		else
		{
		Canvas.DrawText("RESTART "$Level.Title, False);
		}
	}

	// show selection
	//Canvas.SetPos( StartX - 20, StartY + Spacing * Selection);
	//Canvas.DrawText("[]", false);
}

function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing,I;

	// Background
	DrawBackgroundACenter(Canvas);

	DrawTitle(Canvas);

	// Draw Save slots
	DrawSlots(Canvas);

	bMenuReadyForInput = true;
}

// Backgrounds Center
//
function DrawBackGroundACenter(canvas Canvas)
{
	local int Y,MaxY;
	local int ShowX;
	local float OriginX;

	OriginX = Canvas.SizeX/2;
	
	MaxY = Canvas.SizeY;
	y = (MenuExistTime*MaxY*2);
	if (y>MaxY) y=MaxY;
	
	ShowX = (Canvas.SizeX/8.4)+128;	// 76-243 : Basically alter the size of the area for the menu.
	if (ShowX > 240) ShowX = 240;
	
	Canvas.bNoSmooth = True;
	Canvas.Style = 2;
	Canvas.SetPos(OriginX-ShowX,MaxY-y);
	Canvas.DrawColor.r = 200;
	Canvas.DrawColor.g = 200;
	Canvas.DrawColor.b = 200;
	Canvas.DrawTile( MenuBckR, ShowX, y, (0), (Canvas.CurY-Canvas.OrgY+MenuExistTime*20), ShowX, y );
	Canvas.SetPos(OriginX,MaxY-y);
	Canvas.DrawTile( MenuBck, ShowX, y, (256-ShowX), (Canvas.CurY-Canvas.OrgY-MenuExistTime*20), ShowX, y );
	Canvas.OrgX = 0;
}

function DrawTitle(canvas Canvas)
{
	local int XPos,Test;
	
	XPos = MenuExistTime*1000-500;

	if ( Canvas.ClipY < 300 )
	{
		Canvas.Font = DSFont;
		Test = 0.5 * Canvas.ClipX - 4 * Len(MenuTitle);
	}
	else
	{
		Canvas.Font = DLFont;
		Test = 0.5 * Canvas.ClipX - 8 * Len(MenuTitle);
	}
	
	if (XPos>Test) XPos = Test;
	Canvas.SetPos(XPos,4);
	Canvas.DrawColor = Canvas.Default.DrawColor;
	
	Canvas.DrawText(MenuTitle, False);
}

defaultproperties
{
     SlotNames(0)="Untitled 12:47  4"
     MenuLength=10
     MenuTitle="LOAD GAME"
	MenuBckR=Texture'JazzArt.MenuBckR'
	MenuBck=Texture'JazzArt.MenuBck'
	DSFont=Texture'JazzFonts.DSFont'
	DLFont=Texture'JazzFonts.DLFont'
}
