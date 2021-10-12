/*
+--------+
|Gaunt   |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Magic using creature, primarily uses fire magic.                           |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10 stand11 stand12
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame firebolt1 firebolt2 firebolt3 firebolt4 firebolt5 firebolt6 firebolt7 firebolt8 firebolt9 firebolt10
$frame fireball1 fireball2 fireball3 fireball4 fireball5 fireball6 fireball7 fireball8 fireball9 fireball10
$frame fireball11 fireball12 fireball13 fireball14 fireball15
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame death1 death2 death3 death4 death5
$frame hup1 hup2 hup3 hup4 hup5 hup6 hup7 hup8
$frame finger1 finger2 finger3
$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9 shoot10 shoot11 shoot12
$frame beam1 beam2 beam3
$frame kneel1 kneel2 kneel3 kneel4 kneel5 kneel6 kneel7 kneel8
$frame pray1
$frame run1 run2 run3 run4 run5 run6

void() gaunt_talk =
{
	local float rs;

	rs = rint ((random() * 13) + 1);
	if (rs == 1)
		self.noise = "gaunt/talk1.wav";
	if (rs == 2)
		self.noise = "gaunt/talk2.wav";
	if (rs == 3)
		self.noise = "gaunt/talk3.wav";
	if (rs == 4)
		self.noise = "gaunt/talk4.wav";
	if (rs == 5)
		self.noise = "gaunt/talk5.wav";
	if (rs == 6)
		self.noise = "gaunt/talk6.wav";
	if (rs == 7)
		self.noise = "gaunt/talk7.wav";
	if (rs == 8)
		self.noise = "gaunt/talk8.wav";
	if (rs == 9)
		self.noise = "gaunt/talk9.wav";
	if (rs == 10)
		self.noise = "gaunt/talk10.wav";
	if (rs == 11)
		self.noise = "gaunt/talk11.wav";
	if (rs == 12)
		self.noise = "gaunt/talk12.wav";
	if (rs == 13)
		self.noise = "gaunt/talk13.wav";
	if (rs == 14)
		self.noise = "gaunt/talk14.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
};

void() gaunt_scream =
{
	local float rs;

	rs = rint ((random() * 7) + 1);
	if (rs == 1)
		self.noise = "gaunt/scream1.wav";
	if (rs == 2)
		self.noise = "gaunt/scream2.wav";
	if (rs == 3)
		self.noise = "gaunt/scream3.wav";
	if (rs == 4)
		self.noise = "gaunt/scream4.wav";
	if (rs == 5)
		self.noise = "gaunt/scream5.wav";
	if (rs == 6)
		self.noise = "gaunt/scream6.wav";
	if (rs == 7)
		self.noise = "gaunt/scream7.wav";
	if (rs == 8)
		self.noise = "gaunt/scream8.wav";
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
};


void() gaunt_stand1	=[	$stand1,	gaunt_stand2		] {ai_stand();};
void() gaunt_stand2	=[	$stand2,	gaunt_stand3		] {ai_stand();};
void() gaunt_stand3	=[	$stand3,	gaunt_stand4		] {ai_stand();};
void() gaunt_stand4	=[	$stand4,	gaunt_stand5		] {ai_stand();};
void() gaunt_stand5	=[	$stand5,	gaunt_stand6		] {ai_stand();};
void() gaunt_stand6	=[	$stand6,	gaunt_stand7		] {ai_stand();};
void() gaunt_stand7	=[	$stand7,	gaunt_stand8		] {ai_stand();};
void() gaunt_stand8	=[	$stand8,	gaunt_stand9		] {ai_stand();};
void() gaunt_stand9	=[	$stand9,	gaunt_stand10		] {ai_stand();};
void() gaunt_stand10	=[	$stand10,	gaunt_stand11		] {ai_stand();};
void() gaunt_stand11	=[	$stand11,	gaunt_stand12		] {ai_stand();};
void() gaunt_stand12	=[	$stand12,	gaunt_stand1		] {ai_stand();};

void() gaunt_walk1 	=[	$walk1,	gaunt_walk2		] {ai_walk(3);};
void() gaunt_walk2 	=[	$walk2,	gaunt_walk3		] {ai_walk(3);};
void() gaunt_walk3 	=[	$walk3,	gaunt_walk4		] {ai_walk(3);};
void() gaunt_walk4 	=[	$walk4,	gaunt_walk5		] {ai_walk(3);};
void() gaunt_walk5 	=[	$walk5,	gaunt_walk6		] {ai_walk(3);};
void() gaunt_walk6 	=[	$walk6,	gaunt_walk7		] {ai_walk(3);};
void() gaunt_walk7 	=[	$walk7,	gaunt_walk8		] {ai_walk(3);};
void() gaunt_walk8 	=[	$walk8,	gaunt_walk9		] {ai_walk(3);};
void() gaunt_walk9 	=[	$walk9,	gaunt_walk10	] {ai_walk(3);};
void() gaunt_walk10 	=[	$walk10,	gaunt_walk1 	] {ai_walk(3);};

void() gaunt_run1 	=[	$run1,	gaunt_run2	] {ai_walk(13);};
void() gaunt_run2 	=[	$run2,	gaunt_run3	] {ai_walk(13);};
void() gaunt_run3 	=[	$run3,	gaunt_run4	] {ai_walk(13);};
void() gaunt_run4 	=[	$run4,	gaunt_run5	] {ai_walk(13);};
void() gaunt_run5 	=[	$run5,	gaunt_run6	] {ai_walk(13);};
void() gaunt_run6 	=[	$run6,	gaunt_run1	] {ai_walk(13);};

void() gaunt_pain1 	=[	$pain1,	gaunt_pain2	] {monster_removeslide();};
void() gaunt_pain2 	=[	$pain2,	gaunt_pain3	] {monster_removeslide();};
void() gaunt_pain3 	=[	$pain3,	gaunt_pain4	] {monster_removeslide();};
void() gaunt_pain4 	=[	$pain4,	gaunt_pain5	] {monster_removeslide();};
void() gaunt_pain5 	=[	$pain5,	gaunt_pain6	] {monster_removeslide();};
void() gaunt_pain6 	=[	$pain6,	gaunt_run1	] {monster_removeslide();};

// gaunt raises hand
void() gaunt_finger1 	=[	$hup1,	gaunt_finger2	] {gaunt_talk();frameskip(0.02);monster_removeslide();};
void() gaunt_finger2 	=[	$hup2,	gaunt_finger3	] {frameskip(0.02);monster_removeslide();};
void() gaunt_finger3 	=[	$hup3,	gaunt_finger4	] {frameskip(0.02);monster_removeslide();};
void() gaunt_finger4 	=[	$hup4,	gaunt_finger5	] {frameskip(0.02);monster_removeslide();};
void() gaunt_finger5 	=[	$hup5,	gaunt_finger6	] {frameskip(0.02);monster_removeslide();};
void() gaunt_finger6 	=[	$hup6,	gaunt_finger7	] {frameskip(0.02);monster_removeslide();};
void() gaunt_finger7 	=[	$hup7,	gaunt_finger8	] {frameskip(0.02);monster_removeslide();};
void() gaunt_finger8 	=[	$hup8,	gaunt_finger9	] {frameskip(0.02);monster_removeslide();};

void() gaunt_finger9 	=[	$finger1,	gaunt_finger10	] {monster_removeslide();};
void() gaunt_finger10 	=[	$finger2,	gaunt_finger11	] {monster_removeslide();};
void() gaunt_finger11	=[	$finger3,	gaunt_finger12	] {FireMelee(0,15,3,50,99,0,0,FALSE,0,0);monster_removeslide();};

void() gaunt_finger12	=[	$hup8,	gaunt_finger13	] {monster_removeslide();};
void() gaunt_finger13	=[	$hup7,	gaunt_finger14	] {monster_removeslide();};
void() gaunt_finger14	=[	$hup6,	gaunt_finger15	] {monster_removeslide();};
void() gaunt_finger15	=[	$hup5,	gaunt_finger16	] {monster_removeslide();};
void() gaunt_finger16	=[	$hup4,	gaunt_finger17	] {monster_removeslide();};
void() gaunt_finger17	=[	$hup3,	gaunt_finger18	] {monster_removeslide();};
void() gaunt_finger18	=[	$hup2,	gaunt_finger19	] {monster_removeslide();};
void() gaunt_finger19	=[	$hup1,	gaunt_run1  	] {monster_removeslide();};

void() gaunt_pain =
{
	if (self.beams_shot != 0)
		self.beams_shot = 0;

	sound (self, CHAN_VOICE, "gaunt/pain.wav", 1, ATTN_NORM);
	gaunt_pain1();
	monster_pain(self.enemy);
};

void() gaunt_die1		=[          0,		gaunt_die2] {monster_death();};
void() gaunt_die2		=[          1,		gaunt_die3] {monster_death();};
void() gaunt_die3		=[          2,		gaunt_die4] {monster_death();};
void() gaunt_die4		=[          3,		gaunt_die5] {monster_death();};
void() gaunt_die5		=[          4,		gaunt_die5] 
{
	if (self.flags & FL_ONGROUND)
	{
		sound (self, CHAN_BODY, "misc/guts.wav", 1, ATTN_NORM);
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

void() gaunt_die =
{
	if (self.beams_shot != 0)
		self.beams_shot = 0;

	setmodel (self, "progs/b_gaunt.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);

	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  // otherwise player can keep knocking corpse for EXP
		GiveExperience(self.experience);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '100 100 0';
		self.gaveexp = TRUE;
		ThrowHead("progs/h_gaunt.mdl", self.origin + v_up * 24, self);
		sound (self, CHAN_VOICE, "gaunt/death.wav", 1, ATTN_NORM);
	}
	if (self.knockback != 2 && self.knockback != 3)
		self.velocity = '0 0 0';
	gaunt_die1();
};

void()	gaunt_grabbed1	=[	$pain3,		gaunt_grabbed2	] {self.grab_finished = time + 1;};
void()	gaunt_grabbed2	=[	$pain3,		gaunt_grabbed2	] 
{
	if (self.grab_finished < time || self.grabbed == FALSE)
	{
		self.th_run();
		return;
	}		
};

void()	gaunt_firebolt1		=[	$firebolt1,		gaunt_firebolt2	 ] {spawn_magicfog();monster_removeslide();};
void()	gaunt_firebolt2		=[	$firebolt2,		gaunt_firebolt3	 ] {monster_removeslide();};
void()	gaunt_firebolt3		=[	$firebolt3,		gaunt_firebolt4	 ] {monster_removeslide();};
void()	gaunt_firebolt4		=[	$firebolt4,		gaunt_firebolt5	 ] {monster_removeslide();};
void()	gaunt_firebolt5		=[	$firebolt5,		gaunt_firebolt6	 ] {monster_removeslide();};
void()	gaunt_firebolt6		=[	$firebolt6,		gaunt_firebolt7	 ] {monster_removeslide();};
void()	gaunt_firebolt7		=[	$firebolt7,		gaunt_firebolt8	 ] {self.colormod = '3 2 1';Fireball(16,15);monster_removeslide();};
void()	gaunt_firebolt8		=[	$firebolt8,		gaunt_firebolt9	 ] {monster_removeslide();};
void()	gaunt_firebolt9		=[	$firebolt9,		gaunt_firebolt10 ] {monster_removeslide();};
void()	gaunt_firebolt10	=[	$firebolt10,		gaunt_run1	 ] {monster_removeslide();};

void()	gaunt_fireball1	=[	$fireball1,		gaunt_fireball2	] {spawn_magicfog();monster_removeslide();};
void()	gaunt_fireball2	=[	$fireball2,		gaunt_fireball3	] {monster_removeslide();};
void()	gaunt_fireball3	=[	$fireball3,		gaunt_fireball4	] {monster_removeslide();};
void()	gaunt_fireball4	=[	$fireball4,		gaunt_fireball5	] {monster_removeslide();};
void()	gaunt_fireball5	=[	$fireball5,		gaunt_fireball6	] {monster_removeslide();};
void()	gaunt_fireball6	=[	$fireball6,		gaunt_fireball7	] {monster_removeslide();};
void()	gaunt_fireball7	=[	$fireball7,		gaunt_fireball8	] {monster_removeslide();};
void()	gaunt_fireball8	=[	$fireball8,		gaunt_fireball9	] {monster_removeslide();};
void()	gaunt_fireball9	=[	$fireball9,		gaunt_fireball10	] {monster_removeslide();};
void()	gaunt_fireball10	=[	$fireball10,	gaunt_fireball11	] {monster_removeslide();};
void()	gaunt_fireball11	=[	$fireball11,	gaunt_fireball12	] {self.colormod = '3 2 1';Fireball(9,15);monster_removeslide();};
void()	gaunt_fireball12	=[	$fireball12,	gaunt_fireball13	] {monster_removeslide();};
void()	gaunt_fireball13	=[	$fireball13,	gaunt_fireball14	] {self.colormod = '3 2 1';Fireball(9,15);monster_removeslide();};
void()	gaunt_fireball14	=[	$fireball14,	gaunt_fireball15	] {monster_removeslide();};
void()	gaunt_fireball15	=[	$fireball15,	gaunt_run1  	] {self.colormod = '3 2 1';Fireball(9,15);monster_removeslide();};

void()	gaunt_firebeam1	=[	$shoot1,		gaunt_firebeam2	] 
{
	local entity effect;

	spawn_magicfog();
	effect = spawn();
	setmodel(effect, "progs/chrgebm.mdl");
	effect.movetype = MOVETYPE_NOCLIP;
	effect.solid = SOLID_NOT;
	effect.scale = effect.alpha = 1;
	effect.effects = EF_NODEPTHTEST;
	effect.owner = self;
	setorigin(effect, self.origin);
	effect.think = chargebeam_effect;
	effect.nextthink = time;
	sound (effect, CHAN_AUTO, "spells/charge.wav", 1, ATTN_NORM);
	monster_removeslide();
};
void()	gaunt_firebeam2	=[	$shoot2,		gaunt_firebeam3	] {monster_removeslide();};
void()	gaunt_firebeam3	=[	$shoot3,		gaunt_firebeam4	] {self.nextthink = time + 0.7;monster_removeslide();};
void()	gaunt_firebeam4	=[	$shoot4,		gaunt_firebeam5	] {monster_removeslide();};
void()	gaunt_firebeam5	=[	$shoot5,		gaunt_firebeam6	] {monster_removeslide();};
void()	gaunt_firebeam6	=[	$shoot6,		gaunt_firebeam7	] {monster_removeslide();};
void()	gaunt_firebeam7	=[	$shoot7,		gaunt_firebeam8	] {monster_removeslide();};
void()	gaunt_firebeam8	=[	$shoot8,		gaunt_firebeam9	] {monster_removeslide();};
void()	gaunt_firebeam9	=[	$shoot9,		gaunt_firebeam10	] {monster_removeslide();};
void()	gaunt_firebeam10	=[	$shoot10,		gaunt_firebeam11	] {monster_removeslide();};
void()	gaunt_firebeam11	=[	$shoot11,		gaunt_firebeam12	] {monster_removeslide();};
void()	gaunt_firebeam12	=[	$shoot12,		gaunt_firebeam13	] {monster_removeslide();};

void()	gaunt_firebeam13	=[	$beam1,		gaunt_firebeam14	] 
{
	monster_removeslide();
	if (self.beams_shot < 30)
	{
		self.colormod = '5 0 0';
		Firebeam(2, 12, 0);
		self.beams_shot = self.beams_shot + 1;
	}
	else
	{
		self.beams_shot = 0;
		gaunt_run1();
	}
	if (self.beams_shot <= 1)
		Firebeam_Muzzle();
};
void()	gaunt_firebeam14	=[	$beam2,		gaunt_firebeam15	] 
{
	monster_removeslide();
	if (self.beams_shot < 30)
	{
		self.colormod = '5 0 0';
		Firebeam(1, 12, 0);
		self.beams_shot = self.beams_shot + 1;
	}
	else
	{
		self.beams_shot = 0;gaunt_run1();
	}
};
void()	gaunt_firebeam15	=[	$beam3,		gaunt_firebeam13	] 
{
	monster_removeslide();
	if (self.beams_shot < 30)
	{
		self.colormod = '5 0 0';
		Firebeam (1,15, 0);
		self.beams_shot = self.beams_shot + 1;
	}
	else
	{
		self.beams_shot = 0;
		gaunt_run1();
	}
};


void()	gaunt_charge1	=[	$kneel1,		gaunt_charge2	] {spawn_magicfog();monster_removeslide();};
void()	gaunt_charge2	=[	$kneel2,		gaunt_charge3	] {monster_removeslide();};
void()	gaunt_charge3	=[	$kneel3,		gaunt_charge4	] {monster_removeslide();};
void()	gaunt_charge4	=[	$kneel4,		gaunt_charge5	] {monster_removeslide();};
void()	gaunt_charge5	=[	$kneel5,		gaunt_charge6	] {monster_removeslide();};
void()	gaunt_charge6	=[	$kneel6,		gaunt_charge7	] {monster_removeslide();};
void()	gaunt_charge7	=[	$kneel7,		gaunt_charge8	] {monster_removeslide();};
void()	gaunt_charge8	=[	$kneel8,		gaunt_charge9	] {monster_removeslide();};
void() 	gaunt_charge10;
void()	gaunt_charge9	=[	$pray1,		gaunt_charge9	] 
{
	local entity effect;
	
	monster_removeslide();
	if (self.mana < 150)
	{
		effect = spawn();
		setorigin(effect, self.origin - v_up*8);
		setmodel(effect, "progs/grounded.mdl");
		effect.solid = SOLID_NOT;
		setsize (effect, '-21 -21 -16', '22 23 31');
		effect.movetype = MOVETYPE_NOCLIP;
		effect.think = effect_think;
		effect.effects = EF_FULLBRIGHT | EF_ADDITIVE;
		effect.alpha = 0.75;
		effect.nextthink = time + 0.1;

		sound (self, CHAN_BODY, "gaunt/charge.wav", 1, ATTN_NORM);
		self.mana = self.mana + 3;
	}
	else
	{
		self.mana = 150; // cap
		gaunt_charge10();
	}
};

void()	gaunt_charge10	=[	$kneel8,		gaunt_charge11	] {monster_removeslide();};
void()	gaunt_charge11	=[	$kneel7,		gaunt_charge12	] {monster_removeslide();};
void()	gaunt_charge12	=[	$kneel6,		gaunt_charge13	] {monster_removeslide();};
void()	gaunt_charge13	=[	$kneel5,		gaunt_charge14	] {monster_removeslide();};
void()	gaunt_charge14	=[	$kneel4,		gaunt_charge15	] {monster_removeslide();};
void()	gaunt_charge15	=[	$kneel3,		gaunt_charge16	] {monster_removeslide();};
void()	gaunt_charge16	=[	$kneel2,		gaunt_charge17	] {monster_removeslide();};
void()	gaunt_charge17	=[	$kneel1,		gaunt_run1  	] {monster_removeslide();};

void() gaunt_magic =
{
	gaunt_scream();

	if (self.mana <= 9)
	{
		gaunt_charge1();
		return;
	}

	if (self.mana < 10)
	{
		gaunt_firebolt1();
		self.mana = 0;
	}

	if (random() < 0.4 && self.mana > 9)
	{
		gaunt_firebolt1(); // fireball spell
		self.mana = self.mana - 10;
	}
	else if (random() < 0.7 && self.mana > 24)
	{
		gaunt_fireball1(); // fireball spell x 3
		self.mana = self.mana - 25;
	}
	else if (self.mana > 74)
	{
		gaunt_firebeam1(); // firebeam spell
		self.mana = self.mana - 75;
	}
	else
		gaunt_charge1();
};

/*QUAKED monster_gaunt (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_gaunt =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/gaunt.mdl");
	precache_model ("progs/b_gaunt.mdl");
	precache_model ("progs/h_gaunt.mdl");

	precache_sound ("gaunt/charge.wav");
	precache_sound ("gaunt/pain.wav");
	precache_sound ("gaunt/death.wav");
	precache_sound ("gaunt/talk1.wav");
	precache_sound ("gaunt/talk2.wav");
	precache_sound ("gaunt/talk3.wav");
	precache_sound ("gaunt/talk4.wav");
	precache_sound ("gaunt/talk5.wav");
	precache_sound ("gaunt/talk6.wav");
	precache_sound ("gaunt/talk7.wav");
	precache_sound ("gaunt/talk8.wav");
	precache_sound ("gaunt/talk9.wav");
	precache_sound ("gaunt/talk10.wav");
	precache_sound ("gaunt/talk11.wav");
	precache_sound ("gaunt/talk12.wav");
	precache_sound ("gaunt/talk13.wav");
	precache_sound ("gaunt/talk14.wav");
	precache_sound ("gaunt/scream1.wav");
	precache_sound ("gaunt/scream2.wav");
	precache_sound ("gaunt/scream3.wav");
	precache_sound ("gaunt/scream4.wav");
	precache_sound ("gaunt/scream5.wav");
	precache_sound ("gaunt/scream6.wav");
	precache_sound ("gaunt/scream7.wav");
	precache_sound ("gaunt/scream8.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/gaunt.mdl");
	if (difficulty < 2)
		self.health = 175; // regular health
	else
		self.health = 263; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "gaunt";
	self.displayname = "Gaunt";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.mana = 150; // mana, 150 is max for gaunts
	self.th_stand = gaunt_stand1;
	self.th_walk = gaunt_walk1;
	self.th_run = gaunt_run1;
	self.th_grab = gaunt_grabbed1;
	self.th_pain = gaunt_pain;
	self.th_die = gaunt_die;
	self.th_melee = gaunt_finger1;
	self.th_magic = gaunt_magic;
	self.experience = 77;
	self.maxgold = 130;

	//spawn_shadow();
	enemy_start();
};