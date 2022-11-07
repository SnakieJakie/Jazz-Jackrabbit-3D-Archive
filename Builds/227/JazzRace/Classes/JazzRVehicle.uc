//=============================================================================
// JazzRVehicle.
//=============================================================================
class JazzRVehicle expands JazzPlayer;


// Enumeration of our ShipSide
enum EShipSide
{
	SIDE_UP,
	SIDE_DOWN,
	SIDE_LEFT,
	SIDE_RIGHT,
};

var bool bTouchRight;
var bool bTouchLeft;

var (ShipData) float TurnRate;

// if the player has gone backward
var bool bBackward;
// the rank the player was on before they started going backward
var int BackRank;
// the number of laps the player has gone backward
var int BackLap;

// the current lap the player is on
var int CurLap;

// TODO: Remove Gravity and HoverAcceleration and make it look at the current zone
// TODO: Re-do spark system, current one will be too slow

// Ship's current position point
var RankPoint CurrentPoint;

// The actual velocity of the vehicle in the game
var float ActualVehicleVelocity;
// The actual acceleration of the vehicle in the game
var float ActualVehicleAcceleration;
// The ship's height from the floor
var float Height;
// The ship's hover push (z acceleration to fight gravity if too close to the ground)
var float ZAcceleration;
// If the vehicle has just recently hit a wall (debug)
var bool bJustHitWall;
// How long the Just hit a wall message will stay up (debug)
var float MessageTime;
// If a speed burst is in affect
var bool bSpeedBurst;
// The amount of time left of the burst
var float BurstTime;
// The Height above the ground that the ship will hover
var (Const) const float HoverDist;

// The acceleration to add to the ship due to bumps
var vector BounceAccel;

// The acceleration of the acceleration of the ship
var (ShipData) float AAccel;
// The max acceleration of the ship
var (ShipData) float MaxAccel;
// The current acceleration of the ship
var float CurAccel;
// The distance that is checked to make sparks
var (ShipData) float SparkFeelerDist;

// Function to create sparks
function Spark(EShipSide ShipSide, int SparkDist);

// Function to find a certain rank point and set it to CurrentPoint
function FindRankPoint( int Number )
{
	log("Wrong Code!");
}

// Function to see if the ship is near anything
function Feelers();

// Function to do a speed burst
// TimeToBurst is the amount of time the speed burst will last
function DoSpeedBurst( int TimeToBurst);

// Try to see if the player is at the right height or not
function CalcHeight();

exec function Fire( optional float F )
{
	// Disable normal firing, hopefully this won't be too important
	/*
	if( bShowMenu || Level.Pauser!="" )
		return;
	if( Weapon!=None )
	{
		Weapon.bPointing = true;
		Weapon.Fire(F);
		PlayFiring();
	}
	*/
	gotostate('PlayerVehicle');
}

exec function AltFire( optional float F )
{
	// Disable Alt firing, again hopefully this won't be too important
	/*
	if( bShowMenu || Level.Pauser!="" )
		return;
	if( Weapon!=None )
	{
		Weapon.bPointing = true;
		Weapon.AltFire(F);
		PlayFiring();
	}
	*/
	DoSpeedBurst(3);
}

