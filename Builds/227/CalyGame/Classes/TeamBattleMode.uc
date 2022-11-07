//=============================================================================
// TeamBattleMode.
//=============================================================================
class TeamBattleMode expands BattleMode;

var() config bool   bSpawnInTeamArea;
var() config bool	bNoTeamChanges;
var() config float  FriendlyFireScale; //scale friendly fire damage by this value
var() config int	MaxTeams; //Maximum number of teams allowed in (up to 16)
var	JazzTeamInfo Teams[16]; 
var() config float  GoalTeamScore; //like flufflimit
var() config int	MaxTeamSize;
var() config bool	bAllowNewTeams;
var  localized string NewTeamMessage;
var     int			NumberOfTeams;
var		int			NextBotTeam;
// var byte TEAM_Red, TEAM_Blue, TEAM_Green, TEAM_Gold;
// var localized string TeamColor[4];


function PostBeginPlay()
{
	/*
	// Setup and initalize the first four teams (?)
	local int i;
	for (i=0;i<4;i++)
	{
		Teams[i] = Spawn(class'JazzTeamInfo');
		Teams[i].Size = 0;
		Teams[i].Score = 0;
		Teams[i].TeamName = TeamColor[i];
		Teams[i].TeamIndex = i;
	}
	*/
	
	// Setup and initalize the first two teams and give them default names
	
	local int i;
	for (i=0;i<2;i++)
	{
		Teams[i] = Spawn(class'JazzTeamInfo');
		Teams[i].Size = 0;
		Teams[i].Score = 0;
		Teams[i].TeamIndex = i;
	}	

	Teams[0].TeamName = "Team A";
	Teams[0].TeamColor = 0;
	Teams[0].TeamSymbol = 0;
	Teams[1].TeamName = "Team B";
	Teams[1].TeamColor = 1;
	Teams[1].TeamSymbol = 1;
	
	NumberOfTeams = 2;

	
	Super.PostBeginPlay();
}

//------------------------------------------------------------------------------
// Player start functions


//FindPlayerStart
//- add teamnames as new teams enter
//- choose team spawn point if bSpawnInTeamArea


function playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local PlayerPawn newPlayer;

	newPlayer = Super.Login(Portal, Options, Error, SpawnClass);
	if ( newPlayer == None)
		return None;
		
	JazzPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).bSpectate = True;
//	jazzPlayer(NewPlayer).BecomeSpectator();

	// Parse the team name option from the player
	/*
	InTeam     = GetIntOption( Options, "Team", 0 );
	if ( !ChangeTeam(newPlayer, InTeam) )
	{
		Error = "Could not find team for player";
		return None;
	}
	*/
	
	
	// I don't like this, go away, it bad
	/*
	// Spawn in team location if it is wanted
	if ( bSpawnInTeamArea && (NewPlayer.PlayerReplicationInfo.Team != 0) )
	{
		StartSpot = FindPlayerStart(newPlayer.PlayerReplicationInfo.Team, Portal);
		if ( StartSpot != None )
		{
			NewPlayer.SetLocation(StartSpot.Location);
			NewPlayer.SetRotation(StartSpot.Rotation);
			NewPlayer.ViewRotation = StartSpot.Rotation;
			NewPlayer.ClientSetRotation(NewPlayer.Rotation);
			StartSpot.PlayTeleportEffect( NewPlayer, true );
		}
	}
	*/
				
	return newPlayer;
}


function Logout(pawn Exiting)
{
	Super.Logout(Exiting);
	if ( Exiting.IsA('Spectator') )
		return;
	Teams[Exiting.PlayerReplicationInfo.Team].Size--;
}
	
