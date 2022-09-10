/*
+--------+
|Archg   |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Magic using monster that casts a variety of spells, upper gaunt.           |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/     

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10 idle11 idle12 idle13 idle14 idle15 idle16 idle17 idle18 idle19
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12 walk13 walk14
$frame bow1 bow2 bow3 bow4 bow5 bow6 bow7 bow8 bow9 bow10 bow11 bow12 bow13 bow14 bow15
$frame cast1 cast2 cast3 cast4 cast5 cast6 cast7 cast8 cast9 cast10 cast11
$frame castb1 castb2 castb3 castb4 castb5 castb6 castb7 castb8 castb9
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12 death13
$frame melee1 melee2 melee3 melee4 melee5 melee6 melee7 melee8 melee9 melee10 melee11

void() archg_stand1	=[	$idle1,	archg_stand2		] {ai_stand();};
void() archg_stand2	=[	$idle2,	archg_stand3		] {ai_stand();};
void() archg_stand3	=[	$idle3,	archg_stand4		] {ai_stand();};
void() archg_stand4	=[	$idle4,	archg_stand5		] {ai_stand();};
void() archg_stand5	=[	$idle5,	archg_stand6		] {ai_stand();};
void() archg_stand6	=[	$idle6,	archg_stand7		] {ai_stand();};
void() archg_stand7	=[	$idle7,	archg_stand8		] {ai_stand();};
void() archg_stand8	=[	$idle8,	archg_stand9		] {ai_stand();};
void() archg_stand9	=[	$idle9,	archg_stand10		] {ai_stand();};
void() archg_stand10	=[	$idle10,	archg_stand11		] {ai_stand();};
void() archg_stand11	=[	$idle11,	archg_stand12		] {ai_stand();};
void() archg_stand12	=[	$idle12,	archg_stand13		] {ai_stand();};
void() archg_stand13	=[	$idle13,	archg_stand14		] {ai_stand();};
void() archg_stand14	=[	$idle14,	archg_stand15		] {ai_stand();};
void() archg_stand15	=[	$idle15,	archg_stand16		] {ai_stand();};
void() archg_stand16	=[	$idle16,	archg_stand17		] {ai_stand();};
void() archg_stand17	=[	$idle17,	archg_stand18		] {ai_stand();};
void() archg_stand18	=[	$idle18,	archg_stand19		] {ai_stand();};
void() archg_stand19	=[	$idle19,	archg_stand1		] {ai_stand();};

void() archg_walk1	=[	$walk1,	archg_walk2		] {ai_walk(7);};
void() archg_walk2	=[	$walk2,	archg_walk3		] {ai_walk(7);};
void() archg_walk3	=[	$walk3,	archg_walk4		] {ai_walk(7);};
void() archg_walk4	=[	$walk4,	archg_walk5		] {ai_walk(7);};
void() archg_walk5	=[	$walk5,	archg_walk6		] {ai_walk(7);};
void() archg_walk6	=[	$walk6,	archg_walk7		] {ai_walk(7);};
void() archg_walk7	=[	$walk7,	archg_walk8		] {ai_walk(7);};
void() archg_walk8	=[	$walk8,	archg_walk9		] {ai_walk(7);};
void() archg_walk9	=[	$walk9,	archg_walk10	] {ai_walk(7);};
void() archg_walk10	=[	$walk10,	archg_walk11	] {ai_walk(7);};
void() archg_walk11	=[	$walk11,	archg_walk12	] {ai_walk(7);};
void() archg_walk12	=[	$walk12,	archg_walk13	] {ai_walk(7);};
void() archg_walk13	=[	$walk13,	archg_walk14	] {ai_walk(7);};
void() archg_walk14	=[	$walk14,	archg_walk1		] {ai_walk(7);};

void() archg_charge16;
void() archg_charge1	=[	$bow1,	archg_charge2	] {spawn_magicfog();};
void() archg_charge2	=[	$bow2,	archg_charge3	] {};
void() archg_charge3	=[	$bow3,	archg_charge4	] {};
void() archg_charge4	=[	$bow4,	archg_charge5	] {};
void() archg_charge5	=[	$bow5,	archg_charge6	] {};
void() archg_charge6	=[	$bow6,	archg_charge7	] {};
void() archg_charge7	=[	$bow7,	archg_charge8	] {};
void() archg_charge8	=[	$bow8,	archg_charge9	] {};
void() archg_charge9	=[	$bow9,	archg_charge10	] {};
void() archg_charge10	=[	$bow10,	archg_charge11	] {};
void() archg_charge11	=[	$bow11,	archg_charge12	] {};
void() archg_charge12	=[	$bow12,	archg_charge13	] {};
void() archg_charge13	=[	$bow13,	archg_charge14	] {};
void() archg_charge14	=[	$bow14,	archg_charge15	] {};
void() archg_charge15	=[	$bow15,	archg_charge15	] 
{
	local entity effect;

	if (self.mana < 200)
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
		self.mana = self.mana + 6;
	}
	else
	{
		self.mana = 200;
		archg_charge16();
	}
};


void() archg_charge16	=[	$bow14,	archg_charge17	] {};
void() archg_charge17	=[	$bow13,	archg_charge18	] {};
void() archg_charge18	=[	$bow12,	archg_charge19	] {};
void() archg_charge19	=[	$bow11,	archg_charge20	] {};
void() archg_charge20	=[	$bow10,	archg_charge21	] {};
void() archg_charge21	=[	$bow9,	archg_charge22	] {};
void() archg_charge22	=[	$bow8,	archg_charge23	] {};
void() archg_charge23	=[	$bow7,	archg_charge24	] {};
void() archg_charge24	=[	$bow6,	archg_charge25	] {};
void() archg_charge25	=[	$bow5,	archg_charge26	] {};
void() archg_charge26	=[	$bow4,	archg_charge27	] {};
void() archg_charge27	=[	$bow3,	archg_charge28	] {};
void() archg_charge28	=[	$bow2,	archg_charge29	] {};
void() archg_charge29	=[	$bow1,	archg_walk1 	] {};

void() archg_melee1	=[	$melee1,	archg_melee2		] {};
void() archg_melee2	=[	$melee2,	archg_melee3		] {};
void() archg_melee3	=[	$melee3,	archg_melee4		] {};
void() archg_melee4	=[	$melee4,	archg_melee5		] {};
void() archg_melee5	=[	$melee5,	archg_melee6		] {};
void() archg_melee6	=[	$melee6,	archg_melee7		] {FireMelee(0,15,3,50,99,0,0,TRUE,0,0);sound (self, CHAN_AUTO, "misc/windpush.wav", 1, ATTN_NORM);};
void() archg_melee7	=[	$melee7,	archg_melee8		] {};
void() archg_melee8	=[	$melee8,	archg_melee9		] {};
void() archg_melee9	=[	$melee9,	archg_melee10		] {};
void() archg_melee10	=[	$melee10,	archg_melee11		] {};
void() archg_melee11	=[	$melee11,	archg_walk1 		] {};

void() archg_fireball1	=[	$castb1,	archg_fireball2		] {spawn_magicfog();};
void() archg_fireball2	=[	$castb2,	archg_fireball3		] {};
void() archg_fireball3	=[	$castb3,	archg_fireball4		] {};
void() archg_fireball4	=[	$castb4,	archg_fireball5		] {};
void() archg_fireball5	=[	$castb5,	archg_fireball6		] {self.colormod = '3 2 1';Fireball(11,7);};
void() archg_fireball6	=[	$castb6,	archg_fireball7		] {self.colormod = '3 2 1';Fireball(11,3);};
void() archg_fireball7	=[	$castb7,	archg_fireball8		] {};
void() archg_fireball8	=[	$castb8,	archg_fireball9		] {};
void() archg_fireball9	=[	$castb9,	archg_walk1 		] {};

void() archg_lightning9;
void() archg_lightning1		=[	$cast1,	archg_lightning2		] {spawn_magicfog();};
void() archg_lightning2		=[	$cast2,	archg_lightning3		] {};
void() archg_lightning3		=[	$cast3,	archg_lightning4		] {};
void() archg_lightning4		=[	$cast4,	archg_lightning5		] {};
void() archg_lightning5		=[	$cast5,	archg_lightning6		] {};
void() archg_lightning6		=[	$cast6,	archg_lightning7		] {};
void() archg_lightning7		=[	$cast7,	archg_lightning8		] {sound (self, CHAN_AUTO, "spells/lightn.wav", 1, ATTN_NORM);};
void() archg_lightning8		=[	$cast8,	archg_lightning8		] 
{
	if (self.lcount > 24)
		archg_lightning9();
	else
		LightningStorm();
	self.lcount = self.lcount + 1; // count up till end
	self.colormod = '5 5 5';
};

void() archg_lightning9		=[	$cast9,	archg_lightning10		] {};
void() archg_lightning10	=[	$cast10,	archg_lightning11		] {};
void() archg_lightning11	=[	$cast11,	archg_walk1 		] {};

void() archg_icefield1		=[	$cast1,	archg_icefield2		] 
{
	local entity effect;

	spawn_magicfog();

	effect = spawn();
	setorigin(effect, self.origin + v_up * 50);
	setmodel(effect, "progs/chargice.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.solid = SOLID_NOT;
	effect.alpha = 0.2;
	effect.owner = self;
	effect.think = chargeice_effect;
	effect.nextthink = time + 0.01;
	sound (effect, CHAN_AUTO, "spells/charge.wav", 1, ATTN_NORM);
	self.nextthink = time + 0.3;
};
void() archg_icefield2		=[	$cast2,	archg_icefield3		] {};
void() archg_icefield3		=[	$cast3,	archg_icefield4		] {};
void() archg_icefield4		=[	$cast4,	archg_icefield5		] {};
void() archg_icefield5		=[	$cast5,	archg_icefield6		] {};
void() archg_icefield6		=[	$cast6,	archg_icefield7		] {};
void() archg_icefield7		=[	$cast7,	archg_icefield8		] {};
void() archg_icefield8		=[	$cast8,	archg_icefield9		] {};
void() archg_icefield9		=[	$cast9,	archg_icefield10		] {};
void() archg_icefield10		=[	$cast10,	archg_icefield11		] {};
void() archg_icefield11		=[	$cast11,	archg_walk1		      ] {self.colormod = '1 1 10';IceField();};

void() archg_magic =
{
	self.lcount = 0;
	if (self.mana <= 9)
	{
		archg_charge1();
		return;
	}

	if (self.mana < 10)
	{
		archg_fireball1();
		self.mana = 0;
		return;
	}

	if (random() < 0.3 && self.mana > 9)
	{
		archg_fireball1(); // fireball x 2 spell
		self.mana = self.mana - 10;
	}
	else if (random() < 0.7 && self.mana > 44)
	{
		archg_lightning1(); // lightning storm spell
		self.mana = self.mana - 45;
	}
	else if (self.mana > 24 && self.attack_finished < time && self.enemy.onground == TRUE)
	{
		self.attack_finished = time + 3;
		archg_icefield1(); // icefield
		self.mana = self.mana - 25;
	}
	else
	{
		archg_charge1();
		return;
	}
	
};

void() archg_pain1	=[	$castb9,	archg_walk1		] {monster_removeslide();frameskip(0.2);};

void() archg_grabbed1	=[	$idle1,	archg_grabbed2		] {self.grab_finished = time + 1;};
void() archg_grabbed2	=[	$idle1,	archg_grabbed2		]
{
	if (!self.izunatarg)
	{
		if (self.grab_finished < time || self.grabbed == FALSE)
			self.th_run();
	}
	else
		ai_watercheck_removal();
};

void() archg_pain =
{
	archg_pain1();
	sound (self, CHAN_VOICE, "archg/pain.wav", 1, ATTN_NORM);
	monster_pain(self.enemy);
};

void() archg_death1	=[	$death1,	archg_death2		] {monster_death();};
void() archg_death2	=[	$death2,	archg_death3		] {monster_death();};
void() archg_death3	=[	$death3,	archg_death4		] {monster_death();};
void() archg_death4	=[	$death4,	archg_death5		] {monster_death();};
void() archg_death5	=[	$death5,	archg_death6		] {monster_death();};
void() archg_death6	=[	$death6,	archg_death7		] {monster_death();};
void() archg_death7	=[	$death7,	archg_death8		] {monster_death();};
void() archg_death8	=[	$death8,	archg_death9		] {monster_death();};
void() archg_death9	=[	$death9,	archg_death10		] {monster_death();};
void() archg_death10	=[	$death10,	archg_death11		] {monster_death();};
void() archg_death11	=[	$death11,	archg_death12		] {monster_death();};
void() archg_death12	=[	$death12,	archg_death13		] {monster_death();};
void() archg_death13	=[	$death13,	archg_death13		] {monster_death();};

void() archg_die =
{
	self.velocity = '0 0 0';
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  // otherwise player can keep knocking corpse for EXP
		sound (self, CHAN_VOICE, "archg/death.wav", 1, ATTN_NORM);
		GiveExperience(self.experience);
		self.movetype = MOVETYPE_TOSS;
		self.gaveexp = TRUE;
	}
	if (self.knockback != 2 && self.knockback != 3)
		self.velocity = '0 0 0';
	archg_death1();
};

void() archg_melee =
{
	if (random() < 0.1 && self.mana > 24 && self.attack_finished < time && self.enemy.onground == TRUE)
	{
		archg_icefield1(); // icefield
		self.mana = self.mana - 25;
		self.attack_finished = time + 3;
	}
	else
		archg_melee1();
};

/*QUAKED monster_archghoul (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_archghoul =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/archg.mdl");
	precache_sound ("archg/pain.wav");
	precache_sound ("archg/death.wav");
	precache_sound ("gaunt/charge.wav");

	precache_sound ("misc/windpush.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/archg.mdl");
	if (difficulty < 2)
		self.health = 277; // regular health
	else
		self.health = 415; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "archg";
	self.displayname = "Arch-Ghoul";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.mana = 200; // mana, 200 is max for arch ghouls
	self.experience = 150;
	self.maxgold = 333;

	self.th_stand = archg_stand1;
	self.th_walk = archg_walk1;
	self.th_pain = archg_pain;
	self.th_die = archg_die;
	self.th_grab = archg_grabbed1;
	self.th_melee = archg_melee;

	self.th_magic = archg_magic;

	//spawn_shadow();
	enemy_start();
};