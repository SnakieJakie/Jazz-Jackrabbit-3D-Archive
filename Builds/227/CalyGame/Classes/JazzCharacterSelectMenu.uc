//=============================================================================
// JazzCharacterSelectMenu.
//=============================================================================
class JazzCharacterSelectMenu expands JazzMenu;

var		int		MenuRightSide;

var string	ClassString;
var string	PreferredSkin;
var string	StartMap;

var() localized string 	PlayerClasses[8];
var() localized string 	PlayerSkins[8];
var()	int		PlayerClassNum;
var		int		ClassSelected;

// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	ResetMenu();
}

function ResetMenu()
{
	// Plays sounds as menus move across the screen
	MenuSoundNum = 0;
	MenuExistTime = 0;
	ClassSelected = 0;
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
		//SetOwner(RealOwner);
		bExitAllMenus = true;
			
		switch (Selection)
		{
		case 0:
		case 1:
			// Defaults		
			ClassString = PlayerClasses[0];
			PreferredSkin = PlayerSkins[0];
			break;
		}

		// 220 Version
		StartMap = StartMap
					$"?Class="$ClassString
					$"?Skin="$PreferredSkin
					$"?Name="$PlayerOwner.PlayerReplicationInfo.PlayerName		
					$"?Team="$PlayerOwner.PlayerReplicationInfo.TeamName
					$"?Rate="$PlayerOwner.NetSpeed;

		Log("StartMap) "$StartMap);

		SaveConfigs();
		PlayerOwner.ClientTravel(StartMap, TRAVEL_Absolute, false);
		return true;
	}
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

	// Globals	
	MenuStart(Canvas);
	
	DrawBackGroundARight(Canvas);
	
	DrawTitle(Canvas);		// 220 Version
	
	TextMenuRight ( Canvas );

	// Globals	
	MenuEnd(Canvas);
}

// Background
//
function DrawBackGround(canvas Canvas)
{
}

defaultproperties
{
     PlayerClasses(0)="Class"
     MenuLength=1
     MenuTitle="SELECT CHARACTER"
}