function NavigationPoint FindPlayerStart(byte Team, optional string incomingName)
{
	local PlayerStart Dest, Candidate[4], Best;
	local float Score[4], BestScore, NextDist;
	local pawn OtherPlayer;
	local int i, num;
	local Teleporter Tel;
	local NavigationPoint N;

	if( incomingName!="" )
		foreach AllActors( class 'Teleporter', Tel )
			if( string(Tel.Tag)~=incomingName )
				return Tel;
			
	num = 0;
	//choose candidates	
	for ( N=Level.NavigationPointList; N!=None; N=N.nextNavigationPoint )
		if ( N.IsA('PlayerStart') 
			&& (!bSpawnInTeamArea || (Team == PlayerStart(N).TeamNumber)) )
		{
			if (num<4)
				Candidate[num] = PlayerStart(N);
			else if (Rand(num) < 4)
				Candidate[Rand(4)] = PlayerStart(N);
			num++;
		}

	if (num == 0 )
		foreach AllActors( class'PlayerStart', Dest )
		{
			if (num<4)
				Candidate[num] = Dest;
			else if (Rand(num) < 4)
				Candidate[Rand(4)] = Dest;
			num++;
		}
	
	if (num>4) num = 4;
	else if (num == 0)
		return None;
		
	//assess candidates
	for (i=0;i<num;i++)
		Score[i] = 4000 * FRand(); //randomize
		
	for ( OtherPlayer=Level.PawnList; OtherPlayer!=None; OtherPlayer=OtherPlayer.NextPawn)	
		if ( OtherPlayer.bIsPlayer && (OtherPlayer.Health > 0) )
			for (i=0;i<num;i++)
			{
				NextDist = VSize(OtherPlayer.Location - Candidate[i].Location);
				Score[i] += NextDist;
				if ( OtherPlayer.Region.Zone == Candidate[i].Region.Zone )
				{
					if (NextDist < CollisionRadius + CollisionHeight)
						Score[i] -= 1000000.0;
					else if ( (NextDist < 1400) && (Team != OtherPlayer.PlayerReplicationInfo.Team) && OtherPlayer.LineOfSightTo(Candidate[i]) )
						Score[i] -= 10000.0;
				}
			}
	
	BestScore = Score[0];
	Best = Candidate[0];
	for (i=1;i<num;i++)
	{
		if (Score[i] > BestScore)
		{
			BestScore = Score[i];
			Best = Candidate[i];
		}
	}			
				
	return Best;
}

function bool AddBot()
{
	local NavigationPoint StartSpot;
	local jazzThinker NewBot;
	local int BotN, DesiredTeam;

	BotN = BotConfig.ChooseBotInfo();
	
	// Find a start spot.
	StartSpot = FindPlayerStart(0);
	if( StartSpot == None )
	{
		log("Could not find starting spot for Bot");
		return false;
	}

	// Try to spawn the player.
	NewBot = Spawn(BotConfig.GetBotClass(BotN),,,StartSpot.Location,StartSpot.Rotation);

	if ( NewBot == None )
		return false;

	if ( (bHumansOnly || Level.bHumansOnly) && !NewBot.bIsHuman )
	{
		NewBot.Destroy();
		log("Failed to spawn bot");
		return false;
	}

	StartSpot.PlayTeleportEffect(NewBot, true);

	// Init player's information.
	BotConfig.Individualize(NewBot, BotN, NumBots);
	NewBot.ViewRotation = StartSpot.Rotation;

	// broadcast a welcome message.
	BroadcastMessage( NewBot.PlayerReplicationInfo.PlayerName$EnteredMessage, true );

	AddDefaultInventory( NewBot );
	NumBots++;

	DesiredTeam = BotConfig.GetBotTeam(BotN);
	if ( (DesiredTeam == 255) || !ChangeTeam(NewBot, DesiredTeam) )
	{
		ChangeTeam(NewBot, NextBotTeam);
		NextBotTeam++;
		if ( NextBotTeam >= MaxTeams )
			NextBotTeam = 0;
	}

	if ( bSpawnInTeamArea )
	{
		StartSpot = FindPlayerStart(newBot.PlayerReplicationInfo.Team);
		if ( StartSpot != None )
		{
			NewBot.SetLocation(StartSpot.Location);
			NewBot.SetRotation(StartSpot.Rotation);
			NewBot.ViewRotation = StartSpot.Rotation;
			NewBot.ClientSetRotation(NewBot.Rotation);
			StartSpot.PlayTeleportEffect( NewBot, true );
		}
	}

	return true;
}

//-------------------------------------------------------------------------------------
// Level gameplay modification

