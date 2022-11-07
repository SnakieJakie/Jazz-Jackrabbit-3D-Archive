//=============================================================================
// BubbledEffect.
//=============================================================================
class BubbledEffect expands JazzEffects;

simulated function PostBeginPlay()
{
	SetLocation(Owner.Location);
	SetBase(Owner);
}

simulated function Tick(float DeltaTime)
{
	if(Base != Owner)
	{
		SetLocation(Owner.Location);
		SetBase(Owner);
	}
}

defaultproperties
{
}
