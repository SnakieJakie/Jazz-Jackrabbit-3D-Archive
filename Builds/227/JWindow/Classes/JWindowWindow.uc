//=============================================================================
// JWindowWindow.
//=============================================================================
class JWindowWindow expands JWindowBase;

// Other Windows
var JWindowWindow NextWindow;
var JWindowWindow PrevWindow;

var JWindowStyle Style;

var JWindowMain Main;

var bool bExitButton;
var bool bMinButton;

// The current offset of the view
var Struct_XY ViewOffset;

var JWindowObject FirstObject;
var JWindowObject LastObject;

var () string Id;
var () string Caption;

var bool bFocus;

var enum enum_drag_window {
	Drag_Window,
	Drag_Left,
	Drag_Right,
	Drag_LowLeft,
	Drag_LowRight,
	Drag_Bottom,
	Drag_None
} DragState;

// The top left location of the window
var () Struct_XY Location;

// The physical size of the window
var () Struct_XY Size;

// The size of the window
var () Struct_XY WinSize;

function ShutDown()
{
	if(FirstObject != None)
	{
		FirstObject.ShutDown();
	}
	
	if(NextWindow != None)
	{
		NextWindow.ShutDown();
	}
	
	FirstObject = None;
	LastObject = None;
	NextWindow = None;
	PrevWindow = None;
	Style = None;
	Main = None;
}

function bool LocationCheck(Struct_XY Point)
{
	if(FirstObject != None && FirstObject.LocationCheck(Point))
	{
		return true;
	}	
	else if((Point.X >= Location.X && (Point.X <= Location.X + Size.X*Main.Scale)) && (Point.Y >= Location.Y && (Point.Y <= Location.Y + Size.Y*Main.Scale)))
	{
		if((Point.X >= Location.X && Point.X <= Location.X + Size.X*Main.Scale)
		   && (Point.Y >= Location.Y && Point.Y <= Location.Y + Style.Top.V*Main.Scale))
		{
			return false;
		}	
		else if((Point.X <= Location.X + Style.Left.U*Main.Scale) && (Point.Y <= Location.Y + Size.Y*Main.Scale - Style.BottomLeft.V*Main.Scale))
		{
			Main.Cursor.CursorState = Cursor_Resize_H;
			Main.UpdateStatusBar("Resize Left");
			return true;
		}
		else if((Point.X >= Location.X + Size.X*Main.Scale - Style.Left.U*Main.Scale) && (Point.Y <= Location.Y + Size.Y*Main.Scale - Style.BottomRight.V*Main.Scale))
		{
			Main.Cursor.CursorState = Cursor_Resize_H;
			Main.UpdateStatusBar("Resize Right");
			return true;			
		}
		else if((Point.Y >= Location.Y + Size.Y*Main.Scale - Style.Bottom.V*Main.Scale)
		        && (Point.X >= Location.X + Style.BottomLeft.U*Main.Scale)
		        && (Point.X <= Location.X + Size.X*Main.Scale - Style.BottomRight.U*Main.Scale))
		{
			Main.Cursor.CursorState = Cursor_Resize_V;
			Main.UpdateStatusBar("Resize Bottom");
			return true;			
		}
		else if((Point.Y >= Location.Y + Size.Y*Main.Scale - Style.BottomRight.V*Main.Scale)
		       && (Point.X >= Location.X + Size.X*Main.Scale - Style.BottomRight.U*Main.Scale))
		{
			Main.Cursor.CursorState = Cursor_Resize_RVH;
			Main.UpdateStatusBar("Resize Right Corner");
			return true;			
		}
		else if((Point.Y >= Location.Y + Size.Y*Main.Scale - Style.BottomLeft.V*Main.Scale)
		       && (Point.X <= Location.X + Style.BottomLeft.U*Main.Scale))
		{
			Main.Cursor.CursorState = Cursor_Resize_LVH;
			Main.UpdateStatusBar("Resize Left Corner");
			return true;			
		}
	}
	else if(NextWindow != None)
	{
		return NextWindow.LocationCheck(Point);
	}
	
	return false;
}

