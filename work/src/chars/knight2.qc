/*
+--------+
|Knight2 |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Knight Lv 2 is faster, can enrage, stronger attack but still basic         |
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
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8 deathb9 deathb10 deathb11

void() knight2_run1;
void() knight2_block1	=[	$kneel3,	knight2_block1	] 
{
	if (!self.enemy.owner)
		return;
		
	monster_removeslide();

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

void() knight2_yell =
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

void()	knight2_stand1	=[	$stand1,	knight2_stand2	] {ai_stand();};
void()	knight2_stand2	=[	$stand2,	knight2_stand3	] {ai_stand();};
void()	knight2_stand3	=[	$stand3,	knight2_stand4	] {ai_stand();};
void()	knight2_stand4	=[	$stand4,	knight2_stand5	] {ai_stand();};
void()	knight2_stand5	=[	$stand5,	knight2_stand6	] {ai_stand();};
void()	knight2_stand6	=[	$stand6,	knight2_stand7	] {ai_stand();};
void()	knight2_stand7	=[	$stand7,	knight2_stand8	] {ai_stand();};
void()	knight2_stand8	=[	$stand8,	knight2_stand9	] {ai_stand();};
void()	knight2_stand9	=[	$stand9,	knight2_stand1	] {ai_stand();};

void()	knight2_walk1	=[	$walk1,		knight2_walk2	] {ai_walk(6);self.th_stand = knight2_stand1;};
void()	knight2_walk2	=[	$walk2,		knight2_walk3	] {ai_walk(6);};
void()	knight2_walk3	=[	$walk3,		knight2_walk4	] {ai_walk(6);};
void()	knight2_walk4	=[	$walk4,		knight2_walk5	] {ai_walk(6);};
void()	knight2_walk5	=[	$walk5,		knight2_walk6	] {ai_walk(6);};
void()	knight2_walk6	=[	$walk6,		knight2_walk7	] {ai_walk(6);};
void()	knight2_walk7	=[	$walk7,		knight2_walk8	] {ai_walk(6);};
void()	knight2_walk8	=[	$walk8,		knight2_walk9	] {ai_walk(6);};
void()	knight2_walk9	=[	$walk9,		knight2_walk10	] {ai_walk(6);};
void()	knight2_walk10	=[	$walk10,	knight2_walk11	] {ai_walk(6);};
void()	knight2_walk11	=[	$walk11,	knight2_walk12	] {ai_walk(6);};
void()	knight2_walk12	=[	$walk12,	knight2_walk13	] {ai_walk(6);};
void()	knight2_walk13	=[	$walk13,	knight2_walk14	] {ai_walk(6);};
void()	knight2_walk14	=[	$walk14,	knight2_walk1	] {ai_walk(6);};

void()	knight2_run1	=[	$runb1,		knight2_run2	] {ai_walk(12);self.th_stand = knight2_stand1;};
void()	knight2_run2	=[	$runb2,		knight2_run3	] {ai_walk(12);};
void()	knight2_run3	=[	$runb3,		knight2_run4	] {ai_walk(12);};
void()	knight2_run4	=[	$runb4,		knight2_run5	] {ai_walk(12);};
void()	knight2_run5	=[	$runb5,		knight2_run6	] {ai_walk(12);};
void()	knight2_run6	=[	$runb6,		knight2_run7	] {ai_walk(12);};
void()	knight2_run7	=[	$runb7,		knight2_run8	] {ai_walk(12);};
void()	knight2_run8	=[	$runb8,		knight2_run1	] {ai_walk(12);};

void()	knight2_atk1	=[	$attackb3,		knight2_atk2	] 
{
	BlockCancel();
	local float b = random()*3 * 0.1;  // stagger first frame
	frameskip(0.07 + b);
};
void()	knight2_atk2	=[	$attackb4,		knight2_atk3	] {knight2_yell();sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);BlockCancel();frameskip(0.07);};
void()	knight2_atk3	=[	$attackb5,		knight2_atk4	] {BlockCancel();frameskip(0.07);};
void()	knight2_atk4	=[	$attackb6,		knight2_atk5	] {BlockCancel();frameskip(0.07);};
void()	knight2_atk5	=[	$attackb7,		knight2_atk6	] {BlockCancel();frameskip(0.07);};
void()	knight2_atk6	=[	$attackb8,		knight2_atk7	] {BlockCancel();FireMelee(14,10,0,50,0,0,0,FALSE,0,0);frameskip(0.07);};
void()	knight2_atk7	=[	$attackb9,		knight2_atk8] {BlockCancel();frameskip(0.07);};
void()	knight2_atk8 	=[	$attackb10,		knight2_walk1] {BlockCancel();frameskip(0.07);};

void()	knight2_atkb1	=[	$runattack1,		knight2_atkb2	] 
{
	BlockCancel();
	ai_forward(6);
	local float b = random()*3 * 0.1;  // stagger first frame
	frameskip(0.05 + b);
};
void()	knight2_atkb2	=[	$runattack2,		knight2_atkb3	] {BlockCancel();ai_forward(6);frameskip(0.05);knight2_yell();};
void()	knight2_atkb3	=[	$runattack3,		knight2_atkb4	] {BlockCancel();ai_forward(6);frameskip(0.05);};
void()	knight2_atkb4	=[	$runattack4,		knight2_atkb5	] {BlockCancel();ai_forward(6);frameskip(0.05);};
void()	knight2_atkb5	=[	$runattack5,		knight2_atkb6	] {BlockCancel();ai_forward(6);sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);frameskip(0.05);};
void()	knight2_atkb6	=[	$runattack6,		knight2_atkb7	] {BlockCancel();ai_forward(6);frameskip(0.05);};
void()	knight2_atkb7	=[	$runattack7,		knight2_atkb8	] {BlockCancel();ai_forward(6);frameskip(0.05);};
void()	knight2_atkb8	=[	$runattack8,		knight2_atkb9	] 
{
	BlockCancel();
	ai_forward(6);
	frameskip(0.05);
	self.status_broken_finished = time + 16;
	FireMelee(26,10,3,50,5,0,0,FALSE,0,0.2);
};
void()	knight2_atkb9	=[	$runattack9,		knight2_atkb10	] {BlockCancel();ai_forward(6);frameskip(0.05);};
void()	knight2_atkb10	=[	$runattack10,		knight2_atkb11	] {BlockCancel();ai_forward(6);frameskip(0.05);};
void()	knight2_atkb11	=[	$runattack11,		knight2_walk1	] {BlockCancel();ai_forward(6);frameskip(0.05);};

void()	knight2_pain1	=[	$pain1,		knight2_pain2	] {self.nextthink = time + 0.3;monster_removeslide();};
void()	knight2_pain2	=[	$pain2,		knight2_pain3	] {BlockCancel();monster_removeslide();};
void()	knight2_pain3	=[	$pain3,		knight2_walk1	] {monster_removeslide();};

void()	knight2_painb1	=[	$painb1,	knight2_painb2	] {monster_removeslide();};
void()	knight2_painb2	=[	$painb2,	knight2_painb3	] {BlockCancel();monster_removeslide();};
void()	knight2_painb3	=[	$painb3,	knight2_painb4	] {BlockCancel();monster_removeslide();};
void()	knight2_painb4	=[	$painb4,	knight2_painb5	] {BlockCancel();monster_removeslide();};
void()	knight2_painb5	=[	$painb5,	knight2_painb6	] {BlockCancel();monster_removeslide();};
void()	knight2_painb6	=[	$painb6,	knight2_painb7	] {BlockCancel();monster_removeslide();};
void()	knight2_painb7	=[	$painb7,	knight2_painb8	] {BlockCancel();monster_removeslide();};
void()	knight2_painb8	=[	$painb8,	knight2_painb9	] {monster_removeslide();};
void()	knight2_painb9	=[	$painb9,	knight2_painb10	] {monster_removeslide();};
void()	knight2_painb10	=[	$painb10,	knight2_painb11	] {monster_removeslide();};
void()	knight2_painb11	=[	$painb11,	knight2_walk1	] {monster_removeslide();};

void() knight2_pain =
{
	local float r, h;
	
	//
	// Enrage / Berserk
	//
	
	r = random();
	if (r <= 0.05 || self.spawnflags & 2)
	{
		if (self.health < self.max_health / 2.5 && self.mode == 0)
		{
			self.colormod = '3 1 1';
			self.berserk_finished = time + 8;
			enrage();
			self.mode = 1; // only enrage once
		}
	}

	r = h = random();

	monster_pain(self.enemy);

	if (h < 0.35)
		sound (self, CHAN_VOICE, "knight/pain1.wav", 1, ATTN_NORM);
	else if (h < 0.75)
		sound (self, CHAN_VOICE, "knight/pain2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "knight/pain3.wav", 1, ATTN_NORM);
		
	if (r < 0.60) // pain1 is shorter, we want a harder opponent
		knight2_pain1 (); 
	else
		knight2_painb1 ();
};

void()	knight2_die1	=[	$death1,	knight2_die2	] {monster_death();};
void()	knight2_die2	=[	$death2,	knight2_die3	] {monster_death();};
void()	knight2_die3	=[	$death3,	knight2_die4	] {monster_death();};
void()	knight2_die4	=[	$death4,	knight2_die5	] {monster_death();};
void()	knight2_die5	=[	$death5,	knight2_die6	] {monster_death();};
void()	knight2_die6	=[	$death6,	knight2_die7	] {monster_death();};
void()	knight2_die7	=[	$death7,	knight2_die8	] {monster_death();};
void()	knight2_die8	=[	$death8,	knight2_die9	] {monster_death();};
void()	knight2_die9	=[	$death9,	knight2_die10] {monster_death();};
void()	knight2_die10	=[	$death10,	knight2_die10] {monster_death();};

void()	knight2_dieb1	=[	$deathb1,	knight2_dieb2	] {monster_death();};
void()	knight2_dieb2	=[	$deathb2,	knight2_dieb3	] {monster_death();};
void()	knight2_dieb3	=[	$deathb3,	knight2_dieb4	] {monster_death();};
void()	knight2_dieb4	=[	$deathb4,	knight2_dieb5	] {monster_death();};
void()	knight2_dieb5	=[	$deathb5,	knight2_dieb6	] {monster_death();};
void()	knight2_dieb6	=[	$deathb6,	knight2_dieb7	] {monster_death();};
void()	knight2_dieb7	=[	$deathb7,	knight2_dieb8	] {monster_death();};
void()	knight2_dieb8	=[	$deathb8,	knight2_dieb9	] {monster_death();};
void()	knight2_dieb9	=[	$deathb9,	knight2_dieb10] {monster_death();};
void()	knight2_dieb10 = [	$deathb10,	knight2_dieb11] {monster_death();};
void()	knight2_dieb11 = [	$deathb11,	knight2_dieb11] {monster_death();};

void() knight2_die =
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
		ThrowBodyPart("progs/knig2_c1.mdl");
		ThrowBodyPart("progs/knig2_c2.mdl");
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
		knight2_die1 ();
	else
		knight2_dieb1 ();
};

void() knight2_kneel1	=[	$kneel5,	knight2_kneel2	] {};
void() knight2_kneel2	=[	$kneel4,	knight2_kneel3	] {};
void() knight2_kneel3	=[	$kneel3,	knight2_kneel4	] {};
void() knight2_kneel4	=[	$kneel2,	knight2_kneel5	] {};
void() knight2_kneel5	=[	$kneel1,	knight2_walk1	] {};

void() knight2_jump	=[	$runb5,	knight2_jump	] 
{
	if (self.flags & FL_ONGROUND)
		knight2_kneel1();
};

void()	knight2_grabbed1	=[	$pain1,		knight2_grabbed2	] {self.grab_finished = time + 1;};
void()	knight2_grabbed2	=[	$pain1,		knight2_grabbed2	] 
{
	if (!self.izunatarg)
	{
		if (self.grab_finished < time || self.grabbed == FALSE)
			self.th_walk();
	}
	else
		ai_watercheck_removal();
};

/*QUAKED monster_knight2 (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_knight2 =
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

	precache_model ("progs/knight2.mdl");
	precache_model ("progs/knig2_c1.mdl");
	precache_model ("progs/knig2_c2.mdl");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/knight2.mdl");
	setsize (self, '-16 -16 -24', '16 16 40');
	if (difficulty < 2)
		self.health = self.max_health = 150; // regular health
	else
		self.health = self.max_health = 200; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "knight2";
	self.displayname = "Corrupted Captain";

	self.th_stand = knight2_stand1;	
	self.th_walk = knight2_walk1;
	self.th_run = knight2_run1;
	self.th_melee = knight2_atk1;
	self.th_missile = knight2_atkb1;
	self.th_pain = knight2_pain;
	self.th_grab = knight2_grabbed1;
	self.th_die = knight2_die;
	self.th_jump = knight2_jump;
	self.experience = 80; // how much exp to give on death
	self.maxgold = 220;

	self.th_block = knight2_block1;
	if (!self.ai_blockfreq) // frequency on how much the enemy blocks
	{
		if (difficulty < 2)
			self.ai_blockfreq = 0.1;
		else
			self.ai_blockfreq = 0.85;
	}

	//spawn_shadow();
	enemy_start();
};