auto state () PlayerVehicle
{
ignores SeePlayer, HearNoise;
	
	event PlayerTick( float DeltaTime )
	{
		if ( bUpdatePosition )
			ClientUpdatePosition();
	
		PlayerMove(DeltaTime);
		
		// Update the player's current rank point
		UpdateRank();
		
		// Make the bounce accel die down
		BounceAccel /= 1.125;
		
		// FIXME
		/*
		// Attempt to make player hover while slowly moving or not moving at all
		if ( ActualVehicleVelocity < 10 && Velocity.Z == 0 )
		{
			AddVelocity(HoverTickVelocity);
		}
		*/
		
		// If the speed burst is in affect, then run the timer
		if (bSpeedBurst)
		{
			BurstTime -= 1*DeltaTime;
			if(BurstTime <= 0)
			{
				DoSpeedBurst(0);
			}
		}
		
		// Calculate ship's height
		CalcHeight();
		
		bTouchRight = false;
		bTouchLeft = false;
		// See if the ship is too close to something
		Feelers();
		
		// Calculate Z Acceleration to get to desired vehice height
		// If the height is below the hoverdist, that means we're too close to the ground
		if (Height < HoverDist)
		{
			ZAcceleration = (HoverDist - Height)*2.23;
		}
		// If the height is above the hoverdist, that means we're too far away, go to the ground
		else if (Height > HoverDist)
		{
				ZAcceleration = -(Height - HoverDist)*2.23;
		}
		// If the height is the hoverdist, stay there!
		else if (Height == HoverDist)
		{
			ZAcceleration = 0;
		}
		// If the height is zero, that means we don't know where we are! and shoot to the ground, damnit!
		if (Height == 0)
		{
			ZAcceleration = HeadRegion.Zone.ZoneGravity.Z;
		}
		
		// Message Time thingy
		if(bJustHitWall)
		{
			MessageTime -= 1*DeltaTime;
			if (MessageTime <= 0)
				bJustHitWall = false;
		}
		
	}
	
	function ZoneChange( ZoneInfo NewZone )
	{
		if (FinishLine(NewZone) != None)
		{
			if(!bBackward)
			{
				CurLap++;
			}
		}
	}	
	
	simulated function HitWall(vector HitNormal, actor Wall)
	{
		// 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity)
		BounceAccel += (( Velocity dot HitNormal) * HitNormal * (-2.0));
		//BounceAccel += 1600 * HitNormal;
		
		AddVelocity( HitNormal * FMax(VSize(Velocity),600));
		
		CurAccel -= CurAccel * 0.05;
		
		if (bJustHitWall == false)
		{
			bJustHitWall = true;
			// AddVelocity(-Velocity);
			MessageTime = 1.5;
			bSpeedBurst = false;
		}		
	}
	
	function PlayerMove(float DeltaTime)
	{
		local rotator newRotation;
		local vector X,Y,Z;
		local float AccelMult;

		GetAxes(Rotation,X,Y,Z);
		
		// Find the ship's velocity
		ActualVehicleVelocity = sqrt(abs(Velocity.X)*abs(Velocity.X) + abs(Velocity.Y)*abs(Velocity.Y));
		ActualVehicleAcceleration = sqrt(abs(Acceleration.X)*abs(Acceleration.X) + abs(Acceleration.Y)*abs(Acceleration.Y));
		
		if (aTurn != 0)
		{
			// Limit the amount the vehicle can turn
			if (aTurn < -TurnRate)
			{
				aTurn = -TurnRate;
			}
			if (aTurn > TurnRate)
			{
				aTurn = TurnRate;
			}
		
			aTurn    *= 0.07;
		}
		
		// Add our fight against gravity or our lack of thrust to go to desired level
		Acceleration = ZAcceleration*vect(0,0,1);
		
		AccelMult = MaxAccel/CurAccel;

		AccelMult /= 2.5;
		
		if(AccelMult > 12)
		{
			AccelMult = 12;
		}

		// If the control to move forward is pressed
		if(aForward > 0)
		{
			CurAccel += AAccel * DeltaTime * AccelMult;
		}
		else if(aForward < 0)
		{
			CurAccel -= AAccel * 5 * DeltaTime;
		}
		else
		{
			CurAccel -= AAccel * 1.75 * DeltaTime;
		}
		
		if(CurAccel > MaxAccel)
		{
			CurAccel = MaxAccel;
		}
		
		if(CurAccel < 0)
		{
			CurAccel = 0;
		}
		
		/*
		else if(bSpeedBurst)
		{
			// If we're not moving, get rid of the burst time faster
			BurstTime -= 2*DeltaTime;
		}
		*/
		
		Acceleration += X*CurAccel;
		
		Acceleration += BounceAccel;
		
		// If we are turning, strafe a bit and turn less
		if(aTurn != 0)
		{
			aStrafe = aTurn / 2;
			
			aTurn *= 0.95;
			
		}
		else
		{
			// Eliminate Strafing and looking up and down
			aStrafe  = 0.0;
			aLookup  = 0;
		}
		
		Acceleration += aStrafe*Y;
	
		// Update rotation.
		UpdateRotation(DeltaTime, 2);
		
		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}
	
	function Spark(EShipSide ShipSide, int SparkDist)
	{
		//local SparkBit TempSparkBit;
		local rotator SpawnDir;
		local vector SpawnLocation;
		local int NumberOfSparks,i;

		SpawnLocation = vect(0,0.5,0);
				
		switch (ShipSide)
		{
			case SIDE_LEFT:
				SpawnLocation *= -SparkDist;		
			break;
			case SIDE_RIGHT:
				SpawnLocation *= SparkDist;
			break;
		}
		
		SpawnLocation = SpawnLocation >> Rotation;		
		SpawnLocation += Location;
		
		NumberOfSparks = Rand(2)+2;
		for (i=0; i<NumberOfSparks; i++)
		{
	
/*			TempSparkBit = Spawn (class 'SparkBit', , '', SpawnLocation);
		
			SpawnDir = rot(32767,0,0) + Rotation;
			SpawnDir.Yaw += FRand()*(1600+1600)-1600;
			SpawnDir.Pitch += FRand()*(1600+1600)-1600;
			TempSparkBit.Velocity = Vector(SpawnDir)*(100 + FRand()*(175-100))+Velocity;
	
			TempSparkBit.BurnTime = 0.4 + FRand()*(1-0.4);
	
			TempSparkBit.InitialBrightness = 0.7 + FRand()*(1-0.7);	*/
		}
	}


	function BeginState()
	{
		SetPhysics(PHYS_Flying);
		MinHitWall = 2*Pi;
		FindRankPoint(0);
	}

	
	function DoSpeedBurst( int TimeToBurst )
	{
		if (TimeToBurst != 0)
		{
			bSpeedBurst = true;
			BurstTime = TimeToBurst;
			AirSpeed = 2000;
			GroundSpeed = 2000;
			// FIXME: Speed boost of 1000 when speed burst hit
			AddVelocity(vect(1000,0,0) >> Rotation);
		}
		else
		{
			AirSpeed = 1000;
			GroundSpeed = 1000;
			bSpeedBurst = false;
		}
	}
	
	function FindRankPoint(int RankPointNumber)
	{
		local RankPoint OtherPoint;
		
		log("Looking for RankPoint : "$ RankPointNumber);
		
		ForEach AllActors(class 'RankPoint', OtherPoint)
		{
			log("Found a RankPoint - Checking");
			if( OtherPoint.Number == RankPointNumber )
			{
				CurrentPoint = OtherPoint;
				log("Found RankPoint : "$ RankPointNumber);
				return;
			}
		}
		
		log("Could not find RankPoint : "$ RankPointNumber);
	}
	
	function UpdateRank()
	{
		if ( VSize(CurrentPoint.Location - Location) > VSize(CurrentPoint.nextPoint.Location - Location) )
		{
			if(bBackward)
			{
				if(CurrentPoint.Number == BackRank)
				{
					if(BackLap == 0)
					{
						bBackward = false;
					}
					else
					{
						BackLap--;
					}
				}
			}
			CurrentPoint = CurrentPoint.nextPoint;
			return;
		}
		
		if( VSize(CurrentPoint.Location - Location) > VSize(CurrentPoint.prevPoint.Location - Location) )
		{
			if(!bBackward)
			{
				bBackward = true;
				BackRank = CurrentPoint.Number;
				BackLap = 0;
			}
			else if(CurrentPoint.Number == BackRank)
			{
				BackLap++;
			}
			CurrentPoint = CurrentPoint.prevPoint;
			return;
		}
	}
	
	function PostRender( canvas Canvas )
	{
		Canvas.Font = Canvas.SmallFont;
		Canvas.Setpos(0,0);
		Canvas.DrawText("Acceleration: "$ ActualVehicleAcceleration);
		Canvas.Setpos(0,10);
		Canvas.DrawText("Speed: "$ ActualVehicleVelocity);		
		Canvas.SetPos(0,20);
		Canvas.DrawText("BurstTime: "$ BurstTime);
		Canvas.SetPos(0,30);
		Canvas.DrawText("Height: "$ Height);
		Canvas.SetPos(0,40);
		Canvas.DrawText("Current Point: "$ CurrentPoint.Number);
		Canvas.SetPos(100,0);
		Canvas.DrawText("Backtracking: "$ bBackward);
		Canvas.SetPos(100,10);
		Canvas.DrawText("Back Rank: "$ BackRank);
		Canvas.SetPos(100,20);
		Canvas.DrawText("Back laps: "$ BackLap);
		if(bJustHitWall)
		{
			Canvas.SetPos(0,60);
			Canvas.DrawText("Hit a wall!");
		}

		if(bTouchRight)
		{
			Canvas.SetPos(0,70);
			Canvas.DrawText("Touched Right");
		}
		if(bTouchLeft)
		{
			Canvas.SetPos(0,70);
			Canvas.DrawText("Touched Left");
		}		
		Super.PostRender(Canvas);
	}
	
	exec function Jump( optional float F )
	{
		// Disable Jump
	}

	exec function FeignDeath()
	{
		// Disable Feign Death
	}
	
	simulated function Touch( Actor Other)
	{	
		if ( Other.IsA('Brush') || Other.IsA('Wall') || Other.IsA('Level'))
		{
			HitWall( Normal(Location - Other.Location), Other);
			return;
		}
		
		if(JazzRVehicle(Other) != None)
		{
			// We have hit another vehicle
		}
	}
	
	simulated function Bump( Actor other)
	{
		if(JazzRVehicle(Other) != None)
		{
			// We have been hit by another vehicle
		}
	}
	
	function CalcHeight()
	{
		local vector HitLocation,HitNormal;
		local vector HoverHeight;
		
		Height = 0;
		
		HoverHeight = vect(0,0,1);
		HoverHeight *= 2*HoverDist;
	
		if (Trace( HitLocation, HitNormal, (Location - HoverHeight), Location) != None)
		{
			//ValueToReturn = FMin( (HitLocation - Location) Dot HitNormal, HoverDist);
			Height = (Location.Z - HitLocation.Z);
		}
	}
	
	function Feelers()
	{
		local vector HitLocation,HitNormal,Feeler;

		// Check to the right
		Feeler = vect(0,1,0);
		Feeler *= -SparkFeelerDist;
		
		Feeler = Feeler >> Rotation;
		
		if (Trace( HitLocation, HitNormal, (Location - Feeler), Location) != None)
		{
			bTouchRight = true;
			Spark(SIDE_RIGHT,VSize(Location - HitLocation));
			return;
		}				
		
		// Check to the left
		Feeler = vect(0,1,0);
		Feeler *= SparkFeelerDist;
		
		Feeler = Feeler >> Rotation;
		
		if (Trace( HitLocation, HitNormal, (Location - Feeler), Location) != None)
		{
			bTouchLeft = true;
			Spark(SIDE_LEFT,VSize(Location - HitLocation));
			return;
		}			
	}

}

defaultproperties
{
     TurnRate=4000.000000
     HoverDist=64.000000
     AAccel=180.000000
     MaxAccel=4000.000000
     SparkFeelerDist=10.000000
     AirSpeed=5000.000000
     FovAngle=110.000000
     Physics=PHYS_Flying
     InitialState=PlayerVehicle
     AnimSequence=None
     Mesh=Mesh'JazzObjectoids.newcar'
     DrawScale=0.600000
}
