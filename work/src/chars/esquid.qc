/*
+--------+
|Esquid  |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Strange creature that fights with lightning, must be blocked               |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12
$frame death13 death14 death15 death16 death17 death18 death19 death20 death21 death22 death23
$frame death24 death25 death26 death27 death28 death29 death30
$frame move1 move2 move3 move4 move5 move6 move7 move8 move9 move10
$frame move11 move12 move13 move14 move15 move16 move17 move18 move19 move20
$frame move21 move22 move23 move24 move25 move26 move27 move28 move29 move30
$frame move31 move32 move33 move34 move35 move36 move37 move38 move39 move40
$frame move41 move42 move43 move44 move45 move46

void() esquid_particle_think =
{
	if (self.attack_finished < time)
		remove(self);
	particle (self.origin, '0 0 0', 42, 6); // blue particles
	self.nextthink = time + 0.01;
};

void() esquid_particle =
{
	local entity spark;

	sound (self, CHAN_AUTO, "esquid/pain.wav", 1, ATTN_NORM);

	spark = spawn ();
	spark.angles_y = random() * 360;
	makevectors (spark.angles);
	spark.velocity = v_forward * 50;
	spark.velocity_z = 250;
	spark.owner = self;
	spark.movetype = MOVETYPE_BOUNCE;
	spark.solid = SOLID_NOT;
	spark.classname = "spark";
	setmodel (spark, string_null);
	setsize (spark, '0 0 0', '0 0 0');
	makevectors (self.angles);
	setorigin (spark, self.origin);
	spark.attack_finished = time + 1;
				
	spark.think = esquid_particle_think;
	spark.nextthink = time + 0.01;
};

void() esquid_stand1	=[	$move1,	esquid_stand1 	] {ai_stand();};

void() esquid_run1	=[	$move1,	esquid_run2 	] {ai_walk(5);};
void() esquid_run2	=[	$move2,	esquid_run3 	] {ai_walk(5);};
void() esquid_run3	=[	$move3,	esquid_run4 	] {ai_walk(5);};
void() esquid_run4	=[	$move4,	esquid_run5 	] {ai_walk(5);};
void() esquid_run5	=[	$move5,	esquid_run6 	] {ai_walk(5);};
void() esquid_run6	=[	$move6,	esquid_run7 	] {ai_walk(5);};
void() esquid_run7	=[	$move7,	esquid_run8 	] {ai_walk(5);};
void() esquid_run8	=[	$move8,	esquid_run9 	] {ai_walk(5);};
void() esquid_run9	=[	$move9,	esquid_run10 	] {ai_walk(5);};
void() esquid_run10	=[	$move10,	esquid_run11 	] {ai_walk(5);};
void() esquid_run11	=[	$move11,	esquid_run12 	] {ai_walk(5);};
void() esquid_run12	=[	$move12,	esquid_run13 	] {ai_walk(5);};
void() esquid_run13	=[	$move13,	esquid_run14 	] {ai_walk(5);};
void() esquid_run14	=[	$move14,	esquid_run15 	] {ai_walk(5);};
void() esquid_run15	=[	$move15,	esquid_run16 	] {ai_walk(5);};
void() esquid_run16	=[	$move16,	esquid_run17 	] {ai_walk(5);};
void() esquid_run17	=[	$move17,	esquid_run18 	] {ai_walk(5);};
void() esquid_run18	=[	$move18,	esquid_run19 	] {ai_walk(5);};
void() esquid_run19	=[	$move19,	esquid_run20 	] {ai_walk(5);};
void() esquid_run20	=[	$move20,	esquid_run21 	] {ai_walk(5);};
void() esquid_run21	=[	$move21,	esquid_run22 	] {ai_walk(5);};
void() esquid_run22	=[	$move22,	esquid_run23 	] {ai_walk(5);};
void() esquid_run23	=[	$move23,	esquid_run24 	] {ai_walk(5);};
void() esquid_run24	=[	$move24,	esquid_run25 	] {ai_walk(5);};
void() esquid_run25	=[	$move25,	esquid_run26 	] {ai_walk(5);};
void() esquid_run26	=[	$move26,	esquid_run27 	] {ai_walk(5);};
void() esquid_run27	=[	$move27,	esquid_run28 	] {ai_walk(5);};
void() esquid_run28	=[	$move28,	esquid_run29 	] {ai_walk(5);};
void() esquid_run29	=[	$move29,	esquid_run30 	] {ai_walk(5);};
void() esquid_run30	=[	$move30,	esquid_run31 	] {ai_walk(5);};
void() esquid_run31	=[	$move31,	esquid_run32 	] {ai_walk(5);};
void() esquid_run32	=[	$move32,	esquid_run33 	] {ai_walk(5);};
void() esquid_run33	=[	$move33,	esquid_run34 	] {ai_walk(5);};
void() esquid_run34	=[	$move34,	esquid_run35 	] {ai_walk(5);};
void() esquid_run35	=[	$move35,	esquid_run36 	] {ai_walk(5);};
void() esquid_run36	=[	$move36,	esquid_run37 	] {ai_walk(5);};
void() esquid_run37	=[	$move37,	esquid_run38 	] {ai_walk(5);};
void() esquid_run38	=[	$move38,	esquid_run39 	] {ai_walk(5);};
void() esquid_run39	=[	$move39,	esquid_run40 	] {ai_walk(5);};
void() esquid_run40	=[	$move40,	esquid_run41 	] {ai_walk(5);};
void() esquid_run41	=[	$move41,	esquid_run42	] {ai_walk(5);};
void() esquid_run42	=[	$move42,	esquid_run43	] {ai_walk(5);};
void() esquid_run43	=[	$move43,	esquid_run44	] {ai_walk(5);};
void() esquid_run44	=[	$move44,	esquid_run45	] {ai_walk(5);};
void() esquid_run45	=[	$move45,	esquid_run46	] {ai_walk(5);};
void() esquid_run46	=[	$move46,	esquid_run1	      ] {ai_walk(5);};

void() esquid_pain =
{
	monster_removeslide();
	esquid_particle();
	monster_pain(self.enemy);
};

// particle spray
void() esquid_death1	=[	$death1,	esquid_death2 	] {monster_death();};
void() esquid_death2	=[	$death2,	esquid_death3 	] {monster_death();};
void() esquid_death3	=[	$death3,	esquid_death4 	] {monster_death();};
void() esquid_death4	=[	$death4,	esquid_death5 	] {monster_death();};
void() esquid_death5	=[	$death5,	esquid_death6 	] {monster_death();};
void() esquid_death6	=[	$death6,	esquid_death7 	] {monster_death();};
void() esquid_death7	=[	$death7,	esquid_death8 	] {monster_death();esquid_particle();};
void() esquid_death8	=[	$death8,	esquid_death9 	] {monster_death();};
void() esquid_death9	=[	$death9,	esquid_death10 	] {monster_death();esquid_particle();};
void() esquid_death10	=[	$death10,	esquid_death11 	] {monster_death();};
void() esquid_death11	=[	$death11,	esquid_death12 	] {monster_death();esquid_particle();};
void() esquid_death12	=[	$death12,	esquid_death13 	] {monster_death();};
void() esquid_death13	=[	$death13,	esquid_death14 	] {monster_death();esquid_particle();};
void() esquid_death14	=[	$death14,	esquid_death15 	] {monster_death();};
void() esquid_death15	=[	$death15,	esquid_death16 	] {monster_death();esquid_particle();};
void() esquid_death16	=[	$death16,	esquid_death17 	] {monster_death();};
void() esquid_death17	=[	$death17,	esquid_death18 	] {monster_death();esquid_particle();};
void() esquid_death18	=[	$death18,	esquid_death19 	] {monster_death();};
void() esquid_death19	=[	$death19,	esquid_death20 	] {monster_death();esquid_particle();};
void() esquid_death20	=[	$death20,	esquid_death21 	] {monster_death();};
void() esquid_death21	=[	$death21,	esquid_death22 	] {monster_death();esquid_particle();};
void() esquid_death22	=[	$death22,	esquid_death23 	] {monster_death();};

// deflate
void() esquid_death23	=[	$death23,	esquid_death24 	] 
{
	sound (self, CHAN_AUTO, "esquid/deflate.wav", 1, ATTN_NORM);
	monster_death();
};
void() esquid_death24	=[	$death24,	esquid_death25 	] {monster_death();};
void() esquid_death25	=[	$death25,	esquid_death26 	] {monster_death();};
void() esquid_death26	=[	$death26,	esquid_death27 	] {monster_death();};
void() esquid_death27	=[	$death27,	esquid_death28 	] {monster_death();};
void() esquid_death28	=[	$death28,	esquid_death29 	] {monster_death();};
void() esquid_death29	=[	$death29,	esquid_death30 	] {monster_death();};
void() esquid_death30	=[	$death30,	esquid_death30 	] {monster_death();};

void() esquid_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  // otherwise player can keep knocking corpse for EXP
		GiveExperience(self.experience);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 -300 0';
		self.gaveexp = TRUE;
		sound (self, CHAN_AUTO, "esquid/death.wav", 1, ATTN_NORM);
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	esquid_death1();
};

void() lit_think =
{
	local entity head, temp, effect;
	local vector org;
	local float r;

	if (self.owner.health < 1 || self.owner.enemy.flypain || self.owner.enemy.swimming || self.owner.enemy.perfectguard_buff > time || self.owner.enemy.izunatarg)
	{
		remove(self);
		return;
	}

	if (self.frame < 3)
	{
		self.frame = self.frame + 1;
		self.alpha = self.alpha + 0.05;
	}
	else
		self.frame = 0;

	org = self.origin - v_up * 8;
	if (self.attack_finished < time)
	{
		if (self.cnt < 4)
		{
			sound (self, CHAN_BODY, "esquid/charge.wav", 1, ATTN_NORM);
			self.cnt = self.cnt + 1; // adds to 4 then unleash discharge
		}
		else
		{
			head = searchradius(self.origin, 999);
			while (head)
			{
				if (range(self, self.owner.enemy) <= RANGE_MID && visible(self.owner.enemy))
				{
					if (head.deadflag == DEAD_NO && head == self.owner.enemy)
					{
						temp = spawn ();
						temp.movetype = MOVETYPE_NOCLIP;
						temp.solid = SOLID_NOT;
						temp.classname = "sprite";
						temp.alpha = 0.5;
						r = random();
						if (r < 0.5)
							temp.frame = 0;
						else
							temp.frame = 1;

						temp.effects = EF_MUZZLEFLASH | EF_ADDITIVE;
						temp.alpha = 0.75;
						temp.angles_y = -90; // face screen
						temp.angles_z = random()*360; // random rotate
						setmodel (temp, "progs/lsprite.spr");
						setsize (temp, '0 0 0', '0 0 0');	
						setorigin (temp, head.origin);
						temp.think = SUB_Remove;
						temp.nextthink = time + 0.1;

						spawn_color_glow(0, 0, 5, 100, temp);

						if (self.origin_x > head.origin_x)
							head.angles_y = 0; // Victim faces left
						else
							head.angles_y = 180; // Victim faces right

						WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
						WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
						WriteEntity (MSG_BROADCAST, head);
						WriteCoord (MSG_BROADCAST, org_x);
						WriteCoord (MSG_BROADCAST, org_y);
						WriteCoord (MSG_BROADCAST, org_z);
						WriteCoord (MSG_BROADCAST, head.origin_x);
						WriteCoord (MSG_BROADCAST, head.origin_y);
						WriteCoord (MSG_BROADCAST, head.origin_z);

						head.knockback = 3;
						if (head.perfectblock < time)
						{
							if (head.block_finished < time)
								T_Damage (head, self, self.owner, 35,0);
							else if (head.classname == "player")
							{
								head.purge_cooldown = time;
								head.effects = EF_MUZZLEFLASH; // create light on melee impact
								sound (head, CHAN_AUTO, "player/gardcrsh.wav", 1, ATTN_NORM);
								head.think = player_blockbrk1;
								head.nextthink = time;
							}
						}
						else // perfect block sends lightning back
						{
							if (relics & IT_RELIC11) // Stalwart PG gives mana
							{
								head.owner.mana = head.owner.mana + 30;
								head.owner.absorb_finished = time + 3;
								if (head.owner.mana > head.owner.max_mana)
									head.owner.mana = head.owner.max_mana;
							}
							PerfectGuard(head);

							WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
							WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
							WriteEntity (MSG_BROADCAST, self.owner);
							WriteCoord (MSG_BROADCAST, head.origin_x);
							WriteCoord (MSG_BROADCAST, head.origin_y);
							WriteCoord (MSG_BROADCAST, head.origin_z);
							WriteCoord (MSG_BROADCAST, self.owner.origin_x);
							WriteCoord (MSG_BROADCAST, self.owner.origin_y);
							WriteCoord (MSG_BROADCAST, self.owner.origin_z);
							T_Damage (self.owner, head, head, self.owner.health, 0); // Perfect Guard one hit KO
							head.owner.combo = head.owner.combo + 1; // raise combo counter
						}
						head.knockback = 0;
						sound (self, CHAN_WEAPON, "spells/lightn.wav", 1, ATTN_NORM);
						self.owner.colormod = '1 1 10';
					}
				}
				head = head.chain;
			}
			self.cnt = 0;
			self.solid = SOLID_NOT; // Remove glowing dlight (HACK!)
			self.think = SUB_Remove;
			self.nextthink = time + 0.1;
			return;
		}
		self.attack_finished = time + 0.5;
	}
	setorigin (self, self.owner.origin - v_up*5);
	self.nextthink = time + 0.1;
};


void() esquid_lightning =
{
	if (self.attack_finished < time)
	{
		// spawn electricity charge
		local entity lit;

		lit = spawn ();
		lit.owner = self;
		lit.movetype = MOVETYPE_NOCLIP;
		lit.solid = SOLID_TRIGGER;
		lit.classname = "lit";
		setmodel (lit, "progs/esquidcr.spr");
		lit.alpha = 0;
		setsize (lit, '0 0 0', '0 0 0');
		setorigin (lit, self.origin - v_up*5);
		lit.think = lit_think;
		lit.nextthink = time + 0.1;
		
		spawn_color_glow(0, 0, 5, 100, lit);

		self.attack_finished = time + 3 + random()*6; // randomize between 3 and 6 seconds for next attack
	}
};

/*QUAKED monster_esquid (1 0 0) (-16 -16 -24) (16 16 32)
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
void() monster_esquid =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/esquid.mdl");
	precache_model ("progs/esquidcr.spr");

	precache_sound ("esquid/pain.wav");
	precache_sound ("esquid/death.wav");
	precache_sound ("esquid/deflate.wav");
	precache_sound ("esquid/charge.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/esquid.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	if (difficulty < 2)
		self.health = 215; // regular health
	else
		self.health = 247; // hard health (50% tougher)
		
	self.experience = 66;
	self.maxgold = 141;

	self.netname = "solid";
	self.takedamage = DAMAGE_YES;
	self.solid = SOLID_NOT;
	self.classname = "esquid";
	self.displayname = "Electric Squid";
	self.noblood = TRUE;
	self.th_stand = esquid_stand1;
	self.th_walk = esquid_run1;
	self.th_pain = esquid_pain;
	self.th_die = esquid_die;

	self.th_missile = esquid_lightning;

	//spawn_shadow();
	enemy_start();
};