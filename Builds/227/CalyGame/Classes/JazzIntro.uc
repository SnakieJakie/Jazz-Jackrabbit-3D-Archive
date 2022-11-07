//=============================================================================
// JazzIntro.
//=============================================================================
class JazzIntro expands JazzGameInfo;

var PlayerPawn NewPlayer;

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	
	NewPlayer = Super.Login(Portal, Options, Error, SpawnClass);	
	NewPlayer.bHidden = true;
	SetTimer(0.05,False);
	return NewPlayer;
}

Function Timer()
{
	local Actor A;
	local InterpolationPoint i;	
	
	if ( NewPlayer != None )
	{	
		foreach AllActors( class 'InterpolationPoint', i, 'Path' )
		{
			if( i.Position == 0 )
			{			

				NewPlayer.SetCollision(false,false,false);
				NewPlayer.Target = i;
				NewPlayer.SetPhysics(PHYS_Interpolating);
				NewPlayer.PhysRate = 1.0;
				NewPlayer.PhysAlpha = 0.0;
				NewPlayer.bInterpolating = true;
//				NewPlayer.GotoState('');				
			}
		}
	}


}

//
// Starts at 0 by default.  Denotes time in seconds.
//
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

// Old Unreal Stuff
//
function Killed(pawn killer, pawn Other, name damageType)
{
	super.Killed(killer, Other, damageType);
}	

function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)
{
	if ( Incoming.IsA('JazzPlayer') )
	{
		Spawn(class'JazzActorLighting',Incoming);
		
		//Incoming.PlaySound(sound'Teleport1',, 10.0);
	}
}

function DiscardInventory(Pawn Other)
{
	if ( Other.Weapon != None )
		Other.Weapon.PickupViewScale *= 0.7;
	Super.DiscardInventory(Other);
}


// Default Game Type sends 1-second timings
//
/*function Timer()
{
	Super.Timer();

	// Game Timing
	//
	if (WeatherManager != None)
	WeatherManager.AddTime(1);
}*/

defaultproperties
{
     GameMenuType=None
     HUDType=Class'CalyGame.JazzIntroHUD'
     WaterZoneType=Class'UnrealShare.WaterZone'
}
