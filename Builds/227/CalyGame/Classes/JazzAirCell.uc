//=============================================================================
// JazzAirCell.
//=============================================================================
class JazzAirCell expands JazzWeaponCell;

var () float AirDistance;
var () float AirMomentum;
var () float AirRadius;

state FireStateJazz			// Jazz Jackrabbit's Weapon
{
	// Perform actual firing here
	Begin:

	switch (CurrentPowerLevel)
	{
	
	///////////////////////////
	// Fire Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 0;
		
		// Do air burst
		// ProjectileFire(class'JazzFire', 400, true);
		
		//Log("JazzAir) JazzAirCell Fire");
		
		AirBurst(0,300, 'AirBlast', 500000, Owner.Location);
		
		MainFireDelay(0.8);
		//Sleep(0.4);				// Weapon reload time
	break;
	
	}
	
	CheckContinueFire();	// Check if fire held down
}

final function AirBurst( float DamageAmount, float DamageRadius, name DamageName, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir,HitNormal,HLocal;
	
	if( bHurtEntry )
		return;
		
	Dir = (vect(1,0,0) * AirDistance) >> Owner.Rotation;

	HitLocation += Dir;		

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		if( Victims != self )
		{
			if(Pawn(Victims) != None)
			{
				dir = Victims.Location - Owner.Location;
				dist = FMax(1,VSize(dir));
				dir = dir/dist; 
				damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
				Victims.TakeDamage
				(
					damageScale * DamageAmount,
					Instigator, 
					Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
					(damageScale * Momentum * dir),
					DamageName
				);
			}
			else
			{
				if(Victims.bMovable)
				{
					dir = Victims.Location - Owner.Location;
					dist = FMax(1,VSize(dir));
					dir = dir/dist; 				
					Victims.Velocity = Victims.Velocity + dir*Momentum/Victims.Mass;
				}			
			}
		} 
	}
	bHurtEntry = false;
}

defaultproperties
{
     WeaponCapable(1)=255
     ItemName="Air Cell"
     PickupMessage="Air Cell"
     PlayerViewMesh=Mesh'JazzObjectoids.wcell'
     PlayerViewScale=0.300000
     PickupViewScale=0.300000
     Icon=Texture'JazzArt.Weapons.WMedieval'
     Texture=Texture'JazzArt.Particles.Normch1'
     DrawScale=0.300000
}
