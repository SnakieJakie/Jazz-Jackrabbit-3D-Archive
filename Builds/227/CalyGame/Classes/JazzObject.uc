//=============================================================================
// JazzObject.
//=============================================================================
class JazzObject expands Actor;

// Basic Item Type
//
var(JazzObject)	enum	ObjectVal {
OBJ_Vegetable,
OBJ_Meat,
OBJ_Mineral,
OBJ_Wood,
OBJ_Metal,
OBJ_Magic
} ObjectMaterial;

// Base Item Type
//
var(JazzObject)	enum	ObjectTypeVal {
OBJ_Natural,
OBJ_LowTech,
OBJ_MedTech,
OBJ_HighTech,
OBJ_SuperHighTech,
OBJ_Magical
} ObjectType;

// Base Item Type
//
var(JazzObject)	enum	ObjectDangerVal {
OBJ_Normal,
OBJ_Dangerous
} ObjectDanger;

// Base Item Type
//
var()			int		BaseInterest;
var()			int		Health;
var()			bool	Destroyable;
var()			class	DestroyEffect;
var()  class<BaseChunk> ChunkClass;
var() 			int 	NumberOfChunks;

var()			bool	bPushable;				// Pushing
var()			sound	PushSound;
var				bool	bPushSoundPlaying;

var()			bool	bGlides;				// Object keeps moving after pushed
var()			bool	bRotates;				// Object rotates when moving
var()			float 	FrictionSlowdown;		// 0 = No friction
												// Higher values - more friction

// Apply velocity from bumping actor
function Bump( actor Other )
{
	local float speed, oldZ;
	if( bPushable && (Pawn(Other)!=None) && (Other.Mass > 40) )
	{
		oldZ = Velocity.Z;
		speed = VSize(Other.Velocity);
		Velocity = Other.Velocity * FMin(120.0, 20 + speed)/speed;

		if (bGlides)
		Acceleration = Other.Acceleration;
		
		if ( Physics == PHYS_None ) {
			Velocity.Z = 25;
			if (!bPushSoundPlaying) PlaySound(PushSound, SLOT_Misc,0.25);
			bPushSoundPlaying = True;			
		}
		else
			Velocity.Z = oldZ;
		SetPhysics(PHYS_Rolling);
		SetTimer(0.3,False);
		Instigator = Pawn(Other);
	}
}


function int Interest( actor Other )
{
	return(BaseInterest);
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	if (Destroyable==false) return;

	Health -= Damage;
	if (Health<=0)
		KilledBy(EventInstigator);
}

function KilledBy ( Pawn EventInstigator )
{
	local int x;
	local BaseChunk Chunk;
	local vector Vel;
	
	// Chunk Effect
	if (ChunkClass != None)
	{
	
		for(x = NumberOfChunks; x > 0; x--)
		{
			Chunk = spawn(ChunkClass,,,Location);
		
			Vel = VRand() * 500;
		
			Chunk.Velocity = Vel;
		}
	}
	
	// Destroy Effect
	if (DestroyEffect != None)
	spawn(class<actor>(DestroyEffect),None,,Location,Rotation);
		
	Destroy();
}

function Landed(vector HitNormall)
{
	if( Instigator!=None && (VSize(Instigator.Location - Location) < CollisionRadius + Instigator.CollisionRadius) )
		SetLocation(Instigator.Location);
	TakeDamage( Velocity.Z/10, Instigator, Vect(0,0,1), Vect(0,0,1)*900,'exploded' );
}

// Trace to vector V and see if anything is in the way.
//
function bool VectorTrace( vector V, vector Origin )
{
	local vector 	HitLocation,HitNormal;
	local actor		A;
	
	A = Trace( HitLocation, HitNormal,	V, Origin );

	// Return true if trace is not blocked.
	return((HitLocation == V) || (A==None));
}

function CenterOfGravityCheck ( float DeltaTime )
{
	local vector NewLocation,OriginLocation;
	local float LocSlide;
	local vector XSpeed,YSpeed;
	
	if ((Physics == PHYS_Walking) || (Physics == PHYS_Rolling))
	{
		// Moving already?
		NewLocation = Location;
		NewLocation.Z -= CollisionHeight + 5;

		// Center blocked?
		if (VectorTrace(NewLocation,Location)==false)
		return;
			
		// Continue to move object in direction that is not blocked.
		OriginLocation = Location;

		LocSlide = 100*DeltaTime;
		XSpeed.X += LocSlide;
		YSpeed.Y += LocSlide;

		NewLocation.X += CollisionRadius;
		OriginLocation.X += CollisionRadius;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// E
		{
			Velocity += XSpeed;
			Acceleration += XSpeed;
		}

		NewLocation.X -= CollisionRadius*2;
		OriginLocation.X -= CollisionRadius*2;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// W
		{
			Velocity -= XSpeed;
			Acceleration -= XSpeed;
		}

		NewLocation.X += CollisionRadius;
		NewLocation.Y += CollisionRadius;
		OriginLocation.X += CollisionRadius;
		OriginLocation.Y += CollisionRadius;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// S
		{
			Velocity += YSpeed;
			Acceleration += YSpeed;
		}

		NewLocation.Y -= CollisionRadius*2;
		OriginLocation.Y -= CollisionRadius*2;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// N
		{
			Velocity -= YSpeed;
			Acceleration -= YSpeed;
		}
	}
}


