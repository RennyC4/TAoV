/*
+--------+
|Raven   |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Ravens peck at corpses and fly away or decide to go hostile                |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10 fly11

$frame takeoff1 takeoff2 takeoff3 takeoff4 takeoff5 takeoff6 takeoff7 takeoff8
$frame takeoff9 takeoff10 takeoff11 takeoff12 

$frame eat1 eat2 eat3 eat4 eat5 eat6 eat7 eat8 eat9 eat10 eat11
$frame eat12 eat13 eat14 eat15 eat16 eat17 eat18 eat19 eat20 eat21 eat22

$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 atk9 atk10 
$frame atk11 atk12 atk13 atk14 atk15 atk16 atk17 atk18 atk19 

$frame glide1 glide2 glide3 glide4 glide5 glide6 glide7 glide8 glide9 glide10 
$frame glide11 glide12 glide13 glide14 glide15 glide16 glide17 glide18 glide19 glide20 
$frame glide21 glide22 glide23

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10
$frame stand11 stand12 stand13 stand14 stand15 stand16 stand17 stand18 stand19 stand20 
$frame stand21 stand22 stand23 stand24 stand25 stand26

void() raven_idle2;

// normal idle frames
void()	raven_idle	=[	$stand1,	raven_idle	] 
{
	self.count = FALSE;
	if (random() < 0.1)
	{
		if (random() < 0.5)
			self.angles_y = self.angles_y + 10;
		else
			self.angles_y = self.angles_y - 10;	
	}

	if (self.walkframe >= 25)
	{
		if (random() < 0.35)
		{
			raven_idle2(); // flip into eating animation
			return;
		}
		self.walkframe = 0;
	}

	if (random() < 0.05 && self.pain_finished < time)
	{
		sound (self, CHAN_VOICE, "raven/idle.wav", 1, ATTN_NORM);
		self.pain_finished = time + 3; // don't spam
	}

	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	ai_stand();
	frameskip(0.1);
};

// eating idle frames
void()	raven_idle2	=[	$eat1,	raven_idle2	] 
{
	self.count = FALSE;
	
	if (self.walkframe >= 21)
	{
		if (random() < 0.35)
		{
			raven_idle(); // flip into normal idle animation
			return;
		}
		self.walkframe = 0;
	}

	self.frame = $eat1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	ai_stand();
	frameskip(0.1);
};

// raven glides into the distance
void()	raven_glide	=[	$glide1,	raven_glide	] 
{
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}
	
	if (self.attack_finished < time)
	{
		if (self.alpha > 0)
			self.alpha = self.alpha - 0.05;
		else
		{
			remove(self);
			return;
		}
	}
	if (self.walkframe >= 22)
		self.walkframe = 0;

	self.frame = $glide1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

// Raven flies into the distance and fades away
void()	raven_flyoff	=[	$fly1,	raven_flyoff	] 
{
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}
	self.movetype = MOVETYPE_NOCLIP;
	self.effects = EF_NODEPTHTEST;

	if (self.cnt < 125)
		self.cnt = self.cnt + 2;
	else
	{
		self.count = FALSE; // switch frame
		self.think = raven_glide;
		self.nextthink = time + 0.1;
		self.cnt = 150; // cap it
		return;
	}

	makevectors (self.angles);
	self.velocity = aim(self, 200);
	self.velocity = self.velocity * 200;
	self.angles = vectoangles(self.velocity);
	self.velocity_z = self.cnt;

	if (self.walkframe == 4)
		sound (self, CHAN_BODY, "raven/flap.wav", 1, ATTN_NORM);
	
	if (self.walkframe >= 11)
		self.walkframe = 0;
		
	self.frame = $fly1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	frameskip(0.05);
};

// Raven leaves the ground, decides to fly off
void()	raven_takeoff =[	$takeoff1,	raven_takeoff	] 
{
	local float howmuch;
	howmuch = ceil(random()*10);
	
	if (self.count == FALSE)
	{
		sound (self, CHAN_VOICE, "raven/sight.wav", 1, ATTN_NORM);
		self.walkframe = 0;
		self.count = TRUE;
		self.cnt2 = ceil(random()*2); // pick a random direction to turn
	}

	if (self.walkframe >= 11) // flip to flying off
	{
		self.count = FALSE; // reset walkframe
		self.walkframe = 10; // initial frame before flip
		self.attack_finished = time + 6; // 6 seconds before alpha/removal
		self.think = raven_flyoff;
		self.nextthink = time;
		return;
	}

	makevectors (self.angles);
	self.velocity = aim(self, 150);
	self.velocity = self.velocity * 150;
	self.angles = vectoangles(self.velocity);

	if (self.cnt2 == 1)
		self.angles_y = self.angles_y + howmuch;
	else
		self.angles_y = self.angles_y - howmuch;		

	self.cnt = self.velocity_z = 25;

	// Lift off ground
	self.movetype = MOVETYPE_FLY;

	self.frame = $takeoff1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	frameskip(0.05);
};

// fight mode idle frames
void()	raven_fightidle	=[	$fly1,	raven_fightidle	] 
{
	self.count = FALSE;

	if (self.walkframe >= 11)
		self.walkframe = 0;

	if (random() < 0.05 && self.pain_finished < time)
	{
		sound (self, CHAN_VOICE, "raven/idle.wav", 1, ATTN_NORM);
		self.pain_finished = time + 3; // don't spam
	}

	self.frame = $fly1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	self.velocity = '0 0 0';

	if (self.walkframe == 4)
		sound (self, CHAN_BODY, "raven/flap.wav", 1, ATTN_NORM);

	ai_stand();
	frameskip(0.1);
};

// raven is in fight mode
void()	raven_fight	=[	$fly1,	raven_fight	] 
{
	self.count = FALSE;
	self.movetype = MOVETYPE_FLY;
	if (self.walkframe >= 11)
		self.walkframe = 0;

	self.frame = $fly1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	if (self.walkframe == 4)
		sound (self, CHAN_BODY, "raven/flap.wav", 1, ATTN_NORM);

	ai_fly(25);
	frameskip(0.1);
};

void()	raven_atk	=[	$atk1,		raven_atk	] 
{
	// Used to set walkframe to zero on new animation
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}

	if (self.walkframe >= 19)
	{
		self.walkframe = 0;
		self.think = raven_fight;
		self.nextthink = time;
		return;
		
	}
	if (self.walkframe == 4 || self.walkframe == 6 || self.walkframe == 11 || self.walkframe == 14)// attack
	{
		//float damg, float dist, float knokback, float rsize, float snd, float flsh, float ignoreair, float unblockable
		self.velocity_y = self.velocity_z = 0;
		self.velocity_x = self.velocity_x / 4; // almost halt his x velocity
		self.status_poison_finished = time + 1;
		FireMelee(3,0,0,25,0,0,1,FALSE,0,0.13);
		if (random() < 0.5)
			sound (self, CHAN_WEAPON, "raven/melee.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_WEAPON, "raven/melee2.wav", 1, ATTN_NORM);
	}

	self.frame = $atk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	frameskip(0.05);
};

void() raven_misc =
{
	if (self.nodrop == TRUE) // decal ravens always fly away
	{
		self.displayname = "Raven"; // change display name to regular raven
		self.think = raven_takeoff; // Fly off into the distance
		self.nextthink = time + 0.1;
		return;
	}

	if (random() < 0.5 || self.mode == TRUE)
	{
		// The raven is already in fight mode from before when this is called again
		// randomly he'll decide to drop the fight and fly away, coward!
		if (self.mode == TRUE && random() < 0.5)
		{
			self.mode = FALSE;
			self.think = raven_misc;
			self.nextthink = time + 0.1;
			return;
		}
		self.mode = TRUE; // Fight mode!
		self.think = raven_fight; // Decides to fight player
		self.th_stand = raven_fightidle;
		self.th_run = raven_fightidle;
		self.nextthink = time + 0.1;
	}
	else
	{
		self.displayname = "Raven"; // change display name to regular raven
		self.think = raven_takeoff; // Fly off into the distance
		self.nextthink = time + 0.1;
	}
};

void() raven_pain =
{
	self.velocity_y = self.velocity_z = 0;
	sound (self, CHAN_VOICE, "raven/pain.wav", 1, ATTN_NORM);
};

void() raven_death1 =[ $death1, raven_death2 ] {monster_death();};
void() raven_death2 =[ $death2, raven_death3 ] {monster_death();};
void() raven_death3 =[ $death3, raven_death4 ] {monster_death();};
void() raven_death4 =[ $death4, raven_death5 ] {monster_death();};
void() raven_death5 =[ $death5, raven_death6 ] {monster_death();};
void() raven_death6 =[ $death6, raven_death7 ] {monster_death();};
void() raven_death7 =[ $death7, raven_death8 ] {monster_death();};
void() raven_death8 =[ $death8, raven_death9 ] {monster_death();};
void() raven_death9 =[ $death9, raven_death10 ] {monster_death();};
void() raven_death10 =[ $death10, raven_death11 ] {monster_death();};
void() raven_death11 =[ $death11, raven_death12 ] {monster_death();};
void() raven_death12 =[ $death12, raven_death13 ] {monster_death();};
void() raven_death13 =[ $death13, raven_death13 ] {monster_death();};

void() raven_deathb1 =[ $deathb1, raven_deathb2 ] {monster_death();};
void() raven_deathb2 =[ $deathb2, raven_deathb3 ] {monster_death();};
void() raven_deathb3 =[ $deathb3, raven_deathb4 ] {monster_death();};
void() raven_deathb4 =[ $deathb4, raven_deathb5 ] {monster_death();};
void() raven_deathb5 =[ $deathb5, raven_deathb6 ] {monster_death();};
void() raven_deathb6 =[ $deathb6, raven_deathb7 ] {monster_death();};
void() raven_deathb7 =[ $deathb7, raven_deathb7 ] {monster_death();};

void() raven_die =
{
	self.effects = 0; // Remove EF_NODEPTHTEST etc..
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  		  // otherwise player can keep knocking corpse for EXP
		self.gaveexp = TRUE;
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		GiveExperience(self.experience);
		sound (self, CHAN_VOICE, "raven/death.wav", 1, ATTN_NORM);
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	if (self.movetype != MOVETYPE_STEP)
		raven_death1 ();
	else
		raven_deathb1();
};

void() monster_raven =
{
	precache_model ("progs/raven.mdl");
	precache_sound ("raven/sight.wav");
	precache_sound ("raven/flap.wav");
	precache_sound ("raven/idle.wav");
	precache_sound ("raven/melee.wav");
	precache_sound ("raven/melee2.wav");
	precache_sound ("raven/pain.wav");
	precache_sound ("raven/death.wav");
	
	setmodel (self, "progs/raven.mdl");

	self.health = 5;
	self.alpha = 1;
	self.solid = SOLID_NOT;

	self.takedamage = DAMAGE_AIM;
	self.classname = "raven";
	self.displayname = "Mad Raven";
	self.netname = "solid";
	setsize (self, '-16 -16 -24', '16 16 24');
	self.experience = 20;

	self.th_stand = raven_idle;
	self.th_misc = raven_misc;
	self.th_melee = raven_atk;
	self.th_pain = raven_pain;
	self.th_die = raven_die;
	
	spawn_shadow();
	enemy_start();
	if (self.nodrop == FALSE)
	{
		self.movetype = MOVETYPE_STEP;
		droptofloor();
	}
	else
	{
		self.movetype = MOVETYPE_NOCLIP;
		self.health = 1;
	}
};