/*
+----------+
|Werewolf  |
+----------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Big, ugly, aggressive but are vulnerable when they feel the urge to howl   |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10 idle11 idle12

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12

$frame howl_1 howl_2 howl_3 howl_4 howl_5 howl_6 howl_7 howl_8 howl_9 howl_10
$frame howl_11 howl_12 howl_13 howl_14 howl_15 howl_16 howl_17 howl_18

$frame melee1 melee2 melee3 melee4 melee5 melee6 melee7 melee8 melee9 melee10
$frame melee11 melee12

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10 leap11 leap12

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19

$frame cast1 cast2 cast3 cast4 cast5 cast6 cast7 cast8 cast9 cast10 cast11 cast12
$frame cast13 cast14 cast15 cast16


//
// Howl stupidly opening yourself up for punishment
//

void() werewolf_stand;
void()	werewolf_howl	=[	$idle1,	werewolf_howl	] 
{
	// Used to set walkframe to zero on new animation
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}

	if (self.walkframe == 3)
		sound (self, CHAN_VOICE, "werewolf/howl.wav", 1, ATTN_NORM);
		
	self.ignoreaircombo = FALSE; // Opener for air combos
	self.cnt = time + 5; // Don't over-howl

	if (self.walkframe >= 18)
	{
		werewolf_stand();
		self.walkframe = 0;
	}

	self.frame = $howl_1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	monster_removeslide();
	
	frameskip (0.15); // Slow animation down
};

void()	werewolf_stand	=[	$idle1,	werewolf_stand	] 
{
	// Only turn back on when you're on the ground
	if (self.flags & FL_ONGROUND)
		self.ignoreaircombo = TRUE;

	self.count = FALSE;
	if (self.walkframe >= 12)
		self.walkframe = 0;

	self.frame = $idle1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	ai_stand();

	if (random() < 0.035 && self.cnt < time)
	{
		sound (self, CHAN_VOICE, "werewolf/idle.wav", 1, ATTN_NORM);
		werewolf_howl();
	}
};

void()	werewolf_walk	=[	$walk1,		werewolf_walk	] 
{
	self.count = FALSE;
	if (self.walkframe >= 12)
		self.walkframe = 0;

	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	if (random() < 0.035 && self.cnt < time)
		werewolf_howl();
	
	if (self.flags & FL_ONGROUND)
	{
		// foot step sounds
		if (self.walkframe == 3 || self.walkframe == 9)
		{
			if (random() < 0.5)
				sound (self, CHAN_BODY, "werewolf/walk1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "werewolf/walk2.wav", 1, ATTN_NORM);
		}
		self.ignoreaircombo = TRUE;	// Only turn back on when you're on the ground
	}

	ai_walk(6);
	frameskip(0.05);
};

void()	werewolf_run	=[	$run1,		werewolf_run	] 
{
	self.count = FALSE;
	if (self.walkframe >= 12)
		self.walkframe = 0;

	self.frame = $run1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	if (self.flags & FL_ONGROUND)
	{
		// foot step sounds
		if (self.walkframe == 3 || self.walkframe == 9)
		{
			if (random() < 0.5)
				sound (self, CHAN_BODY, "werewolf/walk1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "werewolf/walk2.wav", 1, ATTN_NORM);
		}
		self.ignoreaircombo = TRUE;	// Only turn back on when you're on the ground
	}

	ai_walk(12);
	frameskip(0.05);
};

void()	werewolf_atk	=[	$melee1,		werewolf_atk	] 
{
	// Used to set walkframe to zero on new animation
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}

	// foot step sound
	if (self.flags & FL_ONGROUND)
	{
		if (self.walkframe == 0 || self.walkframe == 5)
		{
			if (random() < 0.5)
				sound (self, CHAN_BODY, "werewolf/walk1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "werewolf/walk2.wav", 1, ATTN_NORM);
		}
	}

	if (self.walkframe == 4) // attack
	{
		self.status_broken_finished = time + 8;
		FireMelee(21,35,3,45,5,1,1,FALSE,0,0.15);
		sound (self, CHAN_WEAPON, "player/twoosh.wav", 1, ATTN_NORM);
		sound (self, CHAN_VOICE, "werewolf/attack.wav", 1, ATTN_NORM);
	}
	if (self.walkframe == 8) // attack
	{
		self.status_broken_finished = time + 8;
		FireMelee(21,35,3,45,5,1,1,FALSE,0,0.15);
		sound (self, CHAN_WEAPON, "player/twoosh.wav", 1, ATTN_NORM);
		sound (self, CHAN_VOICE, "werewolf/attack.wav", 1, ATTN_NORM);
	}

	if (self.walkframe >= 12) // break out
	{
		self.think = werewolf_walk;
		self.nextthink = time;
		self.walkframe = 0;
		return;
	}

	monster_removeslide();
	ai_forward(10); // push forward while attacking

	self.frame = $melee1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	frameskip(0.125);
};

// short pain sequence, over half health
void()	werewolf_paina =[	$paina1,	werewolf_paina	] 
{
	monster_removeslide();
	monster_pain(self.enemy);
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}
	if (self.walkframe > 9)
	{
		self.walkframe = 0;
		self.th_walk();
	}

	self.frame = $paina1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

// long pain sequence when low health
void()	werewolf_painb =[	$painb1,	werewolf_painb	] 
{
	monster_removeslide();
	monster_pain(self.enemy);
	if (self.count == FALSE)
	{
		// Sound
		self.walkframe = 0;
		self.count = TRUE;
	}
	if (self.walkframe > 19)
	{
		self.walkframe = 0;
		self.th_walk();
	}

	self.frame = $painb1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

// logic to decide which pain animation to play
void() werewolf_pain_decide =
{
	monster_removeslide();
	sound (self, CHAN_VOICE, "werewolf/pain.wav", 1, ATTN_NORM);

	if (self.ignoreaircombo == FALSE)
	{
		werewolf_painb();
		return;
	}
		
	if (self.health > 99)
		werewolf_paina();
	else
	{
		if (random() <= 0.5)
			werewolf_painb();
		else
			werewolf_paina();
	}
};

// death frames + thinking
void() werewolf_die1	=[	$death1,	werewolf_die1	]
{
	if (self.walkframe >= 12)
		self.walkframe = 12;

	self.frame = $death1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	monster_death();
};

// start death routine
void() werewolf_die =
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
		sound (self, CHAN_VOICE, "dog/cry.wav", 1, ATTN_NORM);
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	werewolf_die1();
};

/*QUAKED monster_werewolf (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_werewolf =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound ("player/twoosh.wav");
	precache_sound ("dog/cry.wav");
	precache_sound ("werewolf/walk1.wav");
	precache_sound ("werewolf/walk2.wav");
	precache_sound ("werewolf/pain.wav");
	precache_sound ("werewolf/idle.wav");
	precache_sound ("werewolf/attack.wav");
	precache_sound ("werewolf/howl.wav");
	precache_model ("progs/werewolf.mdl");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/werewolf.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (difficulty < 2)
		self.health = 200; // regular health
	else
		self.health = 300; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "werewolf";
	self.displayname = "Werewolf";
	self.experience = 77;

	self.th_stand = werewolf_stand;
	self.th_walk = werewolf_walk;
	self.th_run = werewolf_run;
	self.th_melee = werewolf_atk;
	self.th_pain = werewolf_pain_decide;
	self.th_die = werewolf_die;
	self.ignoreaircombo = TRUE; // Aircombos do not raise werewolf off ground
	
	//spawn_shadow();
	enemy_start();
};