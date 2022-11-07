//=============================================================================
// TreasureHunt.
//=============================================================================
class TreasureHunt expands BattleMode;

var float GameTime;

var bool bKnowKeyGen;
var int KeyGenNumber;

var int NumberOfPlayers;

var int NumberActive;
var int RemainingTime;
var	bool bGameEnded;


event Tick(float DeltaTime)
{
	GameTime += DeltaTime;
}

function PostBeginPlay()
{
	bKnowKeyGen = false;
	KeyGenNumber = 0;
}

function SpawnGem(vector Location, actor OldActor, int Number)
{
	local HuntGem Gem;
	local vector Vel;
	local int x;	

	for(x = 0; x < Number; x++)
	{
		Gem = Spawn(class'HuntGem',,,Location);
		
		Gem.OldOwner = OldActor;
		Gem.GemValue = 1;
		
		Vel.X = (FRand()*1000)-500;
		Vel.Y = (FRand()*1000)-500;
		
		Vel.Z = (FRand()*500)+250;
		
		Gem.Velocity = Vel;
		
		Gem.SetPhysics(PHYS_Falling);
	}
}

function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if ( injured.bIsPlayer )
	{
		if(THPlayerReplicationInfo(JazzPlayer(injured).PlayerReplicationInfo).GemNumber > 0)
		{
			if(Damage >= 50 && THPlayerReplicationInfo(JazzPlayer(injured).PlayerReplicationInfo).GemNumber >= 5)
			{
				SpawnGem(injured.Location, injured, 5);
				THPlayerReplicationInfo(JazzPlayer(injured).PlayerReplicationInfo).GemNumber -= 5;
			}
			else if (Damage >= 25 && THPlayerReplicationInfo(JazzPlayer(injured).PlayerReplicationInfo).GemNumber >= 3)
			{
				SpawnGem(injured.Location, injured, 3);
				THPlayerReplicationInfo(JazzPlayer(injured).PlayerReplicationInfo).GemNumber -= 3;				
			}
			else
			{
				SpawnGem(injured.Location, injured, 1);
				THPlayerReplicationInfo(JazzPlayer(injured).PlayerReplicationInfo).GemNumber -= 1;				
			}
		}
		return 0;
	}
	else
	{
		return Super.ReduceDamage(Damage, DamageType, injured, instigatedBy);
	}
}


event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local PlayerPawn      NewPlayer;

	NewPlayer =  Super.Login(Portal, Options, Error, SpawnClass);
	
	if ( NewPlayer != None )
	{
		NumberOfPlayers++;
		NumberActive++;
		NewPlayer.PlayerReplicationInfo = Spawn(class'THPlayerReplicationInfo',NewPlayer);
		NewPlayer.InitPlayerReplicationInfo();
		FindFlag(NewPlayer);
	}
	else
	Log("TreasureHuntGame) No Player Was Created");
	
	return NewPlayer;
}

function Logout(pawn Exiting)
{
	Super.Logout(Exiting);
	if ( Exiting.IsA('PlayerPawn') )
	{
		NumberOfPlayers--;
		if(!Exiting.IsInState('TreasureHuntFinish'))
		{
			if(THPlayerReplicationInfo(JazzPlayer(Exiting).PlayerReplicationInfo).GemNumber > 0)
			{
				SpawnGem(Exiting.Location,Exiting,THPlayerReplicationInfo(JazzPlayer(Exiting).PlayerReplicationInfo).GemNumber);
			}
			
			if(!THPlayerReplicationInfo(JazzPlayer(Exiting).PlayerReplicationInfo).TreasureKey)
			{
				RemoveFlag(JazzPlayer(Exiting));
			}
			NumberActive--;
		}
	}
}

function PlayerFinish(actor Other)
{
	JazzPlayer(Other).GotoState('TreasureHuntFinish');
	NumberActive--;
	
	if(NumberActive == 0)
	{
		EndGame("end");
	}
}

function RemoveFlag(JazzPlayer Exiting)
{
	local JazzTreasureKey Key;
	
	foreach AllActors(class'JazzTreasureKey',Key)
	{
		if(Key.User == Exiting)
		{
			Key.Destroy();
			return;
		}
	}
}

function FindFlag(playerpawn NewPlayer)
{
	local TreasureKeyGen Key;
	local int Temp;
	
	if(!bKnowKeyGen)
	{
		foreach AllActors(class'TreasureKeyGen',Key)
		{
			KeyGenNumber++;
		}
		
		bKnowKeyGen = true;
	}
	
	Temp = (FRand()*KeyGenNumber)-1;
	
	foreach AllActors(class'TreasureKeyGen',Key)
	{
		if(Temp <= 0)
		{
			Key.SpawnFlag(NewPlayer);
			return;
		}
		else
		{
			Temp--;
		}
	}
}

// Copied over from DeathMatch Game Info
function EndGame(string Reason)
{
	local actor A;
	local pawn aPawn;

	Super.EndGame(Reason);

	bGameEnded = true;
	aPawn = Level.PawnList;
	
	// Not sure what TimeLimit is
	/*
	TimeLimit = 1;
	*/
	
	RemainingTime = -1; // use timer to force restart
	
	while( aPawn != None )
	{
		if ( aPawn.IsA('Bots') )
			aPawn.GotoState('GameEnded');
		aPawn = aPawn.NextPawn;
	}
}

function Timer()
{
	Super.Timer();

	/*
	if ( (RemainingBots > 0) && AddBot() )
		RemainingBots--;
	*/
	
	if ( bGameEnded )
	{
		RemainingTime--;
			
		if ( RemainingTime < -7 )
			RestartGame();
	}
}

//
// Called when pawn has a chance to pick Item up (i.e. when 
// the pawn touches a weapon pickup). Should return true if 
// he wants to pick it up, false if he does not want it.
//
function bool PickupQuery( Pawn Other, Inventory item )
{
	// JazzPawnAI Check
	if ( JazzPawnAI(Other) != None)
		{
		//Log("JazzPawnAICheck) "$JazzPawnAI(Other).CanPickupItems);
		return (JazzPawnAI(Other).CanPickupItems);
		}

	if ( Other.Inventory == None )
		return true;
//	if ( bCoopWeaponMode && item.IsA('Weapon') && !Weapon(item).bHeldItem && (Other.FindInventoryType(item.class) != None) )
//		return false;
	else
		return !Other.Inventory.HandlePickupQuery(Item);
}

defaultproperties
{
     bRestartLevel=False
     bPauseable=False
     ScoreBoardType=Class'JazzMultiPlayer.TreasureHuntScoreBoard'
     GameMenuType=Class'CalyGame.JazzConTreasureMode'
     HUDType=Class'JazzMultiPlayer.JazzTreasureHuntHUD'
     BeaconName="BattleMode"
}
