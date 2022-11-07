//=============================================================================
// Spectator.
//=============================================================================
class Spectator expands PlayerPawn;

event FootZoneChange(ZoneInfo newFootZone)
{
}
	
event HeadZoneChange(ZoneInfo newHeadZone)
{
}

exec function BehindView( Bool B )
{
}

exec function Walk()
{	
}

function ChangeTeam( int N )
{
	Level.Game.ChangeTeam(self, N);
}

exec function Taunt( name Sequence )
{
}

exec function CallForHelp()
{
}

exec function ThrowWeapon()
{
}

exec function Suicide()
{
}

exec function Fly()
{
	UnderWaterTime = -1;	
	SetCollision(false, false, false);
	bCollideWorld = true;
	GotoState('CheatFlying');

	ClientRestart();
}

function ServerChangeSkin(coerce string[64] SkinName)
{
}

function ClientReStart()
{
	//log("client restart");
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	BaseEyeHeight = Default.BaseEyeHeight;
	EyeHeight = BaseEyeHeight;
	
	GotoState('CheatFlying');
}

function PlayerTimeOut()
{
	if (Health > 0)
		Died(None, 'dropped', Location);
}

exec function Grab()
{
}

// Send a message to all players.
exec function Say( string[255] S )
{
	if ( !Level.Game.bMuteSpectators )
		BroadcastMessage( PlayerReplicationInfo.PlayerName$":"$S, true );
}

//=============================================================================
// functions.

exec function RestartLevel()
{
}

// This pawn was possessed by a player.
function Possess()
{
	bIsPlayer = true;
	DodgeClickTime = FMin(0.3, DodgeClickTime);
	EyeHeight = BaseEyeHeight;
	NetPriority = 8;
	Weapon = None;
	Inventory = None;
	Fly();
}

function PostBeginPlay()
{
	if (Level.LevelEnterText != "" )
		ClientMessage(Level.LevelEnterText);
	bIsPlayer = true;
	FlashScale = vect(1,1,1);
	if ( Level.NetMode != NM_Client )
		ScoringType = Level.Game.ScoreboardType;
}

//=============================================================================
// Inventory-related input notifications.

// The player wants to switch to weapon group numer I.
exec function SwitchWeapon (byte F )
{
}

exec function NextItem()
{
}

exec function PrevItem()
{
}

exec function ActivateItem()
{
}

exec function Fire( optional float F )
{
	ViewClass(class'Pawn');
}

// The player wants to alternate-fire.
exec function AltFire( optional float F )
{
	Viewtarget = None;
	ClientMessage("Now viewing from own camera", 'Event', true);
}

//=================================================================================

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
}

defaultproperties
{
     Visibility=0
     AttitudeToPlayer=ATTITUDE_Friendly
     bHidden=True
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
}
