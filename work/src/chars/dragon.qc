/*
+--------+
|Dragon  |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Dragons are powerful but cannot block nor be lifted off the ground.        |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame stand1

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19 walk20
$frame walk21 walk22 walk23 walk24 walk25 walk26 walk27 walk28 walk29 walk30
$frame walk31 walk32 walk33 walk34 walk35 walk36 walk37 walk38 walk39 walk40
$frame walk41 walk42 walk43 walk44 walk45 walk46 walk47 walk48 walk49 walk50
$frame walk51 // sheeesh....

$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10
$frame die11 die12 die13 die14 die15 die16 die17 die18 die19 die20
$frame die21 die22 die23 die24 die25 die26 die27 die28 die29 die30
$frame die31

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8 attack9 attack10
$frame attack11 attack12 attack13 attack14 attack15 attack16 1 attack8 attack19 attack20
$frame attack21 attack22 attack23 attack24 attack25 attack26 attack27 attack28 attack29 attack30

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9 pain10
$frame pain11 pain12 pain13 pain14 pain15 pain16 pain17 pain18 pain19 pain20
$frame pain21 pain22 pain23 pain24 pain25 pain26 pain27 pain28 pain29 pain30

void()	dragon_stand	=[	$stand1,	dragon_stand	] 
{
	if (random() < 0.01)
		sound (self, CHAN_VOICE, "dragon/idle.wav", 1, ATTN_NORM);
	ai_stand();
	self.count = FALSE;
};

void()	dragon_walk	=[	$walk1,		dragon_walk	] 
{
	self.count = FALSE;
	if (self.walkframe >= 51)
		self.walkframe = 0;

	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	ai_walk(3);
	frameskip(0.05);
};

void()	dragon_pain =[	$pain1,		dragon_pain	] 
{
	if (self.count == FALSE)
	{
		sound (self, CHAN_VOICE, "dragon/pain.wav", 1, ATTN_NORM);
		self.walkframe = 0;
		self.count = TRUE;
	}
	if (self.walkframe >= 30)
	{
		self.walkframe = 0;
		self.th_walk();
	}
	monster_removeslide();

	self.frame = $pain1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	frameskip(0.03);
};

void()	dragon_atk	=[	$attack1,		dragon_atk	] 
{
	// Used to set walkframe to zero on new animation
	if (self.count == FALSE)
	{
		sound (self, CHAN_VOICE, "dragon/bite.wav", 1, ATTN_NORM);
		self.walkframe = 0;
		self.count = TRUE;
	}
	
	if (self.walkframe > 30)
		self.walkframe = 0;

	if (self.walkframe == 14) // attack
	{
		self.status_broken_finished = time + 8;
		FireMelee(28,35,3,45,5,1,1,FALSE,0,0.35);
	}
	if (self.walkframe == 30) // break out
	{
		self.think = dragon_walk;
		self.nextthink = time;
		self.walkframe = 0;
		return;
	}
		
	self.frame = $attack1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	frameskip(0.05);
};

void() dragon_die1	=[	$die1,	dragon_die1	]
{
	if (self.walkframe > 30)
		self.walkframe = 30;

	self.frame = $die1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	monster_death();
};

void() dragon_die =
{
	// Used to set walkframe to zero on new animation
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}	
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  		  // otherwise player can keep knocking corpse for EXP
		self.gaveexp = TRUE;
		GiveExperience(self.experience);
		self.walkframe = 0;
		sound (self, CHAN_VOICE, "dragon/death.wav", 1, ATTN_NORM);
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	dragon_die1();
};

/*QUAKED monster_dragon (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_dragon =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound ("dragon/idle.wav");
	precache_sound ("dragon/pain.wav");
	precache_sound ("dragon/bite.wav");
	precache_sound ("dragon/death.wav");

	precache_model ("progs/dragon.mdl");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/dragon.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (difficulty < 2)
		self.health = 250; // regular health
	else
		self.health = 375; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "dragon";
	self.displayname = "Green Dragon";
	self.experience = 70;

	self.th_stand = dragon_stand;
	self.th_walk = dragon_walk;
	self.th_melee = dragon_atk;
	self.th_pain = dragon_pain;
	self.th_die = dragon_die;
	self.ignoreaircombo = TRUE; // Aircombos do not raise Dragon off ground
	
	spawn_shadow();
	enemy_start();
};
