//=============================================================================
// SurroundGlow.
//=============================================================================
class SurroundGlow expands JazzEffects;

function Tick ( float DeltaTime )
{
	if (Owner == None)
	Destroy();

	Mesh = Owner.Mesh;
	DrawScale = Owner.DrawScale*1.03;
	Texture = Owner.Texture;
	Skin = Owner.Skin;
	AnimSequence = Owner.AnimSequence;
	SetLocation(Owner.Location);
	SetRotation(Owner.Rotation);
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
}
