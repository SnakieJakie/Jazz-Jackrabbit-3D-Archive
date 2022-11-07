//=============================================================================
// JButton.
//=============================================================================
class JButton expands JWindowObject;

var bool bDown;
var bool bPressed;

var () string StatusText;

function StartUp(JWindowWindow NewWindow)
{
	Super.StartUp(NewWindow);
	bDown = false;
	bPressed = false;
	FindZone();
}

function FindZone(optional Canvas C);

function bool LocationCheck(Struct_XY Point)
{
	if(bPressed)
	{
		if((Point.X >= ZoneLocation.X && Point.X <= ZoneLocation.X + ZoneLocation.U)
		   && (Point.Y >= ZoneLocation.Y && Point.Y <= ZoneLocation.Y + ZoneLocation.V))	
		{
			Window.Main.UpdateStatusBar(StatusText);
			bDown = true;
			return true;
		}
		else
		{
			Window.Main.UpdateStatusBar("");
			bDown = false;
			return true;
		}
	}
	else if((Point.X >= ZoneLocation.X && Point.X <= ZoneLocation.X + ZoneLocation.U)
	   && (Point.Y >= ZoneLocation.Y && Point.Y <= ZoneLocation.Y + ZoneLocation.V))
	{
		Window.Main.UpdateStatusBar(StatusText);
		return true;
	}
	else
	{
		return Super.LocationCheck(Point);
	}
}

function bool MouseButton(bool bLeft, bool bRelease, Struct_XY Point)
{
	FindZone();
	
	if((Point.X >= ZoneLocation.X && Point.X <= ZoneLocation.X + ZoneLocation.U)
	   && (Point.Y >= ZoneLocation.Y && Point.Y <= ZoneLocation.Y + ZoneLocation.V))
	{
		if(bPressed && bLeft && bRelease)
		{
			bPressed = false;
			ButtonPressed();
			bDown = false;
			return true;
		}
		else if(bLeft && !bRelease)
		{
			bPressed = true;
			bDown = true;
			return true;
		}
	}
	else if(bPressed && bLeft && bRelease)
	{
		bPressed = false;
		bDown = false;
		return true;
	}
	else
	{
		return Super.MouseButton(bLeft,bRelease,Point);
	}
}

function ButtonPressed();

defaultproperties
{
}
