//=============================================================================
// JazzPawn.
//=============================================================================
class JazzPawn expands Pawn;

//=============================================================================
// Contains global information and functions for the Jazz pawn.
//

var(JInteract) bool			Activateable;			// Can be 'activated' - used for conversations
var(JInteract) class		DefaultConversation;	// This is the default conversation.  Actually, other scripts could be used.
var(JInteract) name			ConversationTag;		// Set a conversation to use.
var				bool		Conversing;

var(JAttack) class			BaseJazzPawnWeapon;		// Pawn is given this weapon when starting

var(Display) bool			FatnessReversed;		// Set true if the mesh responds inverse to the fatness rating

var(JScore) int				ScoreForDefeating;
var(JScore)	int				ExperienceForDefeating;
var(JScore) bool			IsBoss;					// Set true to have boss meter and other stuff displayed.

var(JDeath) class			DeathEffect;
var(JDeath)	class<carcass>	DeathCarcass;
var(JDeath) name			DeathTriggerTag;		// Trigger actors matching this when dead.
//var(JDeath) sound			DeathSound;

var(JTouch) int  			JumpOnDamage;
var(JTouch) bool 			JumpOnTakeDamage;
var(JTouch) int  			JumperDamage;
var(JTouch) bool 			JumperTakeDamage;
var(JTouch) class 			JumpedOnEffect;
var(JTouch) float 			JumpedOnEffectPitch;
var(JTouch) class 			JumpedOnDeathEffect;

var(JTouch) int  			TouchedDamage;
var(JTouch) bool 			TouchedTakeDamage;
var(JTouch) int  			ToucherDamage;
var(JTouch) bool 			ToucherTakeDamage;
var(JTouch) class 			TouchedDamageEffect;	// This actor hurt by touching
var(JTouch) class 			TouchedDeathEffect;		// This actor killed by touching

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
var(JDamage)	bool	SoundAnimation;	// Goto state SoundDamage if hit
//var(JDamage)	sound	PlinkSound;		// Sound if no damage taken from attack
var				float	LastDamageAmount;

// Items to drop
//
var(JItems)		class	DropItemFirstHit;
var(JItems)		class	DropItemHealth75Pct;
var(JItems)		class	DropItemHealth50Pct;
var(JItems)		class	DropItemHealth25Pct;
var(JItems)		class	DropItemDead;

// Freeze Variables
var(JDamage)	bool	bFreezeable;
var				float	FreezeTime;
var vector SlideVelocity;

// Burn Variables
var(JDamage)	bool	bBurnable;
var				float	BurnTime;

// Petrify Variables
var(JDamage)	bool	bPetrify;
var				float	PetrifyTime;

// Bubble Variables
var(JDamage)	bool	bBubbleable;
var				float	BubbleTime;

// Default skin override - Ex: Multiplayer bot skins
var				texture BaseSkin;

var float LastBumpTime;

///////////////////////////////////////////////////////////////////////////////////////////
// Sounds																VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//
// VoicePack
var()		class				VoicePack;
var			JazzVoicePack		VoicePackActor;

///////////////////////////////////////////////////////////////////////////////////////////
// Inventory / Etc.
///////////////////////////////////////////////////////////////////////////////////////////
//
// Inventory Amounts
//
var travel int		Carrots;	// Currency, of one form or another - currently money
var travel int		Keys;		// # of keys or key pieces
var travel Inventory	InventorySelections[5];		// Item currently selected in each group type - written to from JazzHUD
				// InventorySelections needs the be saved along with the player data

///////////////////////////////////////////////////////////////////////////////////////////
// Multiplayer Game Variables											VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//
// How many gems the player has (used for Treasure Hunt mode)
var		int			GemNumber;
// If the player has the key (used for Treasure Hunt mode)
var		bool		TreasureKey;
// The time the player spent in the level
var		float		TreasureTime;
// If the player has finished or not (used for Treasure Hunt mode)
var		bool		TreasureFinish;

