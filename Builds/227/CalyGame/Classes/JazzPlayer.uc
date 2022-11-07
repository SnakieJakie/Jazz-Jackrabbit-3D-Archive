//=============================================================================
// JazzPlayer.
//=============================================================================
class JazzPlayer expands PlayerPawn;


////////////////////////////////////////////////////////////////////////////////// VARS ////
//

///////////////////////////////////////////////////////////////////////////////////////////
// General Player Statistics
///////////////////////////////////////////////////////////////////////////////////////////
//
// General Statistics
//
var float			LifeTime;
//
// Additional Status Values
//
var() travel int	HealthMaximum;	// (Pawn) Health is starting health.
									// HealthMaximum can be changed, so keep that in mind.
									
// Invulnerability - Effects against player
var 	bool		CurrentlyInvulnerable;
var()	float		InvulnerabilityDuration;
var		float		InvulnerabilityTime;
var		bool		InvulnerabilityEffect;
var		float		PoisonTime;
var()	texture		PoisonTexture;
var()	texture		FrozenTexture;
var()	texture		PetrifyTexture;
var		bool		PoisonEffect;
var		float		TrailTime;

// Shield Actor
var		JazzShield	ShieldActor;

// General effects
var 	float 		EffectTime;

///////////////////////////////////////////////////////////////////////////////////////////
// Inventory / Etc.
///////////////////////////////////////////////////////////////////////////////////////////
//
// Inventory Amounts
//
var travel int		Carrots;	// Currency, of one form or another - currently money
var travel int		Keys;		// # of keys or key pieces
var travel int		Lives;		// # of lives the player has left
var float			ManaAmmo;	// Amount of ammo player has
var travel float	ManaAmmoMax; // Amount of ammo maximum
//
// Item Inventory System
//
// Group
// 0 - Weapon Cells
var bool				bShowInventory;
var travel Inventory	InventorySelections[5];		// Item currently selected in each group type - written to from JazzHUD
				// InventorySelections needs the be saved along with the player data

// Event Replication
//
var travel name			Events[200];
var travel byte			EventNum;
									
///////////////////////////////////////////////////////////////////////////////////////////
// Player Motion
///////////////////////////////////////////////////////////////////////////////////////////
//
// Vehicle Variables
//
var float			DefaultGroundSpeed;
var vector			VelocityHistory;
var JazzVehicle		Vehicle;
var bool			VehicleBounce;
//
// ForceTurning (This is done manually due to no known automatic function to use.)
//
var bool    		ForceTurning;
var int				TurnSpeedMax;	// TurnSpeedMax must be a multiple of TurnAccel
var int				TurnSpeed;
var	int				TurnAccel;
var bool			TurnIsClose;
var int				TurnDecelDistance;
//
// Jazz Motion Variables
var()	float		DashSpeed;		// Multiplier for quick-forward motion when double-forward
var		float		DashTime;
var		float		DashReadyTime;
var		eDodgeDir	DashDirection;
var 	float		LatentBounce;
var		bool		LatentBounceDo;

var     float		OldAForward,BaseAForward;
var		float		OldATurn;
var		float		OldAStrafe;
var		bool		OldRunContinue;	// Not a new PlayRunning - Use in animation to
									// tell if this is merely a check to see if the
									// player changed direction.
//
// Jazz Special Motion Variables
var		float		SpecialMotionHeldTime;		// Time SpecialMotion button has been held
//
// Jazz Jump-Twice Variables
var		float		DoubleJumpReadyTime;
var		float		DoubleJumpDelayTime;
var		bool		DoubleJumpAlready;
var()	bool		DoubleJumpAllowed;
//
// Swimming Variable
var()	float		MaxSwimmingJumpDuration;
var		float		SwimmingJumpDuration;
var		bool		bWaterJump;
var		bool		bJustJumpedOutOfWater;
//
// Ledge Hang
var		bool		bWasHung;
var		float		LedgeCheckDelay;
var		bool		bLedgeForwardHeld;
var		bool		bLedgeBackHeld;


///////////////////////////////////////////////////////////////////////////////////////////
// Sounds																VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//
// VoicePack
var()		class				VoicePack;
var			JazzVoicePack		VoicePackActor;

var	travel	byte				ColorSetting;			// In-game color selection override
var			texture				BaseSkin;
var			mesh				BaseMesh;

var			texture				TransmuteSkin;
var			mesh				TransmuteMesh;
var			float				TransmuteTime;
var			float				TransmuteEffectTime;	// If !=0 Transmute in Effect	
	
///////////////////////////////////////////////////////////////////////////////////////////
// Display Variables													VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//
// Camera
var travel enum	CameraType				// Camera type in use
{
CAM_Behind,								// 0) Normal behind-view style
CAM_Roaming								// 1) Crispy roaming style
} CameraInUse;

// Roaming
var rotator BasePlayerFacing;
var rotator DesiredFacing,DesiredCameraFacing;

var rotator CameraRotationFrom,CameraRotationCamera;

//var travel bool	UseKevinCamera;			// Whether the new camera should be used.  (Legacy)
//var bool	KevinCameraAvailable;		// Display Kevin Camera selection in A/V list?
var rotator CameraRoaming;				// Current roaming values for camera relative location
var rotator	CameraHistory;
var float	CameraHistoryDeltaTime;
var float	CameraDistHistory;
var bool    CameraFixedBehind;			// False for walking - True for swimming
var actor	ExternalCameraOverride;
//
// Text System
//var			JazzText	TextBox;			// Used for Devon's Messaging system
//
// Tutorial System Variables
var		bool			bShowTutorial;
var		byte			LastTutorial;		// Last tutorial message
var		travel byte		Tutorial[40];		// Tutorial booleans for determining if action has been done before.
var	localized string	TutorialTitle[40];	// Text for tutorial system messages
var	localized string	TutorialText[40];	// Text for tutorial system messages
var		enum			TutorialNumType		// This contains the predefined tutorial #s that other actors reference
{
	TutorialGetWeaponCell,
	TutorialGetWeapon,
	TutorialRocketBoard,
	TutorialHangGlider
} TutorialNum;

//var(Tutorial)	class<TutorialDisplay>		// TutorialDisplay actors containing the information to display for an event.
//					TutorialDisp[50];		// See TutorialNum above for the tutorial references
var				bool	TutorialActive;		// Is the tutorial system actively checking and displaying tutorials?
//
// Camera Variables
var vector			MyCameraLocation;
var rotator			MyCameraRotation;
//
// Shadow
var		ShadowCast		MyShadow;
// 
// Activation Icon
var		ActivationPlayerIcon	MyActivationIcon;
//
// Current Music volume - for entering menus
var		float 			MusicVolume;

///////////////////////////////////////////////////////////////////////////////////////////
// Damage																VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//
// Damage Ratings
//
// % of damage taken from source type
//
var(JDamage)	float	EnergyDamage;
var(JDamage)	float	FireDamage;
var(JDamage)	float	WaterDamage;
var(JDamage)	float	SoundDamage;
var(JDamage)	float	SharpPhysicalDamage;	// Arrow/sword/etc.
var(JDamage)	float	BluntPhysicalDamage;	// Club/mace/rock/etc.
var				float	LastDamageAmount;


///////////////////////////////////////////////////////////////////////////////////////////
// Multiplayer Game Variables											VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//

// var THPlayerReplicationInfo THPRI;

// Remove these as they are in the Player replication info now
/*
// How many gems the player has (used for Treasure Hunt mode)
var		int			GemNumber;
// If the player has the key (used for Treasure Hunt mode)
var		bool		TreasureKey;
// The time the player spent in the level
var		float		TreasureTime;
// If the player has finished or not (used for Treasure Hunt mode)
var		bool		TreasureFinish;
*/

// If we are the leader
var		bool		bLeader;
var		float		LeaderGrowEffectTime;
var		float		LeaderDesiredScale;
var		float		OriginalScale;

var		bool		bHasFlag;
var		CTFFlag		TeamFlag;
var	()  bool		bThunderLand;
//var		bool		bSpectate;

var		float		fJump;

var	JTargeting Targeting;

//
// Animations
function PlayGrabbing(float tweentime);
function PlayLedgePullup(float tweentime);
function PlayLedgeHang();
function PlayLedgeGrab();


////////////////////////////////////////////////////////////////////////////////////////////
// Network Variable Transfers
////////////////////////////////////////////////////////////////////////////////////////////
//
replication
{
	// Things server should replicate to the client
	unreliable if( Role==ROLE_Authority && bNetOwner )
		InventoryItems,Carrots, Gems, Score, ColorSetting; // , GemNumber, TreasureKey, TreasureTime, TreasureFinish;
	
	// Things the client should send to the server
	reliable if ( Role<ROLE_Authority )
		InvulnerabilityTime,TeamFlag,bHasFlag,bLeader,bThunderLand,TeamChange,bSpectate;
		
	// Functions the server should call
	reliable if( Role == ROLE_Authority)
		GainLeader, LoseLeader, BecomeSpectator, LeaveSpectator,PickUpFlag;

	// Input variables.
	unreliable if( Role<ROLE_AutonomousProxy )
		DashTime;
}



///////////////////////////////////////////////////////////////////////////////////////////
// Main Tick Function
///////////////////////////////////////////////////////////////////////////////////////////
//
//
event Tick (float DeltaTime)		// Untested
{
	LifeTime += DeltaTime;
}

function PostRender(canvas Canvas)
{
	Super.PostRender(Canvas);
	
	//if (TextBox != NONE)
	//TextBox.DrawText(Canvas);

	// Devon : Windowing system - Render the windows after the HUD
	//
	/*if (WindowsMain != NONE)
	WindowsMain.DrawWindows(Canvas);*/
}

// Try to pause the game.
exec function Pause()
{
	if (( bShowMenu ) || ( bShowTutorial ))
		return;
	if( !SetPause(Level.Pauser=="") )
		ClientMessage(NoPauseMessage);
}

// Try to set the pause state; returns success indicator.
function bool SetPause( BOOL bPause )
{
	local int MusicVol;

	if( Level.Game.bPauseable || bAdmin || Level.Netmode==NM_Standalone )
	{
		Log("MusicVolume) "$MusicVolume);
	
		if( bPause )
		{	
			MusicVolume = int(ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume"));
			// Pause
			if (Level.Pauser == "")
			{
			//SoundVol = SoundVol * 0.1;
			MusicVol = MusicVolume * 0.1;
			}
			
			Level.Pauser=PlayerReplicationInfo.PlayerName;
		}
		else
		{
			// Unpause
			if (Level.Pauser != "")
			{
			//SoundVol = SoundVol * 10;
			MusicVol = MusicVolume;
			}
			
			Level.Pauser="";
		}
		Log("MusicVolumeB) "$MusicVol);
		ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$MusicVol);
		return True;
	}
	else return False;
}

// Text Box handling
//
exec function AddText(string Text)
{
	//TextBox.AddText(Text,3+Len(Text)/5);
}

///////////////////////////////////////////////////////////////////////////////////////////
// Starting in Level
///////////////////////////////////////////////////////////////////////////////////////////
//
function PostBeginPlay()
{
	local JTargeting Targ;

	Super.PostBeginPlay();

	// Store original skin and mesh
	BaseSkin = Default.Skin;
	BaseMesh = Default.Mesh;
	
	// Default starting animation
	PlayWaiting();

	/*if(TextBox == None)
	{
		TextBox = spawn(class'JazzText',self);
	}*/

	// Test Lives Display
	//
	ChangeLives(0);
	
	// Windowing system defaults.
	//
	/*if(WindowsMain == None)
	{
		WindowsMain = spawn(class'jazzMainWindows',self);
		WindowsMain.Owner = self;
		WindowsMain.bDisplayWindows = true;
		//WindowsMain.bHasControl = true;
		//WindowsMain.bDisplayCursor = true;
	}*/
	
	Targ = Spawn(class'JTargeting',self);
	Targ.SetOwner(self);

	// Tutorial system defaults
	//
	LastTutorial = -1;

	if (JazzGameInfo(Level.Game).TutorialsInMode==true)
	TutorialActive = true;
	
	// Initialize Camera
	InitializeCamera();
}

// Travel Post Accept is called after PostBeginPlay when 'travel' variables are replicated
//
event TravelPostAccept()
{
	// Store original skin & mesh
	if (ColorSetting != 0)
		SpecialChangeSkin(ColorSetting);
	
	// Perform level event replication
	ReplicateLevelEvents();
	
	// Set ammo to current maximum
	ManaAmmo = ManaAmmoMax;

	Super.TravelPostAccept();
}

///////////////////////////////////////////////////////////////////////////////////////////
// Events
///////////////////////////////////////////////////////////////////////////////////////////
//
// See Triggers/ReplicateGameEvent for more detail.
//
function ReplicateLevelEvents()
{
	local ReplicateGameEvent R;
	local byte ReturnValue;
	
	foreach allactors(class'ReplicateGameEvent', R)
	{
		R.Instigator=Self;
		if (SearchForEvent(R.EventName) >= 0)
		R.PerformCheck(true);
	}
}

function AddEventDone( name EventName )
{
	// EventNum stores the current available Event, since Unreal starts everything at 0
	// for us where we'd otherwise want -1.  Not important, just keep it in mind.

	// Do not add event if event already exists.
	if (SearchForEvent(EventName) != -1)
	return;

	if (EventNum<200)
	{
		Events[EventNum]=EventName;
		EventNum++;
	}
}

// Return # of event in list or -1 if not found.
//
function float SearchForEvent( name EventName )
{
	local byte e;
	
	//Log("SearchEvent) "$EventName);
	for (e=0; e<EventNum; e++)
	{
		//Log("SearchEvent) "$Events[e]);
		if (Events[e]==EventName)
		return(e);
	}
	return(-1);
}

///////////////////////////////////////////////////////////////////////////////////////////
// Input
///////////////////////////////////////////////////////////////////////////////////////////
//
// Note on Input:
//
// In order to avoid having to redo internal Unreal code, we can just use existing useless
// buttons and remap them to what we want to use them for. :)
//
// bStrafe = bSpecialMotion
//

// JazzWindows : Mouse Left and Right instant click handling
//
/*function exec MouseLeftClick()
{
	if (bShowTutorial)
		TutorialEnd();
	else
	if (!bShowMenu)
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(true);
		else
			Fire();
	}
}*/

/*function exec MouseRightClick()
{
	if (bShowTutorial)
		TutorialEnd();
	else
	if (!bShowMenu)
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(false);
		else
			AltFire();
	}
}*/

// JazzWindows : Toggle mouse control in windows
//
/*function exec ToggleWindow(optional bool bForceFalse)
{
	if(bForceFalse)
	{
		WindowsMain.bHasControl = false;
		WindowsMain.bDisplayCursor = false;
	}
	else
	{
		WindowsMain.bHasControl = !WindowsMain.bHasControl;
		WindowsMain.bDisplayCursor = !WindowsMain.bDisplayCursor;
	}
}*/

///////////////////////////////////////////////////////////////////////////////////////////
// Damage Routines
///////////////////////////////////////////////////////////////////////////////////////////
//
function PlayHit(float Damage, vector HitLocation, name damageType, float MomentumZ)
{
}

