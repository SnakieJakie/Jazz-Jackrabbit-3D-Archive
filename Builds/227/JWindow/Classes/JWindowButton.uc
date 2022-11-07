//=============================================================================
// JWindowButton.
//=============================================================================
class JWindowButton expands JButton;

function FindZone(Optional Canvas C)
{
	local float tx, ty;
	
	if(C != None)
	{
		C.Font = C.SmallFont;
		C.ClipX = C.SizeX;
		C.ClipY = C.SizeY;
		C.StrLen( Text, tx, ty);
		ZoneLocation.X = Window.Location.X + Window.Style.Left.U + Position.X;
		ZoneLocation.Y = Window.Location.Y + Window.Style.Top.V + Position.Y;
		ZoneLocation.V = Window.Style.ButtonUpLeft.V;
		ZoneLocation.U = Window.Style.ButtonUpLeft.U + Window.Style.ButtonUpRight.U + tx;
	}
}

function Draw(canvas C)
{
	local float lx, ly;
	FindZone(C);
	
	// Draw the window object
	if(Position.X >= Window.ViewOffset.X && Position.Y >= Window.ViewOffset.Y)
	{
		C.ClipX = Window.Location.X + Window.Size.X - Window.Style.Right.U;
		C.ClipY = Window.Location.Y + Window.Size.Y - Window.Style.Bottom.V;
		if(!bDown)
		{
			// The object should be drawn
			lx = FMin(Window.Style.ButtonUpLeft.U,C.ClipX - ZoneLocation.X);
			ly = FMin(Window.Style.ButtonUpLeft.V,C.ClipY - ZoneLocation.Y);
			C.SetPos(ZoneLocation.X,ZoneLocation.Y);
			C.DrawTile( Window.Style.BaseTexture, lx, ly, Window.Style.ButtonUpLeft.X, Window.Style.ButtonUpLeft.Y, Window.Style.ButtonUpLeft.U, Window.Style.ButtonUpLeft.V);	
		
			// Middle part
			lx = FMin(ZoneLocation.U - (Window.Style.ButtonUpLeft.U + Window.Style.ButtonUpRight.U), C.ClipX - (ZoneLocation.X + Window.Style.ButtonUpLeft.U));
			ly = FMin(Window.Style.ButtonUpMiddle.V, C.ClipY - ZoneLocation.Y);
			C.SetPos(Window.Style.ButtonUpLeft.U + ZoneLocation.X,ZoneLocation.Y);
			if(C.CurX < C.ClipX && C.CurY < C.ClipY)
			{
				C.DrawTile( Window.Style.BaseTexture, lx, ly, Window.Style.ButtonUpMiddle.X, Window.Style.ButtonUpMiddle.Y, Window.Style.ButtonUpMiddle.U, Window.Style.ButtonUpMiddle.V);		
			}
		
			// Right part
			lx = FMin(Window.Style.ButtonUpRight.U,C.ClipX - (ZoneLocation.X + ZoneLocation.U - Window.Style.ButtonUpright.U));
			ly = FMin(Window.Style.ButtonUpRight.V,C.ClipY - ZoneLocation.Y);
			C.SetPos(ZoneLocation.X + ZoneLocation.U - Window.Style.ButtonUpRight.U,ZoneLocation.Y);
			if(C.CurX < C.ClipX && C.CurY < C.ClipY)
			{			
				C.DrawTile( Window.Style.BaseTexture, lx, ly, Window.Style.ButtonUpRight.X, Window.Style.ButtonUpRight.Y, Window.Style.ButtonUpRight.U,Window.Style.ButtonUpRight.V);
			}
		}
		else
		{
			// The object should be drawn
			lx = FMin(Window.Style.ButtonDownLeft.U,C.ClipX - ZoneLocation.X);
			ly = FMin(Window.Style.ButtonDownLeft.V,C.ClipY - ZoneLocation.Y);			
			C.SetPos(ZoneLocation.X,ZoneLocation.Y);
			C.DrawTile( Window.Style.BaseTexture, lx, ly, Window.Style.ButtondownLeft.X, Window.Style.ButtondownLeft.Y, Window.Style.ButtondownLeft.U, Window.Style.ButtondownLeft.V);	
		
			// Middle part
			lx = FMin(ZoneLocation.U - (Window.Style.ButtonDownLeft.U + Window.Style.ButtonDownRight.U), C.ClipX - (ZoneLocation.X + Window.Style.ButtonDownLeft.U));
			ly = FMin(Window.Style.ButtonDownMiddle.V, C.ClipY - ZoneLocation.Y);			
			C.SetPos(Window.Style.ButtondownLeft.U + ZoneLocation.X,ZoneLocation.Y);
			if(C.CurX < C.ClipX && C.CurY < C.ClipY)
			{			
				C.DrawTile( Window.Style.BaseTexture, lx, ly, Window.Style.ButtondownMiddle.X, Window.Style.ButtondownMiddle.Y, 				Window.Style.ButtondownMiddle.U, Window.Style.ButtondownMiddle.V);		
			}
		
			// Right part
			lx = FMin(Window.Style.ButtonDownRight.U,C.ClipX - (ZoneLocation.X + ZoneLocation.U - Window.Style.ButtonDownRight.U));
			ly = FMin(Window.Style.ButtonDownRight.V,C.ClipY - ZoneLocation.Y);			
			C.SetPos(ZoneLocation.X + ZoneLocation.U - Window.Style.ButtondownRight.U,ZoneLocation.Y);
			if(C.CurX < C.ClipX && C.CurY < C.ClipY)
			{			
				C.DrawTile( Window.Style.BaseTexture, lx, ly, Window.Style.ButtondownRight.X, Window.Style.ButtondownRight.Y, 				Window.Style.ButtondownRight.U,Window.Style.ButtondownRight.V);				
			}
		}
	
		// The text
		C.SetPos(Window.Style.ButtonUpLeft.U + ZoneLocation.X,ZoneLocation.Y + 3);
		if(C.CurX < C.ClipX && C.CurY < C.ClipY)
		{		
			C.Font = C.SmallFont;
			C.DrawText(Text, false);
		}
	}
	
	Super.Draw(C);
}

function ButtonPressed()
{
	Window.Main.AddWindow(None);
}

defaultproperties
{
}
