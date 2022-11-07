//=============================================================================
// JazzChargingEffects.
//=============================================================================
class JazzChargingEffects expands JazzEffects;

var() name		Animation;
var() bool		ReverseAnimation;
var() bool		ReverseReverseAnimation;
var() float		AnimationSpeed;
var() float		AnimationFrames;
var() float		RotationRoll;

var() float		InitialScale;
var() float		TargetScale;
var() float		ScalePeriod;
var() float		ScaleTimer;

event Tick (float DeltaTime)
{
	local rotator NewRotation;
	local vector NewLocation;

	//Log("JazzChargingEffect) "$AnimFrame);
	
	if (ReverseAnimation)
	{
	AnimFrame -= AnimationSpeed*DeltaTime;
	if (AnimFrame<0) 
		if (ReverseReverseAnimation)
		ReverseAnimation = !ReverseAnimation;
		else
		AnimFrame += AnimationFrames;
	}
	else	
	{
	AnimFrame += AnimationSpeed*DeltaTime;
	if (AnimFrame>AnimationFrames) 
		if (ReverseReverseAnimation)
		ReverseAnimation = !ReverseAnimation;
		else
		AnimFrame -= AnimationFrames;
	}

	if (Owner==None)
	Destroy();
	
	if ((Pawn(Owner) != None) && (Pawn(Owner).Weapon != None))
	{
		NewRotation = Owner.Rotation;
		NewRotation.Roll = Rotation.Roll+RotationRoll*DeltaTime;	
		
		SetRotation(NewRotation);
		SetLocation(Owner.Location + Pawn(Owner).Weapon.CalcDrawOffset() + (20 * Vector(Pawn(Owner).Rotation)) );
		
		//Log("ChargeLocation) Weapon "$Location$" "$Rotation$" Owner:"$Owner.Location$" "$Owner.Rotation);
		//Log("ChargeLocation) CalcDrawOffset:"$Pawn(Owner).Weapon.CalcDrawOffset());
	}
	else
	{
		NewRotation = Owner.Rotation;
		NewRotation.Roll = Rotation.Roll+RotationRoll*DeltaTime;	

		SetRotation(NewRotation);
		SetLocation(Owner.Location + (40 * Vector(Owner.Rotation)) );
	}
	
	
	// Scale Period
	//
	if (ScalePeriod>0)
	{
		ScaleTimer += DeltaTime;
		DrawScale = (TargetScale-InitialScale)*(ScaleTimer/ScalePeriod)+InitialScale;
	}
}

state Die
{
	Begin:
	Destroy();
}

defaultproperties
{
}