function SpawnGibbedCarcass()
{
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	local bool		bAlreadyDead;
	local MultiStar M;

	// Invulnerability still in effect?
	if (InvulnerabilityTime<=0)
	{
	switch (damageType)
	{
		case 'Energy':
			Damage *= EnergyDamage;
			LastDamageAmount = Damage;
		break;
	
		case 'Fire':
			Damage *= FireDamage;
			LastDamageAmount = Damage;
		break;
		
		case 'Water':
			Damage *= WaterDamage;
			LastDamageAmount = Damage;
		break;
		
		case 'Sound':
			Damage *= SoundDamage;
			LastDamageAmount = Damage;
		break;
		
		case 'Sharp':	// Pointed object physical damage (arrow/sword/etc)
			Damage *= SharpPhysicalDamage;
			LastDamageAmount = Damage;
		break;
			
		case 'Blunt':	// Blunt object physical damage (club/mace/rock/etc)
			Damage *= SharpPhysicalDamage;
			LastDamageAmount = Damage;
		break;
	}
	
		if (Damage<1)
		{
			Damage=0;
			VoicePackActor.DoSound(Self,VoicePackActor.PlinkSound);
		}
		else
		{
			M = spawn(class'MultiStar',Self);
			M.MultiSpawn(Damage/5+1);
	
			// Update HUD
			//JazzHUD(MyHUD).UpdateHealth();
	
			// No?  Then get hurt.
			InvulnerabilityTime = InvulnerabilityDuration;
			VoicePackActor.DamageSound(Self,float(Damage)/float(HealthMaximum));

			// Stolen code from Pawn class - redoing Unreal's oddly unworking stuff.
			if (Physics == PHYS_Walking)
				momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
			momentum = momentum/Mass;
			AddVelocity( momentum ); 
				
			Damage = Level.Game.ReduceDamage(Damage, DamageType, self, instigatedBy);
			bAlreadyDead = (Health <= 0);
			Health -= Damage;
			
			if (CarriedDecoration != None)	// Drop carried decoration
				DropDecoration();
			
			
			if ((Health<=0) && ( !bAlreadyDead ))
			{
				NextState = '';
				PlayDeathHit(Damage, hitLocation, damageType);
				Enemy = instigatedBy;
				Died(instigatedBy, damageType, HitLocation);
			}
			
			MakeNoise(1.0);
			
			//Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		}
		}
	
	else
	{
	VoicePackActor.DoSound(Self,VoicePackActor.PlinkSound);
	}
}

function Carcass SpawnCarcass()
{
	return None;
}

function PlayTakeHitSound(int damage, name damageType, int Mult)
{
	if ( Level.TimeSeconds - LastPainSound < 0.3 )
		return;
	LastPainSound = Level.TimeSeconds;
	
	//VoicePackActor.DoSound(Self,VoicePackActor.DashSound);
	//PlaySound(HurtDefaultSound);
}



// General Effect Duration
//
function bool EffectToggle ( bool Effect, float EffectTime )
{
	// Flicker Player
	if ((Effect == false) || (EffectTime>0.5))
	Effect = true;
	else
	Effect = false;
	
	if (EffectTime<=0)	Effect = false;
	
	return( Effect );
}

// Transmutation functionality
//
function TransmuteToMesh ( mesh NewMesh, texture NewSkin, name ASequence, float AFrame, float NewTime )
{
	// Initiate Transmute effect
	//
	// Transmute effect is 
	// <0 = Transmuting Back
	// >0 = Transmute Into
	// 
	
	if ((TransmuteTime>0) && (TransmuteTime<9))	// Currently transmuted
	{
		TransmuteTime = -1;
	}
	else
	if (TransmuteTime<0)	// Transmuting back
	{
		// Nothing happens - can't interrupt effect
	}
	else					// No Transmute Effect Currently
	{
		TransmuteMesh = NewMesh;
		TransmuteSkin = NewSkin;
//		AnimSequence = ASequence;
//		AnimFrame = AFrame;
		AnimSequence = '';
		AnimFrame = 0;
		TransmuteTime = NewTime;
	}
}

// Return to default texture
//
function ReturnToDefaultSkin ()
{
	if (BaseSkin != None)
	Skin = BaseSkin;
	Texture = Default.Texture;
}
function ReturnToDefaultMesh ()
{
	
}

// Zone/special event skin selection
//
// Subclass and alter.
//
function SpecialChangeSkin( byte Color )
{
	//Log("StoreSpecialChange) "$Color);

	Texture = Skin;
	BaseSkin = Skin;

	ColorSetting = Color;	
}

// Multiplayer skin selection
function ServerChangeSkin(coerce string SkinName, coerce string FaceName, byte TeamNum)
{
	local texture NewSkin;
	local string MeshName;

	//Log("ServerSkin) "$SkinName);

	MeshName = GetItemName(string(Mesh));
	if ((Left(SkinName, Len(MeshName)) ~= MeshName) )
	{
		NewSkin = texture(DynamicLoadObject(SkinName, class'Texture'));
		if ( NewSkin != None )
		{
			Skin = NewSkin;
			BaseSkin = NewSkin;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Environment Activation / Conversation								GAMEPLAY
//////////////////////////////////////////////////////////////////////////////////////////////	
//
// This is the Use Item command.
//
exec function UseItem()
{
	if (bShowTutorial)
		TutorialEnd();
	else
	MyActivationIcon.DoActivate();
}

function CheckActivationObjects()
{
	// Trace in front of player for an object/NPC that can be activated.
	//
	// Implement a delay for switching to a different object when one already selected
	// and/or a delay for removing the focus after turning away.
	//

/*intrinsic(277) final function Actor Trace
(
	out vector      HitLocation,
	out vector      HitNormal,
	vector          TraceEnd,
	optional vector TraceStart,
	optional bool   bTraceActors,
	optional vector Extent
);*/
	
	local vector 	HitLocation,HitNormal;
	local actor 	Result;
	local bool		ActorFound;
	
	if (MyActivationIcon != None)
	{

		Result = Trace( HitLocation, HitNormal, 
			Location + (100 * vector(Rotation)), Location );

		if (Result != None)
		{
			//Log("ActivateCheck) "$Result);
			if (JazzGameObjects(Result) != None)
			{
				//Log("ActivateCheck) Is JazzGameObject");
				MyActivationIcon.Show(Result);
				ActorFound = true;
			}
			else
			if (JazzPawn(Result) != None)
			{
				//Log("ActivateCheck) Is JazzPawn");
				if (JazzPawn(Result).Activateable == true)
				{
					//Log("ActivateCheck) Is Activateable JazzPawn");
					MyActivationIcon.Show(Result);
					ActorFound = true;
				}
			}
		}
	
		// No actor found - deactivate icon?
		//
		if (ActorFound == false)
		{
			MyActivationIcon.Hide();
			ActorFound = false;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Timed Effects														SPECIAL EFFECTS
//////////////////////////////////////////////////////////////////////////////////////////////	
//
event PlayerTick ( float DeltaTime )
{
	//Log("Inventory) "$Weapon$" "$InventorySelections[0]);

	// Default Camera
	//
	CameraHistoryDeltaTime += DeltaTime;

	// Decrease Ledge Grab Delay
	//
	if (LedgeCheckDelay>0)
	LedgeCheckDelay -= DeltaTime;

	// Check for activation object/NPC in front of player 
	//
	CheckActivationObjects();
	
	// Player Invulnerability Display
	//
	//Log("PlayerTick) Invulnerability:"$InvulnerabilityTime);
	if (InvulnerabilityTime>0)
	{
		InvulnerabilityTime -= DeltaTime;
		InvulnerabilityEffect = EffectToggle(InvulnerabilityEffect,InvulnerabilityTime);		
		
		if (InvulnerabilityEffect)
		Style = STY_Modulated;
		else
		Style = STY_Normal;
	}
	
	// Player Poison Timer
	//
	if (PoisonTime>0)
	{
		PoisonTime -= DeltaTime;
		PoisonEffect = EffectToggle(PoisonEffect,PoisonTime);
		
		if (PoisonEffect)
		{
		Skin = PoisonTexture;
		Texture = PoisonTexture;
		}
		else
		{
		ReturnToDefaultSkin();
		}
	}

	// Player Trails - Initiated from other than Dash
	//
	if (TrailTime>0)
	{
		TrailTime -= DeltaTime;
	}
	
	// Do Player Trail
	//
	if ((TrailTime>0) || (DashTime>0))
	{
		DoPlayerTrail();
	}
	
	// Transmutation Effect
	//
	if (TransmuteTime>0)
	{
		if (TransmuteTime>9.5)
		{
			Style = STY_Translucent;
			ScaleGlow = 1-(10-TransmuteTime)*2;
		}
		else
		if (TransmuteTime>9)
		{
			Skin=TransmuteSkin;
			Texture=TransmuteSkin;
			Mesh=TransmuteMesh;
			ScaleGlow = ((9.5-TransmuteTime)*2);
		}
		else
		{
			Style = STY_Normal;
			Skin=TransmuteSkin;
			Texture=TransmuteSkin;
			Mesh=TransmuteMesh;
			ScaleGlow = 1;

			if (TransmuteTime<1)
			TransmuteTime=-TransmuteTime;
		}
		TransmuteTime -= DeltaTime;
	}
	else
	if (TransmuteTime<0)
	{
		if (TransmuteTime<-0.5)
		{
			Style = STY_Translucent;
			Skin=TransmuteSkin;
			Texture=TransmuteSkin;
			Mesh=TransmuteMesh;
			ScaleGlow = ((-(TransmuteTime+0.5))*2);
			
			TransmuteTime += DeltaTime;
			if (TransmuteTime>=-0.5)
			{
			ReturnToDefaultSkin();
			Mesh = BaseMesh;
			AnimEnd();
			}
		}
		else
		if (TransmuteTime<0)
		{
			Style = STY_Translucent;
			ReturnToDefaultSkin();
			Mesh = BaseMesh;
			ScaleGlow = 1-(-TransmuteTime)*2;
			TransmuteTime += DeltaTime;
			if (TransmuteTime>=0)
			{
				TransmuteTime = 0;
				ReturnToDefaultSkin();
				Mesh = BaseMesh;
				Style = STY_Normal;
				ScaleGlow = 1;
			}
		}
	}

	// Leader Effect
	//	
	if (LeaderGrowEffectTime>0)
	{
		LeaderEffectTick ( DeltaTime );
	}

}

// Petrify Effect
//
function Petrify()
{
	//TODO: Check for some kind of resistance to affects
	if(IsInState('Petrified'))
	{
		EffectTime += 2;
	}
	else
	{
		AbruptFireHalt();
		GotoState('Petrified');
	}
}

state Petrified
{
	ignores Fire,AltFire;
	
	// TODO: Stop player from taking damage when petrified
	// TODO: Stop player from being able to shoot when petrified
	// TODO: Let player edge around a bit when petrified and make it lower petrification time
	function BeginState()
	{
		SetPhysics(PHYS_Falling);
		Acceleration = vect(0,0,0);
		Skin = PetrifyTexture;
		//PlayAnim('');
		EffectTime = 10;
		fJump = 0;
	}
	
	event PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;
		
		if(fJump <= 0)
		{
			GetAxes(Rotation,X,Y,Z);
			
			if(Physics != PHYS_Falling)
			{
				if(bEdgeForward && bWasForward)
				{
					Velocity += X*20;
				}
				else if(bEdgeBack && bWasBack)
				{
					Velocity -= X*20;
				}
				
				if(bEdgeLeft)
				{
					Velocity -= Y*20;
				}
				else if(bEdgeRight)
				{
					Velocity += Y*20;
				}
				
				if(bEdgeForward || bEdgeBack || bEdgeLeft || bEdgeRight)
				{
					Velocity.Z = 25;
					
					fJump = 0.75;
					
					SetPhysics(PHYS_Falling);
				}
			}
		}
		bPressedJump = false;
	}
	
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
		
		EffectTime -= DeltaTime;
		
		fJump -= DeltaTime;
		
		PlayerMove(DeltaTime);
		
		// log(EffectTime);

		if(EffectTime <= 0)
		{
			ReturnToDefaultSkin();
			// TODO: Check to see if the player needs to be in a different state
			ReturnToNormalState();
		}
	}
	
/*	function exec MouseLeftClick()
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(true);
	}*/
	
/*	function exec MouseRightClick()
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(false);
	}*/
	
	function Freeze();
	function Burn();
}

///////////////////////////////////////////////////////////////////////////////////
// Bubble Effect
///////////////////////////////////////////////////////////////////////////////////
//
function Bubble()
{
	//TODO: Check for some kind of resistance to affects
	if(IsInState('Bubble'))
	{
		// Do nothing
	}
	else
	{
		AbruptFireHalt();
		GotoState('Bubbled');
	}
}

state Bubbled
{
	ignores Fire,AltFire;
	
	function BeginState()
	{
		SetPhysics(PHYS_Falling);
		Acceleration = vect(0,0,0);
		//PlayAnim('');
		EffectTime = 5;
		
		Spawn(class'BubbledEffect',Self);
	}
	
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		// We should get out of the bubble state once we've been shot or taken any form of damage
		EffectTime = 0;
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}		
	
	function EndState()
	{
		local BubbledEffect Bubble;
		
		foreach ChildActors(class'BubbledEffect',Bubble)
		{
			Bubble.Destroy();
		}
		ReturnToDefaultSkin();
	}
	
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
		EffectTime -= DeltaTime;

		if(EffectTime <= 0)
		{
			ReturnToNormalState();
		}
	}
}

// Freeze Effect
//
function Freeze(optional int Level)
{
	//TODO: Check for some kind of resistance to affects
	if(IsInState('Frozen'))
	{
		EffectTime += 2;
	}
	else
	{
		if (Level==0)
		EffectTime = 1;
		else
		EffectTime = Level;
		
		AbruptFireHalt();
		GotoState('Frozen');
	}
}

state Frozen
{
	ignores Fire,AltFire;
	
	function BeginState()
	{
		SetPhysics(PHYS_Falling);
		Acceleration = vect(0,0,0);
		Skin = FrozenTexture;
		//PlayAnim('');
	}
	
	event PlayerMove(float DeltaTime)
	{
		if(aForward != 0 && aTurn != 0 && aStrafe != 0)
		{
			EffectTime -= DeltaTime/4;
		}
		bPressedJump = false;
	}
	
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		EffectTime -= Damage/10;
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}	
	
	function Burn()
	{
		ReturnToNormalState();
	}
	
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
		EffectTime -= DeltaTime;
		
		PlayerMove(DeltaTime);
		
		// log(EffectTime);

		if(EffectTime <= 0)
		{
			ReturnToDefaultSkin();
			// TODO: Check to see if the player needs to be in a different state
			ReturnToNormalState();
		}

		Acceleration /= 1.35;
	}

	function Bump( actor Other)
	{
		if(PlayerPawn(Other) != None)
		{
			Acceleration += (Other.Velocity / 0.4);
		}
	}	
	
/*	function exec MouseLeftClick()
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(true);
	}*/
	
/*	function exec MouseRightClick()
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(false);
	}	*/
}


function Burn()
{
	//TODO: Check for some kind of resistance to affects
	if(!IsInState('Burning'))
	{
		AbruptFireHalt();
		GotoState('Burning');
	}
}

state Burning expands PlayerWalking
{
	ignores Fire,AltFire;
	
	function Freeze(optional int Level)
	{
		ReturnToNormalState();
	}

	function BeginState()
	{
		Spawn(class'JazzFireEffect',Self);
		SetTimer(1.0,true);
		//PlayAnim('');
		EffectTime = 15;
	}
	
	function Timer()
	{
		//TODO: Take damage
	}
	
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
		EffectTime -= DeltaTime;
		
		PlayerMove(DeltaTime);
		
		if(EffectTime <= 0)
		{
			// TODO: Check to see if the player needs to be in a different state
			ReturnToNormalState();
		}
	}

	function Touch( actor Other)
	{
		Super.Touch(Other);
		if(Other.IsA('JazzPlayer'))
		{
			JazzPlayer(Other).Burn();
			return;
		}
		else if(Other.IsA('JazzPawn'))
		{
			JazzPawn(Other).Burn();
			return;
		}
		else if(Other.IsA('JazzDecoration'))
		{
			//JazzDecoration(Other).Burn();
		}
	}	
	
	function EndState()
	{
		local JazzFireEffect r;
		
		foreach ChildActors(class'JazzFireEffect',r)
		{
			r.Destroy();
		}
		
		Disable('Timer');
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Dash Trails															SPECIAL EFFECTS
//////////////////////////////////////////////////////////////////////////////////////////////	
//
simulated function DoPlayerTrail ()
{
	local JazzPlayerTrailImage Image;
	Image = spawn(class'JazzPlayerTrailImage');
	Image.AnimFrame = AnimFrame;
	Image.AnimRate = 0;
	Image.AnimSequence = AnimSequence;
	Image.Mesh = Mesh;
	Image.Skin = Skin;
	Image.DrawScale = DrawScale;
	Image.InitialScaleGlow = DashTime;
}

function PlayDashSound()
{
	VoicePackActor.DoSound(Self,VoicePackActor.DashSound);
	//PlaySound(DashSound, SLOT_Interact, 1, false, 1000.0, 1.0);
}

simulated function PlayerTrailTime ( float Duration )
{
	TrailTime = Duration;
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Initialization														INITIALIZATION
//////////////////////////////////////////////////////////////////////////////////////////////	
//
function ServerReStartPlayer()
{
	//log("calling restartplayer in dying with netmode "$Level.NetMode);
	if ( Level.NetMode == NM_Client )
		return;
	if( Level.Game.RestartPlayer(self) )
	{
		//log("server restart client");
		ServerTimeStamp = 0;
		TimeMargin = 0;
		Level.Game.StartPlayer(self);
		ClientReStart();
	}
	else
		log("Restartplayer failed");
		
	ReturnToDefaultSkin();
	
	// Reset Weapon
	if (Weapon == None)
	JazzWeapon(Weapon).ChangeWeapon(0);
	if (Weapon != None)
	JazzWeapon(Weapon).ChangeCell(0);
	
	// Reset Weapon
	if (InventorySelections[0] != None)
	{
	JazzWeaponCell(InventorySelections[0]).ChargeEnd();
	JazzWeaponCell(InventorySelections[0]).GotoState('Idle');
	}
}

function PreBeginPlay()
{
	Super.PreBeginPlay();

	// Game Setup
	ManaAmmoMax = 10;
	ManaAmmo = ManaAmmoMax;

	// Turn Rate Maximum Set
	TurnSpeedMax = 2000;
	TurnAccel = 200;

	// DoubleJump
	DoubleJumpAlready = false;

	// Create shadow actor
	ShadowCastStart();
	
	// Voice Pack System Initialize
	VoicePackActor = JazzVoicePack(spawn(class<actor>(VoicePack)));
	
	// Create activation icon
	MyActivationIcon = spawn(class'ActivationPlayerIcon',Self);
	MyActivationIcon.SetOwner(Self);

	// Set default camera to use
	CameraInUse = CAM_Roaming;
	InitCamera();

	/*if(TextBox == None)
	{
		TextBox = spawn(class'JazzText',self);
	}*/
}

function ShadowCastStart ()
{
	// ShadowCast Actor Spawn
	MyShadow = spawn(class'ShadowCast',Self);
	//SC.SetOwner(Self);
}

event PreRender( canvas Canvas )
{
	//Log("PlayerPreRender) "$Self$" "$Viewport(Player));
	if (MyShadow != None)
	MyShadow.PreRender(Canvas);
	Super.PreRender(Canvas);
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Initialization														INITIALIZATION
//////////////////////////////////////////////////////////////////////////////////////////////	
//
//
function InitializeCamera()
{
	CameraDistHistory = 50;
}


//////////////////////////////////////////////////////////////////////////////////////////////	
// Camera Functions
//////////////////////////////////////////////////////////////////////////////////////////////	
//
function NextCameraType ()
{
	switch (CameraInUse)
	{
	case CAM_Behind:		CameraInUse = CAM_Roaming;	break;
	case CAM_Roaming:		CameraInUse = CAM_Behind;	break;
	}
	InitCamera();
}

function InitCamera ()
{
	// Init camera system in new type
	
	switch (CameraInUse)
	{
	case CAM_Roaming:
		//
		// Set base direction to current facing
		//
		BasePlayerFacing = Rotation;
		break;
	}
}

////////////////////// Redo External Viewpoint
//
event PlayerCalcView( out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	// Special swimming characteristics
	if (Physics==PHYS_Swimming)
	{
		PlayerCalcViewBehind(ViewActor,CameraLocation,CameraRotation);
	}
	else
	{
		// Current camera to use
		switch (CameraInUse)
		{
		case CAM_Behind:
			PlayerCalcViewBehind(ViewActor,CameraLocation,CameraRotation);
			break;
			
		case CAM_Roaming:
			PlayerCalcViewRoam(ViewActor,CameraLocation,CameraRotation);
			break;
		}
	}

	// Store location of camera for other uses
	MyCameraLocation = CameraLocation;
	MyCameraRotation = CameraRotation;
}

function bool CameraBlockedCheck ( out rotator CameraRotation, out float ViewDist, float WallOutDist, float ViewMax, float ViewChange, float ViewDistIncrease )
{
	local vector HitLocation,HitNormal;

	local bool ViewBlocked;
	local int ExtrapolateLevel;

	ViewBlocked = true;					// View is currently blocked
	ExtrapolateLevel = 10;				// Precision level to check to
		
	while ((ExtrapolateLevel>0))
	{
		//CameraForwardHack += ViewChange*0.9;
		CameraRotation.Yaw -= ViewChange; ViewDist += ViewDistIncrease;
					
		ViewBlocked = !(Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location, false ) == None);

		//Log("CameraRotation) "$CameraRotation.Yaw$" "$ViewMax$" "$" "$BaseYaw$" "$ViewBlocked);

		if ((!ViewBlocked)
			||
			((CameraRotation.Yaw > ViewMax) && (ViewChange<0))
			||
			((CameraRotation.Yaw < ViewMax) && (ViewChange>0))
			)
		{			
			// Extrapolate to next precision level
			ExtrapolateLevel -= 1;
						
			if (ExtrapolateLevel>0)
			{
			ViewMax = CameraRotation.Yaw;
			//CameraForwardHack -= ViewChange*0.9;
			CameraRotation.Yaw += ViewChange;
			ViewDist -= ViewDistIncrease;
						
			ViewChange /= 2;
			ViewDistIncrease /= 2;
			}
		}
	}
	
	return(ViewBlocked);
	//
	// End of New Check
}

event PlayerCalcViewRoam( out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local vector View,HitLocation,HitNormal;
	local float ViewDist,WallOutDist;
	local float BaseYaw,NewDist,ViewMax,ViewChange,ViewDistIncrease;
	local bool ViewBlocked;
	local int ExtrapolateLevel;
	
	local float Yaw1,Yaw2;
	local float Dist1,Dist2;
	local bool Block1,Block2;

	local rotator DesiredRotationFrom,DesiredRotationCamera,NewRotation;
	
	bBehindView = true;	// Force bBehindView On for Jazz Viewpoint
	
	WallOutDist = 5;
	ViewDist = 200;

	// Check most recent action by the player and come up with a desired rotation we would want
	// to shift to (relative to the player) if they keep moving in that way.
	//
	if (OldaTurn<0)	// Turning left
	{
		if (OldaForward!=0)  // Forward or Backward
		{
		// Don't lead as much when player moving diagonally
		DesiredRotationFrom = rot(-4000,0,0);
		DesiredRotationCamera = rot(0,-3000,0);	
		}
		else
		{
		// Camera should move behind the player but lead in their direction.
		DesiredRotationFrom = rot(-4000,0,0);
		DesiredRotationCamera = rot(0,-6000,0);
		}
	}
	else
	if (OldaTurn>0)	// Turning right
	{
		if (OldaForward!=0) // Forward or Backward
		{
		// Don't lead as much when player moving diagonally.
		DesiredRotationFrom = rot(-4000,0,0);
		DesiredRotationCamera = rot(0,3000,0);
		}
		else
		{
		// Camera should move behind the player but lead in their direction.
		DesiredRotationFrom = rot(-4000,0,0);
		DesiredRotationCamera = rot(0,6000,0);
		}
	}
	else
	if (BaseaForward>0)
	{
		// Camera should move behind the player normally
		DesiredRotationFrom = rot(-4000,0,0);
		DesiredRotationCamera = rot(0,0,0);	
	}
	else
	if (BaseaForward<0)
	{
		// Camera should move back and show a little more
		DesiredRotationFrom = rot(-6000,0,0);
		DesiredRotationCamera = rot(-2000,0,0);	
	}
	else
	{
		// Camera should move behind the player normally
		DesiredRotationFrom = rot(-4000,0,0);
		DesiredRotationCamera = rot(0,0,0);	
	}

	CameraHistoryDeltaTime = CameraHistoryDeltaTime * 2;
	if (CameraHistoryDeltaTime<0.05) CameraHistoryDeltaTime=0.01;
	if (CameraHistoryDeltaTime>1) CameraHistoryDeltaTime=1;

	// Move towards desired rotations
	CameraRotationFrom += (DesiredRotationFrom - CameraRotationFrom)*CameraHistoryDeltaTime;
	CameraRotationCamera += (DesiredRotationCamera - CameraRotationCamera)*CameraHistoryDeltaTime;
	
	CameraHistoryDeltaTime = 0;

	CameraRotation = BasePlayerFacing + CameraRotationFrom;
	BaseYaw = CameraRotation.Yaw;
			
	// Check if Camera is Blocked
	//
	//
	if (Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location, false ) != None)
	{
		NewDist = ViewDist;

		ViewMax = BaseYaw-32000;
		ViewChange = 2000;	// Yaw to change each check
		ViewDistIncrease = -((ViewDist-40)/50);
		ViewDistIncrease = 0;
		WallOutDist = 15;

		Dist1 = ViewDist;
		Block1 = CameraBlockedCheck(CameraRotation,Dist1,WallOutDist,ViewMax,ViewChange,ViewDistIncrease);
		Yaw1 = CameraRotation.Yaw;

		ViewChange = -2000;	// Yaw to change each check
		ViewMax = BaseYaw+32000;
		
		Dist2 = ViewDist;
		CameraRotation.Yaw = BaseYaw;
		Block2 = CameraBlockedCheck(CameraRotation,Dist2,WallOutDist,ViewMax,ViewChange,ViewDistIncrease);
		Yaw2 = CameraRotation.Yaw;
		
		//Log("YawCheck) "$Yaw1$" "$Yaw2$" "$CameraHistory.Yaw);
		
		// Do nothing if both cameras are blocked
		if ((Block1 == true) && (Block2 == true))
		{
			CameraRotation.Yaw = BaseYaw;
		}
		else		
		{
			if (abs(Yaw1-CameraHistory.Yaw) > abs(Yaw2-CameraHistory.Yaw))
			{
				ViewDist = Dist2;
				CameraRotation.Yaw = Yaw2;
			}
			else
			{
				ViewDist = Dist1;
				CameraRotation.Yaw = Yaw1;
			}
		
			CameraRotationFrom.Yaw += CameraRotation.Yaw - BaseYaw;
			CameraRotation = BasePlayerFacing + CameraRotationFrom;
		}
		//BasePlayerFacing.Yaw += CameraRotation.Yaw - BaseYaw;
		
		// Basic motion should be based off of the camera location, regardless of the fact 
		// that it has been blocked and shifted around.
		//
		BasePlayerFacing = CameraRotation;
		BasePlayerFacing.Pitch = 0;
	}
	else
	NewDist = ViewDist;
			
	ViewDist = FMin( NewDist, ViewDist );

	View = vect(1,0,0) >> CameraRotation;
	CameraLocation -= (ViewDist - WallOutDist) * View;
	CameraHistory = CameraRotation;
	CameraRotation += CameraRotationCamera;
	CameraDistHistory = ViewDist;
}

// Behind-View camera - Attempts to stay behind the player at all times and rotate upwards
// if blocked.
//
event PlayerCalcViewBehind( out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local vector View,HitLocation,HitNormal;
	local float ViewDist, WallOutDist,NewDist,ViewDistIncrease;
	local int	ExtrapolateLevel;
	local float ViewMax;
	local float ViewChange;
	local bool ViewBlocked;
	local float BaseYaw;
	local float BasePitch,LowPitch;
	local rotator NewRotation;
	
	local float TestPitch;
	local float TestValue;
	local float ViewBest,ViewBestPitch,ViewBestDist;

	local JazzFixedCamera	XCam;
	local actor				Result;
	
	local float CameraForwardHack;	// Angle the camera towards ahead of Jazz if he's near a wall
	local bool  IgnoreBlockedCamera;

	bBehindView = true;	// Force bBehindView On for Jazz Viewpoint
	
	// View Target - Point towards this actor
	//
	if ( ViewTarget != None )
	{
		ViewActor = ViewTarget;
		CameraLocation = ViewTarget.Location;
		CameraRotation = ViewTarget.Rotation;
		if ( Pawn(ViewTarget) != None )
		{
			if ( PlayerPawn(ViewTarget) != None )
				CameraRotation = PlayerPawn(ViewTarget).ViewRotation;
			CameraLocation.Z += Pawn(ViewTarget).EyeHeight;
		}
		return;
	}

	// View rotation.
	ViewActor = Self;
	CameraRotation = ViewRotation;
	
	if( bBehindView ) //up and behind
	{
		// Scan for External Cameras
		//
		ExternalCameraOverride = None;
		foreach allactors(class'JazzFixedCamera', XCam)
		{
			Result = Trace( HitLocation, HitNormal, XCam.Location, Location, false );
			
			if (Result == None)
			ExternalCameraOverride = XCam;	
		}
	
		// External Camera Viewpoint Calculation
		//	
		if (ExternalCameraOverride != None)	// Is there an external camera to use instead?
		{
			// External Camera code
			CameraLocation = ExternalCameraOverride.Location;
			HitLocation = (Location-ExternalCameraOverride.Location);
			TestValue = HitLocation.Y/HitLocation.X;
			if (HitLocation.X<0)
			CameraRotation.Yaw = -16384-(16384-atan(TestValue)/3.142857/2*65536);
			else
			CameraRotation.Yaw = atan(TestValue)/3.142857/2*65536;
			
			CameraRotation.Pitch = atan(HitLocation.Z/
					sqrt(abs(HitLocation.X*HitLocation.X+HitLocation.Y*HitLocation.Y)))
						/3.142857/2*65536;
			//CameraRotation.Pitch = 0;
			//Log("CameraRotation) TestValue:"$TestValue$" Yaw:"$CameraRotation.Yaw$" Pitch:"$CameraRotation.Pitch);
			//Log("CameraRotation) X:"$HitLocation.X$" Y:"$HitLocation.Y);
		}
		else
		{
			if (CameraZone(Region.Zone) == None)		// Camera Zone?
			{
				// Normal Camera Angle
				//
				//
				//
				// Normal: Player is not in CameraFacing Zone and uses normal camera motion.
				// Default camera rotation to attempt first.
				if (CameraFixedBehind)
				CameraRotation.Pitch = ViewRotation.Pitch - 4000;
				else
				CameraRotation.Pitch = 0 - 4000;

				// Reduce distance from player
				if (ViewRotation.Pitch<20000)
				{
				TestPitch = ViewRotation.Pitch;
				if (CameraFixedBehind==false)
					CameraRotation.Pitch += ViewRotation.Pitch/2;
				}
				else
				{
				TestPitch = -(65536-ViewRotation.Pitch)*0.7;
				if (CameraFixedBehind==false)
					CameraRotation.Pitch += -(65536-ViewRotation.Pitch)/1.5;
				}

			    ViewDist    = 200 - abs(TestPitch/200);
			    
			    ViewDistIncrease = 0;
				WallOutDist = 2;
			
				//CameraRotation.Yaw = ViewRotation.Yaw;
				if (CameraRotation.Pitch > 30000) CameraRotation.Pitch -= 65536;
				
				// Store unaltered pitch
				BasePitch = CameraRotation.Pitch;
			
				CameraHistoryDeltaTime = CameraHistoryDeltaTime * 0.8;
				if (CameraHistoryDeltaTime<0.1) CameraHistoryDeltaTime=0.1;
				if (CameraHistoryDeltaTime>1) CameraHistoryDeltaTime=1;
			
				// Calculation fix for moving mouse up/down to look downin full pitch range
				TestValue = abs(CameraHistory.Pitch-CameraRotation.Pitch);
				if (65536-TestValue<TestValue) TestValue=65536-TestValue;
				CameraRotation.Pitch = CameraRotation.Pitch + TestValue*(1-CameraHistoryDeltaTime);
				
				LowPitch = CameraRotation.Pitch;	// Store base pitch that camera would be at
			
				CameraRotation.Yaw = CameraRotation.Yaw + (CameraHistory.Yaw-CameraRotation.Yaw)*(1-CameraHistoryDeltaTime);
				View = vect(1,0,0) >> CameraRotation;
			}
			else
			{	
				// Special Camera Zone Angle
				//
				// Allow for specific camera angles and the like.
				// Override: Player is in CameraFacing Zone and must use fixed camera position.
				//
			
				switch (CameraZone(Region.Zone).CameraFacing)
				{
					case CAM_Above:
					CameraRotation.Pitch = -(65536/4);
					NewRotation = Rotation;
					NewRotation.Pitch = 0;
					SetRotation(NewRotation);
					break;
				}
				ViewDist = CameraZone(Region.Zone).CameraDistance;
				if (CameraZone(Region.Zone).CameraFixedYaw) CameraRotation.Yaw = 0;
				CameraRotation = CameraRotation + CameraZone(Region.Zone).CameraRotation;

				BasePitch = CameraRotation.Pitch;	// Store unaltered pitch
				LowPitch = CameraRotation.Pitch;	// Store base pitch that camera would be at
				
			    ViewDistIncrease = 2;
				WallOutDist = 5;
				
				IgnoreBlockedCamera = true;
			}
			
			/*
			if (NewDist<(ViewDist-WallOutDist-ViewDistIncrease))
			{
				ViewBest = -99;
				for (TestPitch=-65536/4; TestPitch<65536/4; TestPitch=TestPitch+100)
				{
					TestValue = 0;
					TestValue = (-abs(TestPitch+5900))/16000;
				
					CameraRotation.Pitch = TestPitch;
					if (Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location ) != None)
					NewDist = (Location - HitLocation) Dot View;
					else
					NewDist = ViewDist;
				
					TestValue += ((ViewDist-NewDist)/ViewDist);
				
					if (TestValue>ViewBest)
					{
						ViewBest = TestValue;
						ViewBestPitch = TestPitch;
						ViewBestDist = NewDist;
					}
				}
				CameraRotation.Pitch = ViewBestPitch;
				ViewDist = ViewBestDist;
			}*/
	
	/*		// Search Upwards - Original Camera Search
			while ((CameraRotation.Pitch > -65536/4) && (NewDist<(ViewDist-WallOutDist-ViewDistIncrease)))
			{
				ViewBlocked = true;
				CameraRotation.Pitch -= 100; ViewDist += ViewDistIncrease;
				if (Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location ) != None)
				NewDist = (Location - HitLocation) Dot View;
				else
				NewDist = ViewDist;
			}*/
	
			// Check if Camera is Blocked
			//
			//
			if (Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location, false ) != None)
			{
				NewDist = ViewDist;

				/*
				if (CameraZone(Region.Zone) == None)		// Camera Zone?
				{
					// Normal: Player is not in CameraFacing Zone and uses normal camera motion.
					// Default camera rotation to attempt first.
					if (CameraFixedBehind)
					CameraRotation.Pitch = ViewRotation.Pitch - 4000;
					else
					CameraRotation.Pitch = 0 - 4000;

					// Reduce distance from player
					if (ViewRotation.Pitch<20000)
					{
					if (CameraFixedBehind==false)
						CameraRotation.Pitch += ViewRotation.Pitch/2;
					}
					else
					{
					if (CameraFixedBehind==false)
						CameraRotation.Pitch += -(65536-ViewRotation.Pitch)/1.5;
					}

				}*/
				
				CameraRotation.Pitch = BasePitch;
				ViewMax = -13000;
				ViewChange = 2000;	// Pitch to change each check
				ViewDist = ViewDist;
				ViewDistIncrease = -((ViewDist-40)/50);
				WallOutDist = 15;
				ViewBlocked = true;					// View is currently blocked
				ExtrapolateLevel = 10;				// Precision level to check to
				
				if (!IgnoreBlockedCamera)
				while ((ExtrapolateLevel>0))
				{
					CameraForwardHack += ViewChange*0.9;
					CameraRotation.Pitch -= ViewChange; ViewDist += ViewDistIncrease;
					
					ViewBlocked = !(Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location, false ) == None);

					Log("CameraRotation) "$CameraRotation.Pitch$" "$ViewMax$" "$ViewBlocked);

					if ((!ViewBlocked)
						||
						(CameraRotation.Pitch < ViewMax))
					{			
						// Extrapolate to next precision level
						ExtrapolateLevel -= 1;
						ViewBlocked=true;
						
						if (ExtrapolateLevel>0)
						{
						ViewMax = CameraRotation.Pitch;
						CameraForwardHack -= ViewChange*0.9;
						CameraRotation.Pitch += ViewChange;
						ViewDist -= ViewDistIncrease;
						
						ViewChange /= 2;
						ViewDistIncrease /= 2;
						}

						NewDist = ViewDist;
					}
				}
				
				if (LowPitch < CameraRotation.Pitch)
				CameraRotation.Pitch = LowPitch;
				//
				// End of New Check

			// Check if Camera is Blocked
			//
			// Old Code - Downward check instead of upward
			/*
			if (Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location, false ) != None)
			{
				NewDist = ViewDist;

				if (CameraZone(Region.Zone) == None)		// Camera Zone?
					CameraRotation.Pitch = ViewRotation.Pitch - 5900;
					
				ViewDistIncrease = 5;
				WallOutDist = 2;
				ViewBlocked = true;
				
				while ((CameraRotation.Pitch < 0) && (ViewBlocked))
				{
					CameraRotation.Pitch += 300; ViewDist -= ViewDistIncrease;
					
					if (Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location, false ) == None)
					{ ViewBlocked = false; NewDist=ViewDist; }
				}
				
				if (ViewBlocked)	// No Hope
				{
					NewDist = (Location - HitLocation) Dot View;
				}
				else				// Extrapolate further
				{
					//Log("Camera) Extrapolate Origin:"$CameraRotation.Pitch$" "$ViewBlocked);
					ViewBlocked = true;
					TestPitch = CameraRotation.Pitch;
					CameraRotation.Pitch -= 270;
					ViewDist += ViewDistIncrease;
					ViewDistIncrease /= 10;
					while ((CameraRotation.Pitch <= TestPitch) && (ViewBlocked))
					{
						CameraRotation.Pitch += 30;		ViewDist -= ViewDistIncrease;
						
						if (Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location ) == None)
						{ ViewBlocked = false; NewDist=ViewDist; }
					}		
					//Log("Camera) Extrapolate End:"$CameraRotation.Pitch$" "$ViewBlocked$" "$TestPitch);
				}
				
				if (ViewBlocked)	// Sill blocked even when rotated all the way down
				{
					//Log("JazzCamera) TotallyBlocked");
				}*/
			
			}
			else
			NewDist = ViewDist;
		
			//if (CameraRotation.Pitch < 65536) CameraRotation.Pitch += 65536;
			
/*			ViewDist = FMin( NewDist, ViewDist );
			if (CameraDistHistory<ViewDist)
				ViewDist = ViewDist + (CameraDistHistory-ViewDist)*0.9;*/
			
			View = vect(1,0,0) >> CameraRotation;
			CameraLocation -= (ViewDist - WallOutDist) * View;
			CameraHistory = CameraRotation;

			if (CameraFixedBehind)
			CameraRotation.Pitch += CameraForwardHack;
			else
			{
				if (ViewRotation.Pitch<20000)
				CameraRotation.Pitch += CameraForwardHack + ViewRotation.Pitch/2.5;
				else
				CameraRotation.Pitch += CameraForwardHack - -(65536-ViewRotation.Pitch)/20;
			}
			
			CameraDistHistory = ViewDist;
		}
	}
	else
	{
		// First-person view.
		CameraLocation = Location;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
	}
}

