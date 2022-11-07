//=============================================================================
// NewInventoryDisplay.
//=============================================================================
class NewInventoryDisplay expands JazzEffects;

var vector	LocationToGo;
var float	OriginalDrawScale;

var float	ApproachRate;

var float	DisplayTimerMax;
var float	DisplayTimer;
var float	DisplaySpeed;	// 0.2 intial test.  Slower is higher.

var string	ItemName;


// Purpose:
//
// Item must zoom in to the player's display window, where it will rotate and wait for a
// short while.  Description text may also be displayed if set.
//
event PreRender( canvas Canvas )
{
}
event PostRender( canvas Canvas )
{
}

// Initialize inventory display to player HUD
function PostBeginPlay()
{
	JazzHUD(JazzPlayer(Owner).MyHUD).PreRenderInventory = Self;
}

// Zoom to player's view location desired.
//
auto state NewFoundItem
{


function Tick( float DeltaTime )
{
	local float NewDrawScale;
	local rotator NewRotation;

	if (JazzPlayer(Owner) != None)
	{
//		Log("NewFoundItem) Sweep to "$Owner$" "$Owner.Location);
//		Log("NewFoundItem) "$ApproachRate);
		NewRotation = JazzPlayer(Owner).MyCameraRotation;
		NewRotation.Yaw += 16384;
		NewRotation.Pitch = 0;
		LocationToGo = JazzPlayer(Owner).MyCameraLocation +
				100 * vector(JazzPlayer(Owner).MyCameraRotation) +
				70 * vector(NewRotation);
				//vect(100,0,0) << JazzPlayer(Owner).MyCameraRotation;
		//LocationToGo = JazzPlayer(Owner).Location + vect(0,0,100);
//		Log("NewFoundItem) Go "$LocationToGo);

		//SetLocation(LocationToGo);
//		Log("NewFoundItem) At "$Location);
		
		SetLocation(Location + (LocationToGo-Location)/ApproachRate);
		
		// Alter drawscale depending on distance from camera.
		//
		// Never make drawscale larger than original
		NewDrawScale = VSize(LocationToGo-Location)/20+0.2;
		if (NewDrawScale > OriginalDrawScale) NewDrawScale = OriginalDrawScale;
		DrawScale += (NewDrawScale-DrawScale)/3;
		
		// Accelerate approach
		//
		// Rotate object to normal pitch & roll of 0
		//
		
		ApproachRate -= 0.5;
		
		if ((ApproachRate<=1) || (VSize(LocationToGo-Location)<5))
		{
			GotoState('ItemFixedDisplay');
		}
	}
}

	function BeginState()
	{
		ApproachRate = 10;
	}

Begin:
	OriginalDrawScale = DrawScale;
}

state ItemFixedDisplay
{

event PreRender( canvas Canvas )
{
	local rotator NewRotation;
	local int C,Brightness,XStart;

	if (JazzPlayer(Owner) != None)
	{
		NewRotation = JazzPlayer(Owner).MyCameraRotation;
		NewRotation.Yaw += 16384;
		NewRotation.Pitch = 0;
		SetLocation(JazzPlayer(Owner).MyCameraLocation +
				100 * vector(JazzPlayer(Owner).MyCameraRotation) +
				70 * vector(NewRotation));
	}
}

event PostRender( canvas Canvas )
{
	local int	XStart,c,CMax;
	local float Brightness;
		
	XStart = (Canvas.ClipX*0.85)-Len(ItemName)*8/2;
		
	Canvas.Reset();
	Canvas.bNoSmooth = True;
	Canvas.Font = Canvas.MedFont;
	CMax = Len(ItemName);
	for (c=0; c<=CMax; c++)
	{
		Brightness = ((-(DisplayTimerMax-DisplayTimer)/DisplaySpeed)+c+2)*64;
		
		if (Brightness <= 255)
		{
		if (Brightness <= 128) Brightness = 128;

			Canvas.DrawColor.r = Brightness;
			Canvas.DrawColor.g = Brightness;
			Canvas.DrawColor.b = Brightness;
			
			Canvas.SetPos(XStart,Canvas.ClipY*0.4);
			Canvas.DrawText(Mid(ItemName,c,1),false);
		}
		XStart+=8;
	}
}

function Tick( float DeltaTime )
{
	DisplayTimer -= DeltaTime;
	if (DisplayTimer <= 0)
	GotoState('PutItemAway');
}

function BeginState ()
{
	DisplaySpeed = 0.15;
	DisplayTimerMax = (Len(ItemName)+4)*DisplaySpeed;
	DisplayTimer = DisplayTimerMax;
	SetPhysics(PHYS_Rotating);
}

}

state PutItemAway
{

event PreRender( canvas Canvas )
{
	local rotator NewRotation,NewRotationDown;

	if (JazzPlayer(Owner) != None)
	{
//		Log("NewFoundItem) Fixed");
		NewRotation = JazzPlayer(Owner).MyCameraRotation;
		NewRotation.Yaw += 16384;
		NewRotation.Pitch = 0;
		NewRotationDown = JazzPlayer(Owner).MyCameraRotation;
		NewRotationDown.Yaw += 0;
		NewRotationDown.Pitch -= 16384;

		SetLocation(JazzPlayer(Owner).MyCameraLocation +
				100 * vector(JazzPlayer(Owner).MyCameraRotation) +
				70 * vector(NewRotation) +
				ApproachRate * vector(NewRotationDown));
	}
}

event PostRender( canvas Canvas )
{
	local int	XStart,c,CMax;
	local float Brightness;
	
	XStart = (Canvas.ClipX*0.85)-Len(ItemName)*8/2;
		
	Canvas.Reset();
	Canvas.bNoSmooth = True;
	Canvas.Font = Canvas.MedFont;
	CMax = Len(ItemName);
	Brightness = (1-(ApproachRate/100))*128;
	if (Brightness>=0)
	{	
	for (c=0; c<=CMax; c++)
	{
		Canvas.DrawColor.r = Brightness;
		Canvas.DrawColor.g = Brightness;
		Canvas.DrawColor.b = Brightness;
			
		Canvas.SetPos(XStart,Canvas.ClipY*0.4);
		Canvas.DrawText(Mid(ItemName,c,1),false);
		XStart+=8;
	}
	}
}

function Tick ( float DeltaTime )
{
	ApproachRate += (ApproachRate+5)*DeltaTime*3;

	//Log("NewInvDisplay) "$ApproachRate);
	if (ApproachRate>80)
	{
		EndDisplay();	
	}
	
	DisplayTimer += DeltaTime;
}

function BeginState ()
{
	DisplayTimer = 0;
	ApproachRate = 5;
}

}

// Remove and remove actor from the HUD PreRender Update
//
//function Destroy()
//{

//}

function EndDisplay()
{
	//Log("JAZZCELL) Remove from HUD");
	JazzHUD(JazzPlayer(Owner).MyHUD).PreRenderInventory = None;
	Destroy();
}

defaultproperties
{
     bDirectional=True
     bStasis=True
}
