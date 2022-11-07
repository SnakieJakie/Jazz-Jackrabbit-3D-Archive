//=============================================================================
// DudeJazz.
//=============================================================================
class DudeJazz expands JazzCamControl;

// Animation
var name	CurrentAnimation;

//-----------------------------------------------------------------------------
// Animation functions


function SpecialChangeSkin( byte Color )
{
	switch (Color)
	{
		case 1:
			Skin = texture'Jazz_Blue_BB';
		break;

		case 2:
			Skin = texture'Jazz_Green_RB';
		break;
		
		case 3:
			Skin = texture'Jazz_Yellow_PB';
		break;
		
		case 4:
			Skin = texture'Jazz_Grey_BB';
		break;
		
		case 5:
			Skin = texture'Jazz_Red_GB';
		break;
		
		case 6:
			Skin = texture'Jazz_Purple_PB';
		break;
	}
	
	Super.SpecialChangeSkin(Color);
}

function bool AnimateOk()
{
	return(Mesh == Default.Mesh);
}

function PlayTurning()
{
}

function TweenToWalking(float tweentime)
{
	if (AnimateOk())
	if (WeaponPointingCheck())
	{
	TweenAnim('JazzRunShooting',tweentime);
	}
	else
	{
	TweenAnim('JazzRun',tweentime);
	}
}

function TweenToRunning(float tweentime)
{
	if (AnimateOk())
	if (WeaponPointingCheck())
	{
	TweenAnim('JazzRunShooting',tweentime);
	}
	else
	{
	TweenAnim('JazzRun',tweentime);
	}
}

function PlayWalking()
{
	if (AnimateOk())
	if (WeaponPointingCheck())
	{
	PlayAnim('JazzRunShooting');
	}
	else
	{
	LoopAnim('JazzRun');
	}
}

function PlayRunForward()
{
	if (OldRunContinue)
	{
		if ((AnimSequence == 'JazzRunShooting') || (AnimSequence == 'JazzRun'))
		return;
	}

	if (AnimateOk())
	if ((AnimSequence != 'JazzRunShooting') && (AnimSequence != 'JazzRun') &&
		(AnimSequence != 'RunBackShoot') && (AnimSequence != 'RunBackNoShoot')
		)
	{
		if (WeaponPointingCheck())
		{
		TweenAnim('JazzRunShooting',0.1);
		}
		else
		{
		TweenAnim('JazzRun',0.1);
		}
	}
	else
	{
		if (WeaponPointingCheck())
		{
		PlayAnim('JazzRunShooting');
		}
		else
		{
		LoopAnim('JazzRun');
		}
	}
}

function PlayRunBackward()
{
	if (OldRunContinue)
	{
		if ((AnimSequence == 'RunBackShoot') || (AnimSequence == 'RunBackNoShoot'))
		return;
	}
	
	if (AnimateOk())
/*	if ((AnimSequence != 'RunBackShoot') && (AnimSequence != 'RunBackNoShoot'))
	{
		if (WeaponPointingCheck())
		{
		TweenAnim('RunBackShoot',0.05);
		}
		else
		{
		TweenAnim('RunBackNoShoot',0.05);
		}
	}
	else*/
	{
		if (WeaponPointingCheck())
		{
		PlayAnim('RunBackShoot');
		}
		else
		{
		LoopAnim('RunBackNoShoot');
		}
	}
}

function PlayStrafeLeft()
{
	if (OldRunContinue)
	{
		if ((AnimSequence == 'RunLeftShoot') || (AnimSequence == 'RunLeftNoShoot'))
		return;
	}
	
	if (AnimateOk())
	if ((AnimSequence != 'RunLeftShoot') && (AnimSequence != 'RunLeftNoShoot'))
	{
		if (WeaponPointingCheck())
		{
		TweenAnim('RunLeftShoot',0.1);
		}
		else
		{
		TweenAnim('RunLeftNoShoot',0.1);
		}
	}
	else
	{
		if (WeaponPointingCheck())
		{
		PlayAnim('RunLeftShoot');
		}
		else
		{
		LoopAnim('RunLeftNoShoot');
		}
	}
}

function PlayStrafeRight()
{
	if (OldRunContinue)
	{
		if ((AnimSequence == 'RunRightShoot') || (AnimSequence == 'RunRightNoShoot'))
		return;
	}
	
	if (AnimateOk())
	if ((AnimSequence != 'RunRightShoot') && (AnimSequence != 'RunRightNoShoot'))
	{
		if (WeaponPointingCheck())
		{
		TweenAnim('RunRightShoot',0.1);
		}
		else
		{
		TweenAnim('RunRightNoShoot',0.1);
		}
	}
	else
	{
		if (WeaponPointingCheck())
		{
		PlayAnim('RunRightShoot');
		}
		else
		{
		LoopAnim('RunRightNoShoot');
		}
	}
}

