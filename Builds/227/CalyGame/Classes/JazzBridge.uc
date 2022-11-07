//=============================================================================
// JazzBridge.
//=============================================================================
class JazzBridge expands JazzMotionObjects;

///////////////////////////////////////////////////////////////////////////////////////////////
// Bridge Initialization												BRIDGE START
///////////////////////////////////////////////////////////////////////////////////////////////
//

function Touch ( actor Other )
{
	local actor A;

	// Bridge has been touched - where?
	//
	Log("Bridge) Touch");
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Self, Pawn(Other) );
}

function UnTouch ( actor Other )
{
	local actor A;

	// Bridge has been touched - where?
	//
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.UnTrigger( Self, Pawn(Other) );
}

function Bump ( actor Other )
{
	local actor A;

	//Log("Bridge) Bump");
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Self, Pawn(Other) );
}

defaultproperties
{
     bDirectional=True
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.Jplank_01'
     Mesh=Mesh'JazzObjectoids.plank'
     DrawScale=7.000000
     CollisionRadius=70.000000
     CollisionHeight=40.000000
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
}
