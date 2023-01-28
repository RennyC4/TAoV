/*
+--------+
|Wraith  |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Chases enemies non stop, is no clip and carries a huge deadly sword,       |
| not easily seen.                                                           |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12
$frame run1 run2 run3 run4 run5 run6
$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10 smash11 smash12
$frame astrike1 astrike2 astrike3 astrike4 astrike5 astrike6 astrike7 astrike8 astrike9
$frame cstrike1 cstrike2 cstrike3 cstrike4 cstrike5 cstrike6 cstrike7 cstrike8 cstrike9
$frame magic1 magic2 magic3 magic4 magic5 magic6 magic7 magic8 magic9 magic10 magic11 magic12
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12

void() wraith_stand1	=[	$stand1,	wraith_stand2		] 
{
	ai_stand();
	self.alpha = 0.2;

	local float r = random();	
	if (random() < 0.1)
	{
		self.velocity = '0 0 0';
		if (r < 0.5)
			sound (self, CHAN_VOICE, "wraith/idle1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "wraith/idle2.wav", 1, ATTN_NORM);
	}
};
void() wraith_stand2	=[	$stand2,	wraith_stand3		] {ai_stand();};
void() wraith_stand3	=[	$stand3,	wraith_stand4		] {ai_stand();};
void() wraith_stand4	=[	$stand4,	wraith_stand5		] {ai_stand();};
void() wraith_stand5	=[	$stand5,	wraith_stand6		] {ai_stand();};
void() wraith_stand6	=[	$stand6,	wraith_stand7		] {ai_stand();};
void() wraith_stand7	=[	$stand7,	wraith_stand8		] {ai_stand();};
void() wraith_stand8	=[	$stand8,	wraith_stand9		] {ai_stand();};
void() wraith_stand9	=[	$stand9,	wraith_stand10		] {ai_stand();};
void() wraith_stand10	=[	$stand10,	wraith_stand11		] {ai_stand();};
void() wraith_stand11	=[	$stand11,	wraith_stand12		] {ai_stand();};
void() wraith_stand12	=[	$stand12,	wraith_stand13		] {ai_stand();};
void() wraith_stand13	=[	$stand13,	wraith_stand14		] {ai_stand();};
void() wraith_stand14	=[	$stand14,	wraith_stand15		] {ai_stand();};
void() wraith_stand15	=[	$stand15,	wraith_stand16		] {ai_stand();};
void() wraith_stand16	=[	$stand16,	wraith_stand17		] {ai_stand();};
void() wraith_stand17	=[	$stand17,	wraith_stand1		] {ai_stand();};

void() wraith_walk1	=[	$walk1,	wraith_walk2		] 
{
	self.alpha = 0.2;
	ai_fly(8);
};
void() wraith_walk2	=[	$walk2,	wraith_walk3		] 
{
	local float r = random();
	if (random() < 0.1)
	{
		self.velocity = '0 0 0';
		if (r < 0.5)
			sound (self, CHAN_VOICE, "wraith/idle1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "wraith/idle2.wav", 1, ATTN_NORM);
	}
	ai_fly(16);
};
void() wraith_walk3	=[	$walk3,	wraith_walk4		] {ai_fly(16);};
void() wraith_walk4	=[	$walk4,	wraith_walk5		] {ai_fly(16);};
void() wraith_walk5	=[	$walk5,	wraith_walk6		] {ai_fly(16);};
void() wraith_walk6	=[	$walk6,	wraith_walk7		] {ai_fly(16);};
void() wraith_walk7	=[	$walk7,	wraith_walk8		] {ai_fly(16);};
void() wraith_walk8	=[	$walk8,	wraith_walk9		] {ai_fly(16);};
void() wraith_walk9	=[	$walk9,	wraith_walk10		] {ai_fly(16);};
void() wraith_walk10	=[	$walk10,	wraith_walk11		] {ai_fly(16);};
void() wraith_walk11	=[	$walk11,	wraith_walk12		] {ai_fly(16);};
void() wraith_walk12	=[	$walk12,	wraith_walk1		] 
{
	if (random() < 0.2)
		self.velocity = '0 0 0';
	ai_fly(16);
};

void() wraith_smash1	=[	$smash1,	wraith_smash2		] 
{
	local float b = random()*4 * 0.1;  // stagger first frame
	frameskip(0.08 + b);
	ai_forceface();
};
void() wraith_smash2	=[	$smash2,	wraith_smash3		] {frameskip(0.08);ai_forceface();};
void() wraith_smash3	=[	$smash3,	wraith_smash4		] {frameskip(0.08);ai_forceface();};
void() wraith_smash4	=[	$smash4,	wraith_smash5		] {frameskip(0.08);ai_forceface();};
void() wraith_smash5	=[	$smash5,	wraith_smash6		] {frameskip(0.08);ai_forceface();};
void() wraith_smash6	=[	$smash6,	wraith_smash7		] {frameskip(0.08);ai_forceface();};
void() wraith_smash7	=[	$smash7,	wraith_smash8		] {frameskip(0.08);ai_forceface();};
void() wraith_smash8	=[	$smash8,	wraith_smash9		] {frameskip(0.08);ai_forceface();};
void() wraith_smash9	=[	$smash9,	wraith_smash10		] {FireMelee(36,35,2,50,5,0,1,FALSE,0,0,0);frameskip(0.08);ai_forceface();};
void() wraith_smash10	=[	$smash10,	wraith_smash11		] {frameskip(0.08);ai_forceface();};
void() wraith_smash11	=[	$smash11,	wraith_smash12		] {frameskip(0.08);ai_forceface();};
void() wraith_smash12	=[	$smash12,	wraith_walk1		] {frameskip(0.08);ai_forceface();};

void() wraith_strike1	=[	$astrike1,	wraith_strike2		] 
{
	local float b = random()*4 * 0.1;  // stagger first frame
	frameskip(0.08 + b);
	ai_forceface();
};
void() wraith_strike2	=[	$astrike2,	wraith_strike3		] {frameskip(0.08);ai_forceface();};
void() wraith_strike3	=[	$astrike3,	wraith_strike4		] {frameskip(0.08);ai_forceface();};
void() wraith_strike4	=[	$astrike4,	wraith_strike5		] {frameskip(0.08);ai_forceface();};
void() wraith_strike5	=[	$astrike5,	wraith_strike6		] {FireMelee(36,35,3,50,5,0,1,FALSE,0,0,0);frameskip(0.08);ai_forceface();};
void() wraith_strike6	=[	$astrike6,	wraith_strike7		] {frameskip(0.08);ai_forceface();};
void() wraith_strike7	=[	$astrike7,	wraith_strike8		] {frameskip(0.08);ai_forceface();};
void() wraith_strike8	=[	$astrike8,	wraith_strike9		] {frameskip(0.08);ai_forceface();};
void() wraith_strike9	=[	$astrike9,	wraith_walk1		] {frameskip(0.08);ai_forceface();};

void() wraith_cstrike1	=[	$cstrike1,	wraith_cstrike2		] 
{
	local float b = random()*4 * 0.1;  // stagger first frame
	frameskip(0.08 + b);
	ai_forceface();
};
void() wraith_cstrike2	=[	$cstrike2,	wraith_cstrike3		] {frameskip(0.08);ai_forceface();};
void() wraith_cstrike3	=[	$cstrike3,	wraith_cstrike4		] {frameskip(0.08);ai_forceface();};
void() wraith_cstrike4	=[	$cstrike4,	wraith_cstrike5		] {frameskip(0.08);ai_forceface();};
void() wraith_cstrike5	=[	$cstrike5,	wraith_cstrike6		] {frameskip(0.08);ai_forceface();};
void() wraith_cstrike6	=[	$cstrike6,	wraith_cstrike7		] {FireMelee(36,35,3,50,5,0,1,FALSE,0,0,0);frameskip(0.08);ai_forceface();};
void() wraith_cstrike7	=[	$cstrike7,	wraith_cstrike8		] {frameskip(0.08);ai_forceface();};
void() wraith_cstrike8	=[	$cstrike8,	wraith_cstrike9		] {frameskip(0.08);ai_forceface();};
void() wraith_cstrike9	=[	$cstrike9,	wraith_walk1		] {frameskip(0.08);ai_forceface();};

void() wraith_magic1	=[	$magic1,	wraith_magic2		] 
{
	local float b = random()*4 * 0.1;  // stagger first frame
	frameskip(0.08 + b);
	ai_forceface();
};
void() wraith_magic2	=[	$magic2,	wraith_magic3		] {frameskip(0.08);ai_forceface();};
void() wraith_magic3	=[	$magic3,	wraith_magic4		] {frameskip(0.08);ai_forceface();};
void() wraith_magic4	=[	$magic4,	wraith_magic5		] {frameskip(0.08);ai_forceface();};
void() wraith_magic5	=[	$magic5,	wraith_magic6		] {frameskip(0.08);ai_forceface();};
void() wraith_magic6	=[	$magic6,	wraith_magic7		] {FireMelee(36,35,3,50,5,0,1,FALSE,0,0,0);frameskip(0.08);ai_forceface();};
void() wraith_magic7	=[	$magic7,	wraith_magic8		] {frameskip(0.08);ai_forceface();};
void() wraith_magic8	=[	$magic8,	wraith_magic9		] {frameskip(0.08);ai_forceface();};
void() wraith_magic9	=[	$magic9,	wraith_magic10		] {frameskip(0.08);ai_forceface();};
void() wraith_magic10	=[	$magic10,	wraith_magic11		] {frameskip(0.08);ai_forceface();};
void() wraith_magic11	=[	$magic11,	wraith_magic12		] {frameskip(0.08);ai_forceface();};
void() wraith_magic12	=[	$magic12,	wraith_walk1		] {frameskip(0.08);ai_forceface();};

void() wraith_melee =
{
	local float r;

	r = random();

	self.alpha = 1;

	if (r < 0.25)
		wraith_smash1();
	else if (r < 0.50)
		wraith_strike1();
	else if (r < 0.75)
		wraith_cstrike1();
	else
		wraith_magic1();
};

void() wraith_pain1	=[	$pain1,	wraith_pain2		] {};
void() wraith_pain2	=[	$pain2,	wraith_pain3		] {};
void() wraith_pain3	=[	$pain3,	wraith_pain4		] {};
void() wraith_pain4	=[	$pain4,	wraith_pain5		] {};
void() wraith_pain5	=[	$pain5,	wraith_pain6		] {};
void() wraith_pain6	=[	$pain6,	wraith_walk1		] {};

void() wraith_pain =
{
	if (self.damage_type == 2) // Hit by fire
	{
		local entity temp;

		temp = spawn ();
		temp.movetype = MOVETYPE_NOCLIP;
		temp.solid = SOLID_NOT;
		temp.classname = "3dsprite";

		temp.alpha = 0.5;
		temp.frame = 1;

		temp.effects = EF_ADDITIVE;
		temp.alpha = 0.5;
		temp.scale = 1.5;
		temp.angles_y = 90; // face screen
		temp.think = fireweakness_firefx_think;
		temp.nextthink = time + 0.1;

		setmodel (temp, "progs/fire_fx.mdl");
		setsize (temp, '0 0 0', '0 0 0');	
		setorigin (temp, self.origin + v_up * 16);
		spawn_color_glow(5, 3, 0, 100, temp);
	}
	self.alpha = 1;

	if (self.health < self.max_health / 2 && self.pain_finished < time || self.enemy.perfectguard_buff > time)
	{
		self.pain_finished = time + 0.3;
		if (random() < 0.5 && self.enemy.perfectguard_buff < time)
			return;

		wraith_pain1();
	}

	monster_pain(self.enemy);

	// Back away on hits
	if (self.angles_y == 0)
		self.velocity_x = -75;
	else
		self.velocity_x = 75;
};

void() wraith_death1	=[	$death1,	wraith_death2		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death2	=[	$death2,	wraith_death3		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death3	=[	$death3,	wraith_death4		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death4	=[	$death4,	wraith_death5		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death5	=[	$death5,	wraith_death6		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death6	=[	$death6,	wraith_death7		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death7	=[	$death7,	wraith_death8		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death8	=[	$death8,	wraith_death9		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death9	=[	$death9,	wraith_death10		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death10	=[	$death10,	wraith_death11		] {monster_death();self.alpha = self.alpha - 0.1;};
void() wraith_death11	=[	$death11,	wraith_death12		] {monster_death();};
void() wraith_death12	=[	$death12,	wraith_death12		] 
{
	monster_death();
	remove(self);
	return;
};

void() WraithSwordTouch =
{
	if (checkground(self) && !self.cnt)
	{
		sound (self, CHAN_BODY, "player/wallgrab.wav", 1, ATTN_NORM);
		self.cnt = TRUE;
	}
};

void() ThrowWraithSword =
{
	local entity esword;

	esword = spawn();
	esword.owner = self;
	esword.movetype = MOVETYPE_TOSS;
	esword.solid = SOLID_TRIGGER;

	esword.angles_y = random() * 360;
	makevectors (esword.angles);
	esword.velocity = v_forward * 100;
	esword.velocity_z = 250;
	esword.cnt = FALSE;
	esword.touch = WraithSwordTouch;

	if (esword.flags & FL_ONGROUND)
		esword.flags = esword.flags - FL_ONGROUND;

	esword.avelocity = crandom() * '0 600 0';
	setmodel (esword, "progs/wr_sword.mdl");
	setsize (esword, '-16 -16 0', '16 16 56'); 
	setorigin (esword, self.origin);
};

void() wraith_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  		  // otherwise player can keep knocking corpse for EXP
		sound (self, CHAN_VOICE, "wraith/death.wav", 1, ATTN_NORM);
		ThrowWraithSword();
		self.alpha = 1;
		wraith_death1();
		self.velocity = '0 0 0';
		GiveExperience(self.experience);
		self.gaveexp = TRUE;
		spawn_ghost(); // become a ghost! :O
	}
};

/*QUAKED monster_wraith (1 0 0) (-32 -32 -24) (32 32 64)
Flying noclip monster
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
void() monster_wraith =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/wraith.mdl");
	precache_model ("progs/wr_sword.mdl");

	precache_sound ("ghost/taunt.wav");
	precache_sound ("wraith/idle1.wav");
	precache_sound ("wraith/idle2.wav");
	precache_sound ("wraith/death.wav");
	precache_sound ("ghost/pain.wav");
	precache_sound ("ghost/death.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NOCLIP;
	setmodel (self, "progs/wraith.mdl");
	if (!self.health)
	{
		if (difficulty < 2)
			self.health = self.max_health = 175; // regular health
		else
			self.health = self.max_health = 263; // hard health (50% tougher)
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "wraith";
	self.displayname = "Wraith";
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.experience = 100;
	self.maxgold = 360;

	self.effects = EF_NODEPTHTEST;
	self.alpha = 0.2;
	self.th_stand = wraith_stand1;
	self.th_walk = wraith_walk1;
	self.th_pain = wraith_pain;
	self.th_die = wraith_die;
	self.th_melee = wraith_melee;
	self.noblood = TRUE;

	enemy_start();
};