function float RotateTowardYaw ( float YawA, float YawB, float ChangePct )
{
	local float YawChange;

	YawA = YawA & 65535;
	YawB = YawB & 65535;

	//Log("YawChange) "$YawA$" "$YawB$" "$ChangePct$" "$(YawA - YawB));
	
	YawChange = (YawA - YawB) & 65535;

	if (YawChange > (65535 - YawChange))
	YawChange = -(65535-YawChange);
	
	return ( YawChange * ChangePct );
}

function UpdateRotation(float DeltaTime, float maxPitch)
{
	local rotator newRotation;
	
	DesiredRotation = ViewRotation; //save old rotation
	ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
	ViewRotation.Pitch = ViewRotation.Pitch & 65535;
	If ((ViewRotation.Pitch > 17000) && (ViewRotation.Pitch < 52000))
	{
		If (aLookUp > 0) 
			ViewRotation.Pitch = 17000;
		else
			ViewRotation.Pitch = 52000;
	}
	
	/// Camera control movement
	//
	// Turning motion.
	// * Turns in behind camera
	// * Runs in circle in roaming camera (turn slightly)
	//
	switch (CameraInUse)
	{
	case CAM_Behind:
		ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
		break;
	case CAM_Roaming:
		// Rotate towards desired facing
		ViewRotation.Yaw = (ViewRotation.Yaw + 
			RotateTowardYaw(BasePlayerFacing.Yaw-DesiredFacing.Yaw,ViewRotation.Yaw,DeltaTime*5));
		//ViewRotation.Yaw += ((BasePlayerFacing.Yaw-DesiredFacing.Yaw)-ViewRotation.Yaw)*(DeltaTime*3);
		//ViewRotation.Yaw = BasePlayerFacing.Yaw-DesiredFacing.Yaw;
		//Log("Rotation) "$ViewRotation.Yaw$" "$Rotation.Yaw$" "$BasePlayerFacing.Yaw$" "$DesiredFacing.Yaw+BasePlayerFacing.Yaw);
			
		ViewRotation.Yaw += 24.0 * DeltaTime * aTurn;
		break;
	}
	
	ViewShake(deltaTime);
	ViewFlash(deltaTime);
		
	newRotation = Rotation;
	newRotation.Yaw = ViewRotation.Yaw;
	newRotation.Pitch = ViewRotation.Pitch;
	If ( (newRotation.Pitch > maxPitch * RotationRate.Pitch) && (newRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
	{
		If (ViewRotation.Pitch < 32768)
			newRotation.Pitch = maxPitch * RotationRate.Pitch;
		else
			newRotation.Pitch = 65536 - maxPitch * RotationRate.Pitch;
	}

	setRotation(newRotation);
}


////////////////////// Pt.3 Redo Physics
//
// State is played while doing the wall hang thang.
// 
//
state Hanging
{
	function PlayerTick ( float DeltaTime )
	{
		Global.PlayerTick( DeltaTime );
	
		PlayerMove(DeltaTime);
		
	}
	
	// Redo update rotation to remove view up/down motion.
	//
	function UpdateRotation(float DeltaTime, float maxPitch)
	{
		local rotator newRotation;
		
		DesiredRotation = ViewRotation; //save old rotation
		
		// Remove viewrotation up/down
		//
/*		ViewRotation.Pitch += 8.0 * DeltaTime * aLookUp;
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		If ((ViewRotation.Pitch > 16000) && (ViewRotation.Pitch < 59000))
		{
			If (aLookUp > 0) 
				ViewRotation.Pitch = 16000;
			else
				ViewRotation.Pitch = 59000;
		}*/
	
		//ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
		ViewShake(deltaTime);
		ViewFlash(deltaTime);
		
		newRotation = Rotation;
		newRotation.Yaw = ViewRotation.Yaw;
		newRotation.Pitch = ViewRotation.Pitch;
		If ( (newRotation.Pitch > maxPitch * RotationRate.Pitch) && (newRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
		{
			If (ViewRotation.Pitch < 32768) 
				newRotation.Pitch = maxPitch * RotationRate.Pitch;
			else
				newRotation.Pitch = 65536 - maxPitch * RotationRate.Pitch;
		}
		setRotation(newRotation);
	}

	//
	// Send movement to the server.
	// Passes acceleration in components so it doesn't get rounded.
	//
	function ServerMove
	(
		float TimeStamp, 
		vector Accel, 
		vector ClientLoc,
		bool NewbRun,
		bool NewbDuck,
		bool NewbPressedJump, 
		bool bFired,
		bool bAltFired,
		eDodgeDir DodgeMove, 
		byte ClientRoll, 
		int View
	)
	{
		local float DeltaTime, clientErr;
		local rotator DeltaRot, Rot;
		local vector LocDiff;
		local int maxPitch;
		local actor OldBase;
		
		Log("Server) NewbRun:"$NewbRun$" bFired:"$bFired$" NewbDuck:"$NewbDuck);
	
		// Make acceleration.
		/*
		Accel.X = AccelX;
		Accel.Y = AccelY;
		Accel.Z = AccelZ;
		*/
	
		// If this move is outdated, discard it.
		if ( CurrentTimeStamp >= TimeStamp )
			return;
	
		// handle firing and alt-firing
		if ( bFired )
		{
			if ( bFire == 0 )
			{
				Fire(0);
				bFire = 1;
			}
		}
		else
			bFire = 0;
	
	
		if ( bAltFired )
		{
			if ( bAltFire == 0 )
			{
				AltFire(0);
				bAltFire = 1;
			}
		}
		else
			bAltFire = 0;
	
		// Save move parameters.
		DeltaTime = TimeStamp - CurrentTimeStamp;
		if ( ServerTimeStamp > 0 )
		{
			TimeMargin += DeltaTime - (Level.TimeSeconds - ServerTimeStamp);
			if ( TimeMargin > MaxTimeMargin )
			{
				TimeMargin -= DeltaTime;
				if ( TimeMargin < 0.5 )
					MaxTimeMargin = 1.0;
				else
					MaxTimeMargin = 0.5;
				DeltaTime = 0;
				//ClientMessage("I have turbo-speed"); //FIXME REMOVE
				//log(self$" too far ahead at "$Level.TimeSeconds);
			}
		}
	
		CurrentTimeStamp = TimeStamp;
		ServerTimeStamp = Level.TimeSeconds;
		Rot.Roll = 256 * ClientRoll;

		// FIXME: ViewYaw no longer exsists (?)
		// Rot.Yaw = ViewYaw;
		if ( (Physics == PHYS_Swimming) || (Physics == PHYS_Flying) )
			maxPitch = 2;
		else
			maxPitch = 1;

		// FIXME: ViewPitch no longer exsists (?)
		/*
		If ( (ViewPitch > maxPitch * RotationRate.Pitch) && (ViewPitch < 65536 - maxPitch * RotationRate.Pitch) )
		{
			If (ViewPitch < 32768) 
				Rot.Pitch = maxPitch * RotationRate.Pitch;
			else
				Rot.Pitch = 65536 - maxPitch * RotationRate.Pitch;
		}
		else
			Rot.Pitch = ViewPitch;
		*/

		DeltaRot = (Rotation - Rot);
		// FIXME: ViewPitch and ViewYaw no longer exsist (?)
		/*
		ViewRotation.Pitch = ViewPitch;
		ViewRotation.Yaw = ViewYaw;
		*/
		ViewRotation.Roll = 0;
		SetRotation(Rot);

		OldBase = Base;

		// Perform actual movement.
		Log("MoveAutonomous) "$NewbPressedJump);
		if ( (Level.Pauser == "") && (DeltaTime > 0) )
			MoveAutonomous(DeltaTime, NewbRun, NewbDuck, NewbPressedJump, DodgeMove, Accel, DeltaRot);
	
		// Accumulate movement error.
		if ( Level.TimeSeconds - LastUpdateTime > 0.3 )
		{
			ClientErr = 10000;
		}
		else if ( Level.TimeSeconds - LastUpdateTime > 0.07 )
		{
			LocDiff = Location - ClientLoc;
			ClientErr = LocDiff Dot LocDiff;
		}
	
		// If client has accumulated a noticeable positional error, correct him.
		if ( ClientErr > 3 )
		{
			Log("ClientError) "$ClientErr);
		
			if ( Mover(Base) != None )
				ClientLoc = Location - Base.Location;
			else
				ClientLoc = Location;
			// log("Client Error at "$TimeStamp$" is "$ClientErr$" with Velocity "$Velocity$" LocDiff "$LocDiff$" Physics "$Physics);
			LastUpdateTime = Level.TimeSeconds;
			ClientAdjustPosition
			(
				TimeStamp, 
				GetStateName(), 
				Physics, 
				ClientLoc.X, 
				ClientLoc.Y, 
				ClientLoc.Z, 
				Velocity.X, 
				Velocity.Y, 
				Velocity.Z,
				Base
			);
		}
		//log("Server "$Role$" moved "$self$" stamp "$TimeStamp$" location "$Location$" Acceleration "$Acceleration$" Velocity "$Velocity);
	}	

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		local vector OldAccel,VelocityChange,NewVelocity;
		local float OldVelocityKeep,OldVelocityChangeKeep;
		local vector View,HitLocation,HitNormal,NewLocation;
		if (Physics == PHYS_None)
		{
		// Override Velocity System
		//TweentoHanging(0.1);
		}
		VelocityHistory = Velocity;
		bwashung = True;
		//bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );
	
		//TweentoHanging(0.1);
		// Jump Handling
		if ( bPressedJump )
		{
		SetPhysics(Phys_Falling);	
		Velocity.Z = 500;
		Velocity.X = vector(ViewRotation).X*100;
		Velocity.Y = vector(ViewRotation).Y*100;
		PlayLedgePullUp(3);
		VoicePackActor.DoSound(Self,VoicePackActor.LedgePull);
		ReturnToNormalState();
		}
	
	}
	
	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		local vector NewLocation;

		GetAxes(Rotation,X,Y,Z);

		// Press back to fall off the ledge
		if (aForward<0)
		{
			if (bLedgeBackHeld==false)
			{
			//Log("Hanging) "$aForward);
			SetPhysics(Phys_Falling);
			Velocity.Z = -20;	
			bWasHung = true;
			LedgeCheckDelay = 0.5;
			ReturnToNormalState();
			}
		}
		else
		bLedgeBackHeld = false;
		
		// Press back to fall off the ledge
		if (aForward>0)
		{
			if (bLedgeForwardHeld==false)
			{
			bPressedJump = true;
			}
		}
		else
		bLedgeForwardHeld = false;
		
		aForward *= 0;
		aStrafe  *= 0;
		aLookup  *= 0;
		aTurn    *= 0;
		OldAStrafe = aStrafe;
		OldATurn = aTurn;
		OldAForward = aForward;
		
		
		// Update acceleration.
		NewAccel = vect(0,0,0); 
		NewAccel.Z = 0;

		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);

		bPressedJump = false;
	}

	function EndState ()
	{
		GroundSpeed = DefaultGroundSpeed;
		VelocityHistory = vect(0,0,0);
		
		// Cool Effect :)
	}
	
	function AnimEnd()
	{
		PlayLedgeHang();
	}
	
	function BeginState ()
	{
		PlayLedgeGrab();
		bLedgeForwardHeld = true;
		bLedgeBackHeld = true;
	}
	
	
Begin:
	// Prepare Initial Motion
	
	bPressedJump = false;

}

////////////////////// Pt.3 Redo Physics
// 
//
state PlayerWalking
{
	function AnimEnd ()
	{
		local name MyAnimGroup;

		bAnimTransition = false;
		
		if (Physics == PHYS_Falling)
		{
			if (bJustJumpedOutOfWater)
			{
			PlayFlyingUp();
			bJustJumpedOutOfWater=false;
			}
			else
			PlayFallingDown();
		}
		else
		if (Physics == PHYS_Walking)
		{
			if (bIsCrouching)
			{
				if ( !bIsTurning && ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000) )
					PlayDuck();	
				else
					PlayCrawling();
			}
			else
			{
				MyAnimGroup = GetAnimGroup(AnimSequence);
				if ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000)
				{
					if ( MyAnimGroup == 'Waiting' )
						PlayWaiting();
					else
					{
						bAnimTransition = true;
						TweenToWaiting(0.2);
					}
				}	
				else if (bIsWalking)
				{
					if ( (MyAnimGroup == 'Waiting') || (MyAnimGroup == 'Landing') || (MyAnimGroup == 'Gesture') || (MyAnimGroup == 'TakeHit')  )
					{
						TweenToWalking(0.1);
						bAnimTransition = true;
					}
					else 
						PlayWalking();
				}
				else
				{
					if ( (MyAnimGroup == 'Waiting') || (MyAnimGroup == 'Landing') || (MyAnimGroup == 'Gesture') || (MyAnimGroup == 'TakeHit')  )
					{
						bAnimTransition = true;
						TweenToRunning(0.1);
					}
					else
						PlayRunning();
				}
			}
		}
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		local vector OldAccel;
		
		local rotator NewViewRotation1,NewViewRotation2;
		local vector  LocLeftWaist,LocRightWaist;
		local vector  FacingDistanceCheckShort,FacingDistanceCheckLong;
		local vector	HitNormal,HitLocation,HitLocation1,HitNormalA,HitNormalB;
		local float	  Temp;

		// Motion
		if (LatentBounceDo)
		{
		//Log("JazzPlayer) LatentBounce");
		SetLocation(Location + vect(0,0,50));
		Velocity.Z = LatentBounce;
		SetPhysics(PHYS_Falling);
		LatentBounceDo = false;
		}

		OldAccel = Acceleration;
		Acceleration = NewAccel;
		
		// JAZZ3 : This is the code that allows some motion while falling.
		//
		if ((Physics == PHYS_Falling))
		{
			Temp = abs(VSize(Velocity+ ((NewAccel/VSize(NewAccel))*800) ));
			Log("NewAccel Factor) "$Temp$" "$VSize(Velocity)$" "$VSize(NewAccel));
			Temp = Temp / 1500;
			if (Temp<0) Temp=0;
			if (Temp>1) Temp=1;
			Velocity += (NewAccel * DeltaTime)*(1-Temp);
				// Calculation - Increase by NewAccel factored down to 35%
		}
		else
		{
			UpdateRunning();
		}
		
		// Wall Grab End	
		if (bwashung)
			aforward = 0;
		
		// Wall Grab Detection
		if ((Physics == PHYS_Falling) && (LedgeCheckDelay<=0))
		{
		// Wall Grabbing DetectionCode
		NewViewRotation1 = ViewRotation;
		NewViewRotation2 = ViewRotation;
		NewViewRotation1.Yaw = ViewRotation.Yaw + 16384;	// Left 90°
		NewViewRotation2.Yaw = ViewRotation.Yaw - 16384;	// Right 90°
		
		LocLeftWaist	= Location + 10*vector(NewViewRotation1);	// Original value 20
		LocRightWaist	= Location + 10*vector(NewViewRotation1);	// Original value 20
		
		FacingDistanceCheckShort	= 50*vector(ViewRotation);	// Original value 150
		FacingDistanceCheckLong		= 100*vector(ViewRotation);	// Original value 200
		
	/*	WallGrabLocRightShoulder = WallGrabLocRightWaist;
		WallGrabLocLeftShoulder = WallGrabLocLeftWaist;
		WallGrabLocRightHead = WallGrabLocRightWaist;
		WallGrabLocLeftHead = WallGrabLocLeftWaist;
		WallGrabLocRightOverHead = WallGrabLocRightWaist;
		WallGrabLocLeftOverHead =  WallGrabLocLeftWaist;
		WallGrabLocRightHead.Z = WallGrabLocRightWaist.Z + 50;
		WallGrabLocLeftHead.Z = WallGrabLocLeftWaist.Z + 50;
		WallGrabLocRightOverhead.Z = WallGrabLocRightWaist.Z + 200;
		WallGrabLocLeftOverhead.Z = WallGrabLocLeftWaist.Z + 200;*/
		
        
       	if (( Trace( HitLocation1, HitNormalA, LocRightWaist	+ FacingDistanceCheckShort, Location ) == Level ) &&
			( Trace( HitLocation, HitNormalB, LocLeftWaist	+ FacingDistanceCheckShort, Location ) == Level )&&
			( Trace( HitLocation, HitNormal, LocRightWaist	+ vect(0,0,50) + FacingDistanceCheckLong, Location ) != Level ) &&	// Original value 50
			( Trace( HitLocation, HitNormal, LocLeftWaist	+ vect(0,0,50) + FacingDistanceCheckLong, Location ) != Level ) &&	// Original value 50
			( Trace( HitLocation, HitNormal, LocRightWaist	+ vect(0,0,200) + FacingDistanceCheckLong, Location ) != Level ) &&	// Original value 200
			( Trace( HitLocation, HitNormal, LocLeftWaist	+ vect(0,0,200) + FacingDistanceCheckLong, Location ) != Level ) &&	// Original value 200
			( HitNormalA.Z < 0.4) && (HitNormalB.Z < 0.4)&&
			( Self.Velocity.Z <= 0))
		{
			
		SetLocation(HitLocation1);
		SetPhysics(Phys_None);
		//ViewRotation=rotator((HitNormalB)*(-1));
		PlayGrabbing(0.5);
		GotoState('Hanging');
		}

		//End of Wall Grabbing Code
		if ((aForward<0) || ((Velocity.Z<10) && (Acceleration.Z<10)))
		Velocity += NewAccel * 0.15 * DeltaTime;
		}
		
		bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );

		// SpecialMotion
		// This is not used anymore
		/*if (aStrafe>0)
		{
			DoSpecialPlayerMotion( SpecialMotionHeldTime );
			SpecialMotionHeldTime += DeltaTime;
		}
		else
			SpecialMotionHeldTime = 0;*/

		// DoubleJump		//
		if (DoubleJumpAllowed)
		{
			DoubleJumpReadyTime -= DeltaTime;
			DoubleJumpDelayTime -= DeltaTime;
			if (bPressedJump && (DoubleJumpReadyTime>0) && (!DoubleJumpAlready) && (DoubleJumpDelayTime<=0))
			{
				DoubleJumpAlready = true;
				DoDoubleJump();
			}
		}
		
		// Jump Handling
		//
		if ( bPressedJump )
		{
			DoubleJumpReadyTime = 1.5;
			DoubleJumpDelayTime = 0.5;
			DoJump();
		}
		
		if ( (Physics == PHYS_Walking)
			&& (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			if (!bIsCrouching)
			{
				if (bDuck != 0)
				{
					bIsCrouching = true;
					PlayDuck();
				}
			}
			else if (bDuck == 0)
			{
				OldAccel = vect(0,0,0);
				bIsCrouching = false;
			}

			if ( !bIsCrouching )
			{
				if ( (!bAnimTransition || (AnimFrame > 0)) && (GetAnimGroup(AnimSequence) != 'Landing') )
				{
					if ( Acceleration != vect(0,0,0) )
					{
						if ( (GetAnimGroup(AnimSequence) == 'Waiting') || (GetAnimGroup(AnimSequence) == 'Gesture') || (GetAnimGroup(AnimSequence) == 'TakeHit') )
						{
							bAnimTransition = true;
							TweenToRunning(0.1);
						}
					}
			 		else if ( (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000) 
						&& (GetAnimGroup(AnimSequence) != 'Gesture') ) 
			 		{
			 			if ( GetAnimGroup(AnimSequence) == 'Waiting' )
			 			{
							if ( bIsTurning && (AnimFrame >= 0) ) 
							{
								bAnimTransition = true;
								PlayTurning();
							}
						}
			 			else if ( !bIsTurning ) 
						{
							bAnimTransition = true;
							TweenToWaiting(0.2);
						}
					}
				}
			}
			else
			{
				if ( (OldAccel == vect(0,0,0)) && (Acceleration != vect(0,0,0)) )
					PlayCrawling();
			 	else if ( !bIsTurning && (Acceleration == vect(0,0,0)) && (AnimFrame > 0.1) )
					PlayDuck();
			}
		}
		
		//For WaterJump
		bWaterJump = False;
		//For wall Grab
		bwashung = False;
	}

	// Basic Jazz Motion
	// 			
	function Landed(vector HitNormal)
	{
		//Global.Landed(HitNormal);	// Do not want normal landed function
		
	if(bThunderLand)
		ThunderLand();
		
		//From 'PlayerPawn' - Modified
		PlayLanded(Velocity.Z);
		if (Velocity.Z < -1.4 * JumpZ)
		{
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
			if (Velocity.Z <= -1500)
			{
				if ( Role == ROLE_Authority )
					TakeDamage(-0.05 * (Velocity.Z + 1450), None, Location, vect(0,0,0), 'fell');
			}
		}
		else if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.5 * JumpZ) )
			MakeNoise(0.1 * Level.Game.Difficulty);				
		bJustLanded = true;
		
		AnimEnd();
		//End 'PlayerPawn'
		
		// Dash End
		DashTime = 0;
		DashReadyTime = 0;
		
		// Trail End
		TrailTime = 0;
		
		// DoubleJump End
		DoubleJumpAlready = false;
		DoubleJumpReadyTime = 0;
	}
	
	function DoDoubleJump ()
	{
		local vector VelocityAdd;
		
		if ( Role == ROLE_Authority )
			VoicePackActor.DoSound(Self,VoicePackActor.JumpSound);
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			MakeNoise(0.1 * Level.Game.Difficulty);
		
		//if (aForward<0)	VelocityAdd.x = aForward/10;	// Only allow reverse speed increase
		VelocityAdd = VelocityAdd >> Rotation;
		if (Velocity.z + JumpZ*0.75 >= JumpZ*0.75) Velocity.z = JumpZ*0.75;
		else Velocity.z = JumpZ*0.75;
		
		Velocity += VelocityAdd;
		//if ( Base != Level )
			//Velocity.Z += Base.Velocity.Z; 
		SetPhysics(PHYS_Falling);
		//if ( bCountJumps && (Role == ROLE_Authority) )
			//Inventory.OwnerJumped();
			
		PlayFlyingUp();		
	}
	
	//Player Jumped
	function DoJump( optional float F )
	{
		if ( CarriedDecoration != None )
			return;
			
		if ( !bIsCrouching && (Physics == PHYS_Walking) )
		{
			if ( Role == ROLE_Authority )
				VoicePackActor.DoSound(Self,VoicePackActor.JumpSound);
			if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
				MakeNoise(0.1 * Level.Game.Difficulty);

			if ((DashTime>0) && (VSize(Velocity)>400))
			{
			Velocity.Z = JumpZ * 0.8;
			DoubleJumpReadyTime = 0;
			}
			else
			{
			Velocity.Z = JumpZ;
			}
			
			if ( Base != Level )
				Velocity.Z += Base.Velocity.Z; 
			SetPhysics(PHYS_Falling);
			
			PlayFlyingUp();
		
			if ( bCountJumps && (Role == ROLE_Authority) )
				Inventory.OwnerJumped();	
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////	
	// Special Player Motion 										(BUTTON: SPECIAL MOTION)
	//////////////////////////////////////////////////////////////////////////////////////////////	
	//
	// Override this function for the individual player.
	//
	function DoSpecialPlayerMotion( float HeldTime )
	{
		// Check for special item in use first
		
		// Do special Player Motion
	}

	event PlayerTick( float DeltaTime )
	{
		Global.PlayerTick(DeltaTime);
	
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
	}

function rotator JazzOrthoRotation ( vector V )
{
	local Rotator R;
	local float TestValue;
	local bool  YawReverse;
	
	YawReverse = (V.X<0);
	
	TestValue = (V.Y+0.1)/V.X;
	if (YawReverse)
	{
	R.Yaw = -16384-(16384-atan(TestValue)/3.142857/2*65536);
	}
	else
	R.Yaw = atan(TestValue)/3.142857/2*65536;

	return(R);
}

	// Main walking PlayerMove
	//
	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation,TempRotation;
		local float Speed2D,TempF;
		
		local float Size;

		GetAxes(Rotation,X,Y,Z);

		BaseAForward = aForward;
		
		/////////////////////////////////////////////////////////////////////////// ROAMING //////
		// Roaming camera control
		//
		// Left or right should cause player to run forward, but turn to be facing left or right
		//
		if (CameraInUse == CAM_Roaming)
		{
			if ((aForward != 0) || (aTurn != 0))
			{
			NewAccel.Y = aForward;
			NewAccel.X = aTurn;
			DesiredFacing = JazzOrthoRotation(NewAccel);
			DesiredFacing.Yaw -= 16384;
			}

			aForward = Sqrt(Square(aForward)+Square(aTurn));
		}
		
		aForward *= 0.4;
//		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aStrafe  *= 0.4;
		
		OldAStrafe = aStrafe;
		OldATurn = aTurn;
		OldAForward = aForward;
		
		// Super-Dash Acceleration Increase
		//
		//
		DashReadyTime -= DeltaTime;
		if (DashTime>0)
		{
			//if ((aTurn != 0) && (Physics != PHYS_Falling))
				//DashTime = 0;
			GroundSpeed = 800;
			DashTime -= DeltaTime;
			
			// Stop dash if stop running
			if (aForward<=0) DashTime = 0;
	
			//if (frand()<0.5)
				//spawn(class'BloodPuff',,,Location + vect(0,0,10));
		}
		else
		{
			GroundSpeed = 400;
		}
		
		// Poisoned?  Lower the ground speed.
		// 
		// Ground Speed is set above depending on dash in effect or not.
		//
		if (PoisonEffect)
		{
			GroundSpeed = GroundSpeed*0.6;
		}
		
		
		// Update acceleration.
		switch (CameraInUse)
		{
		case CAM_Behind:
			NewAccel = aForward*X + aStrafe*Y; 
			NewAccel.Z = 0;
			break;
			
		case CAM_Roaming:
			NewAccel = aForward*X + aStrafe*Y + abs(aTurn*2)*X;
			NewAccel.Z = 0;

			// Dependent of left/right motion make adjustments to the
			BasePlayerFacing.Yaw += (aTurn/1000)*DeltaTime*10000;	// Approximately 10000 yaw units per tick

			// Drift toward ViewRotation
			if ((OldATurn==0) && (OldAForward==0))
			{
				TempF = RotateTowardYaw(BasePlayerFacing.Yaw,ViewRotation.Yaw,1*DeltaTime);
				BasePlayerFacing.Yaw = BasePlayerFacing.Yaw - TempF;
				DesiredFacing.Yaw = DesiredFacing.Yaw - TempF;
			}
		
			aTurn = 0;
			break;
		}
		
		// Forward pressed
		//
		if (bEdgeForward && bWasForward && (DashTime<=0) && (Physics!=PHYS_Falling))
		{
			if (DashReadyTime>0)
			{
				DashTime = 2;
				DashDirection = DODGE_Forward;
				VoicePackActor.DoSound(Self,VoicePackActor.DashSound);
			}
			else
			{
				DashReadyTime = 0.5;
			}
		
		}
				
		if ( (Physics == PHYS_Walking) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bSnapToLevel )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;	
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			//add bobbing when walking
			if ( !bShowMenu )
			{
				if ( Speed2D < 10 )
					BobTime += 0.2 * DeltaTime;
				else
					BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
				WalkBob = Y * 0.65 * Bob * Speed2D * sin(6.0 * BobTime);
				if ( Speed2D < 10 )
					WalkBob.Z = Bob * 30 * sin(12 * BobTime);
				else
					WalkBob.Z = Bob * Speed2D * sin(12 * BobTime);
			}
		}	
		else if ( !bShowMenu )
		{ 
			BobTime = 0;
			WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
		}

		// Update rotation.
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
			
		bPressedJump = false;
	}
	
	function BeginState()
	{
		// Set Camera Mode
		CameraFixedBehind = false;
		
		if ( GetAnimGroup(AnimSequence) == 'Swimming' )
		{
			if (Velocity.Z > 0)
			{
			bJustJumpedOutOfWater=true;
			TweenToFlyingUp(0.1);
			}
			else
			TweenToFallingDown(0.1);
		}
		
		SetPhysics(PHYS_Falling);
	}
}

