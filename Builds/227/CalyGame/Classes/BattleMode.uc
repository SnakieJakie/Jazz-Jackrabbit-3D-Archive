//=============================================================================
// BattleMode.
//=============================================================================
class BattleMode expands JazzGameInfo;

var() globalconfig int	FluffLimit; 
var() globalconfig int	TimeLimit; // time limit in minutes
var() globalconfig bool	bMultiPlayerBots;
var() globalconfig bool bChangeLevels;

var		bool	bGameEnded;
var		bool	bAlreadyChanged;
var	  int RemainingTime;

// Bot related info
var   int			NumBots;
var	  int			RemainingBots;
var() globalconfig int	InitialBots;
var localized string GlobalNameChange;
var localized string NoNameChange;
var	JazzBotInfo			BotConfig;
var class<JazzBotInfo>	BotConfigType;
 
function PostBeginPlay()
{
	local string NextPlayerClass;
	local int i;

	BotConfig = spawn(class'JazzBotInfo');
	
	RemainingTime = 60 * TimeLimit;
	if ( (Level.NetMode == NM_Standalone) || bMultiPlayerBots )
		RemainingBots = InitialBots;
	Super.PostBeginPlay();
}

function bool IsRelevant(actor Other) 
{
	return Super.IsRelevant(Other);
}

function float PlayerJumpZScaling()
{
	return 1.0;
}

event InitGame( string Options, out string Error )
{
	local string InOpt;

	SetGameSpeed(1.0);

	Super.InitGame(Options, Error);

	FluffLimit = GetIntOption( Options, "FluffLimit", FluffLimit );
	TimeLimit = GetIntOption( Options, "TimeLimit", TimeLimit );

	InOpt = ParseOption( Options, "CoopWeaponMode");
	if ( InOpt != "" )
	{
		log("CoopWeaponMode "$bool(InOpt));
		bCoopWeaponMode = bool(InOpt);
	}
}

//------------------------------------------------------------------------------
// Game Querying.

function string GetRules()
{
	local string ResultSet;
	ResultSet = Super.GetRules();

	// Timelimit.
	ResultSet = "\\timelimit\\"$TimeLimit;
		
	// Flufflimit
	ResultSet = ResultSet$"\\flufflimit\\"$FluffLimit;
		
	// Bots in Multiplay?
	if( bMultiplayerBots )
		Resultset = ResultSet$"\\MultiplayerBots\\"$true;
	else
		Resultset = ResultSet$"\\MultiplayerBots\\"$false;

	// Change levels?
	if( bChangeLevels )
		Resultset = ResultSet$"\\ChangeLevels\\"$true;
	else
		Resultset = ResultSet$"\\ChangeLevels\\"$false;

	return ResultSet;
}

function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if (injured.Region.Zone.bNeutralZone)
		return 0;

	if ( instigatedBy == None)
		return Damage;

	//skill level modification
	if ( (instigatedBy.Skill < 1.5) && instigatedBy.IsA('JazzPawn') && injured.IsA('PlayerPawn') )
		Damage = Damage * (0.7 + 0.15 * instigatedBy.skill);

	return (Damage * instigatedBy.DamageScaling);
}

/*function float PlaySpawnEffect(inventory Inv)
{
	if ( !bCoopWeaponMode || !Inv.IsA('Weapon') )
		spawn( class 'ReSpawn',,, Inv.Location );
}*/

function RestartGame()
{
	local string NextMap;
	local MapList myList;

	log("restart game");

	// these server travels should all be relative to the current URL
	if ( bChangeLevels && !bAlreadyChanged && (MapListType != None) )
	{
		// open a the nextmap actor for this game type and get the next map
		bAlreadyChanged = true;
		myList = spawn(MapListType);
		NextMap = myList.GetNextMap();
		myList.Destroy();
		if ( NextMap == "" )
			NextMap = GetMapName(MapPrefix, NextMap,1);
		if ( NextMap != "" )
		{
			log("Changing to "$NextMap);
			Level.ServerTravel(NextMap, false);
			return;
		}
	}

	Level.ServerTravel("?Restart" , false);
}

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local playerpawn NewPlayer;

	NewPlayer = Super.Login(Portal, Options, Error, SpawnClass );
	if ( NewPlayer != None )
	{
		if ( Left(NewPlayer.PlayerReplicationInfo.PlayerName, 6) == DefaultPlayerName )
			ChangeName( NewPlayer, (DefaultPlayerName$NumPlayers), false );
		NewPlayer.bAutoActivate = true;
	}

	return NewPlayer;
}

function bool AddBot()
{
	local NavigationPoint StartSpot;
	local JazzThinker NewBot;
	local int BotN;

	// log("JazzBotInfo: Getting New Bot");
	BotN = BotConfig.ChooseBotInfo();
	
	// Find a start spot.
	StartSpot = FindPlayerStart(0);
	if( StartSpot == None )
	{
		log("Could not find starting spot for Bot");
		return false;
	}

	// Try to spawn the player.
	// log("JazzBotInfo: Spawning New Bot");
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
	return true;
}

function Logout(pawn Exiting)
{
	Super.Logout(Exiting);
	if ( Exiting.IsA('JazzPawn') )
		NumBots--;
}
	