//////////////////////////////////////////////////////////////////////////////////////
// Pawn Scripting													INITIALIZATION
//////////////////////////////////////////////////////////////////////////////////////
//
var (PawnScript) string PawnScripting[100];

var		int			CurrentLine;
var		int			iParam;

function GotoLabel(string Label)
{
	local string Command, Param;
	local int i, l;
	
	l = -1;
	
	while(!(Param ~= Label))
	{
	
		while(!(Command ~= "Lbl"))
		{
			i = 0;
			l++;
	
			// Find the command
			while(mid(PawnScripting[l],i, 1) != " ")
			{
				command = Command $ mid(PawnScripting[l],i,1);
				i++;
			}
			
			if(Command ~= "End")
			{
				log("PawnScript Error: " $ self $ " - Can not find Label " $ Label);
				return;
			}
		}
	
		// Skip to the start of the parameter
		while(mid(PawnScripting[l], i, 1) != "'")
		{
			i++;
		}
		i++;
	
		// Find parameter
		while(mid(PawnScripting[l], i, 1) != "'")
		{
			Param = Param $ mid(PawnScripting[l],i,1);
			i++;
		}
	}
	
	CurrentLine = l;
}

function ParseLine()
{
	local string Command, Param;
	local int i;
	
	i = 0;
	
	// Find the command
	while(mid(PawnScripting[CurrentLine],i, 1) != " ")
	{
		Command = Command $ mid(PawnScripting[CurrentLine],i,1);
		i++;
	}
	
	// Skip to the start of the parameter
	while(mid(PawnScripting[CurrentLine], i, 1) != "'")
	{
		i++;
	}
	i++;
	
	// Find parameter
	while(mid(PawnScripting[CurrentLine], i, 1) != "'")
	{
		Param = Param $ mid(PawnScripting[CurrentLine],i,1);
		i++;
	}
	
	if(Command ~= "Lbl")
	{
		// Label command
		
		// Argument - Name of Label
	
		// Does not activly do anything, just ignore
	}
	else if(Command ~= "Goto")
	{
		// Goto command
		
		// Argument - Label to go to
		
		// Move the current line to the corrosponding Lbl
		
		GotoLabel(Param);
		return;
	}
	else if(Command ~= "MoveAlong")
	{
		// MoveAlong command
		
		// Argument - Point to move to
		
		// Moves the pawn to a point follow pathnodes
	}
	else if(Command ~= "MoveTo")
	{
		// MoveTo command
		
		// Argument - Point to move to
		
		// Moves to pawn directly toward the given point
	}
	else if(Command ~= "RunAlong")
	{
		// RunAlong command
		
		// Argument - Point to run to
		
		// Moves the pawn to a point following pathnodes at the running speed
	}
	else if(Command ~= "RunTo")
	{
		// RunTo command
		
		// Argument - Point to run to
		
		// Moves the pawn directly to the point at the running speed
	}
	else if(Command ~= "TurnTo")
	{
		// TurnTo command
		
		// Argument - Point to face
		
		// Turns the pawn to face the give point
	}
	else if(Command ~= "PlayAnim")
	{
		// PlayAnim command
		
		// Argument - The animation to play
		
		// Plays the given animation (continuing the script after it has played)
	}
	else if(Command ~= "LoopAnim")
	{
		// LoopAnim command
		
		// Argument - The animation to play
		
		// Plays the given animation over and over
	}
	else if(Command ~= "PlaySound")
	{
		// PlaySound command
		
		// Argument - The sound to play
		
		// Plays the sound (does not pause scripting)
	}
	else if(Command ~= "LoopSound")
	{
		// LoopSound command
		
		// Argument - The sound to play
		
		// Loops the given sound continuously
	}
	else if(Command ~= "Wait")
	{
		// Wait command
		
		// Argument - The time to wait
		
		// Pauses the pawn for the give amount of seconds
		
		iParam = Asc(Param);
		
		GotoState('RunningPawnScript', 'Wait');
		return;
	}
	else if(Command ~= "RandomPick")
	{
		// RandomPick command
		
		// Argument - The number of lines to select from
		
		// Randomly jumps to a line within the given number
		
		iParam = Asc(Param);
		
		i = Rand(iParam - 1) + 1;
		
		CurrentLine += i;
		
		GotoState('RunningPawnScript', 'Parser');
		return;
	}
	else if(Command ~= "RandomWander")
	{
		// RandomWander command
		
		// Argument - The time to randomly wander around
		
		// Causes the pawn to randomly wander around the level for the given amount of seconds
	}
	else if(Command ~= "WaitForPlayer")
	{
		// WaitForPlayer command
		
		// Argument - None
		
		// Pauses the script until the (or a) player is visible
	}
	else if(Command ~= "Approach")
	{
		// Approach command
		
		// Argument - The pawn to approach
		
		// Causes the pawn to move toward the given pawn
	}
	else if(Command ~= "StartConversation")
	{
		// StartConversation command
		
		// Argument - The pawn to converse with
		
		// Starts this pawn's conversation with the given pawn
	}
	else if(Command ~= "EndScript")
	{
		// EndScript command
		
		// Argument - What to do when reached
		
		// If argument is 'loop' current line goes to the start of the script
		// If argument is 'stop' Ends the scripting system
		// If there is no argument - will give an error
		
		if(Param ~= "loop")
		{
			GotoState('RunningPawnScript', 'Begin');
			return;
		}
		else if(Param ~= "stop")
		{
			GotoState('RunningPawnScript', 'End');
			return;
		}
		else
		{
			Log("PawnScript Error: " $ self  $ " - End has unkown argument");
		}
	}
	else
	{
		log("PawnScript Error: " $ self $ " - Unkown command at line " $ CurrentLine);
	}
	
	GotoState('RunningPawnScript', 'ContinueScript');
}

