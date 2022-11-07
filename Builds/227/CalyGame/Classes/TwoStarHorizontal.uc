//=============================================================================
// TwoStarHorizontal.
//=============================================================================
class TwoStarHorizontal expands JazzParticleSpawner;


function PostBeginPlay ()
{
	local Actor			 	S;
	local int 				X;
	local rotator			NewRotation;
	
	NewRotation = Rotation;
	//NewRotation.Pitch += 65536/4;
	//NewRotation.Pitch = 0;
	//NewRotation.Roll = 0;
	NewRotation.Yaw += 65536/4;
	NewRotation.Roll = 0;
	
	for (x=0; x<2; x++)
	{
	Log("TwoStar) "$ThingToSpawn);
	NewRotation.Roll += 65536/5;
	
	S = spawn(class<actor>(ThingToSpawn),Owner);
	S.SetRotation(rot(0,0,0));
	S.SetPhysics(PHYS_Projectile);
	S.Velocity = vect(100,0,0) << NewRotation;
	}
	
	Destroy();
}

defaultproperties
{
     ThingToSpawn=Class'CalyGame.StarryPoofie'
}
