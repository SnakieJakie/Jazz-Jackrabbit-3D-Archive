//=============================================================================
// CircularColumn.
//=============================================================================
class CircularColumn expands ParticleColumn;

var() float CircleRadius;


auto state TrailOn
{
	// Draw Effect Again
	//
	function NewEffect()
	{
		
		local Actor 	Image;
		local vector	NewLocation;
		local rotator	NewRotation;
		
		//Log("Circular Column) "$Owner);
		
		if (Owner == None)
		Destroy();
		
		NewLocation = Owner.Location;
		NewRotation = rot(0,0,0);
		NewRotation.Yaw = FRand()*65536;
		
		Image = spawn(class<actor>(TrailActor),Owner,,NewLocation + CircleRadius*vector(NewRotation));
		
		if (RandomizeTrailActorFacing)
		{
			Image.SetRotation(RotRand(true));
		}
	}
}

defaultproperties
{
     CircleRadius=50.000000
     TrailActor=Class'CalyGame.SpritePoofieOval'
}
