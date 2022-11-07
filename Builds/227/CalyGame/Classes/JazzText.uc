//=============================================================================
// JazzText.
//=============================================================================
class JazzText expands Info;

// The location on the screen for the display box
var () float BoxX;
var () float BoxY;

// The size of the display box
var () float DisplaySizeX;
var () float DisplaySizeY;

// The imaginary border in our display area box
var () float BorderX;
var () float BorderY;

// The size of the font
var () float SizeX;
var () float SizeY;
var	   bool  CapsOnly;

struct STRUCT_JazzChar
{
	var string Char;
	var float PosX,PosY,DesX,DesY;
	var bool bAtDes;
};

// Size of the canvas window (updated each DrawText)
var 	float CanvasSizeX;
var		float CanvasSizeY;

// The current amount of time text has been displayed
var float TimeDisplayed;

// The length of time to display the text
var float TimeToDisplay;

// The text to display
var STRUCT_JazzChar DisplayText[252];

// The amount of characters we will display from DisplayText
var int DisplayTextLen;

var int DummyX1, DummyY1, DummyX2, DummyY2;

// If our little text system is busy displaying
var bool bDisplay;

var () font DLFont;
var () font DSFont;

// This will hold the text to be displayed, and hopefully display the text to the screen
// when needed

function DrawText(canvas Canvas)
{
	// Makes the text draw to the screen
	local int CharNum;
	
	//Canvas.Font = Canvas.SmallFont;
	
	if (Canvas.SizeX>600)
	{
		Canvas.Font = DLFont;
		SizeX = 21;
		SizeY = 30;
		CapsOnly = true;
	}
	else
	{
		Canvas.Font = DSFont;
		SizeX = 12;
		SizeY = 14;
		CapsOnly = true;
	}
	
	// Canvas Size changed?
	if ((CanvasSizeX != Canvas.SizeX) || (CanvasSizeY != Canvas.SizeY))
	{
		ReCalculateTextPosition(Canvas.SizeX,Canvas.SizeY);
	}
	
	for(CharNum = 0; CharNum <= DisplayTextLen; CharNum++)
	{
		Canvas.SetPos(
			DisplayText[CharNum].PosX ,	DisplayText[CharNum].PosY );
			
		if (CapsOnly)
		Canvas.DrawText(Caps(DisplayText[CharNum].Char));
		else
		Canvas.DrawText(DisplayText[CharNum].Char);
	}
}


function AddText(string NewLine, float Time, optional bool bImportant)
{
	// Sets the new text to be displayed
	// with the displaytime of the text
	local int CharNum;
	
	if(bImportant)
	{
		ForceRemove(true);
	}
	
	// Break up the string into our new data format
	for(CharNum = 0; CharNum <= Len(NewLine); CharNum++)
	{
		DisplayText[CharNum].Char = Mid(NewLine,CharNum,1);
		DisplayText[CharNum].bAtDes = false;
	}
	
	// Set the maximum number of characters equal to Len(NewLine)	
	DisplayTextLen = Len(NewLine);
	
	CalculateTextPosition();
	
	TimeToDisplay = Time;
	
	if (TimeToDisplay==0)
	TimeToDisplay = 1+Len(NewLine)/10;
	
	GotoState('BringUp');
}

