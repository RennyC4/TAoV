//+------+
//|Doors |
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| All TAoVs doors and the way they work are handled in this file.            |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

.vector		dest, dest1, dest2;
.float		wait;			// time from firing to restarting
.float		delay;			// time from activation to firing
.entity		trigger_field;	// door's trigger entity
//.string		noise4;
float DOOR_START_OPEN = 1;
float DOOR_DONT_LINK = 4;
float DOOR_GOLD_KEY = 8;
float DOOR_SILVER_KEY = 16;
float DOOR_TOGGLE = 32;

void() door2_stop =
{
	sound (self, CHAN_BODY, "doors/close1.wav", 1, ATTN_NONE);
	self.think = SUB_Null;
	self.nextthink = time + 0.1;
	return;
};

void() door2_use =
{
	sound (self, CHAN_BODY, "doors/door1.wav", 1, ATTN_NONE);
	if (self.cnt2 == 0)
	{
		SUB_CalcMove (self.pos2, self.speed, door2_stop);
		self.cnt2 = 1;
	}
	else
	{
		SUB_CalcMove (self.pos1, self.speed, door2_stop);
		self.cnt2 = 0;
	}
};

void() door_error =
{
	if (!self.targetname)
		bprint ("func_door2 without a targetname, your door is not operational!\n");
	self.nextthink = time + 1;
};

/*QUAKED func_door2 (0 .5 .8) ?
Door that either raises or lowers, may be used in conjunction with trigger_once/multiple
or any other entity that calls for it's use function to fire such as pick ups / monsters deaths
"speed":
50 (default) how fast the door moves
"height":
125 (default) how many units the door moves up/down
"cnt"
0 (default) door raises up once triggered
1 door will lower once triggered
*/
void() func_door2 =
{
	precache_sound ("doors/door1.wav");
	precache_sound ("doors/close1.wav");

	if (!self.targetname)
	{
		bprint ("func_door2 without a targetname, your door is not operational!\n");
		self.think = door_error;
		self.nextthink = time + 1;
		return;
	}
	if (!self.speed)
		self.speed = 50;
	if (!self.height)
		self.height = 125;

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.use = door2_use;
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);

	// pos1 is the top position, pos2 is the bottom
	self.pos1 = self.origin;
	self.pos2 = self.origin;
	if (self.height)
	{
		if (self.cnt == 0) // cnt 0, door rises
			self.pos2_z = self.origin_z + self.height;
		else // cnt 1, door lowers
			self.pos2_z = self.origin_z - self.height;
	}
};

/*
Doors are similar to buttons, but can spawn a fat trigger field around them
to open without a touch, and they link together to form simultanious
double/quad doors.
 
Door.owner is the master door.  If there is only one door, it points to itself.
If multiple doors, all will point to a single one.

Door.enemy chains from the master door through all doors linked in the chain.
*/

/*
=============================================================================

THINK FUNCTIONS

=============================================================================
*/

void() door_go_down;
void() door_go_up;

void() door_blocked =
{
	T_Damage (other, self, self, self.dmg, 0);
	
	// if a door has a negative wait, it would never come back if blocked,
	// so let it just squash the object to death real fast
	if (self.wait >= 0)
	{
		if (self.state == STATE_DOWN)
			door_go_up ();
		else
			door_go_down ();
	}
};

void() door_hit_top =
{
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	self.state = STATE_TOP;
	if (self.spawnflags & DOOR_TOGGLE)
		return;		// don't come down automatically
	self.think = door_go_down;
	self.nextthink = self.ltime + self.wait;
};

void() door_hit_bottom =
{
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() door_go_down =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	if (self.max_health)
	{
		self.takedamage = DAMAGE_YES;
		self.health = self.max_health;
	}
	
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, door_hit_bottom);
};

void() door_go_up =
{
	if (self.state == STATE_UP)
		return;		// allready going up

	if (self.state == STATE_TOP)
	{	// reset top wait time
		self.nextthink = self.ltime + self.wait;
		return;
	}
	
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, door_hit_top);

	SUB_UseTargets();
};


/*
=============================================================================

ACTIVATION FUNCTIONS

=============================================================================
*/

void() door_fire =
{
	local entity 	oself;
	local entity	starte;

	if (self.owner != self)
		objerror ("door_fire: self.owner != self");

	// play use key sound

	if (self.items)
		sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);

	self.message = string_null;		// no more message
	oself = self;

	if (self.spawnflags & DOOR_TOGGLE)
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			starte = self;
			do
			{
				door_go_down ();
				self = self.enemy;
			} while ( (self != starte) && (self != world) );
			self = oself;
			return;
		}
	}
	
	// trigger all paired doors
	starte = self;
	do
	{
		door_go_up ();
		self = self.enemy;
	} while ( (self != starte) && (self != world) );
	self = oself;
};


void() door_use =
{
	local entity oself;

	self.message = "";			// door message are for touch only
	self.owner.message = "";	
	self.enemy.message = "";
	oself = self;
	self = self.owner;
	door_fire ();
	self = oself;
};

void() door_trigger_touch =
{
	if (other.health <= 0)
		return;

	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 1;

	activator = other;

	self = self.owner;
	door_use ();
};

void() door_killed =
{
	local entity oself;
	
	oself = self;
	self = self.owner;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// will be reset upon return
	door_use ();
	self = oself;
};

