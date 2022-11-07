//=============================================================================
// JazzCamControl.
//=============================================================================
class JazzCamControl expands JazzPlayer;

/*
//Kevin's Added Globals
var 	rotator CameraLocationRotation,JazzCameraRotation;
var		vector	GlobalCameraLocation;
var		float	GlobalDeltaTime,CamDist,OuterPerim,InnerPerim,CamTurnFactor,PadDirection,CamWaitTime;
var bool bwashung,bturnleft,bturnright,bforward,bbackward;
var bool bActiveCam, afterfirstrun;
var bool bFacingleft, bFacingright, bPressedPad, WaterJump;

///////////////////////////////////////////////////////////////////////////
function PlaySwimBigStroke(float tweentime);
function PlaySwimSteadyStroke(float tweentime);
function PlaySwimTread(float tweentime);

// CalyChange
function PostBeginPlay ()
{
	Super.PostBeginPlay();
	
	// Use Kevin's Camera System
	UseNormalCamera = true;
	UseKevinCamera = false;		// Camera currently crashes forest level.
	KevinCameraAvailable = true;
}
// CalyChange

event PlayerTick ( float DeltaTime )
{
	// CalyChange
	Super.PlayerTick(DeltaTime);
	
	// Global frame functions
	GlobalDeltaTime=DeltaTime;
}


event PlayerInput( float DeltaTime )
{
	local float SmoothTime, MouseScale;

	// CalyChange
	if (( (bShowMenu) && (myHud != None) ) || (bShowTutorial))
	{
		if ((bShowMenu) && ( myHud.MainMenu != None ))
		{
			myHud.MainMenu.MenuTick( DeltaTime );
		}
		else
		if (bShowTutorial)
		{
			JazzHud(myHud).TutorialTick( DeltaTime );
		}
	// CalyChange
	
		// clear inputs
		bEdgeForward = false;
		bEdgeBack = false;
		bEdgeLeft = false;
		bEdgeRight = false;
		bWasForward = false;
		bWasBack = false;
		bWasLeft = false;
		bWasRight = false;
		aStrafe = 0;
		aTurn = 0;
		aForward = 0;
		aLookUp = 0;
		return;
	}
	else if ( bDelayedCommand )
	{
		bDelayedCommand = false;
		ConsoleCommand(DelayedCommand);
	}
				
	// Check for Dodge move
	// flag transitions
	bEdgeForward = (bWasForward ^^ (aBaseY > 0));
	bEdgeBack = (bWasBack ^^ (aBaseY < 0));
	bEdgeLeft = (bWasLeft ^^ (aStrafe > 0));
	bEdgeRight = (bWasRight ^^ (aStrafe < 0));
	bWasForward = (aBaseY > 0);
	bWasBack = (aBaseY < 0);
	bWasLeft = (aStrafe > 0);
	bWasRight = (aStrafe < 0);
	
	if (aLookUp != 0)
		bKeyboardLook = true;
	if (bSnapLevel != 0)
		bKeyboardLook = false;

	// Smooth and amplify mouse movement
	SmoothTime = FMin(0.2, 3 * DeltaTime);
	MouseScale = MouseSensitivity * DesiredFOV * 0.0111;
	aMouseX = aMouseX * MouseScale;
	aMouseY = aMouseY * MouseScale;

	if ( (SmoothMouseX == 0) || (aMouseX == 0) 
			|| ((SmoothMouseX > 0) != (aMouseX > 0)) )
		SmoothMouseX = aMouseX;
	else if ( (SmoothMouseX < 0.85 * aMouseX) || (SmoothMouseX > 1.17 * aMouseX) )
		SmoothMouseX = 5 * SmoothTime * aMouseX + (1 - 5 * SmoothTime) * SmoothMouseX;
	else
		SmoothMouseX = SmoothTime * aMouseX + (1 - SmoothTime) * SmoothMouseX;

	if ( (SmoothMouseY == 0) || (aMouseY == 0) 
			|| ((SmoothMouseY > 0) != (aMouseY > 0)) )
		SmoothMouseY = aMouseY;
	else if ( (SmoothMouseY < 0.85 * aMouseY) || (SmoothMouseY > 1.17 * aMouseY) )
		SmoothMouseY = 5 * SmoothTime * aMouseY + (1 - 5 * SmoothTime) * SmoothMouseY;
	else
		SmoothMouseY = SmoothTime * aMouseY + (1 - SmoothTime) * SmoothMouseY;

	aMouseX = 0;
	aMouseY = 0;
// set global vars to determine which direction of turning	
	if (abaseX> 0)
		{
		bturnleft = False;
		bturnRight= True;
		}
	else
	if (abaseX < 0)
		{
		bturnLeft = True;	
		bturnRight = False;
		}
	else
		{
		bturnleft = False;
		bturnRight =False;
		}
		
//
	// Remap raw x-axis movement.
	if( bStrafe!=0 )
	{
		// Strafe.
		aStrafe += aBaseX + SmoothMouseX;
		aBaseX   = 0;
	}
	else
		//if ((bForward == True) || (bBackward == True))
	{
		// Forward.
	aTurn  += aBaseX + SmoothMouseX;
	aBaseX  = 0;
	}

	// Remap mouse y-axis movement.
	if( bAlwaysMouseLook || (bLook!=0) )
	{
		// Look up/down.
		bKeyboardLook = false;
		if ( bInvertMouse )
			aLookUp -= SmoothMouseY;
		else
			aLookUp += SmoothMouseY;
	}
	else
	{
		// Move forward/backward.
		aForward += SmoothMouseY;
	}

	// Remap other y-axis movement.
	aForward += aBaseY;
	aBaseY    = 0;
 
 if (aforward > 0)
		{
		bforward = true;
		bBackward= false;
		}
	else
	if (aforward < 0)
		{
		bforward = false;	
		bBackward = true;
		}
	else
		{
		bforward = False;
		bBackWard =False;
		}
/*
if (bforward)
	{
	bpressedpad = True;
	if(bturnleft)
		PadDirection=JazzCameraRotation.yaw+57344;
	else
	if (bturnRight)
		PadDirection=JazzCameraRotation.yaw+8192;
	else
		PadDirection=JazzCameraRotation.yaw;
	}
else
if (bBackward)
	{
	bpressedpad = True;
	if(bturnleft)
		PadDirection=JazzCameraRotation.yaw+40960;
	else
	if (bturnright)
		PadDirection=JazzCameraRotation.yaw+24576;
	else
		PadDirection=JazzCameraRotation.yaw+32768;
	}
else
if (bturnleft)
	{
	bpressedpad = True;
	//PadDirection = JazzCameraRotation.yaw + 49152;
	PadDirection = JazzCameraRotation.yaw + 53000;
	}
else
if (bturnright)
	{
	bpressedpad = True;
	//PadDirection = JazzCameraRotation.yaw + 16384;
	PadDirection = JazzCameraRotation.yaw + 12000;

	}
else
bpressedpad = False;

PadDirection= PadDirection%65536;	
	
ViewRotation.Yaw = PadDirection;	
*/

	// Handle walking.
	HandleWalking();

}


