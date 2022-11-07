//=============================================================================
// BattleScoreBoard.
//=============================================================================
class BattleScoreBoard expands JazzScoreBoard;

var string PlayerNames[16];
var string TeamNames[16];
var float Scores[16];
var byte Teams[16];
var int Pings[16];

function SortScores(int N)
{
	local int I, J, Max;
	
	for ( I=0; I<N-1; I++ )
	{
		Max = I;
		for ( J=I+1; J<N; J++ )
			if (Scores[J] > Scores[Max])
				Max = J;
		Swap( Max, I );
	}
}

function Swap( int L, int R )
{
	local string TempPlayerName, TempTeamName;
	local float TempScore;
	local byte TempTeam;
	local int TempPing;

	TempPlayerName = PlayerNames[L];
	TempTeamName = TeamNames[L];
	TempScore = Scores[L];
	TempTeam = Teams[L];
	TempPing = Pings[L];
	
	PlayerNames[L] = PlayerNames[R];
	TeamNames[L] = TeamNames[R];
	Scores[L] = Scores[R];
	Teams[L] = Teams[R];
	Pings[L] = Pings[R];
	
	PlayerNames[R] = TempPlayerName;
	TeamNames[R] = TempTeamName;
	Scores[R] = TempScore;
	Teams[R] = TempTeam;
	Pings[R] = TempPing;
}

function ShowScores( canvas Canvas )
{
	local PlayerReplicationInfo PRI;
	local int PlayerCount, LoopCount, I;
	local float BoxX, BoxY;

	// Wipe everything.
	for ( I=0; I<16; I++ )
	{
		Scores[I] = -500;
	}

	foreach AllActors (class'PlayerReplicationInfo', PRI)
	{
		PlayerNames[PlayerCount] = PRI.PlayerName;
		TeamNames[PlayerCount] = PRI.TeamName;
		Scores[PlayerCount] = PRI.Score;
		Teams[PlayerCount] = PRI.Team;
		Pings[PlayerCount] = PRI.Ping;

		PlayerCount++;
	}
	
	SortScores(PlayerCount);
	
	BoxX = 5;
	BoxY = Canvas.SizeY*0.05;
	MiscObjectDisplay(Canvas,BoxX,BoxY,PlayerCount,0.25);
	
	for ( I=0; I<PlayerCount; I++ )
	{
		MiscObjectDispIn(Canvas,BoxX,BoxY,i,None,
			PlayerNames[i]," Ping "$Pings[i],Digits(Scores[i],3));
	}

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

defaultproperties
{
}
