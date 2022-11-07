//=============================================================================
// JazzThinker.
//=============================================================================
class JazzThinker expands JazzPawnAI;


var actor TempGoal, MoveGoal, OldGoal;

// If we are following a leader
var bool bFollow;
// If we are being followed
var bool bFollowed;
// The number of people following us
var int Followers;
// How far away followers will allow themselves to be before they 'whine'
const WhineDistance = 2000;
// How far away from the base we should be when guarding
const BaseRadius = 1000;

var vector AttackLocation;

// Leader of the pack variables
var bool bThunderLand;
var bool bLeader;

// If we have a flag
var bool bHasFlag;

// The flag actor
var CTFFlag TeamFlag;

// The state of the flag that we are looking for should be in
var enum enum_ThinkFlagState {FLAG_OnGround, FLAG_AtBase, FLAG_Carried} FlagState;

// The current mindset of the bot (used for team games)
var enum enum_MindSet {MindSet_GuardBase, MindSet_GuardOther, MindSet_RushBase, MindSet_Wander} MindSet;

// The flag we are looking for
var CTFFlag HuntFlag;

var CTFBase HomeBase;
var CTFBase EnemyBase;

//
// Same as a bot only a cuter name.
//
//
// This class can contain more useful bot functions, however the AI should be placed in JazzPawnAI and share with
// standard Jazz AI systems.  This class is originally meant to be used for organization of subclasses.
//

function PreBeginPlay()
{
	bIsPlayer = true;
	Super.PreBeginPlay();
}

function Killed(pawn Killer, pawn Other, name damageType)
{
	if(FriendTarget != None)
	{
		if(Other == FriendTarget)
		{
			// We lost our leader, so stop following him
			bFollow = false;
			GotoState('Decision');
		}
	}
}

function Whine()
{
	if(IsInState('Wander') || IsInState('RandomWander'))
	{
		GotoState('Wait');
	}
}

function WarnAttack(vector ALocation)
{
	if(Enemy == None)
	{
		AttackLocation = ALocation;
		GotoState('LookAround');
	}
}

function PickUpFlag(CTFFlag Flag)
{
	bHasFlag = true;
	TeamFlag = Flag;
}

function GainLeader(float DrawScaleChange, float JumpZChange, bool bTLand)
{
	// We are now the leader, do stuff
	log(self $ " Gained leader");
	DrawScale *= DrawScaleChange;
	JumpZ *= JumpZChange;
	bThunderLand = bTLand;
	bLeader = true;
	SetCollisionSize(default.CollisionRadius * DrawScaleChange, default.CollisionHeight * DrawScaleChange);
}

function LoseLeader()
{
	// We lost the leader status
	DrawScale = Default.DrawScale;
	JumpZ = default.JumpZ;
	bThunderLand = default.bThunderLand;
	bLeader = false;
	SetCollisionSize(default.CollisionRadius, default.CollisionHeight);
}