function MouseInput(float mx, float my)
{
	switch(DragState)
	{
		case Drag_Window:
			Location.x += mx;
			Location.y += my;
		break;
		case Drag_Left:
			if(Size.X >= Style.MinSize.X || Main.Cursor.Position.X <= Location.X+Style.Left.U*Main.Scale)
			{
				if(Main.Cursor.Position.X - mx > Location.X)
				{
					mx = (mx - (Location.X - (Main.Cursor.Position.X - mx)));
				}

				Location.X += mx;
				Size.X -= mx/Main.Scale;
				
				if(Size.X < Style.MinSize.X)
				{
					Location.X -= (Style.MinSize.X - Size.X);
					Size.X = Style.MinSize.X;
				}
			}
		break;
		case Drag_Right:
			if(Main.Cursor.Position.X >= Location.X + Style.MinSize.X*Main.Scale - Style.Right.U*Main.Scale)
			{
				if(Main.Cursor.Position.X + Size.X*Main.Scale - mx > Location.X)
				{
					mx = (mx - (Location.X +Size.X*Main.Scale - (Main.Cursor.Position.X - mx)));
				}
			
				Size.X += mx/Main.Scale;
				
				if(Size.X < Style.MinSize.X)
				{
					Size.X = Style.MinSize.X;
				}
			}
		break;
		case Drag_LowLeft:
			if(Size.X >= Style.MinSize.X || Main.Cursor.Position.X <= Location.X+Style.Left.U*Main.Scale)
			{
				if(Main.Cursor.Position.X - mx > Location.X)
				{
					mx = (mx - (Location.X - (Main.Cursor.Position.X - mx)));
				}

				Location.X += mx;
				Size.X -= mx/Main.Scale;
				
				if(Size.X < Style.MinSize.X)
				{
					Location.X -= (Style.MinSize.X - Size.X);
					Size.X = Style.MinSize.X;
				}
			}		
			if(Main.Cursor.Position.Y >= Location.Y + Style.MinSize.Y*Main.Scale - Style.Bottom.V*Main.Scale)
			{
				if(Main.Cursor.Position.Y + Size.Y*Main.Scale - my > Location.Y)
				{
					my = (my - (Location.Y +Size.Y*Main.Scale - (Main.Cursor.Position.Y - my)));
				}
			
				Size.Y += my/Main.Scale;
				
				if(Size.Y < Style.MinSize.Y)
				{
					Size.Y = Style.MinSize.Y;
				}
			}			
		break;
		case Drag_LowRight:
			if(Main.Cursor.Position.X >= Location.X + Style.MinSize.X*Main.Scale - Style.Right.U*Main.Scale)
			{
				if(Main.Cursor.Position.X + Size.X*Main.Scale - mx > Location.X)
				{
					mx = (mx - (Location.X +Size.X*Main.Scale - (Main.Cursor.Position.X - mx)));
				}
			
				Size.X += mx/Main.Scale;
				
				if(Size.X < Style.MinSize.X)
				{
					Size.X = Style.MinSize.X;
				}
			}		
			if(Main.Cursor.Position.Y >= Location.Y + Style.MinSize.Y*Main.Scale - Style.Bottom.V*Main.Scale)
			{
				if(Main.Cursor.Position.Y + Size.Y*Main.Scale - my > Location.Y)
				{
					my = (my - (Location.Y +Size.Y*Main.Scale - (Main.Cursor.Position.Y - my)));
				}
			
				Size.Y += my/Main.Scale;
				
				if(Size.Y < Style.MinSize.Y)
				{
					Size.Y = Style.MinSize.Y;
				}
			}			
		break;
		case Drag_Bottom:
			if(Main.Cursor.Position.Y >= Location.Y + Style.MinSize.Y*Main.Scale - Style.Bottom.V*Main.Scale)
			{
				if(Main.Cursor.Position.Y + Size.Y*Main.Scale - my > Location.Y)
				{
					my = (my - (Location.Y +Size.Y*Main.Scale - (Main.Cursor.Position.Y - my)));
				}
			
				Size.Y += my/Main.Scale;
				
				if(Size.Y < Style.MinSize.Y)
				{
					Size.Y = Style.MinSize.Y;
				}
			}		
		break;
	}
}


