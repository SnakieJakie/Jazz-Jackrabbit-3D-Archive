//=============================================================================
// JazzLightning1b.
//=============================================================================
class JazzLightning1b expands JazzWeaponEffects;

// NOT USED
//

auto simulated State SpellEffect
{

simulated function Tick ( float DeltaTime )
{
	local float L;
	
	if (SpellFocus != None)
	{
		SetLocation(SpellFocus.Location);
		SetRotation(SpellFocus.Rotation);
	}
	
	if (LifeSpan<0.5)
		ScaleGlow=(LifeSpan/0.5);
	else
		ScaleGlow=1;
}

begin:
	LifeSpan = 1;
}

defaultproperties
{
}
