//=============================================================================
// LevelWeatherManager.
//=============================================================================
class LevelWeatherManager expands Info;

//
// Class Info / GameInfo / UnrealGameInfo / CalyGame.JazzSinglePlayer contains further
// instructions on implementing weather / time lighting into your level.
//
// One LevelWeatherManager actor must be placed anywhere in your level to automatically
// manage the various light actors correctly.
//

/////////////////////////////////////////////////////////////////////////////////////////
// What this does:
//
// This class alters every WeatherLight contained within the level to give the effect of
// night and day.  It will be expanded to add simple weather patterns as well.
//
// The variables below determine how long one day is, the color to fade the light to
// on certain conditions, etc.
//

// Note that this actor will only do one sun specifically.  We should avoid drawing certain
// specific things (and fortunately don't need to as the player should not be able to look
// up much at all) like the sun/clouds/etc.  Drawing a sun is possible, though, through
// the use of fog and sprite-based coronas.
//

////////////////////////////////////////////////////////////////////////////////////////
// Usage of this actor class:
//
// It is recommended to subclass this actor based on each planet's settings, then modify
// it if necessary for local area conditions.
//

////////////////////////////////////////////////////////////////////////////////////////
// How WeatherLight works:
//
// The light settings for each WeatherLight represent optimal settings for a daytime
// environment.
//
// A light is intended to never go beyond the brightness level set in that light
// *unless* during a lightning strike.  Day and night are created by altering that
// brightness level and mixing in the current time/weather color.
//


// Length of a day in seconds (actual real-world seconds).
//
var (JazzTime) 	float	LengthOfOneDay;
var (JazzTime)	float	OffsetFromUniversalTime;
var (JazzTime)	int		DaysInYear;

// Direction the sun travels (to cascade the lights)
//
var (JazzTime)	rotator	SunDirection;

// Color and brightness level for lights in a normal (bright/sunny) day.
//
var (JazzTime)	byte	NormalDayHue;
var (JazzTime)	byte	NormalDaySaturation;
var (JazzTime)	byte	NormalDayBrightness;
var (JazzTime)	byte	NormalNightHue;
var (JazzTime)	byte	NormalNightSaturation;
var (JazzTime)	byte	NormalNightBrightness;

// Color and brightness level for lights in a 100% cloudy day.
//
var (JazzTime)	byte	CloudyDayHue;
var (JazzTime)	byte	CloudyDayBrightness;
var (JazzTime)	byte	CloudyNightHue;
var (JazzTime)	byte	CloudyNightBrightness;

// Color and brightness level for lights in a lightning burst.
//
var (JazzWeather)	byte	LightningDayHue;
var (JazzWeather)	byte	LightningDayBrightness;
var (JazzWeather)	byte	LightningNightHue;
var (JazzWeather)	byte	LightningNightBrightness;

var (JazzAmbient)	sound	DaySounds[20];
var (JazzAmbient)	int		DaySoundNum;
var (JazzAmbient)	sound	NightSounds[20];
var (JazzAmbient)	int		NightSoundNum;
var (JazzAmbient)	sound	RainSounds[20];
var (JazzAmbient)	int		RainSoundNum;
var (JazzAmbient)	sound	ThunderSounds[10];
var (JazzAmbient)	int		ThunderSoundNum;
var (JazzAmbient)	sound	CloudyDaySounds[10];
var (JazzAmbient)	int		CloudyDaySoundNum;
var (JazzAmbient)	sound	CloudyNightSounds[10];
var (JazzAmbient)	int		CloudyNightSoundNum;
var (JazzAmbient)	byte	RateOfSound;

var (JazzPatterns)	float	CloudDayPatterns[20];

// Storm Systems
//
var (JazzWeather)	float	StormPattern[100];		// Hours between storms
var (JazzWeather)	int		StormLightning[100];	// Strength max of lightning with storm
var (JazzWeather)	int		StormStrength[100];		// Strength max of each storm (suggested max 50 - periods of 0 will result in no storm)
var	(JazzWeather)	int		StormPatternLength;		// Length of pattern
var					float	StormTotalHours;		// Calculated # of hours until repeat

// Temperature Systems
var (JazzWeather)	int		TempSummer;				// Degrees farenheit
var (JazzWeather)	int		TempWinter;				//
var (JazzWeather)	float	TempPattern[100];		// Hours between temperature change
var (JazzWeather)	int		TempStrength[100];		// Strength max of each change 
													// (-x decrease temperature or +x increase)
var	(JazzWeather)	int		TempPatternLength;		// Length of pattern
var					float	TempTotalHours;	 		// Calculated # of hours until repeat

// CurrentData
//
var float	CurrentUniversalTime;					// Measured in 'hours'
													// 1 unit = 1 hour
													//
var float	CurrentDay;
var float	LocalTime;
var float	NightDayMix;
var	float	CurrentLightningLevel;

