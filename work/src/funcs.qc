//+------+
//|Funcs |
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Contains all func_ entites used in The Ascension of Vigil                  |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

void() destroy_destroy;

void() func_fall_think =
{
	self.waterlevel = self.watertype = 0; // turn off quake engine splash sound
 
	if (self.attack_finished < time)
	{
		if (self.target) // fire other targets
			SUB_UseTargets();
 
		self.solid = SOLID_NOT;
		if (self.pos1 != '0 0 0')
			self.avelocity = self.pos1; // apply stored avelocity vector values
		if (self.pos2 && !self.velocity) // Add velocity movement
			self.velocity = self.pos2;
 
		if (self.cnt > 0) // cnt over 0
		{
			if (self.cnt >= 2)
			{
				self.movetype = MOVETYPE_BOUNCE;
				if (self.velocity_z < self.lip)
					self.velocity_z = self.lip;
			}
			else // cnt is 1
			{
				self.movetype = MOVETYPE_NOCLIP;
				if (self.velocity_z > self.lip)
					self.velocity_z = self.velocity_z - self.speed * (frametime * 100);
				else
					self.velocity_z = self.lip;
			}
		}
		else // default behavior (cnt is 0)
		{
			self.movetype = MOVETYPE_TOSS;
			if (self.velocity_z < self.lip)
				self.velocity_z = self.lip;
		}
 
		if (self.pain_finished != -1)
		{
			if (self.alpha > 0.1)
				self.alpha = self.alpha - self.pain_finished;
			else
			{
				if (self.noise2)
					sound (self, CHAN_AUTO, self.noise2, 1, ATTN_NORM);
				remove(self);
				return;
			}
		}
	}
	self.nextthink = self.ltime + 0.1;
};
 
void() fall_touch =
{
	if (!other.takedamage)
		return;
	if (other.classname != "player") // player activated only
		return;
	if (self.spawnflags & 2) // disable on monster only, also fixes weird issue
		return;
 
	self.think = func_fall_think;
	self.nextthink = self.ltime + 0.1;
 
	self.attack_finished = time + self.wait;
 
	if (self.noise)
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
 
	self.touch = SUB_Null; // disable touch, only do this once!
 
	if (self.char)
		remove(self.char);
};
 
void() func_fall_use =
{
	self.think = func_fall_think;
	self.nextthink = self.ltime + 0.1;
	self.touch = SUB_Null; // disable touch when used
 
	self.attack_finished = time + self.wait;
	if (self.noise)
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
};
 
void() func_fall_field_touch =
{
	if (other.flags & FL_FLY) // flying monsters shouldn't trigger falling platforms
		return;
 
	if (other.flags & FL_MONSTER)
	{
		local entity oself;
 
		oself = self;
 
		self = self.owner;
		self.think = func_fall_use;
		self.nextthink = self.owner.ltime + 0.1;                 
 
		self = oself;
 
		remove(self);
	}
};
 
/*QUAKED func_fall (0 .5 .8) ?
Falling brush by RennyC
 
wait - how long until the brush begins falling
noise - the sound to make when touched / activated
noise2 - the sound to make before it's removed, pain_finished of -1 disables noise2 as the object stays forever
cnt - 0 is default behavior (MOVETYPE_TOSS), 1 means collisions are disabled while falling (MOVETYPE_NOCLIP), 2 turns the brush into a
	   bouncing entity (MOVETYPE_BOUNCE)
pain_finished - default of 0.01, higher value has the object/brush fade out faster thus in turn affecting how long it stays. -1 stays forever
speed - speed as to how fast something falls per game frame, default is 10, higher values mean faster falling. Only for cnt of 1 (MOVETYPE_NOCLIP).
		Recommended to use lip for max fall speed on MOVETYPE_TOSS/BOUNCE entities (cnt 0 and 2) as they follow Quake's default gravity
lip - maximum fall speed that can be achieved, caps 'speed' variable. Default is -800
pos1 - have it spin when activated using X, Y, Z vector coordinates. MOVETYPE_BOUNCE ignores avelocity !Use an origin brush for proper spin!
pos2 - velocity movement with X (+Left/-Right), Y (+Forward/-Backwards), Z (+Up/-Down)
spawnflags:
	Default behavior allows anyone to activate func_fall on touch ONLY
	1 - Player activated only
	2 - Monster activated only
 
Able to .target other entities, including other func_falls
*/
 
