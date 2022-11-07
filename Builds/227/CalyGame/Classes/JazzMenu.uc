//=============================================================================
// JazzMenu.
//=============================================================================
class JazzMenu expands Menu;

var bool bBegun;
var bool bMenuReadyForInput;

var float	MenuExistTime;
var float   BackgroundTime;

var		int		MenuSoundNum;	// Menu text entries make sounds - # of text entry to make sound
	
var() sound	MenuEntrySound;
var bool bEntrySound;	// Played Entry sound yet?
var() sound MenuSelectSound;
var() sound MenuEnterSound;
var() sound MenuModifySound;
var() sound	SwooshMenuInSound;

var() localized string NoneText;

var string	MenuSelections[16];

var bool BackgroundCheck;

var() texture MenuBarTR;
var() texture MenuBarTL;
var() texture MenuBarBR;
var() texture MenuBarBL;
var() texture MenuBar;
var() texture MenuBack;
var() texture NWater3;
var() texture MenuTop;
var() texture MenuBarTRX;
var() texture MenuBarTLX;
var() texture MenuBarBRX;
var() texture MenuBarBLX;
var() texture MenuBckR;
var() texture MenuBck;
var() sound changeselection;
var() sound menuweird;

function PreBeginPlay ()
{
	MenuSelectSound = changeselection;
	MenuModifySound = menuweird;
}

function PostBeginPlay ()
{
	ResetMenu();
}

function ResetMenu()
{
	// Plays sounds as menus move across the screen
	MenuSoundNum = 0;
	MenuExistTime = 0;
}

