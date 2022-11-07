//=============================================================================
// SpritePoofieOval.
//=============================================================================
class SpritePoofieOval expands SpritePoofie;


event Tick (float DeltaTime)
{
	local vector	NewLocation;
	
	ScaleGlow = LifeSpan/Default.LifeSpan;
	DrawScale = LifeSpan/Default.LifeSpan*Default.DrawScale;
	
	if (OwnerExists)
	{
		if (Owner==None)
		Destroy();
		
		SetLocation(Location + (Owner.Location - LastOwnerLocation) 
			+ vect(0,0,50)*(Default.LifeSpan-LifeSpan)
			);
		LastOwnerLocation = Owner.Location;
		SetRotation(Owner.Rotation);
	}

	if (Drifting>0)
	{
		NewLocation = Location;
		NewLocation += Velocity*DeltaTime;
		SetLocation(NewLocation);
		Velocity.Z += Drifting*3.14*DeltaTime;
	}
}

defaultproperties
{
     Sprite=Texture'JazzArt.Particles.Jazzp8'
     Texture=Texture'JazzArt.Particles.Jazzp8'
     DrawScale=0.400000
}
