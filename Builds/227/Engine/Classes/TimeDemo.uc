//=============================================================================
// TimeDemo - calculate and display framerate
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================


class TimeDemo expands Object;


var float TimePassed;
var float TimeDilation;

var float StartTime;
var float LastSecTime;
var float LastCycleTime;
var float LastFrameTime;
var float SquareSum;

var int FrameNum;
var int FrameLastSecond;	// Frames in the last second
var int FrameLastCycle;		// Frames in the last cycle
var int CycleCount;

var string[100] CycleMessage;
var string[100] CycleResult;

var float LastSec;
var float MinFPS;
var float MaxFPS;

var bool bFirstFrame;

var InterpolationPoint OldPoint;
var TimeDemoInterpolationPoint NewPoint;

var Console Console;

function DoSetup(Console C)
{
	local InterpolationPoint	I;

	Console = C;
	bFirstFrame = True;


	OldPoint = None;

	// Find the first interpolation point, and replace it with one of ours.
	foreach Console.ViewPort.Actor.AllActors( class 'InterpolationPoint', I, 'Path' )
	{
		if(I.Position == 0)
		{
			OldPoint = I;
			break;
		}
	}

	if(OldPoint != None)
	{

		Log("*************************");
		Console.Viewport.Actor.StartWalk();
		Console.Viewport.Actor.SetLocation(OldPoint.Location);

		// We've got a flyby sequence - break into it
		OldPoint.Tag = 'OldPath';	

		NewPoint = Console.ViewPort.Actor.Spawn(class 'TimeDemoInterpolationPoint', OldPoint.Owner);
		NewPoint.SetLocation(OldPoint.Location);
		NewPoint.SetRotation(OldPoint.Rotation);
		NewPoint.Position = 0;
		NewPoint.RateModifier = OldPoint.RateModifier;
		NewPoint.bEndOfPath = OldPoint.bEndOfPath;
		NewPoint.Tag = 'Path';
		NewPoint.Next = OldPoint.Next;	
		NewPoint.Prev = OldPoint.Prev;	
		NewPoint.Prev.Next = NewPoint;	
		NewPoint.Next.Prev = NewPoint;	
		NewPoint.T = Self;
	}
}


function Destroyed()
{
	Local float Avg;

	if(OldPoint != None)
	{
		NewPoint.Destroy();
		OldPoint.Tag = 'Path';
		OldPoint.Prev.Next = OldPoint;
		OldPoint.Next.Prev = OldPoint;
	}

	Avg = FrameNum / ((TimePassed - StartTime) / TimeDilation);
	Console.Viewport.Actor.ClientMessage(FrameNum$" frames rendered in "$((TimePassed - StartTime)/TimeDilation)$" seconds. "$Avg$" FPS average.");
}

function PostRender( canvas C )
{
	local float Avg, RMS;

	TimeDilation = Console.Viewport.Actor.Level.TimeDilation;

	if(bFirstFrame)
	{
		StartTime = TimePassed;
		LastSecTime = TimePassed;
		LastFrameTime = TimePassed;
		
		FrameNum = 0;
		FrameLastSecond = 0;
		FrameLastCycle = 0;
		CycleCount = 0;
	
		LastSec = 0;
		LastCycleTime = 0;
		CycleMessage = "";
		CycleResult = "";
	
		SquareSum = 0;

		MinFPS = 0;
		MaxFPS = 0;

		bFirstFrame = False;

		return;
	}

	FrameNum++;
	FrameLastSecond++;
	FrameLastCycle++;

	SquareSum = SquareSum + (LastFrameTime - TimePassed) * (LastFrameTime - TimePassed);
	RMS = 1 / sqrt(SquareSum / FrameNum);

	LastFrameTime = TimePassed;
	

	Avg = FrameNum / ((TimePassed - StartTime) / TimeDilation);
	
	if((TimePassed - LastSecTime) / TimeDilation > 1)
	{
		LastSec = FrameLastSecond / ((TimePassed - LastSecTime) / TimeDilation);
		FrameLastSecond = 0;
		LastSecTime = TimePassed;
	}

	if(LastSec < MinFPS || MinFPS == 0) MinFPS = LastSec;
	if(LastSec > MaxFPS) MaxFPS = LastSec;


	if(Console.ViewPort.Actor.bShowMenu) return;

	C.Font = C.MedFont;
	C.SetPos(0, 48);
	C.DrawText("Average:");
	C.SetPos(100, 48);
	C.DrawText(Avg $" FPS.");
	C.SetPos(0, 60);
	C.DrawText("RMS:");
	C.SetPos(100, 60);
	C.DrawText(RMS$" FPS.");
	C.SetPos(0, 72);
	C.DrawText("Last Second:");
	C.SetPos(100, 72);
	C.DrawText(LastSec $ " FPS.");
	C.SetPos(0, 84);
	C.DrawText("Lowest:");
	C.SetPos(100, 84);
	C.DrawText(MinFPS $ " FPS.");
	C.SetPos(0, 96);
	C.DrawText("Highest:");
	C.SetPos(100, 96);
	C.DrawText(MaxFPS $ " FPS.");
	C.SetPos(0, 108);
	C.DrawText(CycleMessage);
	C.SetPos(100, 108);
	C.DrawText(CycleResult);
}

function Tick(float Delta)
{
	TimePassed = TimePassed + Delta;
}


function StartCycle() {
	if(LastCycleTime == 0)
	{
		CycleMessage = "Cycle #1:";
		CycleResult = "Timing...";
	}
	else
	{
		CycleMessage = "Cycle #"$CycleCount$":";
		CycleResult = FrameLastCycle / ((TimePassed - LastCycleTime) / TimeDilation)
		                $" FPS ("$FrameLastCycle$" frames, "$
		                ((TimePassed - LastCycleTime) / TimeDilation)$" seconds)";

		Log("Cycle #"$CycleCount$": "
		                $FrameLastCycle / ((TimePassed - LastCycleTime) / TimeDilation)
		                $" FPS ("$FrameLastCycle$" frames, "$
		                ((TimePassed - LastCycleTime) / TimeDilation)$" seconds)");
	}
	LastCycleTime = TimePassed;
	FrameLastCycle = 0;
	CycleCount++;
}

defaultproperties
{
}
