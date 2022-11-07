//=============================================================================
// TreasureHuntScoreBoard.
//=============================================================================
class TreasureHuntScoreBoard expands ScoreBoard;

var float 		Gems[17];
var float		Time[17];
var int			Key[17];
var string[20]  Names[17];
var float		LastRequestTime;
var byte		RequestOffset;
var byte		NumPlayers;
var bool		bRefreshed;

// server update scores
function UpdateScores()
{
	local Pawn aPawn;
	local JazzPlayer Scoring[16];
	local int i;

	aPawn = Level.PawnList;
	NumPlayers = 0;

	// get a sorted list of the top 16 players
	while ( aPawn != None )
	{
		if ( aPawn.bIsPlayer )
		{
			if(NumPlayers < 16)
			{
				Scoring[NumPlayers] = JazzPlayer(aPawn);
				NumPlayers++;
			}
		}		
		aPawn = aPawn.nextPawn;
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
				Time[i] = TreasureHunt(Level.Game).GameTime;
			}
		}
		else
		{
			Names[i] = "";
		}
	}
}


// UpdateNext - server returns next update, and a new request offset
function UpdateNext(string[20] CurrentName, int offset, PlayerPawn requester)
{
	UpdateScores();
}

// RefreshScores() - refresh based on new score received from server
function RefreshScores(string[20] NewName, float NewScore, byte newOffset, byte NewNum)
{
	/*
	NumPlayers = NewNum;
	Names[NewOffset] = NewName;
	Gems[NewOffset] = NewScore;
	*/
	UpdateScores();
}

function QuickRefreshScores(float NewScore, byte newOffset, byte NewNum)
{
	/*
	NumPlayers = NewNum;
	Gems[NewOffset] = NewScore;
	*/
	// UpdateScores();
}

function ShowScores( canvas Canvas )
{
	local int i, num, max, Min, Sec, PSec;
	local float Temp;

	if ( Level.TimeSeconds - LastRequestTime > 0.07 )
	{
		/*
		RequestOffset = RequestOffset + 1;
		if ( RequestOffset >= NumPlayers )
		{
			bRefreshed = true;
			RequestOffset = 0;
		}
		*/
		
		UpdateScores();
		
		//PlayerPawn(Owner).ServerRequestScores(Names[RequestOffset], RequestOffset);
		
		bRefreshed = true;
		
		LastRequestTime = Level.TimeSeconds;
	}

	max = int(0.03725 * Canvas.ClipY);
	
	// Display it
	Canvas.Font = Canvas.MedFont;
	num = 1;

	if ( bRefreshed )
	{
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
		}	
	}
}

defaultproperties
{
     Key(0)=269787768
     Key(9)=26272080
     Key(10)=134217730
     Key(11)=66560
     Names(0)="x¢"
     Names(2)=""
     Names(14)="@3~"
     RequestOffset=120
     NumPlayers=120
}
