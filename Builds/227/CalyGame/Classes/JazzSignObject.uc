//=============================================================================
// JazzSignObject.
//=============================================================================
class JazzSignObject expands JazzPlainObjects;

//
// This is only the mesh display.
//
// Add in the JazzSign actor around it in order to bring up the text display for
// reading the sign.  This is simply the sign to display as an object.
//

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.sign'
     DrawScale=3.000000
}
