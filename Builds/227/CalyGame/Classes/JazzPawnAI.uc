//=============================================================================
// JazzPawnAI.
//=============================================================================
//
// The JazzPawn AI is an independent self-capable system for Jazz character AI.
//
// Unreal AI should coexist peacefully with this and be independent.  The Jazz AI
// is intended to be a complete rewrite of the Unreal AI to be more intellegent in
// some ways and capable of simulating more various creature capabilities.  That 
// and most importantly be much easier for secondary programmers to utilize.
//
// JazzPawn contains various features and intrinsic physical characteristics of the
// pawn.
//
// JazzPawnAI contains the intelligence information and reaction code for the pawn
// to move about and the like.
//
//
class JazzPawnAI expands JazzPawn;

//
var vector 		StartLocation;
var bool		bStayClose;
var int			WanderRadius;
//
var bool		IgnoreAllDecisions;				// Special boolean to ignore all new stimuli
var float		InvulnerabilityTime;
var bool		StateBasedInvulnerability;		// Invulnerability to be used during a state.
												// Note: Recommend mix with IgnoreAllDecisions

// When we see the player (or another thinker [bot]) how should we react?
var(JMind)	enum	AttitudeVal {
ATT_Enemy,
ATT_Friendly,
ATT_Uncaring,
ATT_Protective,
ATT_Scared
} AttitudeVsPlayer;		// This actually represents the player team.

// If checking whether to be scared or not or whether to back off when attacking, how
// courageous is this character?
var(JMind)	enum	CourageVal {
COU_Mindless,
COU_Reactive,
COU_Timid,
COU_Strong,
COU_Terrified
} Courage;

// If we check for intelligence, what kind of intelligence should we return?
var(JMind)	enum	IntellectVal {
INT_Mindless,
INT_Instinct,
INT_Barbaric,
INT_Tactful
} Intelligence;

// If it has a projectile weapon or something, how aggressively does it use it?
var(JMind)	enum	TriggerVal {
INT_Pacifist,
INT_Moderate,
INT_Vicious,
INT_Insane
} TriggerHappy;
var			float	ReactionTime;	// Used by attack

// How does the character carry out it's normal day?
var(JMind) enum	WaitVal {
WAT_Motionless,
WAT_LoneWanderer,
WAT_Ambusher,
WAT_Groupie
} WaitStyle;

// If attacked, what kind of attack does the character use in response?
var(JMind) enum CombatVal {
COM_SniperTroop,
COM_Rusher,
COM_ThinkerCharlie
} CombatStyle;

var(JAttack) bool	StandPhysicalAttack;			// Hand to Hand capability
var(JAttack) bool	StandPhysicalFacing;			// Need to face forward to attack? 

var(JAttack) bool	RunPhysicalAttack;				//
var(JAttack) bool	RunPhysicalFacing;				// Need to face forward to attack? 

var(JAttack) bool	ProjAttack;						// Inherent physical projectile abilities (or pre-scripted ones that may be 'illogical' and not inherently based on the weapon system)
var(JAttack) class	ProjAttackType[5];				//
var(JAttack) byte	ProjAttackDesire[5];			//
var			 float	OptimalAttackStyle;
var			 float  CurrentAttackStyle;

// Base Advance/Retreat Range
/*var byte		StrongAdvanceDesire;					// Strong Forward
var byte		AdvanceDesire;							// Forward
var byte		NeutralDesire;							// Neutralize Distance / Stay
var byte		ReverseDesire;							// Move Away / Back Off
var byte		StrongReverseDesire;					// Move Back / Retreat*/

var byte		AttackMoves[5];							// # of Moves Available (Dependent on Intelligence and AI capability)

var byte	AmbushPointDesire;
var float	RushDuration;
var(JAttack) bool	AvoidLedgesWhenAttacking;
var(JAttack) bool	WarnFriendsWhenFirstAttacking;	// Special case - alert others of same type? - NOT IMPLEMENTED YET
//r(JAttack) sound	WarnFriendsSound;

var(Movement) float	WalkingSpeed;
var(Movement) float	RushSpeed;

var byte	FindFriendDesire;
var byte	WanderDesire;
var float	WanderRange;
var byte	WaitingDesire;
var byte	GoHidePointDesire;
var byte	GoAmbushPointDesire;

var(JAfraid)  byte  RunDesire;
var(JAfraid)  byte  HideDesire;	// Will default to Run if no hide location found.	(NavigationPoint - HidePoint)

var byte	GreetDesire;
var float	GreetRange;

/*var(JAttack) bool	ProjAttack;						// Inherent physical projectile abilities (or pre-scripted ones that may be 'illogical' and not inherently based on the weapon system)
var(JAttack) class	ProjAttackType[5];
var(JAttack) byte	ProjAttackDesire[5];

var(JAttack) byte	NeutralDesire;
var(JAttack) byte	AdvanceDesire;
var(JAttack) byte	AmbushPointDesire;
var(JAttack) float	RushDuration;
var(JAttack) bool	WarnFriendsWhenFirstAttacking;	// Special case - alert others of same type? - NOT IMPLEMENTED YET
var(JAttack) sound	WarnFriendsSound;

var(JMotion) float	WalkingSpeed;
var(JMotion) float	RushSpeed;

var(JWaiting) byte	FindFriendDesire;
var(JWaiting) byte	WanderDesire;
var(JWaiting) float	WanderRange;
var(JWaiting) byte	WaitingDesire;
var(JWaiting) byte	GoHidePointDesire;
var(JWaiting) byte	GoAmbushPointDesire;

var(JAfraid)  byte  RunDesire;
var(JAfraid)  byte  HideDesire;	// Will default to Run if no hide location found.	(NavigationPoint - HidePoint)

var(JFriend)  byte	GreetDesire;
var(JFriend)  float GreetRange;*/

// Inventory.BotDesirability() determines the base desirability of an item based on the JazzPawnAI values
var(JGreed)	bool	CanPickupItems;
var(JGreed)	bool	CanUseWeapons;			// Is capable of using items and weapons (overridden if CanPickupItems is false)
var(JGreed) float	GreedOverrideWaiting;	// Base greed to Override Waiting
var(JGreed)	float	GreedOverrideHostility;	// Base greed to Override Hostility
var		Inventory	CurrentGreedObject;
var		float		CurrentGreedFactor;
var		JazzObject	CurrentInterestObject;
var		float		CurrentInterestFactor;

var			bool	NewAttack;
var			float	RecentlyAttacked;
var			actor	NewAttacker;
//var			actor	CurrentTarget;		// General target			- Second priority
var			float	CurrentTargetLostTicks;	// Ticks from last time target was found with the 'Find' function
var			actor	AfraidTarget;		// Special afraid override 	- First priority
var(JAfraid) float	AfraidDuration;
var			float	AfraidTimeLeft;

