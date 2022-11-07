//=============================================================================
// WaterDroplet.
//=============================================================================
class WaterDroplet expands JazzEffects;

var	int 	BurstNum;
var class 	BurstClass;

event Landed( vector HitNormal )
{
	Burst(HitNormal);
}

event HitWall( vector HitNormal, actor HitWall )
{
	Burst(HitNormal);
}

function Burst( vector HitNormal )
{
	Destroy();
}

defaultproperties
{
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.WaterCell'
     DrawScale=0.500000
}
