//=============================================================================
// JazzTeamScoreBoard.
//=============================================================================
class JazzTeamScoreBoard expands JazzScoreBoard;

var string PlayerNames[32];
var string TeamNames[32];
var float Scores[32];
var byte Teams[32];
var int Pings[32];
var JazzTeamInfo TeamInfoActor[32];
var int TeamNum;
var() texture TeamIcon[16];	// See Team HUD for the icon list.

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

function DrawName( canvas Canvas, int I, float XOffset, int LoopCount )
{
/*	Canvas.SetPos(Canvas.ClipX/4, Canvas.ClipY/4 + (LoopCount * 16));
	Canvas.DrawText(PlayerNames[I], false);*/
}

function DrawPing( canvas Canvas, int I, float XOffset, int LoopCount )
{
/*	local float XL, YL;

	if (Level.Netmode == NM_Standalone)
		return;

	Canvas.StrLen(Pings[I], XL, YL);
	Canvas.SetPos(Canvas.ClipX/4 - XL - 8, Canvas.ClipY/4 + (LoopCount * 16));
	Canvas.Font = Font'TinyWhiteFont';
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.DrawText(Pings[I], false);
	Canvas.Font = Font'WhiteFont';
	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 0;*/
}

function DrawScore( canvas Canvas, int I, float XOffset, int LoopCount )
{
/*	Canvas.SetPos(Canvas.ClipX/4 * 3, Canvas.ClipY/4 + (LoopCount * 16));

	if(Scores[I] >= 100.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] >= 10.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] < 0.0)
		Canvas.CurX -= 6.0;
	Canvas.DrawText(int(Scores[I]), false);*/
}

