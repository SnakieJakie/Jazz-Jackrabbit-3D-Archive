//=============================================================================
// JazzLightningEff1.
//=============================================================================
class JazzLightningEff1 expands JazzEffects;

var actor SpellFocus;

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
	local JazzLightningEff2 a;	
	a = Spawn(class'JazzLightningEff2');
	//a.DrawScale=1;
	a.SpellFocus = SpellFocus;
}

begin:
	MakeSpark();
	
	ScaleGlow=1;
	LifeSpan = 1;
}

defaultproperties
{
     AnimSequence=Explosion
     AnimFrame=4.000000
     DrawType=DT_Mesh
     Mesh=Mesh'UnrealShare.TazerExpl'
     DrawScale=12.000000
}
