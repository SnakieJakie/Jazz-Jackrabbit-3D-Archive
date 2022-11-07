//=============================================================================
// SpritePoofieWaterDrop.
//=============================================================================
class SpritePoofieWaterDrop expands SpritePoofie;

simulated function HitWall( vector HitNormal, actor Wall )
{
	Destroy();
}

function Touch (actor Other)
{
	Destroy();
}

event Tick (float DeltaTime)
{
	local vector NewLocation;

	DrawScale = MaxDrawScale;

	NewLocation = Location;
	NewLocation += Velocity*DeltaTime;
	SetLocation(NewLocation);
//	Velocity.Z -= Drifting*100*DeltaTime;
}

defaultproperties
{
     Style=STY_Masked
     Sprite=None
     Texture=Texture'JazzArt.Weather.Devrain'
     DrawScale=0.500000
     ScaleGlow=0.500000
}