function ShowScores( canvas Canvas )
{
	local JazzPlayerReplicationInfo PRI;
	local int PlayerCount, LoopCountTeam0, LoopCountTeam1, I, XOffset;
	local float Team0Total, Team1Total, XL, YL;
	local JazzTeamInfo TI;
	local texture TeamIconTex;

	local float BoxX,BoxY;
	local string Line1,Line2;

	for ( I=0; I<32; I++ )
		Scores[I] = -500;

	PlayerCount = 0;
	foreach AllActors (class'JazzPlayerReplicationInfo', PRI)
	{
		if(!PRI.bSpectate)
		{
			if (PlayerCount<32)
			{
				PlayerNames[PlayerCount] = PRI.PlayerName;
				TeamNames[PlayerCount] = PRI.TeamName;
				Scores[PlayerCount] = PRI.Score;
				Teams[PlayerCount] = PRI.Team;
				Pings[PlayerCount] = PRI.Ping;
			}

			PlayerCount++;
		}
	}
	
	SortScores(PlayerCount);

	// Extract list of teams
	TeamNum=-1;
	foreach AllActors(class'JazzTeamInfo', TI)
	{
		if ((TI.TeamIndex>-1) && (TI.TeamIndex<32))
		{
			TeamInfoActor[TI.TeamIndex]=TI;
			
			//Log("TeamNum) "$TI.TeamIndex$" "$TeamNum);
			if (TeamNum<TI.TeamIndex) TeamNum=TI.TeamIndex+2;
		}
	}
	
	// Display Player Scores
	BoxX = 5;
	BoxY = Canvas.SizeY*0.05;
	MiscObjectDisplay(Canvas,BoxX,BoxY,PlayerCount,0.25);
	
	for ( I=0; I<PlayerCount; I++ )
	{
		TeamIconTex = TeamIcon[TeamInfoActor[Teams[I]].TeamSymbol];
		MiscObjectDispIn(Canvas,BoxX,BoxY,i,TeamIconTex,
			PlayerNames[i],
			Digits(Scores[i],3),
			"");
	}

	// Display team information
	BoxX = Canvas.SizeX*(1-0.26);
	BoxY = Canvas.SizeY*0.05;
	MiscObjectDisplay(Canvas,BoxX,BoxY,TeamNum,0.25);
	
	for ( I=0; I<TeamNum; I++ )
	{
		if (TeamInfoActor[i] != None)
		{
			MiscObjectDispIn(Canvas,BoxX,BoxY,i,TeamIcon[TeamInfoActor[I].TeamSymbol],
				TeamInfoActor[i].TeamName,
				Digits(TeamInfoActor[i].Score,3),
				//TeamInfoActor[i].Size$" Members",
				""
				);
		}
	}
	
/*		switch (TI.TeamIndex)
		{
			case 0:
				Canvas.DrawColor.R = 255;
				Canvas.DrawColor.G = 0;
				Canvas.DrawColor.B = 0;
				Canvas.SetPos(Canvas.ClipX/8, Canvas.ClipY/4 - 16);
				Canvas.StrLen("Red Team: ", XL, YL);
				Canvas.DrawText("Red Team: ", false);
				Canvas.SetPos(Canvas.ClipX/8 + 96, Canvas.ClipY/4 - 16);
				Canvas.DrawText(int(TI.Score), false);
				break;
			case 1:
				Canvas.DrawColor.R = 0;
				Canvas.DrawColor.G = 128;
				Canvas.DrawColor.B = 255;
				Canvas.SetPos(Canvas.ClipX/2 + Canvas.ClipX/8,  Canvas.ClipY/4 - 16);
				Canvas.StrLen("Blue Team: ", XL, YL);
				Canvas.DrawText("Blue Team: ", false);
				Canvas.SetPos(Canvas.ClipX/2 + Canvas.ClipX/8 + 96, Canvas.ClipY/4 - 16);
				Canvas.DrawText(int(TI.Score), false);
				break;
		}*/
	
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
/*	for ( I=0; I<PlayerCount; I++ )
	{
		if (Teams[I] == 0) {
			XOffset = Canvas.ClipX/8;

			// Player name
			Canvas.DrawColor.R = 200;
			Canvas.DrawColor.G = 0;
			Canvas.DrawColor.B = 0;
			DrawName( Canvas, I, XOffset, LoopCountTeam0 );

			// Player ping
			DrawPing( Canvas, I, XOffset, LoopCountTeam0 );

			// Player score
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 0;
			Canvas.DrawColor.B = 0;
			DrawScore( Canvas, I, XOffset, LoopCountTeam0 );

			Team0Total += Scores[I];
			LoopCountTeam0++;
		} else {
			XOffset = Canvas.ClipX/2 + Canvas.ClipX/8;

			// Player name
			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = 0;
			Canvas.DrawColor.B = 255;
			DrawName( Canvas, I, XOffset, LoopCountTeam1 );

			// Player ping
			DrawPing( Canvas, I, XOffset, LoopCountTeam1 );

			// Player score
			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = 0;
			Canvas.DrawColor.B = 200;
			DrawScore( Canvas, I, XOffset, LoopCountTeam1 );

			Team1Total += Scores[I];
			LoopCountTeam1++;
		}
	}
	foreach AllActors(class'JazzTeamInfo', TI)
	{
		switch (TI.TeamIndex)
		{
			case 0:
				Canvas.DrawColor = SelectColor(TI.TeamColor);
				Canvas.SetPos(Canvas.ClipX/8, Canvas.ClipY/4 - 16);
				Canvas.StrLen(TI.TeamName, XL, YL);
				Canvas.DrawText(TI.TeamName, false);
				Canvas.SetPos(Canvas.ClipX/8 + 96, Canvas.ClipY/4 - 16);
				Canvas.DrawText(int(TI.Score), false);
				break;
			case 1:
				Canvas.DrawColor = SelectColor(TI.TeamColor);
				Canvas.SetPos(Canvas.ClipX/2 + Canvas.ClipX/8,  Canvas.ClipY/4 - 16);
				Canvas.StrLen(TI.TeamName, XL, YL);
				Canvas.DrawText(TI.TeamName, false);
				Canvas.SetPos(Canvas.ClipX/2 + Canvas.ClipX/8 + 96, Canvas.ClipY/4 - 16);
				Canvas.DrawText(int(TI.Score), false);
				break;
		}
	}

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;*/
}

function color SelectColor(int ColorType)
{
/*	local color C;
	
	switch(ColorType)
	{
		case 0:
			C.R = 255;
			C.G = 0;
			C.B = 0;
			break;
		case 1:
			C.R = 0;
			C.G = 0;
			C.B = 255;
			break;
		case 2:
			C.R = 0;
			C.G = 255;
			C.B = 0;
			break;
	}
	
	return C;*/
}

defaultproperties
{
     TeamIcon(0)=Texture'JazzArt.Interface.Team1'
     TeamIcon(1)=Texture'JazzArt.Interface.Team2'
}
