//=============================================================================
// LevelPrecipitationManager.
//=============================================================================
class LevelPrecipitationManager expands Info;

var()	float	RainLevel;			// Approx. Raindrops per second

var()	float	Temperature;		// Determine precipitation type
									// -xx to 32 degrees : Snow
									// 33+		 degrees : Rain
									//

var()	float	ThunderLevel;		// Thunder amount for storm (if any)
									// Windspeed
									// Wind Direction

// Size of the effect field
//
var()	float	RainXSize;
var()	float	RainYSize;
var()	float	SnowXSize;
var()	float	SnowYSize;

event NewWeather ( float NewRainLevel, float NewTemperature, float NewThunderLevel )
{
RainLevel = NewRainLevel;
Temperature = NewTemperature;
ThunderLevel = NewThunderLevel;
}

event Tick (float DeltaTime)
{
	local vector NewLocation;
	local int i;
	
	local actor Image;
	local float RainLevelTick;
	local Pawn aPawn;

// There is precipitation
// 
if (RainLevel>0)
{
RainLevelTick = RainLevel*DeltaTime+FRand()-0.5;

if (RainLevelTick>0)
{
	aPawn = Level.PawnList;

	while ((aPawn != None))
	{

	if (JazzPlayer(aPawn) != None)
	{

		// Snow?
		if (Temperature<32)
		{
		//Log("Snowing) "$RainLevelTick);
		for (i=0; i<RainLevelTick; i++)
		{
			// TODO: Do a trace from height origin to player to check for anything that crosses
		
			NewLocation = VRand();
			NewLocation.X *= RainXSize;
			NewLocation.Y *= RainYSize;
			NewLocation.Z = 0;
			NewLocation += JazzPlayer(aPawn).MyCameraLocation + vector(JazzPlayer(aPawn).MyCameraRotation) * 400 + aPawn.Velocity*2;	// Snow
			NewLocation.Z = JazzPlayer(aPawn).MyCameraLocation.Z + FRand()*300;		// 300 is maximum camera view distance
		
			Image = spawn(class'SpritePoofieSnowflake',,,NewLocation);
			
			if (Image != None)
			{
			SingleSparklies(Image).SkipPreBegin = true;
			SingleSparklies(Image).Drifting = 0.5;
			SingleSparklies(Image).MaxLifeSpan = 6;
			SingleSparklies(Image).LifeSpan = 6;
			SingleSparklies(Image).OwnerExists = false;
			if (RainLevel>10)
			SingleSparklies(Image).MaxDrawScale = 0.0625;
			else
			SingleSparklies(Image).MaxDrawScale = 0.03125;
			Image.Velocity = vect(0,0,-150);
			}
		}
		}
		else
		// Sleet?
	
	
	
		// Rain?
		{
		//Log("Raining) "$RainLevel*DeltaTime);
		for (i=0; i<RainLevelTick; i++)
		{
			// TODO: Do a trace from height origin to player to check for anything that crosses
		
			NewLocation = VRand();
			NewLocation.X *= RainXSize;
			NewLocation.Y *= RainYSize;
			NewLocation.Z = 0;
			NewLocation += JazzPlayer(aPawn).MyCameraLocation + vector(JazzPlayer(aPawn).MyCameraRotation) * 400 + aPawn.Velocity;
			NewLocation.Z = JazzPlayer(aPawn).MyCameraLocation.Z + FRand()*300;		// 300 is maximum camera view distance
		
			// Rain
			//
			Image = spawn(class'SpritePoofieWaterDrop',,,NewLocation);
		
			if (Image != None)
			{
	//		SingleSparklies(Image).SkipPreBegin = true;
	//		SingleSparklies(Image).Drifting = 0.5;
			SingleSparklies(Image).MaxLifeSpan = 6;
			SingleSparklies(Image).LifeSpan = 6;
			SingleSparklies(Image).OwnerExists = false;
			SingleSparklies(Image).MaxDrawScale = 1;
			Image.Velocity = vect(0,0,-600);
			}
		}
		}

	}		
	aPawn = aPawn.nextPawn;	
	}
}
}
}

defaultproperties
{
     RainLevel=10.000000
     ThunderLevel=30.000000
     RainXSize=1000.000000
     RainYSize=1000.000000
     SnowXSize=1000.000000
     SnowYSize=1000.000000
     Texture=Texture'UnrealI.Skins.JMoon1'
}