void() func_fall =
{
	//
	// This is a hack to have monsters be able to trigger it by fake touch - Thanks to Nahuel
	//
 
	// Don't spawn on player only or if I'm a targetable
	if (!self.spawnflags & 1 && !self.targetname)
	{
		local entity func_fall_field;
 
		func_fall_field = spawn();
		func_fall_field.owner = self;
		self.char = func_fall_field; // Link 'em
		func_fall_field.solid = SOLID_TRIGGER;
		setsize (func_fall_field, self.absmin, self.absmax + '0 0 8');
		setorigin (func_fall_field, self.origin);
		setmodel (func_fall_field, self.model);
		func_fall_field.touch = func_fall_field_touch;
	}
 
	if (self.noise)
		precache_sound(self.noise);
	if (self.noise2)
		precache_sound(self.noise2);
 
	self.alpha = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
 
	if (!self.pain_finished)
		self.pain_finished = 0.01;
	if (!self.targetname)
		self.touch = fall_touch; // .touch in this instance is for players only
	if (!self.speed)
		self.speed = 10;
	if (!self.lip)
		self.lip = -800;
	
	if (self.avelocity != '0 0 0')
	{
		self.pos1 = self.avelocity; // store it
		self.avelocity = '0 0 0';
	}
	self.use = func_fall_use;	
 
	setmodel (self, self.model);
};

/*QUAKED func_destroy_map01 (0 .5 .8) ?
Destroyable brush
"health":
Give the func_destroy brush a health value, barrels have 25
health so you can estimate how much health your func_destroy
should have around
"cnt":
0 (default) explode into wooden chunks
1 explode into rock chunks
2 explode into metal chunks
3 explode into meaty chunks

- Sets a special flag to remove after PARM is passed -
*/

void() func_destroy_map01_think =
{
	if (game_progress & IT_PROGRESS3) // Rock in Map01 Smashed
	{
		remove(self);
		return;
	}
	//self.nextthink = self.ltime + 0.1;
	frameskip (0.1);
};

void() func_destroy_map01 =
{
	if (!self.health)
		self.health = 1;

	precache_model ("progs/rock1.mdl");
	precache_model ("progs/rock2.mdl");
	precache_model ("progs/rock3.mdl");
	self.noise = "misc/rocks.wav";
	self.cnt = 1;

	if (self.noise)
		precache_sound (self.noise);

	self.netname = "solid";
	self.classname = "breakable";
	self.attackedname = "func_destroy_map01"; // for parm set
	self.noblood = TRUE;
	self.solid = SOLID_BSP;
	self.think = func_destroy_map01_think;
	self.nextthink = self.ltime + 0.1;
	self.movetype = MOVETYPE_PUSH;
	if (!self.spawnflags & 1)
		self.takedamage = DAMAGE_YES;
	else
		self.takedamage = DAMAGE_NO;
	if (self.health == 0)
		self.takedamage = DAMAGE_NO;
	self.th_die = destroy_destroy;
	self.use = destroy_destroy;
	self.ignoreaircombo = TRUE; // bugfix, don't allow air combos to lift object off ground
	setmodel (self, self.model);
};


void() destroy_think =
{
	if (self.alpha > 0.1)
		self.alpha = self.alpha - 0.1;
	else
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.1;
};

