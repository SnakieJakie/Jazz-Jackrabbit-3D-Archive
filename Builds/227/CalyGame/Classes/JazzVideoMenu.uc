//=============================================================================
// JazzVideoMenu.
//=============================================================================
class JazzVideoMenu expands JazzMenu;

var float brightness;
var string CurrentRes;
var string AvailableRes;
var string MenuValues[20];
var string Resolutions[16];
var int resNum;
var bool bLowTextureDetail;

var localized string TxtRoaming;
var localized string TxtFixed;
var localized string TxtLow;
var localized string TxtHigh;


/*function bool ProcessLeft()
{
	if ( Selection == 1 )
	{
		Brightness = FMax(0.2, Brightness - 0.1);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$Brightness);
		PlayerOwner.ConsoleCommand("FLUSH");
		return true;
	}
	else if ( Selection == 3 )
	{
		ResNum--;
		if ( ResNum < 0 )
		{
			ResNum = ArrayCount(Resolutions) - 1;
			While ( Resolutions[ResNum] == "" )
				ResNum--;
		}
		MenuValues[3] = Resolutions[ResNum];
		return true;
	}	
	else if ( Selection == 5 )
	{
		MusicVol = Max(0, MusicVol - 32);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$MusicVol);
		return true;
	}
	else if ( Selection == 6 )
	{
		SoundVol = Max(0, SoundVol - 32);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$SoundVol);
		return true;
	}	
	else if ( Selection == 4 )
	{
		bLowTextureDetail = !bLowTextureDetail;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager LowDetailTextures "$bLowTextureDetail);
		return true;
	}
	else if ( Selection == 7 )
	{
		bLowSoundQuality = !bLowSoundQuality;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality "$bLowSoundQuality);
		return true;
	}
	else if ( Selection == 8 )
	{
		PlayerOwner.bNoVoices = !PlayerOwner.bNoVoices;
		return true;
	}

	return false;
}

function bool ProcessRight()
{
	local string ParseString;
	local string FirstString;
	local int p;

	if ( Selection == 1 )
	{
		Brightness = FMin(1, Brightness + 0.1);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$Brightness);
		PlayerOwner.ConsoleCommand("FLUSH");
		return true;
	}
	else if ( Selection == 3 )
	{
		ResNum++;
		if ( (ResNum >= ArrayCount(Resolutions)) || (Resolutions[ResNum] == "") )
			ResNum = 0;
		MenuValues[3] = Resolutions[ResNum];
		return true;
	}	
	else if ( Selection == 5 )
	{
		MusicVol = Min(255, MusicVol + 32);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$MusicVol);
		return true;
	}
	else if ( Selection == 6 )
	{
		SoundVol = Min(255, SoundVol + 32);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$SoundVol);
		return true;
	}
	else if ( Selection == 4 )
	{
		bLowTextureDetail = !bLowTextureDetail;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager LowDetailTextures "$bLowTextureDetail);
		return true;
	}
	else if ( Selection == 7 )
	{
		bLowSoundQuality = !bLowSoundQuality;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality "$bLowSoundQuality);
		return true;
	}
	else if ( Selection == 8 )
	{
		PlayerOwner.bNoVoices = !PlayerOwner.bNoVoices;
		return true;
	}

	return false;
}		

function bool ProcessSelection()
{
	if ( Selection == 2 )
	{
		PlayerOwner.ConsoleCommand("TOGGLEFULLSCREEN");
		CurrentRes = PlayerOwner.ConsoleCommand("GetCurrentRes");
		GetAvailableRes();
		return true;
	}
	else if ( Selection == 3 )
	{
		PlayerOwner.ConsoleCommand("SetRes "$MenuValues[3]);
		CurrentRes = PlayerOwner.ConsoleCommand("GetCurrentRes");
		GetAvailableRes();
		return true;
	}
	else if ( Selection == 4 )
	{
		bLowTextureDetail = !bLowTextureDetail;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager LowDetailTextures "$bLowTextureDetail);
		return true;
	}
	else if ( Selection == 7 )
	{
		bLowSoundQuality = !bLowSoundQuality;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality "$bLowSoundQuality);
		return true;
	}
	else if ( Selection == 8 )
	{
		PlayerOwner.bNoVoices = !PlayerOwner.bNoVoices;
		return true;
	}
		
	return false;
}


function DrawMenu(canvas Canvas)
{
	local int StartX, StartY, Spacing, i, HelpPanelX;

	DrawBackGround(Canvas, (Canvas.ClipY < 250));
	HelpPanelX = 228;

	Spacing = Clamp(0.04 * Canvas.ClipY, 16, 32);
	StartX = Max(40, 0.5 * Canvas.ClipX - 120);

	DrawTitle(Canvas);
	StartY = Max(36, 0.5 * (Canvas.ClipY - MenuLength * Spacing - 128));

	// draw text
	DrawList(Canvas, false, Spacing, StartX, StartY);  

	// draw icons
	Brightness = float(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.ViewportManager Brightness"));
	DrawSlider(Canvas, StartX + 155, StartY + 1, (10 * Brightness - 2), 0, 1);

	DrawSlider(Canvas, StartX + 155, StartY + 4*Spacing + 1, MusicVol, 0, 32);
	DrawSlider(Canvas, StartX + 155, StartY + 5*Spacing + 1, SoundVol, 0, 32);

	SetFontBrightness( Canvas, (Selection == 3) );
	Canvas.SetPos(StartX + 152, StartY + Spacing * 2);
	if ( MenuValues[3] ~= CurrentRes )
		Canvas.DrawText("["$MenuValues[3]$"]", false);
	else
		Canvas.DrawText(" "$MenuValues[3], false);
	Canvas.DrawColor = Canvas.Default.DrawColor;

	SetFontBrightness( Canvas, (Selection == 4) );
	Canvas.SetPos(StartX + 152, StartY + Spacing * 3);
	if ( bLowTextureDetail )
		Canvas.DrawText(LowText, false);
	else
		Canvas.DrawText(HighText, false);
	Canvas.DrawColor = Canvas.Default.DrawColor;

	SetFontBrightness( Canvas, (Selection == 7) );
	Canvas.SetPos(StartX + 152, StartY + Spacing * 6);
	if ( bLowSoundQuality )
		Canvas.DrawText(LowText, false);
	else
		Canvas.DrawText(HighText, false);
	Canvas.DrawColor = Canvas.Default.DrawColor;

	SetFontBrightness( Canvas, (Selection == 8) );
	Canvas.SetPos(StartX + 152, StartY + Spacing * 7);
	Canvas.DrawText(!PlayerOwner.bNoVoices, false);
		
	// Draw help panel
	DrawHelpPanel(Canvas, StartY + MenuLength * Spacing, HelpPanelX);
}

*/

