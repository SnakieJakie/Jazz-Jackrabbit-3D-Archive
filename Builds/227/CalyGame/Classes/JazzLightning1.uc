//=============================================================================
// JazzLightning1.
//=============================================================================
class JazzLightning1 expands JazzWeaponEffects;

// NOT USED
//


auto simulated state SpellEffect 
{

simulated function Tick ( float DeltaTime )
{
	local float L;
	
	if (SpellFocus != None)
	{
		SetLocation(SpellFocus.Location);
		SetRotation(SpellFocus.Rotation);
	}

	//
	// Fire Shrink/Grow
	//if (LifeSpan>0.5)
		//L = (1-LifeSpan)/0.5*15;
	//else
		//L = (LifeSpan/0.5)*15;

	if (LifeSpan<0.5)
		ScaleGlow=(LifeSpan/0.5);
	
	//Log("Fire1 Effect) "$L);
	//DrawScale=L;
}

simulated function MakeSpark()
{
	local JazzLightning1b a;
	a = Spawn(class'JazzLightning1b');
	//a.DrawScale=1;
	a.SpellFocus = SpellFocus;
}

begin:
	MakeSpark();
	
	ScaleGlow=1;
	LifeSpan = 2;
}

defaultproperties
{
}
