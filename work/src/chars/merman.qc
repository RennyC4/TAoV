/*
+--------+
|Merman  |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Merman, mid-powerful monster on land and spits acid - swims as well.       |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10
$frame stand11 stand12 stand13 stand14 stand15 stand16 stand17 stand18 stand19 stand20

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame melee1 melee2 melee3 melee4 melee5 melee6 melee7 melee8 melee9 melee10
$frame melee11 melee12 melee13 melee14 melee15 melee16 melee17 melee18 melee19 melee20

$frame spit1 spit2 spit3 spit4 spit5 spit6 spit7 spit8 spit9 spit10

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12

$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 jump8 jump9 jump10 jump11

$frame swim1 swim2 swim3 swim4 swim5 swim6 swim7 swim8 swim9 swim10 swim11 swim12
$frame swim13 swim14 swim15

void()	merman_idle	=[	$stand1,	merman_idle	] 
{	
	if (self.walkframe >= 20)
		self.walkframe = 0;

	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	if (!self.enemy.flypain)
		ai_stand();

	self.movetype = MOVETYPE_STEP;

	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	
	monster_removeslide();
	self.count = FALSE;
};

void()	merman_swim	=[	$swim1,	merman_swim	] 
{
	if (self.walkframe >= 15)
		self.walkframe = 0;

	self.frame = $swim1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	if (self.walkframe == 1)
		sound (self, CHAN_BODY, "hydra/swim.wav", 1, ATTN_NORM);

	if (self.movetype != MOVETYPE_FLY)
		self.movetype = MOVETYPE_FLY;
	if (!self.flags & FL_SWIM)
		self.flags = self.flags | FL_SWIM;

	ai_swim(6);

	self.count = FALSE;
};

void()	merman_walk	=[	$walk1,	merman_walk	] 
{
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
	{
		self.waterjump_finished = time + 1.5; // don't jump back out of the water immediately
		self.th_swim();
		return;
	}
	self.count = FALSE;

	if (self.walkframe >= 18)
		self.walkframe = 0;

	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	monster_removeslide();
	ai_walk(5);
	self.movetype = MOVETYPE_STEP;
	self.count = FALSE;
	
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};

void()	merman_run	=[	$run1,	merman_run	] 
{
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
	{
		merman_idle();
		return;
	}
	if (self.walkframe >= 8)
		self.walkframe = 0;

	self.frame = $run1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	monster_removeslide();
	ai_walk(15);
};

void()	merman_attack	=[	$melee1,	merman_attack	] 
{
	// Used to set walkframe to zero on new animation
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}
	if (self.walkframe >= 20)
	{
		self.walkframe = 0;
		if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
			self.think = self.th_swim;
		else
			self.think = self.th_walk;
		return;
	}
	
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)	
	{
		self.velocity = '0 0 0'; // prevent flying when attacking on top of the water surface
		self.movetype = MOVETYPE_FLY;
	}

	if (self.walkframe == 7)
		FireMelee(8,10,0,35,0,0,0,FALSE,0,0);
	if (self.walkframe == 17)
		FireMelee(13,10,3,35,2,0,0,FALSE,0,0);

	self.frame = $melee1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	monster_removeslide();
	ai_forward(3);
	frameskip(0.05);
};

void() MermanSpitTouch =
{
	local entity effect;
	
	if (other == self.owner)
		return; // don't explode on owner
	
	sound (self, CHAN_WEAPON, "merman/dissolve.wav", 1, ATTN_NORM);
	remove(self);
	return;
};

void() MermanSpitThink =
{
	local entity head, effect;

	MakeSolidList(TRUE);

	head = searchradius(self.origin, 5);
	while (head)
	{
		if (head.takedamage && self.owner != head && self.owner.enemy == head)
		{
			if (head.perfectblock < time)
			{
				if (head.block_finished < time) // Do damage
				{
					sound (self, CHAN_WEAPON, "merman/dissolve.wav", 1, ATTN_NORM);
					self.owner.status_poison_finished = time + 6;
					T_Damage (head, self.owner, self.owner, 1, 1);
					head.colormod = '0 5 0';
					remove(self);
					return;
				}
				else // Regular block
				{
					// spawn a block sprite
					effect = spawn();
					setorigin(effect, head.origin);
					setmodel(effect, "progs/block.spr");
					effect.angles_y = -90;
					effect.angles_z = random()*360;
					effect.effects = EF_NODEPTHTEST;
					effect.movetype = MOVETYPE_NONE;
					effect.think = fx_think;
					effect.nextthink = time;
					effect.solid = SOLID_NOT;
					sound (head, CHAN_BODY, "player/block.wav", 1, ATTN_NORM);

					// block
					if (head.classname == "player")
					{
						// look in the proper direction
						if (head.origin_x < self.owner.origin_x)
							head.angles_y = 0;
						else
							head.angles_y = 180;

						head.purge_cooldown = time;
						head.effects = EF_MUZZLEFLASH; // create light on melee impact
						head.think = player_block;
						head.nextthink = time + 0.1;
						// Check if Vigil is close, if so allow counter
						if (range(self.owner, self.owner.enemy) == RANGE_CLOSE || range(self.owner, self.owner.enemy) == RANGE_MELEE || range(self.owner, self.owner.enemy) == RANGE_NEAR)
						{
							head.enemy = self.owner; // needed for counter attack to face the proper direction
							head.counter_finished = time + 0.5;
						}
					}
					remove(self);
					return;
				}
			}
			else // Perfect Block
			{
				// look in the proper direction
				if (head.origin_x < self.owner.origin_x)
					head.angles_y = 0;
				else
					head.angles_y = 180;
				if (range(self.owner, self.owner.enemy) == RANGE_CLOSE || range(self.owner, self.owner.enemy) == RANGE_MELEE || range(self.owner, self.owner.enemy) == RANGE_NEAR)
				{
					head.enemy = self.owner; // needed for counter attack to face the proper direction
					head.counter_finished = time + 0.5;
				}
				PerfectGuard(head);
				remove(self);
				return;
			}
		}
		head = head.chain;
	}
	UnmakeSolidList();

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
		
	frameskip(0.01);
};

void() Fire_MermanSpit =
{
	local	entity missile;
	
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
		
	// set missile speed	
	makevectors (self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 300;
	missile.angles = vectoangles(missile.velocity);
	missile.angles_y = self.owner.angles_y;
	
	missile.touch = MermanSpitTouch;

	missile.think = MermanSpitThink;
	missile.nextthink = time + 0.1;
	
	setmodel (missile, "progs/spit.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_up*20 + v_forward*22);
};


void()	merman_spit	=[	$melee1,	merman_spit	] 
{
	// Used to set walkframe to zero on new animation
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}
	if (self.walkframe >= 10)
	{
		self.walkframe = 0;
		if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
			self.think = self.th_swim;
		else
			self.think = self.th_walk;
		return;
	}
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
		self.velocity = '0 0 0'; // remove velocity in water only!
	if (self.walkframe == 4)
	{
		Fire_MermanSpit();
		sound (self, CHAN_BODY, "merman/spit.wav", 1, ATTN_NORM);
	}
		
	self.frame = $spit1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	ai_forceface();
};

void()	merman_pain1	=[	$pain1, 	merman_pain2	] {monster_removeslide();};
void()	merman_pain2	=[	$pain2, 	merman_pain3	] {monster_removeslide();};
void()	merman_pain3	=[	$pain3, 	merman_pain4	] {monster_removeslide();};
void()	merman_pain4	=[	$pain4, 	merman_pain5	] {monster_removeslide();};
void()	merman_pain5	=[	$pain5, 	merman_pain6	] {monster_removeslide();};
void()	merman_pain6	=[	$pain6, 	merman_idle		] {monster_removeslide();};

void() merman_pain = 
{
	self.cnt = self.cnt + 1;
	monster_pain(self.enemy);
	monster_removeslide();
	if (self.cnt > 2 || self.grab_finished > time || self.enemy.grabbed || self.enemy.perfectguard_buff > time)
	{
		sound (self, CHAN_VOICE, "merman/pain.wav", 1, ATTN_NORM);
		merman_pain1();
		self.cnt = 0;
	}
	frameskip(0.1);
};

void()	merman_jump1	=[	$jump1,		merman_jump2	] 
{
	local vector dir;
	local float dist;
	
	self.movetype = MOVETYPE_TOSS;

	makevectors (self.angles);

	dir = normalize(self.enemy.origin - self.origin);
	dist = vlen(self.enemy.origin - self.origin);

	self.velocity = dir * dist;
	dist = self.enemy.origin_z - self.origin_z;

	// A vertical velocity to jump just above player's head
	// for any given distance between z origins.
	// (hack numbers that work for Quake)
	dist = dist - 237;
	self.velocity_z = 714 + dist;
	
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	
	self.count = FALSE;
	sound (self, CHAN_AUTO, "player/jump.wav", 1, ATTN_NORM);
};
void()	merman_jump2	=[	$jump2,		merman_jump3	] {};
void()	merman_jump3	=[	$jump3,		merman_jump4	] {};
void()	merman_jump4	=[	$jump4,		merman_jump5	] {};
void()	merman_jump5	=[	$jump5,		merman_jump6	] {};
void()	merman_jump6	=[	$jump6,		merman_jump7	] {};
void()	merman_jump7	=[	$jump7,		merman_jump8	] {};
void()	merman_jump8	=[	$jump8,		merman_jump9	] {};
void()	merman_jump9	=[	$jump9,		merman_jump10	] {};
void()	merman_jump10	=[	$jump10,	merman_jump11	] {};
void()	merman_jump11	=[	$jump11,	merman_jump11	] 
{
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		merman_walk();
	}
};

void()	merman_grabbed1	=[	$spit3,		merman_grabbed2	] {self.grab_finished = time + 1;};
void()	merman_grabbed2	=[	$pain1,		merman_grabbed2	] 
{
	if (self.grab_finished < time || self.grabbed == FALSE)
	{
		self.th_walk();
		return;
	}		
};

void() merman_die1	=[	$death1,	merman_die1	]
{
	if (self.walkframe >= 11)
	{
		self.walkframe = 11;
		self.movetype = MOVETYPE_STEP;
		self.think = SUB_Null; // Do something cool
	}
	self.frame = $death1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	monster_death();
};


void() merman_die =
{
	// Used to set walkframe to zero on new animation
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}	
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  		  // otherwise player can keep knocking corpse for EXP
		self.gaveexp = TRUE;
		GiveExperience(self.experience);
		self.walkframe = 0;
		sound (self, CHAN_VOICE, "merman/die.wav", 1, ATTN_NORM);
	}
	merman_die1();
};

/*QUAKED monster_merman (1 0 0) (-16 -16 -24) (16 16 32)
"awareness":
0 (default) notice player when near and visible
1 notice player if visible at all
2 notice player instantly
3 ignore player, check if camera is infront of monster
4 not aware at all, must be triggered
"target":
If monster is given a target, when the monster dies it
can cause an event such as a door opening!
*/

void() monster_merman =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/spit.mdl");
	precache_model ("progs/merman.mdl");
	precache_sound ("hydra/swim.wav");
	precache_sound ("merman/die.wav");
	precache_sound ("merman/pain.wav");
	precache_sound ("merman/spit.wav");
	precache_sound ("merman/dissolve.wav");

	self.movetype = MOVETYPE_STEP; // Movetype FLY when in-water

	setmodel (self, "progs/merman.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (difficulty < 2)
		self.health = self.max_health = 77; // regular health
	else
		self.health = self.max_health = 132; // hard health (50% tougher)

	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "merman";
	self.displayname = "Merman";
	self.experience = 44;
	self.maxgold = 88;

	self.th_stand = merman_idle;
	self.th_walk = merman_walk;
	self.th_run = merman_run;
	self.th_melee = merman_attack;
	self.th_missile = merman_spit;
	self.th_magic = merman_spit;
	self.th_pain = merman_pain;
	self.th_grab = merman_grabbed1;
	self.th_die = merman_die;
	self.th_jump = merman_jump1;
	self.th_swim = merman_swim;
	
	//spawn_shadow();
	enemy_start();
};
