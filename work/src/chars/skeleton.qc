/*
+---------+
|Skeleton |
+---------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Reanimated corpses of dead knights, jumps around to confuse player, melee  |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame run1 run2 run3 run4 run5 run6
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17 stand18 stand19
$frame stand20 stand21 stand22
$frame pain1 pain2 pain3 pain4 pain5
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 jump8 jump9 jump10 jump11 jump12

void() skeleton_jump;

void()	skel_run1	=[	$run1,		skel_run2	] {ai_walk(15);};
void()	skel_run2	=[	$run2,		skel_run3	] {ai_walk(15);};
void()	skel_run3	=[	$run3,		skel_run4	] {ai_walk(15);};
void()	skel_run4	=[	$run4,		skel_run5	] {ai_walk(15);};
void()	skel_run5	=[	$run5,		skel_run6	] {ai_walk(15);};
void()	skel_run6	=[	$run6,		skel_run1	] {ai_walk(15);};

void()	skel_stand1	=[	$stand1,	skel_stand2	] 
{
	if (self.flags & FL_ONGROUND && self.enemy)
	{
		if (random() < 0.5)
			skeleton_jump();
	}
	ai_stand();
};
void()	skel_stand2	=[	$stand2,	skel_stand3	] {ai_stand();};
void()	skel_stand3	=[	$stand3,	skel_stand4	] {ai_stand();};
void()	skel_stand4	=[	$stand4,	skel_stand5	] {ai_stand();};
void()	skel_stand5	=[	$stand5,	skel_stand6	] {ai_stand();};
void()	skel_stand6	=[	$stand6,	skel_stand7	] {ai_stand();};
void()	skel_stand7	=[	$stand7,	skel_stand8	] {ai_stand();};
void()	skel_stand8	=[	$stand8,	skel_stand9	] {ai_stand();};
void()	skel_stand9	=[	$stand9,	skel_stand10	] {ai_stand();};
void()	skel_stand10	=[	$stand10,	skel_stand11	] {ai_stand();};
void()	skel_stand11	=[	$stand11,	skel_stand12	] {ai_stand();};
void()	skel_stand12	=[	$stand12,	skel_stand13	] {ai_stand();};
void()	skel_stand13	=[	$stand13,	skel_stand14	] {ai_stand();};
void()	skel_stand14	=[	$stand14,	skel_stand15	] {ai_stand();};
void()	skel_stand15	=[	$stand15,	skel_stand16	] {ai_stand();};
void()	skel_stand16	=[	$stand16,	skel_stand17	] {ai_stand();};
void()	skel_stand17	=[	$stand17,	skel_stand18	] {ai_stand();};
void()	skel_stand18	=[	$stand18,	skel_stand19	] {ai_stand();};
void()	skel_stand19	=[	$stand19,	skel_stand20	] {ai_stand();};
void()	skel_stand20	=[	$stand20,	skel_stand21	] {ai_stand();};
void()	skel_stand21	=[	$stand21,	skel_stand22	] {ai_stand();};
void()	skel_stand22	=[	$stand22,	skel_stand1 	] {ai_stand();};

void()	skel_atk1	=[	$attack1,		skel_atk2	] {frameskip(0.2);sound (self, CHAN_WEAPON, "skeleton/attack.wav", 1, ATTN_NORM);};
void()	skel_atk2	=[	$attack2,		skel_atk3	] {};
void()	skel_atk3	=[	$attack3,		skel_atk4	] {};
void()	skel_atk4	=[	$attack4,		skel_atk5	] {};
void()	skel_atk5	=[	$attack5,		skel_atk6	] {FireMelee(11,10,0,50,0,0,0,FALSE,0,0);};
void()	skel_atk6	=[	$attack6,		skel_atk7	] {};
void()	skel_atk7	=[	$attack7,		skel_atk8	] {};
void()	skel_atk8	=[	$attack8,		skel_run1	] {};

void()	skel_pain1	=[	$pain1,		skel_pain2	] {monster_removeslide();};
void()	skel_pain2	=[	$pain2,		skel_pain3	] {monster_removeslide();};
void()	skel_pain3	=[	$pain3,		skel_pain4	] {monster_removeslide();};
void()	skel_pain4	=[	$pain4,		skel_pain5	] {monster_removeslide();};
void()	skel_pain5	=[	$pain5,		skel_run1	] {monster_removeslide();};

void() skel_particle_think =
{
	if (self.attack_finished < time)
		remove(self);
	particle (self.origin, '0 0 0', 12, 6);
	frameskip (0.01);
};

void() skel_particle =
{
	local entity spark;

	spark = spawn ();
	spark.angles_y = random() * 360;
	makevectors (spark.angles);
	spark.velocity = v_forward * 50;
	spark.velocity_z = 250;
	spark.owner = self;
	spark.movetype = MOVETYPE_TOSS;
	spark.solid = SOLID_NOT;
	spark.classname = "spark";
	setmodel (spark, string_null);
	setsize (spark, '0 0 0', '0 0 0');
	makevectors (self.angles);
	setorigin (spark, self.origin);
	spark.attack_finished = time + 1;

	spark.think = skel_particle_think;
	spark.nextthink = time;
};

void() skel_pain =
{
	skel_particle();
	sound (self, CHAN_BODY, "skeleton/smash.wav", 1, ATTN_NORM);

	if (self.paincount > 1 || self.grab_finished > time || self.enemy.grabbed)
	{
		skel_pain1();
		self.paincount = 0;
	}

	monster_pain(self.enemy);
	self.paincount = self.paincount + 1;
};

void() SkelHead_Touch =
{
	if (other.solid == SOLID_BSP)
		sound (self, CHAN_BODY, "skeleton/bounce.wav", 1, ATTN_NORM);
};

void() SkelFinal2 =
{
	local entity head;

	head = spawn();

	head.solid = SOLID_TRIGGER;
	head.movetype = MOVETYPE_BOUNCE;

	head.angles_y = random()*360;
	makevectors (head.angles);
	head.origin_z = head.origin_z + 1;
	head.velocity = v_forward * 150 + '0 0 175';
	if (head.flags & FL_ONGROUND)
		head.flags = head.flags - FL_ONGROUND;

	head.touch = SkelHead_Touch;
	head.think = BecomeFlame;
	head.avelocity = crandom() * '0 600 0';
	head.nextthink = time + 3;

	setmodel (head, "progs/skelhead.mdl");
	setorigin (head, self.origin);
	setsize (head, '-6 -4 -1', '5 4 7');

	self.think = BecomeFlame;
	self.nextthink = time + 0.1;
};

void() SkelFinal1 =
{
	sound (self, CHAN_VOICE, "skeleton/death.wav", 1, ATTN_NORM);
	self.think = SkelFinal2;
	self.nextthink = time + 0.01;
};

void()	skel_die1	=[	$death1,	skel_die2	] {monster_death();};
void()	skel_die2	=[	$death2,	skel_die3	] {monster_death();};
void()	skel_die3	=[	$death3,	skel_die4	] {monster_death();};
void()	skel_die4	=[	$death4,	skel_die5	] {monster_death();};
void()	skel_die5	=[	$death5,	skel_die6	] {monster_death();};
void()	skel_die6	=[	$death6,	skel_die7	] {monster_death();};
void()	skel_die7	=[	$death7,	skel_die8	] {monster_death();};
void()	skel_die8	=[	$death8,	skel_die9	] {monster_death();};
void()	skel_die9	=[	$death9,	skel_die10	] {monster_death();};
void()	skel_die10	=[	$death10,	skel_die10	] 
{
	monster_death();
	if (self.flags & FL_ONGROUND)
	{
		sound (self, CHAN_BODY, "skeleton/smash.wav", 1, ATTN_NORM);
		self.think = SkelFinal1;
		self.nextthink = time + 1;
	}
};

void() skel_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  // otherwise player can keep knocking corpse for EXP
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		self.gaveexp = TRUE;
		GiveExperience(self.experience);
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	skel_die1();
};

void()	skel_jump1	=[	$jump1,	skel_jump2	] {frameskip(0.08);};
void()	skel_jump2	=[	$jump2,	skel_jump3	] {frameskip(0.08);};
void()	skel_jump3	=[	$jump3,	skel_jump4	] {frameskip(0.08);};
void()	skel_jump4	=[	$jump4,	skel_jump5	] {frameskip(0.08);};
void()	skel_jump5	=[	$jump5,	skel_jump6	] {frameskip(0.08);};
void()	skel_jump6	=[	$jump6,	skel_jump7	] {frameskip(0.08);};
void()	skel_jump7	=[	$jump7,	skel_jump8	] {frameskip(0.08);};
void()	skel_jump8	=[	$jump8,	skel_jump9	] {frameskip(0.08);};
void()	skel_jump9	=[	$jump9,	skel_jump10	] {frameskip(0.08);};
void()	skel_jump10	=[	$jump10,	skel_jump11	] {frameskip(0.08);};
void()	skel_jump11	=[	$jump11,	skel_jump12	] {frameskip(0.08);};
void()	skel_jump12	=[	$jump12,	skel_jump12	] 
{
	if (self.flags & FL_ONGROUND)
		skel_run1();
};

void() skeleton_jump =
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
		self.velocity = v_forward * 150 + '0 0 300';
		if (self.flags & FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
		skel_jump1();
		sound (self, CHAN_BODY, "player/jump.wav", 1, ATTN_NORM);
		self.cnt = time + 3;
	}
	if (check)
		remove(check);
	return;
};

void()	skel_grabbed1	=[	$pain2,		skel_grabbed2	] {self.grab_finished = time + 1;};
void()	skel_grabbed2	=[	$pain2,		skel_grabbed2	] 
{
	if (self.grab_finished < time || self.grabbed == FALSE)
	{
		self.th_run();
		return;
	}
};

/*QUAKED monster_skeleton (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_skeleton =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/skeleton.mdl");
	precache_model ("progs/skelhead.mdl");

	precache_sound ("skeleton/smash.wav");
	precache_sound ("skeleton/bounce.wav");
	precache_sound ("skeleton/attack.wav");
	precache_sound ("skeleton/death.wav");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/skeleton.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (difficulty < 2)
		self.health = 160; // regular health
	else
		self.health = 240; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "skeleton";
	self.displayname = "Skeleton";
	self.experience = 50;

	self.th_stand = skel_stand1;
	self.th_run = skel_run1;
	self.th_melee = skel_atk1;
	self.th_pain = skel_pain;
	self.th_die = skel_die;
	self.noblood = TRUE;
	self.th_grab = skel_grabbed1;
	self.th_jump = skel_jump1;

	spawn_shadow();
	enemy_start();
};
