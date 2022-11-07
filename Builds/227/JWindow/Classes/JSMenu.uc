//=============================================================================
// JSMenu.
//=============================================================================
class JSMenu expands JStartBarObject;

var JSMenuItem FirstItem;
var JSMenuItem LastItem;

var JSMenu NextMenu;
var JSMenu PrevMenu;

var bool bOpen;
var bool bSelect;
var bool bSetup;

var Zone Position;

var JStartBar Bar;

var float DrawX;
var float DrawY;

var () String Caption;

function ShutDown()
{
	if(NextMenu != None)
	{
		NextMenu.ShutDown();
	}
	
	if(FirstItem != None)
	{
		FirstItem.ShutDown();
	}
	
	FirstItem = None;
	LastItem = None;
	NextMenu = None;
	PrevMenu = None;
	Bar = None;
}

function bool LocationCheck(Struct_XY Point)
{
	if(bOpen)
	{
		if(!FirstItem.LocationCheck(Point,0))
		{
			if(NextMenu != None)
			{
				return NextMenu.LocationCheck(Point);
			}
		}
	}
	else if(((Point.X >= Position.X) && (Point.X <= (Position.X+Position.U)))
	        && ((Point.Y >= Position.Y) && (Point.Y <= (Position.Y+Position.V))))
	{
		bSelect = true;
		
		if(Bar.bMouseOpen)
		{
			Bar.FirstMenu.Deselect();
			bOpen = true;
		}
		
		if(NextMenu != None)
		{
			NextMenu.Deselect();
		}
		
		if(FirstItem != None)
		{
			FirstItem.Deselect();
		}
		
		return true;
	}
	else
	{
		bSelect = false;
		if(NextMenu != None)
		{
			return NextMenu.LocationCheck(Point);
		}
		else
		{
			return false;
		}
	}
}

function Deselect()
{
	bSelect = false;
	bOpen = false;
		
	if(NextMenu != None)
	{
		NextMenu.Deselect();
	}
}

function bool MouseButton(bool bLeft, bool bRelease, Struct_XY Point)
{
	if(bOpen)
	{
		if( FirstItem.MouseButton(bLeft,bRelease,Point,0) )
		{
			return true;
		}
	}
	
	if(((Point.X >= Position.X) && (Point.X <= (Position.X+Position.U)))
	        && ((Point.Y >= Position.Y) && (Point.Y <= (Position.Y+Position.V))))
	{
		if(bLeft && !bRelease && !bOpen)
		{
			bOpen = true;
			bSelect = true;
			
			Bar.bMouseOpen = true;
		
			if(NextMenu != None)
			{
				NextMenu.Deselect();
			}
	   }
	   else if(bLeft && !bRelease && bOpen)
	   {
	   		bOpen = false;
	   		Bar.bMouseOpen = false;
	   }
	   
	   return true;
	}
	else
	{
		bOpen = false;
		bSelect = false;
		
		if(NextMenu != None)
		{
			return NextMenu.MouseButton(bLeft,bRelease,Point);
		}
		else
		{
			return false;
		}
	}
}

function StartUp(JStartBar NewBar)
{
	bSetup = false;
	bOpen = false;
	Bar = NewBar;
	AddMenuItem(None);
	AddMenuItem(None);
	AddMenuItem(None);
}