// Alternate firing control tests
//
// The player wants to fire.
exec function Fire( optional float F )
{
	if (bShowTutorial)
	{
		TutorialEnd();
		return;
	}

	// Conversation - Trap the fire button?
	if (JazzHUD(MyHUD) != None)
	if (JazzHUD(MyHUD).ConversationTrapButton())
		return;
	
	// Intro - Trap the fire button?
	if (JazzIntroHUD(MyHUD) != None)
	if (JazzIntroHUD(MyHUD).InterceptButton())
		return;
		
	if( bShowMenu || bShowInventory || Level.Pauser!="" )
		return;

	// Activate an object in front of the player	
	if (MyActivationIcon != None)
	if (MyActivationIcon.Focus != None)
	{
		MyActivationIcon.DoActivate();
		return;
	}

		
	// Check Weapon Cell Inventory Slot (0)
	if (InventorySelections[0] != None)
	{
		Weapon.bPointing = true;
		JazzWeaponCell(InventorySelections[0]).Fire(F);
		PlayFiring();
	}
}

// The player wants to alternate-fire.
exec function AltFire( optional float F )
{
	if (bShowTutorial)
	{
		TutorialEnd();
		return;
	}
	
	// Conversation - Trap the fire button?
	if (JazzHUD(MyHUD) != None)
	if (JazzHUD(MyHUD).ConversationTrapButton())
		return;

	// Intro - Trap the fire button?
	if (JazzIntroHUD(MyHUD) != None)
	if (JazzIntroHUD(MyHUD).InterceptButton())
		return;
	
	if( bShowMenu || bShowInventory || Level.Pauser!="" )
		return;

	// Check Weapon Cell Inventory Slot (0)
	if (InventorySelections[0] == None)
		JazzWeapon(Weapon).ChangeCell(0);
		
	if (InventorySelections[0] != None)
	{
		Weapon.bPointing = true;
		JazzWeaponCell(InventorySelections[0]).AltFire(F);
		PlayFiring();
	}
}

