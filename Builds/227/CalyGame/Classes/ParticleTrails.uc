//=============================================================================
// ParticleTrails.
//=============================================================================
class ParticleTrails expands JazzEffects;

//
// The intention of this class is to create an invisible actor that spawns an certain effect
// (created in subclasses) and is attached to another actor.  Hence creating particles that follow,
// for example.  The Owner is the actor attached to.  This should be set when you spawn it, 
// however SetOwner(actor NewOwner) can change this later.
//
// If a Duration is set (or LifeSpan is set beforehand) then the actor will disappear, otherwise it
// will continue on forever.  
//
// (Note that the TrailOff state won't stop the LifeSpan from running down.)  If you need this
// capability, I suggest setting the duration when you Activate() instead of when the actor is
// created.
//

var() float TrailFrequency;
var() class TrailActor;
var() bool	RandomizeTrailActorFacing;	// As opposed to using the 'Owner'
var() bool	RandomizeTrailActorYaw;
var() float	TrailRandomRadius;
var	  bool	NoOwner;					// Set this to false for a spawner that stays in one place
var	  int	TrailAmount;
var	vector  Loc;

// Possible Addition: Randomized Frequency Timings


// Base activation functions
//
function Deactivate	();

// EffectFreqency overrides TrailFrequency
//
function Activate	(optional float EffectFrequency, optional float Duration)
{
	if (EffectFrequency > 0)
	{
		TrailFrequency = EffectFrequency;
	}
	else
		TrailFrequency = Default.TrailFrequency;
			
	if (Duration > 0)
	{
		LifeSpan = Duration;
	}
		
	GotoState('TrailOn');
}

// The default for a created trail is 'On'.
//
// To set it off, tell it to GotoState('TrailOff'); or use the function Deactivate().
//
auto state TrailOn
{
	// Draw Effect Again
	//
	function NewEffect()
	{
		local Actor Image;
		local Rotator NewRot;
	
		Image = spawn(class<actor>(TrailActor));

		if (NoOwner==true)
		{
			if (TrailRandomRadius>0)
			Image.SetLocation(Location+(VRand()*FRand()*TrailRandomRadius));
			else
			Image.SetLocation(Location);
		}
		else
		{
			if ((Owner == None) || (Owner.Location == vect(0,0,0)))
			Destroy();
			else
			Loc=Owner.Location;

			if (TrailRandomRadius>0)
			Image.SetLocation(Loc+(VRand()*FRand()*TrailRandomRadius));
			else
			Image.SetLocation(Loc);
		}

		if (RandomizeTrailActorFacing)
		{
			Image.SetRotation(RotRand(true));
		}
		if (RandomizeTrailActorYaw)
		{
			NewRot = Image.Rotation;
			NewRot.Yaw = FRand()*65536;
			Image.SetRotation(NewRot);
		}
		
		TrailActorFinish(Image);
	}	
	
	function TrailActorFinish(actor Image);

	event Timer()
	{
		local int x;
		for (x=0; x<=TrailAmount; x++)
		NewEffect();
	}
	
	function Deactivate	()
	{
	GotoState('TrailOff');
	}

Begin:
	SetTimer(TrailFrequency,true);
}


// The trail is off.
//
state TrailOff
{
Begin:
	SetTimer(-1,false);
}

defaultproperties
{
     RemoteRole=ROLE_AutonomousProxy
     DrawType=DT_None
}