var int				WeatherLightNum;
var WeatherLight	WeatherLightActors[100];

var LevelPrecipitationManager	PrecipManager;

// Called by Jazz GameInfo
//
function StartManager()
{
	// Scan for all WeatherLight actors.
	//
	local actor SearchActor;
	local class SearchClass;
	local int	L;
	
	SearchClass = class'WeatherLight';

	//Log("WeatherManager) Finding Weather Lights");
	
	// Find LevelWeatherManager
	//
	L = -1;
	foreach allactors(class<actor>(SearchClass), SearchActor )
	{
		L++;
		if (L<100)
		WeatherLightActors[L]=WeatherLight(SearchActor);
	}

	// Todo: Alter lights in a cascading fashion based on the distance along in the direction
	// set for the sun's arc.  In other words, use another array variable for the relative 
	// distance along.
	
	WeatherLightNum = L;
	
	// Find LevelPrecipitationManager
	//
	SearchClass = class'LevelPrecipitationManager';
	
	foreach allactors(class<actor>(SearchClass), SearchActor )
	{
		PrecipManager = LevelPrecipitationManager(SearchActor);
	}
	
	// Initialize Storm pattern system
	//
	StormTotalHours = 0;
	for (l=0; l<=StormPatternLength; l++)
	{
		StormTotalHours += StormPattern[l];
	}
	
	// Initialize Temperature pattern system
	// 
	TempTotalHours = 0;
	for (l=0; l<=TempPatternLength; l++)
	{
		TempTotalHours += TempPattern[l];
	}
	
	
	// Finally, let's set up the lights accordingly.
	//
	Update();
}

function AddTime(float Time)
{
	CurrentUniversalTime += Time;

	Update();
}

function SetTime(float Time)
{
	CurrentUniversalTime = Time;

	Update();
}

function StormUpdate( int l, float Time )
{
	local float temp;
	local float result;
	
	// Todo: Fade from one strength to another?
	//
	temp = 	1-(abs(Time - StormPattern[l]/2)/(StormPattern[l]/2));

	//Log("NewRainLevel) "$temp$" "$StormStrength[l]$" "$Time$" "$StormPattern[l]/2);

	if (PrecipManager != None)
	PrecipManager.RainLevel = temp * StormStrength[l];

	// Lightning
	//
	CurrentLightningLevel = temp * StormLightning[l];
}

// System Update (Calculate everything)
//
function Update()
{
	local float Temp;
	local int l;

	// Error check
	//
	if (LengthOfOneDay==0) return;
	
	// Get Local Time
	//
	CurrentDay = (CurrentUniversalTime+OffsetFromUniversalTime) / LengthOfOneDay;
	LocalTime = (CurrentUniversalTime+OffsetFromUniversalTime) % LengthOfOneDay;
	//Log("WeatherManager) Day"$CurrentDay$" Time"$LocalTime);

	// Mix Night/Day	
	//
	Temp = sin((LocalTime/LengthOfOneDay)*Pi*2-(Pi/2) );	// Range -1 (night) to 1 (day)
	if (Temp<-0.5)
	NightDayMix = 0;
	else
	if (Temp> 0.5)
	NightDayMix = 1;
	else
	NightDayMix = Temp+0.5;
	
	//Log("WeatherManager) DayNightMix "$NightDayMix$" "$Temp);


	/////////// Update storm values
	//
	//
	//
	//Log("Current Time) "$CurrentUniversalTime);
	//Log("StormTotalHours) "$StormTotalHours);
	if (StormTotalHours>0)
	{
	// Get storm pattern #
	Temp = CurrentUniversalTime % StormTotalHours;
	//Log("Storm Hour Log)"$Temp);
	l=0;
	while ((l<=StormPatternLength) && (Temp>StormPattern[l]))
	{
		Temp -= StormPattern[l];		
		l++;
	}
	
	// Apply storm values
	StormUpdate(l,temp);

	}
	
	/////////// Update temperature
	//
	//
	//
	// Year timing (Seasonal changes)
	
	// Temperature change pattern
	
	// Apply Temperature
	
	UpdateLights();
}

function int RangeMix(int Low, int High, float C)
{
	if (Low<=High)
	{
		return( Low + (High-Low)*C );
	}
	else
	{
		return( High + (Low-High)*C );
	}	
}

function int RangeScale(int A, int B, float C)
{
	if (A-B>128)
		B += 255;
	else
	if (B-A>128)
		A += 255;
	
	if (A<=B)
	{
	//Log("WeatherManager) "$A$" "$B$" "$A-(B-A)*C);
		return( A + (B-A)*C );
	}
	else
	{
	//Log("WeatherManager) "$A$" "$B$" "$(A-B)$" "$(A-B)*C$" "$byte(A-(A-B)*C));
		return( A - (A-B)*C );
	}
	
}


