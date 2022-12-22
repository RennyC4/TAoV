/*
+--------+
|Knight  |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Knights are basic enemies, is able to surprise run and attack.             |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame runb1 runb2 runb3 runb4 runb5 runb6 runb7 runb8
$frame runattack1 runattack2 runattack3 runattack4 runattack5 runattack6 runattack7 runattack8 runattack9 runattack10 runattack11
$frame pain1 pain2 pain3
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10 painb11
$frame attackb1 attackb2 attackb3 attackb4 attackb5 attackb6 attackb7 attackb8 attackb9 attackb10
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12 walk13 walk14
$frame kneel1 kneel2 kneel3 kneel4 kneel5
$frame standing1 standing2 standing3 standing4
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8 deathb9 deathb10 deathb11

void() knight_run1;
void() knight_block1	=[	$kneel3,	knight_block1	] 
{
	monster_removeslide();
	ai_watercheck_removal();

	if (self.origin_x < self.enemy.origin_x)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	// Needs Logic to break out his block without spamming messages
	if (self.enemy.onground == TRUE && (self.enemy.owner.attack_finished < time || self.enemy.tired_finished > time))
	{
		if (self.th_run)
		{
			self.think = self.th_run;
			self.nextthink = time;
		}
		else
		{
			self.think = self.th_stand;
			self.nextthink = time;
		}
		return;
	}
	self.block_finished = time + 0.15;
};

void() knight_yell =
{
	local float r, h;

	h = random();
	r = random();

	if (h < 0.4 && self.voice_finished < time)
	{
		if (r < 0.35)
			sound (self, CHAN_VOICE, "knight/yell1.wav", 1, ATTN_NORM);
		else if (r < 0.65)
			sound (self, CHAN_VOICE, "knight/yell2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "knight/yell3.wav", 1, ATTN_NORM);
		self.voice_finished = time + 0.6;
	}
};

void()	knight_stand1	=[	$stand1,	knight_stand2	] {ai_stand();};
void()	knight_stand2	=[	$stand2,	knight_stand3	] {ai_stand();};
void()	knight_stand3	=[	$stand3,	knight_stand4	] {ai_stand();};
void()	knight_stand4	=[	$stand4,	knight_stand5	] {ai_stand();};
void()	knight_stand5	=[	$stand5,	knight_stand6	] {ai_stand();};
void()	knight_stand6	=[	$stand6,	knight_stand7	] {ai_stand();};
void()	knight_stand7	=[	$stand7,	knight_stand8	] {ai_stand();};
void()	knight_stand8	=[	$stand8,	knight_stand9	] {ai_stand();};
void()	knight_stand9	=[	$stand9,	knight_stand1	] {ai_stand();};

void()	knight_standing1	=[	$standing1,	knight_standing2	] {ai_stand();frameskip(0.2);};
void()	knight_standing2	=[	$standing2,	knight_standing3	] {ai_stand();frameskip(0.2);};
void()	knight_standing3	=[	$standing3,	knight_standing4	] {ai_stand();frameskip(0.2);};
void()	knight_standing4	=[	$standing4,	knight_standing1	] {ai_stand();frameskip(0.2);};

void()	knight_walk1	=[	$walk1,		knight_walk2	] {ai_walk(4);self.th_stand = knight_stand1;};
void()	knight_walk2	=[	$walk2,		knight_walk3	] {ai_walk(4);};
void()	knight_walk3	=[	$walk3,		knight_walk4	] {ai_walk(4);};
void()	knight_walk4	=[	$walk4,		knight_walk5	] {ai_walk(4);};
void()	knight_walk5	=[	$walk5,		knight_walk6	] {ai_walk(4);};
void()	knight_walk6	=[	$walk6,		knight_walk7	] {ai_walk(4);};
void()	knight_walk7	=[	$walk7,		knight_walk8	] {ai_walk(4);};
void()	knight_walk8	=[	$walk8,		knight_walk9	] {ai_walk(4);};
void()	knight_walk9	=[	$walk9,		knight_walk10	] {ai_walk(4);};
void()	knight_walk10	=[	$walk10,	knight_walk11	] {ai_walk(4);};
void()	knight_walk11	=[	$walk11,	knight_walk12	] {ai_walk(4);};
void()	knight_walk12	=[	$walk12,	knight_walk13	] {ai_walk(4);};
void()	knight_walk13	=[	$walk13,	knight_walk14	] {ai_walk(4);};
void()	knight_walk14	=[	$walk14,	knight_walk1	] {ai_walk(4);};

void()	knight_run1	=[	$runb1,		knight_run2	] {ai_walk(8);self.th_stand = knight_stand1;};
void()	knight_run2	=[	$runb2,		knight_run3	] {ai_walk(8);};
void()	knight_run3	=[	$runb3,		knight_run4	] {ai_walk(8);};
void()	knight_run4	=[	$runb4,		knight_run5	] {ai_walk(8);};
void()	knight_run5	=[	$runb5,		knight_run6	] {ai_walk(8);};
void()	knight_run6	=[	$runb6,		knight_run7	] {ai_walk(8);};
void()	knight_run7	=[	$runb7,		knight_run8	] {ai_walk(8);};
void()	knight_run8	=[	$runb8,		knight_run1	] {ai_walk(8);};

void()	knight_atk1	=[	$attackb3,		knight_atk2	] {BlockCancel();knight_yell();sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);};
void()	knight_atk2	=[	$attackb4,		knight_atk3	] {BlockCancel();};
void()	knight_atk3	=[	$attackb5,		knight_atk4	] {BlockCancel();};
void()	knight_atk4	=[	$attackb6,		knight_atk5	] {BlockCancel();};
void()	knight_atk5	=[	$attackb7,		knight_atk6	] {BlockCancel();};
void()	knight_atk6	=[	$attackb8,		knight_atk7	] {BlockCancel();FireMelee(8,10,0,50,0,0,0,FALSE,0,0);};
void()	knight_atk7	=[	$attackb9,		knight_atk8] {BlockCancel();};
void()	knight_atk8 	=[	$attackb10,		knight_walk1] {BlockCancel();};

void()	knight_atkb1	=[	$runattack1,		knight_atkb2	] {BlockCancel();ai_forward(6);knight_yell();frameskip(0.08);};
void()	knight_atkb2	=[	$runattack2,		knight_atkb3	] {BlockCancel();ai_forward(6);frameskip(0.08);};
void()	knight_atkb3	=[	$runattack3,		knight_atkb4	] {BlockCancel();ai_forward(6);frameskip(0.08);};
void()	knight_atkb4	=[	$runattack4,		knight_atkb5	] {BlockCancel();ai_forward(6);frameskip(0.08);};
void()	knight_atkb5	=[	$runattack5,		knight_atkb6	] {BlockCancel();ai_forward(6);sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);frameskip(0.08);};
void()	knight_atkb6	=[	$runattack6,		knight_atkb7	] {BlockCancel();ai_forward(6);frameskip(0.08);};
void()	knight_atkb7	=[	$runattack7,		knight_atkb8	] {BlockCancel();ai_forward(6);frameskip(0.08);};
void()	knight_atkb8	=[	$runattack8,		knight_atkb9	] 
{
	BlockCancel();
	ai_forward(6);
	frameskip(0.08);
	self.status_broken_finished = time + 8;
	FireMelee(16,10,3,50,5,0,0,FALSE,0,0.1);
};
void()	knight_atkb9	=[	$runattack9,		knight_atkb10	] {BlockCancel();ai_forward(6);frameskip(0.08);};
void()	knight_atkb10	=[	$runattack10,		knight_atkb11	] {BlockCancel();ai_forward(6);frameskip(0.08);};
void()	knight_atkb11	=[	$runattack11,		knight_walk1	] {BlockCancel();ai_forward(6);frameskip(0.08);};

void()	knight_pain1	=[	$pain1,		knight_pain2	] {self.nextthink = time + 0.3;monster_removeslide();};
void()	knight_pain2	=[	$pain2,		knight_pain3	] {BlockCancel();monster_removeslide();};
void()	knight_pain3	=[	$pain3,		knight_walk1	] {monster_removeslide();};

void()	knight_painb1	=[	$painb1,	knight_painb2	] {monster_removeslide();};
void()	knight_painb2	=[	$painb2,	knight_painb3	] {BlockCancel();monster_removeslide();};
void()	knight_painb3	=[	$painb3,	knight_painb4	] {BlockCancel();monster_removeslide();};
void()	knight_painb4	=[	$painb4,	knight_painb5	] {BlockCancel();monster_removeslide();};
void()	knight_painb5	=[	$painb5,	knight_painb6	] {BlockCancel();monster_removeslide();};
void()	knight_painb6	=[	$painb6,	knight_painb7	] {BlockCancel();monster_removeslide();};
void()	knight_painb7	=[	$painb7,	knight_painb8	] {BlockCancel();monster_removeslide();};
void()	knight_painb8	=[	$painb8,	knight_painb9	] {monster_removeslide();};
void()	knight_painb9	=[	$painb9,	knight_painb10	] {monster_removeslide();};
void()	knight_painb10	=[	$painb10,	knight_painb11	] {monster_removeslide();};
void()	knight_painb11	=[	$painb11,	knight_walk1	] {monster_removeslide();};

void() knight_pain =
{
	local float r, h;

	r = h = random();

	monster_pain(self.enemy);

	if (h < 0.35)
		sound (self, CHAN_VOICE, "knight/pain1.wav", 1, ATTN_NORM);
	else if (h < 0.75)
		sound (self, CHAN_VOICE, "knight/pain2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "knight/pain3.wav", 1, ATTN_NORM);
		
	if (r < 0.35) // pain1 is shorter, we want an easy opponent
		knight_pain1 (); 
	else
		knight_painb1 ();
};

void()	knight_die1	=[	$death1,	knight_die2	] {monster_death();};
void()	knight_die2	=[	$death2,	knight_die3	] {monster_death();};
void()	knight_die3	=[	$death3,	knight_die4	] {monster_death();};
void()	knight_die4	=[	$death4,	knight_die5	] {monster_death();};
void()	knight_die5	=[	$death5,	knight_die6	] {monster_death();};
void()	knight_die6	=[	$death6,	knight_die7	] {monster_death();};
void()	knight_die7	=[	$death7,	knight_die8	] {monster_death();};
void()	knight_die8	=[	$death8,	knight_die9	] {monster_death();};
void()	knight_die9	=[	$death9,	knight_die10] {monster_death();};
void()	knight_die10	=[	$death10,	knight_die10] {monster_death();};

void()	knight_dieb1	=[	$deathb1,	knight_dieb2	] {monster_death();};
void()	knight_dieb2	=[	$deathb2,	knight_dieb3	] {monster_death();};
void()	knight_dieb3	=[	$deathb3,	knight_dieb4	] {monster_death();};
void()	knight_dieb4	=[	$deathb4,	knight_dieb5	] {monster_death();};
void()	knight_dieb5	=[	$deathb5,	knight_dieb6	] {monster_death();};
void()	knight_dieb6	=[	$deathb6,	knight_dieb7	] {monster_death();};
void()	knight_dieb7	=[	$deathb7,	knight_dieb8	] {monster_death();};
void()	knight_dieb8	=[	$deathb8,	knight_dieb9	] {monster_death();};
void()	knight_dieb9	=[	$deathb9,	knight_dieb10] {monster_death();};
void()	knight_dieb10 = [	$deathb10,	knight_dieb11] {monster_death();};
void()	knight_dieb11 = [	$deathb11,	knight_dieb11] {monster_death();};

void() knight_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  		  // otherwise player can keep knocking corpse for EXP
		self.gaveexp = TRUE;
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		GiveExperience(self.experience);
		sound (self, CHAN_VOICE, "knight/death.wav", 1, ATTN_NORM);
	}
	if (self.damage_type == 5) // Sliced/Gored in half
	{
		sound (self, CHAN_BODY, "misc/guts.wav", 1, ATTN_NORM);
		ThrowBodyPart("progs/knig_c1.mdl");
		ThrowBodyPart("progs/knig_c2.mdl");
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
	if (random() < 0.5)
		knight_die1 ();
	else
		knight_dieb1 ();
};

void() knight_kneel1	=[	$kneel5,	knight_kneel2	] {};
void() knight_kneel2	=[	$kneel4,	knight_kneel3	] {};
void() knight_kneel3	=[	$kneel3,	knight_kneel4	] {};
void() knight_kneel4	=[	$kneel2,	knight_kneel5	] {};
void() knight_kneel5	=[	$kneel1,	knight_walk1	] {};

void() knight_jump	=[	$runb5,	knight_jump	] 
{
	if (self.flags & FL_ONGROUND)
		knight_kneel1();
};

void()	knight_grabbed1	=[	$pain3,		knight_grabbed2	] {self.grab_finished = time + 1;};
void()	knight_grabbed2	=[	$pain3,		knight_grabbed2	] 
{
	if (!self.izunatarg)
	{
		if (self.grab_finished < time || self.grabbed == FALSE)
			self.th_walk();
	}
	else
		ai_watercheck_removal();
};

/*QUAKED monster_knight (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_knight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_sound ("knight/death.wav");
	precache_sound ("knight/pain1.wav");
	precache_sound ("knight/pain2.wav");
	precache_sound ("knight/pain3.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/yell1.wav");
	precache_sound ("knight/yell2.wav");
	precache_sound ("knight/yell3.wav");

	precache_model ("progs/knight.mdl");
	precache_model ("progs/knig_c1.mdl");
	precache_model ("progs/knig_c2.mdl");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/knight.mdl");
	setsize (self, '-16 -16 -24', '16 16 40');

	if (difficulty < 2)
		self.health = 100; // regular health
	else
		self.health = 150; // hard health (50% tougher)

	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "knight";
	self.displayname = "Corrupted Knight";

	if (random() < 0.5)
		self.th_stand = knight_stand1;
	else
		self.th_stand = knight_standing1;
	
	self.th_walk = knight_walk1;
	self.th_run = knight_run1;
	self.th_melee = knight_atk1;
	self.th_missile = knight_atkb1;
	self.th_pain = knight_pain;
	self.th_grab = knight_grabbed1;
	self.th_die = knight_die;
	self.th_jump = knight_jump;
	self.experience = 18; // how much exp to give on death
	self.maxgold = 100;

	self.th_block = knight_block1;
	if (!self.ai_blockfreq) // frequency on how much the enemy blocks
	{
		if (difficulty < 2)
			self.ai_blockfreq = 0.045;
		else
			self.ai_blockfreq = 0.7;
	}

	//spawn_shadow();
	enemy_start();
};