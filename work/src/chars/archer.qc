/*
+--------+
|Archer  |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Projectile monster only, shoots arrows from far distances. annoyance.      |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/     

$frame base
$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9 shoot10 shoot11 shoot12 shoot13 shoot14 shoot15 shoot16
$frame shootb1 shootb2 shootb3 shootb4 shootb5 shootb6 shootb7 shootb8 shootb9 shootb10 shootb11 shootb12 shootb13 shootb14 shootb15 shootb16 shootb17 shootb18
$frame stand1 stand2 stand3 stand4 stand5 stand6
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame death1

void() archer_stand1	=[	$stand1,	archer_stand2		] {ai_stand();};
void() archer_stand2	=[	$stand2,	archer_stand3		] {ai_stand();};
void() archer_stand3	=[	$stand3,	archer_stand4		] {ai_stand();};
void() archer_stand4	=[	$stand4,	archer_stand5		] {ai_stand();};
void() archer_stand5	=[	$stand5,	archer_stand6		] {ai_stand();};
void() archer_stand6	=[	$stand6,	archer_stand1		] {ai_stand();};

void() archer_move1 	=[	$walk1,	archer_move2	] {ai_walk(8);};
void() archer_move2 	=[	$walk2,	archer_move3	] {ai_walk(8);};
void() archer_move3 	=[	$walk3,	archer_move4	] {ai_walk(8);};
void() archer_move4 	=[	$walk4,	archer_move5	] {ai_walk(8);};
void() archer_move5 	=[	$walk5,	archer_move6	] {ai_walk(8);};
void() archer_move6 	=[	$walk6,	archer_move7	] {ai_walk(8);};
void() archer_move7 	=[	$walk7,	archer_move8	] {ai_walk(8);};
void() archer_move8 	=[	$walk8,	archer_move1	] {ai_walk(8);};

void() arrow_remove =
{
	if (self.alpha > 0.1)
		self.alpha = self.alpha - 0.1;
	if (self.cnt < 10)
		self.cnt = self.cnt + 1;
	else
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.1;
};

void() archer_arrow_touch =
{
	local entity effect;
	local vector dir;

	if (other.solid == SOLID_BSP && self.velocity != '0 0 0')
	{
		self.movetype = MOVETYPE_FLY;
		self.velocity = '0 0 0';
		sound (self, CHAN_BODY, "archer/arrowhit.wav", 1, ATTN_NORM);
		self.think = arrow_remove;
		self.nextthink = time + 0.1;
		self.touch = SUB_Null;
	}
};

void() ArcherArrowThink =
{
	local entity head, effect;

	MakeSolidList();

	self.angles = vectoangles(self.velocity);

	head = searchradius(self.origin, 5);
	while (head)
	{
		if (head.takedamage && self.owner != head && self.owner.enemy == head && head.perfectguard_buff < time)
		{
			if (head.perfectblock < time)
			{
				if (head.block_finished < time) // Do damage
				{
					sound (self, CHAN_WEAPON, "archer/arrowhit.wav", 1, ATTN_NORM);
					T_Damage (head, self.owner, self.owner, 11, 0);
					ThrowBloodSplat(head.origin, head);
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
						if (head.origin_x < self.owner.origin_x)
							head.angles_y = 0;
						else
							head.angles_y = 180;
				
						head.effects = EF_MUZZLEFLASH; // create light on melee impact
						head.think = player_block;
						head.nextthink = time + 0.1;
					}
					self.avelocity = '500 1000 0';
					self.movetype = MOVETYPE_BOUNCE;
					self.touch = SUB_Null;
					self.velocity = '0 0 0';
					self.think = arrow_remove;
					self.nextthink = time;
					return;
				}
			}
			else // Perfect Block
			{
				if (head.origin_x < self.origin_x)
					head.angles_y = 0;
				else
					head.angles_y = 180;

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

void() archer_arrow =
{
	local entity missile;
	local   float   dist;   // Distance between attacker and target.
	local   float   base;   // This dictates how fast the projectile
                              //   will fly up when it is launched.
	local   float   g;      // Gravity -- g = 1 is Earth gravity.

	g = (cvar("sv_gravity")) * 0.00125;	// Find gravity in terms of g.
	dist = vlen(self.enemy.origin - self.origin);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_TRIGGER;
	missile.hitcontentsmaski = CONTENTBIT_SOLID|0x00000002i|CONTENTBIT_BODY; // ignore clip
	
	makevectors (self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;

	if (self.mode == 0)
		missile.cnt = 175;
	else
		missile.cnt = 100;

	if (self.enemy.velocity_x || self.enemy.velocity_y)
		if (random() < 0.9)
			dist = dist - random()*300;
	if (self.mode == 0)
	{
		if (dist > 900)
			base = missile.cnt+((dist - (200 - (dist * 0.2)))*0.5);
		else if (dist > 700)
			base = missile.cnt+((dist - (200 - (dist * 0.15)))*0.5);
		else if (dist > 500)
			base = missile.cnt+((dist - (200 - (dist * 0.1)))*0.5);
		else if (dist > 200)
			base = missile.cnt+((dist - 200)*0.5);
		else
			base = missile.cnt;
	}
	else // background archers
	{
		if (dist > 900)
			base = missile.cnt+((dist - (200 - (dist * 0.2)))*0.5) * 1.2;
		else if (dist > 700)
			base = missile.cnt+((dist - (200 - (dist * 0.15)))*0.5) * 1.2;
		else if (dist > 500)
			base = missile.cnt+((dist - (200 - (dist * 0.1)))*0.5) * 1.2;
		else if (dist > 200)
			base = missile.cnt+((dist - 200)*0.5) * 1.2;
		else
			base = missile.cnt * 1.2;
	}

	missile.velocity_z = (missile.velocity_z + (base * g));

	missile.think = ArcherArrowThink;
	missile.nextthink = time;

	missile.touch = archer_arrow_touch; // stick in walls temporarily, then fade

	missile.effects = EF_FULLBRIGHT;
	missile.alpha = 1;
	setmodel (missile, "progs/arrow.mdl");
	setsize (missile, '-1 -1 -1', '1 1 1');
	if (self.mode == 0)
		setorigin (missile, self.origin + v_up * 16);
	else
		setorigin (missile, self.origin + v_up * 48);
};

void() archer_fire1 	=[	$shoot1,	archer_fire2	] {ai_forceface();};
void() archer_fire2 	=[	$shoot2,	archer_fire3	] {ai_forceface();};
void() archer_fire3 	=[	$shoot3,	archer_fire4	] {ai_forceface();};
void() archer_fire4 	=[	$shoot4,	archer_fire5	] {ai_forceface();};
void() archer_fire5 	=[	$shoot5,	archer_fire6	] {ai_forceface();};
void() archer_fire6 	=[	$shoot6,	archer_fire7	] {ai_forceface();};
void() archer_fire7 	=[	$shoot7,	archer_fire8	] {ai_forceface();};
void() archer_fire8 	=[	$shoot8,	archer_fire9	] {ai_forceface();};
void() archer_fire9 	=[	$shoot9,	archer_fire10	] {ai_forceface();};
void() archer_fire10 	=[	$shoot10,	archer_fire11	] {ai_forceface();};
void() archer_fire11 	=[	$shoot11,	archer_fire12	] {ai_forceface();};
void() archer_fire12 	=[	$shoot12,	archer_fire13	] {};
void() archer_fire13 	=[	$shoot13,	archer_fire14	] {};
void() archer_fire14 	=[	$shoot14,	archer_fire15	] 
{
	archer_arrow();
	sound (self, CHAN_WEAPON, "archer/arrowuse.wav", 1, ATTN_NORM);
};
void() archer_fire15 	=[	$shoot15,	archer_fire16	] {};
void() archer_fire16 	=[	$shoot16,	archer_move1	] {};

void() archer_fireb1 	=[	$shootb1,	archer_fireb2	] {ai_forceface();};
void() archer_fireb2 	=[	$shootb2,	archer_fireb3	] {ai_forceface();};
void() archer_fireb3 	=[	$shootb3,	archer_fireb4	] {ai_forceface();};
void() archer_fireb4 	=[	$shootb4,	archer_fireb5	] {ai_forceface();};
void() archer_fireb5 	=[	$shootb5,	archer_fireb6	] {ai_forceface();};
void() archer_fireb6 	=[	$shootb6,	archer_fireb7	] {ai_forceface();};
void() archer_fireb7 	=[	$shootb7,	archer_fireb8	] {ai_forceface();};
void() archer_fireb8 	=[	$shootb8,	archer_fireb9	] {ai_forceface();};
void() archer_fireb9 	=[	$shootb9,	archer_fireb10	] {ai_forceface();};
void() archer_fireb10 	=[	$shootb10,	archer_fireb11	] {ai_forceface();};
void() archer_fireb11 	=[	$shootb11,	archer_fireb12	] {ai_forceface();};
void() archer_fireb12 	=[	$shootb12,	archer_fireb13	] {};
void() archer_fireb13 	=[	$shootb13,	archer_fireb14	] {};
void() archer_fireb14 	=[	$shootb14,	archer_fireb15	] {};
void() archer_fireb15 	=[	$shootb15,	archer_fireb16	] {};
void() archer_fireb16 	=[	$shootb16,	archer_fireb17	] {self.nextthink = time + 1;};
void() archer_fireb17 	=[	$shootb17,	archer_fireb18	] 
{
	archer_arrow();
	sound (self, CHAN_WEAPON, "archer/arrowuse.wav", 1, ATTN_NORM);
};
void() archer_fireb18 	=[	$shootb18,	archer_move1	] {};

// archer decides what type of firing animation to play on how far Vigil is
void() archer_fire_decide =
{
	if (range(self.enemy) == RANGE_FAR)
		archer_fireb1();
	else
		archer_fire1();
};

void() archer_pain1 	=[	$pain1,	archer_pain2	] {monster_removeslide();};
void() archer_pain2 	=[	$pain2,	archer_pain3	] {monster_removeslide();};
void() archer_pain3 	=[	$pain3,	archer_pain4	] {monster_removeslide();};
void() archer_pain4 	=[	$pain4,	archer_pain5	] {monster_removeslide();};
void() archer_pain5		=[	$pain5,	archer_pain6	] {monster_removeslide();};
void() archer_pain6 	=[	$pain6,	archer_move1	] {monster_removeslide();};

void() archer_pain =
{
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "archer/pain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "archer/pain2.wav", 1, ATTN_NORM);
	archer_pain1();
	monster_pain(self.enemy);
};

void()	archer_grabbed1	=[	$pain5,		archer_grabbed2	] {self.grab_finished = time + 1;};
void()	archer_grabbed2	=[	$pain5,		archer_grabbed2	] 
{
	if (self.grab_finished < time || self.grabbed == FALSE)
	{
		self.th_run();
		return;
	}		
};

void() archer_death1	=[	$death1,		archer_death1	] {monster_death();};

void() archer_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  		  // otherwise player can keep knocking corpse for EXP
		GiveExperience(self.experience);
		self.gaveexp = TRUE;
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		sound (self, CHAN_VOICE, "archer/death.wav", 1, ATTN_NORM);
	}
	if (self.damage_type == 5) // Sliced/Gored in half
	{
		sound (self, CHAN_BODY, "misc/guts.wav", 1, ATTN_NORM);
		ThrowBodyPart("progs/archer_c1.mdl");
		ThrowBodyPart("progs/archer_c2.mdl");
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		remove(self);
		return;
	}
	
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	archer_death1();
};

/*QUAKED monster_archer (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_archer =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/archer.mdl");
	precache_model ("progs/archer_c1.mdl");
	precache_model ("progs/archer_c2.mdl");
	precache_model ("progs/arrow.mdl");

	precache_sound ("archer/arrowhit.wav");
	precache_sound ("archer/arrowuse.wav");
	precache_sound ("archer/pain1.wav");
	precache_sound ("archer/pain2.wav");
	precache_sound ("archer/death.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/archer.mdl");

	if (difficulty < 2)
	{
		if (self.mode == 0)
			self.health = 75; // regular health
		else
			self.health = 25; // regular health
	}
	else
	{
		if (self.mode == 0)
			self.health = 113; // hard health (50% tougher)
		else
			self.health = 45;
	}

	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "archer";
	self.displayname = "Archer";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.experience = 19; // how much exp to give on death

	self.th_stand = archer_stand1;
	self.th_run = archer_move1;
	self.th_grab = archer_grabbed1;
	self.th_pain = archer_pain;
	self.th_die = archer_die;

	self.th_melee = archer_fire_decide;
	self.th_missile = archer_fire_decide;

	enemy_start();
};