////////////////////// Pt.2 Redo External Viewpoint
// 
//

event PlayerCalcView( out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	//Kevins variables
	local float angle,unrealrads,deltax,deltay,deltaCamToPlayer,CamMoveDist,OutCamDist;
	local float CameraPitchDest,DeltaCameraPitch,BackUpFactor,DeltaRotation,CameraSpeed;
	local rotator JazzCameraRotation2,WallCheckRotation;
	local bool bRotateBehind;
	
	local vector View,HitLocation,HitNormal;
	local float ViewDist, WallOutDist,NewDist,ViewDistIncrease,DistTurned;
	local bool ViewBlocked;

	// CalyChange
	Super.PlayerCalcView(ViewActor,CameraLocation,CameraRotation);
	
	if (!((UseNormalCamera) && (UseKevinCamera)))
	return;
	// CalyChange
	
	bActiveCam = True;  //Take out later when the option is placed in menu
	ViewActor = Self;
	WallOutDist = 5;
	bBehindView = true;	
	CameraSpeed = 1.75;


if (( !IsInState('PlayerSwimming')) && (ViewActor != none) && (WaterJump == False))
{
	//if (AfterFirstRun == False)
	//	{
	//	OuterPerim 	= 150;
	//	InnerPerim  = 50;
	//	AfterFirstRun = True;
	//	}
//Finding angle for camera Centers Camera on Screen
	unrealrads = 65536/(2*pi);
	deltax=(Location.x-GlobalCameralocation.x);
	deltay=(Location.y-GlobalCameralocation.y);
	angle=(Atan(deltay/deltax));
		if(angle >= 0)
		{
		if (deltax < 0)
			angle += pi;
		}
	else
		{
		if (deltax >=0)
			angle += 2*pi;
		else
			angle += pi;
		}
	
	JazzCameraRotation.yaw=Unrealrads* angle;

	/*if ((JazzCameraRotation.yaw+32768) > 65536)
	bFacingRight = (((ViewRotation.yaw%65536) > JazzCameraRotation.Yaw) || 
	((ViewRotation.yaw%65536) < ((32768+JazzCameraRotation.Yaw)-65536)));	
else
	if (((ViewRotation.yaw%65536) > JazzCameraRotation.Yaw) &&
	 ((ViewRotation.Yaw%65536) < (32768+JazzCameraRotation.Yaw)))
	{
	bFacingRight = 	True;
	DistTurned=abs((ViewRotation.Yaw%65536)-16384)/2;
	if (CamTurnFactor < (9000-DistTurned)-125)
		CamTurnFactor -= 3000*GlobalDeltaTime;
	else
		if (CamTurnFactor > (9000-DistTurned)+125)
		 CamTurnFactor += 3000*GlobalDeltaTime;
	
	JazzCameraRotation2.Yaw+=CamTurnFactor;
	}
*/


//if (bFacingRight)
		//JazzCameraRotation.Yaw=JazzCameraRotation.Yaw + 7000;

	CameraRotation = JazzCameraRotation;	 
	 
	
//End of Angle find for camera

//if (JazzCameraRotation.yaw > ViewRotation.Yaw)
//CameraRotation.Yaw += (JazzCameraRotation.Yaw-ViewRotation.Yaw)/3;






//Find if Camera Should Rotate Behind Character

DeltaRotation = (ViewRotation.Yaw%65536)-JazzCameraRotation.Yaw;
	
	if(abs(DeltaRotation)>32768)
		if(DeltaRotation > 0)
			DeltaRotation=((65536-(ViewRotation.Yaw%65536))+JazzCameraRotation.Yaw);
		else
			DeltaRotation=((65536-JazzCameraRotation.Yaw)+(ViewRotation.Yaw%65536));
			
if (bActiveCam)
	{
	if((abs(DeltaRotation) <= 16384) || (CamWaitTime >= 2))
		{
		bRotateBehind = True;
		}
	else
		bRotateBehind = False;
	}
else
	bRotateBehind = False;

/*	if ((bturnleft) && (bForward == False)&& (abs(velocity.x) < 50) && (abs(velocity.y) < 50) && (abs(velocity.z) < 50))
	{
	viewrotation.yaw = JazzCameraRotation.Yaw - 16384; //16384;
	}
else
if ((bturnright) && (bForward == False) && (abs(velocity.x) < 50) && (abs(velocity.y) < 50) && (abs(velocity.z) < 50))

	{
	viewrotation.yaw = JazzCameraRotation.Yaw + 16384;  //16384;
	}

	if (bForward)
	{
	viewrotation.yaw = JazzCameraRotation.Yaw;
	}
	
	if (bBackward)
	{
	viewrotation.yaw = JazzCameraRotation.Yaw + 32768;
	}*/
	
	
//Find Dist Camera from Player
CamDist= (sqrt(((location.X-GlobalCameraLocation.X)**2)+((location.Y-GlobalCameraLocation.Y)**2)));
CamDist= ((CamDist**2)+(GlobalCameraLocation.Z-Location.Z )** 2);
CamDist= sqrt(CamDist);
OutCamDist=CamDist - InnerPerim;
If (OutCamDist > 100)
	OutCamDist = 100;	

//If Jumping Find Camera Angle and Location
WallCheckRotation = CameraLocationRotation;
WallCheckRotation.Pitch = -4000;
if (Trace( HitLocation, HitNormal, Location - (CamDist+30) * vector(WallCheckRotation), Location ) == None)
	{
	If (Self.Velocity.Z <= 0)
		{
		CameraPitchDest = (((Self.Velocity.Z/2500)*16384)-4000);
		DeltaCameraPitch = CameraLocationRotation.Pitch-CameraPitchDest;
		CameraRotation.Pitch = CameraPitchDest;
		}
	else
		{
		CameraPitchDest = (((Self.Velocity.Z/2500)*16384)-4000);
		DeltaCameraPitch = CameraLocationRotation.Pitch-CameraPitchDest;
		CameraRotation.Pitch = CameraPitchDest;
		}
	If (CameraPitchDest > 16384)
		CameraPitchDest = 16384;
	Else
	if (CameraPitchDest < -16384)
		CameraPitchDest = -16384;
		
	DeltaCameraPitch = CameraLocationRotation.Pitch-CameraPitchDest;
	CameraLocationRotation.Pitch -= (3*(DeltaCameraPitch*GlobalDeltaTime));
	CameraRotation.Pitch = CameraLocationRotation.Pitch;
	}
else
	/*
	if((Trace( HitLocation, HitNormal, Location - (CamDist+30) * vector(CameraRotation), Location ) != None))
	{
	While ((Trace( HitLocation, HitNormal, Location - (CamDist+30) * vector(CameraRotation), Location ) != None)) 
	   
	   {
	  if (((Trace( HitLocation, HitNormal, GlobalCameraLocation - 1*vector(rot(0,0,-16384)), GlobalCameraLocation) != level)) &&
	  		(CameraRotation.Pitch > -65536/4))
		CameraRotation.Pitch -=100; 
	   CameraLocationRotation.Pitch = CameraRotation.Pitch;
	   }
	}*/

	if((Trace( HitLocation, HitNormal, Location - (CamDist+30) * vector(CameraRotation), Location ) != None) && 
	   (CameraRotation.Pitch > -65536/4))
	{

	While ((Trace( HitLocation, HitNormal, Location - (CamDist+30) * vector(CameraRotation), Location ) != None) && 
	   (CameraRotation.Pitch > -65536/4))
	   {
	   CameraRotation.Pitch -=100;
	   CameraLocationRotation.Pitch = CameraRotation.Pitch;
	   }
	}
else
	CameraRotation.Pitch = CameraLocationRotation.Pitch;


//End of Jumping Camera

//Finding CameraLocation for Jazz

//ViewRotation.Yaw = (ViewRotation.Yaw%65536);
	if (ViewRotation.Yaw < 0)
		ViewRotation.Yaw  = ViewRotation.Yaw%65536 + 65536;

if ((bRotateBehind))// || ((velocity.X<=1) && (velocity.Y<=1)))
	{
		DeltaCamToPlayer=((abs(CameraRotation.Yaw))-(abs(ViewRotation.Yaw%65536)));

	if(DeltaCamToPlayer >=0)
		{
		if (abs(DeltaCamToPlayer) <= 32768)
			{
			CamMoveDist = abs(CameraSpeed*((DeltaCamToPlayer)*GlobalDeltaTime));
			CameraLocationRotation.Yaw -= CamMoveDist;
			}
		else
			{
			CamMoveDist = abs(CameraSpeed*((65536-abs(DeltaCamToPlayer))*GlobalDeltaTime));
			CameraLocationRotation.Yaw += CamMoveDist;
			}
		}
	else
		{
		if (abs(DeltaCamToPlayer) >= 32768)
			{
			CamMoveDist = abs(CameraSpeed*((65536-abs(DeltaCamToPlayer))*GlobalDeltaTime));
			CameraLocationRotation.Yaw -= CamMoveDist;
			}
		else
			{
			CamMoveDist = abs(CameraSpeed*((DeltaCamToPlayer)*GlobalDeltaTime));
			CameraLocationRotation.Yaw += CamMoveDist;
			
			}
		}
	}


//Check to see if character is running towards Camera
if (((bbackward) ))
{
if (innerPerim < 200)
	innerPerim += GlobalDeltaTime*(250-innerperim);
else innerPerim = 200;
if (outerPerim < 300)
	outerPerim += GlobalDeltaTime*(350-outerperim);
else outerPerim = 300;
}

else
{
if (innerPerim >50)
	innerPerim -= GlobalDeltaTime*(innerperim-49);
else innerPerim = 50;
if (outerPerim >150)
	outerPerim -= GlobalDeltaTime*(outerperim-149);
else outerPerim = 150;
}
	View = vect(1,0,0) >> CameraLocationRotation;
	
	if ((CamDist > (OuterPerim)))
		CameraLocation -= (OuterPerim) * View;
	
	else if ((CamDist > (Outerperim-(Outerperim/8))))
		CameraLocation -= (CamDist * View);
	else
		{
		BackUpFactor = OuterPerim - Camdist;
		BackUpFactor = BackUpFactor/8;
		if ((CamDist < InnerPerim))
		CameraLocation -= (InnerPerim + BackUpFactor) * View;
		else
		CameraLocation -= (CamDist + BackUpFactor) * View;
		}
}
// End of Finding CameraLocation for Jazz




else
//if ( IsInState('PlayerSwimming'))
{
if ( ViewTarget != None )
	{
		ViewActor = ViewTarget;
		CameraLocation = ViewTarget.Location;
		CameraRotation = ViewTarget.Rotation;
		if ( Pawn(ViewTarget) != None )
		{
			if ( PlayerPawn(ViewTarget) != None )
				CameraRotation = PlayerPawn(ViewTarget).ViewRotation;
			CameraLocation.Z += Pawn(ViewTarget).EyeHeight;
		}
		return;
	}

	// View rotation.
	ViewActor = Self;
	CameraRotation = ViewRotation;

	if( bBehindView ) //up and behind
	{
	    ViewDist    = 200;
		WallOutDist = 30;
		View = vect(1,0,0) >> CameraRotation;
		if( Trace( HitLocation, HitNormal, Location - (ViewDist+WallOutDist) * vector(CameraRotation), Location ) != None )
			ViewDist = FMin( (Location - HitLocation) Dot View, ViewDist );
		CameraLocation -= (ViewDist - WallOutDist) * View;
	}
	else
	{
		// First-person view.
		CameraLocation = Location;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
	}
}

GlobalCameraLocation = CameraLocation;
	}