state RunningPawnScript
{
	Begin:
		CurrentLine = 0;
	Parser:
		ParseLine();
	ContinueScript:
		CurrentLine++;
		Goto 'Parser';
	Wait:
		Sleep(iParam);
	End:
}

//////////////////////////////////////////////////////////////////////////////////////
// BeginPlay														INITIALIZATION
//////////////////////////////////////////////////////////////////////////////////////
//
function BeginPlay ()
{
	Super.BeginPlay();

	// Voice Pack System Initialize
	VoicePackActor = JazzVoicePack(spawn(class<actor>(VoicePack)));
	//Log("VoicePack) "$Self$" "$VoicePackActor);
	
	// Spawn new weapon and give to Pawn AI
	if (BaseJazzPawnWeapon != None)
	{
		Weapon = Weapon(spawn(class<actor>(BaseJazzPawnWeapon)));
		Weapon.GiveTo(Self);
		//Log("New Weapon) "$Weapon);
	}
}

//////////////////////////////////////////////////////////////////////////////////////
// Skin Return														PAWN SPECIAL
//////////////////////////////////////////////////////////////////////////////////////
//
// If the skin is changed, this function returns it to the normal default value, either
// set in BaseSkin or Default.Skin.
//
function ReturnToNormalSkin()
{
	if (BaseSkin != None)
	{
		Skin = BaseSkin;
	}
	else
	{
		Skin = Default.Skin;
	}
}

