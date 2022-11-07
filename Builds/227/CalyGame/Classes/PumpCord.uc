//=============================================================================
// PumpCord.
//=============================================================================
class PumpCord expands JazzEffects;

var int SegNum,newsegnum;
var int oldsegnum;
var int numpoints;
var vector dvector,smokelocation;

simulated function Tick(float DeltaTime)
{
	local Vector Start, X,Y,Z;
	local int segdist;
	oldsegnum = segnum;
	
	GetAxes(owner.instigator.ViewRotation,X,Y,Z);
	segdist = (vsize(owner.location - owner.instigator.location)* 1.05);

	Start = Owner.instigator.Location; 


	smokeLocation = (start+(segnum * normal(Owner.location - start)));
	
	if (vsize(smokelocation - owner.Instigator.location) >= segdist)
	{
    	setrotation(rotator(normal(Owner.Location-start)));
	    setlocation(owner.location - 70 * normal(owner.location - start));
	}
	else
	{
		setlocation(smokelocation);
	    setrotation(rotator(normal(Owner.Location-start)));
	}

}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.pump'
}
