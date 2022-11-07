//=============================================================================
// JazzDecoration.
//=============================================================================
class JazzDecoration expands actor;

var bool bInUse;

/*// If the object can freeze
var () bool bFreeze;

// If the object is burnable or not
var () bool bBurnable;

// How long the object will burn
var () float BurnTime;

// How long the object will freeze
var () float FreezeTime;

var () bool bPetrify;

var () float PetrifyTime;

// How long the has had an effect on it
var float TimeEffect;

// The fire affect
var JazzPlantFire Fire;


auto state Basic
{
	event Touch(actor Other)
	{
		if(bBurnable && Other.IsA('JazzFire'))
		{
			GotoState('OnFire');
		}
	}
	
	function BeginState()
	{
		Skin = Default.Skin;
	}
}

function Burn()
{
	if(bBurnable)
	{
		GotoState('OnFire');
	}
}

state OnFire
{
	function BeginState()
	{
		SetCollision(true,false,false);
		Fire = spawn(class'JazzPlantFire',self,,Location+vect(0,0,100));
		TimeEffect = 0;
	}
	
	event Tick(float DeltaTime)
	{
		TimeEffect += DeltaTime;
		
		if(TimeEffect >= BurnTime)
		{
			Fire.Destroy();
			Self.Destroy();			
		}
	}
	
	function Burn();
	
	function Freeze()
	{
		GotoState('Basic');
	}
	
	event Touch(actor Other)
	{
/*		if(Other.IsA('JazzPawn'))
		{
			JazzPawn(Other).Burn();
			return;
		}
		else if(Other.IsA('JazzPlayer'))
		{
			JazzPlayer(Other).Burn();
			return;
		}*/
	}
}

state Petrified
{
	function BeginState()
	{
		//Skin = texture'TRock3';
		
		TimeEffect = 0;
	}
	
	function Burn();
	
	function Freeze();
	
	event Tick(float DeltaTime)
	{
		TimeEffect += DeltaTime;
		
		if(TimeEffect >= FreezeTime)
		{
			GotoState('Basic');
		}
	}
}

state Frozen
{
	function BeginState()
	{
		//Skin = texture'liquid3';
		
		TimeEffect = 0;
	}
	
	function Burn()
	{
		GotoState('Basic');
	}
	
	event Tick(float DeltaTime)
	{
		TimeEffect += DeltaTime;
		
		if(TimeEffect >= FreezeTime)
		{
			GotoState('Basic');
		}
	}
}

function Petrify()
{
	if(bPetrify)
	{
		GotoState('Petrified');
	}
}

// The function that freezes the object
function Freeze()
{
	if(bFreeze)
	{
		GotoState('Frozen');
	}
}
*/

defaultproperties
{
}
