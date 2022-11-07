//=============================================================================
// JExitButton.
//=============================================================================
class JExitButton expands JButton;

function ButtonPressed()
{
	Window.Close();
}

function StartUp(JWindowWindow NewWindow)
{
	Super.StartUp(NewWindow);
	Window.bExitButton = true;
}

function FindZone(optional canvas C)
{
	ZoneLocation.U = Window.Style.ExitButtonUp.U;
	ZoneLocation.V = Window.Style.ExitButtonUp.V;
	ZoneLocation.X = Window.Location.X + Window.Size.X*Window.Main.Scale - Window.Style.TopRight.U*Window.Main.Scale - Window.Style.ExitButtonUp.U*Window.Main.Scale - 1;
	ZoneLocation.Y = Window.Location.Y + 4*Window.Main.Scale;
}

function Draw(canvas C)
{
	FindZone();

	C.SetPos(ZoneLocation.X,ZoneLocation.Y);
	
	if(bDown)
	{
		C.DrawTile( Window.Style.BaseTexture, Window.Style.ExitButtonDown.U*Window.Main.Scale, Window.Style.ExitButtonDown.V*Window.Main.Scale, Window.Style.ExitButtonDown.X, Window.Style.ExitButtonDown.Y, Window.Style.ExitButtonDown.U, 			Window.Style.ExitButtonDown.V);
	}
	else
	{
		C.DrawTile( Window.Style.BaseTexture, Window.Style.ExitButtonUp.U*Window.Main.Scale, Window.Style.ExitButtonUp.V*Window.Main.Scale, Window.Style.ExitButtonUp.X, Window.Style.ExitButtonUp.Y, Window.Style.ExitButtonUp.U, 			Window.Style.ExitButtonUp.V);	
	}
	
	Super.Draw(C);
}

defaultproperties
{
     StatusText="Close Window"
}