var			actor	FriendTarget;		// Friendly target		 	- Third priority
var			actor	TempTarget;
var			float	TargetDistance;		// Distance to Target Currently
var			vector	VectorToTarget;

var			vector	TempVect;
var			int		Temp;
var			int		MotionCounter;

// VectorCheck Globals
var			float	TraceDistance;
var			vector	TraceLocation;


/////////////////////////////////////////////////////////////////////////////////////
// AI INITIALIZATION												INITIALIZATION
/////////////////////////////////////////////////////////////////////////////////////
//
function PreBeginPlay()
{
	Super.PreBeginPlay();

	ResetActorDesires();
	
	// Set Unreal movement code intrinsics
	//
	bCanFly = false;
	bCanSwim = false;
	bAvoidLedges = true;
}

function ResetActorDesires ()
{
	// Normal decision-making
	//
	switch WaitStyle {
	
	case WAT_Motionless:
		FindFriendDesire = 0;
		WanderDesire = 0;
		WaitingDesire = 1;
		GoHidePointDesire = 0;
		GoAmbushPointDesire = 0;
		GreetDesire = 0;
		break;
		
	case WAT_LoneWanderer:
		FindFriendDesire = 0;
		WanderDesire = 50;
		WaitingDesire = 0;
		GoHidePointDesire = 10;
		GoAmbushPointDesire = 0;
		GreetDesire = 5;
		break;

	case WAT_Ambusher:
		FindFriendDesire = 0;
		WanderDesire = 1;
		WaitingDesire = 2;
		GoHidePointDesire = 10;
		GoAmbushPointDesire = 30;
		GreetDesire = 0;
		break;
		
	case WAT_Groupie:
		FindFriendDesire = 10;
		WanderDesire = 5;
		WaitingDesire = 0;
		GoHidePointDesire = 0;
		GoAmbushPointDesire = 0;
		GreetDesire = 50;
		break;
	}

	// Combat styles
	//	
	switch CombatStyle {
	
	case COM_SniperTroop:
/*		StrongAdvanceDesire = 0;
		AdvanceDesire = 0;
		NeutralDesire = 10;
		ReverseDesire = 2;
		StrongReverseDesire = 0;*/
		AmbushPointDesire = 2;
		RushDuration = 0;
		OptimalAttackStyle = 2;
		break;
		
	case COM_Rusher:
/*		StrongAdvanceDesire = 0;
		AdvanceDesire = 10;
		NeutralDesire = 0;
		ReverseDesire = 0;
		StrongReverseDesire = 0;*/
		OptimalAttackStyle = 0;
		AmbushPointDesire = 0;
		RushDuration = 2;
		break;
		
	case COM_ThinkerCharlie:
/*		StrongAdvanceDesire = 1;
		AdvanceDesire = 4;
		NeutralDesire = 10;
		ReverseDesire = 4;
		StrongReverseDesire = 1;*/
		OptimalAttackStyle = 1;
		AmbushPointDesire = 1;
		RushDuration = 2;
		break;
	}
	
	switch Intelligence {

	case INT_Mindless:
	case INT_Instinct:
		AttackMoves[0] = 1;
		AttackMoves[1] = 1;
		AttackMoves[2] = 1;
		AttackMoves[3] = 1;
		AttackMoves[4] = 1;
		break;
		
	case INT_Barbaric:
	case INT_Tactful:
		AttackMoves[0] = 2;
		AttackMoves[1] = 2;
		AttackMoves[2] = 2;
		AttackMoves[3] = 2;
		AttackMoves[4] = 2;
		break;
	
	}
	
	// Universal defaults
	//
	GreetRange = 150;
	CurrentAttackStyle = -1;
}

/////////////////////////////////////////////////////////////////////////////////////
// HitWall															General Event
/////////////////////////////////////////////////////////////////////////////////////
//
function HitWall( vector HitNormal, actor HitWall )
{
	local actor HitActor;
	local vector HitLocation, ViewSpot, ViewDist, LookDir;
	
	if ( NearWall(2 * CollisionRadius + 50))
	{
		// Move away from the wall
		MoveAwayFromWall();
	}
	else
	{
		if(FRand() < 0.25)
		{
			LookDir = vector(Rotation);
			ViewSpot = Location + BaseEyeHeight * vect(0,0,1);
			ViewDist = LookDir * (CollisionRadius*2) * -1; 
			HitActor = Trace(HitLocation, HitNormal, ViewSpot + ViewDist, ViewSpot, false);
			if ( HitActor == None )
			{
				MoveAwayFromWall();
				return;
			}
		}
		
		LookDir = vector(Rotation);
		ViewSpot = Location + BaseEyeHeight * vect(0,0,1);
		ViewDist = LookDir * (CollisionRadius*2 + 50); 

		ViewDist = Normal(HitNormal Cross vect(0,0,1)) * (CollisionRadius*2 + 50);
		if (FRand() < 0.5)
			ViewDist *= -1;
	
		HitActor = Trace(HitLocation, HitNormal, ViewSpot + ViewDist, ViewSpot, false);
		if ( HitActor == None )
		{
			Focus = Location + ViewDist;
			MoveAwayFromWall();
		}
		else
		{
			ViewDist *= -1;
		
			HitActor = Trace(HitLocation, HitNormal, ViewSpot + ViewDist, ViewSpot, false);
			if ( HitActor == None )
			{
				Focus = Location + ViewDist;
				MoveAwayFromWall();
			}
			else
			{
				Focus = Location - LookDir * 300;
				MoveAwayFromWall();
			}
		}
	}
}

function MoveAwayFromWall()
{
}

