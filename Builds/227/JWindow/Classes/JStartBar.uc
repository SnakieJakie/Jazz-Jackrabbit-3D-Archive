//=============================================================================
// JStartBar.
//=============================================================================
class JStartBar expands JWindowBase;

var JWindowMain Main;

var JSMenu FirstMenu;
var JSMenu LastMenu;

var bool bMouseOpen;

function bool LocationCheck(Struct_XY Point)
{
	if(FirstMenu != None)
	{
		return FirstMenu.LocationCheck(Point);
	}
	else
	{
		return false;
	}
}

function ShutDown()
{
	if(FirstMenu != None)
	{
		FirstMenu.ShutDown();
	}
	
	Main = None;
	FirstMenu = None;
	LastMenu = None;
}

function bool MouseButton(bool bLeft, bool bRelease, Struct_XY Point)
{
	local bool bReturn;
	
	if(FirstMenu != None)
	{
		bReturn = FirstMenu.MouseButton(bLeft,bRelease,Point);
		
		if(!bReturn && bMouseOpen)
		{
			bMouseOpen = false;
			
			FirstMenu.Deselect();
			return false;
		}
		
		return bReturn;
	}
	else
	{
		return false;
	}
}

function StartUp(JWindowMain NewMain)
{
	Main = NewMain;
	
	AddMenu();
	AddMenu();
	AddMenu();
}

function AddMenu(optional class<JSMenu> Menu)
{
	local JSMenu NewMenu;
	
	if(Menu != None)
	{
		NewMenu = new Menu;
	}
	else
	{
		NewMenu = new class'JSMenu';
		NewMenu.Caption = "Testing";
	}
	
	if(LastMenu != None)
	{
		LastMenu.NextMenu = NewMenu;
		NewMenu.PrevMenu = LastMenu;
		LastMenu = NewMenu;
	}
	else
	{
		LastMenu = NewMenu;
		FirstMenu = NewMenu;
	}
	
	NewMenu.StartUp(self);
}

function Draw(canvas C)
{
	// Left part
	C.SetPos(0,0);
	C.DrawTile( Main.BaseStyle.BaseTexture, Main.BaseStyle.MenuLeft.U*Main.Scale, Main.BaseStyle.MenuLeft.V*Main.Scale, Main.BaseStyle.MenuLeft.X, Main.BaseStyle.MenuLeft.Y, Main.BaseStyle.MenuLeft.U, Main.BaseStyle.MenuLeft.V);	
	
	// Middle part
	C.SetPos(Main.BaseStyle.MenuLeft.U*Main.Scale,0);
	C.DrawTile( Main.BaseStyle.BaseTexture, Main.Size.X - (Main.BaseStyle.MenuLeft.U*Main.Scale + Main.BaseStyle.MenuRight.U*Main.Scale), Main.BaseStyle.MenuMiddle.V*Main.Scale, Main.BaseStyle.MenuMiddle.X, Main.BaseStyle.MenuMiddle.Y, 		Main.BaseStyle.MenuMiddle.U, Main.BaseStyle.MenuMiddle.V);		
	
	// Right part
	C.SetPos(Main.Size.X-Main.BaseStyle.MenuRight.U*Main.Scale,0);
	C.DrawTile( Main.BaseStyle.BaseTexture, Main.BaseStyle.MenuRight.U*Main.Scale, Main.BaseStyle.MenuRight.V*Main.Scale, Main.BaseStyle.MenuRight.X, Main.BaseStyle.MenuRight.Y, Main.BaseStyle.MenuRight.U, 		Main.BaseStyle.MenuRight.V);		
	
	if(FirstMenu != None)
	{
		FirstMenu.Draw(C);
	}
}

defaultproperties
{
}
