//+-------+
//| Subs  |
//+-------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Little subroutine functions are held here.                                 |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

void() SUB_UseTargets;
void() SUB_Null = {};
// SOLID_NOT hack for glows to remove themselves properly
void() SUB_Remove = {self.solid = SOLID_NOT;remove(self);return;};

void() SetMovedir =
{
	if (self.angles == '0 -1 0')
		self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0')
		self.movedir = '0 0 -1';
	else
	{
		makevectors (self.angles);
		self.movedir = v_forward;
	}
	self.angles = '0 0 0';
};

void() DelayThink =
{
	activator = self.enemy;
	SUB_UseTargets ();
	remove(self);
};

void(string targ) FireTarget =
{	
	local entity t, stemp, otemp, act;
	
	act = activator;
	t = world;
	do
	{
		t = find (t, targetname, targ);
		
		if (!t)
			return;

		if (t.classname == "trigger_push")
		{
			if (t.spawnflags & 2)
				t.cnt = FALSE; // turn inactive trigger into an active one
		}
				
		//
		// Allows two monsters to awaketarget each other without loop crashing
		// targetted monster must not have a current enemy target, prevents 'stuck enemy' glitch
		//

		if (self.awaketarget == t.targetname)
			self.use = SUB_Null; // prevent loop crash
		
		stemp = self;
		otemp = other;
		self = t;
		other = stemp;

		if (self.use != SUB_Null)
		{
			if (self.use)
			{
				self.use();

				//
				// Clear all awaketargets after use, prevent loop crash
				// bosses awaketargets aren't cleared after .use is called
				//
				
				if (!(self.flags & FL_BOSS))
				{
					if (self.awaketarget != "")
						self.awaketarget = "";
					if (self.awaketarget2 != "")
						self.awaketarget2 = "";
					if (self.awaketarget3 != "")
						self.awaketarget3 = "";
					if (self.awaketarget4 != "")
						self.awaketarget4 = "";
					if (self.awaketarget5 != "")
						self.awaketarget5 = "";
					if (self.awaketarget6 != "")
						self.awaketarget6 = "";
					if (self.awaketarget7 != "")
						self.awaketarget7 = "";
					if (self.awaketarget8 != "")
						self.awaketarget8 = "";
					if (self.awaketarget9 != "")
						self.awaketarget9 = "";
				}
			}
		}
		
		self = stemp;
		other = otemp;
		activator = act;
	}
	while (1);
};

/*
==============================
SUB_UseTargets

the global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
and removes them, so some events can remove other triggers.

Search for (string)targetname in all entities that
match (string)self.target and call their .use function

==============================
*/

void() SUB_UseTargets =
{
	local entity t;

	//
	// check for a delay
	//
	if (self.delay)
	{
		// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}

	//
	// fire targets
	//
	if (self.target)
		FireTarget(self.target);
	if (self.target2)
		FireTarget(self.target2);
	if (self.target3)
		FireTarget(self.target3);
	if (self.target4)
		FireTarget(self.target4);
	if (self.target5)
		FireTarget(self.target5);
	if (self.target6)
		FireTarget(self.target6);
	if (self.target7)
		FireTarget(self.target7);
	if (self.target8)
		FireTarget(self.target8);
	if (self.target9)
		FireTarget(self.target9);

	//
	// kill the killtagets
	//
	if (self.killtarget)
	{
		t = world;
		do
		{
			t = find (t, targetname, self.killtarget);
			if (!t)
				return;
			remove (t);
		} while (1);
	}
};

.void()		think1;
.vector		finaldest;

/*
============
After moving, set origin to exact final destination
============
*/
void()  SUB_CalcMoveDone =
{
	setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};

void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
	local vector	vdestdelta;
	local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");

	self.think1 = func;
	self.finaldest = tdest;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
		
	// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	
	// calculate length of vector
	len = vlen (vdestdelta);
	
	// divide by speed to get time to reach dest
	traveltime = len / tspeed;
	
	// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime);	// qcc won't take vec/float	

	self.think = SUB_CalcMoveDone;
	self.nextthink = self.ltime + traveltime;
};