//=============================================================================
// LeaderOfThePack.
//=============================================================================
class LeaderOfThePack expands BattleMode;

// The current Leader of the pack
var pawn Leader;

var () config float LeaderDmgMult;
var () config float LeaderDmgDamp;
var () config float LeaderDrawScaleChange;
var () config float LeaderJumpZChange;
var () config bool  bThunderLand;

// Monitor killed messages for flufflimit
function Killed(pawn killer, pawn Other, name damageType)
{
	Super.Killed(killer, Other, damageType);

	if(Leader == None || Leader == Other)
	{
		if(Leader == Other)
		{
			// If there was a leader, make him lose the leardership
			JazzPlayer(Other).LoseLeader();
		}
		if(killer == Other)
		{
			// If the leader killed himself, lose score
			Leader.PlayerReplicationInfo.Score -= 4;
			Leader = None;
		}
		Leader = killer;
		JazzPlayer(killer).GainLeader(LeaderDrawScaleChange,LeaderJumpZChange,bThunderLand);
		// Give extra score for killing the leader
		Leader.PlayerReplicationInfo.Score += 4;
		BroadcastMessage(Leader.PlayerReplicationInfo.PlayerName$" is now the leader of the pack!",true);
	}
}	

function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if (injured.Region.Zone.bNeutralZone)
		return 0;
		
	if ( injured == Leader)
		Damage /= LeaderDmgDamp;

	if ( instigatedBy == None)
		return Damage;

	if ( instigatedBy == Leader)
		return Damage*LeaderDmgMult;

	//skill level modification
	if ( (instigatedBy.Skill < 1.5) && instigatedBy.IsA('Bots') && injured.IsA('PlayerPawn') )
		Damage = Damage * (0.7 + 0.15 * instigatedBy.skill);

	return (Damage * instigatedBy.DamageScaling);
}

defaultproperties
{
     bRestartLevel=False
     bPauseable=False
     GameMenuType=Class'CalyGame.JazzGameMenu'
     HUDType=Class'CalyGame.JazzLeaderHUD'
     BeaconName="LeaderOfThePac"
}
