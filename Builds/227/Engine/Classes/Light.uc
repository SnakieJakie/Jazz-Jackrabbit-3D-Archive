//=============================================================================
// The light class.
//=============================================================================
class Light expands Actor
	intrinsic;

#exec Texture Import File=Textures\S_Light.pcx  Name=S_Light Mips=Off Flags=2

defaultproperties
{
     bStatic=True
     bHidden=True
     bNoDelete=True
     bMovable=False
     Texture=Texture'Engine.S_Light'
     CollisionRadius=24.000000
     CollisionHeight=24.000000
     LightType=LT_Steady
     LightBrightness=64
     LightSaturation=255
     LightRadius=64
     LightPeriod=32
     LightCone=128
     VolumeBrightness=64
}
