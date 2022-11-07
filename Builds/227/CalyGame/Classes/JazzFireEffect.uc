//=============================================================================
// JazzFireEffect.
//=============================================================================
class JazzFireEffect expands JazzEffects;


simulated event Tick(float DeltaTime)
{
	if(Owner != None)
	{
		SetLocation(Owner.Location+vect(0,0,5));
	}
	else
	{
		Destroy();
	}
}

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'UnrealShare.FlameM'
     LightType=LT_Flicker
     LightBrightness=75
     LightRadius=50
}
