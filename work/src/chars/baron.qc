/*
+--------+
|Baron   |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Melee monster that can shake the ground, also can block, very dangerous.   |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/     

$frame run1 run2 run3 run4 run5 run6
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10 idle11 idle12 idle13 idle14 idle15 idle16 idle17 idle18 idle19 idle20
$frame point1 point2 point3 point4 point5 point6 point7 point8 point9 point10 point11
$frame draw1 draw2 draw3 draw4 draw5
$frame crstand1 crstand2 crstand3 crstand4 crstand5 crstand6 crstand7 crstand8 crstand9 crstand10 crstand11 crstand12 crstand13 crstand14 crstand15 crstand16 crstand17 crstand18 crstand19
$frame pain1 pain2 pain3
$frame diea1 diea2 diea3 diea4 diea5 diea6
$frame dieb1 dieb2 dieb3 dieb4 dieb5 dieb6
$frame smack1 smack2 smack3 smack4 smack5 smack6 smack7 smack8 smack9 smack10 smack11 smack12
$frame painb1 painb2 painb3 painb4
$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7
$frame taunt1 taunt2 taunt3 taunt4 taunt5 taunt6 taunt7 taunt8 taunt9
$frame jump1 jump2 jump3 jump4 jump5 jump6
$frame swing1 swing2 swing3 swing4 swing5 swing6

void() baron_jump1;
void() baron_jump =
{
	local entity check, oself;
	local float cj;

	if (!self.enemy)
		return;
	if (self.cnt > time)
		return;

	makevectors (self.enemy.angles);

	check = spawn();
	check.movetype = MOVETYPE_STEP;
	setmodel (check, "progs/null.spr");
	setorigin(check, self.origin + v_forward * 200 + v_up*32);
	setsize(check, self.mins, self.maxs);

	oself = self;
	self = check;
	droptofloor();

	cj = walkmove(0,0);

	self = oself;
	if (cj == TRUE && (check.flags & FL_ONGROUND) && self.flags & FL_ONGROUND)
	{
		makevectors (self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 100 + '0 0 150';
		if (self.flags & FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
		baron_jump1();
		sound (self, CHAN_BODY, "player/jump.wav", 1, ATTN_NORM);
		self.cnt = time + 3;
		self.takedamage = DAMAGE_NO;
	}
	if (check)
		remove(check);
	return;
};

void() baron_swing1;
void() baron_run1;
void()	baron_block1	=[	$draw5,	baron_block1	] 
{
	monster_removeslide();

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - (self.flags & FL_ONGROUND);
	if (!self.enemy.owner)
		return;

	if (self.origin_x < self.enemy.origin_x)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	// Needs Logic to break out his block without spamming messages
	if (self.enemy.onground == TRUE && (self.enemy.owner.attack_finished < time || self.enemy.tired_finished > time))
	{
		if (random() < 0.25)
		{
			self.think = baron_jump1;
			frameskip(0.1);
			return;
		}
		else if (random() < 0.50)
			self.th_melee();
		else
			self.th_walk();
		return;
	}
	self.block_finished = time + 0.15;
};

void() baron_idle1	=[	$idle1,	baron_idle2		] {ai_stand();};
void() baron_idle2	=[	$idle2,	baron_idle3		] {ai_stand();};
void() baron_idle3	=[	$idle3,	baron_idle4		] {ai_stand();};
void() baron_idle4	=[	$idle4,	baron_idle5		] {ai_stand();};
void() baron_idle5	=[	$idle5,	baron_idle6		] {ai_stand();};
void() baron_idle6	=[	$idle6,	baron_idle7		] {ai_stand();};
void() baron_idle7	=[	$idle7,	baron_idle8		] {ai_stand();};
void() baron_idle8	=[	$idle8,	baron_idle9		] {ai_stand();};
void() baron_idle9	=[	$idle9,	baron_idle10	] {ai_stand();};
void() baron_idle10	=[	$idle10,	baron_idle11	] {ai_stand();};
void() baron_idle11	=[	$idle11,	baron_idle12	] {ai_stand();};
void() baron_idle12	=[	$idle12,	baron_idle13	] {ai_stand();};
void() baron_idle13	=[	$idle13,	baron_idle14	] {ai_stand();};
void() baron_idle14	=[	$idle14,	baron_idle15	] {ai_stand();};
void() baron_idle15	=[	$idle15,	baron_idle16	] {ai_stand();};
void() baron_idle16	=[	$idle16,	baron_idle17	] {ai_stand();};
void() baron_idle17	=[	$idle17,	baron_idle18	] {ai_stand();};
void() baron_idle18	=[	$idle18,	baron_idle19	] {ai_stand();};
void() baron_idle19	=[	$idle19,	baron_idle20	] {ai_stand();};
void() baron_idle20	=[	$idle20,	baron_idle1		] {ai_stand();};

void() baron_run1 	=[	$run1,	baron_run2	] {ai_walk(20);self.takedamage = DAMAGE_AIM;};
void() baron_run2 	=[	$run2,	baron_run3	] {ai_walk(20);};
void() baron_run3 	=[	$run3,	baron_run4	] {ai_walk(20);};
void() baron_run4 	=[	$run4,	baron_run5	] {ai_walk(20);};
void() baron_run5 	=[	$run5,	baron_run6	] {ai_walk(20);};
void() baron_run6 	=[	$run6,	baron_run1	] {ai_walk(20);};

void() baron_point1 	=[	$point1,	baron_point2	] 
{
	monster_removeslide();
	if (self.origin_x < self.enemy.origin_x)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	sound (self, CHAN_VOICE, "baron/sight.wav", 1, ATTN_NORM);
};
void() baron_point2 	=[	$point2,	baron_point3	] {monster_removeslide();};
void() baron_point3 	=[	$point3,	baron_point4	] {monster_removeslide();};
void() baron_point4 	=[	$point4,	baron_point5	] {monster_removeslide();};
void() baron_point5 	=[	$point5,	baron_point6	] {monster_removeslide();};
void() baron_point6 	=[	$point6,	baron_point7	] {monster_removeslide();};
void() baron_point7 	=[	$point7,	baron_point8	] {monster_removeslide();};
void() baron_point8 	=[	$point8,	baron_point9	] {monster_removeslide();};
void() baron_point9 	=[	$point9,	baron_point10	] {monster_removeslide();};
void() baron_point10 	=[	$point10,	baron_point11	] {monster_removeslide();};
void() baron_point11 	=[	$point11,	baron_run1  	] {monster_removeslide();};

void() baron_sight1 	=[	$draw1,	baron_sight2	] {monster_removeslide();sound (self, CHAN_WEAPON, "baron/swordraw.wav", 1, ATTN_NORM);};
void() baron_sight2 	=[	$draw2,	baron_sight3	] {monster_removeslide();};
void() baron_sight3 	=[	$draw3,	baron_sight4	] {monster_removeslide();};
void() baron_sight4 	=[	$draw4,	baron_sight5	] {monster_removeslide();};
void() baron_sight5 	=[	$draw5,	baron_sight5  	] 
{
	local float r;
	r = random();
	if (r < 0.5)
	{
		baron_run1();
		return;
	}
	else
	{
		baron_point1();
		return;
	}	
};

void() baron_hidesword1 	=[	$draw5,	baron_hidesword2	] {monster_removeslide();};
void() baron_hidesword2 	=[	$draw4,	baron_hidesword3	] {monster_removeslide();};
void() baron_hidesword3 	=[	$draw3,	baron_hidesword4	] {monster_removeslide();};
void() baron_hidesword4 	=[	$draw2,	baron_hidesword4	] 
{
	if (self.enemy)
	{
		if (!self.enemy.flypain)
			HuntTarget();
	}
	else
		self.th_stand();
	monster_removeslide();
};

void() baron_swing1 	=[	$swing1,	baron_swing2	] 
{
	BlockCancel();
	local float b = random()*3 * 0.1;  // stagger first frame
	frameskip(0.08 + b);
};
void() baron_swing2 	=[	$swing2,	baron_swing3	] {BlockCancel();frameskip(0.08);};
void() baron_swing3 	=[	$swing3,	baron_swing4	] {BlockCancel();frameskip(0.08);};
void() baron_swing4 	=[	$swing4,	baron_swing5	] {BlockCancel();sound (self, CHAN_WEAPON, "baron/sword.wav", 1, ATTN_NORM);frameskip(0.08);};
void() baron_swing5 	=[	$swing5,	baron_swing6	] {BlockCancel();FireMelee(14,16,3,43,5,0,0,FALSE,0,0);frameskip(0.08);};
void() baron_swing6 	=[	$swing6,	baron_run1  	] {BlockCancel();FireMelee(14,16,3,43,5,0,0,FALSE,0,0);frameskip(0.08);};

void() baron_smash1 	=[	$smack1,	baron_smash2	] {frameskip(0.05);monster_removeslide();};
void() baron_smash2 	=[	$smack2,	baron_smash3	] {frameskip(0.05);monster_removeslide();};
void() baron_smash3 	=[	$smack3,	baron_smash4	] {frameskip(0.05);monster_removeslide();};
void() baron_smash4 	=[	$smack4,	baron_smash5	] {frameskip(0.05);monster_removeslide();};
void() baron_smash5 	=[	$smack5,	baron_smash6	] {frameskip(0.05);monster_removeslide();};
void() baron_smash6 	=[	$smack6,	baron_smash7	] {frameskip(0.15);monster_removeslide();};
void() baron_smash7 	=[	$smack7,	baron_smash8	] {frameskip(0.05);monster_removeslide();};
void() baron_smash8 	=[	$smack8,	baron_smash9	] 
{
	local entity effect, head;

	effect = spawn();
	setorigin(effect, self.origin + v_forward * 18 - v_up*8);
	setmodel(effect, "progs/grounded.mdl");
	effect.solid = SOLID_NOT;
	setsize (effect, '-21 -21 -16', '22 23 31');
	effect.movetype = MOVETYPE_STEP;
	effect.effects = EF_FULLBRIGHT | EF_ADDITIVE;
	effect.velocity_z = -999;
	effect.think = effect_think;
	effect.alpha = 0.8;
	effect.nextthink = time + 0.1;

	head = searchradius(self.origin, 60);
	while (head)
	{
		if ((head.takedamage && head != self && !head.flags & FL_MONSTER && head.onground == TRUE) || head.classname == "breakable")
		{
			head.knockback = 2; // pop Vigil in the air
			self.status_broken_finished = time + 20;
			T_Damage (head, self, self, 18, 0.25);
			if (head.classname == "player")	
				head.owner.camshake_finished = time + 0.4;
		}
		head = head.chain;
	}
	sound (self, CHAN_WEAPON, "baron/smash.wav", 1, ATTN_NORM);
	frameskip(1);
};
void() baron_smash9 	=[	$smack9,	baron_smash10	] {frameskip(0.05);monster_removeslide();};
void() baron_smash10 	=[	$smack10,	baron_smash11	] {frameskip(0.05);monster_removeslide();};
void() baron_smash11 	=[	$smack11,	baron_smash12	] {frameskip(0.05);monster_removeslide();};
void() baron_smash12 	=[	$smack12,	baron_run1  	] {frameskip(0.05);monster_removeslide();};

void() baron_melee =
{
	if (random() < 0.5)
		baron_swing1();
	else
		baron_smash1();
};

void() baron_pain1 	=[	$pain1,	baron_pain2	] {monster_removeslide();};
void() baron_pain2	=[	$pain2,	baron_pain3	] {monster_removeslide();};
void() baron_pain3 	=[	$pain3,	baron_run1	] {BlockCancel();monster_removeslide();};

void() baron_painb1 	=[	$painb1,	baron_painb2	] {monster_removeslide();};
void() baron_painb2		=[	$painb2,	baron_painb3	] {monster_removeslide();};
void() baron_painb3 	=[	$painb3,	baron_painb4	] {BlockCancel();monster_removeslide();};
void() baron_painb4 	=[	$painb4,	baron_run1		] {BlockCancel();monster_removeslide();};

void() baron_pain =
{
	if (random() < 0.5)
		baron_pain1();
	else
		baron_painb1();
	sound (self, CHAN_VOICE, "baron/pain.wav", 1, ATTN_NORM);
	monster_pain(self.enemy);
};

void() baron_diea1 	=[	$diea1,	baron_diea2	] {monster_death();};
void() baron_diea2 	=[	$diea2,	baron_diea3	] {monster_death();};
void() baron_diea3 	=[	$diea3,	baron_diea4	] {monster_death();};
void() baron_diea4 	=[	$diea4,	baron_diea5	] {monster_death();};
void() baron_diea5 	=[	$diea5,	baron_diea6	] {monster_death();};
void() baron_diea6 	=[	$diea6,	baron_diea6	] {monster_death();};

void() baron_dieb1 	=[	$dieb1,	baron_dieb2	] {monster_death();};
void() baron_dieb2 	=[	$dieb2,	baron_dieb3	] {monster_death();};
void() baron_dieb3 	=[	$dieb3,	baron_dieb4	] {monster_death();};
void() baron_dieb4 	=[	$dieb4,	baron_dieb5	] {monster_death();};
void() baron_dieb5 	=[	$dieb5,	baron_dieb6	] {monster_death();};
void() baron_dieb6 	=[	$dieb6,	baron_dieb6	] {monster_death();};

void() baron_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{			  // otherwise player can keep knocking corpse for EXP
		GiveExperience(self.experience);
		self.gaveexp = TRUE;
		sound (self, CHAN_VOICE, "baron/death.wav", 1, ATTN_NORM);
	}
	if (self.damage_type == 5) // Sliced/Gored in half
	{
		sound (self, CHAN_BODY, "misc/guts.wav", 1, ATTN_NORM);
		ThrowBodyPart("progs/baron_c1.mdl");
		ThrowBodyPart("progs/baron_c2.mdl");
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

	if (random() > 0.5)
		baron_diea1 ();
	else
		baron_dieb1 ();
};

void() baron_jump2;
void() baron_jump1	=[	$jump1,	baron_jump1	] 
{
	if (self.flags & FL_ONGROUND)
		baron_jump2();
	frameskip(0.05);
};
void() baron_jump2	=[	$jump2,	baron_jump3	] {frameskip(0.05);};
void() baron_jump3	=[	$jump3,	baron_jump4	] {frameskip(0.05);};
void() baron_jump4	=[	$jump4,	baron_jump4	]
{
	self.takedamage = DAMAGE_AIM;
	if (self.flags & FL_ONGROUND)
		baron_run1();
};

void()	baron_grabbed1	=[	$painb4,		baron_grabbed2	] {self.grab_finished = time + 1;};
void()	baron_grabbed2	=[	$painb4,		baron_grabbed2	] 
{
	if (self.grab_finished < time || self.grabbed == FALSE)
	{
		self.th_walk();
		return;
	}		
};

/*QUAKED monster_baron (1 0 0) (-16 -16 -24) (16 16 32)
"awareness":
0 (default) notice player when near and visible
1 notice player if visible at all
2 notice player instantly
3 ignore player, check if camera is infront of monster
"target":
4 not aware at all, must be triggered
If monster is given a target, when the monster dies it
can cause an event such as a door opening!
*/
void() monster_baron =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/baron.mdl");
	precache_model ("progs/baron_c1.mdl");
	precache_model ("progs/baron_c2.mdl");

	precache_sound ("baron/swordraw.wav");
	precache_sound ("baron/sword.wav");
	precache_sound ("baron/sight.wav");
	precache_sound ("baron/smash.wav");
	precache_sound ("baron/pain.wav");
	precache_sound ("baron/death.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/baron.mdl");

	if (difficulty < 2)
		self.health = 300; // regular health
	else
		self.health = 450; // hard health (50% tougher)

	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "baron";
	self.displayname = "Baron";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.experience = 105;
	self.maxgold = 345;

	self.th_stand = baron_idle1;
	self.th_misc = baron_sight1;
	self.th_walk = baron_run1;
	self.th_grab = baron_grabbed1;
	self.th_pain = baron_pain;
	self.th_die = baron_die;
	self.th_melee = baron_melee;

	self.th_block = baron_block1;
	if (!self.ai_blockfreq) // frequency on how much the enemy blocks
	{
		if (difficulty < 2)
			self.ai_blockfreq = 0.3; // 30% skill 1
		else
			self.ai_blockfreq = 0.5; // 50% skill 2
	}

	//spawn_shadow();
	enemy_start();
};