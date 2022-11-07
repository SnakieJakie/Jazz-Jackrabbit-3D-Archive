//=============================================================================
// WeatherLight.
//=============================================================================
class WeatherLight expands Light;

//
// For instructions also see:
// 
// Class Info / GameInfo / UnrealGameInfo / CalyGame.JazzSinglePlayer contains further
// instructions on implementing weather / time lighting into your level.
//
// Class Info / CalyGame.LevelWeatherManager
//
//

var float	RumbleTime;				// Countdown
var	float	RumbleTimeMax;
var bool	RumbleNext;
var float	RumbleIntensity;
var	float	RumbleSoundDelay;

var() sound LightnSound[8];

// Lightning
//
function LightningStart( float LightningLevel )
{
	local int LightningNum;
	local sound LightningSound;

	if (RumbleSoundDelay>0) return;

	RumbleIntensity = FRand()*1.5;
	
	RumbleNext = FRand()<0.2;
	
	RumbleTime =  FRand()+LightningLevel/100;
	RumbleTimeMax = RumbleTime;
	
	//Log("Lightning");
	
	// Lightning Sound
	//
	LightningNum = Rand(8);
	
	switch LightningNum
	{
	case 0:	LightningSound = LightnSound[0];	break;
	case 1: LightningSound = LightnSound[1];	break;
	case 2: LightningSound = LightnSound[2];	break;
	case 3: LightningSound = LightnSound[3];	break;
	case 4: LightningSound = LightnSound[4];	break;
	case 5: LightningSound = LightnSound[5];	break;
	case 6: LightningSound = LightnSound[6];	break;
	case 7: LightningSound = LightnSound[7];	break;
	}
	PlaySound(LightningSound,,1.5,,100000,FRand()*0.2+0.9);
	
	if (RumbleSoundDelay<10)	RumbleSoundDelay = 10;
}

// Update performed after weather/time of day modification by main weather manager
//
function WeatherUpdate ()
{
	local float	RumbleModifier;
	local int   NewV;

	// Lightning Flash Intensity
	//
	if (RumbleTime>0)
	{
		RumbleModifier =
			(RumbleIntensity) * 
			(1-((RumbleTimeMax-RumbleTime)/RumbleTimeMax));

		//Log("Rumble) "$Name$" Time:"$RumbleTime$" "$RumbleTimeMax$" "$RumbleModifier$" "$RumbleIntensity);
		
		NewV = Default.LightRadius * (1+RumbleModifier);
		if (NewV>255) NewV=255;
		LightRadius = NewV;
		//Log("LightRadius) "$LightRadius);
			
		NewV = LightSaturation * (1+RumbleModifier);
		if (NewV>255) NewV=255;
		LightSaturation = NewV;
		//Log("LightSaturation) "$LightSaturation);

		NewV = LightBrightness * (1+RumbleModifier);
		if (NewV>255) NewV=255;
		LightBrightness = NewV;
		//Log("LightBrightness) "$LightBrightness);
	}
}

event Tick(float DeltaTime)
{
	// Lighting time update
	//
	if (RumbleTime>0)
		RumbleTime -= DeltaTime;
		
	if (RumbleSoundDelay>0)
		RumbleSoundDelay -= DeltaTime;
}

defaultproperties
{
     bStatic=False
     LightnSound[0]=sound'lightn10'
     LightnSound[1]=sound'lightn11'
     LightnSound[2]=sound'lightn12'
     LightnSound[3]=sound'lightn1a'
     LightnSound[4]=sound'lightn2a'
     LightnSound[5]=sound'lightn3a'
     LightnSound[6]=sound'lightn4a'
     LightnSound[7]=sound'lightn5a'
}
