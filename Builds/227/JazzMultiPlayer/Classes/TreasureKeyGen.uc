//=============================================================================
// TreasureKeyGen.
//=============================================================================
class TreasureKeyGen expands JazzGameObjects;

// Spawns the flag for the User
function SpawnFlag(actor User)
{
	local JazzTreasureKey Key;
	local vector Vel;
	
	Key = spawn(class'JazzTreasureKey',,,Location);
	
	Key.User = User;
	
	Vel.X = (FRand()*1000)-500;
	Vel.Y = (FRand()*1000)-500;
	
	Vel.Z = (FRand()*500)+250;
	
	Key.Velocity = Vel;
	
	Key.SetPhysics(PHYS_Falling);
}

defaultproperties
{
     bHidden=True
     bCollideWhenPlacing=True
}
