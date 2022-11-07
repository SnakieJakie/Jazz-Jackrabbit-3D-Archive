//=============================================================================
// TreasureHunt.
//=============================================================================
class TreasureHunt expands UnrealGameInfo;

var float GameTime;

var bool bKnowKeyGen;
var int KeyGenNumber;

var int NumberOfPlayers;

var int NumberActive;

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
		if(JazzPlayer(injured).GemNumber > 0)
		{
			if(Damage >= 50 && JazzPlayer(injured).GemNumber >= 5)
			{
				SpawnGem(injured.Location, injured, 5);
				JazzPlayer(injured).GemNumber -= 5;
			}
			else if (Damage >= 25 && JazzPlayer(injured).GemNumber >= 3)
			{
				SpawnGem(injured.Location, injured, 3);
				JazzPlayer(injured).GemNumber -= 3;				
			}
			else
			{
				SpawnGem(injured.Location, injured, 1);
				JazzPlayer(injured).GemNumber -= 1;				
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
	string[32] Portal,
	string[120] Options,
	out string[80] Error,
	class<playerpawn> SpawnClass
)
{
	local PlayerPawn      NewPlayer;

	NewPlayer =  Super.Login(Portal, Options, Error, SpawnClass);
	
	if ( NewPlayer != None )
	{
		NumberOfPlayers++;
		NumberActive++;
		FindFlag(NewPlayer);
	}
	
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
			if(JazzPlayer(Exiting).GemNumber > 0)
			{
				SpawnGem(Exiting.Location,Exiting,JazzPlayer(Exiting).GemNumber);
			}
			if(JazzPlayer(Exiting).TreasureKey)
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
     DefaultPlayerClass=Class'Jazz3.Jazz'
     DefaultWeapon=Class'JazzContent.JackrabbitGun'
     ScoreBoardType=Class'JazzMultiPlayer.TreasureHuntScoreBoard'
     GameMenuType=Class'CalyGame.JazzGameMenu'
     HUDType=Class'JazzMultiPlayer.JazzTreasureHuntHUD'
     MapListType=Class'CalyGame.JazzMainMenu'
     MapPrefix="JMP"
}
