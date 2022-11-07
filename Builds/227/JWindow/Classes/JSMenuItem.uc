//=============================================================================
// JSMenuItem.
//=============================================================================
class JSMenuItem expands JStartBarObject;

var string Caption;
var string Tip;

var JSMenu Menu;

var JSMenuItem NextItem;
var JSMenuItem PrevItem;

var bool bSelect;

function ShutDown()
{
	if(NextItem != None)
	{
		NextItem.ShutDown();
	}
	
	NextItem = None;
	PrevItem = None;
	Menu = None;
}

function bool LocationCheck(Struct_XY Point, float Y)
{
	if((Point.X >= Menu.Position.X && Point.X <= Menu.Position.X + Menu.DrawX)
	   && (Point.Y >= Menu.Position.Y + Menu.Bar.Main.BaseStyle.MenuLeft.V + Y && Point.Y <= Menu.Position.Y + Menu.Bar.Main.BaseStyle.MenuLeft.V + Y + 9))
	{
		if(NextItem != None)
		{
			NextItem.Deselect();
		}
		
		bSelect = true;
		return true;
	}
	else if(NextItem != None)
	{
		bSelect = false;
		return NextItem.LocationCheck(Point,Y+10);
	}
	else
	{
		bSelect = false;
		return false;
	}
}

function Deselect()
{
	bSelect = false;
	if(NextItem != None)
	{
		NextItem.Deselect();
	}
}

function bool MouseButton(bool bLeft, bool bRelease, Struct_XY Point, float Y)
{
	if((Point.X >= Menu.Position.X && Point.X <= Menu.Position.X + Menu.DrawX)
	   && (Point.Y >= Menu.Position.Y + Menu.Bar.Main.BaseStyle.MenuLeft.V + Y && Point.Y <= Menu.Position.Y + Menu.Bar.Main.BaseStyle.MenuLeft.V + Y + 9))
	{
		if(bLeft && bRelease)
		{
			Clicked();
	   		Menu.bOpen = false;
	   		Menu.Bar.bMouseOpen = false;			
			return true;
		}
		else if(bLeft && !bRelease)
		{
			return true;
		}
	}
	else if(NextItem != None)
	{
		return NextItem.MouseButton(bLeft, bRelease, Point,Y+10);
	}
	else
	{
		return false;
	}
}

function Clicked()
{
	Menu.Bar.Main.AddWindow(None);
}

function FindSize(out float mx,out float my, canvas C)
{
	local float nx, ny;
	C.StrLen(Caption, nx, ny);

	my += ny + 2;	
	
	if(nx > mx)
	{
		mx = nx;
	}
	
	if(NextItem != None)
	{
		NextItem.FindSize(mx, my, C);
	}
}

function StartUp(JSMenu NewMenu)
{
	Menu = NewMenu;
	bSelect = false;
}

function Draw(canvas C, float Y)
{
	local float mx, my;
	local color Old, newc;
	
	Old = C.DrawColor;
	
	newc.g = 170;
	newc.r = 170;
	newc.b = 170;
	
	C.Font = C.SmallFont;

	C.StrLen(Caption, mx, my);
	
	if(bSelect)
	{
		C.DrawColor = newc;
		C.SetPos(Menu.Position.X + Menu.Bar.Main.BaseStyle.PullDownLeft.U, Menu.Position.Y + Menu.Bar.Main.BaseStyle.MenuLeft.V + Menu.Bar.Main.BaseStyle.PullDownUp.V + Y);
		C.DrawTile( Menu.Bar.Main.BaseStyle.BaseTexture, Menu.DrawX - (Menu.Bar.Main.BaseStyle.PullDownLeft.U + Menu.Bar.Main.BaseStyle.PullDownRight.U), my ,Menu.Bar.Main.BaseStyle.PullDownMiddle.X, Menu.Bar.Main.BaseStyle.PullDownMiddle.Y, 			Menu.Bar.Main.BaseStyle.PullDownMiddle.U, Menu.Bar.Main.BaseStyle.PullDownMiddle.V);	
		C.DrawColor = Old;
	}

	C.SetPos(Menu.Position.X + Menu.Bar.Main.BaseStyle.PullDownLeft.U, Menu.Position.Y + Menu.Bar.Main.BaseStyle.MenuLeft.V + Menu.Bar.Main.BaseStyle.PullDownUp.V + Y);
	C.ClipX = C.SizeX;
	C.ClipY = C.SizeY;
	C.DrawText(Caption, false);
	
	y += my + 2;
	
	if(NextItem != None)
	{
		NextItem.Draw(C, Y);
	}
}

defaultproperties
{
}
