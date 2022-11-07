//=============================================================================
// JazzAudioMenu.
//=============================================================================
class JazzAudioMenu expands JazzMenu;

var int SoundVol, MusicVol;
var bool bLowSoundQuality;
var bool MenuInitYet;

var localized string TxtLow;
var localized string TxtHigh;

function Menu ExitMenu ()
{
	JazzPlayer(PlayerOwner).MusicVolume = MusicVol;
	PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$JazzPlayer(PlayerOwner).MusicVolume*0.1);
	
	Super.ExitMenu();
}

function MenuInit ()
{
	PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$JazzPlayer(PlayerOwner).MusicVolume);
	Log("MenuInit) "$JazzPlayer(PlayerOwner).MusicVolume);
	Super.MenuInit();
}

function GetInformation()
{
	if (MenuInitYet == false)
	{
		MenuInit();
		MenuInitYet = true;
	}

	SoundVol = int(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.AudioDevice SoundVolume"));
	MusicVol = int(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume"));
	Log("MenuMusicVol) "$MusicVol);
	bLowSoundQuality = bool(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.AudioDevice LowSoundQuality"));
}

function bool ProcessLeft()
{
	if ( Selection == 1 )
	{
		MusicVol = Max(0, MusicVol - 32);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$MusicVol);
		return true;
	}
	else if ( Selection == 2 )
	{
		SoundVol = Max(0, SoundVol - 32);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$SoundVol);
		return true;
	}	
	else if ( Selection == 3 )
	{
		bLowSoundQuality = !bLowSoundQuality;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality "$bLowSoundQuality);
		return true;
	}

	return false;
}

function bool ProcessRight()
{
	if ( Selection == 1 )
	{
		MusicVol = Min(255, MusicVol + 32);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$MusicVol);
		return true;
	}
	else if ( Selection == 2 )
	{
		SoundVol = Min(255, SoundVol + 32);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$SoundVol);
		return true;
	}
	else if ( Selection == 3 )
	{
		bLowSoundQuality = !bLowSoundQuality;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality "$bLowSoundQuality);
		return true;
	}
	else
	{
		ExitMenu();
	}

	return false;
}		

function bool ProcessSelection()
{
	if ( Selection == 3 )
	{
		bLowSoundQuality = !bLowSoundQuality;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality "$bLowSoundQuality);
		return true;
	} else
	if (Selection == 4)
	{
		ExitMenu();
	}
		
	return false;
}

function DrawMenu (canvas Canvas)
{
	GetInformation();

	MenuStart(Canvas);
	
	DrawBackgroundARight(Canvas);

	DrawTitle(Canvas);

	TextMenuRight(Canvas);
	
	MenuEnd(Canvas);
}

// General function to return a string based on an integer with the correct # of digits (0s on front)
//
function string Digits ( int Value, int Digit )
{
	local string S;
	
	S = string(Value);

	if (InStr(S,"-")>=0)
	{
	S = Mid(S,1,9999);
	while (Len(S)<Digit-1)	S = "0"$S;
	S = "-"$S;
	}
	else
	while (Len(S)<Digit)	S = "0"$S;
	
	return S;
}

// Text Menu Draw Routines
//
function TextMenuRight ( canvas Canvas )
{
	local float spacing,StartY;
	local int i,x,y;
	local float MenuRightSide;
	local string TempS;
	
	MenuRightSide = Canvas.SizeX;
	
	StartY = Canvas.SizeY*0.1;
	Spacing = Canvas.SizeY*0.095;
	if (Spacing<19) Spacing = 19;
	
	FontMenu(Canvas);
	
	for (i=0; i<MenuLength; i++)
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
		x = (MenuExistTime*500)-200-(i*40);
		if (x>20) x=20;
		
		// Check if menu across x threshold point to make a sound
		if ((x>-50) && (MenuSoundNum<i+1))
		{
			PlayerOwner.PlaySound(SwooshMenuInSound);
			MenuSoundNum = i+1;
		}
		
		// Menu is ready once all motion done
		if ((x>=20) && (i>=MenuLength-1))
			bMenuReadyForInput = true;
		
		DancingTextRight(Canvas, MenuRightSide-x, StartY + Spacing * i, MenuList[i],i);
		
		Canvas.SetPos(MenuRightSide-x-Canvas.SizeX*0.8,StartY+Spacing*i);
		
		switch (i)
		{
		case 0: // Music Volume
			DancingText(Canvas, Digits(MusicVol*100/255,1)$"%", i);
			break;
			
		case 1: // Sound Volume
			DancingText(Canvas, Digits(SoundVol*100/255,1)$"%", i);
			break;
			
		case 2: // Sound Quality
			if (bLowSoundQuality)
			DancingText(Canvas, TxtLow, i);
			else
			DancingText(Canvas, TxtHigh, i);
			break;
		}
	}
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
}

defaultproperties
{
     MenuLength=4
}