function ReCalculateTextPosition ( int NewSizeX, int NewSizeY )
{
	local int CharNum,LineNum,LineLen,CurChar;
	local int CharOffset;
	local float LineLength;

/*	local int c;
	for (c=0; c<DisplayTextLen; c++)
	{
		DisplayText[c].DesX = DisplayText[c].DesX / CanvasSizeX * NewSizeX;
		if ((c>0) && (DisplayText[c].DesX < (DisplayText[c-1].DesX)))
		{
			DisplayText[c].DesX = DisplayText[c-1].DesX + SizeX;
		}
		DisplayText[c].DesY = DisplayText[c].DesY / CanvasSizeY * NewSizeY;
		
		/*(BoxX + BorderX + (SizeX * LineLen))								/640*CanvasSizeX;
		DisplayText[CharNum].DesY = (BoxY + BorderY + (SizeY * LineNum))		/480*CanvasSizeY;
		DisplayText[CharNum].PosX = (DisplayText[CharNum].DesX)			/640*CanvasSizeX;
		DisplayText[CharNum].PosY = (DisplayText[CharNum].DesY+(FRand()*200))	/480*CanvasSizeY;*/
	}*/
	
	//
	// Recalculate Box positions
	BoxX = Default.BoxX / 640 * NewSizeX;
	BoxY = Default.BoxY / 480 * NewSizeY;
	BorderX = Default.BorderX / 640 * NewSizeX;
	BorderY = Default.BorderY / 480 * NewSizeY;
	DisplaySizeX = Default.DisplaySizeX / 640 * NewSizeX;
	DisplaySizeY = Default.DisplaySizeY / 480 * NewSizeY;

	CharOffset = 0;
	
	LineLength = DisplayTextLen * SizeX;
	
	if(LineLength + 2*BorderX > DisplaySizeX)
	{
		LineNum = 0;
		CharNum = 0;
		while(CharNum <= DisplayTextLen)
		{
			LineLength = (DisplayTextLen-CharOffset)*SizeX;
			LineLen = (LineLength + 2*BorderX) - DisplaySizeX;
			
			if(LineLen > 0)
			{
				LineLength = (DisplaySizeX - 2*BorderX)/SizeX;
			
				if(DisplayText[CharOffset+LineLength+1].Char != " ")
				{
					for(CurChar = LineLength+CharOffset; DisplayText[CurChar].Char != " "; CurChar--);
				}
				else
				{
					CurChar = LineLength+CharOffset;
				}
			}
			else
			{
				LineLength = DisplayTextLen-CharOffset;
				CurChar = LineLength+CharOffset;
			}				
			
			LineLen = 0;
			for(CharNum = CharOffset; CharNum <= CurChar; CharNum++)
			{
				DisplayText[CharNum].DesX = (BoxX + BorderX + (SizeX * LineLen));
				DisplayText[CharNum].DesY = (BoxY + BorderY + (SizeY * LineNum));
//				DisplayText[CharNum].PosX = (DisplayText[CharNum].DesX);
//				DisplayText[CharNum].PosY = (DisplayText[CharNum].DesY+(FRand()*200));
				LineLen++;
			}
			
			CharOffset = CharNum;
			LineNum++;
		}
	}
	else
	{
		for(CharNum = 0; CharNum <= DisplayTextLen; CharNum++)
		{
			DisplayText[CharNum].DesX = (BoxX + BorderX + ((CharNum-1)*SizeX));
			DisplayText[CharNum].DesY = (BoxY + BorderY);
//			DisplayText[CharNum].PosX = (DisplayText[CharNum].DesX);
//			DisplayText[CharNum].PosY = (DisplayText[CharNum].DesY+(FRand()*200));
		}
	}	
	//
	
	for(CharNum = 0; CharNum <= DisplayTextLen; CharNum++)
	{
		if (DisplayText[CharNum].bAtDes)
		{
		DisplayText[CharNum].PosX = DisplayText[CharNum].DesX;
		DisplayText[CharNum].PosY = DisplayText[CharNum].DesY;
		}
		else
		{
		DisplayText[CharNum].PosX = DisplayText[CharNum].PosX / CanvasSizeX * NewSizeX;
		DisplayText[CharNum].PosY = DisplayText[CharNum].PosY / CanvasSizeY * NewSizeY;
		}
	}
			
	CanvasSizeX = NewSizeX;
	CanvasSizeY = NewSizeY;
}

function CalculateTextPosition ()
{
	local int CharNum,LineNum,LineLen,CurChar;
	local int CharOffset;
	local float LineLength;

	// Recalculate Box positions
	BoxX = 			Default.BoxX / 640 * CanvasSizeX;
	BoxY = 			Default.BoxY / 480 * CanvasSizeY;
	BorderX = 		Default.BorderX / 640 * CanvasSizeX;
	BorderY = 		Default.BorderY / 640 * CanvasSizeY;
	DisplaySizeX = 	Default.DisplaySizeX / 640 * CanvasSizeX;
	DisplaySizeY = 	Default.DisplaySizeY / 480 * CanvasSizeY;

	CharOffset = 0;
	
	LineLength = DisplayTextLen * SizeX;
	
	if(LineLength + 2*BorderX > DisplaySizeX)
	{
		LineNum = 0;
		CharNum = 0;
		while(CharNum <= DisplayTextLen)
		{
			LineLength = (DisplayTextLen-CharOffset)*SizeX;
			LineLen = (LineLength + 2*BorderX) - DisplaySizeX;
			
			if(LineLen > 0)
			{
				LineLength = (DisplaySizeX - 2*BorderX)/SizeX;
			
				if(DisplayText[CharOffset+LineLength+1].Char != " ")
				{
					for(CurChar = LineLength+CharOffset; DisplayText[CurChar].Char != " "; CurChar--);
				}
				else
				{
					CurChar = LineLength+CharOffset;
				}
			}
			else
			{
				LineLength = DisplayTextLen-CharOffset;
				CurChar = LineLength+CharOffset;
			}				
			
			LineLen = 0;
			for(CharNum = CharOffset; CharNum <= CurChar; CharNum++)
			{
				DisplayText[CharNum].DesX = (BoxX + BorderX + (SizeX * LineLen));
				DisplayText[CharNum].DesY = (BoxY + BorderY + (SizeY * LineNum));
				DisplayText[CharNum].PosX = (DisplayText[CharNum].DesX);
				DisplayText[CharNum].PosY = (DisplayText[CharNum].DesY+(FRand()*200));
				LineLen++;
			}
			
			CharOffset = CharNum;
			LineNum++;
		}
	}
	else
	{
		for(CharNum = 0; CharNum <= DisplayTextLen; CharNum++)
		{
			DisplayText[CharNum].DesX = (BoxX + BorderX + ((CharNum-1)*SizeX));
			DisplayText[CharNum].DesY = (BoxY + BorderY);
			DisplayText[CharNum].PosX = (DisplayText[CharNum].DesX);
			DisplayText[CharNum].PosY = (DisplayText[CharNum].DesY+(FRand()*200));
		}
	}
}

