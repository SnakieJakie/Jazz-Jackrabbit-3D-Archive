//=============================================================================
// JMinButton.
//=============================================================================
class JMinButton expands JButton;

function ButtonPressed()
{
	// Minimize Window
}

function StartUp(JWindowWindow NewWindow)
{
	Super.StartUp(NewWindow);
	Window.bMinButton = true;
}

function FindZone(optional Canvas C)
{
	ZoneLocation.U = Window.Style.MinButtonUp.U;
	ZoneLocation.V = Window.Style.MinButtonUp.V;
	if(!Window.bMinButton)
	{
		ZoneLocation.X = Window.Location.X + Window.Size.X*Window.Main.Scale - Window.Style.TopRight.U*Window.Main.Scale - Window.Style.MinButtonUp.U*Window.Main.Scale - Window.Main.Scale;
	}
	else
	{
		ZoneLocation.X = Window.Location.X + Window.Size.X*Window.Main.Scale - Window.Style.TopRight.U*Window.Main.Scale - Window.Style.MinButtonUp.U*Window.Main.Scale - 2*Window.Main.Scale - Window.Style.ExitButtonUp.U*Window.Main.Scale;
	}
	ZoneLocation.Y = Window.Location.Y + 4*Window.Main.Scale;
}

function Draw(canvas C)
{
	FindZone();

	C.SetPos(ZoneLocation.X,ZoneLocation.Y);
	
	if(bDown)
	{
		C.DrawTile( Window.Style.BaseTexture, Window.Style.MinButtonDown.U*Window.Main.Scale, Window.Style.MinButtonDown.V*Window.Main.Scale, Window.Style.MinButtonDown.X, Window.Style.MinButtonDown.Y, Window.Style.MinButtonDown.U, 			Window.Style.MinButtonDown.V);
	}
	else
	{
		C.DrawTile( Window.Style.BaseTexture, Window.Style.MinButtonUp.U*Window.Main.Scale, Window.Style.MinButtonUp.V*Window.Main.Scale, Window.Style.MinButtonUp.X, Window.Style.MinButtonUp.Y, Window.Style.MinButtonUp.U, 			Window.Style.MinButtonUp.V);	
	}
	
	Super.Draw(C);
}

defaultproperties
{
     StatusText="Minimize Window"
}