event MenuTick (float DeltaTime)
{
	if ( BackgroundCheck == false )
	if ( JazzMenu(ParentMenu) != None )
	{
		BackgroundCheck = true;
		BackgroundTime = JazzMenu(ParentMenu).BackgroundTime;
	}
	
	MenuExistTime += DeltaTime;	
	BackgroundTime += DeltaTime;
	
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
		if( JazzPlayer(PlayerOwner).bShowTutorial==false )
		{
			PlayerOwner.SetPause(False);
		}
	}
	else
	{
		JazzMenu(ParentMenu).bEntrySound = false;
		JazzMenu(ParentMenu).MenuExistTime = 0;
		JazzMenu(ParentMenu).BackgroundTime = BackgroundTime;	
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

function DrawBackGround(canvas Canvas)
{
}

function PlayEnterSound()
{
	PlayerOwner.PlaySound(MenuEnterSound,,2.0);
}

function DrawTitle(canvas Canvas)
{
	FontMenu(Canvas);		// Set typical Menu font
	
	if ( Canvas.ClipY < 300 )
	{
		Canvas.SetPos(Max(8, 0.5 * Canvas.ClipX - 4 * Len(MenuTitle)), 4 );
	}
	else
	{
		Canvas.SetPos(Max(8, 0.5 * Canvas.ClipX - 8 * Len(MenuTitle)), 4 );
	}
	Canvas.DrawColor = Canvas.Default.DrawColor;
	//
	DancingText(Canvas,MenuTitle,0.5);
	//Canvas.DrawText(MenuTitle, False);
}

// Globals to remove wordwrap temporarily
//
function MenuStart ( canvas Canvas )
{
	Canvas.ClipX = 100000;
}

function MenuEnd ( canvas Canvas )
{
	Canvas.ClipX = Canvas.SizeX;
}

// Font Setup
//
function FontMenu ( canvas Canvas )
{
	if (Canvas.SizeY>384)
	{
		Canvas.Font = font'DLFont';
	}
	else
	{
		Canvas.Font = font'DSFont';
	}
}

// Font Medium
//
function FontMenuMedium ( canvas Canvas )
{
	if (Canvas.ClipY>384)
		Canvas.Font = font'DLFont';
	else
	if (Canvas.ClipY>200)
		Canvas.Font = font'DSFont';
	else
		Canvas.Font = font'DSFont';
}

function SetFontBrightness(canvas Canvas, bool bBright)
{
	if ( bBright )
	{
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}
	else 
	{
		Canvas.DrawColor.R = 55;
		Canvas.DrawColor.G = 140;
		Canvas.DrawColor.B = 180;
	}
}

// Right-Oriented Text
//
function TextRight ( canvas Canvas, float X, float Y, string St )
{
	local int Len;
	local float LX,LY;
	
	Canvas.StrLen(St,LX,LY);
	
	Canvas.SetPos(X-LX,Y);
	Canvas.DrawText(St,false);
}

// Backgrounds
//
function DrawBackGroundA(canvas Canvas)
{
	local int Y,YStart,MaxY;
	local int ShowX;
	local float Scale;
	local int A,B;

	Canvas.bNoSmooth = True;
	
	MaxY = Canvas.SizeY;
	
	Scale = 1;
	y = (MenuExistTime*32)%512;
	
	ShowX = (((Canvas.SizeX*0.4))+64)*Scale;	// 76-243 : Basically alter the size of the area for the menu.
//	ShowX = 255;

	yStart = (MenuExistTime*ShowX*3);
	if (YStart>ShowX) YStart=ShowX;
	ShowX = yStart;

	if (ShowX > 500) ShowX = 500;
//	if (ShowX < 200) ShowX = 200;

	DrawRear(Canvas);

/*	Canvas.Style = 4;
	Canvas.OrgX = -(512*Scale-ShowX)+64;
	Canvas.SetPos(0,MaxY-y);
	Canvas.DrawColor.r = 100;
	Canvas.DrawColor.g = 100;
	Canvas.DrawColor.b = 100;
	
	for (A=0; A<(Canvas.SizeX/256)+2; A++)
	{
		B = A*256-y+(MaxY-YStart);
		if ((B>-256) && (B<Canvas.SizeY))
		if (A%2==0)
		{
		Canvas.SetPos(256,B);
		Canvas.DrawIcon( MenuBarTR, 1 );
		}
		else
		{
		Canvas.SetPos(256,B);
		Canvas.DrawIcon( MenuBarBR, 1 );
		}
	}*/
	
	Canvas.Style = 2;
	Canvas.OrgX = -(512*Scale-ShowX);
	Canvas.SetPos(0,MaxY-y);
	Canvas.DrawColor.r = 100;
	Canvas.DrawColor.g = 100;
	Canvas.DrawColor.b = 100;
	
	for (A=0; A<(Canvas.SizeX/256)+2; A++)
	{
		B = A*256-y;
		if ((B>-256) && (B<Canvas.SizeY))
		if (A%2==0)
		{
		Canvas.SetPos(0,B);
		Canvas.DrawIcon( MenuBarTL, 1 );
		Canvas.SetPos(256,B);
		Canvas.DrawIcon( MenuBarTR, 1 );
		}
		else
		{
		Canvas.SetPos(0,B);
		Canvas.DrawIcon( MenuBarBL, 1 );
		Canvas.SetPos(256,B);
		Canvas.DrawIcon( MenuBarBR, 1 );
		}
	}
	
	//Canvas.DrawTile( MenuBar, ShowX, y, (512*Scale-ShowX), (Canvas.CurY-Canvas.OrgY+MenuExistTime*20), ShowX, y );

/*	Canvas.Style = 5;
	// Draw whitespace
	B = y+(MaxY-Ystart);  if (B<0) B=0;
	Canvas.SetPos(ShowX,B);
	Canvas.DrawTile( MenuBack, Canvas.SizeX-512, Canvas.SizeY, 0, 0, Canvas.SizeX-512, Canvas.SizeY );*/

	Canvas.OrgX = 0;
	Canvas.Style = 2;
}

function DrawRear(canvas Canvas)
{
	local int temp;
	local texture T;

	Canvas.Style = 3;
	Canvas.OrgX = 0;
	Canvas.SetPos(0,0);
	Temp = BackgroundTime*80; if (Temp>50) Temp=50;
	Canvas.DrawColor.r = Temp;
	Canvas.DrawColor.g = Temp;
	Canvas.DrawColor.b = Temp;
	T = NWater3;
	Canvas.DrawTile( T, Canvas.SizeX, Canvas.SizeY, 0, 0, Canvas.SizeX, Canvas.SizeY );
	
/*	Temp = BackgroundTime*64; if (BackgroundTime>64) BackgroundTime=64;
	Canvas.SetPos(0,-64+Temp);
	Canvas.DrawTile( MenuTop, Canvas.SizeX, 64, 0, 0, Canvas.SizeX, 64 );*/
}

// Backgrounds
//
function DrawBackGroundARight(canvas Canvas)
{
	local int Y,YStart,MaxY;
	local int ShowX;
	local float Scale;
	local int A,B;

	Canvas.bNoSmooth = True;
	
	MaxY = Canvas.SizeY;
	
	Scale = 1;
	y = (MenuExistTime*32)%512;
	
//	yStart = (MenuExistTime*MaxY*2);
//	if (YStart>MaxY) YStart=MaxY;
	
	ShowX = (((Canvas.SizeX*0.4))+64)*Scale;	// 76-243 : Basically alter the size of the area for the menu.
//	ShowX = 255;

	yStart = (MenuExistTime*ShowX*3);
	if (YStart>ShowX) YStart=ShowX;
	ShowX = yStart;

	if (ShowX > 500) ShowX = 500;
//	if (ShowX < 200) ShowX = 200;

	DrawRear(Canvas);

	Canvas.Style = 2;
	Canvas.OrgX = Canvas.SizeX-ShowX;
	Canvas.DrawColor.r = 100;
	Canvas.DrawColor.g = 100;
	Canvas.DrawColor.b = 100;
	Canvas.ClipX = 999999;
	
	for (A=0; A<(Canvas.SizeX/256)+2; A++)
	{
		B = A*256-y;
		if ((B>-256) && (B<Canvas.SizeY))
		if (A%2==0)
		{
		Canvas.SetPos(0,B);
		Canvas.DrawIcon( MenuBarTRX, 1 );
		Canvas.SetPos(256,B);
		Canvas.DrawIcon( MenuBarTLX, 1 );
		}
		else
		{
		Canvas.SetPos(0,B);
		Canvas.DrawIcon( MenuBarBRX, 1 );
		Canvas.SetPos(256,B);
		Canvas.DrawIcon( MenuBarBLX, 1 );
		}
	}
	//Canvas.DrawTile( MenuBar, ShowX, y, (512*Scale-ShowX), (Canvas.CurY-Canvas.OrgY+MenuExistTime*20), ShowX, y );

	Canvas.OrgX = 0;
	Canvas.ClipX = Canvas.SizeX;
}

// Backgrounds Right
//
/*function DrawBackGroundARight(canvas Canvas)
{
	local int Y,MaxY;
	local int ShowX;

	Canvas.bNoSmooth = True;
	
	MaxY = Canvas.SizeY;
	
	y = (MenuExistTime*MaxY*2);
	if (y>MaxY) y=MaxY;
	
	ShowX = (Canvas.SizeX/8.4)*2+128;	// 76-243 : Basically alter the size of the area for the menu.
	if (ShowX > 256) ShowX = 256;

	DrawRear(Canvas);

	Canvas.Style = 2;
	Canvas.SetPos(Canvas.SizeX-ShowX,MaxY-y);
	Canvas.DrawColor.r = 200;
	Canvas.DrawColor.g = 200;
	Canvas.DrawColor.b = 200;
	Canvas.DrawTile( MenuBckR, ShowX, y, (0), (Canvas.CurY-Canvas.OrgY-MenuExistTime*20), ShowX, y );
	//Canvas.DrawTile( MenuBckR, ShowX, y, (0), (Canvas.CurY-Canvas.OrgY), ShowX, y );
	Canvas.OrgX = 0;
}*/

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
	
	DrawRear(Canvas);

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

// Dancing Text Routines
//
function DancingTextRight ( canvas Canvas, float X, float Y, string St, optional float TimeOffset )
{
	local int Len;
	local float LX,LY;
	
	Canvas.StrLen(St,LX,LY);
	
	Canvas.SetPos(X-LX*1.1,Y);
	DancingText(Canvas,St,TimeOffset);
}
//
//
function DancingText ( canvas Canvas, string Text, optional float TimeOffset, optional float FontWidth )
{
	local float X,Y;
	local float LX,LY;
	local int SLen,L;
	local string TempS;
	local float A,B;
	
	local float DanceRadius;
	
	A = (MenuExistTime+TimeOffset)*5;		// Time offsets
	B = (MenuExistTime+TimeOffset)*9.9;

	SLen = Len(Text);
	X = Canvas.CurX;
	Y = Canvas.CurY;
	
	if (Canvas.SizeX < 640)
		DanceRadius = 2;
		else
	if (Canvas.SizeX < 800)
		DanceRadius = 3;
		else
		DanceRadius = 4;
	
	if (FontWidth <= 0)
		FontWidth = 12;

	for (L=0; L<SLen; L++)
	{
	Canvas.SetPos(	X + sin(A+L*0.6)*DanceRadius ,
					Y + cos(B+L*0.95)*DanceRadius );
	TempS = Mid(Text,L,1);
	Canvas.DrawText(TempS);
	Canvas.StrLen(TempS,LX,LY);
	X += LX*1.1;
	}
}

function TextMenuSelections (canvas Canvas)
{
	local int	i,x,MinX;
	local int	spacing,StartY;

	StartY = Canvas.SizeY*0.1;
	Spacing = Canvas.SizeY*0.095;
	if (Spacing<23) Spacing = 23;
	
	FontMenu(Canvas);

	for (i=0; i<=MenuLength; i++)
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
/*		x = (MenuExistTime*500)-200-(i*40);
		if (x>20) x=20;
		Canvas.SetPos(x, 20 + Spacing * i);*/
		
		x = Canvas.SizeX * 0.6;
		
		Canvas.SetPos(x,StartY+Spacing*i);
		DancingText(Canvas,Caps(MenuSelections[i]),i);
	}
	Canvas.Style = 2;
}
	