/////////////////////////////////////////////////////////////////////////////////////
// AI DISTRACTIONS													GENERAL EVENT
/////////////////////////////////////////////////////////////////////////////////////
//
// Event : Found Player
//
function SeePlayer(actor Seen)
{
	// Jazz Player
	//
	if (JazzPlayer(Seen) != None)
	{
		switch (AttitudeVsPlayer)
		{
		case ATT_Enemy :		NewPlayerAttacker(JazzPlayer(Seen));	break;
		case ATT_Friendly : 	NewPlayerFriend(JazzPlayer(Seen));	break;	// Player is friend - greet or something
		case ATT_Uncaring : 	break;	// Player unimportant - not attacking anyway
		case ATT_Protective : 	break;	// Player only seen, maybe play a threat animation
		case ATT_Scared : 		NewPlayerAfraidOf(JazzPlayer(Seen)); break;	// Run away anyway
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// RECEIVE WARNING													GENERAL EVENT
/////////////////////////////////////////////////////////////////////////////////////
//
function Trigger( actor Other, pawn EventInstigator )
{
	// Received trigger from another of my type?
	if (Other.Class == Self.Class)
	{
		// Is my friend telling me of a player?
		//
		if (JazzPlayer(EventInstigator) != None)
		{
			WarnedOfPlayer(EventInstigator);
		}
	}
	else
	Super.Trigger(Other,EventInstigator);
}

// A warning from a friend might be considered the same as an order
//
function WarnedOfPlayer(actor Seen)
{
	// Jazz Player
	//
	if (JazzPlayer(Seen) != None)
	{
		switch (AttitudeVsPlayer)
		{
		case ATT_Enemy :		NewPlayerAttacker(JazzPlayer(Seen));	break;
		case ATT_Friendly : 	NewPlayerAttacker(JazzPlayer(Seen));	break;
		case ATT_Uncaring : 	NewPlayerAttacker(JazzPlayer(Seen));	break;
		case ATT_Protective : 	NewPlayerAttacker(JazzPlayer(Seen));	break;
		case ATT_Scared : 		NewPlayerAfraidOf(JazzPlayer(Seen));	break;	// Run away anyway
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// AI DISTRACTIONS													GENERAL EVENT
/////////////////////////////////////////////////////////////////////////////////////
//
function NewPlayerAttacker( pawn Other )
{
	NewAttack = false;	

	if (Find( Other ))
	{
		// Intellect Check on Attacker
		//
		if (IntellectCheck( Other ))
		{
			if (CourageCheck( Other ))
			{
				Enemy = Other;
			}
			else
			{
				AfraidTarget = Other;
				AfraidTimeLeft = AfraidDuration;
			}
		}
	}
	else
	{
		//Enemy = None;
	}

	TriggerNewDecision();
}

function TriggerNewDecision()
{
	if ((FreezeTime<=0) && (BurnTime<=0) && (PetrifyTime<=0) && (IgnoreAllDecisions==false) && (Health>0))
	{
		GotoState('Decision');	// Override current state - We've been hurt, so make an immediate response!
	}
}


function NewPlayerFriend( Pawn Other )
{
	if (Find( Other ))
	{
		FriendTarget = Other;
	}
	else
	{
		FriendTarget = None;
	}
}

function NewPlayerAfraidOf( JazzPlayer Other )
{
	if (Find( Other ))
	{
		AfraidTarget = Other;
		AfraidTimeLeft = AfraidDuration;
	}
	else
	{
		AfraidTarget = None;
		AfraidTimeLeft = 0;
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// BASE AI FUNCTIONS													BASIC
/////////////////////////////////////////////////////////////////////////////////////
//
function bool NeedToTurn(vector targ)
{
	local int YawErr;

	DesiredRotation = Rotator(targ - location);
	DesiredRotation.Yaw = DesiredRotation.Yaw & 65535;
	YawErr = (DesiredRotation.Yaw - (Rotation.Yaw & 65535)) & 65535;
	if ( (YawErr < 4000) || (YawErr > 61535) )
		return false;

	return true;
}

function UpdateYawRotation ( vector targ )
{
	local rotator NewRotation;
	local int YawErr;
	DesiredRotation = Rotator(targ - location);
	DesiredRotation.Yaw = DesiredRotation.Yaw & 65535;
	YawErr = (DesiredRotation.Yaw - (Rotation.Yaw & 65535)) & 65535;
	
	NewRotation = Rotation;
	if (YawErr<32200)
		NewRotation.Yaw += 100;
	else
		NewRotation.Yaw += 100;
	NewRotation.Pitch = 0;
		
	SetRotation(NewRotation);
}

// Trace to vector V and see if anything is in the way.
//
function bool VectorTrace( vector V )
{
	local vector 	HitLocation,HitNormal;
	local actor 	Result;
	local bool		ActorFound;
	local float		NewDist;
	
	Result = Trace( HitLocation, HitNormal,	V, Location );

	TraceDistance = VSize(HitLocation-Location);
	TraceLocation = HitLocation;

	// Return true if trace is not blocked.
	
	return((HitLocation == V) || (Result==None));
}

// Trace from end vector location to make sure pawn does not fall.
//
// Someday we may need this function if Unreal can't do it automagically.
// 
// FallingDistance		Distance allowed to fall
// CheckForWater		Check if water zone underneath
// CheckFromOrigin		Do multiple checks from the origin point of motion (current Location)
//
/*function bool LocationSafe ( vector V, float FallingDistance, bool CheckForWater, optional bool CheckFromOrigin )
{
}*/

// Randomly Decide between 5 weighted choices
//
function int Decide ( int A, int B, int C, int D, int E )
{
	local int Dec,Val,Min;
	
	Val = Rand((A+B+C+D+E));
	
	Min = 0;

	if (Val<A)
	return(1);
	
	Val-=A;
	if (Val<B)
	return(2);
	Val-=B;
	if (Val<C)
	return(3);
	Val-=C;
	if (Val<D)
	return(4);
	Val-=D;
	if (Val<E)
	return(5);
	
	return(0);
}

/////////////////////////////////////////////////////////////////////////////////////
// SPECIAL POINTS														FIND
/////////////////////////////////////////////////////////////////////////////////////
//
function bool FindAmbushPoint ()
{
	local AmbushPoint	H;
	
	//Log("AmbushPoint) Search");
	// Search for HidePoint
	foreach allactors(class'AmbushPoint', H)
	{
		// TODO: Have WarnDistance affect range of creatures
			
		if (LineOfSightTo(H))
		{
			TempTarget = H;
			return(true);
		}
	}
	return(false);
}

function bool FindHidePoint ()
{
	local HidePoint	H;
	
	//Log("HidePoint) Search");
	// Search for HidePoint
	foreach allactors(class'HidePoint', H)
	{
		// TODO: Have WarnDistance affect range of creatures
			
		if (LineOfSightTo(H))
		{
			TempTarget = H;
			return(true);
		}
	}
	return(false);
}

/////////////////////////////////////////////////////////////////////////////////////
// DAMAGE ANOTHER														EVENT
/////////////////////////////////////////////////////////////////////////////////////
//
function DamageOpponent(rotator Rotate, float Dist, float Damage, name DamageType, float Momentum)
{
	local vector HitLocation,HitNormal,EndTrace;
	local actor Other;
	// Trace for enemy in radius and rotation from here.
	//Log("DamageOpponent) "$Dist$" "$Damage);

	EndTrace = Location + vector(Rotate)*Dist;
	Other = Trace(HitLocation,HitNormal,EndTrace,Location,True);
	
	if (Pawn(Other) != None)
	{
		Pawn(Other).TakeDamage(Damage,Self,HitLocation,vector(Rotate)*Momentum,DamageType);
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// DAMAGE	 															EVENT
/////////////////////////////////////////////////////////////////////////////////////
//
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	// This ignores all attacks and takes no damage.
	//
	if ((!StateBasedInvulnerability) && (InvulnerabilityTime<=0))
	{
	
		if (instigatedBy != None)
		{
			RecentlyAttacked = 3;
			NewAttack = true;
			NewAttacker = instigatedBy;
		}

		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}
}

function Died(pawn Killer, name damageType, vector HitLocation)
{
	IgnoreAllDecisions = true;
	Super.Died(Killer,damageType,HitLocation);	
}

function HurtPlayer( JazzPlayer Other, int Damage, int VelocityBash )
{
	local vector VelocityModify;
	
	Super.HurtPlayer(Other,Damage,VelocityBash);
	
	// Back away afterwards
	TempTarget = Other;
	GotoState('BackAway');

/*	if (Other != NONE)
	{
		Other.TakeDamage(Damage,self,self.Location,vect(0,0,0),'Touched');
		VelocityModify = VelocityBash*(Normal(Other.Location-Location));
		VelocityModify.Z = VelocityBash*3;
		Other.SetPhysics(PHYS_Falling);
		Other.Velocity = VelocityModify;
	}*/
}

/////////////////////////////////////////////////////////////////////////////////////
// ZONE CHANGES															EVENT
/////////////////////////////////////////////////////////////////////////////////////
//
function ZoneChange(ZoneInfo newZone)
{
	local vector jumpDir;

	if ( newZone.bWaterZone )
	{
		if (!bCanSwim)
			MoveTimer = -1.0;
		else if (Physics != PHYS_Swimming)
		{
			if (Physics != PHYS_Falling)
				PlayDive(); 
			setPhysics(PHYS_Swimming);
		}
	}
	else if (Physics == PHYS_Swimming)
	{
		if ( bCanFly )
			 SetPhysics(PHYS_Flying); 
		else
		{ 
			SetPhysics(PHYS_Falling);
			if ( bCanWalk && (Abs(Acceleration.X) + Abs(Acceleration.Y) > 0) && CheckWaterJump(jumpDir) )
				JumpOutOfWater(jumpDir);
		}
	}
}

function JumpOutOfWater(vector jumpDir)
{
	Falling();
	Velocity = jumpDir * WaterSpeed;
	Acceleration = jumpDir * AccelRate;
	velocity.Z = 380; //set here so physics uses this for remainder of tick
	PlayOutOfWater();
	bUpAndOut = true;
}

/////////////////////////////////////////////////////////////////////////////////////
// LIFE		 															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
auto state Life
{
	Begin:
	MinHitWall = -0.5;
	SetPhysics(PHYS_Walking);
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// WEAPON SELECTION														BASIC
/////////////////////////////////////////////////////////////////////////////////////
//
function SelectWeaponCell()
{
	// Weapon cells are used in conjunction with inherent abilities and reflect simply another aspect of the
	// pawn's capabilities.  However, the pawn will try to optimize it's weapon abilities if it has the ability
	// flag set to be capable of using weapons.
	//
	// Pawns must scan each weapon cell in its inventory, which will check the effectiveness based on the
	// current target.  This will be ignored if the intelligence of the pawn is lower than 'Tactful'.
	//
	local	float		Rating;
	local	int			bUseAltFire;
	
	//Log("SelectWeapon");
	
	// Scan inventory for weapon to use
	//
	if(Inventory != None)
	Inventory.RecommendWeapon(Rating,bUseAltFire);
}

// Manual return function to use the bad hack required by my reluctance to alter the Engine.Inventory class to
// add a new weapon reccommendation function to determine the weapon to use.  This requires that anything new,
// such as weapon cells, that are not of class Weapon, must report back manually or not at all.
//
// Basically, this merely assigns the inventory selection 0 (weapon cells) to a new weapon cell.
//
function PerformWeaponCellSelection( actor NewCell )
{
	//Log("New Weapon Cell Selection) "$NewCell);

	InventorySelections[0] = Inventory(NewCell);
}

/////////////////////////////////////////////////////////////////////////////////////
// DECISION 															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state Decision
{
	// Vicinity Object Check
	//
	// Check all items in vicinity to find something to go pick up.
	//
	function VicinityObjectCheck()
	{
		local JazzObject O,OMax;
		local float Desirability,NewDesire;
		
		Desirability = -1;
		OMax = None;

		foreach allactors(class'JazzObject', O)
		{
			if ((O.Owner == None) && (CanSee(O) == true))
			{
				NewDesire = O.Interest(Self);
				NewDesire = NewDesire - (VSize(Location-O.Location)-100)/75;
				
				if (NewDesire > Desirability)
				{
					Desirability = NewDesire;
					OMax = O;
				}
			}
		}
	
		CurrentInterestObject = OMax;
		CurrentInterestFactor = Desirability;
	}

	function MoveAwayFromWall()
	{
		GotoState('Decision','MoveAway');
	}

	// Greed Check
	//
	// Check all items in vicinity to find something to go pick up.
	//
	//
	function GreedCheck ()
	{
		local Inventory I;
		local float Desirability,NewDesire;
		local Inventory IMax;
		
		Desirability = -1;
		IMax = None;

		foreach allactors(class'Inventory', I)
		{
			if ((I.Owner == None) && (CanSee(I) == true))
			{
				NewDesire = I.BotDesireability(Self);
				NewDesire = NewDesire - (VSize(Location-I.Location)-100)/75;
				//Log("DesirabilityCheck) "$NewDesire$" "$I);
			
				if (NewDesire > Desirability)
				{
					Desirability = NewDesire;
					IMax = I;
				}
			}
		}
		
		CurrentGreedObject = IMax;
		CurrentGreedFactor = Desirability;
	}

	// Event : Found Player
	//
	function SeePlayer(actor Seen)
	{
		// Jazz Player
		//
		if (JazzPlayer(Seen) != None)
		{
			switch (AttitudeVsPlayer)
			{
			case ATT_Enemy :		NewPlayerAttacker(JazzPlayer(Seen));	break;
			case ATT_Friendly : 	break;
			case ATT_Uncaring : 	break;
			case ATT_Protective : 	break;
			case ATT_Scared : 		break;
			}
		}
	}

	function NewAttitudes()
	{
		// Check for a new attack on the creature
		//
		if (NewAttack)
		{
			if (JazzPlayer(NewAttacker) != None)
				NewPlayerAttacker(JazzPlayer(NewAttacker));
		}
	}

	function MakeCombatDecision ( pawn Enemy )
	{
		GotoState('AttackTarget');
	}
	
	function MakeAfraidDecision ( pawn Enemy )
	{
		GotoState('AfraidOfTarget');
	}
	
	function MakeFriendDecision ( pawn Enemy )
	{
		GotoState('FriendOfTarget');
	}

	// Choose an action when there's nothing to do.
	//
	function DoNothing ()
	{
		switch (Decide(WanderDesire,WaitingDesire,FindFriendDesire,GoHidePointDesire,GoAmbushPointDesire))
		{
		case 1:		
			GotoState('Wander');
			return;
		break;
		case 2:		
			GotoState('Waiting'); 
			return;
		break;
		case 3:
			GotoState('FindFriend');
			return;
		break;
		case 4:
			GotoState('GoHidePoint');
			return;
		break;
		case 5:
			GotoState('GoAmbushPoint');
			return;
		break;
		
		}
		GotoState('Waiting');
	}

	Begin:
	//Log("JazzPawnAI) Decision");
	//Log("JazzPawnAI) New Attack "$NewAttack);
	
	StateBasedInvulnerability = false;
	
	CheckTargetLife();
	NewAttitudes();

	// Item Greed Check
	//
	if (CanPickupItems)
	{		
		GreedCheck();
	}
	if (Intelligence == INT_Tactful)
	{
		VicinityObjectCheck();
	}

	// Item Interest/Greed Overrides
	// 
	if (( Enemy != None ) || (AfraidTarget != None))	// Ignore Attacker
	{
		if (CurrentGreedObject != None)
			if (CurrentGreedFactor >= GreedOverrideHostility)		GotoState('GetItem');
		if (CurrentInterestObject != None)
			if (CurrentInterestFactor >= GreedOverrideHostility)	GotoState('InterestObject');
	}
	else	// Get item instead of waiting
	{
		if (CurrentGreedObject != None)
			if (CurrentGreedFactor >= GreedOverrideWaiting) 		GotoState('GetItem');
		if (CurrentInterestObject != None)
			if (CurrentInterestFactor >= GreedOverrideWaiting)	GotoState('InterestObject');
	}

	// Special : Are we really afraid of something?
	// Do we have a target?
	if (AfraidTarget != None)
	{
		if (AfraidTimeLeft<=0)
			AfraidTarget = None;
			
		Conversing = false;
		if (Find(pawn(AfraidTarget)) == true)
		{
			MakeAfraidDecision(pawn(AfraidTarget));
		}
		else
		{
			AfraidTarget = None;
			AfraidTimeLeft=0;
		}

	}

	// Do we have a target?
	if (Enemy != None)
	{
		Conversing = false;
		if (Find(Enemy) == true)
		{
			CurrentTargetLostTicks = 0;
			MakeCombatDecision(Enemy);
		}
		else
		{
			// Lost Target
			CurrentTargetLostTicks += 1;
			if (CurrentTargetLostTicks>10)
				Enemy = None;
		}
	}
	
	// Do we have a friend?
	if (FriendTarget != None)
	{
		if (Find(pawn(FriendTarget)) == true)
		{
			MakeFriendDecision(pawn(FriendTarget));
		}
		else
		{
			FriendTarget = None;
		}
	}

	Conversing = false;
	//Sleep(1);		// Originally here to avoid infinite Decision loop
	DoNothing();	
	
	MoveAway:
		if(VSize(Location - Focus) < CollisionRadius)
		{
			Focus = (CollisionRadius * VSize(Location - Focus)) * (Focus - Location) + Location;
		}
		MoveTo(Focus);
		Goto('Begin');
}

function CheckTargetLife()
{
	// Make sure target is alive, if we have one
	if(NewAttacker != None)
	{
		if(Pawn(NewAttacker).Health <= 0)
		{
			NewAttacker = None;
		}
	}
	
	if(Enemy != None)
	{
		if(Enemy.Health <= 0)
		{
			Enemy = None;
		}
	}
	
	if(AfraidTarget != None)
	{
		if(Pawn(AfraidTarget).Health <= 0)
		{
			AfraidTarget = None;
		}
	}
		
	if(FriendTarget != None)
	{
		if(Pawn(FriendTarget).Health <= 0)
		{
			FriendTarget = None;
		}
	}
}

function bool CourageCheck( pawn Other )
{
	switch (Courage)
	{
		case COU_Mindless : return true;	// Never hide
		case COU_Reactive : return true;	// 
		case COU_Timid	 : 					// Hide when recently attacked
				if (RecentlyAttacked>0) return false;
									else return true;
		case COU_Strong	 : return true;		// Never hide
		case COU_Terrified : return false;	// Hide always
	}
return true;
}

function bool IntellectCheck( pawn Other )
{
return true;
}

function bool Find ( pawn Other )
{

return true;
}

/////////////////////////////////////////////////////////////////////////////////////
// SHOW INTEREST IN OBJECT - MOVE TO OBJECT								STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state InterestObject
{

Begin:
	PlayWalking();

	TempVect = (CurrentInterestObject.Location - Location);
	Temp = VSize(TempVect);
	
	if (Temp<20)	// Distance to maintain from object
	{
	TempVect = Location+TempVect/Temp*50;
	}
	MoveTo(TempVect,WalkingSpeed);
	
	// Say something appropriate here.
		
	Sleep(2);
	
	Acceleration = vect(0,0,0);
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// GET ITEM - MOVE TO SELECTED ITEM										STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state GetItem
{
	function Touch ( actor Other )
	{
		Super.Touch(Other);
		
		//Log("Touch) "$Other);
		if (Other == CurrentGreedObject) 
		{
		Acceleration = vect(0,0,0);
		GotoState('Decision');
		}
	}

Begin:
	PlayWalking();
	
	MoveToward(CurrentGreedObject,WalkingSpeed);
	
	Sleep(2);
	
	Acceleration = vect(0,0,0);
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// NOTHINGTODO MOTION - WAIT											STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state Waiting
{

Begin:
	Acceleration = vect(0,0,0);
	PlayWaiting();
	Sleep(1/(TriggerHappy+1));			// Reduce idle time by TriggerHappy factor
	GotoState('Decision');
}


/////////////////////////////////////////////////////////////////////////////////////
// NOTHINGTODO MOTION - FIND AMBUSH POINT								STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state GoAmbushPoint
{

Begin:
	//Log("JazzAI) Look for ambush point");
	if (FindAmbushPoint()==true)
	{
		PlayWalking();
		MoveToward(TempTarget,WalkingSpeed);
		TurnTo(TempTarget.Location + AmbushPoint(TempTarget).LookDir);
		GotoState('Decision');
	}
	else
		GotoState('GoHidePoint');	// Alternately, look for a hiding point for now, then.
}


/////////////////////////////////////////////////////////////////////////////////////
// NOTHINGTODO MOTION - FIND AMBUSH POINT								STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state GoHidePoint
{

Begin:
	//Log("JazzAI) Look for hiding point");
	if (FindHidePoint()==true)
	{
		PlayWalking();
		MoveToward(TempTarget,WalkingSpeed);
		TurnTo(TempTarget.Location + HidePoint(TempTarget).LookDir);
		GotoState('Decision');
	}
	else
		GotoState('Waiting');
}


/////////////////////////////////////////////////////////////////////////////////////
// NOTHINGTODO MOTION - FIND ANOTHER OF SELF CLASS						STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state FindFriend
{
	
	/////////////////////////////////////////////////////////////////////////////////////
	// Look for the first actor of my own kind I can see.
	//
	function actor SearchForFriend()
	{
		local actor A;
	
		foreach allactors(Self.Class, A)
		{
			// TODO: Have WarnDistance affect range of creatures
			
			if (LineOfSightTo(A) && (A != Self))
				return(A);
		}
		return (None);
	}

Begin:
	TempTarget = SearchForFriend();	
	
	if (TempTarget == None)
		GotoState('Wander');
	else
	{
		PlayWalking();
		MoveToward(TempTarget,WalkingSpeed);
		Sleep(FRand()*3+2);
	}
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// NOTHINGTODO MOTION - WANDER											STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state Wander
{
	// Check for locations that cannot be reached.
	//
	function NewWanderLocation ()
	{
		local float	  Distance;
	
		// Normal wandering - stupid wandering
		//
		switch (Intelligence)
		{
		case INT_Instinct:
			// Input Instinct code
			
		case INT_Mindless:
			WanderRandom(0);
			break;
	
		case INT_Barbaric:
			WanderSemiRandom(3);
			break;
			
		case INT_Tactful:
			// Input Tactful code
			WanderSemiRandom(8);
			break;
		
		}
	}
	
	function WanderSemiRandom(int Tries)
	{
		local float	 	Distance;
		local rotator	R;
		while (Tries>=0)
		{
			Distance = FRand()*WalkingSpeed/2+10;
			R = Rotation;
			R.Yaw += FRand()*((65536/4))-(65536/8);
			R.Pitch += FRand()*((65536/6))-(65536/12);
			Destination = Location + (vect(1,0,0) * Distance) << R;
			Destination.Z += 40;
			Tries--;
			
			if (WanderCheck())
			return;
		}
		
		WanderRandom(3);
	}

	function WanderRandom(int Tries)
	{
		local float	  Distance;
		while (Tries>=0)
		{
			Distance = (FRand()+0.4)*WalkingSpeed*3;
			Destination = Location + Distance*VRand();
			Destination.Z = Location.Z;
			Tries--;
			
			if (Tries>0)
				if (WanderCheck())
					return;
		}
	}

	function bool WanderCheck()
	{
		return ((VectorTrace(Destination)) && (pointReachable(Destination)));
	}

	function MoveAwayFromWall()
	{
		GotoState('Wander','MoveAway');
	}

	MoveAway:
	if(VSize(Location - Focus) < CollisionRadius)
	{
		Focus = (CollisionRadius * VSize(Location - Focus)) * (Focus - Location) + Location;
	}
	MoveTo(Focus);
	GotoState('Decision');
	
	Begin:
	PlaySlowWalk();
	NewWanderLocation();
	MoveTimer=0;
	MoveTo(Destination,WalkingSpeed);
	PlayStopped();
	GotoState('Decision');
}

function PlaySlowWalk()
{
	// Override later
}

/////////////////////////////////////////////////////////////////////////////////////
// BACK AWAY AFTER HURTING												STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state BackAway
{
	function MoveAwayFromWall()
	{
		IgnoreallDecisions = false;
		GotoState('Decision','MoveAway');
	}
	
Begin:
	PlayRunning();
	IgnoreAllDecisions=true;	
	TempVect = Location - TempTarget.Location;
	MoveTo(Location + TempVect * (FRand()+0.2)*10,RushSpeed);
	IgnoreAllDecisions=false;
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// TAKE AFRAID ACTION													STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state AfraidOfTarget
{

RunAway:
	PlayRunning();
	TempVect = Location - AfraidTarget.Location;
	MoveTo(Location + TempVect * FRand()*2,RushSpeed);
	GotoState('Decision');

Hide:
	if (FindHidePoint()==true)
	{
		//Log("HidePoint) Found");
		PlayWaiting();
		MoveToward(TempTarget,RushSpeed);
		Sleep(8);
		GotoState('Decision');
	}
	else
		Goto('RunAway');

Begin:
	if (LineOfSightTo(AfraidTarget))
	{
	//Log("AfraidOfTarget) "$AfraidTarget);
		switch (Decide(RunDesire,HideDesire,0,0,0))
		{
		case 0: 	Goto('RunAway');
		case 1: 	Goto('RunAway');
		case 2:		Goto('Hide');
		}
	}
	GotoState('Decision');
}


/////////////////////////////////////////////////////////////////////////////////////
// TAKE FRIEND ACTION													STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state FriendOfTarget
{

Greet:
	//Log("FriendOf) "$VSize(Location-FriendTarget.Location));
	//
	// Don't crowd the player too much
	//
	if (VSize(Location-FriendTarget.Location)<=GreetRange)
	{

	// Turn towards the player when they come towards you, otherwise do what you normally do.
	//	
	while (NeedToTurn(FriendTarget.Location))
	{
		UpdateYawRotation(FriendTarget.Location);
		Sleep(0.02);
	}
	
	TalkToPlayer();
	
	Acceleration = vect(0,0,0);
	}
	else
	{
		GotoState('Wander');
		Conversing = false;	// Out of conversation range
	}
		
	GotoState('Decision');

Begin:
	if (LineOfSightTo(FriendTarget))
	{
		switch (Decide(GreetDesire,0,0,0,0))
		{
		case 0: 	Goto('Greet');	// Default
		case 1: 	Goto('Greet');
		}
	}
	GotoState('Decision');
}

// Animation
function TalkToPlayer();

/////////////////////////////////////////////////////////////////////////////////////
// AI ATTACK CAPABILITY												INITIALIZATION
/////////////////////////////////////////////////////////////////////////////////////
//
function ReactionTimeCalc( TriggerVal TriggerHappy )
{
	switch (TriggerHappy)
	{
		case INT_Pacifist: 	ReactionTime=1; 	return;
		case INT_Moderate: 	ReactionTime=0.5; 	return;
		case INT_Vicious: 	ReactionTime=0.1; 	return;
		case INT_Insane: 	ReactionTime=0.05; 	return;
	}
	ReactionTime=1;
}

/////////////////////////////////////////////////////////////////////////////////////
// PHYSICAL ATTACK FROM STANDING POSITION								STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state StandStrike
{
	Begin:
	// Add creature-specific attack code.
	
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// PHYSICAL ATTACK FROM RUNNING											STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state RushStrike
{
	Begin:
	// Add creature-specific attack code.
	
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// TAKE HOSTILE ACTION													STATES
/////////////////////////////////////////////////////////////////////////////////////
//
function DoProjectileAttack(optional bool CheckAccuracy)
{
	return;
}

state AttackTarget
{

	// Allow enemy to fall off ledges when rushing to attack
	function BeginState()
	{
		if (!AvoidLedgesWhenAttacking)
			bAvoidLedges = false;
	}

	function EndState()
	{
		bAvoidLedges = true;
	}

function DoProjectileAttack(optional bool CheckAccuracy)
{
	local int	result;
	
	//Log("PhysicalAttackCheck");
	
	// Hand to Hand attack takes preference
	if ((StandPhysicalAttack) && (VSize(Velocity)<150)
		&& (VSize(Enemy.Location-Location)<70))
	{
		// Check if facing or facing is necessary
		GotoState('StandStrike');		
	}
	else
	{
		if ((RunPhysicalAttack) && (VSize(Enemy.Location - Location) < 200))
		{
				// Check if facing or facing is necessary
				if ((!RunPhysicalFacing) || (!NeedToTurn(Enemy.Location)))
					GotoState('RushStrike');
		}
	}

	// Projectile Attack
	if ((!CheckAccuracy) || (!NeedToTurn(Enemy.Location)))
	{
		if (Weapon != None)
		{
			FireProjectile(0);
		}
		else
		{
			result = Decide(ProjAttackDesire[0],ProjAttackDesire[1],ProjAttackDesire[2],ProjAttackDesire[3],ProjAttackDesire[4]);
		
			if (result > 0)
				FireProjectile(result-1);
		}
	}
}

function FireProjectile( int ProjNum )
{
	ViewRotation = Rotation;
	
	// Check Weapon Cell Inventory Slot (0)
	if (Weapon != None)
	{
		Weapon.bPointing = true;
		JazzWeaponCell(InventorySelections[0]).Fire(0);
		PlayFiring();
	}
	else
	{
	//Log("NonWeaponAttack");
	spawn(class<actor>(ProjAttackType[ProjNum]));
	}
}

function actor WarnFriendsAction()
{
	local actor	A;

	foreach allactors(Self.Class, A)
	{
		// TODO: Have WarnDistance affect range of creatures
		if (LineOfSightTo(Enemy))
	
		A.Trigger(self, Enemy);
	}
}

function CalculateVectorToTarget ()
{
	VectorToTarget = Enemy.Location - Location;
	VectorToTarget.Z = 0;
}
	
/////////////////////////////////////////////////////////////////////////////////////
// DETERMINE MOVE USED												ATTACK SYSTEM
/////////////////////////////////////////////////////////////////////////////////////
//
// Move group is 0-4 (0-StrongAdvance / 4-StrongReverse)
//
function byte UseMove ( byte MoveGroup )
{
	local byte M;
	M = FRand()*AttackMoves[MoveGroup];
	
	//Log("JazzPawnAI) RandomMove:"$M);
	return(M);
}

function vector VectorDegreeChangeMain ( vector A, vector B, float AngleChange, optional float Distance )
{
	local vector Vc;
	local float	 Angle;
	local float  Size;
	
	Vc = (A - B);
	Vc.Z = 0;
	
	Size = VSize(Vc);
	Angle = atan(Vc.Y / Vc.X)+(Pi);
	
	//Log("PawnAI) Angle:"$Angle$" X:"$Vc.X$" "$Vc.Y);
	
	Angle = Angle + AngleChange;

	if (Distance != 0)
	{
	Vc.X = Sin(Angle)*Distance;
	Vc.Y = Cos(Angle)*Distance;
	}
	else
	{	
	Vc.X = Sin(Angle)*Size;
	Vc.Y = Cos(Angle)*Size;
	}
	
	//Log("PawnAI) Result X:"$Vc.X$" Y:"$Vc.Y);
	
	return(A+Vc);
}

function vector VectorDegreeChange ( vector A, vector B, float AngleChange, bool CompareOpposite, optional float Distance )
{
	local vector V1,V2;
	local vector R1,R2;
	local float  S1,S2;

	if (CompareOpposite)
	{
	V1 = VectorDegreeChangeMain(A,B,AngleChange,Distance);
	
	// Vector Totally Clear?
	if (VectorTrace(V1)) return (V1);
	//V1 = TraceLocation;
	S1 = VSize(Location-TraceLocation);

	// No?  Try the other way.	
	V2 = VectorDegreeChangeMain(A,B,-AngleChange,Distance);
	
	// Vector Totally Clear?
	if (VectorTrace(V2)) return (V2);
	//V2 = TraceLocation;
	S2 = VSize(Location-TraceLocation);
	
	// Are both ways really bad?
	//if (S1<10) && (S2<10)
	
	//Log("JazzPawnAI) VectorChangeTrace S1:"$S1$" S2:"$S2);
	//Log("JazzPawnAI) VectorChangeTrace V1:"$V1$" V2:"$V2);
	
	if (S1>S2) return(V1);
	else
	return(V2);
	}
	else
	return(VectorDegreeChangeMain(A,B,AngleChange,Distance));
}

function float Rad ( float Degrees )
{
	return(Degrees/360*2*Pi);
}

	function Tick ( float DeltaTime )
	{
		Global.Tick(DeltaTime);
	
		//Log("MoveTimer) "$MoveTimer);
		MoveTimer -= DeltaTime;
	
		if (MoveTimer<0) MoveTimer=0;
	}

	function MoveAwayFromWall()
	{
		GotoState('AttackTarget','MoveAway');
	}

	MoveAway:
		if(Intelligence != INT_Mindless)
		{
			TempTarget = FindPathToward(Enemy);
			Focus = TempTarget.Location;
		}
		MoveTo(Focus);
		GotoState('AttackTarget');

/////////////////////////////////////////////////////////////////////////////////////
// GOTO AMBUSH POINT												ATTACK SYSTEM
//
AmbushPoint:
	if (FindAmbushPoint()==true)
	{
		PlayRunning();
		MoveToward(TempTarget,RushSpeed);
		Sleep(8);
		GotoState('Decision');
	}
	else
		GotoState('Waiting');

/////////////////////////////////////////////////////////////////////////////////////
// CRY TO WARN FRIENDS (FLOCK)										ATTACK SYSTEM
//
WarnFriends:
	PlayWarnFriends();
	VoicePackActor.DoSound(Self,VoicePackActor.WarnFriendsSound);
	WarnFriendsAction();
	FinishAnim();
	GotoState('Decision');

/////////////////////////////////////////////////////////////////////////////////////
// RUSH THE TARGET													ATTACK SYSTEM
// Fire when TriggerHappy >= Vicious
//
RushTarget:

	PlayRunning();

	ReactionTimeCalc(TriggerHappy);

	for (MotionCounter=(TriggerHappy+1)^2; MotionCounter>=0; MotionCounter--)
	{
	DoProjectileAttack(false);
	MoveTimer = ReactionTime;
	MoveToward(Enemy,RushSpeed);
	}

	Acceleration = vect(0,0,0);
	GotoState('Decision');

/////////////////////////////////////////////////////////////////////////////////////
// HOLD BACK AND FIRE												ATTACK SYSTEM
// Fire always
//
HoldBack:
	Acceleration = vect(0,0,0);
	PlayStationaryFiring();
	TurnToward(Enemy);
	DoProjectileAttack(false);
	Sleep(2/(float(Courage)+float(TriggerHappy)+1));		// Firing compensation decrease based on TriggerHappy and Courage values
	GotoState('Decision');

/////////////////////////////////////////////////////////////////////////////////////
// FLANK WHEN RUNNING TOWARDS THE TARGET							ATTACK SYSTEM
//
FlankLeft:
	TempVect = VectorDegreeChange(Location,Enemy.Location,-Rad(FRand()*30+15),true,10+FRand()*300);
	
	PlayRunning();
	//MoveTimer = FRand()*3+1;
	DoProjectileAttack(true);
	MoveTo(TempVect,RushSpeed);
	
	GotoState('Decision');

/////////////////////////////////////////////////////////////////////////////////////
// DART TO THE LEFT	RELATIVE TO TARGET								ATTACK SYSTEM
//
DartLeft:
	TempVect = VectorDegreeChange(Enemy.Location,Location,-Rad(45),true,10+FRand()*400);
	
	PlayRunning();
	//MoveTimer = FRand()*3+1;
	DoProjectileAttack(true);
	MoveTo(TempVect,RushSpeed);
	
	GotoState('Decision');

/////////////////////////////////////////////////////////////////////////////////////
// ACTION SUBGROUPS													ATTACK SYSTEM
/////////////////////////////////////////////////////////////////////////////////////
//
// This is the main code which randomly determines what move to use in each attack
// category.  The pawn decides first 'Ok, should I attack or retreat or just stay a nice
// distance away?'  Then, it randomly determines, 'Ok, how can I fake out the player or just
// attack well given how intelligent I am?'
//
//
StrongAdvance:
Advance:
	switch (UseMove(1))
	{
	case 0:		Goto('RushTarget');
	case 1:		Goto('FlankLeft');
	}
	Goto('RushTarget');		// Default
	GotoState('Decision');

Neutral:
Reverse:
StrongReverse:
	switch (UseMove(4))
	{
	case 0:		Goto('HoldBack');
	case 1:		Goto('DartLeft');
	}
	Goto('HoldBack');		// Default
	GotoState('Decision');

/////////////////////////////////////////////////////////////////////////////////////
// AI MOVE LIST														DOCUMENTATION
/////////////////////////////////////////////////////////////////////////////////////
//
//	#  Move Name					Int Level
//
// Strong Advance:
//	1) Rush Target					1
//
// Advance:
//	1) Rush Target					1
//
// Neutral:
//  1) Hold	Back					1
//
// Reverse:
//	1) Hold	Back					1
//
// Strong Reverse:
//	1) Hold Back					1
//	2)
//

Begin:
	if (LineOfSightTo(Enemy))
	{
		// Special function that calls out to all the other creatures of the same type as this one.
		//
		if (WarnFriendsWhenFirstAttacking)
		{
			WarnFriendsWhenFirstAttacking = false;	// We only want to do this once.
			Goto('WarnFriends');
		}

		// Distance to Target
		//
		TargetDistance = VSize(Location-Enemy.Location);
		
		// Hey, let's do a Weapon check
		//
		SelectWeaponCell();
	
		// Determine Current Attack Style
		//
		CurrentAttackStyle = OptimalAttackStyle;
		
		/* // Thinker Code Only
		if (Health/Default.Health < 0.3)
		{
			CurrentAttackStyle = CurrentAttackStyle+1;
			if (Health/Default.Health < 0.1)
			CurrentAttackStyle = CurrentAttackStyle+1;
		}*/
		
		if (CurrentAttackStyle>4) CurrentAttackStyle = 4;
	
		switch (CurrentAttackStyle)
		{
		case 0:		Goto('StrongAdvance');
		case 1:		Goto('Advance');
		case 2:		Goto('Neutral');
		case 3: 	Goto('Reverse');
		case 4: 	Goto('StrongReverse');
		}
	}
	else
	{
		switch (Decide(AmbushPointDesire,0,0,0,0))
		{
		case 0: 	GotoState('Waiting');
		case 1: 	Goto('AmbushPoint');
		}
	}
	
	GotoState('Decision');
}


/////////////////////////////////////////////////////////////////////////////////////
// WARN FRIENDS														ANIMATIONS
//
function PlayWarnFriends()
{
	// Do animation
}

/////////////////////////////////////////////////////////////////////////////////////
// STATIONARY FIRING												ANIMATIONS
//
function PlayStationaryFiring()
{
	// Do animation
}

/////////////////////////////////////////////////////////////////////////////////////
// STOPPED AFTER WALKING/RUNNING									ANIMATIONS
//
function PlayStopped()
{
	// Do animation
}

// Testing
//
// Just in case
//
state PlayerSwimming
{
Begin:
	GotoState('Decision');
}

//
// Tick
//
event Tick (float DeltaTime)
{
	local rotator NewRot;

	Super.Tick(DeltaTime);
	RecentlyAttacked -= DeltaTime;

	// Time limit to being afraid (in seconds)
	AfraidTimeLeft -= DeltaTime;
	
	InvulnerabilityTime -= DeltaTime;
}

defaultproperties
{
     GreetDesire=5
     GreetRange=400.000000
     GreedOverrideHostility=80.000000
     AfraidDuration=15.000000
     EnergyDamage=1.000000
     FireDamage=1.000000
     WaterDamage=1.000000
     SoundDamage=1.000000
     SharpPhysicalDamage=1.000000
     BluntPhysicalDamage=1.000000
     VoicePack=Class'CalyGame.VoiceJazzJackrabbit'
     RotationRate=(Pitch=0)
}
