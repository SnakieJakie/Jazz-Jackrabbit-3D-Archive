//=============================================================================
// JazzBotInfo.
//=============================================================================
class JazzBotInfo expands Info;

var() config bool	bAdjustSkill;
var() config bool	bRandomOrder;

var() config string BotNames[32];
var() config int BotTeams[32];
var() config float BotSkills[32];
var() config float BotAccuracy[32];
var() config float CombatStyle[32]; 
var() config float Alertness[32];
var() config float Camping[32];
var() config class<Weapon> FavoriteWeapon[32];
var	  byte ConfigUsed[32];
var() config string BotClasses[32];
var() config string BotSkins[32];
var string AvailableClasses[32], NextBotClass;
var int NumClasses;

function PreBeginPlay()
{
	//DON'T Call parent prebeginplay
}

function PostBeginPlay()
{
	local string NextBotClass;
	local int i;

	Super.PostBeginPlay();

	/*
	NextBotClass = GetNextInt("Bots", 0); 
	while ( (NextBotClass != "") && (NumClasses < 32) )
	{
		AvailableClasses[NumClasses] = NextBotClass;
		NumClasses++;
		NextBotClass = GetNextInt("Bots", NumClasses); 
	}
	*/
}

function String GetAvailableClasses(int n)
{
	return AvailableClasses[n];
}

function int ChooseBotInfo()
{
	local int n, start;

	if ( bRandomOrder )
		n = Rand(16);
	else 
		n = 0;

	start = n;
	while ( (n < 32) && (ConfigUsed[n] == 1) )
		n++;

	if ( (n == 32) && bRandomOrder )
	{
		n = 0;
		while ( (n < start) && (ConfigUsed[n] == 1) )
			n++;
	}

	if ( n > 31 )
		n = 31;

	return n;
}

function class<JazzThinker> GetBotClass(int n)
{
	return class<JazzThinker>( DynamicLoadObject(GetBotClassName(n), class'Class') );
}

function Individualize(jazzthinker NewBot, int n, int NumBots)
{
	local texture NewSkin;

	// Set bot's skin
	if ( (n >= 0) && (n < 32) && (BotSkins[n] != "") && (BotSkins[n] != "None") )
	{
		NewSkin = texture(DynamicLoadObject(BotSkins[n], class'Texture'));
		if ( NewSkin != None )
		{
			NewBot.Skin = NewSkin;
			NewBot.BaseSkin = NewSkin;
		}
	}

	// Set bot's name.
	if ( (BotNames[n] == "") || (ConfigUsed[n] == 1) )
		BotNames[n] = "Bot";

	Level.Game.ChangeName( NewBot, BotNames[n], false );
	if ( BotNames[n] != NewBot.PlayerReplicationInfo.PlayerName )
		Level.Game.ChangeName( NewBot, ("Bot"$NumBots), false);

	ConfigUsed[n] = 1;

	// FIXME: Bot currently have no skill
	/*
	// adjust bot skill
	NewBot.Skill = FClamp(NewBot.Skill + BotSkills[n], 0, 3);
	NewBot.ReSetSkill();
	*/
}

function SetBotClass(string ClassName, int n)
{
	BotClasses[n] = ClassName;
}

function SetBotName(coerce string NewName, int n)
{
	BotNames[n] = NewName;
}

function String GetBotName(int n)
{
	return BotNames[n];
}

function int GetBotTeam(int num)
{
	return BotTeams[Num];
}

function SetBotTeam(int NewTeam, int n)
{
	BotTeams[n] = NewTeam;
}

function int GetBotIndex(coerce string BotName)
{
	local int i;
	local bool found;

	found = false;
	for (i=0; i<ArrayCount(BotNames)-1; i++)
		if (BotNames[i] == BotName)
		{
			found = true;
			break;
		}

	if (!found)
		i = -1;

	return i;
}

function string GetBotSkin(int num)
{
	return BotSkins[Num];
}

function SetBotSkin(coerce string NewSkin, int n)
{
	BotSkins[n] = NewSkin;
}

function String GetBotClassName(int n)
{
	if ( (n < 0) || (n > 31) )
		return AvailableClasses[Rand(NumClasses)];

	if ( BotClasses[n] == "" )
		BotClasses[n] = AvailableClasses[Rand(NumClasses)];

	return BotClasses[n];
}

defaultproperties
{
     BotNames(0)="Bot1"
     BotNames(1)="Bot2"
     BotNames(2)="Bot3"
     BotNames(3)="Bot4"
     BotNames(4)="Bot5"
     BotNames(5)="Bot6"
     BotNames(6)="Bot7"
     BotNames(7)="Bot8"
     BotNames(8)="Bot9"
     BotNames(9)="Bot10"
     BotNames(10)="Bot11"
     BotNames(11)="Bot12"
     BotNames(12)="Bot13"
     BotNames(13)="Bot14"
     BotNames(14)="Bot15"
     BotNames(15)="Bot16"
     BotTeams(0)=1
     BotTeams(1)=1
     BotTeams(2)=1
     BotClasses(0)="CalyGame.JazzJazzThinker"
     BotClasses(1)="CalyGame.JazzJazzThinker"
     BotClasses(2)="CalyGame.JazzJazzThinker"
     BotClasses(3)="CalyGame.JazzJazzThinker"
     BotClasses(4)="CalyGame.JazzJazzThinker"
     BotClasses(5)="CalyGame.JazzJazzThinker"
     BotClasses(6)="CalyGame.JazzJazzThinker"
     BotClasses(7)="CalyGame.JazzJazzThinker"
     BotClasses(8)="CalyGame.JazzJazzThinker"
     BotClasses(9)="CalyGame.JazzJazzThinker"
     BotClasses(10)="CalyGame.JazzJazzThinker"
     BotClasses(11)="CalyGame.JazzJazzThinker"
     BotClasses(12)="CalyGame.JazzJazzThinker"
     BotClasses(13)="CalyGame.JazzJazzThinker"
     BotClasses(14)="CalyGame.JazzJazzThinker"
     BotClasses(15)="CalyGame.JazzJazzThinker"
     BotClasses(16)="CalyGame.JazzJazzThinker"
     BotSkins(0)="Jazz3.Jazz_purple_rb"
     BotSkins(1)="Jazz3.Jazz_purple_yb"
     BotSkins(2)="Jazz3.Jazz_purple_gb"
     BotSkins(3)="Jazz3.Jazz_teal_rb"
     BotSkins(4)="Jazz3.Jazz_teal_bb"
     BotSkins(5)="Jazz3.Jazz_teal_gb"
     BotSkins(6)="Jazz3.JJazz_01"
     BotSkins(7)="Jazz3.JJazz_01"
     BotSkins(8)="Jazz3.JJazz_01"
     BotSkins(9)="Jazz3.JJazz_01"
     BotSkins(10)="Jazz3.JJazz_01"
     BotSkins(11)="Jazz3.JJazz_01"
     BotSkins(12)="Jazz3.JJazz_01"
     BotSkins(13)="Jazz3.JJazz_01"
     BotSkins(14)="Jazz3.JJazz_01"
     BotSkins(15)="Jazz3.JJazz_01"
}