//Use reduce damage for teamplay modifications, etc.
function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	local int reducedDamage;

	if (injured.Region.Zone.bNeutralZone)
		return 0;
	
	if ( instigatedBy == None )
		return Damage;

	Damage *= instigatedBy.DamageScaling;

	if ( (instigatedBy != injured) 
		&& (injured.PlayerReplicationInfo.Team ~= instigatedBy.PlayerReplicationInfo.Team) )
		return (Damage * FriendlyFireScale);
	else
		return Damage;
}

function Killed(pawn killer, pawn Other, name damageType)
{
	Super.Killed(killer, Other, damageType);

	if ( (killer != Other) && (killer != None) )
                Teams[killer.PlayerReplicationInfo.Team].Score += 1.0;

        if ( (GoalTeamScore > 0) && (Teams[killer.PlayerReplicationInfo.Team].Score >= GoalTeamScore) )
		EndGame("teamlimit");
}

function CreateTeam(string TeamName, int TeamSymbol, int TeamColor, pawn Other)
{
	local int temp;
	
	if(bNoTeamChanges && !jazzPlayer(Other).IsInState('Spectate'))
	{
		// We are allready in the game and we aren't allowed to change teams
		Other.ClientMessage("Changing Teams in not allowed",'Event',true);
	}
	
	temp = MakeTeam(TeamName,TeamSymbol,TeamColor);
	
	if(temp != 0)
	{
		if(temp == 1)
		{
			// New teams are not allowed
			Other.ClientMessage("New Teams are not allowed", 'Event', true);
		}
		else if(temp == 2)
		{
			// A team by that name allready exists
			Other.ClientMessage("A team with that name allready exists", 'Event', true);
		}
	}
	else
	{
		// Make Other join the new team
		ChangeTeam(Other,NumberOfTeams-1);
	}
}

function RemoveTeams()
{
	local int x,y;
	
	if(NumberOfTeams <= 2)
	{
		// Can't have less than two teams
		return;
	}
	
	for(x = 0; x < NumberOfTeams; x++)
	{
		if(Teams[x].Size == 0)
		{
			if(NumberOfTeams <= 2)
			{
				// Don't go below two teams
				return;
			}
			
			// We need to destroy this team, and make the next team (if there is one) take it's place
			// Also, we need to inform the players that their team number has changed
			
			If(x != NumberOfTeams - 1)
			{
				for(y = x; y < NumberOfTeams - 1; y++)
				{
					Teams[y] = Teams[y+1];
					TeamNumberChange(Y+1,Y);
				}
				Teams[NumberOfTeams] = None;
				NumberOfTeams--;
			}
		}
	}
}

function TeamNumberChange(int OldNumber, int NewNumber)
{
	local PlayerReplicationInfo PRI;
	
	foreach AllActors(class'PlayerReplicationInfo',PRI)
	{
		if(PRI.Team == OldNumber)
		{
			PRI.Team = NewNumber;
		}
	}
}

function int MakeTeam(string TeamName, int TeamSymbol, int TeamColor)
{
	local int x, NewTeamNumber;
	
	if(bAllowNewTeams && NumberOfTeams < MaxTeams)
	{
		for(x = 0; x < NumberOfTeams; x++)
		{
			if(Teams[x].TeamName == TeamName)
			{
				return 2;
			}
		}	
		Teams[NumberOfTeams] = Spawn(class'JazzTeamInfo');
		Teams[NumberOfTeams].Size = 0;
		Teams[NumberOfTeams].Score = 0;
		Teams[NumberOfTeams].TeamIndex = NumberOfTeams;
		Teams[NumberOfTeams].TeamName = TeamName;
		Teams[NumberOfTeams].TeamSymbol = TeamSymbol;
		Teams[NumberOfTeams].TeamColor = TeamColor;
		NumberOfTeams++;
		return 0;
	}
	else
	{
		return 1;
	}
}