function TextMenuLeftSelections (canvas Canvas)
{
	local int	i,x,MinX;
	local int	spacing,StartY;

	StartY = Canvas.SizeY*0.1;
	Spacing = Canvas.SizeY*0.095;
	if (Spacing<23) Spacing = 23;
	
	FontMenu(Canvas);

	for (i=0; i<=MenuLength; i++)
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
/*		x = (MenuExistTime*500)-200-(i*40);
		if (x>20) x=20;
		Canvas.SetPos(x, 20 + Spacing * i);*/
		
		x = Canvas.SizeX * 0.1;
		
		Canvas.SetPos(x,StartY+Spacing*i);
		DancingText(Canvas,Caps(MenuSelections[i]),i);
	}
	Canvas.Style = 2;
}
	
// Text Menu Draw Routines
//
function TextMenuLeft ( canvas Canvas )
{
	local float spacing,StartY;
	local int i,x;
	local int Margin;

	Margin = Canvas.SizeX*0.03;
	StartY = Canvas.SizeY*0.1;
	Spacing = Canvas.SizeY*0.095;
	if (Spacing<23) Spacing = 23;
	
	FontMenu(Canvas);

	for (i=0; i<=MenuLength; i++)
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
		x = (MenuExistTime*500)-200-(i*40);
		if (x>Margin) x=Margin;
		
		// Check if menu across x threshold point to make a sound
		if ((x>-50) && (MenuSoundNum<i+1))
		{
			PlayerOwner.PlaySound(SwooshMenuInSound);
			MenuSoundNum = i+1;
		}
		
		// Menu is ready once all motion done
		if ((x>=Margin) && (i>=MenuLength))
			bMenuReadyForInput = true;
		
		Canvas.SetPos(x, StartY + Spacing * i);
		DancingText(Canvas,MenuList[i],i);
		//Canvas.DrawText(MenuList[i], false);
	}
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	Canvas.Style = 2;
}

