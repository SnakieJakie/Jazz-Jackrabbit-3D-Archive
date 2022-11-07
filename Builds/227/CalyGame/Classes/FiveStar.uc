//=============================================================================
// FiveStar.
//=============================================================================
class FiveStar expands JazzParticleSpawner;


function PreBeginPlay ()
{
	local Actor			 	S;
	local int 				X;
	
	for (x=0; x<5; x++)
	{
	S = spawn(class<actor>(ThingToSpawn),Owner);
	S.SetPhysics(PHYS_Projectile);
	S.Velocity = vect(100,0,0) << RotRand(false);
	}
	
	Destroy();
}

defaultproperties
{
     ThingToSpawn=Class'CalyGame.StarryPoofie'
     bDirectional=False
}
