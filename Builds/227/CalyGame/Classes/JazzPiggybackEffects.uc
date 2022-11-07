//=============================================================================
// JazzPiggybackEffects.
//=============================================================================
class JazzPiggybackEffects expands JazzEffects;

event Tick ( float DeltaTime )
{
	// Always track player
	if (Owner != None)
	{
		SetLocation(Owner.Location);
	}
}

defaultproperties
{
     DrawType=DT_Mesh
}
