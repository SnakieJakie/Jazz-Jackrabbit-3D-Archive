//=============================================================================
// JWindowMain.
//=============================================================================
class JWindowMain expands JWindowBase config(JWindow);

// Windows under main
var JWindowWindow FirstWindow;
var JWindowWindow LastWindow;

var JWindowStyle BaseStyle;

var JStatusBar StatusBar;
var JStartBar MenuBar;

var Struct_XY Size;

var JCursor Cursor;

var JWindowWindow CaptureWindow;
var bool bMouseCapture;

var ()config bool bStatusBar;

var ()config float MouseMovement;

// The scaling on the windowing system
var ()config float Scale;

// The owner
var console User;

var bool bInUse;

function StartUp(console NewConsole, canvas C)
{
	User = NewConsole;

	Size.X = C.ClipX;
	Size.Y = C.ClipY;
	
	Cursor = New class'JCursor';
	Cursor.StartUp(Self);
	
	StatusBar = New class'JStatusBar';
	StatusBar.StartUp(self);
	bStatusBar = true;
	
	MenuBar = new class'JStartBar';
	MenuBar.StartUp(self);
	
	BaseStyle = New class'BasicStyle';
}

function MouseButton(bool bLeft, bool bRelease)
{
	if(!MenuBar.MouseButton(bLeft,bRelease,Cursor.Position))
	{
		if(FirstWindow != None)
		{
			FirstWindow.MouseButton(bLeft,bRelease,Cursor.Position);
		}
	}
}

function MouseMoved(float x, float y)
{
	if(bMouseCapture)
	{
		CaptureWindow.MouseInput(x, y);
	}
}

function MouseInput(float x, float y)
{
	local float mx, my;
	
	mx = x*MouseMovement * Scale;
	my = y*MouseMovement * Scale;
	
	Cursor.MoveMouse(mx, my);
}

function LocationCheck(Struct_XY Point)
{
	if(!MenuBar.LocationCheck(Point))
	{
		if(FirstWindow != None)
		{
			if (!FirstWindow.LocationCheck(Point))
			{
				Cursor.CursorState = Cursor_Arrow;
				UpdateStatusBar("");
			}
		}
		else
		{
			UpdateStatusBar("");
		}
	}
}

function GiveFocus(JWindowWindow FocusWindow)
{
	if(FirstWindow != FocusWindow)
	{
		if(LastWindow == FocusWindow)
		{
			LastWindow = FocusWindow.PrevWindow;
			LastWindow.NextWindow = None;
		}
		
		FirstWindow.PrevWindow = FocusWindow;
		FirstWindow.bFocus = false;
		FocusWindow.PrevWindow.NextWindow = FocusWindow.NextWindow;
		FocusWindow.NextWindow.PrevWindow = FocusWindow.PrevWindow;
		FocusWindow.PrevWindow = None;
		FocusWindow.NextWindow = FirstWindow;
		FirstWindow = FocusWindow;
		FirstWindow.bFocus = true;
	}
}

function JWindowWindow AddWindow(class<JWindowWindow> NewWindowClass)
{
	local JWindowWindow NewWindow;
	
	if(NewWindowClass != None)
	{
		NewWindow = New NewWindowClass;
	}
	else
	{
		NewWindow = New class'JWindowWindow';
		if(NewWindow != None)
		{
			NewWindow.Id = "TestWin";
			NewWindow.Caption = "Test";
			NewWindow.Location.X = 10;
			NewWindow.Location.Y = 10;
			NewWindow.Size.X = 80;
			NewWindow.Size.Y = 80;
			NewWindow.WinSize.X = 70;
			NewWindow.WinSize.Y = 70;
			NewWindow.Style = BaseStyle;
		}
	}
		
	if(FirstWindow == None)
	{
		FirstWindow = NewWindow;
		LastWindow = NewWindow;
	}
	else
	{
		FirstWindow.PrevWindow = NewWindow;
		FirstWindow.bFocus = false;
		NewWindow.PrevWindow = None;
		NewWindow.NextWindow = FirstWindow;
		FirstWindow = NewWindow;
	}
	
	NewWindow.bFocus = true;
	NewWindow.Main = self;
	NewWindow.StartUp();
		
	return NewWindow;
}

function UpdateStatusBar(string Status)
{
	StatusBar.Text = Status;
}

function ShutDown()
{
	if(FirstWindow != None)
	{
		FirstWindow.ShutDown();
	}
	
	if(StatusBar != None)
	{
		StatusBar.ShutDown();
	}
	
	if(MenuBar != None)
	{
		MenuBar.ShutDown();
	}
	
	if(Cursor != None)
	{
		Cursor.ShutDown();	
	}
	
	FirstWindow = None;
	LastWindow = None;
	MenuBar = None;
	StatusBar = None;
	Cursor = None;
	BaseStyle = None;
	CaptureWindow = None;
}

function Draw(canvas C)
{
	local Color Color;
	
	Color.R = 235;
	Color.B = 235;
	Color.G = 235;

	C.Reset();
	C.Style = 2;
	C.DrawColor = Color;
	
	C.bNoSmooth = true;
	
	Size.X = C.Sizex;
	Size.Y = C.Sizey;
	
	if(LastWindow != None)
	{
		LastWindow.Draw(C);
	}
	
	if(bStatusBar)
	{
		StatusBar.Draw(C);
	}
	
	MenuBar.Draw(C);
	
	Cursor.Draw(c);
}

defaultproperties
{
     MouseMovement=1.000000
     Scale=1.000000
}
