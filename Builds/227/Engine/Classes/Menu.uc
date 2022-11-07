//=============================================================================
// Menu: An in-game menu.
// This is a built-in Unreal class and it shouldn't be modified.
//
// Serves as a generic menu master class.  Can be used with any style
// of menu implementation.  Offers menu services such as reading input.
// Not dependent on any visual style.
//=============================================================================
class Menu expands Actor
	intrinsic;

var Menu	ParentMenu;
var int		Selection;
var() int	MenuLength;
var bool	bConfigChanged;
var bool    bExitAllMenus;
var PlayerPawn PlayerOwner;

var() localized string[255] HelpMessage[24];
var() localized string[128] MenuList[24];
var() localized string[32] LeftString;
var() localized string[32] RightString;
var() localized string[32] CenterString;
var() localized string[32] EnabledString;
var() localized string[32] DisabledString;
var() localized string[64] MenuTitle;
var() localized string[16] YesString;
var() localized string[16] NoString;

function bool ProcessSelection();
function bool ProcessLeft();
function bool ProcessRight();
function bool ProcessYes();
function bool ProcessNo();
function SaveConfigs();
function PlaySelectSound();
function PlayModifySound();
function PlayEnterSound();
function ProcessMenuInput( coerce string[64] InputString );
function ProcessMenuUpdate( coerce string[64] InputString );
function ProcessMenuEscape();
function ProcessMenuKey( int KeyNo, string[32] KeyName );
function MenuTick( float DeltaTime );
function MenuInit();

function DrawMenu(canvas Canvas);

function ExitAllMenus()
{
	while ( Hud(Owner).MainMenu != None )
		Hud(Owner).MainMenu.ExitMenu();
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

	Destroy();
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
		Canvas.DrawColor = Canvas.Default.DrawColor;
}

function MenuProcessInput( byte KeyNum, byte ActionNum )
{
	if ( KeyNum == EInputKey.IK_Escape )
	{
		PlayEnterSound();
		ExitMenu();
		return;
	}	
	else if ( KeyNum == EInputKey.IK_Up )
	{
		PlaySelectSound();
		Selection--;
		if ( Selection < 1 )
			Selection = MenuLength;
	}
	else if ( KeyNum == EInputKey.IK_Down )
	{
		PlaySelectSound();
		Selection++;
		if ( Selection > MenuLength )
			Selection = 1;
	}
	else if ( KeyNum == EInputKey.IK_Enter )
	{
		bConfigChanged=true;
		if ( ProcessSelection() )
			PlayEnterSound();
	}
	else if ( KeyNum == EInputKey.IK_Left )
	{
		bConfigChanged=true;
		if ( ProcessLeft() )
			PlayModifySound();
	}
	else if ( KeyNum == EInputKey.IK_Right )
	{
		bConfigChanged=true;
		if ( ProcessRight() )
			PlayModifySound();
	}
	else if ( Chr(KeyNum) ~= left(YesString, 1) ) 
	{
		bConfigChanged=true;
		if ( ProcessYes() )
			PlayModifySound();
	}
	else if ( Chr(KeyNum) ~= left(NoString, 1) )
	{
		bConfigChanged=true;
		if ( ProcessNo() )
			PlayModifySound();
	}

	if ( bExitAllMenus )
		ExitAllMenus(); 
	
}

defaultproperties
{
     Selection=1
     HelpMessage(1)="This menu has not yet been implemented."
     LeftString="Left"
     RightString="Right"
     CenterString="Center"
     EnabledString="Enabled"
     DisabledString="Disabled"
     YesString="yes"
     NoString="no"
     bHidden=True
}