function bool CouldSee(Actor Other)
{
	local vector Hitlocation, HitNormal;
	local actor Hit;
	
	Hit = Trace(HitLocation, HitNormal,Other.Location);
	
	if(Hit == None || Hit == Other)
	{
		return true;
	}
	else
	{
		return false;
	}
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
		// If we are in a team game, do not attack if they are on the same team
		if(Level.game.bTeamGame && enemy.playerreplicationinfo.team == playerreplicationinfo.team)
		{
			Enemy = None;
		}
		else if(Enemy.Health <= 0)
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

function string KillMessage(name damageType, pawn Other)
{
	return ( Level.Game.PlayerKillMessage(damageType, Other)$PlayerReplicationInfo.PlayerName );
}

function pawn GainFollower(pawn Other)
{
	if(bFollow)
	{
		return JazzThinker(FriendTarget).GainFollower(Other);
	}
	else
	{
		if(bFollowed)
		{
			Followers++;
		}
		else
		{
			bFollowed = true;
			Followers++;
		}
	
		return self;
	}
}

function LoseFollower(pawn Other)
{
	if(bFollow)
	{
		log(self $ " was following and tried to lose " $ other $ " as a follower");
	}
	else if(!bFollowed)
	{
		log(self $ " was not being followed and tried to lose " $ other $ " as a follower");
	}
	else
	{
		Followers--;
		if(Followers == 0)
		{
			bFollowed = false;
		}
	}
}

function ChangeLeader( pawn NewLeader)
{
	if(NewLeader == None)
	{
		log(self $ " was told to change leader to none");
	}
	else
	{
		JazzThinker(FriendTarget).LoseFollower(Self);
		JazzThinker(NewLeader).GainFollower(Self);
		FriendTarget = NewLeader;
		GotoState('Follow');
	}
}

function GiveFollower( pawn Other)
{
	local JazzThinker Follower;
	
	if(other == None)
	{
		log(self $ " tried to give followers to no one");
		return;
	}
	
	foreach AllActors(class'JazzThinker', Follower)
	{
		if(Follower.bFollow && FriendTarget == Self)
		{
			Follower.ChangeLeader(Other);
			Followers--;
		}
	}
	
	if(Followers != 0)
	{
		log(self $ "Gave followers away and ended up with " $ Followers);
	}
}

function NewPlayerFriend( Pawn Other )
{
	local actor NewFriendTarget;

	if (CanSee( Other ))
	{
		NewFriendTarget = Other;
	}
	else
	{
		NewFriendTarget = None;
		return;
	}
	
	if(Level.Game.bTeamGame)
	{
		if(bFollow && NewFriendTarget == FriendTarget)
		{
			// We are following someone, and our 'newfriend' is that someone
			return;
		}
		
		if(JazzThinker(NewFriendTarget) != None)
		{
			if(CaptureTheFlag(Level.Game) != None)
			{
				if(MindSet != MindSet_Wander)
				{
					// We don't want to follow others around if we are supposed to guard the base
					NewFriendTarget = None;
				}
				else if(JazzThinker(NewFriendTarget).MindSet == MindSet_GuardBase)
				{
					// Don't follow someone who is guarding the base
					NewFriendTarget = None;
				}
			}

			if(NewFriendTarget == None)
			{
				// Place holder so we don't do that other stuff if the CTF code gets rid of 'NewFriendTarget'
			}
			else if(bFollowed)
			{
				// I am being followed
				if(PlayerReplicationInfo.TeamID > JazzThinker(NewFriendTarget).PlayerReplicationInfo.TeamID)
				{
					// Cause all of my followers to follow other
					GiveFollower(pawn(NewFriendTarget));
				}
				else
				{
					// We are of higher rank, ignore the other guy
					NewFriendTarget = None;
				}
			}
			else if(bFollow)
			{
				// I am following
				if(pawn(FriendTarget).PlayerReplicationInfo.TeamID < JazzThinker(NewFriendTarget).PlayerReplicationInfo.TeamID)
				{
					// We are following someone with a better team id, stick with him
					NewFriendTarget = None;
				}
				else
				{
					// We should follow the new guy
					JazzThinker(FriendTarget).LoseFollower(self);
					NewFriendTarget = JazzThinker(NewFriendTarget).GainFollower(Self);
				}
			}
			else
			{
				// I am not following anyone
				if(PlayerReplicationInfo.TeamID > JazzThinker(NewFriendTarget).PlayerReplicationInfo.TeamID)
				{
					// We should follow other
					NewFriendTarget = JazzThinker(NewFriendTarget).GainFollower(Self);
				}
				else
				{
					// We are of higher rank than the other guy, don't follow him
					NewFriendTarget = None;
				}
			}
		}
		
		if(NewFriendTarget != None)
		{
			FriendTarget = NewFriendTarget;
			GotoState('Follow');
		}
	}
	else
	{
		FriendTarget = NewFriendTarget;
	}
}

function vector CheckVect(vector TempVect)
{
	local vector HitLocation, HitNormal;
	local actor HitActor;
		
	HitActor = Trace(HitLocation,HitNormal,TempVect,Location,false);
		
	if(HitActor != None)
	{
		TempVect = HitLocation;
	}
		
	return TempVect;
}

function SeePlayer(actor Seen)
{
	if(Pawn(Seen) != None)
	{
		if(JazzPlayerReplicationInfo(Pawn(Seen).PlayerReplicationInfo).bSpectate)
		{
			// We saw someone, but they're spectating, so leave them alone
			return;
		}
	}	
	
	if (Seen==Enemy)
	{
		return;
	}
	
	// Jazz Player
	//
	if (JazzPlayer(Seen) != None || JazzThinker(Seen) != None)
	{
		switch (AttitudeVsOther(Pawn(Seen)))
		{
		case ATT_Enemy :		NewPlayerAttacker(Pawn(Seen));	break;
		case ATT_Friendly : 	NewPlayerFriend(Pawn(Seen));	break;	// Player is friend - greet or something
		case ATT_Uncaring : 	break;	// Player unimportant - not attacking anyway
		case ATT_Protective : 	break;	// Player only seen, maybe play a threat animation
		case ATT_Scared : 		NewPlayerAfraidOf(JazzPlayer(Seen)); break;	// Run away anyway
		}
	}
}

function AttitudeVal AttitudeVsOther(Pawn Other)
{
	if(Level.Game.bTeamGame)
	{
		if(Other.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
		{
			if(PlayerPawn(Other) != None)
			{
				return ATT_Uncaring;
			}
			else
			{
				return ATT_Friendly;
			}
		}
	}
	
	if(JazzThinker(Other) != None)
	{
		return ATT_Enemy;
	}
	else if(JazzPlayer(Other) != None)
	{
		return ATT_Enemy;
	}
}

function NewPlayerAttacker( Pawn Other )
{
	NewAttack = false;	
	
	// If this is a capture the flag game
	if(CaptureTheFlag(Level.Game) != None)
	{
		// If 'other' is a jazz player
		if(JazzPlayer(Other) != None)
		{
			// If 'other' has our flag, make him our target
			if(JazzPlayer(Other).bHasFlag && JazzPlayer(Other).TeamFlag.TeamNumber == PlayerReplicationInfo.Team)
			{
				Enemy = Other;
			}
		}
		// If 'other' is a jazz thinker (bot)
		else if(JazzThinker(Other) != None)
		{
			// If 'other' has our flag, make it our target
			if(JazzThinker(Other).bHasFlag && JazzThinker(Other).TeamFlag.TeamNumber == PlayerReplicationInfo.Team)
			{
				Enemy = Other;
			}
		}
	}

	if(Enemy != None)
	{
		if(!CanSee(Enemy))
		{
			if (CanSee( Other ))
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
					}
				}
			}
			else
			{
				//CurrentTarget = None;
			}
		}
	}
	else
	{
		if(IntellectCheck(Other))
		{
			if(CourageCheck(Other))
			{
				Enemy = Other;
			}
			else
			{
				AfraidTarget = Other;
			}
		}
	}
	
	if(Enemy != None)
	{
		TriggerNewAttackThink();
	}
}

