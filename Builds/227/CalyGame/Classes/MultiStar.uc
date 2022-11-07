//=============================================================================
// MultiStar.
//=============================================================================
class MultiStar expands JazzParticleSpawner;


function MultiSpawn ( int NumToSpawn )
{
	local Actor			 	S;
	local int 				X;
	
	for (x=0; x<NumToSpawn; x++)
	{
	S = spawn(class<actor>(ThingToSpawn),Owner);
	S.SetPhysics(PHYS_Projectile);
	S.Velocity = vect(200,0,0) << RotRand(false);
	}
	
	Destroy();
}

defaultproperties
{
     ThingToSpawn=Class'CalyGame.StarryPoofie'
}