function MouseButton(bool bLeft, bool bRelease, Struct_XY Point)
{
	if(bLeft && bRelease && DragState != Drag_None)
	{
		StopDrag();
	}
	else if(FirstObject != None && FirstObject.MouseButton(bLeft, bRelease, Point))
	{
		// One of the objects used the click, do nothing
	}
	else if((Point.X >= Location.X && (Point.X <= Location.X + Size.X*Main.Scale)) && (Point.Y >= Location.Y && (Point.Y <= Location.Y + Size.Y*Main.Scale)))
	{
		if((Point.X >= Location.X && Point.X <= Location.X + Size.X*Main.Scale)
		   && (Point.Y >= Location.Y && Point.Y <= Location.Y + Style.Top.V*Main.Scale))
		{
			if(bLeft && !bRelease)
			{
				DragState = Drag_Window;			
				StartDrag();
			}
		}
		else if((Point.X <= Location.X + Style.Left.U*Main.Scale) && (Point.Y <= Location.Y + Size.Y*Main.Scale - Style.BottomLeft.V*Main.Scale))
		{
			if(bLeft && !bRelease)
			{
				DragState = Drag_Left;
				StartDrag();
			}
		}
		else if((Point.X >= Location.X + Size.X*Main.Scale - Style.Left.U*Main.Scale) && (Point.Y <= Location.Y + Size.Y*Main.Scale - Style.BottomRight.V*Main.Scale))
		{
			if(bLeft && !bRelease)
			{
				DragState = Drag_Right;
				StartDrag();
			}
		}
		else if((Point.Y >= Location.Y + Size.Y*Main.Scale - Style.Bottom.V*Main.Scale)
		        && (Point.X >= Location.X + Style.BottomLeft.U*Main.Scale)
		        && (Point.X <= Location.X + Size.X*Main.Scale - Style.BottomRight.U*Main.Scale))
		{
			if(bLeft && !bRelease)
			{
				DragState = Drag_Bottom;
				StartDrag();
			}
		}
		else if((Point.Y >= Location.Y + Size.Y*Main.Scale - Style.BottomRight.V*Main.Scale)
		       && (Point.X >= Location.X + Size.X*Main.Scale - Style.BottomRight.U*Main.Scale))
		{
			if(bLeft && !bRelease)
			{
				DragState = Drag_LowRight;
				StartDrag();
			}		
		}
		else if((Point.Y >= Location.Y + Size.Y*Main.Scale - Style.BottomLeft.V*Main.Scale)
		       && (Point.X <= Location.X + Style.BottomLeft.U*Main.Scale))
		{
			if(bLeft && !bRelease)
			{
				DragState = Drag_LowLeft;
				StartDrag();
			}		
		}
		
		Main.GiveFocus(self);
	}
	else if(NextWindow != None)
	{
		NextWindow.MouseButton(bLeft, bRelease, Point);
	}
}

function StartDrag()
{
	Main.bMouseCapture = true;
	Main.CaptureWindow = self;
	Main.Cursor.bFreezeCursor = true;
	switch(DragState)
	{
		case Drag_Left:
		case Drag_Right:
		Main.Cursor.FrozenState = Cursor_Resize_H;
		break;
		case Drag_Bottom:
		Main.Cursor.FrozenState = Cursor_Resize_V;
		break;
		case Drag_None:	
		case Drag_Window:
		Main.Cursor.FrozenState = Cursor_Arrow;
		break;
		case Drag_LowLeft:
		Main.Cursor.FrozenState = Cursor_Resize_LVH;
		break;
		case Drag_LowRight:
		Main.Cursor.FrozenState = Cursor_Resize_RVH;
		break;
	}	
}

