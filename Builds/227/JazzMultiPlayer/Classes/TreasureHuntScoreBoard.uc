//=============================================================================
// TreasureHuntScoreBoard.
//=============================================================================
class TreasureHuntScoreBoard expands JazzScoreBoard;

var float 		Gems[17];
var float		Time[17];
var int			Key[17];
var string		Names[17];
var byte		NumPlayers;

var () texture JazzKey;


// update scores
function UpdateScores()
{
	local THPlayerReplicationInfo THP;
	local THPlayerReplicationInfo Scoring[16];
	local int i;

	NumPlayers = 0;

	// get a sorted list of the top 16 players
	foreach AllActors(class'THPlayerReplicationInfo', THP)
	{
		if(NumPlayers < 16)
		{
			Scoring[NumPlayers] = THP;
			NumPlayers++;
		}
	}

	for ( i=0; i<16; i++ )
	{
		if ( i < NumPlayers )
		{
			Names[i] = Scoring[i].PlayerName;
			
			Gems[i] = Scoring[i].GemNumber;
			Key[i] = int(Scoring[i].TreasureKey);
			if(Scoring[i].TreasureFinish)
			{
				Time[i] = Scoring[i].TreasureTime;
			}
			else
			{
				Time[i] = Level.TimeSeconds;
			}
		}
		else
		{
			Names[i] = "";
		}
	}
}


// UpdateNext - server returns next update, and a new request offset
function UpdateNext(string CurrentName, int offset, PlayerPawn requester)
{
	UpdateScores();
}


function ShowScores( canvas Canvas )
{
	local int i, num, max, Min, Sec, PSec;
	local float Temp;

	local float BoxX,BoxY;
	local string Line1,Line2;

	UpdateScores();

	max = int(0.03725 * Canvas.ClipY);
	
	// Display it
	SmallFont(Canvas);
	
	BoxX = 5;
	BoxY = Canvas.SizeY*0.05;
	MiscObjectDisplay(Canvas,BoxX,BoxY,NumPlayers,0.25);
	
	for (i=0; i<NumPlayers; i++)
	{
		Line1 = Digits(Gems[i],3)$" "$Names[i];

		Min = Time[i]/60;
		Sec = Time[i] - (Min*60);
		Temp = Time[i] - (Min*60) - Sec;
		PSec = Temp * 100;		
		Line2 = " "$Digits(Min,2)$":"$Digits(Sec,2);

		if (Key[i]==0)
		MiscObjectDispIn(Canvas,BoxX,BoxY,i,None,Line1,Line2);
		else
		MiscObjectDispIn(Canvas,BoxX,BoxY,i,JazzKey,Line1,Line2);
	}

	// Display it
/*	Canvas.Font = Canvas.MedFont;
	num = 1;

	Canvas.SetPos(0.1 * Canvas.ClipX, 0.2 * Canvas.ClipY );
	Canvas.DrawText("Name", False);
	Canvas.SetPos(0.3 * Canvas.ClipX, 0.2 * Canvas.ClipY );
	Canvas.DrawText("Time", false);
	Canvas.SetPos(0.6 * Canvas.ClipX, 0.2 * Canvas.ClipY);
	Canvas.DrawText("Gems", False);
	Canvas.SetPos(0.8 * Canvas.ClipX, 0.2 * Canvas.ClipY);
	Canvas.DrawText("Key", false);
			
	for ( i=0; i<NumPlayers; i++ )
	{
		if ( Names[i] != "" )
		{
			Canvas.SetPos(0.1 * Canvas.ClipX, 0.2 * Canvas.ClipY + 16 * num );
			Canvas.DrawText(Names[i], False);
			Canvas.SetPos(0.3 * Canvas.ClipX, 0.2 * Canvas.ClipY + 16 * num );

			Min = Time[i]/60;
			Sec = Time[i] - (Min*60);

			Temp = Time[i] - (Min*60) - Sec;

			PSec = Temp * 100;
				
			if(Sec < 10 || PSec < 10)
			{
				if(PSec > 10)
				{
					Canvas.DrawText(Min$":0"$Sec$":"$PSec, False);
				}
				else if(Sec > 10)
				{
					Canvas.DrawText(Min$":"$Sec$":0"$PSec, False);	
				}
				else
				{
					Canvas.DrawText(Min$":0"$Sec$":0"$PSec, False);				
				}
			}
			else
			{
				Canvas.DrawText(Min$":"$Sec$":"$PSec, False);				
			}
			
			Canvas.SetPos(0.6 * Canvas.ClipX, 0.2 * Canvas.ClipY + 16 * num );
			Canvas.DrawText(int(Gems[i]), False);
			Canvas.SetPos(0.8 * Canvas.ClipX, 0.2 * Canvas.ClipY + 16 * num );
			if(Key[i] == 0)
			{
				Canvas.DrawText("Searching...", False);				
			}
			else
			{
				Canvas.DrawText("Found!",False);
			}
			num++;
			if ( num >= max )
				break;
		}
	}	*/
}

defaultproperties
{
    JazzKey=Texture'JazzArt.JazzKey'
}