/*
================
door_touch

Prints messages and opens key doors
================
*/
void() door_touch =
{
	if (other.classname != "player")
		return;
	if (self.owner.attack_finished > time)
		return;

	self.owner.attack_finished = time + 2;

	if (self.owner.message != "")
			centerprint (other.owner, self.message);

	if (self.spawnflags & 8) // Church/Gold key
	{
		if (!(keys & IT_KEY1))
		{
			sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
			centerprint (other.owner, "/P^bLocked Door^b\n\n===========================\n\nIt requires a key to open.\n\n\n^3Press ATTACK or JUMP to resume ...");
			setpause(1);
			return;
		}
		else
			sound (other.owner, CHAN_AUTO, "misc/key.wav", 1, ATTN_NORM); //  Unlock sound
	}

	self.touch = SUB_Null;
	if (self.enemy)
		self.enemy.touch = SUB_Null;	// get paired door
	door_use ();
};

/*
=============================================================================

SPAWNING FUNCTIONS

=============================================================================
*/

entity(vector fmins, vector fmaxs) spawn_field =
{
	local entity	trigger;
	local	vector	t1, t2;

	trigger = spawn();
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.owner = self;
	trigger.touch = door_trigger_touch;

	t1 = fmins;
	t2 = fmaxs;
	setsize (trigger, t1 - '60 60 8', t2 + '60 60 8');
	return (trigger);
};

float (entity e1, entity e2) EntitiesTouching =
{
	if (e1.mins_x > e2.maxs_x)
		return FALSE;
	if (e1.mins_y > e2.maxs_y)
		return FALSE;
	if (e1.mins_z > e2.maxs_z)
		return FALSE;
	if (e1.maxs_x < e2.mins_x)
		return FALSE;
	if (e1.maxs_y < e2.mins_y)
		return FALSE;
	if (e1.maxs_z < e2.mins_z)
		return FALSE;
	return TRUE;
};

/*
=============
LinkDoors
=============
*/
void() LinkDoors =
{
	local entity	t, starte;
	local vector	cmins, cmaxs;

	if (self.enemy)
		return;		// already linked by another door
	if (self.spawnflags & 4)
	{
		self.owner = self.enemy = self;
		return;		// don't want to link this door
	}

	cmins = self.mins;
	cmaxs = self.maxs;
	
	starte = self;
	t = self;
	
	do
	{
		self.owner = starte;			// master door

		if (self.health)
			starte.health = self.health;
		if (self.targetname)
			starte.targetname = self.targetname;
		if (self.message != "")
			starte.message = self.message;

		t = find (t, classname, self.classname);	
		if (!t)
		{
			self.enemy = starte;		// make the chain a loop

		// shootable, fired, or key doors just needed the owner/enemy links,
		// they don't spawn a field
	
			self = self.owner;

			if (self.health)
				return;
			if (self.targetname)
				return;
			if (self.items)
				return;

			self.owner.trigger_field = spawn_field(cmins, cmaxs);

			return;
		}

		if (EntitiesTouching(self,t))
		{
			if (t.enemy)
				objerror ("cross connected doors");
			
			self.enemy = t;
			self = t;

			if (t.mins_x < cmins_x)
				cmins_x = t.mins_x;
			if (t.mins_y < cmins_y)
				cmins_y = t.mins_y;
			if (t.mins_z < cmins_z)
				cmins_z = t.mins_z;
			if (t.maxs_x > cmaxs_x)
				cmaxs_x = t.maxs_x;
			if (t.maxs_y > cmaxs_y)
				cmaxs_y = t.maxs_y;
			if (t.maxs_z > cmaxs_z)
				cmaxs_z = t.maxs_z;
		}
	} while (1);

};


/*QUAKED func_door (0 .5 .8) ? START_OPEN x DOOR_DONT_LINK GOLD_KEY SILVER_KEY TOGGLE
if two doors touch, they are assumed to be connected and operate as a unit.

TOGGLE causes the door to wait in both the start and end states for a trigger event.

START_OPEN causes the door to move to its destination when spawned, and operate in reverse.  It is used to temporarily or permanently close off an area when triggered (not usefull for touch or takedamage doors).

Key doors are always wait -1.

"message"	is printed when the door is touched if it is a trigger door and it hasn't been fired yet
"angle"		determines the opening direction
"targetname" if set, no touch field will be spawned and a remote button or trigger field activates the door.
"health"	if set, door must be shot open
"speed"		movement speed (100 default)
"wait"		wait before returning (3 default, -1 = never return)
"lip"		lip remaining at end of move (8 default)
"dmg"		damage to inflict when blocked (2 default)
"sounds"
0)	no sound
1)	stone
2)	base
3)	stone chain
4)	screechy metal
*/

void() func_door =
{
	self.noise1 = "doors/door1.wav";
	self.noise2 = "doors/close1.wav";

	precache_sound ("doors/door1.wav");
	precache_sound ("doors/close1.wav");
	precache_sound ("misc/key.wav");
	precache_sound ("misc/talk.wav");

	SetMovedir ();

	self.max_health = self.health;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	self.classname = "door";

	self.blocked = door_blocked;
	self.use = door_use;
	
	if (self.spawnflags & DOOR_SILVER_KEY)
		self.items = IT_KEY1;
	if (self.spawnflags & DOOR_GOLD_KEY)
		self.items = IT_KEY2;
	
	if (!self.speed)
		self.speed = 100;
	if (!self.wait)
		self.wait = 3;
	if (!self.lip)
		self.lip = 8;
	if (!self.dmg)
		self.dmg = 2;

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);

	// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
	// but spawn in the open position
	if (self.spawnflags & DOOR_START_OPEN)
	{
		setorigin (self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	self.state = STATE_BOTTOM;

	if (self.health)
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = door_killed;
	}
	
	if (self.items)
		self.wait = -1;
		
	self.touch = door_touch;

	// LinkDoors can't be done until all of the doors have been spawned, so
	// the sizes can be detected properly.
	self.think = LinkDoors;
	self.nextthink = self.ltime + 0.1;
};