/////////////////////////////////////////////////////////////////////////////////
// NearWall() returns true if there is a nearby barrier at eyeheight, and 
// changes Focus to a suggested value
/////////////////////////////////////////////////////////////////////////////////
function bool NearWall(float walldist)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, ViewSpot, ViewDist, LookDir;

	LookDir = vector(Rotation);
	ViewSpot = Location + BaseEyeHeight * vect(0,0,1);
	ViewDist = LookDir * walldist; 
	HitActor = Trace(HitLocation, HitNormal, ViewSpot + ViewDist, ViewSpot, false);
	if ( HitActor == None )
		return false;

	ViewDist = Normal(HitNormal Cross vect(0,0,1)) * walldist;
	if (FRand() < 0.5)
		ViewDist *= -1;

	HitActor = Trace(HitLocation, HitNormal, ViewSpot + ViewDist, ViewSpot, false);
	if ( HitActor == None )
	{
		Focus = Location + ViewDist;
		return true;
	}

	ViewDist *= -1;

	HitActor = Trace(HitLocation, HitNormal, ViewSpot + ViewDist, ViewSpot, false);
	if ( HitActor == None )
	{
		Focus = Location + ViewDist;
		return true;
	}

	Focus = Location - LookDir * 300;
	return true;
}

//////////////////////////////////////////////////////////////////////////////////////
// Bubble															Pawn Special
//////////////////////////////////////////////////////////////////////////////////////
//
function Bubble()
{
	if(bBubbleable)
	{
		BubbleTime = 5;
		
		GotoState('Bubbled');
	}
}

