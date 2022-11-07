//=============================================================================
// JTextBox.
//=============================================================================
class JTextBox expands JWindowObject;

var () string Text;

function Draw(Canvas C)
{
	local float lx, ly;
	
	C.StrLen(Text,lx,ly);
	
	// Draw the window object
	if(Position.X >= Window.ViewOffset.X && Position.Y >= Window.ViewOffset.Y)
	{
		C.ClipX = Window.Location.X + Window.Size.X - Window.Style.Right.U;
		C.ClipY = Window.Location.Y + Window.Size.Y - Window.Style.Bottom.V;
		C.SetPos(Window.Location.X + Window.Style.Left.U + Position.X,Window.Location.Y + Window.Style.Top.V + Position.Y);
		if(C.CurX < C.ClipX && C.CurY < C.ClipY - ly)
		{		
			C.Font = C.SmallFont;
			C.DrawText(Text, false);
		}
	}
	
	Super.Draw(C);
}	

defaultproperties
{
}
