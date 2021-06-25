/*
==============================================================================

STAINED GLASS KNIGHT

==============================================================================
*/

$frame tpose_1

$frame idle_1_01 idle_1_02 idle_1_03 idle_1_04 idle_1_05 idle_1_06 idle_1_07
$frame idle_1_08 idle_1_09 idle_1_10 idle_1_11 idle_1_12 idle_1_13 idle_1_14
$frame idle_1_15 idle_1_16 idle_1_17 idle_1_18 idle_1_19

$frame idle_2_01 idle_2_02 idle_2_03 idle_2_04 idle_2_05 idle_2_06 idle_2_07
$frame idle_2_08 idle_2_09 idle_2_10 idle_2_11 idle_2_12 idle_2_13 idle_2_14
$frame idle_2_15 idle_2_16 idle_2_17 idle_2_18

$frame walk_1_01 walk_1_02 walk_1_03 walk_1_04 walk_1_05 walk_1_06 walk_1_07
$frame walk_1_08 walk_1_09 walk_1_10 walk_1_11 walk_1_12 walk_1_13 walk_1_14
$frame walk_1_15 walk_1_16 walk_1_17 walk_1_18 walk_1_19 walk_1_20

$frame walk_2_01 walk_2_02 walk_2_03 walk_2_04 walk_2_05 walk_2_06 walk_2_07
$frame walk_2_08 walk_2_09 walk_2_10 walk_2_11 walk_2_12 walk_2_13 walk_2_14
$frame walk_2_15 walk_2_16 walk_2_17 walk_2_18 walk_2_19 walk_2_20

$frame walk_3_01 walk_3_02 walk_3_03 walk_3_04 walk_3_05 walk_3_06 walk_3_07
$frame walk_3_08 walk_3_09 walk_3_10 walk_3_11 walk_3_12 walk_3_13 walk_3_14
$frame walk_3_15 walk_3_16 walk_3_17 walk_3_18 walk_3_19 walk_3_20 walk_3_21
$frame walk_3_22 walk_3_23 walk_3_24 walk_3_25 walk_3_26 walk_3_27 walk_3_28
$frame walk_3_29 walk_3_30 walk_3_31 walk_3_32 walk_3_33 walk_3_34 walk_3_35
$frame walk_3_36 walk_3_37 walk_3_38 walk_3_39 walk_3_40 walk_3_41

$frame attack_1_01 attack_1_02 attack_1_03 attack_1_04 attack_1_05 attack_1_06 attack_1_07
$frame attack_1_08 attack_1_09 attack_1_10 attack_1_11 attack_1_12 attack_1_13 attack_1_14
$frame attack_1_15 attack_1_16 attack_1_17 attack_1_18 attack_1_19 attack_1_20 attack_1_21
$frame attack_1_22 attack_1_23 attack_1_24 attack_1_25 attack_1_26 attack_1_27

void() sgk_think;

//
// Start idle routine
//

// normal idle
void() sgk_idle	=[	$idle_1_01,	sgk_idle	] 
{
	self.count = FALSE;
	if (self.walkframe >= 18)
		self.walkframe = 0;

	self.frame = $idle_1_01 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	monster_removeslide();
};

// low health idle
void() sgk_idle_lowhealth	=[	$idle_2_01,	sgk_idle_lowhealth	] 
{
	self.count = FALSE;
	if (self.walkframe >= 18)
		self.walkframe = 0;

	self.frame = $idle_2_01 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	monster_removeslide();
};

// check which animation to play accordingly
void() sgk_idle_animation_switch =
{
	if (self.health >= self.max_health / 2)
		sgk_idle();
	else
		sgk_idle_lowhealth();
};

//
// End idle routine
//

//
// Start walk routine
//

// walk normal
void() sgk_walk1	=[	$walk_1_01,	sgk_walk1	] 
{
	self.count = FALSE;
	if (self.walkframe >= 20)
		self.walkframe = 0;

	self.frame = $walk_1_01 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	monster_removeslide();
};

