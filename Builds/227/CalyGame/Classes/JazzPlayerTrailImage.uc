//=============================================================================
// JazzPlayerTrailImage.
//=============================================================================
class JazzPlayerTrailImage expands Decoration;

var() float	InitialScaleGlow;


// Fade image out
//
auto simulated state Display
{
simulated event Tick ( float DeltaTime )
{
	if (InitialScaleGlow<0) InitialScaleGlow = 0;
	if (InitialScaleGlow>1) InitialScaleGlow = 1;

	ScaleGlow = (LifeSpan)*InitialScaleGlow;
	
	//Log("TrailImageFade "$ScaleGlow);
}
}

defaultproperties
{
     InitialScaleGlow=1.000000
     bStatic=False
     RemoteRole=ROLE_None
     LifeSpan=0.300000
     DrawType=DT_Mesh
     Style=STY_Translucent
}
