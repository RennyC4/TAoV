/*
+---------+
|Troglod  |
+---------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Highest class magic using demon, knows all spells and floats in the air    |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame float1 float2 float3 float4 float5 float6 float7
$frame casta1 casta2 casta3 casta4 casta5 casta6 casta7 casta8 casta9 casta10 casta11 casta12 casta13 casta14 casta15
$frame castb1 castb2 castb3 castb4 castb5 castb6 castb7
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12 death13 death14 death15 death16 death17

void()	troglod_stand1	=[	$float1,		troglod_stand2	] 
{
	local float r;
	r = random();
	if (random() < 0.1)
	{
		self.velocity = '0 0 0';
		if (r < 0.5)
			sound (self, CHAN_VOICE, "troglod/tidle1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "troglod/tidle2.wav", 1, ATTN_NORM);
	}

	ai_stand();
};
void()	troglod_stand2	=[	$float2,		troglod_stand3	] {ai_stand();};
void()	troglod_stand3	=[	$float3,		troglod_stand4	] {ai_stand();};
void()	troglod_stand4	=[	$float4,		troglod_stand5	] {ai_stand();};
void()	troglod_stand5	=[	$float5,		troglod_stand6	] {ai_stand();};
void()	troglod_stand6	=[	$float6,		troglod_stand7	] {ai_stand();};
void()	troglod_stand7	=[	$float7,		troglod_stand1	] {ai_stand();};

void()	troglod_run1	=[	$float1,		troglod_run2	] 
{
	local float r;
	r = random();
	if (random() < 0.1)
	{
		self.velocity = '0 0 0';
		if (r < 0.5)
			sound (self, CHAN_VOICE, "troglod/tidle1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "troglod/tidle2.wav", 1, ATTN_NORM);
	}

	self.angles_x = 0;
	ai_walk(7);
};
void()	troglod_run2	=[	$float2,		troglod_run3	] {ai_fly(11);};
void()	troglod_run3	=[	$float3,		troglod_run4	] {ai_fly(11);};
void()	troglod_run4	=[	$float4,		troglod_run5	] {ai_fly(11);};
void()	troglod_run5	=[	$float5,		troglod_run6	] {ai_fly(11);};
void()	troglod_run6	=[	$float6,		troglod_run7	] {ai_fly(11);};
void()	troglod_run7	=[	$float7,		troglod_run1	] {ai_fly(11);};

void()	troglod_firebolt1	=[	$casta1,		troglod_firebolt2	] {spawn_magicfog();ai_forceface();};
void()	troglod_firebolt2	=[	$casta2,		troglod_firebolt3	] {ai_forceface();};
void()	troglod_firebolt3	=[	$casta3,		troglod_firebolt4	] {ai_forceface();};
void()	troglod_firebolt4	=[	$casta4,		troglod_firebolt5	] {ai_forceface();};
void()	troglod_firebolt5	=[	$casta5,		troglod_firebolt6	] {ai_forceface();};
void()	troglod_firebolt6	=[	$casta6,		troglod_firebolt7	] {ai_forceface();};
void()	troglod_firebolt7	=[	$casta7,		troglod_firebolt8	] {ai_forceface();};
void()	troglod_firebolt8	=[	$casta8,		troglod_firebolt9	] {ai_forceface();};
void()	troglod_firebolt9	=[	$casta9,		troglod_firebolt10	] {ai_forceface();};
void()	troglod_firebolt10	=[	$casta10,		troglod_firebolt11	] {ai_forceface();};
void()	troglod_firebolt11	=[	$casta11,		troglod_firebolt12	] {Fireball(13,15);ai_forceface();};
void()	troglod_firebolt12	=[	$casta12,		troglod_firebolt13	] {ai_forceface();};
void()	troglod_firebolt13	=[	$casta13,		troglod_firebolt14	] {ai_forceface();};
void()	troglod_firebolt14	=[	$casta14,		troglod_firebolt15	] {ai_forceface();};
void()	troglod_firebolt15	=[	$casta15,		troglod_run1    	] {ai_forceface();};

void()	troglod_fireball1	=[	$casta1,		troglod_fireball2	] {spawn_magicfog();ai_forceface();};
void()	troglod_fireball2	=[	$casta2,		troglod_fireball3	] {ai_forceface();};
void()	troglod_fireball3	=[	$casta3,		troglod_fireball4	] {ai_forceface();};
void()	troglod_fireball4	=[	$casta4,		troglod_fireball5	] {ai_forceface();};
void()	troglod_fireball5	=[	$casta5,		troglod_fireball6	] {ai_forceface();};
void()	troglod_fireball6	=[	$casta6,		troglod_fireball7	] {ai_forceface();};
void()	troglod_fireball7	=[	$casta7,		troglod_fireball8	] {ai_forceface();};
void()	troglod_fireball8	=[	$casta8,		troglod_fireball9	] {ai_forceface();};
void()	troglod_fireball9	=[	$casta9,		troglod_fireball10	] {ai_forceface();};
void()	troglod_fireball10	=[	$casta10,		troglod_fireball11	] {ai_forceface();};
void()	troglod_fireball11	=[	$casta11,		troglod_fireball12	] {Fireball(13,15);ai_forceface();};
void()	troglod_fireball12	=[	$casta12,		troglod_fireball13	] {Fireball(13,15);ai_forceface();};
void()	troglod_fireball13	=[	$casta13,		troglod_fireball14	] {Fireball(13,15);ai_forceface();};
void()	troglod_fireball14	=[	$casta14,		troglod_fireball15	] {ai_forceface();};
void()	troglod_fireball15	=[	$casta15,		troglod_run1    	] {ai_forceface();};

void() troglod_lightning7;
void() troglod_lightning1		=[	$castb1,	troglod_lightning2		] {spawn_magicfog();ai_forceface();};
void() troglod_lightning2		=[	$castb2,	troglod_lightning3		] {ai_forceface();};
void() troglod_lightning3		=[	$castb3,	troglod_lightning4		] {ai_forceface();};
void() troglod_lightning4		=[	$castb4,	troglod_lightning5		] {ai_forceface();};
void() troglod_lightning5		=[	$castb5,	troglod_lightning6		] {sound (self, CHAN_AUTO, "spells/lightn.wav", 1, ATTN_NORM);ai_forceface();};
void() troglod_lightning6		=[	$castb6,	troglod_lightning6		] 
{
	if (self.lcount > 50)
		troglod_lightning7();
	else
		LightningStorm();
	self.lcount = self.lcount + 1; // count up till end
	ai_forceface();
};

void() troglod_lightning7	=[	$castb3,	troglod_lightning8		] {ai_forceface();};
void() troglod_lightning8	=[	$castb2,	troglod_lightning9		] {ai_forceface();};
void() troglod_lightning9	=[	$castb1,	troglod_run1	 		] {ai_forceface();};

void() IceField_Projectile_Touch =
{
	if (other.solid != SOLID_BSP)
		return;

	IceField();
	remove(self);
	return;
};

void() IceField_Projectile_Animate =
{
	particle (self.origin, '0 0 0', 208, 10);
	particle (self.origin, '0 0 0', 208, 10);
	if (self.frame < 1)
		self.frame = self.frame + 1;
	else
		self.frame = 0;
	self.nextthink = time + 0.01;
};

void() IceField_Projectile =
{
	local entity missile;

	makevectors(self.angles);

	missile = spawn();
	setorigin(missile, self.origin);
	setmodel (missile, "progs/s_bluep.spr");
	setsize(missile, '0 0 0', '0 0 0');
	missile.owner = self;
	missile.classname = "icefieldprojectile";
	missile.flags = FL_MONSTER;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_TRIGGER;
	missile.think = IceField_Projectile_Animate;
	missile.nextthink = time + 0.01;

	missile.touch = IceField_Projectile_Touch;
};

void() troglod_icefield1	=[	$castb1,	troglod_icefield2		] 
{
	local entity effect;

	spawn_magicfog();

	effect = spawn();
	setorigin(effect, self.origin);
	setmodel(effect, "progs/chargice.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.owner = self;
	effect.solid = SOLID_NOT;
	effect.alpha = 0.2;
	effect.think = chargeice_effect;
	effect.nextthink = time + 0.01;
	sound (effect, CHAN_AUTO, "spells/charge.wav", 1, ATTN_NORM);
	self.nextthink = time + 0.3;
};

// Charge ice field
void() troglod_icefield2	=[	$castb2,	troglod_icefield3	] {};
void() troglod_icefield3	=[	$castb3,	troglod_icefield4	] {};
void() troglod_icefield4	=[	$castb4,	troglod_icefield5	] {};
void() troglod_icefield5	=[	$castb5,	troglod_icefield6	] {};
void() troglod_icefield6	=[	$castb6,	troglod_icefield7	] {};
void() troglod_icefield7	=[	$castb7,	troglod_icefield8	] {};
void() troglod_icefield8	=[	$castb3,	troglod_icefield9	] {};

// Shoot ice field downward!
void() troglod_icefield9	=[	$casta9,	troglod_icefield10	] {self.angles_x = -20;};
void() troglod_icefield10	=[	$casta9,	troglod_icefield11	] {self.angles_x = -40;};
void() troglod_icefield11	=[	$casta10,	troglod_icefield12	] {self.angles_x = -60;};
void() troglod_icefield12	=[	$casta11,	troglod_icefield13	] {self.angles_x = -80;IceField_Projectile();};
void() troglod_icefield13	=[	$casta12,	troglod_icefield14	] {self.angles_x = -60;};
void() troglod_icefield14	=[	$casta13,	troglod_icefield15	] {self.angles_x = -40;};
void() troglod_icefield15	=[	$casta14,	troglod_icefield16	] {self.angles_x = -20;};
void() troglod_icefield16	=[	$casta15,	troglod_run1	        ] {self.angles_x = 0;};

void()  troglod_charge5;
void()	troglod_charge1	=[	$castb1,		troglod_charge2	] {spawn_magicfog();};
void()	troglod_charge2	=[	$castb2,		troglod_charge3	] {};
void()	troglod_charge3	=[	$castb3,		troglod_charge4	] {};
void()	troglod_charge4	=[	$castb4,		troglod_charge4	] 
{
	local entity effect;

	if (self.mana < 200)
	{
		effect = spawn();
		setorigin(effect, self.origin - v_up*8);
		setmodel(effect, "progs/grounded.mdl");
		effect.solid = SOLID_NOT;
		setsize (effect, '-21 -21 -16', '22 23 31');
		effect.movetype = MOVETYPE_FLY;
		effect.think = effect_think;
		effect.alpha = 0.2;
		effect.nextthink = time + 0.1;

		sound (self, CHAN_BODY, "gaunt/charge.wav", 1, ATTN_NORM);
		self.mana = self.mana + 3;
	}
	else
		troglod_charge5();
};
void()	troglod_charge5	=[	$castb3,		troglod_charge6	] {};
void()	troglod_charge6	=[	$castb2,		troglod_charge7	] {};
void()	troglod_charge7	=[	$castb1,		troglod_run1	] {};

// Fire Beam spell
void()	troglod_firebeam1	=[	$casta1,		troglod_firebeam2	] 
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
};
void()	troglod_firebeam2	=[	$casta2,		troglod_firebeam3	] {ai_forceface();};
void()	troglod_firebeam3	=[	$casta3,		troglod_firebeam4	] {self.nextthink = time + 0.7;ai_forceface();};
void()	troglod_firebeam4	=[	$casta4,		troglod_firebeam5	] {ai_forceface();};
void()	troglod_firebeam5	=[	$casta5,		troglod_firebeam6	] {ai_forceface();};
void()	troglod_firebeam6	=[	$casta6,		troglod_firebeam7	] {ai_forceface();};
void()	troglod_firebeam7	=[	$casta7,		troglod_firebeam8	] {ai_forceface();};
void()	troglod_firebeam8	=[	$casta8,		troglod_firebeam9	] {};
void()	troglod_firebeam9	=[	$casta9,		troglod_firebeam10	] {};
void()	troglod_firebeam10	=[	$casta9,		troglod_firebeam11	] {};
void()	troglod_firebeam11	=[	$casta9,		troglod_firebeam12	] {};
void()	troglod_firebeam12	=[	$casta10,		troglod_firebeam13	] {};

void()	troglod_firebeam13	=[	$casta11,		troglod_firebeam14	] 
{
	if (self.beams_shot < 30)
	{
		Firebeam(2, 12, 0);
		self.beams_shot = self.beams_shot + 1;
	}
	else
	{
		self.beams_shot = 0;
		troglod_run1();
	}
	if (self.beams_shot <= 1)
		Firebeam_Muzzle();
};
void()	troglod_firebeam14	=[	$casta12,		troglod_firebeam15	] 
{
	if (self.beams_shot < 30)
	{
		Firebeam(1, 12, 0);
		self.beams_shot = self.beams_shot + 1;
	}
	else
	{
		self.beams_shot = 0;
		troglod_run1();
	}
};
void()	troglod_firebeam15	=[	$casta13,		troglod_firebeam13	] 
{
	if (self.beams_shot < 30)
	{
		Firebeam (1, 15, 0);
		self.beams_shot = self.beams_shot + 1;
	}
	else
	{
		self.beams_shot = 0;
		troglod_run1();
	}
};

void() troglod_magic =
{
	self.lcount = 0;
	if (self.mana <= 9)
	{
		troglod_charge1();
		return;
	}

	if (self.mana < 10)
	{
		troglod_firebolt1();
		self.mana = 0;
		return;
	}

	if (random() < 0.2 && self.mana > 9)
	{
		troglod_firebolt1(); // fireball spell
		self.mana = self.mana - 10;
	}
	else if (random() < 0.4 && self.mana > 24)
	{
		troglod_fireball1(); // fireball spell x 3
		self.mana = self.mana - 25;
	}
	else if (random() < 0.6 && self.mana > 44)
	{
		troglod_lightning1(); // lightning storm spell
		self.mana = self.mana - 45;
	}
	else if (self.mana > 24 && self.attack_finished < time && self.enemy.onground == TRUE)
	{
		self.attack_finished = time + 3;
		troglod_icefield1(); // icefield
		self.mana = self.mana - 25;
	}
	else if (self.mana > 74)
	{
		troglod_firebeam1(); // firebeam spell
		self.mana = self.mana - 75;
	}
};

void()	troglod_pain1	=[	$pain1,		troglod_pain2	] {};
void()	troglod_pain2	=[	$pain2,		troglod_pain3	] {};
void()	troglod_pain3	=[	$pain3,		troglod_pain4	] {};
void()	troglod_pain4	=[	$pain4,		troglod_pain5	] {};
void()	troglod_pain5	=[	$pain5,		troglod_pain6	] {};
void()	troglod_pain6	=[	$pain6,		troglod_run1	] {};

void() troglod_pain =
{
	if (self.beams_shot != 0) // Remove firebeam muzzle
		self.beams_shot = 0;

	self.angles_x = 0;
	sound (self, CHAN_VOICE, "troglod/tpain.wav", 1, ATTN_NORM);
	troglod_pain1();
	monster_pain(self.enemy);
};

void()	troglod_die1	=[	$death1,	troglod_die2	] {monster_death();};
void()	troglod_die2	=[	$death2,	troglod_die3	] {monster_death();};
void()	troglod_die3	=[	$death3,	troglod_die4	] {monster_death();};
void()	troglod_die4	=[	$death4,	troglod_die5	] {monster_death();};
void()	troglod_die5	=[	$death5,	troglod_die6	] {monster_death();};
void()	troglod_die6	=[	$death6,	troglod_die7	] {monster_death();};
void()	troglod_die7	=[	$death7,	troglod_die8	] {monster_death();};
void()	troglod_die8	=[	$death8,	troglod_die9	] {monster_death();};
void()	troglod_die9	=[	$death9,	troglod_die10	] {monster_death();};
void()	troglod_die10	=[	$death10,	troglod_die11	] {monster_death();};
void()	troglod_die11	=[	$death11,	troglod_die12	] {monster_death();};
void()	troglod_die12	=[	$death12,	troglod_die13	] {monster_death();};
void()	troglod_die13	=[	$death13,	troglod_die14	] {monster_death();};
void()	troglod_die14	=[	$death14,	troglod_die15	] {monster_death();};
void()	troglod_die15	=[	$death15,	troglod_die16	] {monster_death();};
void()	troglod_die16	=[	$death16,	troglod_die17	] {monster_death();};
void()	troglod_die17	=[	$death17,	troglod_die17	] {monster_death();};

void() troglod_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{			  // otherwise player can keep knocking corpse for EXP
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		self.gaveexp = TRUE;
		GiveExperience(self.experience);

		if (random() < 0.5)
			sound (self, CHAN_VOICE, "troglod/tdeath1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "troglod/tdeath2.wav", 1, ATTN_NORM);

	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	troglod_die1();
};

/*QUAKED monster_troglod (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_troglod =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound ("troglod/tidle1.wav");
	precache_sound ("troglod/tidle2.wav");
	precache_sound ("troglod/tpain.wav");
	precache_sound ("troglod/tdeath1.wav");
	precache_sound ("troglod/tdeath2.wav");
	precache_sound ("troglod/tidle2.wav");
	precache_sound ("gaunt/charge.wav");

	precache_model ("progs/troglod.mdl");

	self.movetype = MOVETYPE_FLY;
	setmodel (self, "progs/troglod.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (difficulty < 2)
		self.health = 266; // regular health
	else
		self.health = 399; // hard health (50% tougher)
	self.mana = 200; // mana, 200 is max for troglod

	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "troglod";
	self.displayname = "Troglodyte";
	self.experience = 175;
	
	self.th_stand = troglod_stand1;
	self.th_run = troglod_run1;
	self.th_missile	= troglod_magic;
	self.th_pain = troglod_pain;
	self.th_die = troglod_die;

	//spawn_shadow();
	enemy_start();
};