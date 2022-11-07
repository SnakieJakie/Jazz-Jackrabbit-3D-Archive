//=============================================================================
// JCursor.
//=============================================================================
class JCursor expands JWindowBase;

// The position of the mouse
var Struct_XY Position;

var JWindowMain Main;

var ECursorState CursorState;
var ECursorState FrozenState;

var bool bFreezeCursor;

var () texture ArrowNormal;
var () texture ArrowResizeH;
var () texture ArrowResizeV;
var () texture ArrowResizeLVH;
var () texture ArrowResizeRVH;

function Shutdown()
{
	Main = None;
}

function Draw(canvas C)
{
	local ECursorState Cursor;

	C.SetPos(Position.X, Position.Y);
	if(bFreezeCursor)
	{
		Cursor = FrozenState;
	}
	else
	{
		Cursor = CursorState;
	}
	
	switch(Cursor)
	{
		case Cursor_Arrow:
			C.DrawIcon(ArrowNormal,Main.Scale);
		break;
		case Cursor_Resize_H:
			C.DrawIcon(ArrowResizeH,Main.Scale);		
		break;
		case Cursor_Resize_V:
			C.DrawIcon(ArrowResizeV,Main.Scale);
		break;
		case Cursor_Resize_LVH:
			C.DrawIcon(ArrowResizeLVH,Main.Scale);
		break;
		case Cursor_Resize_RVH:
			C.DrawIcon(ArrowResizeRVH,Main.Scale);
		break;
	}
}

function StartUp(JWindowMain NewMain)
{
	Main = NewMain;
	CursorState = Cursor_Arrow;
	bFreezeCursor = false;
}

function MoveMouse(float x, float y)
{
	local float mx, my;
	
	mx = Position.X;
	my = Position.Y;
	
	Position.X += x;
	Position.Y -= y;
	
	// Check to make sure the mouse is still on the screen
	if(Position.X < 0)
	{
		Position.X = 0;
	}
	else if(Position.X > Main.Size.X)
	{
		Position.X = Main.Size.X;
	}
	
	if(Position.Y < 0)
	{
		Position.Y = 0;
	}
	else if (Position.Y > Main.Size.Y)
	{
		Position.Y = Main.Size.Y;
	}
	
	Main.LocationCheck(Position);
	Main.MouseMoved((Position.x - mx),(Position.y - my));
}

defaultproperties
{
    ArrowNormal=Texture'JazzWindow.ArrowCursor'
    ArrowResizeH=Texture'JazzWindow.Arrow4'
    ArrowResizeV=Texture'JazzWindow.Arrow2'
    ArrowResizeLVH=Texture'JazzWindow.Arrow3'
    ArrowResizeRVH=Texture'JazzWindow.Arrow1'
}
