//=============================================================================
// StoneExplosion.
//=============================================================================
class StoneExplosion expands Effects;

function Timer()
{
	if (LightBrightness>60) LightBrightness-=60;
}


auto state Explode
{
Begin:
	SetTimer(0.1,True);
	PlayAnim  ( 'Explosion', 1 );
	PlaySound (EffectSound1,,3.0);	
	MakeNoise ( 1.0 );
	FinishAnim();
	Destroy   ();
}

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzArt.Effects.NRock'
     Mesh=Mesh'UnrealShare.TazerExpl'
}
