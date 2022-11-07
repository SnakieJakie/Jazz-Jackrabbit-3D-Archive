//=============================================================================
// JWindowObject.
//=============================================================================
class JWindowObject expands JWindowBase;

var JWindowObject NextObject;
var JWindowObject PrevObject;

var JWindowWindow Window;

var () Struct_XY Position;

var () string Id;
var () string ToolTip;

// The object's zone location in
var Zone ZoneLocation;

var bool bFocus;

var () string Text;

function ShutDown()
{
	if(NextObject != None)
	{
		NextObject.ShutDown();
	}
	
	NextObject = None;
	PrevObject = None;
	Window = None;
}

function Draw(canvas C)
{
	// Draw the window object
	
	if(NextObject != None)
	{
		NextObject.Draw(C);
	}
}

function FindZone(optional Canvas C)
{
}

function bool LocationCheck(Struct_XY Point)
{
	if(NextObject != None)
	{
		return NextObject.LocationCheck(Point);
	}
	else
	{
		return false;
	}
}

function bool MouseButton(bool bLeft, bool bRelease, Struct_XY Point)
{
	if(NextObject != None)
	{
		return NextObject.MouseButton(bLeft, bRelease, Point);
	}
	else
	{
		return false;
	}
}

function StartUp(JWindowWindow NewWindow)
{
	Window = NewWindow;
}

defaultproperties
{
}