function PlayRising()
{
}

function PlayFeignDeath()
{
}

function PlayDying(name DamageType, vector HitLoc)
{
	if (AnimateOk())
	CurrentAnimation = '';
}

function PlayGutHit(float tweentime)
{
}

function PlayHeadHit(float tweentime)
{
}

function PlayLeftHit(float tweentime)
{
}

function PlayRightHit(float tweentime)
{
}
	
function PlayLanded(float impactVel)
{
}
	
function PlayFlyingUp()
{
	if (AnimateOk())
	PlayAnim('JazzForwardJump');
}
function TweenToFlyingUp(float tweentime)
{
	TweenAnim('JazzForwardJump',tweentime);
}

function PlayFallingDown()
{
	if (AnimateOk())
	if (WeaponPointingCheck())
	{
	LoopAnim('JazzFallShooting');
	}
	else
	LoopAnim('JazzFall');
}
function TweenToFallingDown(float tweentime)
{
	if (WeaponPointingCheck())
	{
	TweenAnim('JazzFallShooting',tweentime);
	}
	else
	TweenAnim('JazzFall',tweentime);
}

function PlayDuck()
{
}

function PlayCrawling()
{
}

function TweenToWaiting(float tweentime)
{
	if (AnimateOk())
	TweenAnim('JazzIdle1',tweentime);
}
	
function PlayWaiting()
{
	if (AnimateOk())
	if ((AnimSequence != 'JazzIdle1Shoot') && (AnimSequence != 'JazzIdle1'))
	{
		if (WeaponPointingCheck())
		{
		TweenAnim('JazzIdle1Shoot',0.1);
		}
		else
		{
		TweenAnim('JazzIdle1',0.1);
		}
	}
	else
	{
		if (WeaponPointingCheck())
		{
			PlayAnim('JazzIdle1Shoot');
		}
		else
		{
			LoopAnim('JazzIdle1');
		}
	}
}	

function PlayFiring()
{
	if (AnimateOk())
	switch (AnimSequence)
	{
		case 'JazzIdle1':
			PlayAnim('JazzIdle1Shoot');
		break;
		
		case 'JazzRun':
			PlayAnim('JazzRunShooting');
		break;
	
		case 'jazzfall':
			PlayAnim('JazzFallShooting');
		break;
		
		case 'RunLeftNoShoot':
			PlayAnim('RunLeftShoot');
		break;
		
		case 'RunRightNoShoot':
			PlayAnim('RunRightShoot');
		break;
		
		case 'RunBackNoShoot':
			PlayAnim('RunBackShoot');
		break;
	}
}

function PlayWeaponSwitch(Weapon NewWeapon)
{
}

function PlaySwimming()
{
	PlayAnim('JazzSwimForward');
}

function TweenToSwimming(float tweentime)
{
	TweenAnim('JazzSwimForward',tweentime);
}

function PlayTreading()
{
	PlayAnim('JazzSwimForward');
}

function TweenToTreading(float tweentime)
{
	TweenAnim('JazzSwimForward',tweentime);
}

function PlayGrabbing(float tweentime)
{

}

// Ledge Functionality
// 
function PlayLedgePullup(float tweentime)
{
	if (AnimateOk())
	PlayAnim('JazzLedgePullup');
}

function PlayLedgeHang()
{
	if (AnimateOk())
	PlayAnim('JazzLedgeHang');
}

function PlayLedgeGrab()
{
	if (AnimateOk())
	PlayAnim('JazzLedgeGrab');
}

function PlaySwimBigStroke(float tweentime)
{

}

function PlaySwimSteadyStroke(float tweentime)
{

}

function PlaySwimTread(float tweentime)
{

}

function bool WeaponPointingCheck ()
{
	if (Weapon == None)
	return false;
	else
	return Weapon.bPointing;
}

defaultproperties
{
     HealthMaximum=100
     MaxSwimmingJumpDuration=1.000000
     VoicePack=Class'CalyGame.VoiceJazzJackrabbit'
     EnergyDamage=1.000000
     FireDamage=1.000000
     WaterDamage=1.000000
     SoundDamage=1.000000
     SharpPhysicalDamage=1.000000
     BluntPhysicalDamage=1.000000
     WaterSpeed=300.000000
     JumpZ=650.000000
     BaseEyeHeight=-20.000000
     Physics=PHYS_Falling
     AnimSequence=jazzidle1
     DrawType=DT_Mesh
     Texture=Texture'Jazz3.Jjazz_01'
     Skin=Texture'Jazz3.Jjazz_01'
     Mesh=Mesh'Jazz3.Jazz'
     bMeshCurvy=False
     CollisionRadius=18.000000
     CollisionHeight=36.000000
}