////////////////////// Pt.3 Redo Physics
// 
//
state PlayerWalking
{
/*	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		local vector OldAccel;
		

	//Kevin's New Variables
		local vector View,HitLocation1,HitLocation2,HitLocation3,HitLocation4,HitLocation5,HitLocation6,
		HitNormal1,HitNormal2,HitNormal3,HitNormal4,HitNormal5,HitNormal6,WallGrabLocLeftShoulder,
		WallGrabLocRightShoulder,WallGrabLocLeftWaist,WallGrabLocRightWaist,WallGrabLocRightHead,
		WallGrabLocLeftHead,WallGrabLocRightOverhead,WallGrabLocLeftOverhead;
		local rotator NewViewRotation1,NewViewRotation2;
		local float ViewRotationDirection;
		
		
		
		OldAccel = Acceleration;
		Acceleration = NewAccel;

		
		if (bwashung)
		{
		aforward = 0;
		}

		// JAZZ3 : This is the code that allows some motion while falling.
		if ((Physics == PHYS_Falling))
		{
		// Wall Grabbing DetectionCode
		NewViewRotation1 = ViewRotation;
		NewViewRotation2 = ViewRotation;
		NewViewRotation1.Yaw = ViewRotation.Yaw + 16384;
		NewViewRotation2.Yaw = ViewRotation.Yaw - 16384;
		
		WallGrabLocRightWaist=Location + 20 * vector(NewViewRotation1);
		WallGrabLocLeftWaist =Location + 20 * vector(NewViewRotation2);
		WallGrabLocRightWaist.Z = WallGrabLocRightWaist.Z;
		WallGrabLocLeftWaist.Z = WallGrabLocLeftWaist.Z;
		WallGrabLocRightShoulder = WallGrabLocRightWaist;
		WallGrabLocLeftShoulder = WallGrabLocLeftWaist;
		WallGrabLocRightHead = WallGrabLocRightWaist;
		WallGrabLocLeftHead = WallGrabLocLeftWaist;
		WallGrabLocRightOverHead = WallGrabLocRightWaist;
		WallGrabLocLeftOverHead =  WallGrabLocLeftWaist;
		WallGrabLocRightHead.Z = WallGrabLocRightWaist.Z + 50;
		WallGrabLocLeftHead.Z = WallGrabLocLeftWaist.Z + 50;
		WallGrabLocRightOverhead.Z = WallGrabLocRightWaist.Z + 200;
		WallGrabLocLeftOverhead.Z = WallGrabLocLeftWaist.Z + 200;
		
        
       	if (( Trace( HitLocation1, HitNormal1, WallGrabLocRightWaist + (150) * vector(ViewRotation), Location ) == Level ) &&
			( Trace( HitLocation2, HitNormal2, WallGrabLocLeftWaist + (150) * vector(ViewRotation), Location ) == Level )&&
			( Trace( HitLocation3, HitNormal3, WallGrabLocRightHead + (200) * vector(ViewRotation), Location )!= Level ) &&
			( Trace( HitLocation4, HitNormal4, WallGrabLocLeftHead + (200) * vector(ViewRotation), Location ) != Level ) &&
			( Trace( HitLocation5, HitNormal5, WallGrabLocRightOverHead + (200) * vector(ViewRotation), Location ) != Level ) &&
			( Trace( HitLocation6, HitNormal6, WallGrabLocLeftOverHead +(200) * vector(ViewRotation), Location ) != Level ) &&
			( HitNormal1.Z < 0.4) && (HitNormal2.Z < 0.4)&&
			( Self.Velocity.Z <= 0))
		{
			
		SetLocation(HitLocation1);
		SetPhysics(Phys_None);
		ViewRotation=rotator((HitNormal2)*(-1));
		PlayGrabbing(0.5);
		GotoState('Hanging');	
		
		}
		else
		{
		WaterJump = False;
		}
		

		
		//End of Wall Grabbing Code
		if ((aForward<0) || ((Velocity.Z<10) && (Acceleration.Z<10)))
		Velocity += NewAccel * 0.15 * DeltaTime;
		}
	
		bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );
			
		
		// DoubleJump//
		if (DoubleJumpAllowed)
		{
			DoubleJumpReadyTime -= DeltaTime;
			DoubleJumpDelayTime -= DeltaTime;
			if (bPressedJump && (DoubleJumpReadyTime>0) && (!DoubleJumpAlready) && (DoubleJumpDelayTime<=0))
			{
				DoubleJumpAlready = true;
				DoDoubleJump();
			}
		}
		
		
		// Jump Handling
		//
		if ( bPressedJump )
		{
			DoubleJumpReadyTime = 1.5;
			DoubleJumpDelayTime = 0.5;
			DoJump();
		}
		
		if ( (Physics == PHYS_Walking)
			&& (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			if (!bIsCrouching)
			{
				if (bDuck != 0)
				{
					bIsCrouching = true;
					PlayDuck();
				}
			}
			else if (bDuck == 0)
			{
				OldAccel = vect(0,0,0);
				bIsCrouching = false;
			}

			if ( !bIsCrouching )
			{
				if ( (!bAnimTransition || (AnimFrame > 0)) && (GetAnimGroup(AnimSequence) != 'Landing') )
				{
					if ( Acceleration != vect(0,0,0) )
					{
						if ( (GetAnimGroup(AnimSequence) == 'Waiting') || (GetAnimGroup(AnimSequence) == 'Gesture') || (GetAnimGroup(AnimSequence) == 'TakeHit') )
						{
							bAnimTransition = true;
							TweenToRunning(0.1);
						}
					}
			 		else if ( (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000) 
						&& (GetAnimGroup(AnimSequence) != 'Gesture') ) 
			 		{
			 			if ( GetAnimGroup(AnimSequence) == 'Waiting' )
			 			{
							if ( bIsTurning && (AnimFrame >= 0) ) 
							{
								bAnimTransition = true;
								PlayTurning();
							}
						}
			 			else if ( !bIsTurning ) 
						{
							bAnimTransition = true;
							TweenToWaiting(0.2);
						}
					}
				}
			}
			else
			{
				if ( (OldAccel == vect(0,0,0)) && (Acceleration != vect(0,0,0)) )
					PlayCrawling();
			 	else if ( !bIsTurning && (Acceleration == vect(0,0,0)) && (AnimFrame > 0.1) )
					PlayDuck();
			}
		}
	}*/

	// Basic Jazz Motion
	// 			
	function Landed(vector HitNormal)
	{
		//Global.Landed(HitNormal);	// Do not want normal landed function
		
		//From 'PlayerPawn' - Modified
		PlayLanded(Velocity.Z);
		if (Velocity.Z < -1.4 * JumpZ)
		{
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
			if (Velocity.Z <= -1500)
			{
				if ( Role == ROLE_Authority )
					TakeDamage(-0.05 * (Velocity.Z + 1450), None, Location, vect(0,0,0), 'fell');
			}
		}
		else if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.5 * JumpZ) )
			MakeNoise(0.1 * Level.Game.Difficulty);				
		bJustLanded = true;

		if (Physics==PHYS_Falling) SetPhysics(Phys_Walking);		// CALYCHANGE
		AnimEnd();		// CALYCHANGE
		//End 'PlayerPawn'
		
		// Dash End
		DashTime = 0;
		DashReadyTime = 0;
		
		// DoubleJump End
		DoubleJumpAlready = false;
		DoubleJumpReadyTime = 0;
		
		//For WaterJump
		WaterJump = False;
		//For wall Grab
		bwashung = False;
	}
	
	function DoDoubleJump ()
	{
		local vector VelocityAdd;
		log("JazzPlayer) DoubleJump");
		if ( Role == ROLE_Authority )
			PlaySound(JumpSound, SLOT_Talk, 1.5, true, 1200, 1.0 );
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			MakeNoise(0.1 * Level.Game.Difficulty);
		PlayInAir();
		
		//if (aForward<0)	VelocityAdd.x = aForward/10;	// Only allow reverse speed increase
		VelocityAdd.y = aStrafe/10;
		VelocityAdd = VelocityAdd >> Rotation;
		if (Velocity.z + JumpZ*0.75 >= JumpZ*0.75) Velocity.z = JumpZ*0.75;
		else Velocity.z = JumpZ*0.75;
		
		Velocity += VelocityAdd;
		//if ( Base != Level )
			//Velocity.Z += Base.Velocity.Z; 
		SetPhysics(PHYS_Falling);
		//if ( bCountJumps && (Role == ROLE_Authority) )
			//Inventory.OwnerJumped();
	}
	
	//Player Jumped
	/*function DoJump( optional float F )
	{

		if ( CarriedDecoration != None )
			return;
		if ( !bIsCrouching && (Physics == PHYS_Walking) )
		{
			if ( Role == ROLE_Authority )
				PlaySound(JumpSound, SLOT_Talk, 1.5, true, 1200, 1.0 );
			if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
				MakeNoise(0.1 * Level.Game.Difficulty);
			PlayInAir();
			
		if ((DashTime>0) && (VSize(Velocity)>400))
			{
			Velocity.Z = JumpZ * 0.8;
			DoubleJumpReadyTime = 0;
			}
			else
			//Velocity.Z = JumpZ;
			Velocity.Z = JumpZ*2;
		
			if ( Base != Level )
				Velocity.Z += Base.Velocity.Z; 
			SetPhysics(PHYS_Falling);
			if ( bCountJumps && (Role == ROLE_Authority) )
				Inventory.OwnerJumped();
		}
	}*/

	function DoPlayerTrail ()
	{
		local JazzPlayerTrailImage Image;
		Image = spawn(class'JazzPlayerTrailImage');
		Image.AnimFrame = AnimFrame;
		Image.AnimRate = 0;
		Image.AnimSequence = AnimSequence;
		Image.Mesh = Mesh;
		Image.Skin = Skin;
		Image.DrawScale = DrawScale;
		Image.InitialScaleGlow = DashTime;
	}

	event PlayerTick( float DeltaTime )
	{
		Global.PlayerTick(DeltaTime);
	
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
	}

	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		
		//Kevin's Added locals
		local float ViewRotationDirection,PadDiff;
		
	// CALYCHANGE
	// Use this control system check?
	// <Start>
	//
	if ((UseKevinCamera==false) || (UseNormalCamera==false))
	{
		Super.PlayerMove(DeltaTime);
	}
	else
	{
		GetAxes(Rotation,X,Y,Z);

		aForward *= 0.4;
		aStrafe  *= 0.4;
		aLookup  *= 0.24;
		//aTurn    *= 0.24;   
		//if (bBackward)
	    //aTurn *= -1; 
		//aTurn *= (0.6-CamDist/1000);
		aturn = 0;
		//if ((bturnleft) || (bturnright))
		//aForward = 1000;
		aForward = 0;
	//find which direction is pressed on the controller			
if ((bforward) && (bBackward))
	{
	bforward = False;
	bBackward= False;
	}
if ((bturnleft) && (bturnright))
	{
	bturnleft= False;
	bturnright= False;
	}
if (bforward)
	{
	bpressedpad = True;
	if(bturnleft)
		PadDirection=JazzCameraRotation.yaw+57344;
	else
	if (bturnRight)
		PadDirection=JazzCameraRotation.yaw+8192;
	else
		PadDirection=JazzCameraRotation.yaw;
	}
else
if (bBackward)
	{
	bpressedpad = True;
	if(bturnleft)
		PadDirection=JazzCameraRotation.yaw+40960;
	else
	if (bturnright)
		PadDirection=JazzCameraRotation.yaw+24576;
	else
		PadDirection=JazzCameraRotation.yaw+32768;
	}
else
if (bturnleft)
	{
	
	bpressedpad = True;
    PadDirection = JazzCameraRotation.yaw + 49152;
	}
else
if (bturnright)
	{
	bpressedpad = True;
	PadDirection = JazzCameraRotation.yaw + 16384;
	}
else
bpressedpad = False;

if (bpressedpad)
	{
	CamWaitTime = 0;
	}
else
	{
	CamWaitTime += DeltaTime;
	}
	
PadDirection= PadDirection%65536;	
//aforward = 0;
//ViewRotationDirection = ((ViewRotation.Yaw-(ViewRotation.Yaw%65536))+PadDirection);

/*
// New Control Code
if (bPressedPad)
	{
	if (!bPressedPad)
	{
	//if (((abs(self.velocity.X) < 5 ) && (abs(self.velocity.Y) < 5)) ||
	//	 ((abs(((viewrotation.yaw%65536))-((padDirection))) > 30000) &&
	//	  (abs(((viewrotation.yaw%65536))-((padDirection))) < 34000)))			
	//		{
	//	ViewRotation.Yaw = ViewRotationDirection;
	}
	else
	if (abs((ViewRotation.Yaw%65536)-PadDirection)>32768)
		{
		if ((ViewRotation.Yaw%65536) < PadDirection)
			{
			if ((ViewRotation.Yaw >= ViewRotationDirection))
				{
			 	//ClientMessage('RotateRight1');
				//Rotate Right
				ViewRotation.Yaw = (ViewRotationDirection);	
				}
			else
			if ((ViewRotation.Yaw < viewRotationDirection))
				{
				//	viewrotation.yaw = viewrotation.yaw+1800;
				aturn = 1300;
				}
			}
		else
		if ((ViewRotation.Yaw%65536) >= PadDirection)
			{
			if ((ViewRotation.Yaw < ViewRotationDirection))
				{
				//ClientMessage('RotateLeft1');
				//Rotate Left
				ViewRotation.Yaw = (ViewRotationDirection);
				}
			else
			if ((ViewRotation.Yaw > ViewRotationDirection))
				{
				// viewrotation.yaw = viewrotation.yaw - 1300;
				aturn = -1300;
				}
			}
		}
	else
	if (abs((ViewRotation.Yaw%65536)-PadDirection)<32768)
	{
		if ((ViewRotation.Yaw%65536) > PadDirection)
			{
			if ((ViewRotation.Yaw >= ViewRotationDirection))
				{
			 	//ClientMessage('RotateRight2');
				//Rotate Right
				ViewRotation.Yaw = (ViewRotationDirection);	
				}
			else
			if ((ViewRotation.Yaw < ViewRotationDirection))	
				{
				//	viewrotation.yaw = viewrotation.yaw+1800;
				aturn = 1300;
				}
			}
		else
		if ((ViewRotation.Yaw%65536) < PadDirection)
			{
			if ((ViewRotation.Yaw < ViewRotationDirection))
				{
				//ClientMessage('RotateLeft2');
				//Rotate Left
				ViewRotation.Yaw = (ViewRotationDirection);
				}
			else
			if ((ViewRotation.Yaw > ViewRotationDirection))
				{
				// viewrotation.yaw = viewrotation.yaw - 1300;
				aturn = -1300;
				}
			}
		else
		aturn = 0;
		}
	else
	aturn = 0;
}*/

//  Old But Kinda Working Code
if (bPressedPad)
	{
	//if (((abs(self.velocity.X) < 5 ) && (abs(self.velocity.Y) < 5)) ||
	if	 (((abs(((viewrotation.yaw%65536))-((padDirection))) > 28000) &&
		  (abs(((viewrotation.yaw%65536))-((padDirection))) < 36000)))			
			{
		ViewRotation.Yaw = PadDirection;
	}
	else
	if (abs(ViewRotation.Yaw%65536) >= 32768)
		{
		if ((((PadDirection)) >= abs(ViewRotation.Yaw%65536)) ||	
			(((PadDirection)) <=abs((ViewRotation.Yaw+32768)%65536)))
			{
			//Rotate Right
			if ((Viewrotation.Yaw%65536 <= (PadDirection+1300)) && 
			   (ViewRotation.Yaw%65536 >=(PadDirection-1300)))
			   ViewRotation.Yaw = (PadDirection);
			else
			//	viewrotation.yaw = viewrotation.yaw+1800;
				aturn = 1300;
			}
		else
		if ((((PadDirection)) <= abs(ViewRotation.Yaw%65536)) &&	
			(((PadDirection)) >= abs((ViewRotation.Yaw+32768)%65536)))
			{
			//Rotate Left
			if ((abs(Viewrotation.Yaw%65536) <= ((PadDirection+1300))) && 
			   (abs(ViewRotation.Yaw%65536) >=((PadDirection-1300))))
			   ViewRotation.Yaw = (PadDirection);
			else
			//	viewrotation.yaw = viewrotation.yaw-1800;
				aturn =-1300;
			}
		else
		//aturn = 0;
		viewrotation.yaw = padDirection;
		}
	else
		{
		if ((((PadDirection)) >= abs(ViewRotation.Yaw%65536)) &&
			(((PadDirection)) <= abs((ViewRotation.Yaw+32768)%65536)))
			{
			//Rotate Right
			if ((Viewrotation.Yaw%65536 <= (PadDirection+1300)) && 
			   (ViewRotation.Yaw%65536 >=(PadDirection-1300)))
			   ViewRotation.Yaw = (PadDirection);
			else
			//	viewrotation.yaw = viewrotation.yaw+1800;
				aturn = 1300;
			}
		else
		if ((((PadDirection)) <= abs(ViewRotation.Yaw%65536)) ||
			(((PadDirection)) >= abs((ViewRotation.Yaw+32768)%65536)))
			{
			//RotateLeft
			if ((abs(Viewrotation.Yaw%65536) <= (PadDirection+1300)%65536) && 
			   (abs(ViewRotation.Yaw%65536) >=(PadDirection-1300)%65536))
			   ViewRotation.Yaw = (PadDirection);
			else
			//	viewrotation.yaw = viewrotation.yaw-1800;
				aturn =-1300;
			}
		else
		viewRotation.yaw = padDirection;
		}	
		PadDiff = abs(((ViewRotation.yaw)%65536)-PadDirection);
	if (PadDiff >= 32768)
		PadDiff = 65536 - abs(PadDiff);

	aforward = (32768-PadDiff)/32;


		}

		if (bwashung)
		aTurn = 0;

				/*
		// Super-Dash Acceleration Increase
		//
		//
		DashReadyTime -= DeltaTime;
		if (DashTime>0)
		{
			if ((aTurn != 0) && (Physics != PHYS_Falling))
				DashTime = 0;
			GroundSpeed = 800;
			DashTime -= DeltaTime;
			aForward = (aForward*2) + 600*DeltaTime;
			DoPlayerTrail();
			//if (frand()<0.5)
				//spawn(class'BloodPuff',,,Location + vect(0,0,10));
		}*/
		else
		{
			GroundSpeed = 400;
		}
		
		// Poisoned?  Lower the ground speed.
		// 
		// Ground Speed is set above depending on dash in effect or not.
		//
		if (PoisonEffect)
		{
			GroundSpeed = GroundSpeed*0.6;
		}
		
		
		// Update acceleration.
		NewAccel = aForward*X + aStrafe*Y; 
		NewAccel.Z = 0;
		
		//For wall Grab
		if (bwashung)
		NewAccel = vect(0,0,0);
		
		
		// Forward pressed
		//
		if (bEdgeForward && bWasForward && (DashTime<=0) && (Physics!=PHYS_Falling))
		{
			if (DashReadyTime>0)
			{
				//DodgeDir = DODGE_Forward;
				DashTime = 2;
				DashDirection = DODGE_Forward;
				
				// CalyChange				
				PlayDashSound();
				// CalyChange
			}
			else
			{
				DashReadyTime = 0.5;
			}
		
		}
				
		if ( (Physics == PHYS_Walking) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bSnapToLevel )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;	
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			//add bobbing when walking
			if ( !bShowMenu )
			{
				if ( Speed2D < 10 )
					BobTime += 0.2 * DeltaTime;
				else
					BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
				WalkBob = Y * 0.65 * Bob * Speed2D * sin(6.0 * BobTime);
				if ( Speed2D < 10 )
					WalkBob.Z = Bob * 30 * sin(12 * BobTime);
				else
					WalkBob.Z = Bob * Speed2D * sin(12 * BobTime);
			}
		}	
		else if ( !bShowMenu )
		{ 
			BobTime = 0;
			WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
		}

		// Update rotation.
				
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if ( bPressedJump && ((GetAnimGroup(AnimSequence) == 'Dodge') || (GetAnimGroup(AnimSequence) == 'Landing')) )
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
			bSaveJump = false;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		bPressedJump = bSaveJump;
		}

	// CalyChange
	// Use this control system check?
	// <End>
	//
	}
}

