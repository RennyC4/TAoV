/*
+----------+
|Golem     |
+----------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Large enemy, relatively weak but can pack a mean punch                     |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10 idle11

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12

$frame punch1 punch2 punch3 punch4 punch5 punch6 punch7 punch8 punch9 punch10
$frame punch11 punch12 punch13 punch14 punch15 punch16 punch17 punch18 punch19 punch20
$frame punch21 punch22 punch23 punch24

$frame combo1 combo2 combo3 combo4 combo5 combo6 combo7 combo8 combo9 combo10
$frame combo11 combo12 combo13 combo14 combo15 combo16 combo17 combo18 combo19 combo20
$frame combo21 combo22 combo23 combo24

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12 paina13 paina14 paina15 paina16

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13 death14 death15 death16 death17 death18 death19 death20
$frame death21 death22

void()	golem_stand	=[	$idle1,	golem_stand	] 
{
	self.count = FALSE;
	if (self.walkframe >= 11)
		self.walkframe = 0;

	self.frame = $idle1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	ai_stand();
};

void()	golem_walk	=[	$walk1,		golem_walk	] 
{
	self.count = FALSE;
	if (self.walkframe >= 17)
		self.walkframe = 0;

	self.frame = $walk1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	if (self.flags & FL_ONGROUND)
	{
		// foot step sounds
		if (self.walkframe == 1 || self.walkframe == 8)
		{
			if (random() < 0.5)
				sound (self, CHAN_BODY, "golem/walk1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "golem/walk2.wav", 1, ATTN_NORM);
		}
	}

	ai_walk(2);
};

void()	golem_run	=[	$run1,		golem_run	] 
{
	self.count = FALSE;
	if (self.walkframe >= 12)
		self.walkframe = 0;

	self.frame = $run1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	if (self.flags & FL_ONGROUND)
	{
		// foot step sounds
		if (self.walkframe == 5 || self.walkframe == 12)
		{
			if (random() < 0.5)
				sound (self, CHAN_BODY, "golem/walk1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "golem/walk2.wav", 1, ATTN_NORM);
		}
	}

	ai_walk(9);
};

// Normal punch combo
void()	golem_atk	=[	$punch1,		golem_atk	] 
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
		if (self.walkframe == 5 || self.walkframe == 12 || self.walkframe == 17)
		{
			if (random() < 0.5)
				sound (self, CHAN_BODY, "golem/walk1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "golem/walk2.wav", 1, ATTN_NORM);
		}
	}

	if (self.walkframe == 6) // attack
	{
		self.status_broken_finished = time + 4;
		FireMelee(12,18,3,45,5,1,1,FALSE,0,0.22);
		sound (self, CHAN_WEAPON, "player/twoosh.wav", 1, ATTN_NORM);
	}
	if (self.walkframe == 18) // attack
	{
		self.status_broken_finished = time + 4;
		FireMelee(12,18,3,45,5,1,1,FALSE,0,0.22);
		sound (self, CHAN_WEAPON, "player/twoosh.wav", 1, ATTN_NORM);
	}

	if (self.walkframe >= 24) // break out
	{
		self.think = golem_walk;
		self.nextthink = time;
		self.walkframe = 0;
		return;
	}

	monster_removeslide();
	ai_forward(3); // push forward while attacking

	self.frame = $punch1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

// Secondary combo attack
void()	golem_atk2	=[	$combo1,		golem_atk2	] 
{
	local float check;
	
	// No stomp attack mid-air
	check = checkground(self);
	if (!check)
	{
		golem_atk();
		return;
	}
	
	// Used to set walkframe to zero on new animation
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}

	// foot step sound
	if (self.flags & FL_ONGROUND)
	{
		if (self.walkframe == 5 || self.walkframe == 12 || self.walkframe == 17)
		{
			if (random() < 0.5)
				sound (self, CHAN_BODY, "golem/walk1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "golem/walk2.wav", 1, ATTN_NORM);
		}
	}

	if (self.walkframe == 6) // attack
	{
		local entity effect, head;

		makevectors(self.angles);

		effect = spawn();
		setorigin(effect, self.origin + v_forward * 32 - v_up*8);
		setmodel(effect, "progs/grounded.mdl");
		effect.solid = SOLID_NOT;
		setsize (effect, '-21 -21 -16', '22 23 31');
		effect.movetype = MOVETYPE_STEP;
		effect.velocity_z = -999;
		effect.think = effect_think;
		effect.alpha = 0.2;
		effect.nextthink = time + 0.1;

		head = searchradius(self.origin, 60);
		while (head)
		{
			if (head.takedamage && head != self && !head.flags & FL_MONSTER && head.onground == TRUE)
			{
				head.knockback = 2; // pop Vigil in the air
				self.status_broken_finished = time + 8;
				T_Damage (head, self, self, 6, 0.22);
				if (head.classname == "player")	
					head.owner.camshake_finished = time + 0.4;
			}
			head = head.chain;
		}
		sound (self, CHAN_WEAPON, "baron/smash.wav", 1, ATTN_NORM);
	}
	
	if (self.walkframe == 10) // turn to face enemy before mid-air punch is launched
	{
		if (self.origin_x < self.enemy.origin_x)
			self.angles_y = 0;
		else
			self.angles_y = 180;
	}
	
	if (self.walkframe == 17) // attack
	{
		self.status_broken_finished = time + 4;
		FireMelee(18,15,3,50,5,1,1,FALSE,0,0.15);
		sound (self, CHAN_WEAPON, "player/twoosh.wav", 1, ATTN_NORM);
	}

	if (self.walkframe >= 24) // break out
	{
		self.think = golem_walk;
		self.nextthink = time;
		self.walkframe = 0;
		return;
	}

	monster_removeslide();
	if (self.walkframe > 9)
		ai_forward(2); // push forward while attacking
	else
		ai_forward(1); // push forward while attacking

	self.frame = $combo1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() golem_decide_atk =
{
	if (self.health > self.max_health / 2)
		golem_atk();
	else
		golem_atk2();
};

// Spawn pain rubble
void() golem_particle_think =
{
	if (self.alpha < 0.1)
	{
		remove(self);
		return;
	}
	self.alpha = self.alpha - 0.025;
	frameskip(0.1);
};

void() golem_particle =
{
	local entity spark;

	spark = spawn ();
	spark.angles_y = random() * 360;
	makevectors (spark.angles);
	spark.velocity = v_forward * (50 + random()*50);
	spark.velocity_z = 150;
	spark.owner = self;
	spark.movetype = MOVETYPE_TOSS;
	spark.solid = SOLID_NOT;
	spark.classname = "spark";
	
	if (random() < 0.25)
		setmodel (spark, "progs/rubble1.mdl");
	else if (random() < 0.65)
		setmodel (spark, "progs/rubble2.mdl");
	else
		setmodel (spark, "progs/rubble3.mdl");

	spark.alpha = 1;
	if (!spark.owner.cnt2) // pain size
		spark.scale = 0.25;
	else
		spark.scale = 1; // death size
	spark.avelocity = '250 250 250';
	
	setsize (spark, '0 0 0', '0 0 0');
	makevectors (self.angles);
	setorigin (spark, self.origin + v_up * 40);
	spark.attack_finished = time + 1;

	spark.think = golem_particle_think;
	spark.nextthink = time;
};

void()	golem_pain1 =[	$paina1,	golem_pain1	] 
{
	if (self.count == FALSE)
	{
		self.walkframe = 0;
		self.count = TRUE;
	}
	if (self.walkframe > 16)
	{
		self.walkframe = 0;
		self.th_walk();
	}

	monster_removeslide();

	self.frame = $paina1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() golem_pain =
{
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "golem/pain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "golem/pain2.wav", 1, ATTN_NORM);
	
	if (self.health != self.oldhealth)
		golem_particle();
	self.oldhealth = self.health;
	
	if (self.pain_finished < time || self.enemy.perfectguard_buff > time)
	{
		if (self.paincount > 4 || random() < 0.10 || self.enemy.perfectguard_buff > time)
		{
			golem_pain1();
			self.paincount = 0;
			self.pain_finished = time + 5;
		}
	}

	monster_pain(self.enemy);
	self.paincount = self.paincount + 1;
	monster_removeslide();
};

// death frames + thinking
void() golem_die1	=[	$death1,	golem_die1	]
{
	local float ox, oy, oz, i;
	local entity effect, fx;
	
	makevectors (self.angles);

	if (self.walkframe >= 21)
	{
		if (!self.cnt2) // initial shake when head smacks ground
			shake_camera(0.1);
			
		if (self.cnt2 == 5 || self.cnt2 == 10 || self.cnt2 == 15)
		{
			shake_camera(0.1);
			ox = self.origin_x + random() * 64 - 64;
			oy = self.origin_y;
			oz = self.origin_z - 16;

			sound (self, CHAN_BODY, "misc/explode.wav", 1, ATTN_NORM);
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_EXPLOSION);
			WriteCoord (MSG_BROADCAST, ox);
			WriteCoord (MSG_BROADCAST, oy);
			WriteCoord (MSG_BROADCAST, oz);
			
		}
		else if (self.cnt2 > 20)
		{
			self.enemy.owner.screenflash_finished = time + 0.5;

			effect = spawn();
			setorigin(effect, self.origin);
			setmodel(effect, "progs/explode1.mdl");
			effect.movetype = MOVETYPE_NOCLIP;
			effect.think = explodemodel_think;
			effect.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
			effect.nextthink = time;
			effect.alpha = 1;
			effect.solid = SOLID_NOT;
			sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);

			fx = spawn(); // special flash
			setorigin(fx, self.origin);
			setmodel(fx, "progs/efxflash.mdl");
			fx.movetype = MOVETYPE_NOCLIP;
			fx.alpha = 1;
			fx.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
			fx.think = efxflashe_think;
			fx.nextthink = time;
			fx.solid = SOLID_NOT;

			for (i = 0; i < 6; i = i+1)
				golem_particle();

			remove(self);
			return;
		}
		self.cnt2 = self.cnt2 + 1;
		self.walkframe = 21;
	}

	if (self.walkframe == 6)
		shake_camera(0.1);

	self.frame = $death1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	monster_death();
};

// start death routine
void() golem_die =
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
		sound (self, CHAN_VOICE, "golem/death.wav", 1, ATTN_NORM);
	}
	/*
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	*/
	golem_die1();
};

/*QUAKED monster_golem (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_golem =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound ("golem/walk1.wav");
	precache_sound ("golem/walk2.wav");
	precache_sound ("golem/death.wav");
	precache_sound ("golem/pain1.wav");
	precache_sound ("golem/pain2.wav");

	precache_sound ("player/twoosh.wav");
	precache_sound ("baron/smash.wav");
	precache_sound ("misc/explode.wav");

	precache_model ("progs/rubble1.mdl");
	precache_model ("progs/rubble2.mdl");
	precache_model ("progs/rubble3.mdl");
	precache_model ("progs/golem.mdl");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/golem.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (difficulty < 2)
		self.health = self.max_health = 138; // regular health
	else
		self.health = self.max_health = 207; // hard health (50% tougher)
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "golem";
	self.displayname = "Stone Golem";
	self.experience = 44;
	self.maxgold = 125;

	self.th_stand = golem_stand;
	self.th_walk = golem_walk;
	self.th_run = golem_run;
	self.th_melee = golem_decide_atk;	
	self.th_pain = golem_pain;
	self.th_die = golem_die;
	
	self.ignoreaircombo = TRUE; // Aircombos do not raise golem off ground
	self.noblood = TRUE;
	
	//spawn_shadow();
	enemy_start();
};
