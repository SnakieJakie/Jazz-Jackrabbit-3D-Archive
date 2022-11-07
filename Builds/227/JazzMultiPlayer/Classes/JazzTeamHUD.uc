//=============================================================================
// JazzTeamHUD.
//=============================================================================
class JazzTeamHUD expands JazzBattleHUD;

var string 	RespawnMessage;
var class		SelectTeamMenu;
var() texture	TeamIcon[16];	// Team symbols - Also change Team Score Board
var	texture		MyTeamIcon;

var() texture HudMisc;
var() texture HudMiscT;
Var() font DLFont;
var() font DSFont;

// Get Team Info
//
function JazzTeamInfo GetTeamInfoActor ( int TeamNum )
{
	local JazzTeamInfo TI;
	
	// Extract list of teams
	foreach AllActors(class'JazzTeamInfo', TI)
	{
		if (TI.TeamIndex == TeamNum)
		return(TI);
	}
	
	return(None);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HUD Kinetic																		HUD STYLE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HUD Style : Kinetic Single Player
//
function DrawHudKinetic(canvas Canvas)
{
	// Display object amount bar at right
	MiscObjectDisplayBar(Canvas);
		
	DancingMessage	(Canvas,DancingMessageText,Canvas.SizeX/2,Canvas.SizeY/2);
	DancingMessage	(Canvas,VersionMessageText,Canvas.SizeX/2,Canvas.SizeY*0.6);

	DeanHudTypeA	(Canvas,Canvas.SizeX*0.03,Canvas.SizeY*0.03);

	// Press Fire to spawn	
	if (PlayerPawn(Owner).IsInState('Dying'))
	{
		DisplayBoxMessage(Canvas,"PRESS FIRE TO PLAY");
	}
	
	if (JazzPlayerReplicationInfo(PlayerPawn(Owner).PlayerReplicationInfo).bSpectate)
	{
		DisplayBoxMessage(Canvas,"PRESS FIRE TO SELECT TEAM");
	}
}

function DisplayBoxMessage (canvas Canvas, string Message )
{
	local texture T;
	local float Scale;
	local float TX,TY;

	Canvas.Style = 2;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
	Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*0.42);
	T = HudMisc;
	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*0.8, Canvas.SizeY*0.16, 0, 0, T.USize, T.VSize );
	
	Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*0.42);
	Canvas.Style = 3;
	T = HudMiscT;
	if (T != None)
	Canvas.DrawTile( T, Canvas.SizeX*0.8, Canvas.SizeY*0.16, 0, 0, T.USize, T.VSize );
	
	Canvas.Style = 2;

	if (Canvas.SizeX<640)
	Canvas.Font = DSFont;
	else
	Canvas.Font = DLFont;

	RespawnMessage = Message;
	Canvas.StrLen(RespawnMessage,TX,TY);

	Canvas.SetPos(Canvas.SizeX*0.5 - TX/2,Canvas.SizeY*0.5 - TY/2);
	Canvas.DrawText(RespawnMessage, False);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Master function for the display bar												HUD FUNCTION
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Override the display bar to provide multiplayer personal game stats instead of normal bar information.
//
//
function MiscObjectDisplayBar(canvas Canvas)
{
	local int   Min,Sec,PSec;
	local float Temp;
	local float Team;
	local float TeamSymbol;
	local JazzTeamInfo	TeamInfo;

	if ((Owner == None) || (PlayerPawn(Owner) == None))
		return;

	if (PlayerPawn(Owner).PlayerReplicationInfo==None)
		return;
	
	Team = PlayerPawn(Owner).PlayerReplicationInfo.Team;
	TeamInfo = GetTeamInfoActor(Team);
	if (TeamInfo != None)
	TeamSymbol = TeamInfo.TeamSymbol;

	if ((Team>=0) && (Team<16))
	MyTeamIcon = TeamIcon[TeamSymbol];
		
	if (ProcessComponent(0,Canvas.SizeX+100,0,Canvas.SizeX*0.69,5))	// Component 0 - Carrots / Money
	{
	MiscObjectDisplay	(Canvas,ComponentX,ComponentY,2,0.30);

	// Display Score (Kills)
	MiscObjectDispIn2	(Canvas,ComponentX,ComponentY,0,None,
		"SCORE",
		"",
		Digits(PlayerPawn(Owner).PlayerReplicationInfo.Score,3)
		);

	// Display Team Name
	if (JazzPlayerReplicationInfo(PlayerPawn(Owner).PlayerReplicationInfo).bSpectate)
	MiscObjectDispIn2	(Canvas,ComponentX,ComponentY,1,None,
		"SPECTATOR",
		"",
		""
		);
	else
	MiscObjectDispIn2	(Canvas,ComponentX,ComponentY,1,MyTeamIcon,
		PlayerPawn(Owner).PlayerReplicationInfo.TeamName,
		"",
		"TEAM"
		);
	}
		
	// Force Display
	UpdateComponent(0,10);
}

defaultproperties
{
     TeamIcon(0)=Texture'JazzArt.Interface.Team1'
     TeamIcon(1)=Texture'JazzArt.Interface.Team2'
     MainMenuType=Class'CalyGame.JazzTeamGameMenu'
     DSFont=Texture'JazzFonts.DSFont'
     DLFont=Texture'JazzFonts.DLFont'
     HudMisc=Texture'JazzArt.HudMisc'
     HudMiscT=Texture'JazzArt.HudMiscT'
}