void() destroy_destroy = // how silly
{
	local vector h;

	h = self.absmin + ((self.absmax - self.absmin) * 0.5);

	if (self.target)
		SUB_UseTargets();

	if (self.cnt == 0)
	{
	      ThrowSceneryGib ("progs/wood1.mdl", h);
	      ThrowSceneryGib ("progs/wood2.mdl", h);
	      ThrowSceneryGib ("progs/wood3.mdl", h);
	      ThrowSceneryGib ("progs/wood1.mdl", h);
	      ThrowSceneryGib ("progs/wood2.mdl", h);
	      ThrowSceneryGib ("progs/wood3.mdl", h);
	}
	else if (self.cnt == 1)
	{
	      ThrowSceneryGib ("progs/rock1.mdl", h);
	      ThrowSceneryGib ("progs/rock2.mdl", h);
	      ThrowSceneryGib ("progs/rock3.mdl", h);
	      ThrowSceneryGib ("progs/rock1.mdl", h);
	      ThrowSceneryGib ("progs/rock2.mdl", h);
	      ThrowSceneryGib ("progs/rock3.mdl", h);
	}
	else if (self.cnt == 2)
	{
	      ThrowSceneryGib ("progs/metal1.mdl", h);
	      ThrowSceneryGib ("progs/metal2.mdl", h);
	      ThrowSceneryGib ("progs/metal3.mdl", h);
	      ThrowSceneryGib ("progs/metal1.mdl", h);
	      ThrowSceneryGib ("progs/metal2.mdl", h);
	      ThrowSceneryGib ("progs/metal3.mdl", h);
	}
	else if (self.cnt == 3)
	{
	      ThrowSceneryGib ("progs/gib2.mdl", h);
	      ThrowSceneryGib ("progs/gib1.mdl", h);
	      ThrowSceneryGib ("progs/gib1.mdl", h);
	      ThrowSceneryGib ("progs/gib3.mdl", h);
	      ThrowSceneryGib ("progs/gib3.mdl", h);
	      ThrowSceneryGib ("progs/gib3.mdl", h);
	}
	if (self.attackedname == "func_destroy_map01")
	{
		if (!(game_progress & IT_PROGRESS3)) // Rock smashed in Map01
			game_progress = game_progress | IT_PROGRESS3; // Add it (True)
			
//		map01_rock_smashed = TRUE;
	}

	if (self.noise != "" && self.cnt != 5)
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	remove(self);
	return;
};

/*QUAKED func_destroy (0 .5 .8) ?
Destroyable brush
"health":
Give the func_destroy brush a health value, barrels have 25
health so you can estimate how much health your func_destroy
should have around
"cnt":
0 (default) explode into wooden chunks
1 explode into rock chunks
2 explode into metal chunks
3 explode into meaty chunks
*/

void() func_destroy =
{
	if (!self.health)
		self.health = 1;
	if (self.cnt == 0)
	{
		precache_model ("progs/wood1.mdl");
		precache_model ("progs/wood2.mdl");
		precache_model ("progs/wood3.mdl");
		self.noise = "misc/woodbrk.wav";
	}
	if (self.cnt == 1)
	{
		precache_model ("progs/rock1.mdl");
		precache_model ("progs/rock2.mdl");
		precache_model ("progs/rock3.mdl");
		self.noise = "misc/rocks.wav";
	}
	if (self.cnt == 2)
	{
		precache_model ("progs/metal1.mdl");
		precache_model ("progs/metal2.mdl");
		precache_model ("progs/metal3.mdl");
		self.noise = "misc/metlbrk.wav";
	}
	if (self.cnt == 3)
	{
		precache_model ("progs/gib1.mdl");
		precache_model ("progs/gib2.mdl");
		precache_model ("progs/gib3.mdl");
		self.noise = "zombie/splat.wav";
	}
	if (self.noise)
		precache_sound (self.noise);

	self.netname = "solid";
	self.classname = "breakable";
	self.noblood = TRUE;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	if (!self.spawnflags & 1)
		self.takedamage = DAMAGE_YES;
	else
		self.takedamage = DAMAGE_NO;
	if (self.health == 0)
		self.takedamage = DAMAGE_NO;
	self.th_die = destroy_destroy;
	self.use = destroy_destroy;
	self.ignoreaircombo = TRUE; // bugfix, don't allow air combos to lift object off ground
	setmodel (self, self.model);
};

/*QUAKED func_bell (0 .5 .8) ?
Make a bell noise when jumped on top of, also swings using an origin brush
*/

void() func_bell_touch =
{
	if (other.classname == "player" && self.attack_finished < time)
	{
		if (other.velocity_z <= -100)
		{
			sound (self, CHAN_AUTO, "misc/bell.wav", 1, ATTN_NORM);
			self.attack_finished = time + 5;
		}
	}
};

void() func_bell =
{
	precache_sound ("misc/bell.wav");

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.touch = func_bell_touch;
	setmodel (self, self.model);
};

/*QUAKED func_jumpblock (0 .5 .8) ?
jump blocks are entities that are non solid when the player is below
and solid when above, allows a player to jump through and land on top
as seen in many platformer games
*/

