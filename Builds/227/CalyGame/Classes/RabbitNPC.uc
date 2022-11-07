//=============================================================================
// RabbitNPC.
//=============================================================================
class RabbitNPC expands JazzNPC;

//
// Basic Rabbit NPC
//
// Conversation:
//	Uses as default just random rabbit conversations
//


////////////////////////////////////////////////////////////////////////////////////
// Animations
//

function PlaySlowWalk()
{
	GroundSpeed = 100;
	PlayAnim('walk');
}

function PlayWarnFriends()
{
}

function PlayRunning()
{
	GroundSpeed = 200;
	LoopAnim('shotat');
}

function PlayWalking()
{
	GroundSpeed = 100;
	PlayAnim('walk');
}

function PlayWaiting()
{
	if (AnimSequence != 'idle1')
	LoopAnim('idle1');
}

function PlayStationaryFiring()
{
}

function TalkToPlayer()
{
	if (Conversing)
	{
		if ((AnimSequence != 'talking') && (AnimSequence != 'Starttalk'))
		{
			PlayAnim('Starttalk');
		}
	}
	else
	PlayWaiting();
}

function AnimEnd()
{
	if (Conversing)
	{
		PlayAnim('Talking');
	}
	else
	Super.AnimEnd();
}

defaultproperties
{
     Courage=COU_Terrified
     WalkingSpeed=30.000000
     RushSpeed=200.000000
     RunDesire=5
     AfraidDuration=5.000000
     GroundSpeed=200.000000
     DrawType=DT_Mesh
     Mesh=Mesh'JazzObjectoids.NPC1'
     CollisionRadius=12.000000
     CollisionHeight=24.000000
}