// Abruptly ends all firing processes.  You must halt or change the animation manually as you see fit.
//
function AbruptFireHalt ()
{
	bFire 		= 0;
	bAltFire 	= 0;
//	bLeft 		= 0;
//	bRight 		= 0;
	
	// Check Weapon Cell Inventory Slot (0)
	if (InventorySelections[0] == None)
	{
		Weapon.GotoState('Idle');
	}
	else
	{
		JazzWeaponCell(InventorySelections[0]).GotoState('Idle');
	}
}


///////////////////////////////////////
// Swimming
// Player movement.
// Player Swimming
state PlayerSwimming
{
ignores SeePlayer, HearNoise, Bump;

	function Landed(vector HitNormal)
	{
		PlayLanded(Velocity.Z);
		if (Velocity.Z < -1.2 * JumpZ)
		{
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
			if (Velocity.Z <= -1100)
			{
				if ( (Velocity.Z < -2000) && (ReducedDamageType != 'All') )
				{
					health = -1000; //make sure gibs
					Died(None, 'fell', Location);
				}
				else if ( Role == ROLE_Authority )
					TakeDamage(-0.1 * (Velocity.Z + 1050), Self, Location, vect(0,0,0), 'fell');
			}
		}
		else if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.5 * JumpZ) )
			MakeNoise(0.1 * Level.Game.Difficulty);				
		bJustLanded = true;
		if ( Region.Zone.bWaterZone )
			SetPhysics(PHYS_Swimming);
		else
		{
			GotoState('PlayerWalking');
			AnimEnd();
		}
	}

	function SwimAnimUpdate(bool bNotForward)
	{
		if ( !bAnimTransition && (GetAnimGroup(AnimSequence) != 'Gesture') )
		{
			if ( bNotForward )
		 	{
			 	 if ( GetAnimGroup(AnimSequence) != 'Waiting' )
					TweenToSwimming(0.1);
			}
			else if ( GetAnimGroup(AnimSequence) == 'Waiting' )
				TweenToSwimming(0.1);
		}
	}

	function AnimEnd()
	{
		local vector X,Y,Z;
		GetAxes(Rotation, X,Y,Z);
		if ( (Acceleration Dot X) <= 0 )
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToTreading(0.2);
			} 
			else
				PlayTreading();
		}	
		else
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToSwimming(0.2);
			} 
			else
				PlaySwimming();
		}
	}
	
	function ZoneChange( ZoneInfo NewZone )
	{
		local actor HitActor;
		local vector NewLocation,HitLocation, HitNormal, checkpoint;

		if (!NewZone.bWaterZone)
		{
			SetPhysics(PHYS_Falling);

			if ((SwimmingJumpDuration>MaxSwimmingJumpDuration*0.8))
			{
				// Do A Jump out of the water (It works now)
				SetPhysics(PHYS_Falling);
				
				Velocity.Z = JumpZ*0.8;
				
				DoubleJumpReadyTime = 1.5;
				DoubleJumpDelayTime = 0.5;
				PlayInAir();
				GotoState('PlayerWalking');
			}
			else
			if (!FootRegion.Zone.bWaterZone || (Velocity.Z > 160) )
			{
				GotoState('PlayerWalking');
				AnimEnd();
			}
			else //check if in deep water
			{
				checkpoint = Location;
				checkpoint.Z -= (CollisionHeight + 6.0);
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, false);
				if (HitActor != None)
				{
					GotoState('PlayerWalking');
					AnimEnd();
				}
				else
				{
					Enable('Timer');
					SetTimer(0.7,false);
				}
			}
		}
		else
		{
			Disable('Timer');
			SetPhysics(PHYS_Swimming);
		}
	}

	// Redo update rotation to remove view up/down motion.
	//
	function UpdateRotation(float DeltaTime, float maxPitch)
	{
		local rotator newRotation;
		
		DesiredRotation = ViewRotation; //save old rotation
		
		// Remove viewrotation up/down
		//
		ViewRotation.Pitch += 8.0 * DeltaTime * aLookUp;
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		If ((ViewRotation.Pitch > 16000) && (ViewRotation.Pitch < 53152))
		{
			If (aLookUp > 0) 
				ViewRotation.Pitch = 16000;
			else
				ViewRotation.Pitch = 53152;
		}
	
		ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
		ViewShake(deltaTime);
		ViewFlash(deltaTime);
		
		newRotation = Rotation;
		newRotation.Yaw = ViewRotation.Yaw;
		newRotation.Pitch = ViewRotation.Pitch;
		If ( (newRotation.Pitch > maxPitch * RotationRate.Pitch) && (newRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
		{
			If (ViewRotation.Pitch < 32768) 
				newRotation.Pitch = maxPitch * RotationRate.Pitch;
			else
				newRotation.Pitch = 65536 - maxPitch * RotationRate.Pitch;
		}
		setRotation(newRotation);
	}

	// Trace to vector V and see if anything is in the way.
	//
	function float WaterSurfaceDistance( )
	{
		local vector 	HitLocation,HitNormal;
		local actor 	Result;
		local bool		ActorFound;
		local float		NewDist;
	
		Result = Trace( HitLocation, HitNormal, Location + vect(0,0,1000), Location );


		//Log("SurfaceDistance) "$Result$" "$VSize(HitLocation-Location));
		
		return (VSize(HitLocation - Location));
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		local vector X,Y,Z, Temp;

		GetAxes(ViewRotation,X,Y,Z);
		Acceleration = NewAccel;

		// Buoyancy
		//Velocity.Z += 3;

		//WaterSurfaceDistance();

		if ( !bAnimTransition && (GetAnimGroup(AnimSequence) != 'Gesture') )
		{
			if ((X Dot Acceleration) <= 0)
	 		{
		 		 if ( GetAnimGroup(AnimSequence) != 'Swimming' )
					TweenToSwimming(0.1);
			}
			else if ( GetAnimGroup(AnimSequence) == 'Waiting' )
				TweenToSwimming(0.1);
		}
		bUpAndOut = ((X Dot Acceleration) > 0) && ((Acceleration.Z > 0) || (ViewRotation.Pitch > 2048));
		if ( bUpAndOut && !Region.Zone.bWaterZone && 
		/*CheckWaterJump(Temp) &&*/
			(bPressedJump || (SwimmingJumpDuration>0)) ) //check for waterjump
		{
			//velocity.Z = 330 + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
			/*velocity.Z = JumpZ; //set here so physics uses this for remainder of tick
			PlayDuck();
			GotoState('PlayerWalking');
			bPressedJump = false;
			SwimmingJumpDuration = 0;*/
		}
		else
		if (bPressedJump)
		{
			Velocity.Z += 500;
			SwimmingJumpDuration = MaxSwimmingJumpDuration;
		}
		else
		if (SwimmingJumpDuration>0)
		{
			SwimmingJumpDuration-=DeltaTime;
			Velocity.Z = 300*(SwimmingJumpDuration/MaxSwimmingJumpDuration);
		}
	}

	event PlayerTick( float DeltaTime )
	{
		Global.PlayerTick(DeltaTime);
	
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
		
		// Generate Bubbles
		GenerateBubbles(DeltaTime);
	}
	
	function GenerateBubbles ( float DeltaTime )
	{
		local vector NewLocation;
		if (FRand()-(abs(Velocity.Z)/200) < 0.05)
		{
			NewLocation = Location + VRand()*FRand()*50;
			spawn(class'WaterBubble',,,NewLocation);
		}
	}
	

	function PlayerMove(float DeltaTime)
	{
		local rotator oldRotation;
		local vector X,Y,Z, NewAccel;
		local float Speed2D;
	
		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.2;
//		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;

		// Check for distance from top of the water and adjust buoyancy
		NewAccel = aForward*X + aUp*vect(0,0,1);
	
		//add bobbing when swimming
		if ( !bShowMenu )
		{
			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * Level.TimeSeconds);
			WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * Level.TimeSeconds);
		}

		//SwimAnimUpdate();		// 220 Change

		// Update rotation.
		oldRotation = Rotation;
		UpdateRotation(DeltaTime, 2);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
			
		bPressedJump = false;
	}

	function Timer()
	{
		if ( !Region.Zone.bWaterZone && (Role == ROLE_Authority) )
		{
			GotoState('PlayerWalking');
			AnimEnd();
		}
	
		Disable('Timer');
	}
	
	function BeginState()
	{
		local rotator NewRotation;
	
		// Set Camera Mode
		CameraFixedBehind = true;
			
		Disable('Timer');
		if ( !IsAnimating() )
			TweenToWaiting(0.3);
			
		SwimmingJumpDuration = 0;
		DashTime = 0;
		NewRotation = Rotation;
		NewRotation.Yaw = NewRotation.Yaw & 65535;
		SetRotation(NewRotation);
		ViewRotation.Yaw = ViewRotation.Yaw & 65535;
	}
	
	function EndState ()
	{
		BasePlayerFacing.Yaw = Rotation.Yaw & 65535;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// RideVehicle
//
state RideVehicle
{

	event ForwardCheck()
	{
		local vector	HitLocation,HitNormal;
		local actor 	A;
		local int		NewDist;
	
		A = Trace( HitLocation, HitNormal, 
			Location + 80 * Velocity, Location );

		NewDist = VSize(Location - HitLocation);
	
		// Touching Forward Wall
		if (NewDist < 80)
		{
		Vehicle.HandleBumpForward();
		}
	}

	function PlayerTick ( float DeltaTime )
	{
		Global.PlayerTick( DeltaTime );
	
		PlayerMove(DeltaTime);

		// Check if something is rather close in motion direction
		if (Vehicle.BumpForwardCheck) 	ForwardCheck();	
	}
	
	function ForceHover ()
	{
		local vector View,HitLocation,HitNormal,NewLocation;
		local rotator CheckRotation;
		local float Distance;
	
		// Make sure above surface sufficiently
		//
		CheckRotation.Pitch = 65536/4;
		View = vect(1,0,0) >> CheckRotation;
		if( Trace( HitLocation, HitNormal, Location - 100 * vector(CheckRotation), Location ) != None )
			Distance = (Location - HitLocation) Dot View;
			
		//Log("JazzPlayer) Distance "$Distance);
		if (Distance < 50)
		{
		NewLocation = Location;
		NewLocation.Z += 50-Distance;
		}
	}
	
	event PreRender( canvas Canvas )
	{
		Vehicle.AcceptPlayerRotation(Rotation);			// Move to prerender
		Vehicle.AcceptVehicleLocation(Location,Rotation);
		Super.PreRender(Canvas);
	}
	
	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local vector OldAccel,VelocityChange,NewVelocity;
		local float OldVelocityKeep,OldVelocityChangeKeep;

		OldAccel = Acceleration;
		Acceleration += NewAccel;
		
		//Acceleration.Z -= 1000;
		
		//Log("VehicleA) "$Acceleration$" "$Velocity$" "$Physics);
		Vehicle.FilterSpeed(Acceleration,Velocity,DeltaTime);
		//Log("VehicleB) "$Acceleration$" "$Velocity$" "$Physics);
		
		// SpecialMotion button handling for vehicles
		// This is not used anymore
		/*if (aStrafe>0)
		{
			Vehicle.PlayerPressedSpecialMotion( SpecialMotionHeldTime );
			SpecialMotionHeldTime += DeltaTime;
		}
		else
			SpecialMotionHeldTime = 0;*/

		// JAZZ3 : This is the code that allows some motion at any time.
		if (Physics == PHYS_Walking)
		{

		// Override Velocity System
		NewVelocity = Velocity;
		VelocityChange = Velocity - VelocityHistory;
		Velocity = (NewAccel * DeltaTime * 0.5) + Vehicle.FilterVelocityHistory(VelocityHistory,DeltaTime);
		Velocity.Z = NewVelocity.Z;
		}
		
		/*if ((Physics != PHYS_Walking) && (Vehicle.FlyingVehicle == true))
		{
		// Override Velocity System
		NewVelocity = Velocity;
		VelocityChange = Velocity - VelocityHistory;
		Velocity = (NewAccel * DeltaTime * 0.5) + Vehicle.FilterVelocityHistory(VelocityHistory,DeltaTime);
		}*/
		
		//Acceleration.Y += 100;
		//Velocity.Y += 100;
		
		if (VehicleBounce)
		{
		Velocity.Z = Vehicle.FilterBounce(VelocityHistory.Z);
		if (Velocity.Z > 10) SetPhysics(Vehicle.FallingPhysics);
		VehicleBounce = false;
		}
		
		VelocityHistory = Velocity;
		
		//Log("JazzPlayerVehicle) Velocity:"$Velocity$" "$NewVelocity);
		
		bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );

		// Jump Handling
		//
		if ( bPressedJump )
		{
			Vehicle.PlayerPressedJump();
		}
		//bPressedJump = false;
	}
	
	// Redo update rotation to remove view up/down motion.
	//
	function UpdateRotation(float DeltaTime, float maxPitch)
	{
		if (!Vehicle.Rotate360)
		{
			Global.UpdateRotation(DeltaTime,maxPitch);
		}
	}

	function ClientSetRotation( rotator NewRotation )
	{
		ViewRotation      = NewRotation;
	}
	
	event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
	{
	local vector View,HitLocation,HitNormal;
	local float ViewDist, WallOutDist, TargetYaw, TargetPitch, DeltaTime;
	local vector ResultLocation;

	Global.PlayerCalcView(ViewActor,CameraLocation,CameraRotation);
	return;

	if ( ViewTarget != None )
	{
		ViewActor = ViewTarget;
		CameraLocation = ViewTarget.Location;
		CameraRotation = ViewTarget.Rotation;
		if ( Pawn(ViewTarget) != None )
		{
			if ( (Level.NetMode == NM_StandAlone) 
				&& (ViewTarget.IsA('PlayerPawn') || ViewTarget.IsA('Bot')) )
					CameraRotation = Pawn(ViewTarget).ViewRotation;

			CameraLocation.Z += Pawn(ViewTarget).EyeHeight;
		}

		return;
	}

	// View rotation.
	ViewActor = Self;
	CameraRotation = ViewRotation;

	if( bBehindView ) //up and behind
	{
	    ViewDist    = 200;
		WallOutDist = 60;

		View = vect(1,0,0) >> CameraRotation;
		//ResultLocation = 
		
		if( Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location ) != None )
			ViewDist = FMin( (Location - HitLocation) Dot View, ViewDist );
		CameraLocation -= (ViewDist - WallOutDist) * View;
	}
	else
	{
		// First-person view.
		CameraLocation = Location;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
	}
	}

	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		local vector NewLocation;

		// Flying vehicle check
		if ((Physics == Vehicle.FallingPhysics) && (Vehicle.FlyingVehicle == true))
		{
			//SetPhysics(PHYS_Flying);
			Velocity = VelocityHistory;
		}


		aForward *= 0.4;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		
		aForward = Vehicle.FilterForwardBack(aForward,DeltaTime);
		aTurn = Vehicle.FilterTurn(aTurn,DeltaTime);
		
		// Update acceleration.
		if (Vehicle.Rotate360)
		{
		//NewAccel = aForward*X;
		//GetAxes(ViewRotation,X,Y,Z);
		NewAccel = vector(ViewRotation)*aForward;
		}
		else
		{
		GetAxes(Rotation,X,Y,Z);
		NewAccel = aForward*X + aStrafe*Y;
		}
		
		//NewAccel.Z = 0;		// CHANGED - IS THIS OK?
		
		//Log("JazzPlayerVehicle) Acceleration:"$NewAccel);
		
