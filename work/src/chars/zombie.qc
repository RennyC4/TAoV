/*
+-------+
|Zombie |
+------------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| zombie, ground monster that throws evil magic homing dark magic balls      |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10 stand11 stand12 stand13 stand14 stand15
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12 run13 run14 run15 run16 run17 run18 run19
$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11 atta12 atta13
$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11 attb12 attb13 attb14
$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11 attc12
$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10 paina11 paina12
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10 painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10 painc11 painc12 painc13
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12

void()	zombie_stand1	=[	$stand1,	zombie_stand2	] {ai_stand();};
void()	zombie_stand2	=[	$stand2,	zombie_stand3	]
{
	if (random() < 0.01)
	{
		if (random() < 0.5)
			sound (self, CHAN_VOICE, "zombie/idle1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "zombie/idle2.wav", 1, ATTN_NORM);
	}
	ai_stand();
};
void()	zombie_stand3	=[	$stand3,	zombie_stand4	] {ai_stand();};
void()	zombie_stand4	=[	$stand4,	zombie_stand5	] {ai_stand();};
void()	zombie_stand5	=[	$stand5,	zombie_stand6	] {ai_stand();};
void()	zombie_stand6	=[	$stand6,	zombie_stand7	] {ai_stand();};
void()	zombie_stand7	=[	$stand7,	zombie_stand8	] {ai_stand();};
void()	zombie_stand8	=[	$stand8,	zombie_stand9	] {ai_stand();};
void()	zombie_stand9	=[	$stand9,	zombie_stand10	] {ai_stand();};
void()	zombie_stand10	=[	$stand10,	zombie_stand11	] {ai_stand();};
void()	zombie_stand11	=[	$stand11,	zombie_stand12	] {ai_stand();};
void()	zombie_stand12	=[	$stand12,	zombie_stand13	] {ai_stand();};
void()	zombie_stand13	=[	$stand13,	zombie_stand14	] {ai_stand();};
void()	zombie_stand14	=[	$stand14,	zombie_stand15	] {ai_stand();};
void()	zombie_stand15	=[	$stand15,	zombie_stand1	] {ai_stand();};

void()	zombie_run1	=[	$run1,		zombie_run2	] {ai_walk(5);};
void()	zombie_run2	=[	$run2,		zombie_run3	] {ai_walk(5);};
void()	zombie_run3	=[	$run3,		zombie_run4	] {ai_walk(5);};
void()	zombie_run4	=[	$run4,		zombie_run5	] {ai_walk(5);};
void()	zombie_run5	=[	$run5,		zombie_run6	] {ai_walk(5);};
void()	zombie_run6	=[	$run6,		zombie_run7	] {ai_walk(5);};
void()	zombie_run7	=[	$run7,		zombie_run8	] {ai_walk(5);};
void()	zombie_run8	=[	$run8,		zombie_run9	] {ai_walk(5);};
void()	zombie_run9	=[	$run9,		zombie_run10	] {ai_walk(5);};
void()	zombie_run10	=[	$run10,		zombie_run11	] {ai_walk(5);};
void()	zombie_run11	=[	$run11,		zombie_run12	] {ai_walk(5);};
void()	zombie_run12	=[	$run12,		zombie_run13	] {ai_walk(5);};
void()	zombie_run13	=[	$run13,		zombie_run14	] {ai_walk(5);};
void()	zombie_run14	=[	$run14,		zombie_run15	] {ai_walk(5);};
void()	zombie_run15	=[	$run15,		zombie_run16	] {ai_walk(5);};
void()	zombie_run16	=[	$run16,		zombie_run17	] {ai_walk(5);};
void()	zombie_run17	=[	$run17,		zombie_run18	] {ai_walk(5);};
void()	zombie_run18	=[	$run18,		zombie_run1	] {ai_walk(5);};

void() DarkBallRemove =
{
	if (self.state == 0)
	{
		self.effects = 0;
		sound (self, CHAN_AUTO, "spells/dbhit.wav", 1, ATTN_NORM);
		self.state = 1;
	}

	if (self.cnt == 1)
	{
		self.scale = self.scale + 0.1;
		setorigin (self, self.enemy.origin);
	}
	else // hit wall
		self.scale = self.scale + 0.1;

	self.alpha = self.alpha - 0.01;
	if (self.alpha < 0.1)
	{
		remove(self);
		return;
	}
	frameskip(0.01);
};

void() DarkBallThink =
{
	local entity head, effect;

	head = searchradius(self.origin, 5);
	while (head)
	{
		if (head.takedamage && self.owner != head && head == self.enemy)
		{
			if (head.classname != "zombieboss")
			{
				if (head.classname == "player" && head.perfectblock > time)
				{
					if (relics & IT_RELIC11) // Stalwart PG gives mana
					{
						head.owner.mana = head.owner.mana + 10;
						head.owner.absorb_finished = time + 3;
						if (head.owner.mana > head.owner.max_mana)
							head.owner.mana = head.owner.max_mana;
					}

					if (self.origin_x > head.origin_x) // Bug fix vigil needs to face the proper angles
						head.angles_y = 0; // Block victim faces left
					else
						head.angles_y = 180; // Block victim faces right
					PerfectGuard(head);

					// Check if Vigil is close, if so allow counter
					if (range(self.owner, self.owner.enemy) == RANGE_CLOSE || range(self.owner, self.owner.enemy) == RANGE_MELEE || range(self.owner, self.owner.enemy) == RANGE_NEAR)
					{
						head.enemy = self.owner; // needed for counter attack to face the proper direction
						head.counter_finished = time + 0.5;
					}
					remove(self);
					return;
				}
				if (head.classname == "player" && head.owner)
				{
					local float r = random();
					if (self.owner.classname == "zombieboss")
					{
						self.owner.status_blind_finished = time + 20;
						T_Damage (head, self.owner, self.owner, 7, 0.5);
					}
					else
					{
						self.owner.status_blind_finished = time + 16;
						T_Damage (head, self.owner, self.owner, 3, 0.25);
					}
				}
				head.colormod = '7 0 7';
			}
			else
			{
				head.health = head.health + 8; // heal zombie boss!
				if (head.health > head.max_health / 2)
					head.health = head.max_health / 2;
			}
			self.cnt = 1; // hit somebody!
			self.velocity = '0 0 0';
			setorigin (self, head.origin);
			self.enemy = head;
			self.think = DarkBallRemove;
			self.nextthink = time;
			return;
		}
		head = head.chain;
	}

	if (self.enemy == world || self.velocity == '0 0 0' || self.enemy.health <= 0 || self.cnt2 < 0.1)
	{
		remove(self);
		return;
	}

	if (self.origin_x < self.enemy.origin_x)
		self.velocity_x = self.velocity_x + 1 * frametime * 50;
	if (self.origin_x > self.enemy.origin_x)
		self.velocity_x = self.velocity_x - 1 * frametime * 50;
	if (self.origin_y < self.enemy.origin_y)
		self.velocity_y = self.velocity_y + 1 * frametime * 50;
	if (self.origin_y > self.enemy.origin_y)
		self.velocity_y = self.velocity_y - 1 * frametime * 50;
	if (self.origin_z < self.enemy.origin_z)
		self.velocity_z = self.velocity_z + 2 * frametime * 50;
	if (self.origin_z > self.enemy.origin_z)
		self.velocity_z = self.velocity_z - 2 * frametime * 50;

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;

	self.cnt2 = self.cnt2 - 0.1;

	frameskip(0.01);
};

void(float hight) Darkball =
{
	local	entity missile;

	makevectors (self.angles);

	sound (self, CHAN_WEAPON, "spells/dbfire.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_SLIDEBOX;
	missile.classname = "darkball";
		
	// set missile speed
	makevectors (self.angles);
	missile.velocity = aim(self, 150);
	missile.velocity = missile.velocity * 150;
	missile.angles = vectoangles(missile.velocity);
	missile.avelocity = '600 300 150';
	missile.alpha = missile.scale = 1;
	missile.enemy = self.enemy;
	missile.touch = DarkBallRemove;
	missile.effects = EF_FULLBRIGHT;

	missile.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW;
	missile.light_lev = 50;
	missile.color = [.508, .1, .816];
	
	// set missile duration
	missile.think = DarkBallThink;
	missile.nextthink = time + 0.1;
	missile.cnt2 = 16; // duration

	setmodel (missile, "progs/darkball.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + v_up*hight);
	
	self.colormod = '4 0 4';
};

void()  zombie_atta1	=[	$atta1,		zombie_atta2	] {};
void()  zombie_atta2	=[	$atta2,		zombie_atta3	] {};
void()  zombie_atta3	=[	$atta3,		zombie_atta4	] {};
void()  zombie_atta4	=[	$atta4,		zombie_atta5	] {};
void()  zombie_atta5	=[	$atta5,		zombie_atta6	] {};
void()  zombie_atta6	=[	$atta6,		zombie_atta7	] {};
void()  zombie_atta7	=[	$atta7,		zombie_atta8	] {};
void()  zombie_atta8	=[	$atta8,		zombie_atta9	] {};
void()  zombie_atta9	=[	$atta9,		zombie_atta10	] {};
void()  zombie_atta10	=[	$atta10,	zombie_atta11	] {};
void()  zombie_atta11	=[	$atta11,	zombie_atta12	] {};
void()  zombie_atta12	=[	$atta12,	zombie_atta13	] {};
void()  zombie_atta13	=[	$atta13,	zombie_run1	] {Darkball(8);}; //fire

void()  zombie_attb1	=[	$attb1,		zombie_attb2	] {};
void()  zombie_attb2	=[	$attb2,		zombie_attb3	] {};
void()  zombie_attb3	=[	$attb3,		zombie_attb4	] {};
void()  zombie_attb4	=[	$attb4,		zombie_attb5	] {};
void()  zombie_attb5	=[	$attb5,		zombie_attb6	] {};
void()  zombie_attb6	=[	$attb6,		zombie_attb7	] {};
void()  zombie_attb7	=[	$attb7,		zombie_attb8	] {};
void()  zombie_attb8	=[	$attb8,		zombie_attb9	] {};
void()  zombie_attb9	=[	$attb9,		zombie_attb10	] {};
void()  zombie_attb10	=[	$attb10,	zombie_attb11	] {};
void()  zombie_attb11	=[	$attb11,	zombie_attb12	] {};
void()  zombie_attb12	=[	$attb12,	zombie_attb13	] {};
void()  zombie_attb13	=[	$attb13,	zombie_attb14	] {};
void()  zombie_attb14	=[	$attb14,	zombie_run1	] {Darkball(8);}; // fire

void()  zombie_attc1	=[	$attc1,		zombie_attc2	] {};
void()  zombie_attc2	=[	$attc2,		zombie_attc3	] {};
void()  zombie_attc3	=[	$attc3,		zombie_attc4	] {};
void()  zombie_attc4	=[	$attc4,		zombie_attc5	] {};
void()  zombie_attc5	=[	$attc5,		zombie_attc6	] {};
void()  zombie_attc6	=[	$attc6,		zombie_attc7	] {};
void()  zombie_attc7	=[	$attc7,		zombie_attc8	] {};
void()  zombie_attc8	=[	$attc8,		zombie_attc9	] {};
void()  zombie_attc9	=[	$attc9,		zombie_attc10	] {};
void()  zombie_attc10	=[	$attc10,	zombie_attc11	] {};
void()  zombie_attc11	=[	$attc11,	zombie_attc12	] {};
void()  zombie_attc12	=[	$attc12,	zombie_run1	] {Darkball(16);}; // fire

void() zombie_missile =
{
	if (self.attack_finished > time)
		return;
	
	self.attack_finished = time + 0.75;
	
	if (random() < 0.33)
		zombie_atta1();
	else if (random() < 0.66)
		zombie_attb1();
	else
		zombie_attc1();
};

void()	zombie_paina1	=[	$paina1,	zombie_paina2	] {monster_removeslide();};
void()	zombie_paina2	=[	$paina2,	zombie_paina3	] {monster_removeslide();};
void()	zombie_paina3	=[	$paina3,	zombie_paina4	] {monster_removeslide();};
void()	zombie_paina4	=[	$paina4,	zombie_paina5	] {monster_removeslide();};
void()	zombie_paina5	=[	$paina5,	zombie_paina6	] {monster_removeslide();};
void()	zombie_paina6	=[	$paina6,	zombie_paina7	] {monster_removeslide();};
void()	zombie_paina7	=[	$paina7,	zombie_paina8	] {monster_removeslide();};
void()	zombie_paina8	=[	$paina8,	zombie_paina9	] {monster_removeslide();};
void()	zombie_paina9	=[	$paina9,	zombie_paina10	] {monster_removeslide();};
void()	zombie_paina10	=[	$paina10,	zombie_paina11	] {monster_removeslide();};
void()	zombie_paina11	=[	$paina11,	zombie_paina12	] {monster_removeslide();};
void()	zombie_paina12	=[	$paina12,	zombie_run1		] {monster_removeslide();};

void()	zombie_painb1	=[	$painb1,	zombie_painb2	] {monster_removeslide();};
void()	zombie_painb2	=[	$painb2,	zombie_painb3	] {monster_removeslide();};
void()	zombie_painb3	=[	$painb3,	zombie_painb4	] {monster_removeslide();};
void()	zombie_painb4	=[	$painb4,	zombie_painb5	] {monster_removeslide();};
void()	zombie_painb5	=[	$painb5,	zombie_painb6	] {monster_removeslide();};
void()	zombie_painb6	=[	$painb6,	zombie_painb7	] {monster_removeslide();};
void()	zombie_painb7	=[	$painb7,	zombie_painb8	] {monster_removeslide();};
void()	zombie_painb8	=[	$painb8,	zombie_painb9	] {monster_removeslide();};
void()	zombie_painb9	=[	$painb9,	zombie_painb10	] {monster_removeslide();};
void()	zombie_painb10	=[	$painb10,	zombie_painb11	] {monster_removeslide();};
void()	zombie_painb11	=[	$painb11,	zombie_painb12	] {monster_removeslide();};
void()	zombie_painb12	=[	$painb12,	zombie_painb13	] {monster_removeslide();};
void()	zombie_painb13	=[	$painb13,	zombie_painb14	] {monster_removeslide();};
void()	zombie_painb14	=[	$painb14,	zombie_painb15	] {monster_removeslide();};
void()	zombie_painb15	=[	$painb15,	zombie_painb16	] {monster_removeslide();};
void()	zombie_painb16	=[	$painb16,	zombie_painb17	] {monster_removeslide();};
void()	zombie_painb17	=[	$painb17,	zombie_painb18	] {monster_removeslide();};
void()	zombie_painb18	=[	$painb18,	zombie_run1		] {monster_removeslide();};

void()	zombie_painc1	=[	$painc1,	zombie_painc2	] {monster_removeslide();};
void()	zombie_painc2	=[	$painc2,	zombie_painc3	] {monster_removeslide();};
void()	zombie_painc3	=[	$painc3,	zombie_painc4	] {monster_removeslide();};
void()	zombie_painc4	=[	$painc4,	zombie_painc5	] {monster_removeslide();};
void()	zombie_painc5	=[	$painc5,	zombie_painc6	] {monster_removeslide();};
void()	zombie_painc6	=[	$painc6,	zombie_painc7	] {monster_removeslide();};
void()	zombie_painc7	=[	$painc7,	zombie_painc8	] {monster_removeslide();};
void()	zombie_painc8	=[	$painc8,	zombie_painc9	] {monster_removeslide();};
void()	zombie_painc9	=[	$painc9,	zombie_painc10	] {monster_removeslide();};
void()	zombie_painc10	=[	$painc10,	zombie_painc11	] {monster_removeslide();};
void()	zombie_painc11	=[	$painc11,	zombie_painc12	] {monster_removeslide();};
void()	zombie_painc12	=[	$painc12,	zombie_painc13	] {monster_removeslide();};
void()	zombie_painc13	=[	$painc13,	zombie_run1	] {monster_removeslide();};

void() zombie_pain =
{
	if (self.damage_type == 2) // Hit by fire
	{
		local entity temp;

		temp = spawn ();
		temp.movetype = MOVETYPE_NOCLIP;
		temp.solid = SOLID_NOT;
		temp.classname = "3dsprite";

		temp.alpha = 0.5;
		temp.frame = 1;

		temp.effects = EF_ADDITIVE;
		temp.alpha = 0.5;
		temp.scale = 1;
		temp.angles_y = 90; // face screen
		temp.think = fireweakness_firefx_think;
		temp.nextthink = time + 0.1;

		setmodel (temp, "progs/fire_fx.mdl");
		setsize (temp, '0 0 0', '0 0 0');	
		setorigin (temp, self.origin + v_up * 16);
		spawn_color_glow(5, 3, 0, 100, temp);
	}

	if (random() < 0.5)
		sound (self, CHAN_VOICE, "zombie/pain3.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "zombie/pain4.wav", 1, ATTN_NORM);

	if (random() < 0.33)
		zombie_paina1();
	else if (random() < 0.66)
		zombie_painb1();
	else
		zombie_painc1();

	monster_pain(self.enemy);
};

void()	zombie_die1	=[	$death1,	zombie_die2	] {monster_death();};
void()	zombie_die2	=[	$death2,	zombie_die3	] {monster_death();};
void()	zombie_die3	=[	$death3,	zombie_die4	] {monster_death();};
void()	zombie_die4	=[	$death4,	zombie_die5	] {monster_death();};
void()	zombie_die5	=[	$death5,	zombie_die6	] {monster_death();};
void()	zombie_die6	=[	$death6,	zombie_die7	] {monster_death();};
void()	zombie_die7	=[	$death7,	zombie_die8	] {monster_death();};
void()	zombie_die8	=[	$death8,	zombie_die9	] {monster_death();};
void()	zombie_die9	=[	$death9,	zombie_die10	] {monster_death();};
void()	zombie_die10	=[	$death10,	zombie_die11	] {monster_death();};
void()	zombie_die11	=[	$death11,	zombie_die12	] {monster_death();};
void()	zombie_die12	=[	$death12,	zombie_die12	] 
{
	if (self.flags & FL_ONGROUND)
	{
		sound (self, CHAN_BODY, "zombie/splat.wav", 1, ATTN_NORM);
		ThrowGib("progs/gib2.mdl"); // chest
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		remove(self);
		return;
	}
	monster_death();
};

void() zombie_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{			  			  // otherwise player can keep knocking corpse for EXP
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		self.gaveexp = TRUE;
		GiveExperience(self.experience);
		sound (self, CHAN_VOICE, "zombie/death.wav", 1, ATTN_NORM);
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	zombie_die1();
};

void()	zombie_grabbed1	=[	$painb2,		zombie_grabbed2	] {self.grab_finished = time + 1;};
void()	zombie_grabbed2	=[	$painb2,		zombie_grabbed2	] 
{
	if (!self.izunatarg)
	{
		if (self.grab_finished < time || self.grabbed == FALSE)
			self.th_run();
	}
	else
		ai_watercheck_removal();
};

/*QUAKED monster_zombie (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_zombie =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/zombie.mdl");
	precache_model ("progs/darkball.mdl");
	precache_sound ("spells/dbfire.wav");
	precache_sound ("spells/dbhit.wav");
	precache_sound ("zombie/idle1.wav");
	precache_sound ("zombie/idle2.wav");
	precache_sound ("zombie/pain1.wav");
	precache_sound ("zombie/pain2.wav");
	precache_sound ("zombie/pain3.wav");
	precache_sound ("zombie/pain4.wav");
	precache_sound ("zombie/splat.wav");
	precache_sound ("zombie/death.wav");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/zombie.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (difficulty < 2)
		self.health = 150; // regular health
	else
		self.health = 225; // hard health (50% tougher)
	self.state = self.health / 3; // Hold 1/3 health value for testing in damage.qc
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "zombie";
	self.displayname = "Zombie";
	self.experience = 32;
	self.maxgold = 110;

	self.th_stand = zombie_stand1;
	self.th_run = zombie_run1;
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.th_grab = zombie_grabbed1;

	self.th_magic = zombie_missile;
	self.th_melee = zombie_missile;

	//spawn_shadow();
	enemy_start();
};