void() jblock_think =
{
	local entity y;

	y = find(world, classname, "player");

	while (y)
	{
		if (y.origin_z > self.absmax_z + 23)
		{
			self.solid = SOLID_BSP;
			setorigin(self, self.origin);
		}
		else
			self.solid = SOLID_NOT;
		y = find(y, classname, "player");
	}
	y = find(world, classname, "player");

	self.nextthink = self.ltime + 0.1;
};

void() func_jumpblock =
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_PUSH;
	self.classname = "jumpblock";
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);
	self.think = jblock_think;
	self.nextthink = self.ltime + 0.01;
};

/*QUAKED func_barrier (0 .5 .8) ?
barrier is similar to noclip brushes, is non-solid until triggered,
used to stop Vigil from going places he's not supposed to. Careful
as to not allow other players to get stuck inside it!

requires a target name

*/

void() barrier_think  =
{
	if (self.mode == 1)
	{
		if (self.alpha < 0.75)
			self.alpha = self.alpha + 0.005;
	}
	else // fade out, turned off!
	{
		if (self.alpha > 0)
			self.alpha = self.alpha - 0.05;
		else
		{
			setorigin (self, '-4096 -4096 -4096');
			self.think = SUB_Null;
		}
	}
	if (self.pain_finished < time)
	{
		if (random() < 0.5)
			sound (self, CHAN_VOICE, "misc/whisper1.wav", 0.5, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "misc/whisper2.wav", 0.5, ATTN_NORM);		
		self.pain_finished = time + 10;
	}
	self.nextthink = self.ltime + 0.1;
};

void() barrier_use =
{
	// Boss defeated, barrier perma-removed
	if (bosses == IT_BOSS2 && world.model == "maps/boss2.bsp")
	{
		remove(self);
		return;
	}
	
	if (self.mode == 1) // barrier off
	{
		self.mode = 0;
		sound (self, CHAN_VOICE, "misc/barrier.wav", 1, ATTN_NONE);
	}
	else // barrier on
	{
		//
		// Warp all Vigil's to the barrier activator
		//
		if (players > 1)
		{
			for (entity v = world; (v=nextent(v));)
			{
				if (v.classname != "player" && v != activator)
					continue;
				local vector oldorg;
				oldorg = v.origin;

				setorigin (v, activator.origin);

				// Add teleport 'fog'
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_TELEPORT);
				WriteCoord (MSG_BROADCAST, v.origin_x);
				WriteCoord (MSG_BROADCAST, v.origin_y);
				WriteCoord (MSG_BROADCAST, v.origin_z);
	
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_TELEPORT);
				WriteCoord (MSG_BROADCAST, oldorg_x);
				WriteCoord (MSG_BROADCAST, oldorg_y);
				WriteCoord (MSG_BROADCAST, oldorg_z);

				v.owner.telecam = TRUE;
			}
		}
		self.pain_finished = time;
		sound (self, CHAN_BODY, "misc/barrier.wav", 1, ATTN_NONE);
		setorigin(self, self.oldorigin);
		self.mode = 1;

		self.think = barrier_think;
		self.nextthink = self.ltime + 0.1;
	}
};

void() func_barrier =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_sound ("misc/barrier.wav");
	precache_sound ("misc/whisper1.wav");
	precache_sound ("misc/whisper2.wav");

	if (!self.targetname)
		objerror ("func_barrier with no target name found\n");

	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.classname = "barrier";
	setmodel (self, self.model);

	setorigin(self, self.origin);
	self.oldorigin = self.origin; // store origin

	setorigin (self, '-4096 -4096 -4096'); // stupid hack
	setsize (self, self.mins , self.maxs);

	self.alpha = 0.1;
	self.use = barrier_use;
};

/*QUAKED func_key (0 .5 .8) ?
Only triggers when the user is in possession of the needed key
*/

void() func_key_touch =
{
	if (other.classname != "player" || other.health <= 0 || self.mode == TRUE)
		return;

	if (self.cnt == 0 && keys > 0) // Gold key, user has it!
	{
		self.origin_z = self.origin_z - 10;
		sprint (other.owner, "Gold key has been used\n");
		sound (self, CHAN_AUTO, "misc/key.wav", 1, ATTN_NORM);
		SUB_UseTargets();
		self.mode = TRUE;
	}
	else if (self.cnt == 1 && keys > 1) // Silver key, user has it!
	{
		self.origin_z = self.origin_z - 10;
		sprint (other.owner, "Silver key has been used\n");
		sound (self, CHAN_AUTO, "misc/key.wav", 1, ATTN_NORM);
		SUB_UseTargets();
		self.mode = TRUE;
	}
};