function Draw(canvas C)
{
	local float OutX, OutY;
	local Color Color;

	C.Font = C.SmallFont;
	
	if(!bSetup)
	{	
		C.StrLen(Caption,OutX,OutY);
		
		if(PrevMenu != None)
		{
			Position.Y = 0;
			Position.X = PrevMenu.Position.X + PrevMenu.Position.U;
		}
		else
		{
			Position.Y = 0;
			Position.X = 0;
		}
		
		Position.U = OutX + 6;
		Position.V = Bar.Main.BaseStyle.MenuLeft.V;
		bSetup = true;
	}
	
	// Draw the actual menu
	if(bOpen)
	{
		// Left part
		C.SetPos(Position.X*Bar.Main.Scale, Position.Y);
		C.DrawTile( Bar.Main.BaseStyle.BaseTexture, Bar.Main.BaseStyle.ButtonDownLeft.U*Bar.Main.Scale, Bar.Main.BaseStyle.ButtonDownLeft.V*Bar.Main.Scale, Bar.Main.BaseStyle.ButtonDownLeft.X, Bar.Main.BaseStyle.ButtonDownLeft.Y, 			Bar.Main.BaseStyle.ButtonDownLeft.U, Bar.Main.BaseStyle.ButtonDownLeft.V);	
	
		// Middle part
		C.SetPos(Position.X*Bar.Main.Scale + Bar.Main.BaseStyle.ButtonDownLeft.U*Bar.Main.Scale,Position.Y);
		C.DrawTile( Bar.Main.BaseStyle.BaseTexture, Position.U - (Bar.Main.BaseStyle.ButtonDownLeft.U*Bar.Main.Scale + Bar.Main.BaseStyle.ButtonDownRight.U*Bar.Main.Scale), Bar.Main.BaseStyle.ButtonDownMiddle.V*Bar.Main.Scale, 			Bar.Main.BaseStyle.ButtonDownMiddle.X, Bar.Main.BaseStyle.ButtonDownMiddle.Y, Bar.Main.BaseStyle.ButtonDownMiddle.U, Bar.Main.BaseStyle.ButtonDownMiddle.V);		
	
		// Right part
		C.SetPos(Position.X*Bar.Main.Scale + Position.U*Bar.Main.Scale - Bar.Main.BaseStyle.ButtonDownRight.U*Bar.Main.Scale,Position.Y);
		C.DrawTile( Bar.Main.BaseStyle.BaseTexture, Bar.Main.BaseStyle.ButtonDownRight.U*Bar.Main.Scale, Bar.Main.BaseStyle.ButtonDownRight.V*Bar.Main.Scale, Bar.Main.BaseStyle.ButtonDownRight.X, Bar.Main.BaseStyle.ButtonDownRight.Y, 			Bar.Main.BaseStyle.ButtonDownRight.U, Bar.Main.BaseStyle.ButtonDownRight.V);	
	}
	else if(bSelect)
	{
		// Draw a lighter version of the status bar
		Color.R = 255;
		Color.G = 255;
		Color.B = 255;
		
		C.DrawColor = Color;
		
		// Left part
		C.SetPos(Position.X*Bar.Main.Scale, Position.Y);
		C.DrawTile( Bar.Main.BaseStyle.BaseTexture, Bar.Main.BaseStyle.MenuLeft.U*Bar.Main.Scale, Bar.Main.BaseStyle.MenuLeft.V*Bar.Main.Scale, Bar.Main.BaseStyle.MenuLeft.X, Bar.Main.BaseStyle.MenuLeft.Y, Bar.Main.BaseStyle.MenuLeft.U, 			Bar.Main.BaseStyle.MenuLeft.V);	
	
		// Middle part
		C.SetPos(Position.X*Bar.Main.Scale + Bar.Main.BaseStyle.MenuLeft.U*Bar.Main.Scale,Position.Y);
		C.DrawTile( Bar.Main.BaseStyle.BaseTexture, Position.U - (Bar.Main.BaseStyle.MenuLeft.U*Bar.Main.Scale + Bar.Main.BaseStyle.MenuRight.U*Bar.Main.Scale), Bar.Main.BaseStyle.MenuMiddle.V*Bar.Main.Scale, Bar.Main.BaseStyle.MenuMiddle.X, 			Bar.Main.BaseStyle.MenuMiddle.Y, Bar.Main.BaseStyle.MenuMiddle.U, Bar.Main.BaseStyle.MenuMiddle.V);		
	
		// Right part
		C.SetPos(Position.X*Bar.Main.Scale + Position.U*Bar.Main.Scale - Bar.Main.BaseStyle.MenuRight.U*Bar.Main.Scale,Position.Y);
		C.DrawTile( Bar.Main.BaseStyle.BaseTexture, Bar.Main.BaseStyle.MenuRight.U*Bar.Main.Scale, Bar.Main.BaseStyle.MenuRight.V*Bar.Main.Scale, Bar.Main.BaseStyle.MenuRight.X, Bar.Main.BaseStyle.MenuRight.Y, Bar.Main.BaseStyle.MenuRight.U, 			Bar.Main.BaseStyle.MenuRight.V);
	}
	
	C.ClipX = C.SizeX;
	
	// Draw the text
	C.SetPos(Position.X + 3*Bar.Main.Scale, Position.Y + 3*Bar.Main.Scale);
	C.DrawText(Caption);
	
	if(bOpen)
	{
		DrawBox(C);
		
		if(FirstItem != None)
		{
			FirstItem.Draw(C, 0);
		}
	}
	
	if(NextMenu != None)
	{
		NextMenu.Draw(C);
	}
}

