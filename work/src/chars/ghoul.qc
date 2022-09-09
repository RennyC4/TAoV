/*
+--------+
|Ghoul   |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Ghouls raise up out of the ground usually, melee fighters                  |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/
   
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12
$frame die1 die2 die3 die4 die5 die6 die7 die8
$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10 rise11 rise12 rise13 rise14 rise15 rise16
$frame hit1 hit2 hit3 hit4 hit5 hit6 hit7 hit8 hit9 hit10 hit11 hit12 hit13 hit14 hit15 hit16 hit17 hit18 hit19
$frame hit20 hit21 hit22 hit23 hit24 hit25 hit26 hit27 hit28 hit29 hit30 hit31 hit32 hit33 hit34 hit35

void() ghoul_stand1	=[	$stand1,	ghoul_stand2	] {ai_stand();monster_removeslide();};
void() ghoul_stand2	=[	$stand2,	ghoul_stand3	] {ai_stand();monster_removeslide();};
void() ghoul_stand3	=[	$stand3,	ghoul_stand4	] {ai_stand();monster_removeslide();};
void() ghoul_stand4	=[	$stand4,	ghoul_stand5	] {ai_stand();monster_removeslide();};
void() ghoul_stand5	=[	$stand5,	ghoul_stand6	] {ai_stand();monster_removeslide();};
void() ghoul_stand6	=[	$stand6,	ghoul_stand7	] {ai_stand();monster_removeslide();};
void() ghoul_stand7	=[	$stand7,	ghoul_stand1	] {ai_stand();monster_removeslide();};

void() ghoul_rise2;
void() ghoul_rise1	=[	$rise1,	ghoul_rise1	] 
{
	self.takedamage = DAMAGE_NO;
	ai_stand();
	if (self.enemy)
		ghoul_rise2();
};
void() ghoul_rise2	=[	$rise2,	ghoul_rise3	] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise3	=[	$rise3,	ghoul_rise4	] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise4	=[	$rise4,	ghoul_rise5	] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise5	=[	$rise5,	ghoul_rise6	] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise6	=[	$rise6,	ghoul_rise7	] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise7	=[	$rise7,	ghoul_rise8	] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise8	=[	$rise8,	ghoul_rise9	] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise9	=[	$rise9,	ghoul_rise10 ] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise10	=[	$rise10,	ghoul_rise11 ] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise11	=[	$rise11,	ghoul_rise12 ] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise12	=[	$rise12,	ghoul_rise13 ] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise13	=[	$rise13,	ghoul_rise14 ] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise14	=[	$rise14,	ghoul_rise15 ] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise15	=[	$rise15,	ghoul_rise16 ] {particle(self.origin - v_up*16, '0 0 0', 18, 25);};
void() ghoul_rise16	=[	$rise16,	ghoul_stand1 ] {self.th_stand = ghoul_stand1;particle(self.origin - v_up*16, '0 0 0', 18, 25);};

void() ghoul_walk1	=[	$walk1,	ghoul_walk2	] {self.takedamage = DAMAGE_AIM;ai_walk(2);monster_removeslide();};
void() ghoul_walk2	=[	$walk2,	ghoul_walk3	] {ai_walk(2);monster_removeslide();};
void() ghoul_walk3	=[	$walk3,	ghoul_walk4	] {ai_walk(2);monster_removeslide();};
void() ghoul_walk4	=[	$walk4,	ghoul_walk5	] {ai_walk(2);monster_removeslide();};
void() ghoul_walk5	=[	$walk5,	ghoul_walk6	] {ai_walk(2);monster_removeslide();};
void() ghoul_walk6	=[	$walk6,	ghoul_walk7	] {ai_walk(2);monster_removeslide();};
void() ghoul_walk7	=[	$walk7,	ghoul_walk8	] {ai_walk(2);monster_removeslide();};
void() ghoul_walk8	=[	$walk8,	ghoul_walk9	] {ai_walk(2);monster_removeslide();};
void() ghoul_walk9	=[	$walk9,	ghoul_walk10] {ai_walk(5);monster_removeslide();};
void() ghoul_walk10	=[	$walk10,	ghoul_walk11] {ai_walk(8);monster_removeslide();};
void() ghoul_walk11	=[	$walk11,	ghoul_walk12] {ai_walk(2);monster_removeslide();};
void() ghoul_walk12	=[	$walk12,	ghoul_walk1	] {ai_walk(2);monster_removeslide();};

void() ghoul_hit1	=[	$hit1,	ghoul_hit2	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit2	=[	$hit2,	ghoul_hit3	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit3	=[	$hit3,	ghoul_hit4	] 
{
	frameskip(0.05);
	self.status_poison_finished = time + 8;
	FireMelee(4,5,0,25,1,0,0,FALSE,0,0.5);
	ai_forward(2);
	monster_removeslide();
};
void() ghoul_hit4	=[	$hit4,	ghoul_hit5	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit5	=[	$hit5,	ghoul_hit6	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit6	=[	$hit6,	ghoul_hit7	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit7	=[	$hit7,	ghoul_hit8	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit8	=[	$hit8,	ghoul_hit9	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit9	=[	$hit9,	ghoul_hit10	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit10	=[	$hit10,	ghoul_hit11	] 
{
	local float check;
	check = checkground(self);
	if (!check)
	{
		self.think = self.th_run;
		frameskip(0.1);
		return;
	}

	frameskip(0.05);
	ai_forward(2);
	monster_removeslide();
};
void() ghoul_hit11	=[	$hit11,	ghoul_hit12	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit12	=[	$hit12,	ghoul_hit13	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit13	=[	$hit13,	ghoul_hit14	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit14	=[	$hit14,	ghoul_hit15	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit15	=[	$hit15,	ghoul_hit16	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit16	=[	$hit16,	ghoul_hit17	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit17	=[	$hit17,	ghoul_hit18	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit18	=[	$hit18,	ghoul_hit19	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit19	=[	$hit19,	ghoul_hit20	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit20	=[	$hit20,	ghoul_hit21	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit21	=[	$hit21,	ghoul_hit22	] 
{
	frameskip(0.05);
	self.status_poison_finished = time + 8;
	FireMelee(4,5,0,25,1,0,0,FALSE,0,0.5);
	ai_forward(2);
	monster_removeslide();
};
void() ghoul_hit22	=[	$hit22,	ghoul_hit23	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit23	=[	$hit23,	ghoul_hit24	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit24	=[	$hit24,	ghoul_hit25	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit25	=[	$hit25,	ghoul_hit26	] 
{
	local float check;
	check = checkground(self);
	if (!check)
	{
		self.think = self.th_run;
		frameskip(0.1);
		return;
	}

	frameskip(0.05);
	ai_forward(2);
	monster_removeslide();
};
void() ghoul_hit26	=[	$hit26,	ghoul_hit27	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit27	=[	$hit27,	ghoul_hit28	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit28	=[	$hit28,	ghoul_hit29	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit29	=[	$hit29,	ghoul_hit30	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit30	=[	$hit30,	ghoul_hit31	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit31	=[	$hit31,	ghoul_hit32	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit32	=[	$hit32,	ghoul_hit33	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit33	=[	$hit33,	ghoul_hit34	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit34	=[	$hit34,	ghoul_hit35	] {frameskip(0.05);ai_forward(2);monster_removeslide();};
void() ghoul_hit35	=[	$hit35,	ghoul_walk1	] {frameskip(0.05);ai_forward(2);monster_removeslide();};

void() ghoul_melee =
{
	local float c;
	c = checkground(self);

	if (c)
		ghoul_hit1();
};

void() ghoul_die1	=[	$die1,	ghoul_die2	] {monster_death();walkmove((self.angles_y+180), 7);monster_removeslide();};
void() ghoul_die2	=[	$die2,	ghoul_die3	] {monster_death();walkmove((self.angles_y+180), 7);monster_removeslide();};
void() ghoul_die3	=[	$die3,	ghoul_die4	] {monster_death();walkmove((self.angles_y+180), 7);monster_removeslide();};
void() ghoul_die4	=[	$die4,	ghoul_die5	] {monster_death();walkmove((self.angles_y+180), 7);monster_removeslide();};
void() ghoul_die5	=[	$die5,	ghoul_die6	] {monster_death();walkmove((self.angles_y+180), 7);monster_removeslide();};
void() ghoul_die6	=[	$die6,	ghoul_die7	] {monster_death();walkmove((self.angles_y+180), 7);monster_removeslide();};
void() ghoul_die7	=[	$die7,	ghoul_die8	] {monster_death();walkmove((self.angles_y+180), 7);monster_removeslide();};
void() ghoul_die8	=[	$die8,	ghoul_die8	] {monster_death();};

void()	ghoul_grabbed1	=[	$stand1,		ghoul_grabbed2	] {self.grab_finished = time + 1;monster_removeslide();};
void()	ghoul_grabbed2	=[	$stand1,		ghoul_grabbed2	] 
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

void() ghoul_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  // otherwise player can keep knocking corpse for EXP
		sound (self, CHAN_VOICE, "ghoul/death.wav", 1, ATTN_NORM);
		GiveExperience(self.experience);
		self.movetype = MOVETYPE_TOSS;
		self.gaveexp = TRUE;
	}
	if (self.knockback != 2 && self.knockback != 3)
		self.velocity = '0 0 0';
	ghoul_die1();
};

void() ghoul_pain =
{
	sound (self, CHAN_VOICE, "ghoul/pain.wav", 1, ATTN_NORM);
	monster_pain(self.enemy);
	monster_removeslide();
};

/*QUAKED monster_ghoul (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_ghoul =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/ghoul.mdl");
	precache_sound ("ghoul/pain.wav");
	precache_sound ("ghoul/death.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/ghoul.mdl");

	if (difficulty < 2)
		self.health = 115; // regular health
	else
		self.health = 173; // hard health (50% tougher)

	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "ghoul";
	self.displayname = "Ghoul";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.experience = 43;
	self.maxgold = 85;

	self.th_stand = ghoul_rise1;
	self.th_run = ghoul_walk1;
	self.th_pain = ghoul_pain;
	self.th_die = ghoul_die;
	self.th_melee = ghoul_melee;
	self.th_missile = ghoul_melee;
	self.th_grab = ghoul_grabbed1;

	enemy_start();
};