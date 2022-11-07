//=============================================================================
// JazzGameInfo.
//=============================================================================
class JazzGameInfo expands GameInfo;

// Starts at 0 by default.  Denotes time in seconds.
//
var float VirtualGameTime;
var	LevelWeatherManager WeatherManager;

var() bool	TutorialsInMode;
var() bool  SinglePlayerGame;
//
// This value is used to determine the change in the lighting based on what time it is.
//
// Since there is no way to have master state information spanning levels or anything of that kind,
// we'll fool the system by maintaining a time for each player.
//
// SinglePlayer : Easy, just use the current player's time.
//
// MultiPlayer DeathMatch/etc : Easy, start the map at 0.
//
// MultiPlayer Cooperative : If one map is used at a time, this is easy, however if running off a
// server with multiple cooperative maps (if such a thing will be possible for us) then it will be
// potentially confusing...  We can deal with this later if necessary.
//
// For now I'm going to implement a time-from-start variable called: 'float LifeTime' in the
// JazzPlayer class.  This will contain the entire life of the player in seconds, from which the
// level will determine the correct time based on this universal time. 
//
// ---
//
// IMPLEMENTING IN YOUR LEVEL:
//
// To add time/weather-based capability into your level, you will need to add:
//
// 1 LevelWeatherManager class actor anywhere into the level - this will be an invisible server
// actor that this class will update on creation.
//
// Use WeatherLight in place of normal lights in any place where a light is created by the world.
// All WeatherLights in a level will be controlled by the LevelWeatherManager class.
//

function PreBeginPlay()
{
	Super.PreBeginPlay();

	SetupWeatherControl();	
}

// Default Game Type sends 1-second timings
//
event Tick( float DeltaTime )
{
	Super.Tick(DeltaTime);

	// Game Timing
	//
	if (WeatherManager != None)
	WeatherManager.AddTime(DeltaTime/120);		// 120 seconds per unit = hour
}

// Finds the weather control actor and sets up weather control.
//
function SetupWeatherControl()
{
	local actor SearchActor;
	local class SearchClass;
	
	SearchClass = class'LevelWeatherManager';
	
	// Find LevelWeatherManager
	//
	foreach allactors(class<actor>(SearchClass), SearchActor )
	{
		WeatherManager = LevelWeatherManager(SearchActor);
	}
	
	if (WeatherManager != None)
	{
		Log("JazzGame) Weather Manager Found - Initializing");
		// Setup Weather Time
		//
		// For now just set to 0 when started.
		//
		VirtualGameTime = 0;
		WeatherManager.SetTime(VirtualGameTime);
		WeatherManager.StartManager();
	}
}

// Original GameInfo functions
//
function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if (injured.Region.Zone.bNeutralZone)
		return 0;

	if ( instigatedBy == None)
		return Damage;
	//skill level modification
	if ( instigatedBy.bIsPlayer )
	{
		if ( injured == instigatedby )
		{ 
			if ( instigatedby.skill == 0 )
				Damage = 0.25 * Damage;
			else if ( instigatedby.skill == 1 )
				Damage = 0.5 * Damage;
		}
		else if ( !injured.bIsPlayer )
			Damage = float(Damage) * (1.1 - 0.1 * injured.skill);
	}
	else if ( injured.bIsPlayer )
		Damage = Damage * (0.4 + 0.2 * instigatedBy.skill);
	return (Damage * instigatedBy.DamageScaling);
}

/*function float PlaySpawnEffect(inventory Inv)
{
	spawn( class 'ReSpawn',,, Inv.Location );
}*/

function bool ShouldRespawn(Actor Other)
{
	return false;
}

function string KillMessage(name damageType, pawn Other)
{
}

function string CreatureKillMessage(name damageType, pawn Other)
{
}

function string PlayerKillMessage(name damageType, pawn Other)
{
	return " was blasted by ";
} 	

defaultproperties
{
     GameMenuType=Class'CalyGame.JazzOptionsMenu'
     HUDType=Class'CalyGame.JazzHUD'
}