function StopDrag()
{
	Main.Cursor.bFreezeCursor = false;
	Main.bMouseCapture = false;
	DragState = Drag_None;
}

function StartUp()
{
	DragState = Drag_None;
	AddExitButton();
	AddMinButton();
	AddButton(None);
	AddTextBox(None);
}

function Close()
{
	if(NextWindow != None)
	{
		NextWindow.PrevWindow = PrevWindow;
	}
	
	if(PrevWindow != None)
	{
		PrevWindow.NextWindow = NextWindow;
	}
	
	if(Main.FirstWindow == self)
	{
		Main.FirstWindow = NextWindow;
	}
	
	if(Main.LastWindow == self)
	{
		Main.LastWindow = PrevWindow;
	}
	
	NextWindow = None;
	
	ShutDown();
}

function AddExitButton()
{	
	local JExitButton NewObject;
	
	NewObject = new class'JExitButton';
	
	if(FirstObject == None)
	{
		FirstObject = NewObject;
		LastObject = NewObject;
	}
	else
	{
		LastObject.NextObject = NewObject;
		NewObject.PrevObject = LastObject;
		LastObject = NewObject;
	}
	
	NewObject.StartUp(self);
}

function AddMinButton()
{	
	local JMinButton NewObject;
	
	NewObject = new class'JMinButton';
	
	if(FirstObject == None)
	{
		FirstObject = NewObject;
		LastObject = NewObject;
	}
	else
	{
		LastObject.NextObject = NewObject;
		NewObject.PrevObject = LastObject;
		LastObject = NewObject;
	}
	
	NewObject.StartUp(self);
}

function AddButton(class<JWindowButton> NewButtonClass)
{
	local JWindowButton NewButton;
	
	if(NewButtonClass != None)
	{
		NewButton = new NewButtonClass;
	}
	else
	{
		newButton = new class'JWindowButton';
		NewButton.Position.X = 10;
		NewButton.Position.Y = 10;
		NewButton.Text = "I'm a Button";
	}
	
	if(FirstObject == None)
	{
		FirstObject = NewButton;
		LastObject = NewButton;
	}
	else
	{
		LastObject.NextObject = NewButton;
		NewButton.PrevObject = LastObject;
		LastObject = NewButton;
	}
	
	NewButton.StartUp(self);	
}

function AddTextBox(class<JTextBox> NewTextClass)
{
	local JTextBox NewBox;
	
	if(NewTextClass != None)
	{
		NewBox = new NewTextClass;
	}
	else
	{
		newBox = new class'JTextBox';
		NewBox.Position.X = 10;
		NewBox.Position.Y = 25;
		NewBox.Text = "I'm some text";
	}
	
	if(FirstObject == None)
	{
		FirstObject = NewBox;
		LastObject = NewBox;
	}
	else
	{
		LastObject.NextObject = NewBox;
		NewBox.PrevObject = LastObject;
		LastObject = NewBox;
	}
	
	NewBox.StartUp(self);	
}

function Draw(canvas C)
{
	// Draw the window
	DrawWindowFrame(C);
	
	if(FirstObject != None)
	{
		FirstObject.Draw(C);
	}
	
	if(PrevWindow != None)
	{
		PrevWindow.Draw(C);
	}
}