void() func_key =
{
	if (!self.target)
		objerror ("func_key entity without a target\n");

	precache_sound ("misc/key.wav");

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.touch = func_key_touch;
	setmodel (self, self.model);
};

/*QUAKED func_illusionary (0 .5 .8) ?
A simple entity that looks solid but lets you walk through it.
*/
void() func_illusionary =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	makestatic (self);
};

void() func_swing_use;
void() func_swing_reset =
{
	if (self.pain_finished < time)
	{
		self.use = func_swing_use; // restore use

		self.think = SUB_Null;
		self.nextthink = self.ltime + time;
		return;
	}
	self.think = func_swing_reset;
	self.nextthink = self.ltime + 0.01;
};

void() func_swing_use =
{	
	if (!self.count) // play activate sound once
	{
		sound (self, CHAN_BODY, self.noise, 1, ATTN_NORM);
		self.count = TRUE;
	}

	// Object will reverse direction
	if (self.cnt2 == TRUE)
	{
		if (self.attack_finished < time)
		{
			self.avelocity = self.pos1 * -1;
			if (self.mode >= self.cnt)
			{
				self.avelocity = '0 0 0';
				sound (self, CHAN_BODY, self.noise2, 1, ATTN_NORM);
				self.cnt2 = self.mode = self.count = 0; // Reset back to default
				
				self.pain_finished = time + self.attack_finished;
				self.think = func_swing_reset;
				self.nextthink = self.ltime + 0.01;
				
				return;
			}

			self.use = SUB_Null; // prevent trigger_multiple spam
			self.mode = self.mode + 0.01;
		}
		self.think = func_swing_use;
		self.nextthink = self.ltime + 0.01;
		return;
	}
	else
	{
		self.avelocity = self.pos1;
		self.use = SUB_Null; // prevent trigger_multiple spam
	}

	// Object will open spin itself one way
	if (self.cnt > -1)
	{
		if (self.mode >= self.cnt) // stop moving/thinking
		{
			self.avelocity = '0 0 0';
			sound (self, CHAN_BODY, self.noise2, 1, ATTN_NORM);
			self.count = FALSE;
			self.mode = 0;
			if (self.attack_finished) // Given a value to reverse
			{
				self.cnt2 = TRUE;
				self.nextthink = self.ltime + self.attack_finished; // setup how long to swing back if desired
			}
			return;
		}
		self.mode = self.mode + 0.01;
	}
	//self.solid = SOLID_NOT; // Temporary until ericw/spike fix collision with WRBrushes

	self.think = func_swing_use;
	self.nextthink = self.ltime + 0.01;
};

/*QUAKED func_swing (0 .5 .8) ?
Swinging object. Adjustable speed (minus values swings other way), time to swing (-1 is infinite), as
well as vector rotation on any axis
*/
void() func_swing =
{
	precache_sound ("doors/door1.wav");
	precache_sound ("doors/close1.wav");

	// How long to swing
	if (!self.cnt)
		self.cnt = 1;
	
	// How long to swing back the other direction
	//if (!self.attack_finished)
	//	self.attack_finished = 3;
	
	// X,Y,Z rotation
	if (!self.pos1)
		self.pos1 = '0 350 0';
	// Default sound when triggered
	if (!self.noise)
		self.noise = "doors/door1.wav";
	// Default sound when stopped
	if (!self.noise2)
		self.noise2 = "doors/close1.wav";

	self.angles = '0 0 0';
	self.count = 0;
	self.movetype = MOVETYPE_PUSH;
	if (self.spawnflags & 1)
		self.solid = SOLID_NOT;
	else
		self.solid = SOLID_BSP;
	setmodel (self, self.model);
	self.use = func_swing_use;
};

/*
==============================================================================

SIMPLE BMODELS

==============================================================================
*/

void() func_wall_use =
{
	remove(self);
	return;
};

/*QUAKED func_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
*/
void() func_wall =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};