//=============================================================================
// BigRedLizard.
//=============================================================================
class BigRedLizard expands Lizard;

var actor InvulnerableGlow;
var float SpecialEffectTime;

/////////////////////////////////////////////////////////////////////////////////////
// Override Action														STATES
/////////////////////////////////////////////////////////////////////////////////////
//
//
//
state HitAnimation
{

Begin:
	IgnoreAllDecisions = true;
	StateBasedInvulnerability = true;
	InvulnerableGlow = spawn(class'SurroundGlow',Self);

	SpecialEffectTime = 4;
	InvulnerabilityTime = 4;
	
	Acceleration = vect(0,0,0);
	TweenAnim('LizardIdle',0.3);
	Sleep(0.3);
	
	PlayAnim('LizardIdle',0.3);
	Sleep(0.5);
	
	InvulnerableGlow.Destroy();
	
	IgnoreAllDecisions = false;
	GotoState('Decision');
}

function Tick ( float DeltaTime )
{
	Super.Tick(DeltaTime);
	
	if (SpecialEffectTime>0)
	{
		SpecialEffectTime -= DeltaTime;
		InvulnerableGlow.ScaleGlow = SpecialEffectTime;

		DoPlayerTrail();
	}
	else
	{
		StateBasedInvulnerability = false;
		
		if (InvulnerableGlow != None)
		InvulnerableGlow.Destroy();
	}
}

function DoPlayerTrail ()
{
	local JazzPlayerTrailImage Image;
	Image = spawn(class'JazzPlayerTrailImage');
	Image.AnimFrame = AnimFrame;
	Image.AnimRate = 0;
	Image.AnimSequence = AnimSequence;
	Image.Mesh = Mesh;
	Image.Skin = Skin;
	Image.DrawScale = DrawScale;
}

defaultproperties
{
     RushSpeed=320.000000
     JumpOnDamage=5
     JumpOnTakeDamage=True
     JumperDamage=5
     JumperTakeDamage=True
     FireDamage=0.500000
     WaterDamage=1.500000
     DropItemHealth75Pct=Class'JazzContent.JazzItemLevel1'
     DropItemHealth50Pct=Class'JazzContent.JazzItemLevel1'
     DropItemHealth25Pct=Class'JazzContent.JazzItemLevel1'
     bBurnable=False
     GroundSpeed=340.000000
     Health=200
     Texture=Texture'JazzEnemy.Skins.Lizard_02'
     DrawScale=2.300000
     CollisionRadius=30.000000
     CollisionHeight=66.599998
}
