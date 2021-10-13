/*
+--------------+
|Lesser Wraith |
+--------------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Chases enemies non stop, is no clip and carries a small sword,             |
| not easily seen. Weaker but flies faster than his bigger brother.          |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/
$frame float1 float2 float3 float4 float5 float6 float7 float8 float9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12 run13 run14 run15 run16

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8 magica9 magic10 magica11
$frame magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8 magicb9 magicb10 magicb11
$frame magicb12 magicb13

$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10

$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20 
$frame w_attack21 w_attack22 

void() lesserwraith_stand1	=[	$float1,	lesserwraith_stand2		] {ai_stand();self.alpha = 0.2;};
void() lesserwraith_stand2	=[	$float2,	lesserwraith_stand3		] {ai_stand();};
void() lesserwraith_stand3	=[	$float3,	lesserwraith_stand4		] {ai_stand();};
void() lesserwraith_stand4	=[	$float4,	lesserwraith_stand5		] {ai_stand();};
void() lesserwraith_stand5	=[	$float5,	lesserwraith_stand6		] {ai_stand();};
void() lesserwraith_stand6	=[	$float6,	lesserwraith_stand7		] {ai_stand();};
void() lesserwraith_stand7	=[	$float7,	lesserwraith_stand8		] {ai_stand();};
void() lesserwraith_stand8	=[	$float8,	lesserwraith_stand9		] {ai_stand();};
void() lesserwraith_stand9	=[	$float9,	lesserwraith_stand1		] {ai_stand();};

void() lesserwraith_walk1	=[	$walk1,	lesserwraith_walk2		] {self.alpha = 0.35;ai_fly(16);};
void() lesserwraith_walk2	=[	$walk2,	lesserwraith_walk3		] 
{
	local float r;
	r = random();
	if (random() < 0.1)
	{
		self.velocity = '0 0 0';
		if (r < 0.5)
			sound (self, CHAN_VOICE, "wraith/idle1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "wraith/idle2.wav", 1, ATTN_NORM);
	}
	ai_fly(8);
};
void() lesserwraith_walk3	=[	$walk3,	lesserwraith_walk4		] {ai_fly(16);};
void() lesserwraith_walk4	=[	$walk4,	lesserwraith_walk5		] {ai_fly(16);};
void() lesserwraith_walk5	=[	$walk5,	lesserwraith_walk6		] {ai_fly(16);};
void() lesserwraith_walk6	=[	$walk6,	lesserwraith_walk7		] {ai_fly(16);};
void() lesserwraith_walk7	=[	$walk7,	lesserwraith_walk8		] {ai_fly(16);};
void() lesserwraith_walk8	=[	$walk8,	lesserwraith_walk9		] {ai_fly(16);};
void() lesserwraith_walk9	=[	$walk9,	lesserwraith_walk10		] {ai_fly(16);};
void() lesserwraith_walk10	=[	$walk10, lesserwraith_walk11	] {ai_fly(16);};
void() lesserwraith_walk11	=[	$walk11, lesserwraith_walk12	] {ai_fly(16);};
void() lesserwraith_walk12	=[	$walk12, lesserwraith_walk13	] {ai_fly(16);};
void() lesserwraith_walk13	=[	$walk13, lesserwraith_walk14	] {ai_fly(16);};
void() lesserwraith_walk14	=[	$walk14, lesserwraith_walk15	] {ai_fly(16);};
void() lesserwraith_walk15	=[	$walk15, lesserwraith_walk16	] {ai_fly(16);};
void() lesserwraith_walk16	=[	$walk16, lesserwraith_walk17	] {ai_fly(16);};
void() lesserwraith_walk17	=[	$walk17, lesserwraith_walk18	] {ai_fly(16);};
void() lesserwraith_walk18	=[	$walk18, lesserwraith_walk19	] {ai_fly(16);};
void() lesserwraith_walk19	=[	$walk19, lesserwraith_walk20	] {ai_fly(16);};
void() lesserwraith_walk20	=[	$walk20, lesserwraith_walk1		] {ai_fly(16);};

void() lesserwraith_run1	=[	$run1,	lesserwraith_run2	] {self.alpha = 0.5;ai_fly(30);};
void() lesserwraith_run2	=[	$run2,	lesserwraith_run3	] {ai_fly(30);};
void() lesserwraith_run3	=[	$run3,	lesserwraith_run4	] {ai_fly(30);};
void() lesserwraith_run4	=[	$run4,	lesserwraith_run5	] {ai_fly(30);};
void() lesserwraith_run5	=[	$run5,	lesserwraith_run6	] {ai_fly(30);};
void() lesserwraith_run6	=[	$run6,	lesserwraith_run7	] {ai_fly(30);};
void() lesserwraith_run7	=[	$run7,	lesserwraith_run8	] {ai_fly(30);};
void() lesserwraith_run8	=[	$run8,	lesserwraith_run9	] {ai_fly(30);};
void() lesserwraith_run9	=[	$run9,	lesserwraith_run10	] {ai_fly(30);};
void() lesserwraith_run10	=[	$run10,	lesserwraith_run11	] {ai_fly(30);};
void() lesserwraith_run11	=[	$run11,	lesserwraith_run12	] {ai_fly(30);};
void() lesserwraith_run12	=[	$run12,	lesserwraith_run13	] {ai_fly(30);};
void() lesserwraith_run13	=[	$run13,	lesserwraith_run14	] {ai_fly(30);};
void() lesserwraith_run14	=[	$run14,	lesserwraith_run15	] {ai_fly(30);};
void() lesserwraith_run15	=[	$run15,	lesserwraith_run16	] {ai_fly(30);};
void() lesserwraith_run16	=[	$run16,	lesserwraith_run1	] {ai_fly(30);};

void() lesserwraith_pain1	=[	$pain1,	lesserwraith_pain2		] {};
void() lesserwraith_pain2	=[	$pain2,	lesserwraith_pain3		] {};
void() lesserwraith_pain3	=[	$pain3,	lesserwraith_pain4		] {};
void() lesserwraith_pain4	=[	$pain4,	lesserwraith_pain5		] {};
void() lesserwraith_pain5	=[	$pain5,	lesserwraith_run1		] {};

void() lesserwraith_smash1	=[	$magica1,	lesserwraith_smash2		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash2	=[	$magica2,	lesserwraith_smash3		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash3	=[	$magica3,	lesserwraith_smash4		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash4	=[	$magica4,	lesserwraith_smash5		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash5	=[	$magica5,	lesserwraith_smash6		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash6	=[	$magica6,	lesserwraith_smash7		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash7	=[	$magica7,	lesserwraith_smash8		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash8	=[	$magica8,	lesserwraith_smash9		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash9	=[	$magica9,	lesserwraith_smash10	] {FireMelee(20,15,0,40,5,0,1,FALSE,0,0);frameskip(0.07);ai_forceface();};
void() lesserwraith_smash10	=[	$magica10,	lesserwraith_smash11	] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash11	=[	$magica11,	lesserwraith_smash12	] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash12	=[	$magica12,	lesserwraith_smash13	] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash13	=[	$magica13,	lesserwraith_smash14	] {frameskip(0.07);ai_forceface();};
void() lesserwraith_smash14	=[	$magica14,	lesserwraith_walk1		] {frameskip(0.07);ai_forceface();};

void() lesserwraith_magicb1	=[	$magicb1,	lesserwraith_magicb2		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb2	=[	$magicb2,	lesserwraith_magicb3		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb3	=[	$magicb3,	lesserwraith_magicb4		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb4	=[	$magicb4,	lesserwraith_magicb5		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb5	=[	$magicb5,	lesserwraith_magicb6		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb6	=[	$magicb6,	lesserwraith_magicb7		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb7	=[	$magicb7,	lesserwraith_magicb8		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb8	=[	$magicb8,	lesserwraith_magicb9		] {FireMelee(20,15,0,40,5,0,1,FALSE,0,0);frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb9	=[	$magicb9,	lesserwraith_magicb10	] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb10 =[	$magicb10,	lesserwraith_magicb11	] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb11 =[	$magicb11,	lesserwraith_magicb12	] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb12 =[	$magicb12,	lesserwraith_magicb13	] {frameskip(0.07);ai_forceface();};
void() lesserwraith_magicb13 =[	$magicb13,	lesserwraith_walk1		] {frameskip(0.07);ai_forceface();};

void() lesserwraith_slice1	 =[	$slice1,	lesserwraith_slice2		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_slice2	 =[	$slice2,	lesserwraith_slice3		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_slice3	 =[	$slice3,	lesserwraith_slice4		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_slice4	 =[	$slice4,	lesserwraith_slice5		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_slice5	 =[	$slice5,	lesserwraith_slice6		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_slice6	 =[	$slice6,	lesserwraith_slice7		] {FireMelee(20,15,0,40,5,0,1,FALSE,0,0);frameskip(0.07);ai_forceface();};
void() lesserwraith_slice7	 =[	$slice7,	lesserwraith_slice8		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_slice8	 =[	$slice8,	lesserwraith_slice9		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_slice9  =[	$slice9,	lesserwraith_slice10	] {frameskip(0.07);ai_forceface();};
void() lesserwraith_slice10 =[	$slice10,	lesserwraith_walk1		] {frameskip(0.07);ai_forceface();};

void() lesserwraith_doubleattack1	=[	$w_attack1,	lesserwraith_doubleattack2		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack2	=[	$w_attack2,	lesserwraith_doubleattack3		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack3	=[	$w_attack3,	lesserwraith_doubleattack4		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack4	=[	$w_attack4,	lesserwraith_doubleattack5		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack5	=[	$w_attack5,	lesserwraith_doubleattack6		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack6	=[	$w_attack6,	lesserwraith_doubleattack7		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack7	=[	$w_attack7,	lesserwraith_doubleattack8		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack8	=[	$w_attack8,	lesserwraith_doubleattack9		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack9	=[	$w_attack9,	lesserwraith_doubleattack10		] {FireMelee(20,15,0,40,5,0,1,FALSE,0,0);frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack10	=[	$w_attack10,	lesserwraith_doubleattack11		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack11	=[	$w_attack11,	lesserwraith_doubleattack12		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack12	=[	$w_attack12,	lesserwraith_doubleattack13		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack13	=[	$w_attack13,	lesserwraith_doubleattack14		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack14	=[	$w_attack14,	lesserwraith_doubleattack15		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack15	=[	$w_attack15,	lesserwraith_doubleattack16		] {FireMelee(20,15,0,40,5,0,1,FALSE,0,0);frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack16	=[	$w_attack16,	lesserwraith_doubleattack17		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack17	=[	$w_attack17,	lesserwraith_doubleattack18		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack18	=[	$w_attack18,	lesserwraith_doubleattack19		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack19	=[	$w_attack19,	lesserwraith_doubleattack20		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack20	=[	$w_attack20,	lesserwraith_doubleattack21		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack21	=[	$w_attack21,	lesserwraith_doubleattack22		] {frameskip(0.07);ai_forceface();};
void() lesserwraith_doubleattack22	=[	$w_attack22,	lesserwraith_walk1				] {frameskip(0.07);ai_forceface();};

void() lesserwraith_melee =
{
	local float r;

	r = random();

	self.alpha = 1;

	// cut all directional velocity in half before attack is launched

	self.velocity = self.velocity / 2;
	if (r < 0.25)
		lesserwraith_smash1();
	else if (r < 0.50)
		lesserwraith_magicb1();
	else if (r < 0.75)
		lesserwraith_slice1();
	else
		lesserwraith_doubleattack1();
};

void() lesserwraith_pain =
{
	self.alpha = 1;
	lesserwraith_pain1();
	monster_pain(self.enemy);

	// Back away on hits
	if (self.angles_y == 0)
		self.velocity_x = -50;
	else
		self.velocity_x = 50;
};

void() lesserwraith_death1	=[	$death1,	lesserwraith_death2		] {monster_death();};
void() lesserwraith_death2	=[	$death2,	lesserwraith_death3		] {monster_death();};
void() lesserwraith_death3	=[	$death3,	lesserwraith_death4		] {monster_death();};
void() lesserwraith_death4	=[	$death4,	lesserwraith_death5		] {monster_death();};
void() lesserwraith_death5	=[	$death5,	lesserwraith_death6		] {monster_death();};
void() lesserwraith_death6	=[	$death6,	lesserwraith_death6		] 
{
	monster_death();
	remove(self);
	return;
};

void() lesserwraith_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  		  // otherwise player can keep knocking corpse for EXP
		GiveExperience(self.experience);
		self.gaveexp = TRUE;
	}
	sound (self, CHAN_VOICE, "wraith/death.wav", 1, ATTN_NORM);

	self.movetype = MOVETYPE_TOSS;
	self.alpha = 1;
	self.velocity = '0 0 0';
	lesserwraith_death1();
};

/*QUAKED monster_lesserwraith (1 0 0) (-32 -32 -24) (32 32 64)
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
void() monster_lesserwraith =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/lwraith.mdl");

	precache_sound ("wraith/idle1.wav");
	precache_sound ("wraith/idle2.wav");
	precache_sound ("wraith/death.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NOCLIP;
	setmodel (self, "progs/lwraith.mdl");
	if (difficulty < 2)
		self.health = 115; // regular health
	else
		self.health = 172; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "lesserwraith";
	self.displayname = "Lesser Wraith";
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.experience = 67;
	self.maxgold = 168;

	self.alpha = 0.2;
	self.effects = EF_NODEPTHTEST;
	
	self.th_stand = lesserwraith_stand1;
	self.th_walk = lesserwraith_walk1;
	self.th_run = lesserwraith_run1;
	self.th_pain = lesserwraith_pain;
	self.th_die = lesserwraith_die;
	self.th_melee = lesserwraith_melee;
	
	self.noblood = TRUE;
	enemy_start();
};