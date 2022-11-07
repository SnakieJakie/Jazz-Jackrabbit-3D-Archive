//=============================================================================
// RankPoint.
//=============================================================================
class RankPoint expands NavigationPoint;

// What the number of the point is (note: 0 is the first point
var () const int Number;

// The point after it
var RankPoint nextPoint;
// The point before it
var RankPoint prevPoint;
// The first point (0 point)
var RankPoint firstPoint;


function PostBeginPlay()
{
	FindOtherPoints();
	
	WriteLog();
	
	Super.PostBeginPlay();
}

function FindOtherPoints()
{
	local RankPoint OtherPoint;
	local int NumberOfRankPoints;
	NumberOfRankPoints = -1;
	ForEach AllActors(class 'RankPoint', OtherPoint)
	{
		NumberOfRankPoints += 1;
		if ( OtherPoint.Number == Number+1)
		{
			nextPoint = OtherPoint;
		} 
		else if  ( OtherPoint.Number == Number-1)
		{
			prevPoint = OtherPoint;
		}
		else if ( OtherPoint.Number == 0)
		{
			firstPoint = OtherPoint;
		}
	}
	
	if( Number == NumberOfRankPoints || Number == 0)
	{
		ForEach AllActors(class 'RankPoint', OtherPoint)
		{
			if ( Number == NumberOfRankPoints && OtherPoint.Number == 0 )
			{
				nextPoint = OtherPoint;
				return;
			}
			if ( Number == 0 && OtherPoint.Number == NumberOfRankPoints )
			{
				prevPoint = OtherPoint;
				return;
			}
		}
	}
}

function WriteLog()
{
	log("Rank Point : "$ Number $ "  Next Point : "$ nextPoint.Number $" Previous Point : "$ prevPoint.Number);
}

defaultproperties
{
     bStatic=False
}
