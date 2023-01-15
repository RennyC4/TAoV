/*
+--------+
|Hydra   |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Hydra is a typical weak underwater enemy that slowly homes in and attacks. |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame hadie1 hadie2 hadie3 hadie4 hadie5 hadie6 hadie7 hadie8 hadie9 hadie10
$frame hadie11 hadie12 hadie13 hadie14 hadie15 hadie16 hadie17 hadie18 hadie19 hadie20
$frame hadie21 hadie22 hadie23 hadie24 hadie25 hadie26 hadie27 hadie28 hadie29 hadie30
$frame hadie31 hadie32 hadie33 hadie34 hadie35 hadie36

$frame hapan1 hapan2 hapan3 hapan4 hapan5 hapan6 hapan7 hapan8 hapan9 hapan10

$frame hopen1 hopen2 hopen3 hopen4 hopen5 hopen6 hopen7 hopen8

$frame hspan1 hspan2 hspan3 hspan4 hspan5 hspan6 hspan7 hspan8 hspan9 hspan10

$frame hspit1 hspit2 hspit3 hspit4 hspit5 hspit6 hspit7 hspit8 hspit9 hspit10 hspit11 hspit12

$frame hswim1 hswim2 hswim3 hswim4 hswim5 hswim6 hswim7 hswim8 hswim9 hswim10
$frame hswim11 hswim12 hswim13 hswim14 hswim15 hswim16 hswim17 hswim18 hswim19 hswim20

$frame htent1 htent2 htent3 htent4 htent5 htent6 htent7 htent8 htent9 htent10
$frame htent11 htent12 htent13 htent14 htent15 htent16 htent17 htent18 htent19 htent20
$frame htent21 htent22 htent23 htent24

void()	hydra_idle	=[	$hapan1,	hydra_idle	] 
{
	if (self.walkframe >= 10)
		self.walkframe = 0;

	self.frame = $hapan1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	if (!self.enemy.flypain)
		ai_stand();
};

void()	hydra_move	=[	$hswim1,	hydra_move	] 
{
	self.movetype = MOVETYPE_FLY; // Needs to be reinforced for some reason
	if (self.walkframe >= 20)
		self.walkframe = 0;
	if (self.walkframe == 1)
		sound (self, CHAN_BODY, "misc/swim.wav", 1, ATTN_NORM);

	self.frame = $hswim1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	ai_swim(5);
};

void()	hydra_attack	=[	$htent1,	hydra_attack	] 
{
	if (self.walkframe >= 24)
	{
		self.walkframe = 0;
		self.think = self.th_walk;
		self.nextthink = time;
		return;
	}
	if (self.walkframe == 6 || self.walkframe == 9 || self.walkframe == 6 || self.walkframe == 13 || self.walkframe == 17 || self.walkframe == 20 || self.walkframe == 22)
	{
		FireMelee(6,5,0,45,0,0,0,FALSE,0,0,0);
		sound (self, CHAN_BODY, "hydra/attack.wav", 1, ATTN_NORM);
	}

	self.frame = $htent1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	self.velocity = '0 0 0';
	frameskip(0.2);
};

void() hydra_die1	=[	$hadie1,	hydra_die1	]
{
	if (self.walkframe >= 35)
		self.walkframe = 35;
	
	if (self.cnt == TRUE) // Bob the corpse
	{
		if (self.mode == 0)
		{
			if (self.velocity_z < 5)
				self.velocity_z = self.velocity_z + 1;
			else
				self.mode = 1;
		}
		else
		{
			if (self.velocity_z > -5)
				self.velocity_z = self.velocity_z - 1;
			else
				self.mode = 0;
		}
		self.frame = $hadie1 + 35;
		frameskip(0.1);
		return;
	}

	self.frame = $hadie1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	self.velocity_x = self.velocity_y = 0;
	if (pointcontents(self.origin) == CONTENT_WATER)
		self.velocity_z = 25;
	else
	{
		self.velocity_z = self.velocity_z / 4;
		self.cnt = TRUE; // turn on bob
	}
	frameskip(0.1); // maintain with framerate
};

void() hydra_pain = 
{
	sound (self, CHAN_VOICE, "hydra/pain.wav", 1, ATTN_NORM);
};

void() hydra_die =
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
		sound (self, CHAN_VOICE, "hydra/die.wav", 1, ATTN_NORM);
	}
	self.velocity = '0 0 0';
	hydra_die1();
	monster_death();
};

/*QUAKED monster_hydra (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_hydra =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound ("hydra/die.wav");
	precache_sound ("hydra/pain.wav");
	precache_sound ("hydra/spit.wav");
	precache_sound ("hydra/attack.wav");
	
	precache_model ("progs/hydra.mdl");

	setmodel (self, "progs/hydra.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (difficulty < 2)
		self.health = 200; // regular health
	else
		self.health = 300; // hard health
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.classname = "hydra";
	self.displayname = "Hydra";
	self.flags = self.flags | FL_MONSTER | FL_SWIM;
	self.experience = 25;
	self.maxgold = 115;
	self.movetype = MOVETYPE_FLY;

	self.th_stand = hydra_idle;
	self.th_walk = hydra_move;
	self.th_melee = hydra_attack;
	self.th_pain = hydra_pain;
	self.th_die = hydra_die;
	
	//spawn_shadow();
	enemy_start();
};
