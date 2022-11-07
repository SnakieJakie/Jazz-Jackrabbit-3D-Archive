//=============================================================================
// SpritePoofieSnowflake.
//=============================================================================
class SpritePoofieSnowflake expands SpritePoofie;

simulated function HitWall( vector HitNormal, actor Wall )
{
	// Water drop just sticks to the ground and fades away normally
	SetPhysics(PHYS_None);
	Velocity = vect(0,0,0);
	Drifting = 0;
	
	Log("HitWall)");
}

function Touch (actor Other)
{
	if (Other == None)
	{
	Velocity = vect(0,0,0);
	Drifting = 0;
	SetPhysics(PHYS_None);
	Log("HitWall)");
	}
}

defaultproperties
{
     bCollideWorld=True
}