function ForceRemove(optional bool bImportant)
{
	// Forces the text to disappear from the screen
	local int CharNum;
	
	if(!bImportant && IsInState('BringUp'))
	{
		return;
	}

	for(CharNum = 0; CharNum <= DisplayTextLen; CharNum++)
	{
		DisplayText[CharNum].bAtDes = false;
		DisplayText[CharNum].DesX = DisplayText[CharNum].PosX+((Frand()*100)-50);
		DisplayText[CharNum].DesY = 480+(FRand()*200);
	}
	
	GotoState('BringDown');
}

auto state Idle
{
	function DrawText(Canvas canvas);
	function BeginState()
	{
		bDisplay = false;
	}
}

state BringUp
{
	event Tick(float DeltaTime)
	{
		local int CharNum;
		local bool AllDone;	

		AllDone = true;
	
		for(CharNum = 0; CharNum <= DisplayTextLen; CharNum++)
		{
			if(!DisplayText[CharNum].bAtDes)
			{
				DisplayText[CharNum].PosX += (DisplayText[CharNum].DesX - DisplayText[CharNum].PosX)*DeltaTime*2;
				DisplayText[CharNum].PosY += (DisplayText[CharNum].DesY - DisplayText[CharNum].PosY)*DeltaTime*2;
	
				if((DisplayText[CharNum].PosX <= DisplayText[CharNum].DesX+0.125 && DisplayText[CharNum].PosX >= DisplayText[CharNum].DesX-0.125)
				   &&
				  (DisplayText[CharNum].PosY <= DisplayText[CharNum].DesY+0.125 && DisplayText[CharNum].PosY >= DisplayText[CharNum].DesY-0.125))
				{
					DisplayText[CharNum].bAtDes = true;
				}
				else
				AllDone = false;
			}
		}
		
		if(AllDone)
		{
			GotoState('Display');
		}
	}
	
	function BeginState()
	{
		bDisplay = true;
	}
}

state BringDown
{
	event Tick(float DeltaTime)
	{
		local int CharNum;
		local bool AllDone;	
			
		AllDone = true;

		for(CharNum = 0; CharNum <= DisplayTextLen; CharNum++)
		{
			if(!DisplayText[CharNum].bAtDes)
			{
				AllDone = false;
				DisplayText[CharNum].PosX += (DisplayText[CharNum].DesX - DisplayText[CharNum].PosX)*DeltaTime*2;
				DisplayText[CharNum].PosY += (DisplayText[CharNum].DesY - DisplayText[CharNum].PosY)*DeltaTime*2;
				
				if((DisplayText[CharNum].PosX <= DisplayText[CharNum].DesX+0.25 && DisplayText[CharNum].PosX >= DisplayText[CharNum].DesX-0.25)
				  &&
				  (DisplayText[CharNum].PosY <= DisplayText[CharNum].DesY+0.25 && DisplayText[CharNum].PosY >= DisplayText[CharNum].DesY-0.25))
				{
					DisplayText[CharNum].bAtDes = true;
				}
			}
		}
	
		if(AllDone)
		{
			GotoState('Idle');
		}
	}
	
	function BeginState ()
	{
		bDisplay = false;
	}
}


state Display
{
	event Tick(float DeltaTime)
	{
		TimeDisplayed += DeltaTime;
		
		if(TimeDisplayed >= TimeToDisplay)
		{
			ForceRemove();
		}
	}
	
	function BeginState()
	{
		TimeDisplayed = 0;
	}
}

function PreBeginPlay()
{
	CanvasSizeX = 640;
	CanvasSizeY = 480;
}

defaultproperties
{
     BoxX=100.000000
     BoxY=340.000000
     DisplaySizeX=440.000000
     DisplaySizeY=70.000000
     BorderX=5.000000
     BorderY=5.000000
     SizeX=6.000000
     SizeY=8.000000
     DrawType=DT_None
     DLFont=Texture'JazzFonts.DLFont'
     DSFont=Texture'JazzFonts.DSFont'
}