/*		if ( (Physics == PHYS_Walking) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bSnapToLevel )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;	
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);

		}	
		else if ( !bShowMenu )
		{ 
		}*/

		// Update rotation.
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
			
		bPressedJump = false;
	}

	
	function ValidVehicle ()
	{
		if (Vehicle == None)
		{
			ReturnToNormalState();
		}
	}
	
	function Landed(vector HitNormal)
	{
		VehicleBounce = true;		// Register that the vehicle will now bounce in ProcessMove

		AnimEnd();	
		SetPhysics(Vehicle.NormalPhysics);
	}
	
	function ZoneChange( ZoneInfo NewZone )
	{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint;

		if (!NewZone.bWaterZone)
		{
			SetPhysics(Vehicle.FallingPhysics);
			//if (bUpAndOut && CheckWaterJump(HitNormal)) //check for waterjump
			if (bUpAndOut)
			{
				velocity.Z = JumpZ + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
				PlayDuck();
				//DoJump();
				DoubleJumpReadyTime = 1.5;
				DoubleJumpDelayTime = 0.5;
				ReturnToNormalState();
			}				
			else if (!FootRegion.Zone.bWaterZone || (Velocity.Z > 160) )
			{
				GotoState('PlayerWalking');
				AnimEnd();
			}
			else //check if in deep water
			{
				checkpoint = Location;
				checkpoint.Z -= (CollisionHeight + 6.0);
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, false);
				if (HitActor != None)
				{
					GotoState('PlayerWalking');
					AnimEnd();
				}
				else
				{
					Enable('Timer');
					SetTimer(0.7,false);
				}
			}
		}
		else
		{
			Disable('Timer');
			SetPhysics(PHYS_Swimming);
		}
	}
	
	function BeginState ()
	{
		// Set Camera Mode
		CameraFixedBehind = false;	// Override later with vehicle-specific camera
		AirSpeed = Vehicle.GroundSpeed;
		GroundSpeed = Vehicle.GroundSpeed;
		
		DashTime = 0;
		SetPhysics(Vehicle.NormalPhysics);
	}
	
	function EndState ()
	{
		GroundSpeed = DefaultGroundSpeed;
		VelocityHistory = vect(0,0,0);
		
		// Cool Effect :)
		DashTime = 3;
	}
	
	function AnimEnd()
	{
		local int Vel;
		
		if ((Physics == Vehicle.NormalPhysics) && (Vehicle.bAllowPlayerWalkAnimation))
		{
		Vel = VSize(Velocity);
		
		if ((Vel>200) || (Vel<-200))
		PlayRunning();
		else
		if ((Vel>10) || (Vel<-10))
		PlayWalking();
		}
		else
		{
		PlayWaiting();
		//TweenAnim('Breath1L',0.3);
		//PlayAnim('Breath1L');
		}
	}

