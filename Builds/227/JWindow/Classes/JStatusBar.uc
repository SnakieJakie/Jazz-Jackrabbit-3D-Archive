//=============================================================================
// JStatusBar.
// 
// Goes across the bottom of the screen.  Used for tool tips and stuff.
//=============================================================================
class JStatusBar expands JWindowBase;

var string Text;

var JWindowMain Main;

function ShutDown()
{
	Main = None;
}

function StartUp(JWindowMain NewMain)
{
	Main = NewMain;
}

function Draw(canvas C)
{
	// Left part
	C.SetPos(0,Main.Size.Y-Main.BaseStyle.StatusLeft.V*Main.Scale);
	C.DrawTile( Main.BaseStyle.BaseTexture, Main.BaseStyle.StatusLeft.U*Main.Scale, Main.BaseStyle.StatusLeft.V*Main.Scale, Main.BaseStyle.StatusLeft.X, Main.BaseStyle.StatusLeft.Y, Main.BaseStyle.StatusLeft.U, Main.BaseStyle.StatusLeft.V);	
	
	// Middle part
	C.SetPos(Main.BaseStyle.StatusLeft.U*Main.Scale,Main.Size.Y-Main.BaseStyle.StatusMiddle.V*Main.Scale);
	C.DrawTile( Main.BaseStyle.BaseTexture, Main.Size.X - (Main.BaseStyle.StatusLeft.U*Main.Scale + Main.BaseStyle.StatusRight.U*Main.Scale), Main.BaseStyle.StatusMiddle.V*Main.Scale, Main.BaseStyle.StatusMiddle.X, Main.BaseStyle.StatusMiddle.Y, 		Main.BaseStyle.StatusMiddle.U, Main.BaseStyle.StatusMiddle.V);		
	
	// Right part
	C.SetPos(Main.Size.X-Main.BaseStyle.StatusRight.U*Main.Scale,Main.Size.Y-Main.BaseStyle.StatusRight.V*Main.Scale);
	C.DrawTile( Main.BaseStyle.BaseTexture, Main.BaseStyle.StatusRight.U*Main.Scale, Main.BaseStyle.StatusRight.V*Main.Scale, Main.BaseStyle.StatusRight.X, Main.BaseStyle.StatusRight.Y, Main.BaseStyle.StatusRight.U, 		Main.BaseStyle.StatusRight.V);		
	
	// The text
	C.SetPos(2*Main.Scale,Main.Size.Y - Main.BaseStyle.StatusLeft.V*Main.Scale + 3*Main.Scale);
	C.Font = C.SmallFont;
	C.DrawText(Text, false);
}

defaultproperties
{
}
