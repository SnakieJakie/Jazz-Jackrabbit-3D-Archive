//=============================================================================
// Player start location.
//=============================================================================
class PlayerStart expands NavigationPoint 
	intrinsic;

#exec Texture Import File=Textures\S_Player.pcx Name=S_Player Mips=Off Flags=2

// Players on different teams are not spawned in areas with the
// same TeamNumber unless there are more teams in the level than
// team numbers.
var() byte TeamNumber;
var() bool bSinglePlayerStart;
var() bool bCoopStart;		


function PlayTeleportEffect(actor Incoming, bool bOut)
{
	Level.Game.PlayTeleportEffect(Incoming, bOut, Level.Game.IsA('DeathMatchGame'));
}

defaultproperties
{
     bSinglePlayerStart=True
     bCoopStart=True
     bDirectional=True
     Texture=Texture'Engine.S_Player'
     SoundVolume=128
     CollisionRadius=18.000000
     CollisionHeight=40.000000
}
