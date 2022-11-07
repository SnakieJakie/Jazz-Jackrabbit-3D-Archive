//=============================================================================
// ShadowCast.
//=============================================================================
class ShadowCast expands JazzEffects;

//
// Incomplete pending graphics or further idea.
//


//var actor Owner;


event PreRender( canvas Canvas )
{
	local vector	HitLocation,HitNormal,View;
	local actor 	A;
	local int		NewDist;

	//Log("ShadowCast) PreRender");

/*	if (Owner != None)
	{
		// 1. Trace down from owner to first location
		
		View = vect(1,0,0) >> rot(0,16384,0);
		
		A = Trace( HitLocation, HitNormal, 
			Owner.Location - vect(0,0,100000), Owner.Location );
		
		NewDist = (Location - HitLocation) Dot View;
		
		SetLocation(HitLocation+vect(0,0,1));
		DrawScale = 1*((10000-NewDist)/10000);
		
		//Log("ShadowCast) "$Location$" "$Owner.Location);
	}*/
	
	bHidden = true;
}

event Tick ( float DeltaTime )
{
	//SetLocation(Owner.Location);
	//Log("ShadowCast) Tick!");
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Texture=Texture'JazzObjectoids.Skins.JDecal_01'
     Mesh=Mesh'JazzObjectoids.Decal'
     bAlwaysRelevant=False
     CollisionRadius=22.000000
     CollisionHeight=22.000000
     LightType=LT_Steady
     LightBrightness=51
     LightRadius=51
     bSpecialLit=True
}