function GetInformation()
{
	if ( CurrentRes == "" )
		GetAvailableRes();
	else if ( AvailableRes == "" )
		GetAvailableRes();
		
	bLowTextureDetail = bool(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.ViewportManager LowDetailTextures"));
}

function GetAvailableRes()
{
	local int p,i;
	local string ParseString;

	AvailableRes = PlayerOwner.ConsoleCommand("GetRes");
	resNum = 0;
	ParseString = AvailableRes;
	p = InStr(ParseString, " ");
	while ( (ResNum < ArrayCount(Resolutions)) && (p != -1) ) 
	{
		Resolutions[ResNum] = Left(ParseString, p);
		ParseString = Right(ParseString, Len(ParseString) - p - 1);
		p = InStr(ParseString, " ");
		ResNum++;
	}

	Resolutions[ResNum] = ParseString;
	for ( i=ResNum+1; i< ArrayCount(Resolutions); i++ )
		Resolutions[i] = "";

	CurrentRes = PlayerOwner.ConsoleCommand("GetCurrentRes");
	MenuValues[1] = CurrentRes;
	for ( i=0; i< ResNum+1; i++ )
		if ( MenuValues[1] ~= Resolutions[i] )
		{
			ResNum = i;
			return;
		}

	ResNum = 0;
	MenuValues[1] = Resolutions[0];
}

function bool ProcessLeft()
{
	if ( Selection == 1 )
	{
		Brightness = FMax(0.0, Brightness - 0.1);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$Brightness);
		PlayerOwner.ConsoleCommand("FLUSH");
		return true;
	}
	else if ( Selection == 2 )
	{
		ResNum--;
		if ( ResNum < 0 )
		{
			ResNum = ArrayCount(Resolutions) - 1;
			While ( Resolutions[ResNum] == "" )
				ResNum--;
		}
		MenuValues[1] = Resolutions[ResNum];
		return true;
	}	
	else if ( Selection == 3 )
	{
		bLowTextureDetail = !bLowTextureDetail;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager LowDetailTextures "$bLowTextureDetail);
		return true;
	}
/*	else if ( Selection == 8 )
	{
		if (JazzPlayer(PlayerOwner).KevinCameraAvailable)
		JazzPlayer(PlayerOwner).UseKevinCamera = !JazzPlayer(PlayerOwner).UseKevinCamera;
		return true;
	}*/

	return false;
}