// walk hurt
void() sgk_walk2	=[	$walk_2_01,	sgk_walk2	] 
{	
	self.count = FALSE;
	if (self.walkframe >= 20)
		self.walkframe = 0;

	self.frame = $walk_2_01 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	monster_removeslide();
};

// walk really hurt
void() sgk_walk3	=[	$walk_3_01,	sgk_walk3	] 
{
	self.count = FALSE;
	if (self.walkframe >= 41)
		self.walkframe = 0;

	self.frame = $walk_3_01 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	monster_removeslide();
};

// check which animation to play accordingly
void() sgk_walk_animation_switch =
{
	if (self.health >= self.max_health / 2)
		sgk_walk1();
	else if (self.health >= self.max_health / 3)
		sgk_walk2();
	else
		sgk_walk3();	
};

// sword swing 1
void() sgk_attack1	=[	$attack_1_01,	sgk_attack1	] 
{
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}

	if (self.walkframe >= 27)
	{
		self.walkframe = 0;
		self.mode = 0; // Break out after a swing
		self.think = sgk_think;
		frameskip(0.05);
		return;
	}
	
	if (!self.flags & FL_ONGROUND) // SGK is in the air, block!
	{
		self.block_finished = time + 0.15;
		// Needs block frames
		self.frame = 131;
		frameskip(0.1);
		return;
	}

	if (self.walkframe == 7) // First swing
	{
		sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
		FireMelee(8,10,0,50,0,0,0,FALSE,0,0);
	}
	if (self.walkframe == 15) // Second swing
	{
		sound (self, CHAN_WEAPON, "player/twoosh.wav", 1, ATTN_NORM);
		FireMelee(16,10,3,50,5,0,0,FALSE,0,0);
	}

	self.frame = $attack_1_01 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	monster_removeslide();
	ai_forward(1);

	// SGK tanks hits but slows down when hurt
	if (self.pain_finished > time)
	{
		if (self.health >= self.max_health / 2) // full reaction
			frameskip(0.085);
		else if (self.health >= self.max_health / 3)
			self.nextthink = time + 0.115;
		else
			self.nextthink = time + 0.150;
	}
	else
		frameskip(0.05);
};

// magic attack 1 (fireball)
void() sgk_magic1	=[	69,	sgk_magic1	] 
{
	self.count = FALSE;

	self.colormod = '3 2 1';

	if (self.cnt2 == 4)
		Fireball(7,26); // damage, height
	if (self.cnt2 == 8)
		Fireball(7,26); // damage, height

	else if (self.cnt2 >= 12)
	{
		self.colormod = '0 0 0';
		self.walkframe = 0;
		self.mode = 0; // Break out after magic is done
		self.think = sgk_think;
		frameskip (0.1);
		return;
	}
	else
		self.frame = 69; // Temporary, needs casting frames
	
	monster_removeslide();
	self.cnt2 = self.cnt2 + 1;
	frameskip (0.1);
};

//
// End walk routine
//