Begin:
	// Prepare Initial Motion
	bPressedJump = false;
	
	AnimEnd();
		
	DefaultGroundSpeed = GroundSpeed;
	GroundSpeed = Vehicle.GroundSpeed;
	ValidVehicle();
}


//////////////////////////
// Vehicle Exit
//
function LeaveVehicle()
{
	// Return Rider to Normal
	Vehicle = None;
		
	// If in a water zone currently, swim, otherwise goto walking and act from there.
	ReturnToNormalState();
}


///////////////////////////////////////////////////////////////////////////////////////////////
// Player Inventory															INVENTORY
///////////////////////////////////////////////////////////////////////////////////////////////
//
replication
{
	reliable if( Role<ROLE_Authority )
		InventoryMenu,NewInventoryItem;
}

exec function InventoryMenu()
{
	//Log("Entering Inventory Menu) HUD Type "$myHUD);
	JazzHUD(myHUD).DoInventoryMenu();
}

// New JazzInventoryItem Found
//
event NewInventoryItem()
{
	JazzHUD(myHUD).NewInventoryItem();
}

function SetInventorySelection( int Group, Inventory Inv )
{
	if (Group==0)	// Weapon Cell Selection
	{
	DeSelectCurrentWeapon();
	if (JazzWeapon(Inv) != None)
		InventorySelections[Group]=None;
		else
		InventorySelections[Group]=Inv;
	SelectCurrentWeapon();
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////
// Player Inventory															INVENTORY
///////////////////////////////////////////////////////////////////////////////////////////////
//
function AddScore(int ScoreAdd)
{
	if (ScoreAdd != 0)
	{
	//Score += ScoreAdd;		// 220 Change
	JazzHUD(MyHUD).UpdateScore();
	}
}

function ChangeLives(int LifeAdd,optional int LifeTo)
{
//	Log("ChangeLives) "$LifeAdd$" "$LifeTo);

	JazzHUD(MyHUD).UpdateComponent(7,20);
	
	if (LifeTo>0)
	{
		Lives = LifeTo;
	}
	else
	{
		Lives += LifeTo;
	}
}

// Weapon Powerup (Add an entire level(s))
//
function AddPowerLevel()
{
	//Log("JazzPlayer) Add Power Level "$Weapon);
	JazzWeapon(Weapon).AddPowerLevel();
}

// Weapon Experience Increase
// 
function AddWeaponExperience( int XP )
{
	JazzWeapon(Weapon).AddWeaponExperience(XP);
	JazzHUD(MyHUD).UpdateWeaponExperience();
}

// Food Eaten
//
function EatFood( bool Poison )
{
	if (Poison==true)
	VoicePackActor.DoSound(Self,VoicePackActor.Poisoned);
	else
	VoicePackActor.DoSound(Self,VoicePackActor.EatSomething);
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Weapon Selection
//////////////////////////////////////////////////////////////////////////////////////////////	
//
// Switch to next weapon
//
exec function NextWeapon()
{
	JazzWeapon(Weapon).ChangeWeapon(1);
}

// Switch to previous weapon
//
exec function PrevWeapon()
{
	JazzWeapon(Weapon).ChangeWeapon(-1);
}

// Switch to next weapon
//
exec function NextCell()
{
	JazzWeapon(Weapon).ChangeCell(1);
}

// Switch to previous weapon
//
exec function PrevCell()
{
	JazzWeapon(Weapon).ChangeCell(-1);
}

// Tell Current Weapon It Is Being Deselected
//
function DeSelectCurrentWeapon()
{
	if (InventorySelections[0] == None)
		JazzWeapon(Weapon).DeSelectWeapon();
	else
		JazzWeaponCell(InventorySelections[0]).DeSelectWeapon();
}

// Tell Current Weapon It Is Being Selected
//
function SelectCurrentWeapon()
{
	if (InventorySelections[0] == None)
		JazzWeapon(Weapon).SelectWeapon();
	else
		JazzWeaponCell(InventorySelections[0]).SelectWeapon();
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// HUD Displays															HUD COMMANDS
//////////////////////////////////////////////////////////////////////////////////////////////	
//
function UpdateCarrot()	// Money
{
	//Log("UPDATECARROTS)");
	JazzHUD(MyHUD).UpdateCarrots();
}
function UpdateKeys()
{
}
function AddHealth( int AddHealth )
{
	if (AddHealth != 0)
	{
	JazzHUD(MyHUD).UpdateHealth();
	Health += AddHealth;
	if (Health > HealthMaximum)	Health = HealthMaximum;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////
// Player Input																INPUT
///////////////////////////////////////////////////////////////////////////////////////////////
//
// Override PlayerInput to add support for mini-menus like the input display.
//
event PlayerInput( float DeltaTime )
{
	local float SmoothTime, MouseScale;
	//local bool  JazzWindowsHasControl;
	
	if (( (bShowMenu) && (myHud != None) ) || (bShowTutorial))
	{
		if ((bShowMenu) && ( myHud.MainMenu != None ))
		{
			myHud.MainMenu.MenuTick( DeltaTime );
		}
		else
		if (bShowTutorial)
		{
			JazzHud(myHud).TutorialTick( DeltaTime );
		}
		
		// clear inputs
		bEdgeForward = false;
		bEdgeBack = false;
		bEdgeLeft = false;
		bEdgeRight = false;
		bWasForward = false;
		bWasBack = false;
		bWasLeft = false;
		bWasRight = false;
		aStrafe = 0;
		aTurn = 0;
		aForward = 0;
		aLookUp = 0;
		return;
	}
	else if ( bDelayedCommand )
	{
		bDelayedCommand = false;
		ConsoleCommand(DelayedCommand);
	}
				
	// Check for Dodge move
	bEdgeForward = (bWasForward ^^ (aBaseY > 0));
	bEdgeBack = (bWasBack ^^ (aBaseY < 0));
	bEdgeLeft = (bWasLeft ^^ (aBaseX < 0));
	bEdgeRight = (bWasRight ^^ (aBaseX > 0));
	bWasForward = (aBaseY > 0);
	bWasBack = (aBaseY < 0);
	bWasLeft = (aStrafe > 0);
	bWasRight = (aStrafe < 0);
	
	if (aLookUp != 0)
		bKeyboardLook = true;
	if (bSnapLevel != 0)
		bKeyboardLook = false;


	// Smooth and amplify mouse movement
	SmoothTime = FMin(0.2, 3 * DeltaTime);
	MouseScale = MouseSensitivity * DesiredFOV * 0.0111;
	aMouseX = aMouseX * MouseScale;
	aMouseY = aMouseY * MouseScale;

	if ( (SmoothMouseX == 0) || (aMouseX == 0) 
			|| ((SmoothMouseX > 0) != (aMouseX > 0)) )
		SmoothMouseX = aMouseX;
	else if ( (SmoothMouseX < 0.85 * aMouseX) || (SmoothMouseX > 1.17 * aMouseX) )
		SmoothMouseX = 5 * SmoothTime * aMouseX + (1 - 5 * SmoothTime) * SmoothMouseX;
	else
		SmoothMouseX = SmoothTime * aMouseX + (1 - SmoothTime) * SmoothMouseX;

	if ( (SmoothMouseY == 0) || (aMouseY == 0) 
			|| ((SmoothMouseY > 0) != (aMouseY > 0)) )
		SmoothMouseY = aMouseY;
	else if ( (SmoothMouseY < 0.85 * aMouseY) || (SmoothMouseY > 1.17 * aMouseY) )
		SmoothMouseY = 5 * SmoothTime * aMouseY + (1 - 5 * SmoothTime) * SmoothMouseY;
	else
		SmoothMouseY = SmoothTime * aMouseY + (1 - SmoothTime) * SmoothMouseY;

	aMouseX = 0;
	aMouseY = 0;

	// Does JazzWindow system have mouse control?
	//
/*	JazzWindowsHasControl = false;
	if (WindowsMain != None)
		if (WindowsMain.bHasControl == true)
			JazzWindowsHasControl = true;*/

	// Handle Firing
	//if ((bLeft>0) && (bFire==0))			Fire();
	//if ((bRight>0) && (bAltFire==0))		AltFire();
	//Log("Player buttons "$bFire$" "$bAltFire$" Left:"$bLeft$" Right:"$bRight);

	// Remap raw x-axis movement.
	if( bStrafe!=0 )
	{
		// Strafe.
		aStrafe += aBaseX + SmoothMouseX;
		aBaseX   = 0;
	}
	else
	{
		// Forward.
		aTurn  += aBaseX + SmoothMouseX;
		aBaseX  = 0;
	}
	// Remap mouse y-axis movement.
	if( bAlwaysMouseLook || (bLook!=0) )
	{
		// Look up/down.
		bKeyboardLook = false;
		if ( bInvertMouse )
			aLookUp -= SmoothMouseY;
		else
			aLookUp += SmoothMouseY;
	}
	else
	{
		// Move forward/backward.
		aForward += SmoothMouseY;
	}

	// Remap other y-axis movement.
	aForward += aBaseY;
	aBaseY    = 0;

	// Handle walking.
	HandleWalking();

	// Inventory Menu Input
	if (JazzHUD(myHud) != None)
	JazzHUD(myHud).UpdateInventoryTick(DeltaTime);
	
	if (bShowInventory)
	{
		// clear inputs
		bEdgeForward = false;
		bEdgeBack = false;
		bEdgeLeft = false;
		bEdgeRight = false;
		bWasForward = false;
		bWasBack = false;
		bWasLeft = false;
		bWasRight = false;
		bPressedJump = false;
		aStrafe = 0;
		aTurn = 0;
		aForward = 0;
		aLookUp = 0;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////
// UnrealL Menu Overrides													INVENTORY
///////////////////////////////////////////////////////////////////////////////////////////////
//
exec function ShowLoadMenu()
{
	//Log("DeadMenu) Initialize");
	if (JazzGameInfo(Level.Game).SinglePlayerGame==true)
	{
		bSpecialMenu = true;
		SpecialMenu = class'JazzDeadMenu';
		ShowMenu();
	}
	else
	{
		ServerRestartPlayer();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Tutorial System															TUTORIAL
///////////////////////////////////////////////////////////////////////////////////////////////
//
// Every time some event happens in Jazz which corresponds to a tutorial #, that event should
// send a call to EventNum to see if this event has been handled before.  If not, the correct
// tutorial actor is called (JazzTutorial.u) to display the new information.
//
function TutorialCheck ( TutorialNumType EventNum )
{
	//Log("TutorialCheck) "$EventNum$" "$Tutorial[EventNum]);

	if (TutorialActive)		// Tutorials on?
	{
		if (Tutorial[EventNum] == 0)
		{
			JazzHUD(MyHUD).NewTutorial(TutorialText[EventNum],TutorialTitle[EventNum]);
			//JazzHUD(MyHUD).NewTutorial(TutorialText[1]);
			Tutorial[EventNum]++;
		}
	}
}

function NewTutorial ( string Text, string Title, optional bool Centered )
{
	JazzHUD(MyHUD).NewTutorial(Text,Title,Centered);
}
//
//
function DoEvent ( int Type, float Duration, string Message )
{
	JazzHUD(MyHUD).AddEvent(Type,Duration,Message);
}

// New Tutorial
//
//function NewExternalTutorialMessage ( TutorialDisplay Instigator, string TutorialDesc )
//{
	//JazzHUD(MyHUD).AddEvent(0,20,"Tutorial");
	//LastTutorialActor = Instigator;
//}

function TutorialEnd()
{
	JazzHUD(myHUD).TutorialEnd();
}

//
//
exec function ActivateHelp ( )
{
	// No longer in use

	//local TutorialDisplay T;
	
	//Log("ActivateHelp");
	
	// First check if an In-Level tutorial is desiring to be displayed.  Otherwise go ahead and check for the last 
	// tutorial library # to display.
	//
	/*if (LastTutorialActor != None)
	{
		TutorialWindow.DoTutorial(Self,LastTutorialActor);
	}
	else
	if (LastTutorial>-1)
	{
		if (TutorialDisp[LastTutorial] != None)
		{
			T = spawn(TutorialDisp[LastTutorial]);
			T.DoTutorial(Self);
			T.Destroy();
		}
	}*/
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Multiplayer Handling														MULTIPLAYER
///////////////////////////////////////////////////////////////////////////////////////////////
//
state TreasureHuntFinish
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, TakeDamage;

	function BeginState()
	{
		bShowScores = true;
		SetPhysics(PHYS_None);
		/*
		THPlayerReplicationInfo(PlayerReplicationInfo).TreasureTime = TreasureHunt(Level.Game).GameTime;
		THPlayerReplicationInfo(PlayerReplicationInfo).TreasureFinish = true;
		*/
		HidePlayer();
	}
}

function PickUpFlag(CTFFlag Flag)
{
	bHasFlag = true;
	TeamFlag = Flag;
}

function GainLeader(float DrawScaleChange, float JumpZChange, bool bTLand)
{
	// Duration of effect
	LeaderGrowEffectTime = 2;

	// We are now the leader, do stuff
	OriginalScale = Default.DrawScale;
	LeaderDesiredScale = Default.DrawScale * DrawScaleChange;
	
	JumpZ *= JumpZChange;
	bThunderLand = bTLand;
	bLeader = true;
}

function LeaderEffectTick ( float DeltaTime )
{
	local float ScaleDelta;
	local float LeaderDelta;

	LeaderGrowEffectTime -= DeltaTime;
	ScaleDelta = LeaderDesiredScale - DrawScale;
	
	LeaderDelta = LeaderGrowEffectTime/2;
	
	if (bLeader==true)
	{
		// Effect To Leader
		DrawScale = OriginalScale + ScaleDelta*(1-LeaderDelta);
	}
	else
	{
		// Effect away from Leader
		DrawScale = OriginalScale + ScaleDelta*(LeaderDelta);
	}
	
	Style = STY_Translucent;
	ScaleGlow = abs(LeaderGrowEffectTime-1);
	
	// Return to normal when done
	if (LeaderGrowEffectTime<0)
	{
		Style = STY_Normal;
		ScaleGlow = 1;
		if (bLeader==true)
		{
		DrawScale = LeaderDesiredScale;
		}
		else
		{
		DrawScale = OriginalScale;
		}
	}

	SetCollisionSize(default.CollisionRadius*(DrawScale/OriginalScale), 
					 default.CollisionHeight*(DrawScale/OriginalScale));
}

function LoseLeader()
{
	// Duration of effect
	LeaderGrowEffectTime = 2;

	// We lost the leader status
	JumpZ = default.JumpZ;
	bThunderLand = default.bThunderLand;
	bLeader = false;
}

simulated function ThunderLandToss(vector TLLocation)
{
	local float dist, shake;
	local PlayerPawn aPlayer;
	local vector Momentum;


	dist = VSize(TLLocation - Location);
	shake = FMax(500, 1500 - dist);
	ShakeView( FMax(0, 0.35 - dist/20000), shake, 0.015 * shake);
	if ( Physics != PHYS_Walking )
		return;

	Momentum = -0.5 * Velocity + 100 * VRand();
	Momentum.Z =  7000000.0/((0.4 * dist + 350) * Mass);
	AddVelocity(Momentum);
}

function BecomeSpectator()
{
	GotoState('Spectate');
}

function LeaveSpectator()
{
	GotoState('Dying');
}

// Use for entering games before joining a team
state Spectate
{
	// Over-ride all movement and firing functions for now
	// Only leave mouse/menu for selecting team/player info

	event FootZoneChange(ZoneInfo newFootZone);
	event HeadZoneChange(ZoneInfo newHeadZone);
	exec function BehindView( Bool B );
	exec function Walk();
	function AnimEnd();
	exec function Grab();	
	function ServerChangeSkin(coerce string SkinName, coerce string FaceName, byte TeamNum);	
	exec function SwitchWeapon (byte F );
	exec function NextItem();
	exec function PrevItem();
	exec function ActivateItem();	
	
	exec function TeamChange(int n)
	{
		ChangeTeam(N);
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		Acceleration = NewAccel;
		MoveSmooth(Acceleration * DeltaTime);

		if (bPressedJump)		
		ViewClass(class'Pawn');
	}

	function Timer()
	{
		bFrozen = false;
		//bShowScores = true;	// TODO: Remove because it is annoying.  Add something else back in to show scores and not remove team select message.
		bPressedJump = false;
	}
	
	function ShowTeamMenu()
	{
		ShowMenu();
	}

	event PlayerTick( float DeltaTime )
	{
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator newRotation;
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;
	
		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);  

		UpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}

	function BeginState()
	{
		EyeHeight = BaseEyeHeight;
		SetPhysics(PHYS_None);
		self.Mesh = None;
		self.SetCollision(false,false,false);
		bCollideWorld = true;		
		if  ( !IsAnimating() ) PlaySwimming();
		// log("cheat flying");
	}
	
	function ClientReStart()
	{
		//log("client restart");
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		BaseEyeHeight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
	}
	
	function PlayerTimeOut()
	{
		if (Health > 0)
			Died(None, 'dropped', Location);
	}
	
	// Send a message to all players.
	exec function Say( string S )
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
	}
	
	//=============================================================================
	// Inventory-related input notifications.
	
	// The player wants to switch to weapon group numer I.
	
	exec function Fire( optional float F )
	{
		ShowTeamMenu();
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
	
	function EndState()
	{
		self.mesh = default.mesh;
		self.bBlockActors = default.bBlockActors;
		self.bBlockPlayers = default.bBlockPlayers;
		self.bCollideWorld = default.bCollideWorld;
		self.SetCollision(true,true,true);
		self.bProjTarget = self.bProjTarget;
		Viewtarget = None;
	}
}

// Change Team
function ChangeTeam( int N )
{
	Level.Game.ChangeTeam(self, N);
	
	if ( Level.Game.bTeamGame )
		Died( None, '', Location );
}

function ThunderLand()
{
	local Pawn aPawn;
	local actor Other;
	local jazzPlayer aJazz;
	local vector Momentum;
	local float dist;
	
	// Possibly change 'Pawn' to 'Actor' to throw decorations and the like
	foreach RadiusActors(class'Actor', Other, 1500)
	{
		if ( Other.mass > 500 )
			return;
			
		dist = VSize(Other.Location - Location);
		
		aJazz = jazzPlayer(Other);
		
		if ( aJazz != None )
		{	
			aJazz.ThunderLandToss(Location);
			return;
		}
		
		
		// Some checking will need to be done to see what should be thrown
		/*
		Momentum = -0.5 * Other.Velocity + 100 * VRand();
		Momentum.Z =  7000000.0/((0.4 * dist + 350) * Other.Mass);
		Momentum.Z *= 5.0;
		Other.Velocity += Momentum;
		*/
	}
}

function Died(pawn Killer, name damageType, vector HitLocation)
{
	local vector Vel;
	
	// Reset Weapon
	if (InventorySelections[0] != None)
	{
	JazzWeaponCell(InventorySelections[0]).ChargeEnd();
	JazzWeaponCell(InventorySelections[0]).GotoState('Idle');
	}
	
	/*if (Weapon == None)
	JazzWeapon(Weapon).ChangeWeapon(0);
	if (Weapon == None)
	JazzWeapon(Weapon).ChangeCell(0);*/
	
	if(bHasFlag)
	{
		Vel.X = (FRand()*1000)-500;
		Vel.Y = (FRand()*1000)-500;
	
		Vel.Z = (FRand()*500)+250;
	
		TeamFlag.GotoState('OnGround');
		
		TeamFlag.SetPhysics(PHYS_Falling);
		
		TeamFlag.Velocity = Vel;
	}

	bHasFlag = false;
	TeamFlag = none;
	Super.Died(Killer, damageType, HitLocation);	
}

// Handle In-Air Motion
//
function PlayInAir()
{
/*	Log("PlayInAir) "$Velocity.Z);
	if (Velocity.Z>0)
	{
	PlayFlyingUp();
	}
	else
	{
	PlayFallingDown();
	}*/
}

function PlayFlyingUp();
function PlayFallingDown();

function TweenToTreading(float tweentime);
function PlayTreading();

function TweenToFlyingUp(float tweentime);
function TweenToFallingDown(float tweentime);

//
// Multiplayer Messaging
//
event ClientMessage( coerce string S, optional name Type, optional bool bBeep )
{
	//Log("ClientMessage) "$S$" "$Type);
	
	//if (Type == 'DeathMessage') 		// Ignore Message
		//return;

	//Log("ClientMessage) >"$Type$"<");
	if (Type=='')
		return;

	if (JazzHUD(MyHUD) != None)	
	JazzHUD(MyHUD).AddEvent(1,10,S);
}

// Return to correct state
//
function ReturnToNormalState()
{
	if (Region.Zone.bWaterZone == true)
	{
		SetPhysics(PHYS_Swimming);
		GotoState('PlayerSwimming');
	}
	else
	{
		SetPhysics(PHYS_Falling);
		GotoState('PlayerWalking');
	}
}

// Running Animation
//
function PlayRunning()
{
	// Extract forward/backward motion and strafing.
	//
	// Any strafing motion should take precedence over forward/backward, generally
	// because it will be displayed less and his motion will seem more accurate,
	// probably.  Regardless, just whatever looks ok.
	//
	
	//Log("PlayRunning) "$OldaStrafe$" "$OldaForward);
	if (OldaStrafe != 0)	// Strafing
	{
		if (OldaStrafe<0)
		{
			PlayStrafeLeft();
		}
		else
		{
			PlayStrafeRight();
		}
	}
	else
	{
		if (OldaForward>0)
		{
			PlayRunForward();
		}
		else
		if (OldaForward<0)
		{
			PlayRunBackward();
		}
		else
		{
			PlayWaiting();
		}
	}
}

function UpdateRunning ()
{
	if ( GetAnimGroup(AnimSequence) == 'Running' )
	{
		if ((aForward != 0) || (aStrafe != 0))
		{
			if (Physics != PHYS_Falling)
			{
				OldRunContinue=true;
				PlayRunning();
				OldRunContinue=false;
			}
		}
	}
}

// Redefined and Separated Movement Animations
//
function PlayStrafeLeft();
function PlayStrafeRight();
function PlayRunForward();
function PlayRunBackward();

// Dying state
//
state Dying
{
	function Timer()
	{
		bFrozen = false;
		//bShowScores = true;	// TODO: Remove until 'Press Fire to Play' message is displayed ok.
		bPressedJump = false;
	}
}

defaultproperties
{
     FrozenTexture=Texture'JazzArt.NWater2'
     PetrifyTexture=Texture'JazzArt.NRock'
     PoisonTexture=Texture'JazzArt.Effects.NMurky'
     ManaAmmo=10.000000
     AirSpeed=800.000000
     PlayerReplicationInfoClass=Class'CalyGame.JazzPlayerReplicationInfo'
}
