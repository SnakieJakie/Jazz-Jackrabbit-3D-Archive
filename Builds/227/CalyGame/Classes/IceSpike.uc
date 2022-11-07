//=============================================================================
// IceSpike.
//=============================================================================
class IceSpike expands JazzAnimations;

var() int NumberOfChunks;
var bool Chunked;

//
// 1. Ice spike appears and slides up out of the ground.  (0.5 sec)
//
// 2. Ice Spike glows and stays still.  (2 sec)
//
// 3. Ice spike explodes.
//

function PreBeginPlay()
{
	spawn(class'SurroundGlow',Self);
}

function Tick ( float DeltaTime )
{

// Still growing
if (LifeSpan>4)
{
	DrawScale = (1-(LifeSpan-4))*4;
	SetCollisionSize(Default.CollisionRadius*DrawScale,Default.CollisionHeight*DrawScale);
}
else
if (LifeSpan>1)
{
	// Wait
}
else
{
	DrawScale = LifeSpan*4;
	SetCollisionSize(Default.CollisionRadius*DrawScale,Default.CollisionHeight*DrawScale);
	Style = STY_Translucent;
}

}

event Destroyed ()
{
	local int x;
	local BaseChunk Chunk;
	local vector Vel;

	// Spawn shards as we end the effect
	// Chunk Effect
	for(x = NumberOfChunks; x > 0; x--)
	{
		Chunk = spawn(class'IceChunk',,,Location);
		
		Vel = VRand() * 300;
		
		Chunk.Velocity = Vel;
		Chunk.RotRand(true);
	}
}

defaultproperties
{
     NumberOfChunks=8
     LifeSpan=5.000000
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.Jicebomb_01'
     Mesh=Mesh'JazzObjectoids.icebomb2'
     AmbientGlow=255
     CollisionRadius=30.000000
     CollisionHeight=40.000000
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
}
