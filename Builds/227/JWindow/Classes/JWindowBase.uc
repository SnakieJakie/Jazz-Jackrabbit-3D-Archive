//=============================================================================
// JWindowBase.
//=============================================================================
class JWindowBase expands Object;

struct Struct_XY
{
	var () config float X, Y;
};

struct Zone
{
	var () config float x, y, u, v;
};

enum ECursorState
{
	Cursor_Arrow,
	Cursor_Resize_V,
	Cursor_Resize_H,
	Cursor_Resize_LVH,
	Cursor_Resize_RVH
};

defaultproperties
{
}