void() sgk_think =
{
	//
	// Initialize the boss when he first lands on the ground
	//
	if (self.mode == 3)
		return;
	
	if (self.bigfall_recovery_finished > time)
	{
		if (self.flags & FL_ONGROUND)
		{
			self.takedamage = DAMAGE_AIM;
			self.bigfall_recovery_finished = time;
			FireAwakeTargets();
		}
		self.think = sgk_think;
		frameskip (1);
		return;
	}

	self.takedamage = DAMAGE_AIM;

	// Modes:
	// 0 = Idle
	// 1 = Walking
	// 2 = Attacking
	// 3 = Death
	// 4 = Casting Magic

	if (self.mode == 0)
		sgk_idle_animation_switch();
	if (self.mode == 1)
		sgk_walk_animation_switch();

	//
	// Players dead, time to relax
	//
	
	if (self.enemy.health < 1)
	{
		self.enemy = world;
		self.mode = 0;
		self.think = sgk_think;
		frameskip(0.1);
		return;
	}
	
	// Always face enemy
	if (self.origin_x < self.enemy.origin_x - 15)
		self.angles_y = 0;
	else
		self.angles_y = 180;
	
	//
	// Speed Adjustments
	//

	if (self.health <= self.max_health / 2 && self.speed >= 6)
		self.speed = 4;
	else if (self.health <= self.max_health / 3 && self.speed >= 2)
		self.speed = 2;
	
	//
	// SGK's Moving towards player
	//

	if (random() < 0.05)
	{
		self.stand_finished = time + 0.5 * random()*2;
		self.mode = 0;
	}

	if (self.stand_finished < time)
	{
		// No need to shift foreground/background as I'm lined up my enemy
		if (self.origin_y < self.enemy.origin_y + 20 && self.origin_y > self.enemy.origin_y - 20)
		{
			self.mode = 1; // Walk mode
			if (self.enemy.inair)
				walkmove (self.angles_y, self.speed * (-1 / 1.25)); // Back up from air attacks
			else if (!(self.origin_x > self.enemy.origin_x - 40 && self.origin_x < self.enemy.origin_x + 40))
			{
				if (!walkmove (self.angles_y, self.speed)) // walkmove failed, push with movetogoal();
					movetogoal(self.speed);
			}
		}
		else
		{
			self.mode = 1; // Walk mode
			if (self.origin_y < self.enemy.origin_y)
			{
				if (self.angles_y == 0)
					walkmove (self.angles_y + 90, self.speed);
				else
					walkmove (self.angles_y - 90, self.speed);
			}
			else
			{
				if (self.angles_y == 0)
					walkmove (self.angles_y - 90, self.speed);
				else
					walkmove (self.angles_y + 90, self.speed);
			}
			if (!(self.origin_x > self.enemy.origin_x - 40 && self.origin_x < self.enemy.origin_x + 40))
			{
				if (!walkmove (self.angles_y, self.speed / 1.5)) // Move forward towards Vigil half speed
					movetogoal(self.speed / 1.5);
			}
		}
	}
	
	//
	// SGK Attack logic
	//
	
	local float r = range(self.enemy);

	if (r <= RANGE_MELEE || r <= RANGE_CLOSE)
	{
		if (self.th_melee)
			self.mode = 2;
	}
	else if (random() < 0.05 && self.attack_finished < time)
	{
		if (self.th_magic)
		{
			self.mode = 4;
			self.attack_finished = time + 4 + random() * 4; // Wait before next cast
		}
	}
	
	if (self.mode == 2) // Attacking
		self.th_melee();
	else if (self.mode == 4) // Casting
	{
		self.cnt2 = 0;
		self.th_magic();
	}
	else
		self.think = sgk_think; // Very important to keep !

	self.colormod = '0 0 0';

	// How fast SGK thinks
	frameskip(0.05);
};

// Spawn pain rubble
void() boss1_particle_think =
{
	if (self.attack_finished < time)
		remove(self);

	particle (self.origin, '0 0 0', 12, 6);
	frameskip (0.01);
};

void() boss1_particle =
{
	local entity spark;

	spark = spawn ();
	spark.angles_y = random() * 360;
	makevectors (spark.angles);
	spark.velocity = v_forward * 50;
	spark.velocity_z = 50;
	spark.owner = self;
	spark.movetype = MOVETYPE_TOSS;
	spark.solid = SOLID_NOT;
	spark.classname = "spark";
	setmodel (spark, string_null);
	setsize (spark, '0 0 0', '0 0 0');
	makevectors (self.angles);
	setorigin (spark, self.origin);
	spark.attack_finished = time + 1;

	spark.think = boss1_particle_think;
	spark.nextthink = time;
};

void() boss1_pain =
{
	if (self.health != self.oldhealth)
		boss1_particle();

	self.oldhealth = self.health;
	
	sound (self, CHAN_VOICE, "sgk/pain.wav", 1, ATTN_NONE);
	monster_pain(self.enemy);
	self.pain_finished = time + 0.6;
};

