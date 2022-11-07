//=============================================================================
// Canvas: A drawing canvas.
// This is a built-in Unreal class and it shouldn't be modified.
//
// Notes.
//   To determine size of a drawable object, set Style to STY_None,
//   remember CurX, draw the thing, then inspect CurX and CurYL.
//=============================================================================
class Canvas expands Object
	intrinsic;

// Objects.
#exec Font Import File=Textures\SmallFont.bmp Name=SmallFont
#exec Font Import File=Textures\MedFont.pcx   Name=MedFont
#exec Font Import File=Textures\LargeFont.pcx Name=LargeFont
#exec Font Import File=Textures\BigFont.pcx   Name=BigFont

// Modifiable properties.
var font    Font;            // Font for DrawText.
var float   SpaceX, SpaceY;  // Spacing for after Draw*.
var float   OrgX, OrgY;      // Origin for drawing.
var float   ClipX, ClipY;    // Bottom right clipping region.
var float   CurX, CurY;      // Current position for drawing.
var float   Z;               // Z location. 1=no screenflash, 2=yes screenflash.
var byte    Style;           // Drawing style STY_None means don't draw.
var float   CurYL;           // Largest Y size since DrawText.
var color   DrawColor;       // Color for drawing.
var bool    bCenter;         // Whether to center the text.
var bool    bNoSmooth;       // Don't bilinear filter.
var const int SizeX, SizeY;  // Zero-based actual dimensions.

// Stock fonts.
var const font SmallFont;    // Small system font.
var const font MedFont;      // Medium system font.
var const font BigFont;      // Big system font.
var const font LargeFont;    // Large system font.

// Internal.
var const viewport Viewport; // Viewport that owns the canvas.
var const int FramePtr;      // Scene frame pointer.
var const int RenderPtr;	 // Render device pointer, only valid during UGameEngine::Draw

// Intrinsic functions.
intrinsic(464) final function StrLen( coerce string[255] String, out float XL, out float YL );
intrinsic(465) final function DrawText( coerce string[255] Text, optional bool CR );
intrinsic(466) final function DrawTile( texture Tex, float XL, float YL, float U, float V, float UL, float VL );
intrinsic(467) final function DrawActor( Actor A, bool WireFrame );

// UnrealScript functions.
event Reset()
{
	Font        = Default.Font;
	SpaceX      = Default.SpaceX;
	SpaceY      = Default.SpaceY;
	OrgX        = Default.OrgX;
	OrgY        = Default.OrgY;
	CurX        = Default.CurX;
	CurY        = Default.CurY;
	Style       = Default.Style;
	DrawColor   = Default.DrawColor;
	CurYL       = Default.CurYL;
	bCenter     = false;
	bNoSmooth   = false;
	Z           = 1.0;
}
final function SetPos( float X, float Y )
{
	CurX = X;
	CurY = Y;
}
final function SetOrigin( float X, float Y )
{
	OrgX = X;
	OrgY = Y;
}
final function SetClip( float X, float Y )
{
	ClipX = X;
	ClipY = Y;
}
final function DrawPattern( texture Tex, float XL, float YL, float Scale )
{
	DrawTile( Tex, XL, YL, (CurX-OrgX)*Scale, (CurY-OrgY)*Scale, XL*Scale, YL*Scale );
}
final function DrawIcon( texture Tex, float Scale )
{
	DrawTile( Tex, Tex.USize*Scale, Tex.VSize*Scale, 0, 0, Tex.USize, Tex.VSize );
}
final function DrawRect( texture Tex, float RectX, float RectY )
{
	DrawTile( Tex, RectX, RectY, 0, 0, Tex.USize, Tex.VSize );
}

defaultproperties
{
     Style=1
     DrawColor=(R=127,G=127,B=127)
     SmallFont=Font'Engine.SmallFont'
     MedFont=Font'Engine.MedFont'
     BigFont=Font'Engine.BigFont'
     LargeFont=Font'Engine.LargeFont'
}
