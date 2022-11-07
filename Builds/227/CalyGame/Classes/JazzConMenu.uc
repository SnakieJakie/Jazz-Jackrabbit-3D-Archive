//=============================================================================
// JazzConMenu.
//=============================================================================
class JazzConMenu expands JazzMenu;

//
// Basic configuration functions necessary for altering the GameType class and saving
// the options afterward.
//

var() class<GameInfo> GameClass;
var	  GameInfo	GameType;

function Destroyed()
{
	Super.Destroyed();
	if ( GameType != Level.Game )
		GameType.Destroy();
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if ( Level.Game.Class == GameClass )
		GameType = Level.Game;
	else
		GameType = Spawn(GameClass);
}

function SaveConfigs()
{
	if ( GameType != None )
		GameType.SaveConfig();
	PlayerOwner.SaveConfig();
}

defaultproperties
{
}
