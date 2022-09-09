/*
+------------+
|Zombie Boss |
+------------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| zombie boss, tougher larger version of the regular zombie                  |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10 stand11 stand12 stand13 stand14 stand15
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame atta1 atta2 atta3 atta4 atta5
$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7
$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8
$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10 painb11 painb12 painb13
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12

void()	zombie_boss_stand1	=[	$stand1,	zombie_boss_stand2	] {ai_stand();};
void()	zombie_boss_stand2	=[	$stand2,	zombie_boss_stand3	]
{
	if (random() < 0.01)
	{
		if (random() < 0.5)
			sound (self, CHAN_VOICE, "zombie/idle1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "zombie/idle2.wav", 1, ATTN_NORM);
	}
	ai_stand();
};
void()	zombie_boss_stand3	=[	$stand3,	zombie_boss_stand4	] {ai_stand();};
void()	zombie_boss_stand4	=[	$stand4,	zombie_boss_stand5	] {ai_stand();};
void()	zombie_boss_stand5	=[	$stand5,	zombie_boss_stand6	] {ai_stand();};
void()	zombie_boss_stand6	=[	$stand6,	zombie_boss_stand7	] {ai_stand();};
void()	zombie_boss_stand7	=[	$stand7,	zombie_boss_stand8	] {ai_stand();};
void()	zombie_boss_stand8	=[	$stand8,	zombie_boss_stand9	] {ai_stand();};
void()	zombie_boss_stand9	=[	$stand9,	zombie_boss_stand10	] {ai_stand();};
void()	zombie_boss_stand10	=[	$stand10,	zombie_boss_stand11	] {ai_stand();};
void()	zombie_boss_stand11	=[	$stand11,	zombie_boss_stand12	] {ai_stand();};
void()	zombie_boss_stand12	=[	$stand12,	zombie_boss_stand13	] {ai_stand();};
void()	zombie_boss_stand13	=[	$stand13,	zombie_boss_stand14	] {ai_stand();};
void()	zombie_boss_stand14	=[	$stand14,	zombie_boss_stand15	] {ai_stand();};
void()	zombie_boss_stand15	=[	$stand15,	zombie_boss_stand1	] {ai_stand();};

void()	zombie_boss_run1	=[	$walk1,		zombie_boss_run2	] {ai_walk(5);};
void()	zombie_boss_run2	=[	$walk2,		zombie_boss_run3	] {ai_walk(5);};
void()	zombie_boss_run3	=[	$walk3,		zombie_boss_run4	] {ai_walk(5);};
void()	zombie_boss_run4	=[	$walk4,		zombie_boss_run5	] {ai_walk(5);};
void()	zombie_boss_run5	=[	$walk5,		zombie_boss_run6	] {ai_walk(5);};
void()	zombie_boss_run6	=[	$walk6,		zombie_boss_run7	] {ai_walk(0);};
void()	zombie_boss_run7	=[	$walk7,		zombie_boss_run8	] {ai_walk(0);};
void()	zombie_boss_run8	=[	$walk8,		zombie_boss_run9	] {ai_walk(0);};
void()	zombie_boss_run9	=[	$walk9,		zombie_boss_run10	] {ai_walk(0);};
void()	zombie_boss_run10	=[	$walk10,	zombie_boss_run11	] {ai_walk(0);};
void()	zombie_boss_run11	=[	$walk11,	zombie_boss_run12	] {ai_walk(5);};
void()	zombie_boss_run12	=[	$walk12,	zombie_boss_run13	] {ai_walk(5);};
void()	zombie_boss_run13	=[	$walk13,	zombie_boss_run14	] {ai_walk(0);};
void()	zombie_boss_run14	=[	$walk14,	zombie_boss_run15	] {ai_walk(0);};
void()	zombie_boss_run15	=[	$walk15,	zombie_boss_run16	] {ai_walk(0);};
void()	zombie_boss_run16	=[	$walk16,	zombie_boss_run17	] {ai_walk(0);};
void()	zombie_boss_run17	=[	$walk17,	zombie_boss_run18	] {ai_walk(0);};
void()	zombie_boss_run18	=[	$walk18,	zombie_boss_run19	] {ai_walk(0);};
void()	zombie_boss_run19	=[	$walk19,	zombie_boss_run1	] {ai_walk(0);};

void()  zombie_boss_atta1	=[	$atta1,		zombie_boss_atta2	] {};
void()  zombie_boss_atta2	=[	$atta2,		zombie_boss_atta3	] {};
void()  zombie_boss_atta3	=[	$atta3,		zombie_boss_atta4	] {};
void()  zombie_boss_atta4	=[	$atta4,		zombie_boss_atta5	] {};
void()  zombie_boss_atta5	=[	$atta5,		zombie_boss_run1	] {Darkball(16);}; //fire

void()  zombie_boss_attb1	=[	$attb1,		zombie_boss_attb2	] {};
void()  zombie_boss_attb2	=[	$attb2,		zombie_boss_attb3	] {};
void()  zombie_boss_attb3	=[	$attb3,		zombie_boss_attb4	] {};
void()  zombie_boss_attb4	=[	$attb4,		zombie_boss_attb5	] {};
void()  zombie_boss_attb5	=[	$attb5,		zombie_boss_attb6	] {};
void()  zombie_boss_attb6	=[	$attb6,		zombie_boss_attb7	] {};
void()  zombie_boss_attb7	=[	$attb7,		zombie_boss_run1	] {Darkball(16);}; // fire

void()  zombie_boss_attc1	=[	$attc1,		zombie_boss_attc2	] {};
void()  zombie_boss_attc2	=[	$attc2,		zombie_boss_attc3	] {};
void()  zombie_boss_attc3	=[	$attc3,		zombie_boss_attc4	] {};
void()  zombie_boss_attc4	=[	$attc4,		zombie_boss_attc5	] {};
void()  zombie_boss_attc5	=[	$attc5,		zombie_boss_attc6	] {};
void()  zombie_boss_attc6	=[	$attc6,		zombie_boss_attc7	] {};
void()  zombie_boss_attc7	=[	$attc7,		zombie_boss_attc8	] {Darkball(16);}; // fire
void()  zombie_boss_attc8	=[	$attc8,		zombie_boss_run1	] {};

void() zombie_boss_missile =
{
	if (random() < 0.33)
		zombie_boss_atta1();
	else if (random() < 0.66)
		zombie_boss_attb1();
	else
		zombie_boss_attc1();
};

void()	zombie_boss_paina1	=[	$paina1,	zombie_boss_paina2	] 
{
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "zombie/pain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "zombie/pain2.wav", 1, ATTN_NORM);
};
void()	zombie_boss_paina2	=[	$paina2,	zombie_boss_paina3	] {monster_removeslide();};
void()	zombie_boss_paina3	=[	$paina3,	zombie_boss_paina4	] {monster_removeslide();};
void()	zombie_boss_paina4	=[	$paina4,	zombie_boss_paina5	] {monster_removeslide();};
void()	zombie_boss_paina5	=[	$paina5,	zombie_boss_paina6	] {monster_removeslide();};
void()	zombie_boss_paina6	=[	$paina6,	zombie_boss_paina7	] {monster_removeslide();};
void()	zombie_boss_paina7	=[	$paina7,	zombie_boss_paina8	] {monster_removeslide();};
void()	zombie_boss_paina8	=[	$paina8,	zombie_boss_paina9	] {monster_removeslide();};
void()	zombie_boss_paina9	=[	$paina9,	zombie_boss_run1	] {monster_removeslide();};

void()	zombie_boss_painb1	=[	$painb1,	zombie_boss_painb2	] 
{
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "zombie/pain3.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "zombie/pain4.wav", 1, ATTN_NORM);
};
void()	zombie_boss_painb2	=[	$painb2,	zombie_boss_painb3	] {monster_removeslide();};
void()	zombie_boss_painb3	=[	$painb3,	zombie_boss_painb4	] {monster_removeslide();};
void()	zombie_boss_painb4	=[	$painb4,	zombie_boss_painb5	] {monster_removeslide();};
void()	zombie_boss_painb5	=[	$painb5,	zombie_boss_painb6	] {monster_removeslide();};
void()	zombie_boss_painb6	=[	$painb6,	zombie_boss_painb7	] {monster_removeslide();};
void()	zombie_boss_painb7	=[	$painb7,	zombie_boss_painb8	] {monster_removeslide();};
void()	zombie_boss_painb8	=[	$painb8,	zombie_boss_painb9	] {monster_removeslide();};
void()	zombie_boss_painb9	=[	$painb9,	zombie_boss_painb10	] {monster_removeslide();};
void()	zombie_boss_painb10	=[	$painb10,	zombie_boss_painb11	] {monster_removeslide();};
void()	zombie_boss_painb11	=[	$painb11,	zombie_boss_painb12	] {monster_removeslide();};
void()	zombie_boss_painb12	=[	$painb12,	zombie_boss_painb13	] {monster_removeslide();};
void()	zombie_boss_painb13	=[	$painb13,	zombie_boss_run1	] {monster_removeslide();};

void() zombie_boss_pain =
{
	if (random() < 0.25)
	{
		if (random() < 0.5)
			zombie_boss_paina1();
		else
			zombie_boss_painb1();
	}
	monster_pain(self.enemy);
};

void()	zombie_boss_die1	=[	$death1,	zombie_boss_die2	] {monster_death();};
void()	zombie_boss_die2	=[	$death2,	zombie_boss_die3	] {monster_death();};
void()	zombie_boss_die3	=[	$death3,	zombie_boss_die4	] {monster_death();};
void()	zombie_boss_die4	=[	$death4,	zombie_boss_die5	] {monster_death();};
void()	zombie_boss_die5	=[	$death5,	zombie_boss_die6	] {monster_death();};
void()	zombie_boss_die6	=[	$death6,	zombie_boss_die7	] {monster_death();};
void()	zombie_boss_die7	=[	$death7,	zombie_boss_die8	] {monster_death();};
void()	zombie_boss_die8	=[	$death8,	zombie_boss_die9	] {monster_death();};
void()	zombie_boss_die9	=[	$death9,	zombie_boss_die10	] {monster_death();};
void()	zombie_boss_die10	=[	$death10,	zombie_boss_die11	] {monster_death();};
void()	zombie_boss_die11	=[	$death11,	zombie_boss_die12	] {monster_death();};
void()	zombie_boss_die12	=[	$death12,	zombie_boss_die12	] 
{
	if (self.flags & FL_ONGROUND)
	{
		sound (self, CHAN_BODY, "zombie/splat.wav", 1, ATTN_NORM);
		ThrowGib("progs/gib2.mdl"); // chest
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		remove(self);
		return;
	}
	monster_death();
};

void() zombie_boss_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{			  			  // otherwise player can keep knocking corpse for EXP
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		self.gaveexp = TRUE;
		GiveExperience(self.experience);
		sound (self, CHAN_VOICE, "zombie/death.wav", 1, ATTN_NORM);
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	zombie_boss_die1();
};

void()	zombie_boss_grabbed1	=[	$painb2,		zombie_boss_grabbed2	] {self.grab_finished = time + 1;};
void()	zombie_boss_grabbed2	=[	$painb2,		zombie_boss_grabbed2	] 
{
	if (!self.izunatarg)
	{
		if (self.grab_finished < time || self.grabbed == FALSE)
		{
			self.th_run();
			return;
		}
	}
};

/*QUAKED monster_zombie_boss (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_zombie_boss =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/zombieb.mdl");
	precache_model ("progs/darkball.mdl");

	precache_sound ("spells/dbfire.wav");
	precache_sound ("spells/dbhit.wav");

	precache_sound ("zombie/idle1.wav");
	precache_sound ("zombie/idle2.wav");
	precache_sound ("zombie/pain1.wav");
	precache_sound ("zombie/pain2.wav");
	precache_sound ("zombie/pain3.wav");
	precache_sound ("zombie/pain4.wav");
	precache_sound ("zombie/splat.wav");
	precache_sound ("zombie/death.wav");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/zombieb.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (difficulty < 2)
		self.health = self.max_health = 225; // regular health
	else
		self.health = self.max_health = 383; // hard health (50% tougher)
	self.state = self.max_health / 3; // Hold 1/3 health value for testing in damage.qc
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "zombieboss";
	self.displayname = "Greater Zombie";
	self.experience = 56;
	self.maxgold = 175;

	self.th_stand = zombie_boss_stand1;
	self.th_run = zombie_boss_run1;
	self.th_pain = zombie_boss_pain;
	self.th_die = zombie_boss_die;
	self.th_grab = zombie_boss_grabbed1;
	
	self.th_melee = zombie_boss_missile;
	self.th_magic = zombie_boss_missile;
	
	//spawn_shadow();
	enemy_start();
};
