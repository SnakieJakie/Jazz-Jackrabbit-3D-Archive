//=============================================================================
// JazzServerMenu.
//=============================================================================
class JazzServerMenu expands JazzMenu
	config;

var		int		MenuSoundNum;
var()	sound	SwooshMenuInSound;

//
var config string 	Map;
var config string 	GameType;
var config string 	GameTypeName[16];
var	string		  	GameTypeDisplay;
var config string 	Games[16];
var config int MaxGames;
var int CurrentGame;
var class<GameInfo> GameClass;
var bool bStandalone;
//var localized string BotTitle;


// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	//Log("JazzServer) "$Games[0]);

	ResetMenu();

	// Set maximum games to 2 if shareware?
//	if ( class'GameInfo'.Default.bShareware )
//		MaxGames = 2;		// 220 Version
		
	// Game Default Selection
	CurrentGame = 0;
	SetGameClass();
}

function bool ProcessLeft()
{
	if ( Selection == 1 )
	{
		CurrentGame--;
		if ( CurrentGame < 0 )
			CurrentGame = MaxGames;
		SetGameClass();
		if ( GameClass == None )
		{
			MaxGames--;
			if ( MaxGames > 0 )
				ProcessLeft();
		}
	}
	else if ( Selection == 2 )
	{
		GameClass = class<gameinfo>(DynamicLoadObject(GameType, class'Class'));
		Map = GetMapName(GameClass.Default.MapPrefix, Map, -1);
	}
	else 
		return false;

	return true;
}

function bool ProcessRight()
{
	if ( Selection == 1 )
	{
		CurrentGame++;
		if ( CurrentGame > MaxGames )
			CurrentGame = 0;
		SetGameClass();
		if ( GameClass == None )
		{
			MaxGames--;
			if ( MaxGames > 0 )
				ProcessRight();
		}

	}
	else if ( Selection == 2 )
	{
		GameClass = class<gameinfo>(DynamicLoadObject(GameType, class'Class'));
		Map = GetMapName(GameClass.Default.MapPrefix, Map, 1);
	}
	else
		return false;

	return true;
}

//
function SetGameClass()
{
	GameType = Games[CurrentGame];
	GameClass = class<gameinfo>(DynamicLoadObject(GameType, class'Class'));
	Map = GetMapName(GameClass.Default.MapPrefix, Map,0);
	
	// Extract preceding '.' and class name in GameType string for display.
	//
	GameTypeDisplay = GameTypeName[CurrentGame];
	
	//Log("Game Class) "$GameTypeDisplay);
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
	local string URL;
	local GameInfo NewGame;

	GameClass = class<gameinfo>(DynamicLoadObject(GameType, class'Class'));
	
	if( Selection == 3 )
	{
		ChildMenu = spawn( GameClass.Default.GameMenuType, owner );
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
		return true;
	}
	else if ( Selection == 4 )
	{
		NewGame = Spawn(GameClass);
		NewGame.ResetGame();
		NewGame.Destroy();

		URL = Map $ "?Game=" $ GameType;
//		if( !bStandAlone )		// CALYCHANGE : Listen removed so that single-player same as multiplayer
			URL = URL $ "?Listen";
			
//		if( !bStandAlone && Level.Netmode!=NM_ListenServer )
//			URL = URL $ "?Listen";
		SaveConfigs();
		ChildMenu = spawn(class'JazzMultiplayerCharacterSelectMenu', owner);
		if ( ChildMenu != None )
		{
			JazzMultiplayerCharacterSelectMenu(ChildMenu).StartMap = URL;
			HUD(Owner).MainMenu = ChildMenu;
			ChildMenu.ParentMenu = self;
			ChildMenu.PlayerOwner = PlayerOwner;
		}
		return true;
	}
	else if ( Selection == 5 )
	{
		NewGame = Spawn(GameClass);
		NewGame.ResetGame();
		NewGame.Destroy();
		
		URL = Map $ "?Game=" $ GameType;
		SaveConfigs();
		PlayerOwner.ConsoleCommand("RELAUNCH "$URL$" -server");
		return true;
	}
	else return false;
}

function SaveConfigs()
{
	SaveConfig();
	PlayerOwner.SaveConfig();
}

function DrawMenu (canvas Canvas)
{
	local int	i,x,MinX;
	local int	spacing,StartY;

	MenuStart(Canvas);
	
	DrawBackgroundA(Canvas);

	TextMenuLeft(Canvas);
	
	MenuSelections[0] = Caps(GameTypeDisplay);
	
	x = InStr(Map,".");
	if (x>0)
	MenuSelections[1] = Left(Caps(Map),InStr(Map,"."));
	else
	MenuSelections[1] = Caps(Map);
	
	TextMenuSelections(Canvas);
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	
	MenuEnd(Canvas);
}

defaultproperties
{
     Map="JMPClover.unr"
     GameType="JazzMultiPlayer.TreasureHunt"
     GameTypeName(0)="Treasure Hunt"
     GameTypeName(1)="Battle Mode"
     GameTypeName(2)="Team Battle Mode"
     GameTypeName(3)="Leader of the Pack"
     GameTypeName(4)="Capture The Flag"
     Games(0)="JazzMultiPlayer.TreasureHunt"
     Games(1)="CalyGame.BattleMode"
     Games(2)="CalyGame.TeamBattleMode"
     Games(3)="CalyGame.LeaderOfThePack"
     Games(4)="CalyGame.CaptureTheFlag"
     MaxGames=4
     MenuLength=5
     MenuList(0)="CHOOSE GAME"
     MenuList(1)="CHOOSE MAP"
     MenuList(2)="CONFIGURE GAME"
     MenuList(3)="START GAME"
     MenuList(4)="LAUNCH DEDICATED SERVER"
}
