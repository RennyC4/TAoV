/*
+--------+
|Horror  |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Horrors are flying creatures that shoot semi-homing fireballs, annoying.   |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6
$frame walk1 walk2 walk3 walk4 walk5 walk6
$frame run1 run2 run3 run4 run5 run6
$frame die1 die2 die3 die4 die5 die6
$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame pain1 pain2 pain3 pain4 pain5 pain6

void() horror_stand1	=[	$stand1,	horror_stand2	] {ai_stand();};
void() horror_stand2	=[	$stand2,	horror_stand3	] {ai_stand();};
void() horror_stand3	=[	$stand3,	horror_stand4	] {ai_stand();};
void() horror_stand4	=[	$stand4,	horror_stand5	] {ai_stand();};
void() horror_stand5	=[	$stand5,	horror_stand6	] {ai_stand();};
void() horror_stand6	=[	$stand6,	horror_stand1	] {ai_stand();};

void() horror_run1	=[	$run1,	horror_run2	] {ai_fly(35);};
void() horror_run2	=[	$run2,	horror_run3	] {ai_fly(35);};
void() horror_run3	=[	$run3,	horror_run4	] {ai_fly(35);};
void() horror_run4	=[	$run4,	horror_run5	] {ai_fly(35);};
void() horror_run5	=[	$run5,	horror_run6	] {ai_fly(35);};
void() horror_run6	=[	$run6,	horror_run1	] {ai_fly(35);};


void() horror_fireball1	=[	$attack1,	horror_fireball2	] {self.velocity = '0 0 0';sound (self, CHAN_VOICE, "horror/taunt.wav", 1, ATTN_NORM);};
void() horror_fireball2	=[	$attack2,	horror_fireball3	] {};
void() horror_fireball3	=[	$attack3,	horror_fireball4	] {};
void() horror_fireball4	=[	$attack4,	horror_fireball5	]
{
	Fireball(9,8); // damage, height
};
void() horror_fireball5	=[	$attack5,	horror_fireball6	] {};
void() horror_fireball6	=[	$attack6,	horror_run1 	] {};

void() horror_pain1	=[	$pain1,	horror_pain2	] {};
void() horror_pain2	=[	$pain2,	horror_pain3	] {};
void() horror_pain3	=[	$pain3,	horror_pain4	] {};
void() horror_pain4	=[	$pain4,	horror_pain5	] {};
void() horror_pain5	=[	$pain5,	horror_pain6	] {};
void() horror_pain6	=[	$pain6,	horror_run1 	] {};

void() horror_fireball =
{
	if (self.attack_finished < time) // prevent spam
	{
		horror_fireball1();
		self.attack_finished = time + 1;
	}
};


void() horror_pain =
{
	self.velocity = '0 0 0';
	sound (self, CHAN_BODY, "horror/pain.wav", 1, ATTN_NORM);
	horror_pain1();
	monster_pain(self.enemy);
};

void() horror_die1	=[	$die1,	horror_die2 	] {monster_death();};
void() horror_die2	=[	$die2,	horror_die3 	] {monster_death();};
void() horror_die3	=[	$die3,	horror_die4 	] {monster_death();};
void() horror_die4	=[	$die4,	horror_die5 	] {monster_death();};
void() horror_die5	=[	$die5,	horror_die6 	] {monster_death();};
void() horror_die6	=[	$die6,	horror_die6 	] {monster_death();};

void() horror_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  // otherwise player can keep knocking corpse for EXP
		sound (self, CHAN_BODY, "horror/death.wav", 1, ATTN_NORM);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		GiveExperience(self.experience);
		self.gaveexp = TRUE;
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	horror_die1();
};

/*QUAKED monster_horror (1 0 0) (-21 -31 -16) (22 33 35)
Flying monster
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
void() monster_horror =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/horror.mdl");

	precache_sound ("horror/pain.wav");
	precache_sound ("horror/crunch.wav");
	precache_sound ("horror/death.wav");
	precache_sound ("horror/taunt.wav");

	self.movetype = MOVETYPE_FLY;
	setmodel (self, "progs/horror.mdl");
	setsize(self, '-21 -31 -16', '22 33 35');
	if (difficulty < 2)
		self.health = 75; // regular health
	else
		self.health = 113; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "horror";
	self.displayname = "Horror";
	self.experience = 31;

	self.th_stand = horror_stand1;
	self.th_run = horror_run1;
	self.th_missile = horror_fireball;
	self.th_pain = horror_pain;
	self.th_die = horror_die;

	//spawn_shadow();
	enemy_start();
};