// Testbed area for function to rotate a rotator
//
//
function rotator RotateRotator ( rotator RotA, rotator RotB )
{
	local vector VectorA,VectorB;
	local float X,Y,Z;
	local float a,b,c,d,e,f,g,h,i;
	
	VectorA = vector(RotA);
	VectorB = vector(RotB);
	
	// Transform around Y axis
	VectorB = VectorA;
	VectorA.X =  cos(0.01) * VectorB.X + sin(0.01) * VectorB.Z;
	VectorA.Z = -sin(0.01) * VectorB.X + cos(0.01) * VectorB.Z;
	
	// Transform around X axis
/*	VectorB = VectorA;
	VectorA.Y =  cos(0.02) * VectorB.Y - sin(0.02) * VectorB.Z;
	VectorA.Z =  sin(0.02) * VectorB.Y + cos(0.02) * VectorB.Z;*/
	
	// Transform around Z axis
/*	VectorB = VectorA;
	VectorA.X =  cos(0.05) * VectorB.X - sin(0.05) * VectorB.Y;
	VectorA.Y =  sin(0.05) * VectorB.X + cos(0.05) * VectorB.Y;*/
	
//	VectorA += VectorB*1000;
	
	//Log("Vector) "$VectorA$" "$VectorB);
	
	return(JazzOrthoRotation(VectorA));
}

function rotator JazzOrthoRotation ( vector V )
{
	local Rotator R;
	local float TestValue,XYSize;
	local bool  YawReverse;
	local bool  PitchReverse;
	
	YawReverse = (V.X<0);
	PitchReverse = (((V.X<0) && (V.Y<0)) || ((V.X>0) && (V.Y>0)));

	TestValue = V.Y/V.X;
	R.Yaw = atan(TestValue)/3.142857/2*65536;
	
/*	R.Yaw = atan(V.Z/
			sqrt(abs(V.Y*V.Y+V.X*V.X)))
				/3.142857/2*65536;*/
	

	XYSize = sqrt((V.X*V.X)+(V.Y*V.Y));
	TestValue = V.Z / XYSize;

	Log("Reverse) "$YawReverse$" "$PitchReverse);	
	if (PitchReverse)
	{
//	R.Pitch = -16384-(16384-atan(TestValue)/3.142857/2*65536);
	R.Pitch = atan(TestValue)/Pi/2*65536;
	//R.Pitch = atan(TestValue)/Pi/2*65536;
	Log("Calc1) **");
	}
	else
	{
	Log("Calc2)");
	R.Pitch = atan(TestValue)/Pi/2*65536;
	}
	
	if (R.Pitch>49152)
	{
		Log("ReverseCalc)");
		R.Pitch = 49152-(R.Pitch-49152);
	}

	Log("Result1) "$atan(TestValue));
	Log("Result2) "$-16384-(16384-atan(TestValue)/Pi/2*65536));
	Log("Vector) "$V$" "$TestValue$" "$XYSize$" "$R);

/*	R.Pitch = atan(V.Z/
			sqrt(abs(V.X*V.X+V.Y*V.Y)))
				/3.142857/2*65536;*/
				
	//Log("Vector) "$V$" "$R);
				
	return(R);
}


// Includes rotation code
//
function Tick ( float DeltaTime )
{
	local rotator ApplyRotation;

	/*
	if (bRotates)
	{	
		Acceleration -= (Acceleration*(DeltaTime*FrictionSlowDown));

		if(Velocity.X != 0)
		{
			ApplyRotation.Pitch -= Velocity.X * 5;
		}
	
		if(Velocity.Y != 0)
		{
			ApplyRotation.Roll += Velocity.Y * 5;
		}

		SetRotation(RotateRotator(Rotation,ApplyRotation));
	}*/

	// Check if object is near edge of ledge and should fall off.
	//	
	CenterOfGravityCheck(DeltaTime);
}

/*
function rotator JazzOrthoRotation ( vector V )
{
	local Rotator R;
	local float TestValue,XYSize;
	local bool  YawReverse;
	local bool  PitchReverse;
	
	YawReverse = (V.X<0);
	PitchReverse = (((V.X<0) && (V.Y<0)) || ((V.X>0) && (V.Y>0)));

	TestValue = V.Y/V.X;
//	if (YawReverse)
//	{
//	R.Yaw = -16384-(16384-atan(TestValue)/3.142857/2*65536);
//	}
//	else
	R.Yaw = atan(TestValue)/3.142857/2*65536;
	
/*	R.Yaw = atan(V.Z/
			sqrt(abs(V.Y*V.Y+V.X*V.X)))
				/3.142857/2*65536;*/
	
	XYSize = sqrt(abs(V.X*V.X)+abs(V.Y*V.Y));
	TestValue = V.Z / XYSize;
	//if (XYSize<0)
//	if (PitchReverse)
//	if (V.X>0)
/	{
//	R.Pitch = -16384-(16384-atan(TestValue)/3.142857/2*65536)-65536/4;
//	R.Pitch = 16384*2-(atan(TestValue)/3.142857/2*65536);
//	R.Pitch = 16384*2+atan(TestValue)/Pi/2*65536;
//	R.Pitch = -atan(TestValue)/Pi/2*65536;
//	Log("Calc1) **");
//	}
///	R.Pitch = atan(TestValue)/Pi/2*65536;
//	else
//	{
//	Log("Calc2)");
	R.Pitch = atan(TestValue)/Pi/2*65536;
//	}
	
	Log("Result1) "$atan(TestValue)/3.142857/2*65536);
	Log("Result2) "$-16384-(16384-atan(TestValue)/Pi/2*65536));
	Log("Vector) "$V$" "$TestValue$" "$XYSize$" "$R);

/*	R.Pitch = atan(V.Z/
			sqrt(abs(V.X*V.X+V.Y*V.Y)))
				/3.142857/2*65536;*/
				
	//Log("Vector) "$V$" "$R);
				
	return(R);
}
*/

defaultproperties
{
}
