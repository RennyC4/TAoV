/*
+--------+
|Grem    |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Gremlin monster that's able to lunge and is stronger then dogs             |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/     

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12 run13 run14 run15
$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 jump8 jump9 jump10 jump11 jump12 jump13 jump14 jump15 jump16
$frame attk1 attk2 attk3 attk4 attk5 attk6 attk7 attk8 attk9 attk10 attk11
$frame maul1 maul2 maul3 maul4 maul5 maul6 maul7 maul8 maul9 maul10 maul11 maul12 maul13
$frame look1 look2 look3 look4 look5 look6 look7 look8 look9 look10
$frame pain1 pain2 pain3 pain4
$frame painb1 painb2 painb3 painb4 painb5 painb6
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12
$frame flip1 flip2 flip3 flip4 flip5 flip6 flip7 flip8
$frame lunge1 lunge2 lunge3 lunge4 lunge5 lunge6 lunge7 lunge8 lunge9 lunge10 lunge11

void() grem_stand1	=[	$stand1,	grem_stand2		] 
{
	local float rs;

	ai_stand();
	if (self.voice_finished < time)
	{
		rs = rint((random() * 3) + 1);
		self.noise = "";
		if (rs == 1)
			self.noise = "gremlin/idle1.wav";
		else if (rs == 2)
			self.noise = "gremlin/idle2.wav";
		else if (rs == 3)
			self.noise = "gremlin/idle3.wav";
		else
			self.noise = "gremlin/idle4.wav";
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

		self.voice_finished = time + 5;
	}
};
void() grem_stand2	=[	$stand2,	grem_stand3		] {ai_stand();};
void() grem_stand3	=[	$stand3,	grem_stand4		] {ai_stand();};
void() grem_stand4	=[	$stand4,	grem_stand5		] {ai_stand();};
void() grem_stand5	=[	$stand5,	grem_stand6		] {ai_stand();};
void() grem_stand6	=[	$stand6,	grem_stand7		] {ai_stand();};
void() grem_stand7	=[	$stand7,	grem_stand8		] {ai_stand();};
void() grem_stand8	=[	$stand8,	grem_stand9		] {ai_stand();};
void() grem_stand9	=[	$stand9,	grem_stand10	] {ai_stand();};
void() grem_stand10	=[	$stand10,	grem_stand11	] {ai_stand();};
void() grem_stand11	=[	$stand11,	grem_stand12	] {ai_stand();};
void() grem_stand12	=[	$stand12,	grem_stand13	] {ai_stand();};
void() grem_stand13	=[	$stand13,	grem_stand14	] {ai_stand();};
void() grem_stand14	=[	$stand14,	grem_stand15	] {ai_stand();};
void() grem_stand15	=[	$stand15,	grem_stand16	] {ai_stand();};
void() grem_stand16	=[	$stand16,	grem_stand17	] {ai_stand();};
void() grem_stand17	=[	$stand17,	grem_stand1 	] {ai_stand();};

void() grem_run1	      =[	$run1,	grem_run2		] {ai_walk(10);frameskip(0.05);};
void() grem_run2	      =[	$run2,	grem_run3		] {ai_walk(10);frameskip(0.05);};
void() grem_run3	      =[	$run3,	grem_run4		] {ai_walk(10);frameskip(0.05);};
void() grem_run4	      =[	$run4,	grem_run5		] {ai_walk(10);frameskip(0.05);};
void() grem_run5	      =[	$run5,	grem_run6		] {ai_walk(10);frameskip(0.05);};
void() grem_run6	      =[	$run6,	grem_run7		] {ai_walk(10);frameskip(0.05);};
void() grem_run7	      =[	$run7,	grem_run8		] {ai_walk(10);frameskip(0.05);};
void() grem_run8	      =[	$run8,	grem_run9		] {ai_walk(10);frameskip(0.05);};
void() grem_run9	      =[	$run9,	grem_run10		] {ai_walk(10);frameskip(0.05);};
void() grem_run10	      =[	$run10,	grem_run11		] {ai_walk(10);frameskip(0.05);};
void() grem_run11	      =[	$run11,	grem_run12		] {ai_walk(10);frameskip(0.05);};
void() grem_run12	      =[	$run12,	grem_run13		] {ai_walk(10);frameskip(0.05);};
void() grem_run13	      =[	$run13,	grem_run14		] {ai_walk(10);frameskip(0.05);};
void() grem_run14	      =[	$run14,	grem_run15		] {ai_walk(10);frameskip(0.05);};
void() grem_run15	      =[	$run15,	grem_run1		] {ai_walk(10);frameskip(0.05);};

void() grem_leap_attack =
{
	FireMelee(3,0,1,30,0,0,1,TRUE,-22,0);
	if (self.flags & FL_ONGROUND)
		self.think = grem_run1;
};

void() grem_leap2;
void() grem_leap1	=[	$leap1,		grem_leap1	] 
{
	// start -
	// hack to comply with using frameskip();
	if (self.cnt >= 8)
	{
		self.cnt = 0;
		self.think = grem_leap2;
	}
	else if (self.cnt == 1)
		sound (self, CHAN_VOICE, "gremlin/leap.wav", 1, ATTN_NORM);
	self.cnt = self.cnt + 1;
	// hack to comply with using frameskip();
	// end -
};
void() grem_leap2	=[	$leap2,		grem_leap3	]
{
	makevectors (self.angles);
	self.velocity = v_forward * 400 + '0 0 150';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	grem_leap_attack();
	frameskip(0.05);
};

void() grem_leap3	      =[	$jump3,		grem_leap4	] {grem_leap_attack();frameskip(0.02);};
void() grem_leap4	      =[	$jump4,		grem_leap5	] {grem_leap_attack();frameskip(0.02);};
void() grem_leap5	      =[	$jump5,		grem_leap6	] {grem_leap_attack();frameskip(0.02);};
void() grem_leap6	      =[	$jump6,		grem_leap7	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap7	      =[	$jump7,		grem_leap8	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap8	      =[	$jump8,		grem_leap9	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap9	      =[	$jump9,		grem_leap10	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap10	=[	$jump10,		grem_leap11	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap11	=[	$jump11,		grem_leap12	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap12	=[	$jump12,		grem_leap13	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap13	=[	$jump13,		grem_leap14	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap14	=[	$jump14,		grem_leap15	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap15	=[	$jump15,		grem_leap16	] {grem_leap_attack();frameskip(0.05);};
void() grem_leap16	=[	$jump16,		grem_run1	] {grem_leap_attack();frameskip(0.05);};

void() grem_atk1  	=[	$attk1,		grem_atk2	] {monster_removeslide();};
void() grem_atk2  	=[	$attk2,		grem_atk3	] {monster_removeslide();};
void() grem_atk3  	=[	$attk3,		grem_atk4	] {monster_removeslide();};
void() grem_atk4  	=[	$attk4,		grem_atk5	] {monster_removeslide();};
void() grem_atk5  	=[	$attk5,		grem_atk6	] {monster_removeslide();};
void() grem_atk6  	=[	$attk6,		grem_atk7	] {monster_removeslide();};
void() grem_atk7  	=[	$attk7,		grem_atk8	] 
{
	monster_removeslide();
	self.status_poison_finished = time + 5;
	FireMelee(13,25,0,30,5,0,0,FALSE,0,0.1);
};
void() grem_atk8  	=[	$attk8,		grem_atk9	] {monster_removeslide();};
void() grem_atk9  	=[	$attk9,		grem_atk10	] {monster_removeslide();};
void() grem_atk10  	=[	$attk10,		grem_atk11	] {monster_removeslide();};
void() grem_atk11  	=[	$attk11,		grem_run1	] {monster_removeslide();};

void() grem_maul1  	=[	$maul1,		grem_maul2	] {frameskip(0.5);monster_removeslide();};
void() grem_maul2  	=[	$maul2,		grem_maul3	] {frameskip(0.5);monster_removeslide();};
void() grem_maul3  	=[	$maul3,		grem_maul4	] {monster_removeslide();};
void() grem_maul4  	=[	$maul4,		grem_maul5	] 
{
	monster_removeslide();
	self.status_poison_finished = time + 5;
	FireMelee(8,25,0,30,5,0,0,FALSE,0,0.1);
};
void() grem_maul5  	=[	$maul5,		grem_maul6	] {monster_removeslide();};
void() grem_maul6  	=[	$maul6,		grem_maul7	] {monster_removeslide();};
void() grem_maul7  	=[	$maul7,		grem_maul8	] {monster_removeslide();};
void() grem_maul8  	=[	$maul8,		grem_maul9	] 
{
	monster_removeslide();
	self.status_poison_finished = time + 5;
	FireMelee(6,25,0,30,5,0,0,FALSE,0,0.1);
};
void() grem_maul9  	=[	$maul9,		grem_maul10	] {};
void() grem_maul10  	=[	$maul10,		grem_maul11	] {monster_removeslide();};
void() grem_maul11  	=[	$maul11,		grem_maul12	] {monster_removeslide();};
void() grem_maul12  	=[	$maul12,		grem_maul13	] {monster_removeslide();};
void() grem_maul13  	=[	$maul13,		grem_run1	] {monster_removeslide();};

void() grem_lunge1  	=[	$lunge1,		grem_lunge2	] {monster_removeslide();};
void() grem_lunge2  	=[	$lunge2,		grem_lunge3	] {monster_removeslide();};
void() grem_lunge3  	=[	$lunge3,		grem_lunge4	] {monster_removeslide();};
void() grem_lunge4  	=[	$lunge4,		grem_lunge5	] {monster_removeslide();};
void() grem_lunge5  	=[	$lunge5,		grem_lunge6	] {monster_removeslide();};
void() grem_lunge6  	=[	$lunge6,		grem_lunge7	] {monster_removeslide();};
void() grem_lunge7  	=[	$lunge7,		grem_lunge8	] {monster_removeslide();};
void() grem_lunge8  	=[	$lunge8,		grem_lunge9	] 
{
	monster_removeslide();
	self.status_poison_finished = time + 5;
	FireMelee(22,25,1,30,5,0,0,FALSE,0,0.1);
};
void() grem_lunge9  	=[	$lunge9,		grem_lunge10	] {monster_removeslide();};
void() grem_lunge10  	=[	$lunge10,		grem_lunge11      ] {monster_removeslide();};
void() grem_lunge11  	=[	$lunge11,		grem_run1	      ] {monster_removeslide();};

void() grem_melee =
{
	local float r,s;

	r = s = random();

	if (s < 0.5)
		sound (self, CHAN_VOICE, "gremlin/attack1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "gremlin/attack2.wav", 1, ATTN_NORM);

	if (r < 0.35)
		grem_lunge1();
	else if (r < 0.75)
		grem_maul1();
	else
		grem_atk1();
};

void() grem_pain1	      =[	$pain1,	grem_pain2	      ] {monster_removeslide();};
void() grem_pain2	      =[	$pain2,	grem_pain3	      ] {monster_removeslide();};
void() grem_pain3	      =[	$pain3,	grem_pain4	      ] {monster_removeslide();};
void() grem_pain4	      =[	$pain4,	grem_run1	      ] {monster_removeslide();};

void() grem_painb1	=[	$painb1,	grem_painb2	      ] {monster_removeslide();};
void() grem_painb2	=[	$painb2,	grem_painb3	      ] {monster_removeslide();};
void() grem_painb3	=[	$painb3,	grem_painb4	      ] {monster_removeslide();};
void() grem_painb4	=[	$painb4,	grem_painb5	      ] {monster_removeslide();};
void() grem_painb5	=[	$painb5,	grem_painb6	      ] {monster_removeslide();};
void() grem_painb6	=[	$painb6,	grem_run1	      ] {monster_removeslide();};

void() grem_pain =
{
	local float rs;

	self.cnt = 0;

	rs = rint((random() * 2) + 1);
	self.noise = "";
	if (rs == 1)
		self.noise = "gremlin/pain1.wav";
	else if (rs == 2)
		self.noise = "gremlin/pain2.wav";
	else
		self.noise = "gremlin/pain3.wav";
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	if (random() > 0.5)
		grem_pain1();
	else
		grem_painb1();

	monster_pain(self.enemy);
};

void() grem_grabbed1	=[	$painb1,	grem_grabbed2	] {self.grab_finished = time + 1;};
void() grem_grabbed2	=[	$painb1,	grem_grabbed2	] 
{
	if (self.grab_finished < time || self.grabbed == FALSE)
	{
		self.th_run();
		return;
	}		
};

void() grem_death1	=[	$death1,	grem_death2		] {monster_death();};
void() grem_death2	=[	$death2,	grem_death3		] {monster_death();};
void() grem_death3	=[	$death3,	grem_death4		] {monster_death();};
void() grem_death4	=[	$death4,	grem_death5		] {monster_death();};
void() grem_death5	=[	$death5,	grem_death6		] {monster_death();};
void() grem_death6	=[	$death6,	grem_death7		] {monster_death();};
void() grem_death7	=[	$death7,	grem_death8		] {monster_death();};
void() grem_death8	=[	$death8,	grem_death9		] {monster_death();};
void() grem_death9	=[	$death9,	grem_death10	] {monster_death();};
void() grem_death10	=[	$death10,	grem_death11	] {monster_death();};
void() grem_death11	=[	$death11,	grem_death12	] {monster_death();};
void() grem_death12	=[	$death12,	grem_death12	] {monster_death();};

void() grem_deathb1	=[	$flip1,	grem_deathb2	] {monster_death();};
void() grem_deathb2	=[	$flip2,	grem_deathb3	] {monster_death();};
void() grem_deathb3	=[	$flip3,	grem_deathb4	] {monster_death();};
void() grem_deathb4	=[	$flip4,	grem_deathb5	] {monster_death();};
void() grem_deathb5	=[	$flip5,	grem_deathb6	] {monster_death();};
void() grem_deathb6	=[	$flip6,	grem_deathb7	] {monster_death();};
void() grem_deathb7	=[	$flip7,	grem_deathb8	] {monster_death();};
void() grem_deathb8	=[	$flip8,	grem_deathb8	] {monster_death();};

void() grem_die =
{
	if (random() > 0.5)
		grem_death1();
	else
		grem_deathb1();

	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{			  // otherwise player can keep knocking corpse for EXP
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "gremlin/death1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "gremlin/death2.wav", 1, ATTN_NORM);
		GiveExperience(self.experience);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		self.gaveexp = TRUE;
	}
	if (self.knockback != 2 && self.knockback != 3)
		self.velocity = '0 0 0';
};

void() grem_jump	=[	$jump6,	grem_jump	] 
{
	if (self.flags & FL_ONGROUND)
		grem_run1();
};

/*QUAKED monster_gremlin (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_gremlin =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/grem.mdl");
	precache_sound ("gremlin/idle1.wav");
	precache_sound ("gremlin/idle2.wav");
	precache_sound ("gremlin/idle3.wav");
	precache_sound ("gremlin/idle4.wav");
	precache_sound ("gremlin/attack1.wav");
	precache_sound ("gremlin/attack2.wav");
	precache_sound ("gremlin/leap.wav");
	precache_sound ("gremlin/pain1.wav");
	precache_sound ("gremlin/pain2.wav");
	precache_sound ("gremlin/pain3.wav");
	precache_sound ("gremlin/death1.wav");
	precache_sound ("gremlin/death2.wav");

	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/grem.mdl");

	if (difficulty < 2)
		self.health = 80; // regular health
	else
		self.health = 120; // hard health (50% tougher)

	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.classname = "grem";
	self.displayname = "Gremlin";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.experience = 22;
	self.maxgold = 90;

	self.th_stand = grem_stand1;
	self.th_run = grem_run1;
	self.th_pain = grem_pain;
	self.th_die = grem_die;
	self.th_grab = grem_grabbed1;
	self.th_jump = grem_jump;
	self.th_missile = grem_leap1;
	self.th_melee = grem_melee;
	
	//spawn_shadow();
	enemy_start();
};