State Bubbled
{
	function BeginState()
	{
		SetPhysics(PHYS_Walking);
		AnimRate = 0;
		Spawn(class'BubbledEffect',Self);		
		// Spawn()
	}
	
	function EndState()
	{
		local BubbledEffect Bubble;
		
		foreach ChildActors(class'BubbledEffect',Bubble)
		{
			Bubble.Destroy();
		}
		
		PlayWaiting();
		ReturnToNormalSkin();		
	}
	
	event Tick(float DeltaTime)
	{
		BubbleTime -= DeltaTime;
		
		Acceleration /= 1.35;

		if(BubbleTime <= 0)
		{
			Gotostate('Decision');
		}
	}

	function Bump( actor Other)
	{
		if(PlayerPawn(Other) != None)
		{
			Acceleration += (Other.Velocity / 0.4);
			// Velocity += (Other.Velocity / 3);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////
// Freeze															PAWN SPECIAL
//////////////////////////////////////////////////////////////////////////////////////
//
function Freeze(optional int Level)
{
	if(bFreezeable)
	{
		switch(Level)
		{
			case 0:	FreezeTime = 1;	break;
			case 1:	FreezeTime = 1;	break;
			case 2:	FreezeTime = 2;	break;
			case 3:	FreezeTime = 3;	break;
			case 4:	FreezeTime = 4;	break;
			case 5:	FreezeTime = 5;	break;
		}
		
		GotoState('Frozen');
	}
}

state Frozen
{
	function BeginState()
	{
		SetPhysics(PHYS_Walking);
		// FIXME: Needs package prefix to compile
		//Skin = texture'NWater2';
		AnimRate = 0;
	}
	
	function EndState()
	{
		PlayWaiting();
	}
	
	function Burn(optional int Level)
	{
		GotoState('Decision');
	}
	
	event Tick(float DeltaTime)
	{
		FreezeTime -= DeltaTime;
		
		Acceleration /= 1.35;

		if(FreezeTime <= 0)
		{
			ReturnToNormalSkin();
			Gotostate('Decision');
		}
	}

	function Bump( actor Other)
	{
		if(PlayerPawn(Other) != None)
		{
			Acceleration += (Other.Velocity / 0.4);
			// Velocity += (Other.Velocity / 3);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////
// Burning															PAWN SPECIAL
//////////////////////////////////////////////////////////////////////////////////////
//
function Burn(optional int Level)
{
	if(bBurnable)
	{
		switch(Level)
		{
			case 0:
				BurnTime = 10;
			break;
		}
		
		GotoState('Burning');
	}
}

state Burning
{
	function BeginState()
	{
		SetPhysics(PHYS_Walking);
		spawn(class'JazzFireEffect',self);
		PlayAnim(AnimSequence,0);
		SetTimer(1.0,true);
	}
	
	event Timer()
	{
		//TODO: Take fire damage
	}
	
	event Tick(float DeltaTime)
	{
		BurnTime -= DeltaTime;

		if(BurnTime <= 0)
		{
			Gotostate('Decision');
		}
	}
	
	function Freeze(optional int Level)
	{
		GotoState('Decision');
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


//////////////////////////////////////////////////////////////////////////////////////
// Petrify															PAWN SPECIAL
//////////////////////////////////////////////////////////////////////////////////////
//
function Petrify(optional int Level)
{
	if(bPetrify)
	{
		switch(Level)
		{
			case 0:
				PetrifyTime = 15;
			break;
		}

		GotoState('Petrified');	
	}
}

state Petrified
{
ignores TakeDamage;

	function Burn(optional int Level);
	function Freeze(optional int Level);

	function BeginState()
	{
		SetPhysics(PHYS_Falling);
		Acceleration = vect(0,0,0);
		// FIXME: Needs package prefix to compile
		//Skin = texture'NRock';		
		PlayAnim(AnimSequence,0);
	}
	
	event Tick(float DeltaTime)
	{
		PetrifyTime -= DeltaTime;

		if(PetrifyTime <= 0)
		{
			ReturnToNormalSkin();
			Gotostate('Decision');
		}
	}

	function Bump( actor Other)
	{

	}
}


//////////////////////////////////////////////////////////////////////////////////////
// Physical Touch
//
function Bump( actor Other )
{
	if (LastBumpTime<Level.TimeSeconds-0.5)
	{
	DetermineTypeOfBump(Pawn(Other));
	LastBumpTime = Level.TimeSeconds;		// Bumps within 0.5 seconds of each other will be ignored
	}
}

///////// Enemy was touched
//
// Determine if jumped on or just touched from the side
//
function DetermineTypeOfBump( pawn Other )
{
	local	vector	LocationA,LocationB;
	
	LocationA = Location;	LocationA.Z = 0;
	LocationB = Other.Location;		LocationB.Z = 0;
	
	if (Other==None) return;
	
	// Jumped On?
	//
	if (JazzPlayer(Other)!=None)
	{
	//Log("JumpCheck) "$Location.Z+CollisionHeight$" "$Other.Location.Z);
	if  (
		(CollisionRadius*1.8>VSize(LocationA-LocationB)) 	// Within actor size?
		&&
		(Location.Z+CollisionHeight<Other.Location.Z)						// Underneath touching actor?
		)
	{
		HitByJumping(Other);
	}
	else
	// Touched from side or underneath?
	// 
	{
		HitByTouching(Other);
	}
	}
}

///////// Enemy was run into or underneath - Hurt player
//
//
//
function HurtPlayer( JazzPlayer Other, int Damage, int VelocityBash )
{
	local vector VelocityModify;
	
	if (Other != NONE)
	{
		Other.TakeDamage(Damage,self,self.Location,vect(0,0,0),'Touched');
		VelocityModify = VelocityBash*(Normal(Other.Location-Location));
		VelocityModify.Z = VelocityBash*3;
		Other.SetPhysics(PHYS_Falling);
		Other.Velocity = VelocityModify;
	}
}

///////// Enemy was jumped on
//
// Takes 'JumpingDamage' points of damage
//
function HitByJumping( pawn Other )
{
	local vector NewLocation;

	if (Other != None)
	{
		if (JumpOnTakeDamage)
		{
		//Log("JazzChar) JumpedOn BouncePlayer");
		
		//JazzPlayer(Other).Velocity.Z = 200;
		
		// Use a latent bounce
		JazzPlayer(Other).LatentBounce = 400;
		JazzPlayer(Other).LatentBounceDo = true;
		
/*		Other.Velocity.Z = abs(Other.Velocity.Z)*2;
		Other.SetLocation(Other.Location + vect(0,0,50));
		Other.SetPhysics(PHYS_Falling);*/
		//Log("JAZZAI) JumpOn "$Other.Velocity.Z);
		//
		
		TakeDamage(JumpOnDamage,Other,Other.Location,vect(0,0,0),'JumpedOn');
		PlayHit(JumpOnDamage,vect(0,0,0),'JumpedOn',0);
		}
		
		if (JumperTakeDamage)
		{
		HurtPlayer( JazzPlayer(Other), JumperDamage, 100 );
		}
	}
}

function HitByTouching ( pawn Other )
{
	if (Other != None)
	{
		if (TouchedTakeDamage)
		{
		TakeDamage(100,Other,Other.Location,vect(0,0,0),'Touched');
		PlayHit(TouchedDamage,vect(0,0,0),'Touched',0);
		}
		
		if (ToucherTakeDamage)
		{
		//Log("JazzChar) ToucherDamage "$ToucherDamage$" "$JazzPlayer(Other));
		HurtPlayer( JazzPlayer(Other), ToucherDamage, 100 );
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////
// Damage Control System
//
function PlayHit(float Damage, vector HitLocation, name damageType, float MomentumZ)
{
	local float rnd;
	local WaterBubble bub;
	local bool bOptionalTakeHit;
	local vector BloodOffset;
	local rotator BloodRotate;

	if (Damage > 1) //spawn some damage effect
	{
		switch (DamageType)
		{
		case 'Drowned':
			bub = spawn(class 'WaterBubble',,, Location 
				+ 0.7 * CollisionRadius * vector(ViewRotation) + 0.3 * EyeHeight * vect(0,0,1));
			if (bub != None)
				bub.DrawScale = FRand()*0.06+0.04;
		break;
		
		case 'JumpedOn':
			//BloodOffset = 0.2 * CollisionRadius * Normal(HitLocation - Location);
			//BloodOffset.Z = BloodOffset.Z * 0.5;
			//spawn(class<actor>(JumpedOnEffect),,,hitLocation);
			BloodRotate.Pitch = JumpedOnEffectPitch;
			spawn(class<actor>(JumpedOnEffect),,,Location,BloodRotate);
		break;
		}
	}	

	if ( (Weapon != None) && Weapon.bPointing && !bIsPlayer )
	{
		bFire = 0;
		bAltFire = 0;
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// DAMAGE	 															EVENT
/////////////////////////////////////////////////////////////////////////////////////
//
// JAZZ3 Types of Damage:
//
// Energy - Conventional energy weapons.
// Fire
// Water
//
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	local float HealthPct;

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
			
			// Special effect:
			if (SoundAnimation)
				GotoState('TakeSoundDamage');
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
	// Damage Sound
	//
	VoicePackActor.DamageSound(Self,float(Damage)/float(Default.Health));
	
	PlayHit(Damage, HitLocation, damageType, Momentum.Z);

	// Check for items to drop
	//
	HealthPct = float(Health) / float(Default.Health);
	
	if (DropItemFirstHit != None)
	{
		DropAnItem(DropItemFirstHit);
		DropItemFirstHit = None;
	}
	if (HealthPct < 0.75)
	{
		if (DropItemHealth75Pct != None)
		{
			DropAnItem(DropItemHealth75Pct);
			DropItemHealth75Pct = None;
		}
	}
	if (HealthPct < 0.5)
	{
		if (DropItemHealth50Pct != None)
		{
			DropAnItem(DropItemHealth50Pct);
			DropItemHealth50Pct = None;
		}
	}
	if (HealthPct < 0.25)
	{
		if (DropItemHealth25Pct != None)
		{
			DropAnItem(DropItemHealth25Pct);
			DropItemHealth25Pct = None;
		}
	};

	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}
}

function Died(pawn Killer, name damageType, vector HitLocation)
{
	local actor A;

	if(JazzThinker(Self) == None)
	{
		// Trigger when dead.
		//
		if (DeathTriggerTag != '')
		{
			foreach AllActors( class 'Actor', A, DeathTriggerTag )
				A.Trigger( Self, Self );
		}
	
		// Score for defeating
		//
		if (Health<=0)
		{
			JazzPlayer(Killer).AddScore(ScoreForDefeating);
			JazzPlayer(Killer).AddWeaponExperience(ExperienceForDefeating);
		}
	
		// Drop any items carried
		if (DropItemDead != None)
		{
			DropAnItem(DropItemDead);
			DropItemDead = None;
		}

		If (DeathEffect != None)
		spawn(class<actor>(DeathEffect));
	
		VoicePackActor.DoSound(Self,VoicePackActor.Death);
	
		// Parent Died function
		//
	}
	
	Super.Died(Killer,damageType,HitLocation);
}

// Drop Item
// 
// Scatters the object type in a random direction with initial Z velocity upwards and Bounce on.
//
function DropAnItem ( class ItemToDrop )
{
	local actor A;
	
	A = spawn(class<actor>(ItemToDrop));
	
	if (A != None)
	{
	
	if (JazzPickupItem(A) != None)
	{
		JazzPickupItem(A).NewPickupDelay();	// Set delay for pickup items to be grabbed
	}
	
	A.Velocity = VRand()*100;
	A.Velocity.Z = 300;
	//A.Acceleration.Z = 300;
	A.SetLocation(Location+vect(0,0,100));
	A.bBounce = true;
	A.SetPhysics(PHYS_Falling);
	}
}

function bool Gibbed (name damageType)
{
	return false;
}

function SpawnGibbedCarcass()
{
}

function Carcass SpawnCarcass()
{
	local carcass carc;

	carc = Spawn(DeathCarcass);
	if ( carc != None )
		carc.Initfor(self);

	return carc;
}
/////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
// DYING																STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state Dying
{
	function BeginState ()
	{
		Destroy();
	}

Begin:
}

/////////////////////////////////////////////////////////////////////////////////////
// Special Damage Animation												STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state TakeSoundDamage
{
	function Tick(float DeltaTime)
	{
		local rotator NewRotation;
		
		NewRotation = Rotation;
		NewRotation.Yaw += FRand()*100-50;
		SetRotation(NewRotation);
	}
	
	Begin:
		Sleep(LastDamageAmount/5);
		GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// Conversation Activation Request										EVENT
/////////////////////////////////////////////////////////////////////////////////////
//
function Trigger( actor Other, Pawn EventInstigator )
{
	// See ActivationPlayerIcon for Details
	//
	//Log("JazzPawn) Activated by "$Other$" and "$EventInstigator);
	if (ActivationPlayerIcon(Other) != None)
	{
		if (Activateable != False)
		if (EventInstigator != None)
		Activate(EventInstigator);
	}
}

// We have been requested to activate for NPC purposes.
//
function Activate( Pawn Activator )
{
	local JazzConversation C;
	local JazzConversation JC;
	local actor A;

	// Put a JazzConversation somewhere in the level and set its trigger tag.
	//
	if (ConversationTag != '')
	{
		foreach allactors(class'JazzConversation', C,ConversationTag)
		{
		JC = C;
		}
		if (JC != None)
		{
			JC.Trigger(Activator,Self);
			Conversing = true;		
		}	
	}
	else
	
	// In the base JazzPawn class, the only activation possible is to put up the
	// default conversation type (if any).  Override this for additional capabilities.
	//
	if (DefaultConversation != None)
	{
		// Create the self-executing activation script and trigger it.
		//
		A = spawn(class<actor>(DefaultConversation),Self);
		A.Trigger(Activator,Self);
		Conversing = true;
	}
}

defaultproperties
{
     VoicePack=Class'CalyGame.JazzVoicePack'
}
