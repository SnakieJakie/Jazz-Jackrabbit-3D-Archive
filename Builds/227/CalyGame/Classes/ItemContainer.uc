//=============================================================================
// ItemContainer.
//=============================================================================
class ItemContainer expands JazzGameObjects;

var()	class	Items[5];	// Items contained inside the container which are released
var		bool	Released;
var		bool	Open;

// Release through touching this actor.
//
var()	bool	ReleaseByTouch;

// Release through destroying this actor.
//
var()	int		Health;
var()	bool	Invulnerable;

// Released items
//
var()	enum	ReleaseType {
REL_Normal,
REL_Forward,	// Release in a generally forward direction instead of all around
REL_Backward,
REL_Left,
REL_Right
} Release;

auto state WaitForRelease
{
	// Release by Touch?
	//
	event Touch ( actor Other )
	{
		//Log("ItemContainer) Touch "$JazzPlayer(Other)$" "$ReleaseByTouch);
		if ((JazzPlayer(Other) != None) && (ReleaseByTouch))
		{
			OpenTouch();
		}
	}
	
	// Release by Destroying?
	//
	event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
	{
		if (!Invulnerable)
		{
			Health -= Damage;
			
			if (Health<=0)
			{
				OpenDestroy();
			}
		}	
	}
	
	// Release by Trigger?
	//
	event Trigger ( actor Other, pawn EventInstigator )
	{
		OpenTrigger();
	}
}

// Release All Items
//
function ReleaseAll()
{
	local int i;
	
	if (!Released)
	{
	for (i=0; i<5; i++)
	{
		if (Items[i] != None)
		{
			DropAnItem(Items[i]);
		}
	}
	Released = true;
	}
}

// Drop Item
// 
// Scatters the object type in a random direction with initial Z velocity upwards and Bounce on.
//
function DropAnItem ( class ItemToDrop )
{
	local actor A;
	local rotator R;
	
	A = spawn(class<actor>(ItemToDrop));
	
	if (A != None)
	{
	
	if (JazzPickupItem(A) != None)
	{
		JazzPickupItem(A).NewPickupDelay();	// Set delay for pickup items to be grabbed
	}

	// General direction of item release
	//
	switch (Release)
	{
	case REL_Normal:
	A.Velocity = VRand()*100;
	A.Velocity.Z = 300;
	break;
	
	case REL_Forward:
	R = Rotation;
	R.Yaw += (FRand()*(65535/3)-65535/6);
	R.Pitch = FRand()*65535/5;
	R.Roll = 0;
	A.Velocity = vect(100,0,0) << Rotation;
	A.Velocity.Z = 300;
	break;
	
	case REL_Left:
	R = Rotation;
	R.Yaw += (FRand()*(65535/3)-65535/6) + (65536/4);
	R.Pitch = FRand()*65535/5;
	R.Roll = 0;
	A.Velocity = vect(100,0,0) << Rotation;
	A.Velocity.Z = 300;
	break;
	
	case REL_Right:
	R = Rotation;
	R.Yaw += (FRand()*(65535/3)-65535/6) - (65536/4);
	R.Pitch = FRand()*65535/5;
	R.Roll = 0;
	A.Velocity = vect(100,0,0) << Rotation;
	A.Velocity.Z = 300;
	break;
	
	case REL_Backward:	
	R = Rotation;
	R.Yaw += (FRand()*(65536/3)-65536/6) - (65536/2);
	R.Pitch = FRand()*65536/5;
	R.Roll = 0;
	A.Velocity = vect(100,0,0) << Rotation;
	A.Velocity.Z = 300;
	break;	
	}
	
	
	//A.Acceleration.Z = 300;
	A.SetLocation(Location+vect(0,0,100));
	A.bBounce = true;
	A.SetPhysics(PHYS_Falling);
	}
}

// Item Container opened by touch
//
function OpenTouch ()
{
	//Log("ItemContainer) OpenTouch");
	ReleaseAll();
	Destroy();
}

// Item Container opened by trigger
//
function OpenTrigger ()
{
	//Log("ItemContainer) OpenTrigger");
	ReleaseAll();
	Destroy();
}

// Item Container opened by shooting/attacking
//
function OpenDestroy ()
{
	//Log("ItemContainer) OpenDestroy");
	ReleaseAll();
	Destroy();
}

defaultproperties
{
}