function DrawBox(canvas C)
{
	local float mX, mY;
	
	mx = 0;
	my = -2;
	
	if(FirstItem != None)
	{
		FirstItem.FindSize(mx,my,C);
	}
	
	mx += Bar.Main.BaseStyle.PullDownUpLeft.U + Bar.Main.BaseStyle.PullDownUpRight.U;
	my += Bar.Main.BaseStyle.PullDownUpLeft.V + Bar.Main.BaseStyle.PullDownBottomLeft.V;
	
	DrawX = mx;
	DrawY = my;
	
	// Up Left
	C.SetPos(Position.X, Position.Y+Bar.Main.BaseStyle.MenuLeft.V);
	C.DrawTile(Bar.Main.BaseStyle.BaseTexture,Bar.Main.BaseStyle.PullDownUpLeft.U*Bar.Main.Scale, Bar.Main.BaseStyle.PullDownUpLeft.V*Bar.Main.Scale, Bar.Main.BaseStyle.PullDownUpLeft.X, Bar.Main.BaseStyle.PullDownUpLeft.Y, 			Bar.Main.BaseStyle.PullDownUpLeft.U, Bar.Main.BaseStyle.PullDownUpLeft.V);
	// Up
	C.SetPos(Position.X+Bar.Main.BaseStyle.PullDownUpLeft.U, Position.Y+Bar.Main.BaseStyle.MenuLeft.V);
	C.DrawTile(Bar.Main.BaseStyle.BaseTexture,mx - (Bar.Main.BaseStyle.PullDownUpLeft.U + Bar.Main.BaseStyle.PullDownUpRight.U)*Bar.Main.Scale,Bar.Main.BaseStyle.PullDownUp.V*Bar.Main.Scale, Bar.Main.BaseStyle.PullDownUp.X, 			Bar.Main.BaseStyle.PullDownUp.Y, Bar.Main.BaseStyle.PullDownUp.U, Bar.Main.BaseStyle.PullDownUp.V);

	// Up Right
	C.SetPos(Position.X+mx-Bar.Main.BaseStyle.PullDownUpRight.U, Position.Y+Bar.Main.BaseStyle.MenuLeft.V);
	C.DrawTile(Bar.Main.BaseStyle.BaseTexture,Bar.Main.BaseStyle.PullDownUpRight.U*Bar.Main.Scale,Bar.Main.BaseStyle.PullDownUpRight.V*Bar.Main.Scale,Bar.Main.BaseStyle.PullDownUpRight.X,Bar.Main.BaseStyle.PullDownUpRight.Y,
			Bar.Main.BaseStyle.PullDownUpRight.U,Bar.Main.BaseStyle.PullDownUpRight.V);
	
	// Left
	C.SetPos(Position.X, Position.Y + Bar.Main.BaseStyle.MenuLeft.V + Bar.Main.BaseStyle.PullDownUpLeft.V);
	C.DrawTile(Bar.Main.BaseStyle.BaseTexture,Bar.Main.BaseStyle.PullDownLeft.U*Bar.Main.Scale,my - (Bar.Main.BaseStyle.PullDownUpLeft.V + Bar.Main.BaseStyle.PullDownBottomLeft.V)*Bar.Main.Scale,Bar.Main.BaseStyle.PullDownLeft.X, 			Bar.Main.BaseStyle.PullDownLeft.Y, Bar.Main.BaseStyle.PullDownLeft.U, Bar.Main.BaseStyle.PullDownLeft.V);
	
	// Middle
	C.SetPos(Position.X + Bar.Main.BaseStyle.PullDownLeft.U, Position.Y + Bar.Main.BaseStyle.MenuLeft.V + Bar.Main.BaseStyle.PullDownUp.V);
	C.DrawTile(Bar.Main.BaseStyle.BaseTexture, mx - (Bar.Main.BaseStyle.PullDownLeft.U + Bar.Main.BaseStyle.PullDownRight.U)*Bar.Main.Scale, my - (Bar.Main.BaseStyle.PullDownUp.V + Bar.Main.BaseStyle.PullDownBottom.V), 			Bar.Main.BaseStyle.PullDownMiddle.X, Bar.Main.BaseStyle.PullDownMiddle.Y, Bar.Main.BaseStyle.PullDownMiddle.U, Bar.Main.BaseStyle.PullDownMiddle.V);
	
	// Right
	C.SetPos(Position.X+mx-Bar.Main.BaseStyle.PullDownRight.U, Position.Y + Bar.Main.BaseStyle.MenuLeft.V + Bar.Main.BaseStyle.PullDownUpRight.V);
	C.DrawTile(Bar.Main.BaseStyle.BaseTexture,Bar.Main.BaseStyle.PullDownRight.U*Bar.Main.Scale, my - (Bar.Main.BaseStyle.PullDownUpRight.V + Bar.Main.BaseStyle.PullDownBottomRight.V)*Bar.Main.Scale, Bar.Main.BaseStyle.PullDownright.X, 			Bar.Main.BaseStyle.PullDownright.Y, Bar.Main.BaseStyle.PullDownright.U, Bar.Main.BaseStyle.PullDownright.V);

	// Bottom Left
	C.SetPos(Position.X, Position.Y+Bar.Main.BaseStyle.MenuLeft.V + my - Bar.Main.BaseStyle.PullDownBottomLeft.V);
	C.DrawTile(Bar.Main.BaseStyle.BaseTexture,Bar.Main.BaseStyle.PullDownbottomLeft.U*Bar.Main.Scale, Bar.Main.BaseStyle.PullDownbottomLeft.V*Bar.Main.Scale, Bar.Main.BaseStyle.PullDownbottomLeft.X, Bar.Main.BaseStyle.PullDownbottomLeft.Y, 			Bar.Main.BaseStyle.PullDownbottomLeft.U, Bar.Main.BaseStyle.PullDownbottomLeft.V);
	
	// Bottom
	C.SetPos(Position.X+Bar.Main.BaseStyle.PullDownbottomLeft.U, Position.Y+Bar.Main.BaseStyle.MenuLeft.V + my - Bar.Main.BaseStyle.PullDownBottomLeft.V);
	C.DrawTile(Bar.Main.BaseStyle.BaseTexture,mx - (Bar.Main.BaseStyle.PullDownbottomLeft.U + Bar.Main.BaseStyle.PullDownbottomRight.U)*Bar.Main.Scale,Bar.Main.BaseStyle.PullDownbottom.V*Bar.Main.Scale, Bar.Main.BaseStyle.PullDownbottom.X, 			Bar.Main.BaseStyle.PullDownbottom.Y, Bar.Main.BaseStyle.PullDownbottom.U, Bar.Main.BaseStyle.PullDownbottom.V);
	
	// Bottom Right
	C.SetPos(Position.X+mx-Bar.Main.BaseStyle.PullDownbottomRight.U, Position.Y +Bar.Main.BaseStyle.MenuLeft.V+ my - Bar.Main.BaseStyle.PullDownBottomLeft.V);
	C.DrawTile(Bar.Main.BaseStyle.BaseTexture,Bar.Main.BaseStyle.PullDownbottomRight.U*Bar.Main.Scale,Bar.Main.BaseStyle.PullDownbottomRight.V*Bar.Main.Scale,Bar.Main.BaseStyle.PullDownbottomRight.X,Bar.Main.BaseStyle.PullDownbottomRight.Y,
			Bar.Main.BaseStyle.PullDownbottomRight.U,Bar.Main.BaseStyle.PullDownbottomRight.V);
}

function AddMenuItem(class<JSMenuItem> AddItem)
{
	local JSMenuItem NewItem;
	
	if(AddItem != None)
	{
		NewItem = new AddItem;
	}
	else
	{
		NewItem = new class'JSMenuItem';
		NewItem.Caption = "Testing (2)";
	}
	
	if(LastItem != None)
	{
		LastItem.NextItem = NewItem;
		NewItem.PrevItem = LastItem;
		LastItem = NewItem;
	}
	else
	{
		FirstItem = NewItem;
		LastItem = NewItem;
	}
	
	NewItem.StartUp(self);
}

defaultproperties
{
}
