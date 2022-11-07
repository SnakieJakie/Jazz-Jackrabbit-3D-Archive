//=============================================================================
// JazzParticles.
//=============================================================================

// Base class for particle systems
//

class JazzParticles expands JazzEffects;

var() bool DisappearWhenAnimationDone;
var() bool FadeWhileAnimating;
var() bool FadeWhenAnimationDone;
var() bool FloatDownWhenAnimationDone;
var() bool FloatUpWhenAnimationDone;
var() float FadeTime;

auto state ParticleBurst
{

	event Tick( float DeltaTime )
	{
		if (FadeWhileAnimating)
		{
		ScaleGlow = (LifeSpan/FadeTime);
		AmbientGlow = (LifeSpan/FadeTime)*255;
		}
	}
	
/*	event AnimEnd()
	{
		if (DisappearWhenAnimationDone)
		Destroy();
	}*/

Begin:

if (FadeWhileAnimating)
LifeSpan = FadeTime;

PlayAnim(AnimSequence);
FinishAnim();

if (DisappearWhenAnimationDone)
Destroy();

if (FloatDownWhenAnimationDone)
{
//Log("ParticleExplosion) Down");
Velocity.Z = -10;
SetPhysics(PHYS_Projectile);
}
if (FloatUpWhenAnimationDone)
{
//Log("ParticleExplosion) Up");
Velocity.Z = 10;
SetPhysics(PHYS_Projectile);
}

//Log("ParticleExplosion) "$Velocity.Z);

if (FadeWhenAnimationDone)
GotoState('ParticleFadeAway');

GotoState('ParticleBurst');
}

state ParticleFadeAway
{
	event Tick( float DeltaTime )
	{
		ScaleGlow = (LifeSpan/FadeTime);
		AmbientGlow = (LifeSpan/FadeTime)*255;
	}

Begin:
	if (!FadeWhileAnimating)
	LifeSpan = FadeTime;
}

defaultproperties
{
     FadeWhenAnimationDone=True
     FadeTime=1.000000
     bDirectional=True
     RemoteRole=ROLE_Authority
     AnimSequence=Explo
     AnimFrame=1.000000
     AnimRate=0.100000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'UnrealI.Effects.RocketFlare'
     Mesh=Mesh'UnrealShare.b1exp'
     AmbientGlow=255
     bParticles=True
}