///////////////////////////////////////
// Swimming
// Player movement.
// Player Swimming
/*state PlayerSwimming
{
ignores SeePlayer, HearNoise, Bump;

	function Landed(vector HitNormal)
	{
		//log(class$" Landed while swimming");
		PlayLanded(Velocity.Z);
		if (Velocity.Z < -1.2 * JumpZ)
		{
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
			if (Velocity.Z <= -1100)
			{
				if ( (Velocity.Z < -2000) && (ReducedDamageType != 'All') )
				{
					health = -1000; //make sure gibs
					Died(None, 'fell', Location);
				}
				else if ( Role == ROLE_Authority )
					TakeDamage(-0.1 * (Velocity.Z + 1050), Self, Location, vect(0,0,0), 'fell');
			}
		}
		else if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.5 * JumpZ) )
			MakeNoise(0.1 * Level.Game.Difficulty);				
		bJustLanded = true;
		if ( Region.Zone.bWaterZone )
			SetPhysics(PHYS_Swimming);
		else
		{
			GotoState('PlayerWalking');
			AnimEnd();
		}
	}

	function AnimEnd()
	{
		local vector X,Y,Z;
		GetAxes(Rotation, X,Y,Z);
		if ( (Acceleration Dot X) <= 0 )
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToWaiting(0.2);
			} 
			else
				PlayWaiting();
		}	
		else
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToSwimming(0.2);
			} 
			else
				PlaySwimming();
		}
	}
	
	function ZoneChange( ZoneInfo NewZone )
	{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint;

		if (!NewZone.bWaterZone)
		{
			SetPhysics(PHYS_Falling);
			//if (bUpAndOut && CheckWaterJump(HitNormal)) //check for waterjump
			/*if (bUpAndOut)
			{
				velocity.Z = JumpZ + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
				PlayDuck();
				//DoJump();
				DoubleJumpReadyTime = 1.5;
				DoubleJumpDelayTime = 0.5;
				GotoState('PlayerWalking');
				
			}				
			else*/
			if (!FootRegion.Zone.bWaterZone || (Velocity.Z > 160) )
			{
				GotoState('PlayerWalking');
				AnimEnd();
			}
			else //check if in deep water
			{
				checkpoint = Location;
				checkpoint.Z -= (CollisionHeight + 6.0);
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, false);
				if (HitActor != None)
				{
					GotoState('PlayerWalking');
					AnimEnd();
				}
				else
				{
					Enable('Timer');
					SetTimer(0.7,false);
				}
			}
			//log("Out of water");
		}
		else
		{
			Disable('Timer');
			SetPhysics(PHYS_Swimming);
		}
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		local vector X,Y,Z, Temp;
		
		self.waterspeed = 1000;
		GetAxes(ViewRotation,X,Y,Z);
		Acceleration = NewAccel;

		if ( !bAnimTransition && (GetAnimGroup(AnimSequence) != 'Gesture') )
		{
			if ((X Dot Acceleration) <= 0)
	 		{
		 		 if ( GetAnimGroup(AnimSequence) != 'Waiting' )
					TweenToWaiting(0.1);
			}
			else if ( GetAnimGroup(AnimSequence) == 'Waiting' )
				TweenToSwimming(0.1);
		}
		bUpAndOut = ((X Dot Acceleration) > 0) && ((Acceleration.Z > 0) || (ViewRotation.Pitch > 2048));
		if ( bUpAndOut && !Region.Zone.bWaterZone && /*CheckWaterJump(Temp) &&*/
			(bPressedJump || (SwimmingJumpDuration>0)) ) //check for waterjump
		{
			//velocity.Z = 330 + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
			velocity.Z = JumpZ; //set here so physics uses this for remainder of tick
			PlayDuck();
			
			GotoState('PlayerWalking');
			bPressedJump = false;
			SwimmingJumpDuration = 0;
		}
		/*if (bPressedJump)
		{	
			Log("JazzPlayer) Jump while swimming");
			Velocity.Z += 500;
			SwimmingJumpDuration = 3;  // 3
			bPressedJump = false;
		}*/
		WaterJump = True;
			if ((bPressedJump) && (SwimmingJumpDuration <= 0.5))
		{	
			Log("JazzPlayer) Jump while swimming");
			//Velocity.Z += 500;
			SwimmingJumpDuration = 1;  // 3
			bPressedJump = false;
			velocity = (self.waterspeed*x);
			PlaySwimBigStroke(3.0);
		}

			if (SwimmingJumpDuration<=0)
		{
			if ((bExtra0 > 0) && (bPressedJump == False))
			{
			velocity = ((self.waterspeed/2)*x);
			PlaySwimSteadyStroke(3.0);
			}
		}
		

			if (SwimmingJumpDuration>0)
		{
			SwimmingJumpDuration-=DeltaTime;
			//velocity = (5000*x);
			//Velocity.Z = 300;
		}
			else
		{
			PlaySwimTread(3.0);
		}
		
				
		/*if (SwimmingJumpDuration>0)
		{
			SwimmingJumpDuration-=DeltaTime;
			Velocity.Z = 300;
		}*/
	}

	event PlayerTick( float DeltaTime )
	{
		Global.PlayerTick(DeltaTime);
	
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator oldRotation;
		local vector X,Y,Z, NewAccel;
		local float Speed2D;
	
		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.2;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;  


		aLookup = aforward;
		aLookup  *=0.2;
		aLookup *=-1;
		aforward = 0;
		
		NewAccel = aForward*X + aStrafe*Y + aUp*vect(0,0,1); 
	
		

		//add bobbing when swimming
		if ( !bShowMenu )
		{
			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * Level.TimeSeconds);
			WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * Level.TimeSeconds);
		}
		
		

		
		
		//SwimAnimUpdate();

		// Update rotation.
		oldRotation = Rotation;
		UpdateRotation(DeltaTime, 2);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
	}

	function Timer()
	{
		if ( !Region.Zone.bWaterZone && (Role == ROLE_Authority) )
		{
			//log("timer out of water");
			GotoState('PlayerWalking');
			AnimEnd();
		}
	
		Disable('Timer');
	}
	
	function BeginState()
	{
		Disable('Timer');
		if ( !IsAnimating() )
			TweenToWaiting(0.3);
			
		SwimmingJumpDuration = 0;
	}
}
*/
*/

defaultproperties
{
}