function Timer()
{
	Super.Timer();

	if ( (RemainingBots > 0) && AddBot() )
		RemainingBots--;

	if ( TimeLimit > 0 )
	{
		RemainingTime--;
		if ( bGameEnded )
		{
			if ( RemainingTime < -7 )
				RestartGame();
		}
		else if ( RemainingTime <= 0 )
			EndGame("timelimit");
	}
}

/* FindPlayerStart()
returns the 'best' player start for this player to start from.
Re-implement for each game type
*/
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
	N = Level.NavigationPointList;
	While ( N != None )
	{
		if ( N.IsA('PlayerStart') && !N.Region.Zone.bWaterZone )
		{
			if (num<4)
				Candidate[num] = PlayerStart(N);
			else if (Rand(num) < 4)
				Candidate[Rand(4)] = PlayerStart(N);
			num++;
		}
		N = N.nextNavigationPoint;
	}

	if (num == 0 )
		foreach AllActors( class 'PlayerStart', Dest )
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
					if (NextDist < OtherPlayer.CollisionRadius + OtherPlayer.CollisionHeight)
						Score[i] -= 1000000.0;
					else if ( (NextDist < 1400) && OtherPlayer.LineOfSightTo(Candidate[i]) )
						Score[i] -= 10000.0;
				}
			}
	
	BestScore = Score[0];
	Best = Candidate[0];
	for (i=1;i<num;i++)
		if (Score[i] > BestScore)
		{
			BestScore = Score[i];
			Best = Candidate[i];
		}

	return Best;
}

/* AcceptInventory()
Examine the passed player's inventory, and accept or discard each item
* AcceptInventory needs to gracefully handle the case of some inventory
being accepted but other inventory not being accepted (such as the default
weapon).  There are several things that can go wrong: A weapon's
AmmoType not being accepted but the weapon being accepted -- the weapon
should be killed off. Or the player's selected inventory item, active
weapon, etc. not being accepted, leaving the player weaponless or leaving
the HUD inventory rendering messed up (AcceptInventory should pick another
applicable weapon/item as current).
*/
function AcceptInventory(pawn PlayerPawn)
{
	//deathmatch accepts no inventory
	local inventory Inv;
	for( Inv=PlayerPawn.Inventory; Inv!=None; Inv=Inv.Inventory )
		Inv.Destroy();
		
	PlayerPawn.Weapon = None;
	PlayerPawn.SelectedItem = None;
	
	AddDefaultInventory( PlayerPawn );
}

function ChangeName(Pawn Other, coerce string S, bool bNameChange)
{
	local pawn APlayer;

	if ( S == "" )
		return;

	if (Other.PlayerReplicationInfo.PlayerName~=S)
		return;
	
	APlayer = Level.PawnList;
	
	While ( APlayer != None )
	{	
		if ( APlayer.bIsPlayer && (APlayer.PlayerReplicationInfo.PlayerName~=S) )
		{
			Other.ClientMessage(S$NoNameChange);
			return;
		}
		APlayer = APlayer.NextPawn;
	}

	if (bNameChange)
		BroadcastMessage(Other.PlayerReplicationInfo.PlayerName$GlobalNameChange$S, false);
			
	Other.PlayerReplicationInfo.PlayerName = S;
}

function bool ShouldRespawn(Actor Other)
{
	if ( bCoopWeaponMode && Other.IsA('Weapon') 
	&& !Inventory(Other).bHeldItem &&  (Inventory(Other).ReSpawnTime != 0.0) )
	{
		Inventory(Other).ReSpawnTime = 1.0;
		return true;
	}
	return ( (Inventory(Other) != None) && (Inventory(Other).ReSpawnTime!=0.0) );
}

function bool CanSpectate( pawn Viewer, actor ViewTarget )
{
	return ( (Level.NetMode == NM_Standalone) || (Spectator(Viewer) != None) );
}

// Monitor killed messages for flufflimit
function Killed(pawn killer, pawn Other, name damageType)
{
	Super.Killed(killer, Other, damageType);
	if ( (killer == None) || (Other == None) )
		return;
	if ( (FluffLimit > 0) && (killer.PlayerReplicationInfo.Score >= FluffLimit) )
		EndGame("flufflimit");

/*	if ( BotConfig.bAdjustSkill && (killer.IsA('PlayerPawn') || Other.IsA('PlayerPawn')) )
	{
		if ( killer.IsA('JazzPawn') )
			JazzPawn(killer).AdjustSkill(true);
		if ( Other.IsA('JazzPawn') )
			JazzPawn(Other).AdjustSkill(false);
	}*/
}	

function EndGame( string Reason)
{
	local actor A;
	local pawn aPawn;

	Super.EndGame(Reason);

	bGameEnded = true;
	aPawn = Level.PawnList;
	TimeLimit = 1;
	RemainingTime = -1; // use timer to force restart
	while( aPawn != None )
	{
		if ( aPawn.IsA('JazzPawn') )
			aPawn.GotoState('GameEnded');
		aPawn = aPawn.NextPawn;
	}
}

defaultproperties
{
     FluffLimit=20
     bMultiPlayerBots=True
     InitialBots=3
     DefaultWeapon=Class'CalyGame.JackrabbitGun'
     ScoreBoardType=Class'JazzMultiPlayer.BattleScoreBoard'
     GameMenuType=Class'CalyGame.JazzConBattleMode'
     HUDType=Class'JazzMultiPlayer.JazzBattleHUD'
     MapPrefix="JMP"
}
