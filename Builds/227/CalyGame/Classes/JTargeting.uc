//=============================================================================
// JTargeting.
//=============================================================================
class JTargeting expands JazzEffects;

simulated function Target()
{
	local vector HitLocation, HitNormal, End;
	local actor Hit;
	
	End = Owner.Location + (vect(2000,0,0) >> PlayerPawn(Owner).ViewRotation);
	
	Hit = Trace(HitLocation, HitNormal,End,Owner.Location, true);
	
	if(Hit == None)
	{
		SetLocation(End);
	}
	else
	{
		SetLocation(HitLocation);
	}
}
// ?? This seems to have been taken out
//
/*simulated function Tick(float DealtTime)
{
	local vector HitLocation, HitNormal, End;
	local actor Hit;
	
	if ((Owner==None) || (PlayerPawn(Owner)==None))
		return;
		
	// If the owner is hidden, we don't want to see the targeting dot.	
	bHidden = Owner.bHidden;
	
	End = Owner.Location + (vect(2000,0,0) >> PlayerPawn(Owner).ViewRotation);
	
	Hit = Trace(HitLocation, HitNormal,End,Owner.Location, true);
	
	if(Hit == None)
	{
		SetLocation(End);
	}
	else
	{
		SetLocation(HitLocation);
	}
}
*/

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     Style=STY_Translucent
     Texture=Texture'JazzArt.Interface.Drmnorm'
     DrawScale=0.125000
}