function bool ChangeTeam(Pawn Other, int NewTeam)
{
	local int i, s;
	local pawn APlayer;
	local jazzteaminfo SmallestTeam;
	local bool bIgnoreNoTeamChange;

	// We shouldn't have to worry about the spectator as we shouldn't have any in Jazz
	/*
	if ( Other.IsA('Spectator') )
	{
		Other.PlayerReplicationInfo.Team = NewTeam;
		Other.PlayerReplicationInfo.TeamName = Teams[NewTeam].TeamName;
		return true;
	}
	
	log(Other $ " attempting to change teams");
	*/
	
	if(JazzPlayerReplicationInfo(Other.PlayerReplicationInfo).bSpectate)
	{
		JazzPlayerReplicationInfo(Other.PlayerReplicationInfo).bSpectate = false;
		jazzPlayer(Other).LeaveSpectator();
		bIgnoreNoTeamChange = true;
	}
	
	if(!bIgnoreNoTeamChange)
	{
		if ( Other.PlayerReplicationInfo.TeamName == Teams[Other.PlayerReplicationInfo.Team].TeamName )
		{
			if ( bNoTeamChanges )
				return false;
		}
	}

	// Finds the smallest team
	SmallestTeam = None;

	for( i=0; i<NumberOfTeams; i++ )
		if ( (Teams[i].Size < MaxTeamSize) && ((SmallestTeam == None) || (SmallestTeam.Size > Teams[i].Size)) )
		{
			s = i;
			SmallestTeam = Teams[i];
		}

	// Add player to the team if it exists
	// Magic Eight ball says: This code is stupid
	/*
	for( i=0; i< NumberOfTeams; i++ )
	{
		if ( i == NewTeam )
		{
			if (Teams[i].Size < MaxTeamSize)
			{
				AddToTeam(i, Other);
				return true;
			}
			else 
				break;
		}
	}
	*/
	
	if( NewTeam < NumberOfTeams )
	{
		if(Teams[NewTeam].Size <  MaxTeamSize)
		{
			AddToTeam(NewTeam, Other);
			return true;
		}
	}

	if ( (SmallestTeam != None) && (SmallestTeam.Size < MaxTeamSize) )
	{
		AddToTeam(s, Other);
		return true;
	}

	return false;
}

function AddToTeam( int num, Pawn Other )
{
	local texture NewSkin;
	local jazzteaminfo aTeam;
	local Pawn P;
	local bool bSuccess;

	aTeam = Teams[num];

	aTeam.Size++;
	Other.PlayerReplicationInfo.Team = num;
	Other.PlayerReplicationInfo.TeamName = aTeam.TeamName;
	bSuccess = false;
	if ( Other.IsA('PlayerPawn') )
		Other.PlayerReplicationInfo.TeamID = 0;
	else
		Other.PlayerReplicationInfo.TeamID = 1;

	while ( !bSuccess )
	{
		bSuccess = true;
		for ( P=Level.PawnList; P!=None; P=P.nextPawn )
                        if ( P.bIsPlayer && (P != Other) 
							&& (P.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team) 
							&& (P.PlayerReplicationInfo.TeamId == Other.PlayerReplicationInfo.TeamId) )
				bSuccess = false;
		if ( !bSuccess )
			Other.PlayerReplicationInfo.TeamID++;
	}

	BroadcastMessage(Other.PlayerReplicationInfo.PlayerName $ " has joined " $ aTeam.TeamName, false);

	// FIXME: We will deal with team skins later
	// NewSkin = texture(DynamicLoadObject(GetItemName(string(Other.Mesh))$"Skins.T_"$aTeam.TeamName, class'Texture'));

	if ( NewSkin != None )
		Other.Skin = NewSkin;
}

function bool CanSpectate( pawn Viewer, actor ViewTarget )
{
	return ( (Spectator(Viewer) != None) 
			|| ((Pawn(ViewTarget) != None) && (Pawn(ViewTarget).PlayerReplicationInfo.Team == Viewer.PlayerReplicationInfo.Team)) );
}

defaultproperties
{
     MaxTeams=2
     MaxTeamSize=4
     bTeamGame=True
     ScoreBoardType=Class'JazzMultiPlayer.JazzTeamScoreBoard'
     GameMenuType=Class'CalyGame.JazzConTeamBattleMode'
     HUDType=Class'JazzMultiPlayer.JazzTeamHUD'
     BeaconName="TeamBattleMode"
}