// Text Menu Draw Routines
//
function TextMenuRight ( canvas Canvas )
{
	local float spacing,StartY;
	local int i,x;
	local float MenuRightSide;
	local int Margin;
	
	MenuRightSide = Canvas.SizeX;
	
	Margin = Canvas.SizeX*0.03;
	StartY = Canvas.SizeY*0.1;
	Spacing = Canvas.SizeY*0.095;
	if (Spacing<25) Spacing = 25;
	
	FontMenu(Canvas);
	
	for (i=0; i<MenuLength; i++)
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
		x = (MenuExistTime*500)-200-(i*40);
		if (x>Margin) x=Margin;
		
		// Check if menu across x threshold point to make a sound
		if ((x>-50) && (MenuSoundNum<i+1))
		{
			PlayerOwner.PlaySound(SwooshMenuInSound);
			MenuSoundNum = i+1;
		}
		
		// Menu is ready once all motion done
		if ((x>=Margin) && (i>=MenuLength-1))
			bMenuReadyForInput = true;
		
		DancingTextRight(Canvas, MenuRightSide-x, StartY + Spacing * i, MenuList[i],i);
	}
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	Canvas.Style = 2;
}

// Text Menu Draw Routines
//
function TextMenuCenter ( canvas Canvas )
{
	local float spacing,StartY;
	local int i,x;
	local int Margin;
	local float Left;
	local float TX,TY;

	Margin = Canvas.SizeX*0.5;
	StartY = Canvas.SizeY*0.1;
	Spacing = Canvas.SizeY*0.095;
	if (Spacing<23) Spacing = 23;
	
	FontMenu(Canvas);

	for (i=0; i<=MenuLength; i++)
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
		x = (MenuExistTime*500)-200-(i*40);
		
		Canvas.StrLen(MenuList[i],TX,TY);
		Left = Margin-TX/2;
		
		if (x>Left) x=Left;
		
		// Check if menu across x threshold point to make a sound
		if ((x>Left-80) && (MenuSoundNum<i+1))
		{
			PlayerOwner.PlaySound(SwooshMenuInSound);
			MenuSoundNum = i+1;
		}
		
		// Menu is ready once all motion done
		if ((x>=Margin) && (i>=MenuLength))
			bMenuReadyForInput = true;
		
		Canvas.SetPos(x, StartY + Spacing * i);
		DancingText(Canvas,MenuList[i],i);
		//Canvas.DrawText(MenuList[i], false);
	}
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	Canvas.Style = 2;
}

defaultproperties
{
     MenuEntrySound=Sound'JazzSounds.Interface.whoosh'
     MenuBarTR=Texture'JazzArt.MenuBarTR'
     MenuBarTL=Texture'JazzArt.MenuBarTL'
     MenuBarBR=Texture'JazzArt.MenuBarBR'
     MenuBarBL=Texture'JazzArt.MenuBarBL'
     MenuBar=Texture'JazzArt.MenuBar'
     MenuBack=Texture'JazzArt.MenuBack'
     NWater3=Texture'JazzArt.NWater3'
     MenuTop=Texture'JazzArt.MenuTop'
     MenuBarTRX=Texture'JazzArt.MenuBarTRX'
     MenuBarTLX=Texture'JazzArt.MenuBarTLX'
     MenuBarBRX=Texture'JazzArt.MenuBarBRX'
     MenuBarBLX=Texture'JazzArt.MenuBarBLX'
     MenuBckR=Texture'MenuBckR'
     MenuBck=Texture'MenuBck'
     changeselection=Sound'JazzSounds.changeselection'
     menuweird=Sound'JazzSounds.menuweird'
}
