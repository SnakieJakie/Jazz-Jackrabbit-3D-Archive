//=============================================================================
// For internal testing.
//=============================================================================
class TestInfo expands Info;

var() bool bTrue1;
var() bool bFalse1;
var() bool bTrue2;
var() bool bFalse2;
var bool bBool1;
var bool bBool2;
var() int xnum;
var float ppp;
var string[32] sxx;
var int MyArray[2];
var vector v1,v2;

const Pie=3.14;
const Str="Tim";
const Lotus=vect(1,2,3);

/*
function BeginPlay()
{
	local testobj to;
	local object oo;
	to = new class'TestObj';
	to = new()class'TestObj';
	to = new(self)class'TestObj';
	to = new(self,'')class'TestObj';
	to = new(self,'',0)class'TestObj';
	to.Test();
}

function TestX( bool bResource )
{
	local int n;
	n = int(bResource);
	MyArray[ int(bResource) ] = 0;
	MyArray[ int(bResource) ]++;
}

function bool RecurseTest()
{
	bBool1=true;
	return false;
}

function TestLimitor( class c )
{
	local class<actor> NewClass;
	NewClass = class<actor>( c );
}

static function int OtherStatic( int i )
{
	assert(i==246);
	assert(default.xnum==777);
	return 555;
}

static function int TestStatic( int i )
{
	assert(i==123);
	assert(default.xnum==777);
	assert(OtherStatic(i*2)==555);
}

function TestContinueFor()
{
	local int i;
	log("TestContinue");
	for( i=0; i<20; i++ )
	{
		log("iteration "$i);
		if(i==7||i==9||i==19)
			continue;
		log("...");
	}
	log("DoneContinue");
}

function TestContinueWhile()
{
	local int i;
	log("TestContinue");
	while( ++i <= 20 )
	{
		log("iteration "$i);
		if(i==7||i==9)
			continue;
		log("...");
	}
	log("DoneContinue");
}

function TestContinueDoUntil()
{
	local int i;
	log("TestContinue");
	do
	{
		i++;
		log("iteration "$i);
		if(i==7||i==9||i>18)
			continue;
		log("...");
	} until( i>20 );
	log("DoneContinue");
}

function TestContinueForEach()
{
	local actor a;
	log("TestContinue");
	foreach AllActors( class'Actor', a )
	{
		log("actor "$a);
		if(light(a)==none)
			continue;
		log("...");
	}
	log("DoneContinue");
}


function SubTestOptionalOut( optional out int a, optional out int b, optional out int c )
{
	a *= 2;
	b = b*2;
	c += c;
}
function TestOptionalOut()
{
	local int a,b,c;
	a=1; b=2; c=3;

	SubTestOptionalOut(a,b,c);
	assert(a==2); assert(b==4); assert(c==6);

	SubTestOptionalOut(a,b);
	assert(a==4); assert(b==8); assert(c==6);

	SubTestOptionalOut(,b,c);
	assert(a==4); assert(b==16); assert(c==12);

	SubTestOptionalOut();
	assert(a==4); assert(b==16); assert(c==12);

	SubTestOptionalOut(a,b,c);
	assert(a==8); assert(b==32); assert(c==24);

	log("TestOptionalOut ok!");
}

function Tick( float DeltaTime )
{
	local class C;
	local class<testinfo> TC;
	local actor a;

	//TestOptionalOut();

	v1=vect(1,2,3);
	v2=vect(2,4,6);
	assert(v1!=v2);
	assert(!(v1==v2));
	assert(v1==vect(1,2,3));
	assert(v2==vect(2,4,6));
	assert(vect(1,2,5)!=v1);
	assert(v1*2==v2);
	assert(v1==v2/2);

	assert(Pie==3.14);
	assert(Pie!=2);
	assert(Str=="Tim");
	assert(Str!="Bob");
	assert(Lotus==vect(1,2,3));

	assert(GetPropertyText("sxx")=="Tim");
	assert(GetPropertyText("ppp")!="123");
	assert(GetPropertyText("bogus")=="");
	xnum=345;
	assert(GetPropertyText("xnum")=="345");
	SetPropertyText("xnum","999");
	assert(xnum==999);
	assert(xnum!=666);

	assert(bTrue1==true);
	assert(bFalse1==false);
	assert(bTrue2==true);
	assert(bFalse2==false);

	assert(default.bTrue1==true);
	assert(default.bFalse1==false);
	assert(default.bTrue2==true);
	assert(default.bFalse2==false);

	assert(class'TestInfo'.default.bTrue1==true);
	assert(class'TestInfo'.default.bFalse1==false);
	assert(class'TestInfo'.default.bTrue2==true);
	assert(class'TestInfo'.default.bFalse2==false);

	TC=Class;
	assert(TC.default.bTrue1==true);
	assert(TC.default.bFalse1==false);
	assert(TC.default.bTrue2==true);
	assert(TC.default.bFalse2==false);

	C=Class;
	assert(class<testinfo>(C).default.bTrue1==true);
	assert(class<testinfo>(C).default.bFalse1==false);
	assert(class<testinfo>(C).default.bTrue2==true);
	assert(class<testinfo>(C).default.bFalse2==false);

	assert(default.xnum==777);
	TestStatic(123);
	TC.static.TestStatic(123);
	class<testinfo>(C).static.TestStatic(123);

	bBool2=RecurseTest();
	assert(bBool2==false);

	log( "All tests passed" );
}

function f();

function temp()
{
	local int i;
	local playerpawn PlayerOwner;
	local name LeftList[20];
	for( i=0; i<20; i++ )
		PlayerOwner.WeaponPriority[i] = LeftList[i+1];
	temp();
}

state AA
{
	function f();
}
state BB
{
	function f();
}
state CCAA expands AA
{
	function f();
}
state DDAA expands AA
{
	function f();
}
state EEDDAA expands DDAA
{
	function f();
}
*/

defaultproperties
{
     bTrue1=True
     bTrue2=True
     xnum=777
     ppp=3.140000
     sxx="Tim"
     bHidden=False
}