function UpdateLights()
{
	local int i;
	local byte BaseWeatherBrightness,BaseWeatherHue,BaseWeatherSaturation;

//var byte			WeatherLightNum;
//var WeatherLight	WeatherLightActors[100];

	//Log("WeatherManager) "$NormalNightBrightness$" "$NormalDayBrightness$" "$NightDayMix);
	
	BaseWeatherBrightness = RangeMix(NormalNightBrightness,NormalDayBrightness,NightDayMix);
	BaseWeatherSaturation = RangeMix(NormalNightSaturation,NormalDaySaturation,NightDayMix);
	BaseWeatherHue		  = RangeScale(NormalNightHue,NormalDayHue,NightDayMix);

	//Log("WeatherManager) BaseBrightness "$BaseWeatherBrightness);
	//Log("WeatherManager) BaseSaturation "$BaseWeatherHue);
	
	if (WeatherLightNum>-1)
	for (i=0; i<=WeatherLightNum; i++)
	{
		if (WeatherLightActors[i] != None)
		{
	
		WeatherLightActors[i].LightBrightness = BaseWeatherBrightness *
			(float(WeatherLightActors[i].Default.LightBrightness)/255);
		WeatherLightActors[i].LightSaturation = BaseWeatherSaturation *
			(float(WeatherLightActors[i].Default.LightSaturation)/255);
		WeatherLightActors[i].LightHue = BaseWeatherHue;
			//RangeScale( WeatherLightActors[i].Default.LightHue,BaseWeatherHue,0.1);
			
		WeatherLightActors[i].WeatherUpdate();
			
		//Log("WeatherManager) WeatherLightBaseBrightness "$i$" "$WeatherLightActors[i].LightBrightness);
		//Log("WeatherManager) WeatherLightSaturation "$i$" "$WeatherLightActors[i].LightSaturation);
		//Log("WeatherLight) "$WeatherLightActors[i]);
		}
	}
	
	// Ambient sound?
	//
	if (FRand()*255<RateOfSound)
		PlayAmbientSound();
		
	// Lightning crash?
	//
	//Log("LightningLevel) "$CurrentLightningLevel$" "$CurrentLightningLevel/255);
	if (FRand()*255<=CurrentLightningLevel)
		CauseLightning();	
}

function CauseLightning()
{
	local int	L;

	if (WeatherLightNum>-1)
	{
		L = FRand()*WeatherLightNum;
	
		WeatherLightActors[L].LightningStart(FRand()*CurrentLightningLevel);
	}
}

function PlayAmbientSound()
{
	local int	L;
	local sound S;
	
	if (WeatherLightNum>-1)
	{
		L = FRand()*WeatherLightNum;
		
		// Check for recent lightning sound
		//
		if (WeatherLightActors[L].RumbleSoundDelay>0)
		return;
	
		// Decide type of sound to play
		if (NightDayMix+FRand()*0.3-0.15>0.5)
		{
			// Day
			S = DaySounds[FRand()*DaySoundNum];
		}
		else
		{
			// Night
			S = NightSounds[FRand()*NightSoundNum];
		}
		
		//WeatherLightActors[L].PlaySound(S,SLOT_Ambient,200,true,100000);
		WeatherLightActors[L].PlaySound(S,,FRand()*0.7+0.3,,100000,FRand()*0.2+0.9);
		WeatherLightActors[L].RumbleSoundDelay = 4;
		//PlaySound(S);
	
		//Log("AmbientSound) "$L$" "$S);
	}
}

defaultproperties
{
     LengthOfOneDay=1000.000000
     OffsetFromUniversalTime=500.000000
     NormalDayHue=20
     NormalDaySaturation=255
     NormalDayBrightness=255
     NormalNightHue=153
     NormalNightSaturation=50
     NormalNightBrightness=200
     CloudyDayHue=127
     CloudyDayBrightness=67
     CloudyNightHue=153
     DaySounds(0)=Sound'AmbOutside.OneShot.bird50'
     DaySounds(1)=Sound'AmbOutside.OneShot.bird51'
     DaySounds(2)=Sound'AmbOutside.OneShot.bird80'
     DaySounds(3)=Sound'AmbOutside.OneShot.bird90'
     DaySounds(4)=Sound'AmbOutside.OneShot.buzz10'
     DaySoundNum=4
     NightSounds(0)=Sound'AmbOutside.OneShot.crick01'
     NightSounds(1)=Sound'AmbOutside.OneShot.crick02'
     NightSounds(2)=Sound'AmbOutside.OneShot.cricket5'
     NightSounds(3)=Sound'AmbOutside.OneShot.owl1'
     NightSounds(4)=Sound'AmbAncient.OneShot.mcreak6'
     NightSounds(5)=Sound'AmbAncient.OneShot.scaryN3'
     NightSounds(6)=Sound'AmbOutside.OneShot.call6'
     NightSoundNum=6
     RateOfSound=70
     Texture=Texture'UnrealI.Skins.JMoon1'
     DrawScale=0.250000
}