void() boss1_death =
{
	local float ox, oy, oz, i;
	local entity effect, fx;

	self.takedamage = DAMAGE_NO;
	self.velocity_x = self.velocity_y = 0;

	bosses = bosses | IT_BOSS1; // Defeated Boss 1, record it

	//local string s = ftos(bosses);
	//bprint ("Boss Flag: ", s, "\n");

	if (self.cnt < 10)
	{
		self.enemy.owner.screenflash_finished = time + 0.1;
		shake_camera(0.1);
		ox = self.origin_x;
		oy = self.origin_y;
		oz = self.origin_z;

		sound (self, CHAN_BODY, "misc/explode.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, ox);
		WriteCoord (MSG_BROADCAST, oy);
		WriteCoord (MSG_BROADCAST, oz);
	}
	else
	{
		if (self.gaveexp != TRUE) // only give experience on first instance of death
		{				    	  // otherwise player can keep knocking corpse for EXP
			self.takedamage = DAMAGE_NO;
			self.gaveexp = TRUE;
			GiveExperience(999999);
			SUB_UseTargets(); // fire any activators
		}
	
		freeze_finished = time + 0.1 * (frametime * 100); // slowmo effect
		self.enemy.owner.screenflash_finished = time + 0.5;

		effect = spawn();
		setorigin(effect, self.origin);
		setmodel(effect, "progs/explode1.mdl");
		effect.movetype = MOVETYPE_NONE;
		effect.think = explodemodel_think;
		effect.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
		effect.nextthink = time;
		effect.alpha = 1;
		effect.solid = SOLID_NOT;
		sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);

		fx = spawn(); // special flash
		setorigin(fx, self.origin);
		setmodel(fx, "progs/efxflash.mdl");
		fx.movetype = MOVETYPE_NOCLIP;
		fx.alpha = 1;
		fx.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
		fx.think = efxflashe_think;
		fx.nextthink = time;
		fx.solid = SOLID_NOT;

		remove(self);
		return;
	}

	self.cnt = self.cnt + 1;
	self.frame = 35; // Needs proper death frames
	self.think = boss1_death;
	frameskip (0.25);
};

//
// Boss wakes up
//

void() boss1_awake =
{
	self.movetype = MOVETYPE_STEP; // Go

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
		
	self.velocity = '0 500 0';
	sound (self, CHAN_AUTO, "player/jump.wav", 1, ATTN_NONE);
	
	self.enemy = self.goalentity = activator;
	self.bigfall_recovery_finished = time + 999;
	sgk_think(); // start boss

	freeze_finished = time + 0.125 * (frametime * 100); // slowmo effect
};

void() monster_boss1_remove =
{
	if (bosses & IT_BOSS1) // defeated
	{
		remove(self);
		return;
	}
	frameskip(0.1);
};

/*QUAKED monster_boss1 (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_boss1 =
{
	if (bosses & IT_BOSS1) // defeated
	{
		remove(self);
		return;
	}
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/s_knight.mdl");
	precache_sound ("knight/sword1.wav");
	precache_sound ("sgk/pain.wav");
	precache_sound ("misc/explode.wav");

	self.movetype = MOVETYPE_NOCLIP; // Don't move until activated
	setmodel (self, "progs/s_knight.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 64');
	if (difficulty < 2)
		self.health = self.max_health = 800; // regular health
	else
		self.health = self.max_health = 1200; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.classname = "sgknight";
	self.displayname = "Stained Glass Knight";

	self.speed = 6;
	self.noblood = TRUE;
	self.flags = FL_MONSTER | FL_BOSS | IT_BOSS1;

	self.th_die = boss1_death;
	self.th_pain = boss1_pain;
	self.th_melee = sgk_attack1;
	self.th_magic = sgk_magic1;

	self.use = boss1_awake; // Wake up trigger
	self.experience = 999999; // instant level up

	self.think = monster_boss1_remove;
	self.nextthink = time + 0.1;

//	self.th_block = knight_block1;
//	if (!self.ai_blockfreq) // frequency on how much the enemy blocks
//	{
//		if (difficulty < 2)
//			self.ai_blockfreq = 0.03; // 3% skill 1
//		else
//			self.ai_blockfreq = 0.7;  // 10% skill 2
//	}

//	spawn_shadow();
};