function TriggerNewAttackThink()
{
	if ((FreezeTime<=0) && (BurnTime<=0) && (PetrifyTime<=0) && (IgnoreAllDecisions==false) && (Health>0))
	{
		GotoState('AttackTarget');	// Override current state - We've been hurt, so make an immediate response!
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// LIFE		 															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
auto state Life
{
	function FindBase()
	{
		local CTFFlag O;

		foreach allactors(class'CTFFlag', O)
		{
			if(O.TeamNumber == PlayerReplicationInfo.Team)
			{
				HomeBase = O.FlagBase;
			}
			else
			{
				EnemyBase = O.FlagBase;
			}
		}	
	}
	
	Begin:
	SetPhysics(PHYS_Walking);
	MinHitWall = -0.5;	
	if(CaptureTheFlag(Level.Game) != none)
	{
		FindBase();
		MindSet = MindSet_GuardBase;
	}
	GotoState('Decision');
}


/////////////////////////////////////////////////////////////////////////////////////
// DYING																STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state Dying
{
ignores SeePlayer, EnemyNotVisible, HearNoise, Died, Bump, Trigger, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, WarnTarget, LongFall, PainTimer;

	function ReStartPlayer()
	{
		if( bHidden && Level.Game.RestartPlayer(self) )
		{
			Velocity = vect(0,0,0);
			Acceleration = vect(0,0,0);
			ViewRotation = Rotation;
			// ReSetSkill();
			SetPhysics(PHYS_Falling);
			ReturnToNormalSkin();
			
			GotoState('Decision');
		}
		else
			GotoState('Dying', 'TryAgain');
	}
	
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		if ( !bHidden )
			Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}
	
	function BeginState()
	{
		local vector Vel;
		
		SetTimer(0, false);
		Enemy = None;
		// AmbushSpot = None;
		bFire = 0;
		bAltFire = 0;

		NewAttacker = None;
		AfraidTarget = None;
		FriendTarget = None;
		NewAttack = false;
		bFollow = false;
		bFollowed = false;
		Followers = 0;
		
		MindSet = MindSet_GuardBase;
		
		if(bHasFlag)
		{
			Vel.X = (FRand()*1000)-500;
			Vel.Y = (FRand()*1000)-500;
		
			Vel.Z = (FRand()*500)+250;
		
			TeamFlag.GotoState('OnGround');
			
			TeamFlag.SetPhysics(PHYS_Falling);
			
			TeamFlag.Velocity = Vel;
		}
		
		bHasFlag = False;
		TeamFlag = None;		
	}

	function EndState()
	{
		if ( Health <= 0 )
			log(self$" health still <0");
	}

Begin:
	Sleep(0.2);
	if ( !bHidden )
	{
		SpawnCarcass();
		HidePlayer();
	}
TryAgain:
	Sleep(0.25 + BattleMode(Level.Game).NumBots * FRand());
	ReStartPlayer();
	Goto('TryAgain');
WaitingForStart:
	bHidden = true;
}

/////////////////////////////////////////////////////////////////////////////////////
// LOOK AROUND															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state LookAround
{
	Begin:
		TurnTo(AttackLocation);
		GotoState('Decision');
}


/////////////////////////////////////////////////////////////////////////////////////
// TAKE HOSTILE ACTION													STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state AttackTarget
{
	event Bump(actor Other)
	{
		if(Other == Enemy)
		{
			GotoState('AttackTarget','Backup');
		}
		else
		{
			GotoState('AttackTarget','MoveAround');
		}
	}
	
	event Touch(actor Other)
	{
		if(Other == Enemy)
		{
			GotoState('AttackTarget','Backup');
		}
		else
		{
			GotoState('AttackTarget','MoveAround');
		}
	}
	
	event HitWall(vector HitNormal, actor HitWall)
	{
		GotoState('AttackTarget','MoveAround');
	}
	
	function DoProjectileAttack(optional bool CheckAccuracy)
	{
		local int	result;
		local vector HitLocation, HitNormal;
		local actor HitPawn;
		
		// If it is a team game, attempt not to shoot someone on our team
		if(Level.Game.bTeamGame)
		{
			HitPawn = Trace(HitLocation, HitNormal, Enemy.Location, Location);		
			
			if(Pawn(HitPawn) != None)
			{
				if(Pawn(HitPawn).PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
				{
					return;
				}
			}
		}
		
		if ((!CheckAccuracy) || (!NeedToTurn(Enemy.Location)))
		{
			if (Weapon != None)
			{
				FireProjectile(0);
			}
			/*
			else
			{
				result = Decide(ProjAttackDesire[0],ProjAttackDesire[1],ProjAttackDesire[2],ProjAttackDesire[3],ProjAttackDesire[4]);
			
				if (result > 0)
					FireProjectile(result-1);
			}
			*/
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
	
	event Timer()
	{
		CheckTargetLife();
		
		if(Enemy == None)
		{
			GotoState('Decision');
			return;
		}
		
		DoProjectileAttack(true);
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
		Angle = atan(Vc.Y / Vc.X)+(3.142857);
		
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
		return(Degrees/360*2*3.142857);
	}
	
	function vector CheckVect(vector TempVect)
	{
		local vector HitLocation, HitNormal;
		local actor HitActor;
		
		HitActor = Trace(HitLocation,HitNormal,TempVect,Location,false);
		
		if(HitActor != None)
		{
			TempVect = HitLocation;
		}
		
		return TempVect;
	}
	
	function EndState()
	{
		Disable('Timer');
		Disable('EnemyNotVisible');
		// log(Name $ " - End State AttackTarget");
	}
	
	function BeginState()
	{
		// Track the enemy's visiblity
		Enable('EnemyNotVisible');
	}
	
	event EnemyNotVisible()
	{
		// log(Name  $ ": Enemy Not Visible");
		
		CheckTargetLife();
		
		// The enemy isn't visible anymore, do something
		if(Enemy == None)
		{
			// log(Name $ " - Leaving AttackTarget because Enemy isn't visible and we have no enemy");
			GotoState('Decision');
			return;
		}
		
		if(Health <= 75 && Enemy.Health > Health)
		{
			// The enemy is in too good of shape, give up
			// FIXME: Make thinker go for health, maybe, don't just go to decision
			// log(Name $ " - Leaving AttackTarget because we can't handle the target");
			GotoState('Decision');
		}
		else
		{
			// We think we can take on the enemy, we just gotta hunt for him
			// log(Name $ " - Leaving AttackTarget because we're hunting down our enemy");
			GotoState('CombatThink','HuntTarget');
		}
	}	
	/////////////////////////////////////////////////////////////////////////////////////
	// GOTO AMBUSH POINT												ATTACK SYSTEM
	//
	AmbushPoint:
		if (FindAmbushPoint()==true)
		{
			PlayRunning();
			MoveToward(TempTarget,RushSpeed);
			Sleep(8);
			GotoState('CombatThink');
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
		GotoState('CombatThink');
	
	/////////////////////////////////////////////////////////////////////////////////////
	// RUSH THE TARGET													ATTACK SYSTEM
	// Fire when TriggerHappy >= Vicious
	//
	RushTarget:
	
		PlayRunning();
		MoveTimer = 1;
	
		for (Temp=TriggerHappy+1; Temp>=0; Temp--)
		{
			MoveToward(Enemy,RushSpeed);
			//Sleep(RushDuration/(float(TriggerHappy)+1)+0.1);
			DoProjectileAttack(false);
		}
	
		Acceleration = vect(0,0,0);
			
		GotoState('CombatThink');
	
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
		GotoState('CombatThink');
	
	/////////////////////////////////////////////////////////////////////////////////////
	// FLANK WHEN RUNNING TOWARDS THE TARGET							ATTACK SYSTEM
	//
	FlankLeft:
		TempVect = VectorDegreeChange(Location,Enemy.Location,-Rad(FRand()*30+15),true,10+FRand()*300);
		
		TempVect = CheckVect(TempVect);
		
		PlayRunning();
		//MoveTimer = FRand()*3+1;
		DoProjectileAttack(true);
		MoveTo(TempVect,RushSpeed);
		
		GotoState('CombatThink');
	
	/////////////////////////////////////////////////////////////////////////////////////
	// DART TO THE LEFT	RELATIVE TO TARGET								ATTACK SYSTEM
	//
	DartLeft:
		TempVect = VectorDegreeChange(Enemy.Location,Location,-Rad(45),true,10+FRand()*400);
		
		TempVect = CheckVect(TempVect);
		
		PlayRunning();
		//MoveTimer = FRand()*3+1;
		DoProjectileAttack(true);
		MoveTo(TempVect,RushSpeed);
		
		GotoState('CombatThink');
	
	/////////////////////////////////////////////////////////////////////////////////////
	// Find a different route											ATTACK SYSTEM
	/////////////////////////////////////////////////////////////////////////////////////
	MoveAround:
	if(NearWall(CollisionRadius*2 + 50))
	{
		if(VSize(Location - Focus) < CollisionRadius)
		{
			Focus = (CollisionRadius * VSize(Location - Focus)) * (Focus - Location) + Location;
		}
	}

	MoveTo(Focus);	
	GotoState('CombatThink');
	
	/////////////////////////////////////////////////////////////////////////////////////
	// Backup while facing the enemy									Attack System
	/////////////////////////////////////////////////////////////////////////////////////
	Backup:
	TempVect = Location + (Vect(-1,0,0) * (FRand() * 100 + 50) >> Rotation);
	TempVect = CheckVect(TempVect);//CALYCHANGE
	
	StrafeTo(TempVect,Enemy.Location);
	GotoState('CombatThink');

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
		GotoState('CombatThink');
	
	Neutral:
	Reverse:
	StrongReverse:
		switch (UseMove(4))
		{
		case 0:		Goto('HoldBack');
		case 1:		Goto('DartLeft');
		}
		Goto('HoldBack');		// Default
		GotoState('CombatThink');
	
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
		if(Enemy != None)
		{
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
			
				// Set up timer for shots
				SetTimer(0.4+FRand()/2,true);
			
				/* // Thinker Code Only
				if (Health/Default.Health < 0.3)
				{
					CurrentAttackStyle = CurrentAttackStyle+1;
					if (Health/Default.Health < 0.1)
					CurrentAttackStyle = CurrentAttackStyle+1;
				}*/
				
				if (CurrentAttackStyle>4) CurrentAttackStyle = 4;
				
				if (TargetDistance < 300)
				{
					// We are close to our target, back up some
					Goto('Backup');
				}
			
				switch (CurrentAttackStyle)
				{
					case 0:		Goto('StrongAdvance'); break;
					case 1:		Goto('Advance'); break;
					case 2:		Goto('Neutral'); break;
					case 3: 	Goto('Reverse'); break;
					case 4: 	Goto('StrongReverse'); break;
				}
			}
			else
			{
				switch (Decide(AmbushPointDesire,0,0,0,0))
				{
					case 0: 	GotoState('Waiting'); break;
					case 1: 	Goto('AmbushPoint'); break;
				}
			}
		}
		
		GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// THINK ABOUT COMBAT - DECIDE IF WE SHOULD CONTINUE ATTACKING		STATES
/////////////////////////////////////////////////////////////////////////////////////
state CombatThink
{
	function WarnOthers()
	{
		local jazzthinker other;
		
		foreach radiusactors(class'JazzThinker', other, BaseRadius, HomeBase.Location)
		{
			if(other.MindSet == MindSet_GuardBase && other.enemy == None)
			{
				other.enemy = enemy;
				other.gotostate('Decision');
			}
		}
	}
	
	Begin:
		// log(Name $ " - Start State: CombatThink");
		CheckTargetLife();
		
		if(CaptureTheFlag(level.game) != None)
		{
			if(MindSet == MindSet_GuardBase && VSize(Location - HomeBase.Location) < BaseRadius)
			{
				WarnOthers();
			}
		}

		if(Enemy != None)
		{
			if (CanSee(Enemy) == true)
			{
				CurrentTargetLostTicks = 0;
				GotoState('AttackTarget');
			}
			else
			{
				CurrentTargetLostTicks += 1;
				//Log("JAZZAI) LostTarget");
				//CurrentTarget = None;
				if (CurrentTargetLostTicks>10)
					Enemy = None;
			}
		}
		
		GotoState('Decision');

	HuntingTarget:
		// Randomly attempt to follow enemy
		if(FRand() < 0.75)
	HuntTarget:
			MoveTo(LastSeenPos);
		// If we get to the last loc and don't see him, give up
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
		local actor Spot;
		local float MinWeight;
		
		Spot = FindBestInventoryPath(MinWeight, false);
		
		if(Spot == None)
		{
			Spot = FindRandomDest(true);
		}
		
		MoveGoal = Spot;
		
		//log("MoveGoal set: " $ MoveGoal);
	}
	
	function bool WanderCheck()
	{
		return (VectorTrace(Destination));
	}
	
	function HearNoise(float Loudness, Actor NoiseMaker)
	{
		//log(class$" heard noise by "$NoiseMaker.class);
		AttackLocation = NoiseMaker.Location;
		GotoState('LookAround');
	}			

	event HitWall( vector HitNormal, actor HitWall )
	{
		GotoState('Wander','Backup');
	}
	
	event Bump(actor Other)
	{
		GotoState('Wander','Backup');
	}	
	
	event Touch(actor Other)
	{
		GotoState('Wander','Backup');
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if(Health <= 0)
		{
			Return;
		}
		
		AttackLocation = instigatedBy.Location;
		NewAttack = true;
		
		GotoState('LookAround');
	}
	
Begin:
	PlayRunning();
	NewWanderLocation();
	
	if (MoveGoal==None)
		GotoState('RandomWander');
	
MoveAlongPath:
	if(Enemy != None)
	{
		// log(Name $ " - Wandering with enemy set");
		GotoState('CombatThink');
	}
	
	TempGoal = FindPathToward(MoveGoal);
	//log("TempGoal: " $ TempGoal);
	MoveToward(TempGoal,RushSpeed);
	
	If(TempGoal != MoveGoal)
		Goto('MoveAlongPath');

	PlayStopped();
	
	GotoState('Decision');
	
Backup:
	if(NearWall(CollisionRadius*2 + 50))
	{
		if(VSize(Location - Focus) < CollisionRadius)
		{
			Focus = (CollisionRadius * VSize(Location - Focus)) * (Focus - Location) + Location;
		}
	}

	MoveTo(Focus);		
	GotoState('Decision');			
}

/////////////////////////////////////////////////////////////////////////////////////
// NOTHINGTODO MOTION - WANDER RANDOMLY									STATES
/////////////////////////////////////////////////////////////////////////////////////
//

state RandomWander
{
	event HitWall( vector HitNormal, actor HitWall )
	{
		GotoState('RandomWander','Backup');
	}
	
	event Bump(actor Other)
	{
		GotoState('RandomWander','Backup');
	}	

	event Touch(actor Other)
	{
		GotoState('RandomWander','Backup');
	}	

	function WanderRandom()
	{
		local float	  Distance;

		Distance = (FRand()+0.4)*WalkingSpeed*3;
		Destination = Location + Distance*VRand();
		Destination.Z = Location.Z;
		
		Destination = CheckVect(Destination);
	}
	
	function HearNoise(float Loudness, Actor NoiseMaker)
	{
		//log(class$" heard noise by "$NoiseMaker.class);
		AttackLocation = NoiseMaker.Location;
		GotoState('LookAround');
	}		
	
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if(Health <= 0)
		{
			Return;
		}
		
		AttackLocation = instigatedBy.Location;
		NewAttack = true;
		
		GotoState('LookAround');
	}

Begin:
	// log(Name $ " - Start State: RandomWander");
	PlaySlowWalk();
	WanderRandom();
	MoveTimer=0;
	MoveTo(Destination,WalkingSpeed);
	PlayStopped();
	GotoState('Decision');
	
Backup:
	/*
	TempVect = Location + (Vect(-1,0,0) * (FRand() * 100 + 50) >> Rotation);
		
	TempVect = CheckVect(TempVect);//CALYCHANGE
		
	StrafeTo(TempVect,Location);
	*/
	if(NearWall(CollisionRadius*2 + 50))
	{
		if(VSize(Location - Focus) < CollisionRadius)
		{
			Focus = (CollisionRadius * VSize(Location - Focus)) * (Focus - Location) + Location;
		}
	}
	
	MoveTo(Focus);			
	GotoState('RandomWander');		
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
	function LookForFlags()
	{
		local CTFFlag O;

		foreach allactors(class'CTFFlag', O)
		{
			if(CouldSee(O) && ((vsize(o.location - location)) < SightRadius))
			{
				if(O.IsInState('OnGround'))
				{
					// Go after flags that are on the ground
					FlagState = FLAG_OnGround;
					HuntFlag = O;
					GotoState('TrackFlag');
					return;
				}
				else if(O.IsInState('Carried'))
				{
					if(O.TeamNumber == PlayerReplicationInfo.Team)
					{
						if(O.Carry != Enemy)
						{
							Enemy = pawn(O.Carry);
							GotoState('AttackTarget');
							return;
						}
					}
				}
				else
				{
					if(O.TeamNumber != PlayerReplicationInfo.Team)
					{
						// Go after other team's flags
						FlagState = FLAG_AtBase;
						HuntFlag = O;
						GotoState('TrackFlag');
						return;						
					}
				}
			}
		}
	}
	
	// Special find flag function that will check for our team flag
	// used to make sure flag hasn't been dropped right next to us when we're running the flag home
	function bool CheckForTeamFlag()
	{
		local CTFFlag O;

		foreach allactors(class'CTFFlag', O)
		{
			if(CouldSee(O) && ((vsize(o.location - location)) < SightRadius))
			{
				if(O.IsInState('OnGround') && O.TeamNumber == PlayerReplicationInfo.Team)
				{
					// Go after flags that are on the ground
					FlagState = FLAG_OnGround;
					HuntFlag = O;
					return true;
				}
				else if(O.IsInState('Carried') && O.TeamNumber == PlayerReplicationInfo.Team)
				{
					FlagState = FLAG_Carried;
					HuntFlag = O;
					return true;
				}
			}
		}
		
		return false;
	}
		
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

	function MakeCombatDecision ( pawn CurrentTarget )
	{
		GotoState('CombatThink');
	}
	
	function MakeAfraidDecision ( pawn CurrentTarget )
	{
		GotoState('AfraidOfTarget');
	}
	
	function MakeFriendDecision ( pawn CurrentTarget )
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
	StateBasedInvulnerability = false;

	// Make sure old targets still exsist	
	CheckTargetLife();
	NewAttitudes();

	// CTF - look for flags and make dicisions based off of them
	if(CaptureTheFlag(Level.Game) != None)
	{
		if(HuntFlag == None && !bHasFlag)
		{
			LookForFlags();
		}
		
		if(bHasFlag)
		{
			if(CheckForTeamFlag())
			{
				if(FLAGSTATE == FLAG_OnGround)
				{
					GotoState('TrackFlag');
				}
				else
				{
					Enemy = pawn(HuntFlag.Carry);
					GotoState('CombatThink');
				}
			}
			else
			{
				GotoState('ReturnToBase');
			}
		}
		
		if(HuntFlag != None)
		{
			GotoState('TrackFlag');
		}
	}

	// If we have an enemy, go after 'em	
	if(Enemy != None && CurrentTargetLostTicks == 0)
	{
		GotoState('CombatThink');
	}
	
	// If we are following someone, follow them
	if(bFollow)
	{
		GotoState('Follow');
	}
	
	// Item Greed Check
	//
	GreedCheck();
	VicinityObjectCheck();

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
		if (CanSee(pawn(AfraidTarget)) == true)
		{
			MakeAfraidDecision(pawn(AfraidTarget));
		}
		else
		{
			AfraidTarget = None;
		}
	}

	// Do we have a target?
	if (Enemy != None)
	{
		if (CanSee(Enemy) == true)
		{
			CurrentTargetLostTicks = 0;
			MakeCombatDecision(Enemy);
		}
		else
		{
			CurrentTargetLostTicks += 1;
			//Log("JAZZAI) LostTarget");
			//CurrentTarget = None;
			if (CurrentTargetLostTicks>10)
				Enemy = None;
				}
	}
	
	//Sleep(1);		// Originally here to avoid infinite Decision loop
	
	// CTF - Do actions based on our current mindset
	if(CaptureTheFlag(Level.Game) != None)
	{
		switch(MindSet)
		{
			case MindSet_GuardBase:
				// We want to hang around the base and defend
				GotoState('GuardBase');
			break;
			case MindSet_GuardOther:
				// We want to guard another player
			break;
			case MindSet_RushBase:
				// We want to go in and attack the other base
				GotoState('RushBase');
			break;
			case MindSet_Wander:
				// We just want to lollygag around
				GotoState('Wander');
			break;
		}
	}	
	
	DoNothing();	
}

state Follow
{
	function NewFollowLocation()
	{
		local float	  Distance;

		Distance = FRand()*200 + 100;
		Destination = FriendTarget.Location + Distance*VRand();
		Destination.Z = FriendTarget.Location.Z;

		Destination = LocationCheck(FriendTarget,Destination);			
	}
	
	function vector LocationCheck(actor Leader, vector Dest)
	{
		local vector HitLocation, HitNormal;
		local actor Hit;
		
		Hit = Trace(HitLocation, HitNormal, Dest, Leader.Location);
		
		if(Hit != None)
		{
			Dest = HitLocation;
		}
		
		return Dest;
	}
	
	event Tick(float DeltaTime)
	{
		if(FriendTarget != None)
		{
			if(pawn(FriendTarget).Enemy != None && Enemy == None)
			{
				Enemy = pawn(FriendTarget).Enemy;
				GotoState('CombatThink');
			}
		}
	}
	
	function bool CheckLoc(vector Dest)
	{
		if(VSize(Dest - FriendTarget.Location) > WhineDistance/4)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	event HitWall( vector HitNormal, actor HitWall )
	{
		GotoState('Follow','Backup');
	}
	
	event Bump(actor Other)
	{
		if(pawn(Other) != None)
		{
			GotoState('Follow','Backup');
		}
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if(Health <= 0)
		{
			Return;
		}
		
		AttackLocation = instigatedBy.Location;
		NewAttack = true;
		
		JazzThinker(FriendTarget).WarnAttack(AttackLocation);
	}

	function HearNoise(float Loudness, Actor NoiseMaker)
	{
		//log(class$" heard noise by "$NoiseMaker.class);
		JazzThinker(FriendTarget).HearNoise(Loudness, NoiseMaker);
	}		

	Begin:
		// log(Name $ " - Start State: Follow");
		NewFollowLocation();
		
		// Make some decisions based on CTF
		if(CaptureTheFlag(Level.Game) != None)
		{
			switch(MindSet)
			{
				case MindSet_GuardBase:
					if(VSize(Location - HomeBase.Location) < BaseRadius)
					{
						FriendTarget = None;
					}
					else if( FriendTarget.IsA('JazzThinker') )
					{
						FriendTarget = None;
					}
					else if( JazzThinker(FriendTarget).MindSet != MindSet_GuardBase)
					{
						FriendTarget = None;
					}
				break;
			}
	
			if(FriendTarget == None)
			{
				GotoState('Decision');
			}
		}
		
		if(VSize(FriendTarget.Location - Location) > WhineDistance)
		{
			jazzThinker(FriendTarget).Whine();
		}

	Following:
		MoveTimer=-1.0;
		
		TempGoal = FindPathTo(Destination);
		
		if(TempGoal != None)
		{
			MoveToward(TempGoal,RushSpeed);
		}
		else
		{
			MoveTo(Destination, RushSpeed);
			Goto('Begin');
		}
		
		if(CheckLoc(Destination))
		{
			Goto('Following');
		}
		else
		{
			Goto('Begin');
		}
		
		Backup:
		/*
		TempVect = Location + (Vect(-1,0,0) * (FRand() * 100 + 50) >> Rotation);
		
		TempVect = CheckVect(TempVect);//CALYCHANGE
		
		StrafeTo(TempVect,Location);
		*/
		if(NearWall(CollisionRadius*2 + 50))
		{
			if(VSize(Location - Focus) < CollisionRadius)
			{
				Focus = (CollisionRadius * VSize(Location - Focus)) * (Focus - Location) + Location;
			}
		}
		
		MoveTo(Focus,WalkingSpeed);
}

///////////////////////////////////////////////////////////////////////////////////
// GuardBase - Guard the base from attackers							STATES
///////////////////////////////////////////////////////////////////////////////////
//
state GuardBase
{
	function Bump(actor Other)
	{
		GotoState('GuardBase','Backup');
	}
	
	function Touch(actor Other)
	{
		GotoState('GuardBase','Backup');
	}
	
	function HitWall(vector HitNormal, actor HitWall)
	{
		GotoState('GuardBase','Backup');
	}
	
	function WanderRandom()
	{
		local float	  Distance;

		Distance = (FRand()+0.4)*WalkingSpeed*3;
		Destination = Location + Distance*VRand();
		Destination.Z = Location.Z;
		
		Destination = CheckVect(Destination);
	}
	
	function HearNoise(float Loudness, Actor NoiseMaker)
	{
		//log(class$" heard noise by "$NoiseMaker.class);
		AttackLocation = NoiseMaker.Location;
		GotoState('LookAround');
	}
	
	function CheckMindSets()
	{
		local int TeamFound,TeamTotal,RushNum;
		local JazzThinker Other;
		
		TeamFound = 0;
		TeamTotal = 0;
		
		foreach allactors(class'JazzThinker',Other)
		{
			if(Other.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
			{
				TeamTotal++;
				
				if(VSize(Other.Location - HomeBase.Location) < BaseRadius*1.1 && Other.MindSet == MindSet_GuardBase)
				{
					TeamFound++;
				}
			}
		}
		
		// If at least 60% of the team is at the base
		if(TeamFound > 0.6*TeamTotal)
		{
			// We'll send 50% of thouse at the base to capture the other flag
			RushNum = TeamFound/2;
			
			if(RushNum > 0)
			{
				SendRush(RushNum);
			}
		}
	}
	
	function SendRush(int RushNum)
	{
		local JazzThinker Other;
		
		foreach allactors(class'JazzThinker',Other)
		{
			if(RushNum > 0)
			{
				if(Other.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
				{
					if(VSize(Other.Location - HomeBase.Location) < BaseRadius*1.1 && Other.MindSet == MindSet_GuardBase)
					{
						Other.MindSet = MindSet_RushBase;
						RushNum--;
					}
				}
			}
		}
	}		
	
	Begin:
		if(VSize(Location - HomeBase.Location) > BaseRadius || !CouldSee(HomeBase))
		{
			// We are too far away from base, get back there
			Goto('ReturnBase');
		}
		else
		{
			// We're near base, wander a bit so we don't look like idiots and also to look around us
			Goto('Wander');
		}
		
	ReturnBase:
		TempGoal = FindPathToward(HomeBase);
		MoveToward(TempGoal,RushSpeed);
		GotoState('Decision');
		
	Wander:
		PlaySlowWalk();
		WanderRandom();
		MoveTimer=0;
		MoveTo(Destination,WalkingSpeed);
		PlayStopped();

		if(Frand() < 0.07)
		{
			CheckMindSets();
		}
		
		GotoState('Decision');

	Backup:
		if(NearWall(CollisionRadius*2 + 50))
		{
			if(VSize(Location - Focus) < CollisionRadius)
			{
				Focus = (CollisionRadius * VSize(Location - Focus)) * (Focus - Location) + Location;
			}
		}
	
		MoveTo(Focus);
		GotoState('Decision');
}

///////////////////////////////////////////////////////////////////////////////////
// ReturnToBase - Go back to our base with a flag						STATES
///////////////////////////////////////////////////////////////////////////////////
//
state ReturnToBase
{
	Begin:
		OldGoal = TempGoal;
		TempGoal = FindPathToward(HomeBase);
		
		if(!bHasFlag)
		{
			MindSet = MindSet_GuardBase;
		}
		
		if(TempGoal != OldGoal)
		{
			MoveToward(TempGoal,RushSpeed);
		}
		else
		{
			MoveToward(HomeBase,RushSpeed);
		}
		GotoState('Decision');	
}

///////////////////////////////////////////////////////////////////////////////////
// RushBase - Attack the enemy's base									STATES
///////////////////////////////////////////////////////////////////////////////////
//
state RushBase
{
	function CheckFlag()
	{
		local CTFFlag EnemyFlag;
		local vector HitLocation, HitNormal;
		local actor Hit;
		local bool bFound;
		
		bFound = false;
		
		foreach RadiusActors(class'CTFFlag', EnemyFlag, 50, EnemyBase.Location)
		{
			if(EnemyFlag.TeamNumber != PlayerReplicationInfo.Team)
			{
				bFound = true;
			}
		}
		
		if(bFound == false)
		{
			Hit = Trace(HitLocation,HitNormal, EnemyBase.Location, Location, false);
			
			if(Hit == None)
			{
				MindSet = MindSet_GuardBase;
			}
		}
	}
	Begin:
		OldGoal = TempGoal;
		
		if(CaptureTheFlag(Level.Game) != None)
		{
			// Make sure the enemies flag is at their base (if we can see it, that is)
			CheckFlag();
		}

		TempGoal = FindPathToward(EnemyBase);
		if(TempGoal != OldGoal)
		{
			MoveToward(TempGoal,RushSpeed);
		}
		else
		{
			MoveToward(EnemyBase,RushSpeed);
		}
		MoveToward(EnemyBase,RushSpeed);
		GotoState('Decision');	
}


///////////////////////////////////////////////////////////////////////////////////
// TackFlag - Track down a flag											STATES
///////////////////////////////////////////////////////////////////////////////////
//
state TrackFlag
{
	function CheckFlag()
	{
		if(HuntFlag.IsInState('Carried'))
		{
			// Someone, maybe us, has the flag, don't hunt it down anymore
			HuntFlag = None;
		}
		else if(HuntFlag.IsInState('OnGround') && FlagState != FLAG_OnGround)
		{
			// The flag is on the ground, and we aren't looking for a flag on the ground
			
			// Note: this situation should be impossible to come by
			
			HuntFlag = None;
		}
		else if(FlagState != FLAG_AtBase && !(HuntFlag.IsInState('OnGround') || HuntFlag.IsInState('Carried')))
		{
			// The flag is at it's base and we aren't looking for a flag at a base
			HuntFlag = None;
		}
	}
	
	Begin:
		// Make sure the flag is still in the state we want it to be
		CheckFlag();
		if(HuntFlag != None)
		{
			OldGoal = TempGoal;
			TempGoal = FindPathToward(HuntFlag);
			if(TempGoal != OldGoal)
			{
				MoveToward(TempGoal,RushSpeed);
			}
			else
			{
				MoveToward(HuntFlag,RushSpeed);
			}
			Goto('Begin');			
		}
		else
		{
			GotoState('Decision');
		}
}

///////////////////////////////////////////////////////////////////////////////////
// Wait - Waiting for a follower to catch up							STATES
///////////////////////////////////////////////////////////////////////////////////
//
state Wait
{
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		if(Health <= 0)
		{
			Return;
		}
		
		AttackLocation = instigatedBy.Location;
		NewAttack = true;
		
		GotoState('LookAround');
	}
	
	function HearNoise(float Loudness, Actor NoiseMaker)
	{
		//log(class$" heard noise by "$NoiseMaker.class);
		AttackLocation = NoiseMaker.Location;
		GotoState('LookAround');
	}	
	
	Begin:
		Velocity = vect(0,0,0);
		Sleep(2*FRand());
		GotoState('Decision');	
}

defaultproperties
{
     Courage=COU_Strong
     TriggerHappy=INT_Vicious
     AmbushPointDesire=3
     RushDuration=2.000000
     WalkingSpeed=300.000000
     RushSpeed=600.000000
     FindFriendDesire=2
     WanderDesire=6
     WanderRange=2.000000
     WaitingDesire=3
     GoHidePointDesire=10
     GoAmbushPointDesire=10
     RunDesire=2
     HideDesire=8
     CanPickupItems=True
     GreedOverrideWaiting=1.000000
     GreedOverrideHostility=70.000000
     ScoreForDefeating=100
     ExperienceForDefeating=20
     DeathEffect=Class'CalyGame.JazzParticles'
     bFreezeable=True
     bPetrify=True
     PlayerReplicationInfoClass=Class'CalyGame.JazzPlayerReplicationInfo'
     bStasis=False
     DrawType=DT_Mesh
     Mesh=Mesh'UnrealI.Female2'
     DrawScale=3.000000
     CollisionRadius=50.000000
     CollisionHeight=120.000000
     RotationRate=(Pitch=8000,Roll=8000)
}