function DrawWindowFrame(canvas C)
{
	local float cx;
	
	cx = 0;
	
	// Top Left
	C.SetPos(Location.X,Location.Y);
	C.DrawTile( Style.BaseTexture, Style.TopLeft.U*Main.Scale, Style.TopLeft.V*Main.Scale, Style.TopLeft.X, Style.TopLeft.Y, Style.TopLeft.U, Style.TopLeft.V);
	
	// Top
	C.SetPos(Location.X + Style.TopLeft.U*Main.Scale,Location.Y);
	C.DrawTile( Style.BaseTexture, Size.X*Main.Scale - Style.TopRight.U*Main.Scale - Style.TopLeft.U*Main.Scale, Style.Top.V*Main.Scale, Style.Top.X, Style.Top.Y, Style.Top.U, Style.Top.V);
	
	// Top Right
	C.SetPos(Location.X + Size.X*Main.Scale - Style.TopRight.U*Main.Scale,Location.Y);
	C.DrawTile( Style.BaseTexture, Style.TopRight.U*Main.Scale, Style.TopRight.V*Main.Scale, Style.TopRight.X, Style.TopRight.Y, Style.TopRight.U, Style.TopRight.V);
	
	// Left
	C.SetPos(Location.X,Location.Y + Style.TopLeft.V*Main.Scale);
	C.DrawTile( Style.BaseTexture, Style.Left.U*Main.Scale, Size.Y*Main.Scale - Style.TopLeft.V*Main.Scale - Style.BottomLeft.V*Main.Scale, Style.Left.X, Style.Left.Y, Style.Left.U, Style.Left.V);
		
	// Right
	C.SetPos(Location.X + Size.X*Main.Scale - Style.Right.U*Main.Scale,Location.Y + Style.TopRight.V*Main.Scale);
	C.DrawTile( Style.BaseTexture, Style.Right.U*Main.Scale, Size.Y*Main.Scale - Style.TopRight.V*Main.Scale - Style.BottomRight.V*Main.Scale, Style.Right.X, Style.Right.Y, Style.Right.U, Style.Right.V);
	
	// Bottom Left
	C.SetPos(Location.X,Location.Y + Size.Y*Main.Scale - Style.BottomLeft.V*Main.Scale);
	C.DrawTile( Style.BaseTexture, Style.BottomLeft.U*Main.Scale, Style.BottomLeft.V*Main.Scale, Style.BottomLeft.X, Style.BottomLeft.Y, Style.BottomLeft.U, Style.BottomLeft.V);
		
	// Bottom
	C.SetPos(Location.X + Style.BottomLeft.U*Main.Scale,Location.Y + Size.Y*Main.Scale - Style.BottomLeft.V*Main.Scale);
	C.DrawTile( Style.BaseTexture, Size.X*Main.Scale - Style.BottomRight.U*Main.Scale - Style.BottomLeft.U*Main.Scale, Style.Bottom.V*Main.Scale, Style.Bottom.X, Style.Bottom.Y, Style.Bottom.U, Style.Bottom.V);
		
	// Bottom Right
	C.SetPos(Location.X + Size.X*Main.Scale - Style.Right.U*Main.Scale,Location.Y + Size.Y*Main.Scale - Style.BottomRight.V*Main.Scale);
	C.DrawTile( Style.BaseTexture, Style.BottomRight.U*Main.Scale, Style.BottomRight.V*Main.Scale, Style.BottomRight.X, Style.BottomRight.Y, Style.BottomRight.U, Style.BottomRight.V);	
	
	// Draw background of the window
	C.SetPos(Location.X + Style.Left.U*Main.Scale, Location.Y + Style.Top.V*Main.Scale);
	C.DrawTile( Style.BaseTexture,Size.X*Main.Scale - Style.Left.U*Main.Scale - Style.Right.U*Main.Scale, Size.Y*Main.Scale - Style.Top.V*Main.Scale - Style.Bottom.v*Main.Scale,
	 Style.Background.X, Style.Background.Y, Style.BackGround.U, Style.Background.V);
	 
	// Draw the window title
	C.SetPos(Location.X + Style.TitleOffset.X*Main.Scale, Location.Y + Style.TitleOffset.Y*Main.Scale);
	if(bMinButton)
	{
		cx += 11*Main.Scale;
	}
	
	if(bExitButton)
	{
		cx += 11*Main.Scale;
	}
	
	C.Font = C.SmallFont;
	
	C.ClipX = Location.X + Size.X*Main.Scale - cx - Style.TopRight.U*Main.Scale;
	C.ClipY = 3;
	C.DrawText(Caption, false);
}

defaultproperties
{
}