function bool ProcessRight()
{
	if ( Selection == 1 )
	{
		Brightness = FMin(1, Brightness + 0.1);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$Brightness);
		PlayerOwner.ConsoleCommand("FLUSH");
		return true;
	}
	else if ( Selection == 2 )
	{
		ResNum++;
		if ( (ResNum >= ArrayCount(Resolutions)) || (Resolutions[ResNum] == "") )
			ResNum = 0;
		MenuValues[1] = Resolutions[ResNum];
		return true;
	}	
	else if ( Selection == 3 )
	{
		bLowTextureDetail = !bLowTextureDetail;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager LowDetailTextures "$bLowTextureDetail);
		return true;
	}
/*	else if ( Selection == 8 )
	{
		if (JazzPlayer(PlayerOwner).KevinCameraAvailable)
		JazzPlayer(PlayerOwner).UseKevinCamera = !JazzPlayer(PlayerOwner).UseKevinCamera;
		return true;
	}*/

	return false;
}		

function bool ProcessSelection()
{
	if ( Selection == 4 )
	{
		PlayerOwner.ConsoleCommand("TOGGLEFULLSCREEN");
		CurrentRes = PlayerOwner.ConsoleCommand("GetCurrentRes");
		GetAvailableRes();
		return true;
	}
	else if ( Selection == 2 )
	{
		PlayerOwner.ConsoleCommand("SetRes "$MenuValues[1]);
		CurrentRes = PlayerOwner.ConsoleCommand("GetCurrentRes");
		GetAvailableRes();
		return true;
	}
	else if ( Selection == 3 )
	{
		bLowTextureDetail = !bLowTextureDetail;
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager LowDetailTextures "$bLowTextureDetail);
		return true;
	}
	else if ( Selection == 5 )
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
		case 0: // Brightness
			DancingText(Canvas, Digits(Brightness*100,1)$"%", i);
			break;
			
		case 1: // Resolution
			if ( MenuValues[1] ~= CurrentRes )
				DancingText(Canvas,"["$Caps(MenuValues[1])$"]");
			else
				DancingText(Canvas," "$Caps(MenuValues[1]));
			break;

		case 2: // Texture Detail
			if (bLowTextureDetail)			
			DancingText(Canvas, TxtLow, i);
			else
			DancingText(Canvas, TxtHigh, i);
			break;
			
/*		case 4: // Music Volume
			DancingText(Canvas, Digits(MusicVol*100/255,1)$"%", i);
			break;
			
		case 5: // Sound Volume
			DancingText(Canvas, Digits(SoundVol*100/255,1)$"%", i);
			break;
			
		case 6: // Sound Quality
			if (bLowSoundQuality)
			DancingText(Canvas, TxtLow, i);
			else
			DancingText(Canvas, TxtHigh, i);
			break;*/
			
/*		case 7: // Camera Style
			if (JazzPlayer(PlayerOwner).UseKevinCamera)
			DancingText(Canvas, TxtRoaming, i);
			else
			DancingText(Canvas, TxtFixed, i);
			break;*/
		}
	}
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
}

defaultproperties
{
     MenuLength=5
     MenuList(0)="BRIGHTNESS"
     MenuList(1)="TOGGLE FULLSCREEN MODE"
     MenuList(2)="RESOLUTION"
     MenuList(3)="TEXTURE DETAIL"
     MenuList(4)="MUSIC VOLUME"
     MenuList(5)="SOUND VOLUME"
     MenuList(6)="SOUND QUALITY"
     MenuList(7)="CAMERA"
     MenuTitle="AUDIO/VIDEO"
}
