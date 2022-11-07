//=============================================================================
// ActivationPlayerIcon.
//=============================================================================
class ActivationPlayerIcon expands JazzEffects;

//
// This icon is intended to display above any object or person that can be activated.  While
// it may not be used ultimately, it may be quite interesting if done well.
//
//

var 	actor	Focus;
var		float	ActivationTime;

// Set initially to hidden when created
//
function PreBeginPlay()
{
	local rotator Rot;

	Rot.Pitch = 65536/2;
	SetRotation(Rot);

	Hide();
}

// Set to show over an actor
//
function Show ( actor Other )
{
	local vector	V;

	Focus = Other;
	bHidden = false;
	
	//Log("DisplayActivationIcon) "$Other);
}

function Hide ()
{
	bHidden = true;
	LightRadius = 0;
	LightBrightness = 0;
	LightType = LT_None;
	Focus = None;
}

event Tick ( float DeltaTime )
{
	local vector V;

	// Display activation icon
	//
	if (bHidden == false)
	{
		ActivationTime = ActivationTime + DeltaTime;
		
		V = Focus.Location;
		V.Z += Focus.CollisionHeight + 10 + sin(ActivationTime*2)*15;
		LightBrightness = sin(ActivationTime*1.5)*200;
		LightType = LT_Steady;
		SetLocation(V);
	}
}


//
// Pass on Activation Event
//
function DoActivate ()
{
	//Log("ActivationIcon) Activate Passthru "$Focus);
	if (Focus != None)
	Focus.Trigger(Self,Pawn(Owner));
	
	//
	// A Trigger whose Other component is of type ActivationPlayerIcon must be an
	// activation request to the item or NPC.
	//
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'jazzWindow.Misc.MinimizedWindow'
     Skin=Texture'jazzWindow.Misc.MinimizedWindow'
     Mesh=Mesh'JazzObjectoids.arrow'
     DrawScale=0.250000
     bUnlit=True
     LightType=LT_SubtlePulse
     LightEffect=LE_TorchWaver
     LightHue=204
     LightSaturation=102
     LightRadius=15
}
