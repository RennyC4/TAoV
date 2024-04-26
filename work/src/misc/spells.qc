/*
+--------+
|Impulses|
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Every TAoV spell for monsters / player is located here.                    |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

.float beams_shot;
.float elebeamSound_finished;
.float lcount; // lightning count
.float tcount; // twister count

void() chargeparticle_think =
{
	if (self.attack_finished < time || !self.owner)
	{
		remove(self);
		return;
	}

	if (self.cnt == 0) // charge particles for Ice Field
		setmodel (self, "progs/s_bluep.spr");
	else // charge particles for Elemental Beam
		setmodel (self, "progs/s_redp.spr");

	if (self.origin_x < self.owner.origin_x)
		self.velocity_x = self.velocity_x + 25 * (frametime * 100);
	if (self.origin_x > self.owner.origin_x)
		self.velocity_x = self.velocity_x - 25 * (frametime * 100);
	if (self.origin_y < self.owner.origin_y)
		self.velocity_y = self.velocity_y + 25 * (frametime * 100);
	if (self.origin_y > self.owner.origin_y)
		self.velocity_y = self.velocity_y - 25 * (frametime * 100);
	if (self.origin_z < self.owner.origin_z)
		self.velocity_z = self.velocity_z + 25 * (frametime * 100);
	if (self.origin_z > self.owner.origin_z)
		self.velocity_z = self.velocity_z - 25 * (frametime * 100);

	frameskip(0.01);
};

void(float w) spawn_chargeparticle =
{
	local entity part;

	local float x,y,z;

	x = random() * 128 - 64;
	y = random() * 128 - 64;
	z = random() * 128 - 64;

	part = spawn();
	part.owner = self;
	part.movetype = MOVETYPE_NOCLIP;
	part.solid = SOLID_NOT;
	part.classname = "particle";
	part.effects = EF_NODEPTHTEST;
	setorigin (part, self.owner.origin + v_forward*x + v_up*y + v_right*z);
	part.attack_finished = time + 0.1;

	part.cnt = w; // store and use

	part.think = chargeparticle_think;
	part.nextthink = time;// + 0.01;
};

//*
// magic fog
//*

void() spawn_magicfog =
{
	local vector org;
	local entity s;

	s = spawn ();
	org = self.origin;
	s.origin = org;
	s.nextthink = time + 0.1;
	s.think = SUB_Remove;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};





// FIRE BALL






void() FireBall_HitBox =
{
	local entity head, effect;

	head = searchradius(self.origin, 25); // hit box size from origin point
	while (head)
	{
		if (head.takedamage && head.deadflag != DEAD_DEAD && self.owner != head && head.perfectguard_buff < time && (self.owner.flags & FL_MONSTER && !head.flags & FL_MONSTER || !self.owner.flags & FL_MONSTER))
		{
			effect = spawn();
			setorigin(effect, head.origin + v_up * 14);
			setmodel(effect, "progs/fire.spr");
			effect.movetype = MOVETYPE_NONE;
			effect.think = firesprite_think;
	
			effect.nextthink = time;
			effect.solid = SOLID_NOT;
			if (deathmatch == TRUE) // deathmatch damage is divided by 3
				self.mode = self.mode / 3;
			if (head.block_finished < time)
			{
				head.knockback = 0;
				head.damage_type = 2; // Fire based damage
				if (head.classname != "dragon") // dragon's are immune to fireball
				{
					if (head.classname == "ethskull" || head.classname == "ghost" || head.classname == "ghost2" || head.classname == "ghoul" || head.classname == "lesserwraith"
					|| head.classname == "wraith" || head.classname == "zombie" || head.classname == "zombieboss" || head.classname == "skeleton") // undead enemies slightly damaged more
						T_Damage (head, self, self.owner, self.mode * 1.25, 0);
					else if (head.classname == "merman") // double damage on Merman
						T_Damage (head, self, self.owner, self.mode * 2, 0);
					else if (head.classname == "golem") // golems are resistant
						T_Damage (head, self, self.owner, self.mode / 3, 0);
					else if (head.classname == "sgknight") // SGK is very resistant
						T_Damage (head, self, self.owner, self.mode / 4, 0);
					else // normal damage
						T_Damage (head, self, self.owner, self.mode, 0);
					if (head.origin_x < self.owner.origin_x) // Overwrite monster_pain angle_y turning
						head.angles_y = 0;
					else
						head.angles_y = 180;
				}
				if (self.owner.classname == "player")
				{
					self.owner.owner.combo = self.owner.owner.combo + 1; // raise combo counter
					self.owner.enemy = head; // FIX: Fireball casted again tracks the same target
				}

				if (head.classname == "player")
					head.colormod = '5 2.5 0';
			}
			else
			{
				if (range(self.owner, self.owner.enemy) == RANGE_CLOSE || range(self.owner, self.owner.enemy) == RANGE_MELEE || range(self.owner, self.owner.enemy) == RANGE_NEAR)
				{
					head.enemy = self.owner; // needed for counter attack to face the proper direction
					head.counter_finished = time + 0.5;
				}
				if (head.perfectblock > time)
				{
					if (head.owner && relics & IT_RELIC11) // Reward mana
					{
						head.owner.mana = head.owner.mana + 10;
						head.owner.absorb_finished = time + 3;
						if (head.owner.mana > head.owner.max_mana)
							head.owner.mana = head.owner.max_mana;
					}
					PerfectGuard(head);
					remove(self);
					return;
				}
				head.purge_cooldown = time;
			}
			sound (self, CHAN_AUTO, "spells/fhit.wav", 1, ATTN_NORM);
			spawn_embers();
			remove(self);
			return;
		}
		head = head.chain;
	}
};


.float fireballhome_finished;
void() FireBallHomeIn =
{
	local entity effect;
	
	if (self.velocity == '0 0 0')
	{
		effect = spawn();
		setorigin(effect, self.origin + v_up * 14);
		setmodel(effect, "progs/fire.spr");
		effect.movetype = MOVETYPE_NONE;
		
		effect.think = firesprite_think;
		effect.nextthink = time;
		effect.solid = SOLID_NOT;
		sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);
		spawn_embers();
		remove(self);
		return;
	}

	if (self.fireballhome_finished < time)
	{
		self.velocity_x = self.velocity_x / 2;
		self.velocity_y = self.velocity_y / 2;
		self.fireballhome_finished = time + 1.5;
	}
	if (self.origin_x < self.enemy.origin_x)
		self.velocity_x = self.velocity_x + 25 * frametime * 75;
	if (self.origin_x > self.enemy.origin_x)
		self.velocity_x = self.velocity_x - 25 * frametime * 75;
	if (self.origin_y < self.enemy.origin_y)
		self.velocity_y = self.velocity_y + 25 * frametime * 75;
	if (self.origin_y > self.enemy.origin_y)
		self.velocity_y = self.velocity_y - 25 * frametime * 75;

	if (!(self.owner.origin_z < self.enemy.origin_z + 25 && self.owner.origin_z > self.enemy.origin_z - 25))
	{
		if (self.origin_z > self.enemy.origin_z)
			self.velocity_z = self.velocity_z - 25 * frametime * 75;
		if (self.origin_z < self.enemy.origin_z)
			self.velocity_z = self.velocity_z + 25 * frametime * 75;
	}
	if (self.enemy.classname == "camera")
	{
		bprint ("Fireball targetted camera: Switched to world\n");
		self.enemy = world;
	}
};

void() FireBallThink =
{
	local entity effect, oself;

	if (self.owner.enemy.health > 0)
		self.enemy = self.owner.enemy;

	FireBall_HitBox();
	if (self.owner.classname == "player")
	{
		if (!self.lip) // Run once, do a proper infront check from my owner
		{
			oself = self;
			self = self.owner;
			local float testchk = infront(self.enemy);
			self = oself;
			if (testchk || self.owner.enemy.movetype == MOVETYPE_NOCLIP)
				self.lip = TRUE;
		}
		if (self.enemy && self.enemy.health > 0 && self.enemy.deadflag != DEAD_DEAD && self.enemy != self.owner && self.enemy.classname != "camera" && self.lip)
			FireBallHomeIn();
	}
	else // not vigil casting
	{
		if (self.enemy && self.enemy.health > 0 && self.enemy.deadflag != DEAD_DEAD && self.enemy != self.owner && self.enemy.classname != "camera")
			FireBallHomeIn();
	}

	if (self.attack_finished < time)
	{
		effect = spawn();
		setorigin(effect, self.origin + v_up * 14);
		setmodel(effect, "progs/fire.spr");
		effect.movetype = MOVETYPE_NONE;
		effect.think = firesprite_think;
		effect.nextthink = time;
		effect.solid = SOLID_NOT;
		spawn_embers();
		sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}

	frameskip(0.01);
};

void() FireballWallTouch =
{
	local entity effect;

	effect = spawn();
	setorigin(effect, self.origin);
	setmodel(effect, "progs/fire.spr");
	effect.movetype = MOVETYPE_NOCLIP;
	effect.think = firesprite_think;
	effect.nextthink = time;
	effect.solid = SOLID_NOT;
	sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);
	remove(self);
	return;
};

void(float damg, float hight) Fireball =
{
	local	entity missile;

	makevectors (self.angles);

	sound (self, CHAN_BODY, "spells/fball.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_TRIGGER;
	missile.classname = "fireball";
		
	// set missile speed
	makevectors (self.angles);
	missile.velocity = aim(self, 800);
	missile.velocity = missile.velocity * 800;
	//missile.angles = vectoangles(missile.velocity);
	missile.avelocity = '600 300 150';
	missile.mode = damg;
	missile.touch = FireballWallTouch;
	missile.attack_finished = time + 0.5;
	missile.angles = self.angles;
	// .touch should only work on BSP objects/walls
	missile.dimension_hit = 1;
	missile.dimension_solid = 0;

	missile.light_lev = 40;
	missile.color = [2, 1, 0];
	missile.hitcontentsmaski = CONTENTBIT_SOLID|0x00000002i|CONTENTBIT_PLAYERCLIP; // don't ignore clip brushes etc
	
	missile.think = FireBallThink;
	missile.nextthink = time + 0.1;

	setmodel (missile, "progs/fball.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + v_up*hight);
};





// LIGHTNING STORM





void() LightningThink =
{
	local entity temp, head, effect;
	local vector source, org, targ;
	local float r;

	targ = self.origin - '0 0 9999';
	targ_x = (targ_x + RandomRange (-50, 50));
	targ_y = (targ_y + RandomRange (-50, 50));

	// Save particle resources
	/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteCoord (MSG_BROADCAST, targ_x);
	WriteCoord (MSG_BROADCAST, targ_y);
	WriteCoord (MSG_BROADCAST, targ_z);
	*/

	r = random();

	source = self.origin;
	traceline (source, source - v_up*100, FALSE, self);
	org = trace_endpos - v_up*8;

	head = searchradius(org, 70);
	while (head)
	{
		if (head.takedamage && head.perfectguard_buff < time && self.owner != head
		&& ((coop == TRUE && head.classname != "player" && self.owner.classname == "player" || self.owner.flags & FL_MONSTER) || (coop == FALSE))) // coop
		{
			if (self.owner.flags & FL_MONSTER && !head.flags & FL_MONSTER || !self.owner.flags & FL_MONSTER) // fix monsters pretending to hit each other
			{
				if (self.owner.classname == "player")
						self.owner.owner.combo = self.owner.owner.combo + 1; // raise combo counter

				if (head.classname == "player")
				{
					head.colormod = '5 5 5';
					if (head.onground)
					{
						if (random() < 0.5)
							head.paincount = 0;
						else
							head.paincount = 1;
					}

					if (head.owner && head.classname == "player")
					{
						head.owner.noblock_finished = time + 0.5; // don't allow block / spin attack on ice hit
						head.owner.nospinatk_finished = time + 0.5; // don't allow block / spin attack on ice hit
						head.owner.nobackflip_finished = time + 0.5; // don't allow backflip on hit
					}

					if (head.perfectblock > time)
					{
						if (range(self.owner, self.owner.enemy) == RANGE_CLOSE || range(self.owner, self.owner.enemy) == RANGE_MELEE || range(self.owner, self.owner.enemy) == RANGE_NEAR)
						{
							head.enemy = self.owner; // needed for counter attack to face the proper direction
							head.counter_finished = time + 0.5;
						}
						if (head.owner && relics & IT_RELIC11) // Reward mana
						{
							head.owner.mana = head.owner.mana + 50;
							head.owner.absorb_finished = time + 3;
							if (head.owner.mana > head.owner.max_mana)
								head.owner.mana = head.owner.max_mana;
						}
						PerfectGuard(head);
						remove(self);
						return;
					}
				}

				sound (self, CHAN_BODY, "weapons/lhit.wav", 1, ATTN_NORM);
				if (head.flags & FL_ONGROUND)
					head.flags = head.flags - FL_ONGROUND;
				head.velocity = '0 0 25';
				head.damage_type = 4; // Lightning based damage
				if (self.owner.classname == "player")
				{
					head.knockback = 0;
					if (head.classname == "dragon") // monsters with immense weakness
						T_Damage (head, self, self.owner, 5, 0);
					else if (head.classname == "sgknight") // stained glass knight takes slightly more damage
						T_Damage (head, self, self.owner, 4, 0);
					else if (head.classname == "ethskull" || head.classname == "ghost" || head.classname == "ghost2" || head.classname == "ghoul" || head.classname == "lesserwraith"
					|| head.classname == "wraith" || head.classname == "zombie" || head.classname == "zombieboss" || head.classname == "skeleton") // undead enemies aren't affected much
						T_Damage (head, self, self.owner, 1, 0);						
					else if (head.classname == "esquid") // electric squid gains health
					{
						T_Damage (head, self, self.owner, 0, 0);
						head.health = head.health + 1;
						if (head.health > head.max_health)
							head.health = head.max_health;
					}
					else
					{
						if (deathmatch)
							T_Damage (head, self, self.owner, 1, 0); // deathmatch damage
						else
							T_Damage (head, self, self.owner, 3, 0); // normal damage
					}
				}
				else
				{
					if (self.owner.classname == "archg") // arch ghoul damage
						T_Damage (head, self, self.owner, 3, 0);
					else if (self.owner.classname == "troglod") // troglodyte damage
						T_Damage (head, self, self.owner, 5, 0);
					else
						T_Damage (head, self, self.owner, 2, 0);
				}
				self.cnt = self.cnt + 1;
			}
		}
		head = head.chain;
	}

	temp = spawn ();
	temp.movetype = MOVETYPE_NOCLIP;
	temp.solid = SOLID_NOT;
	temp.classname = "sprite";
	temp.effects = EF_NODEPTHTEST;

	temp.alpha = 0.5;
	if (r < 0.5)
		temp.frame = 0;
	else
		temp.frame = 1;

	temp.think = SUB_Remove;
	temp.nextthink = time + 0.01;
	setmodel (temp, "progs/lightnin.spr");
	setsize (temp, '0 0 0', '0 0 0');		
	setorigin (temp, self.origin - v_up * 65);

	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	frameskip(0.07);
};

void() LightningStorm =
{
	local entity missile;
	local float r;

	if (random() < 0.5 && self.classname == "player")
		self.owner.screenflash_finished = time + 0.01;

	r = random();

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_NOCLIP;
	missile.solid = SOLID_NOT;
	missile.classname = "lightning";

	// set missile speed
	missile.angles_y = random() * 360;

	makevectors (missile.angles);

	missile.velocity = aim(self, 500);
	missile.velocity = missile.velocity * 500;
	missile.angles = vectoangles(missile.velocity);

	// set missile duration
	missile.alpha = 0.5;
	missile.effects = EF_NODEPTHTEST | EF_ADDITIVE;
	missile.think = LightningThink;
	missile.nextthink = time;
	missile.attack_finished = time + 0.3;

	setmodel (missile, "progs/lball.spr");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + '0 0 110');

	if (self.classname == "player")
		self.owner.attack_finished = time + 0.2;
	else
		missile.owner.attack_finished = time + 0.2;
	self.lcount = self.lcount + 1; // count up till end
};




// ICE FIELD




void() iced_think =
{
	if (self.attack_finished < time)
	{
		self.cnt2 = self.cnt2 + 1;
		if (self.cnt2 > 5)
		{
			sound (self, CHAN_BODY, "spells/shatter.wav", 1, ATTN_NORM);
			remove(self);
			return;
		}
		self.attack_finished = time + 0.1;
	}

	self.alpha = 0.5 + sin(time*6)*0.05;
	self.colormod_x = 1 + sin(time*8)*0.25; // glow pallet
	self.colormod_y = 1 + sin(time*8)*0.25; // glow pallet
	self.colormod_z = 2 + sin(time*8)*0.25; // glow pallet

	frameskip(0.01);
};

void() iced_particle =
{
	particle (self.origin, '0 0 0', 208, 8);
	particle (self.origin, '0 0 0', 208, 8);
	if (!self.velocity)
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.1;
};

.float icefield_count;
.float iced_time;
void() icefield_think =
{
	local entity head, effect, effect2;
	local float vis;

	if (!checkground(self))
		droptofloor();

	if (self.attack_finished < time) // grow size
	{
		if (self.frame < 17)
		{
			self.frame = self.frame + 1;
			self.scale = self.scale + 0.1;
			self.cnt2 = self.cnt2 + 7; // damage radius grows with model
		}
		self.attack_finished = time + 0.08;
	}
	if (self.pain_finished < time || self.owner.health < 1)
	{
		if (self.frame > 0)
		{
			self.frame = self.frame - 1;
			self.cnt2 = self.cnt2 - 4; // shrink the damage radius
		}
		else
		{
			remove(self);
			return;
		}
	}
	else // icefield glow logic
	{
		self.alpha = 0.5 + sin(time*6)*0.05;
		self.colormod_x = 1 + sin(time*6)*0.15; // glow pallet
		self.colormod_y = 1 + sin(time*6)*0.15; // glow pallet
		self.colormod_z = 2 + sin(time*6)*0.15; // glow pallet
	}

	head = searchradius(self.origin, (self.cnt2 * 1.5));
	while (head)
	{
		if (world.model == "maps/boss2.bsp") // Special exception for Eternal Dragon, visible can't see his origin
			vis = TRUE;
		else
		{
			if (visible(head))
				vis = TRUE;
			else
				vis = FALSE;
		}

		if (self.owner != head && head.takedamage && head.iced_time < time && head.perfectguard_buff < time && vis
		&& ((coop == TRUE && head.classname != "player" && self.owner.classname == "player" || self.owner.flags & FL_MONSTER) || (coop == FALSE))) // coop
		{
			if (self.owner.flags & FL_MONSTER && !head.flags & FL_MONSTER || !self.owner.flags & FL_MONSTER) // fix monsters pretending to hit each other
			{
				if (head.flags & FL_ONGROUND || head.onground)
				{
					if (head.perfectblock > time)
					{
						if (range(self.owner, self.owner.enemy) == RANGE_CLOSE || range(self.owner, self.owner.enemy) == RANGE_MELEE || range(self.owner, self.owner.enemy) == RANGE_NEAR)
						{
							head.enemy = self.owner; // needed for counter attack to face the proper direction
							head.counter_finished = time + 0.5;
						}
						if (head.owner && relics & IT_RELIC11) // Reward mana
						{
							head.owner.mana = head.owner.mana + 30;
							head.owner.absorb_finished = time + 3;
							if (head.owner.mana > head.owner.max_mana)
								head.owner.mana = head.owner.max_mana;
						}
						PerfectGuard(head);
						self.pain_finished = time; // disappear now
					}
					else
					{
						// cover the enemy in ice
						effect = spawn();
						setorigin(effect, head.origin);
						setmodel(effect, "progs/iced.mdl");
						setsize (effect, '0 0 0', '0 0 0');
						effect.movetype = MOVETYPE_NOCLIP;
						effect.think = iced_think;
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						effect.alpha = 0.2;
						if (head.flags & IT_BOSS2)
						{
							effect.alpha = 0.5;
							effect.scale = 3;
						}

						// spray some particles
						effect2 = spawn();
						setorigin(effect2, head.origin + v_up * 16);
						setmodel(effect2, "progs/null.spr");
						setsize (effect2, '0 0 0', '0 0 0');
						effect2.movetype = MOVETYPE_BOUNCE;
						effect2.think = iced_particle;
						effect2.nextthink = time;
						effect2.angles_y = random() * 360;
						makevectors (effect2.angles);
						effect2.velocity = v_forward * 80;

						sound (self, CHAN_BODY, "spells/freeze.wav", 1, ATTN_NORM);
						head.paincount = 0;
						head.velocity = '0 0 0';
						effect.angles_x = effect.angles_y = effect.angles_z = random()*360;
						head.knockback = 0;
						head.damage_type = 3; // Ice based damage

						if (!deathmatch)
						{
							if (head.classname == "player")
								head.colormod = '0 2.5 5';
							if (head.flags & IT_BOSS2) // Eternal Dragon is weak to Ice
							{
								head.colormod = '0 2.5 5';
								T_Damage (head, self, self.owner, 16, 0);
							}
							else
								T_Damage (head, self, self.owner, 3, 0);
						}
						else // Deathmatch damage
							T_Damage (head, self, self.owner, 1, 0);
					
						if (self.owner.classname == "player")
							self.owner.owner.combo = self.owner.owner.combo + 1; // raise combo counter

						head.iced_time = time + 0.5;
						if (head.owner && head.classname == "player")
						{
							head.owner.noblock_finished = time + 0.5; // don't allow block / spin attack on ice hit
							head.owner.nospinatk_finished = time + 0.5; // don't allow block / spin attack on ice hit
						}
					}
				}
			}
		}
		head = head.chain;
	}

	frameskip(0.01);
};

void() chargeice_effect =
{
	if (self.frame > 4)
	{
		self.frame = self.frame + 1;
		if (self.frame > 9)
		{
			remove(self);
			return;
		}
		self.nextthink = time + 0.1;
		return;
	}

	if (self.mode < time)
	{
		if (self.frame < 4)
			self.frame = self.frame + 1;
		else
		{
			remove(self);
			return;
		}
		self.mode = time + 0.08;
	}
	spawn_chargeparticle(0); // create ice field charge particles
	frameskip(0.01);
};

void() IceField =
{
	local entity effect;
	
	effect = spawn();
	setorigin(effect, self.origin);
	setmodel(effect, "progs/chargice.spr");
	setsize(effect, '0 0 0', '0 0 0');
	effect.owner = self;
	effect.movetype = MOVETYPE_NOCLIP;
	effect.classname = "IceFieldHitGroundSprite";
	effect.dimension_hit = 0;
	effect.dimension_solid = 0;
	effect.solid = SOLID_NOT;
	effect.scale = 1;
	effect.frame = 5;
	effect.alpha = 0.6;
	effect.effects = EF_ADDITIVE | EF_NODEPTHTEST | EF_FULLBRIGHT;
	effect.think = chargeice_effect;
	effect.nextthink = time;

	sound (effect, CHAN_AUTO, "spells/flnch.wav", 1, ATTN_NORM);
	sound (effect, CHAN_VOICE, "spells/iceyair.wav", 1, ATTN_NORM);

	local entity missile = spawn ();

	if (self.classname == "icefieldprojectile")
		missile.owner = self.owner;
	else
		missile.owner = self;

	missile.movetype = MOVETYPE_NOCLIP;
	missile.solid = SOLID_NOT;
	missile.dimension_hit = 0;
	missile.dimension_solid = 0;
	missile.classname = "icefield";
	missile.alpha = 0.35;
	missile.think = icefield_think;
	missile.nextthink = time;
	missile.pain_finished = time + 10; // time till spells over
	missile.effects = EF_NODEPTHTEST | EF_FULLBRIGHT | EF_ADDITIVE;
	missile.pvsflags = PVSF_IGNOREPVS;

	setmodel (missile, "progs/icef.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);
};






// ELEMENTAL BEAM





void() chargebeam_effect =
{
	if (self.pain_finished < time)
	{
		self.scale = self.scale - 0.01;
		self.alpha = self.alpha - 0.01;
	}
	if (self.alpha < 0.01 || self.scale < 0.01)
	{
		remove(self);
		return;
	}
	if (self.owner.flags & IT_BOSS2) // Eternal Dragon difference
		setorigin (self, self.owner.origin + v_up * 100);
	else
		setorigin (self, self.owner.origin);
	
	spawn_chargeparticle(1);
	frameskip(0.01);
};

void() elebeam_think =
{
	local entity head, effect, spark;

	if (self.attack_finished < time)
	{
		if (self.frame < 5)
		{
			self.alpha = self.alpha - 0.1;
			self.frame = self.frame + 1;
		}
		else
		{
			self.frame = 5;
			if (self.alpha > 0)
				self.alpha = self.alpha - 0.05;
			else
			{
				remove(self);
				return;
			}
		}
	}

	// do damage
	if (self.frame == 0)
	{
		head = searchradius(self.origin - v_up*20, 40);
		while (head)
		{
			if (head != self && visible(head) && head.perfectguard_buff < time && head.takedamage && self.owner != head && head.deadflag != DEAD_DEAD
			&& ((coop == TRUE && head.classname != "player" && self.owner.classname == "player" || self.owner.flags & FL_MONSTER) || (coop == FALSE))) // coop
			{
				if (self.owner.flags & FL_MONSTER && !head.flags & FL_MONSTER || !self.owner.flags & FL_MONSTER) // fix monsters pretending to hit each other
				{
					if (head.perfectblock > time)
					{
						if (range(self.owner, self.owner.enemy) == RANGE_CLOSE || range(self.owner, self.owner.enemy) == RANGE_MELEE || range(self.owner, self.owner.enemy) == RANGE_NEAR)
						{
							head.enemy = self.owner; // needed for counter attack to face the proper direction
							head.counter_finished = time + 0.5;
						}
						if (head.owner && relics & IT_RELIC11) // Reward mana
						{
							head.owner.mana = head.owner.mana + 100;
							head.owner.absorb_finished = time + 3;
							if (head.owner.mana > head.owner.max_mana)
								head.owner.mana = head.owner.max_mana;
						}
						PerfectGuard(head);
					}
					else
					{
						effect = spawn();
						setorigin(effect, head.origin + v_up * 14);
						setmodel(effect, "progs/fire.spr");
						effect.movetype = MOVETYPE_NONE;
						effect.think = firesprite_think;
						effect.nextthink = time;
						effect.solid = SOLID_NOT;

						if (deathmatch == TRUE)
							self.mode = 1;

						head.knockback = 1;

						if (head.flags & FL_MONSTER) // Wake target up on hit
							head.enemy = self.owner;
	
						T_Damage (head, self, self.owner, self.mode, 0);
						
						if (head.classname == "player")
						{
							head.colormod = '8 0 0';
							if (head.owner)
							{
								head.owner.noblock_finished = time + 0.5; // don't allow block / spin attack on hit
								head.owner.nospinatk_finished = time + 0.5; // don't allow block / spin attack on hit
								head.owner.nobackflip_finished = time + 0.5; // don't allow backflip on hit
							}
						}
						if (self.owner.classname == "player" && head.flags & FL_MONSTER)
						{ // owner.owner == Vigil -> Camera
							if (self.owner.owner.camera_forcezoom_finished < time)
								self.owner.owner.zoom_mode = 1; // zoom in camera
							self.owner.owner.camchangetarget_finished = time + 0.5;
							self.owner.owner.goalentity = head; // Have the camera track the enemy
							self.owner.owner.combo = self.owner.owner.combo + 1; // raise combo counter
						}

						if (self.owner.origin_x < self.owner.enemy.origin_x)
							head.angles_y = 180;
						else
							head.angles_y = 0;

						head.velocity = '0 0 50';
						if (head.flags & FL_ONGROUND)
							head.flags = head.flags - FL_ONGROUND;
						if (self.owner.angles_y == 0)
							head.velocity_x = 50;
						else
							head.velocity_x = -50;

						sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);
					}
				}
			}
			head = head.chain;
		}
	}
	frameskip(0.1);
};

void() beameffect_think =
{
	makevectors(self.owner.angles);
	setorigin (self, self.owner.origin + v_forward*36 + '0 0 12');

	if (self.frame < 7)
		self.frame = self.frame + 1;
	else
		self.frame = 0;

	if (self.owner.beams_shot < 1 || self.owner.grab_finished > time || self.owner.health < 1)
	{
		remove(self);
		return;
	}
	frameskip(0.01);
};

void() Elebeam_Muzzle =
{
	local	entity effect;

	local vector ang;

	ang = self.angles;
	if (self.flags & FL_MONSTER) // fix for makevector angle_x input
		ang_x = ang_x * -1;
	makevectors(ang);

	effect = spawn ();
	effect.owner = self;
	effect.movetype = MOVETYPE_NONE;
	effect.solid = SOLID_NOT;
	effect.classname = "elebeameffect";
	effect.think = beameffect_think;
	effect.nextthink = time + 0.1;
	effect.alpha = 0.5;
	effect.angles_y = self.angles_y - 180;
	effect.angles_x = ang_x;
	effect.angles_z = self.angles_z;

	effect.effects = EF_DIMLIGHT | EF_ADDITIVE;
	setmodel (effect, "progs/beam1.mdl");
	setsize (effect, '0 0 0', '0 0 0');
	setorigin (effect, self.origin + v_forward*36 + '0 0 12');
};

void(float damg, float hight, float fwd) Elebeam =
{
	local entity beam;
	local vector ang;

	if (self.flags & FL_MONSTER) // fix for makevector angle_x input
	{
		ang = self.angles;
		ang_x = ang_x * -1;
		makevectors(ang);
	}
	else
		makevectors (self.angles);

	if (self.elebeamSound_finished < time)
	{
		self.elebeamSound_finished = time + 0.4;
		sound (self, CHAN_BODY, "spells/fbeam.wav", 1, ATTN_NORM);
	}

	beam = spawn ();
	beam.owner = self;
	beam.movetype = MOVETYPE_NOCLIP;
	beam.solid = SOLID_NOT;
	beam.classname = "elebeam";
		
	// set beam speed	
	beam.velocity = aim(self, 500);
	beam.velocity = beam.velocity * 500;
	beam.angles = vectoangles(beam.velocity);
	beam.alpha = 0.5;

	beam.attack_finished = time + 0.5; // set beam duration
	beam.think = elebeam_think;
	beam.nextthink = time;
	beam.mode = damg;
	beam.effects = EF_ADDITIVE;

	setmodel (beam, "progs/beam2.mdl");
	setsize (beam, '0 0 0', '0 0 0');

	setorigin (beam, self.origin + v_forward*55 + v_up*hight + v_forward*fwd);
};





// TWISTER





void() TwisterThink =
{
	local entity head, effect;
	local vector vdestdelta;
	local float len, traveltime, r;

	r = random();
	vdestdelta = '0 0 0';

	// Have the twister grow
	if (self.mode == 0)
	{
		if (self.frame < 23)
			self.frame = self.frame + 1;
		else
			self.mode = 1; // twister mode increased
	}
	else if (self.mode == 1) // twister will now fly around randomly and damage opponents
	{
		// move randomly around
		makevectors(self.mangle);
		if (random() < 0.03)
			self.mangle_y = random()*360;
			//self.mangle_y = self.mangle_y + random()*360;
		self.velocity = v_forward * 100;
		self.flags = self.flags - FL_ONGROUND;

		len = vlen(vdestdelta);
		traveltime = len / 400; // second variable is the cyclespeed

        head = searchradius(self.origin, 115);
		while (head)                      
		{
			self.enemy = head;
			if (visible(head) && (head.flags & FL_MONSTER || deathmatch == TRUE) && head != self.owner)
			{
				vdestdelta = self.origin - self.enemy.origin;
				len = vlen(vdestdelta);
				traveltime = len / 600;
				self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
				self.enemy.velocity = vdestdelta * (1/traveltime);
			}
			head = head.chain;
		}	

		if (self.frame < 47)
			self.frame = self.frame + 1;
		else
			self.frame = 24; // reset animation

		if (self.attack_finished < time) // twister dies
		{
			self.mode = 2;
			self.frame = 49;
		}

	}
	else
	{
		if (self.frame < 73)
		{
			self.frame = self.frame + 1;
			self.velocity_z = 50;
		}
		else
		{
			remove(self);
			return;
		}
	}

	head = searchradius(self.origin, 50);
	while (head)
	{
		if (head.takedamage && self.owner != head && self.mode == 1 && head.twister_damage_finished < time && head.health > 0 && head.perfectguard_buff < time
		&& ((coop == TRUE && head.classname != "player" && self.owner.classname == "player" || self.owner.flags & FL_MONSTER) || (coop == FALSE))) // coop
		{
			if (self.owner.flags & FL_MONSTER && !head.flags & FL_MONSTER || !self.owner.flags & FL_MONSTER) // fix monsters pretending to hit each other
			{
				if (self.owner.classname == "player")
					self.owner.owner.combo = self.owner.owner.combo + 1; // raise combo counter

				if (head.perfectblock > time)
				{
					if (range(self.owner, self.owner.enemy) == RANGE_CLOSE || range(self.owner, self.owner.enemy) == RANGE_MELEE || range(self.owner, self.owner.enemy) == RANGE_NEAR)
					{
						head.enemy = self.owner; // needed for counter attack to face the proper direction
						head.counter_finished = time + 0.5;
					}
					if (head.owner && relics & IT_RELIC11) // Reward mana
					{
						head.owner.mana = head.owner.mana + 13;
						head.owner.absorb_finished = time + 3;
						if (head.owner.mana > head.owner.max_mana)
							head.owner.mana = head.owner.max_mana;
					}
					PerfectGuard(head);
					self.attack_finished = time; // twister dies off
				}

				head.knockback = head.paincount = 0;
				head.damage_type = 1; // Wind based damage
				if (head.movetype == MOVETYPE_FLY || head.movetype == MOVETYPE_NOCLIP) // extra damage on flying type monsters
					T_Damage (head, self, self.owner, 3, 0);
				if (self.owner.classname == "player")
				{
					if (deathmatch == FALSE)
						T_Damage (head, self, self.owner, 5, 0);
					else
						T_Damage (head, self, self.owner, 2, 0);
				}
				else
					T_Damage (head, self, self.owner, 3, 0);
				sound (self, CHAN_VOICE, "player/swordhit.wav", 1, ATTN_NORM);
				head.twister_damage_finished = time + 0.5;

				head.velocity = '0 0 0';

				self.velocity_z = head.velocity_z + 75;
				if (head.flags & FL_ONGROUND)
					head.flags = head.flags - (head.flags & FL_ONGROUND);
			}
		}
		head = head.chain;
	}

	frameskip(0.1);
};

void() Twister =
{
	local entity missile;
	local float r;

	r = random();

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLY;
	missile.solid = SOLID_NOT;
	missile.classname = "twister";

	missile.angles_y = random() * 360;

	makevectors (missile.angles);

	missile.velocity = aim(self, 25);
	missile.velocity = missile.velocity * 25;
	missile.angles = vectoangles(missile.velocity);

	missile.alpha = 0.8;

	missile.think = TwisterThink;
	missile.nextthink = time;

	missile.attack_finished = time + 10;

	setmodel (missile, "progs/twister.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);
	missile.effects = EF_ADDITIVE;

	if (self.classname == "player")
		self.owner.attack_finished = time + 1;
	else
		missile.owner.attack_finished = time + 1;
};




// FIRE BUSTER (SGK Ability)




void() fire_buster_explode =
{
	if (self.frame < 19)
	{
		if (self.frame == 1) // Fire once
			FireMelee(29,0,2,25,99,1,1,FALSE,12,0,1);
		self.frame = self.frame + 1;
	}
	else
	{
		remove(self);
		return;
	}
	frameskip (0.02);
};

void() fire_buster_think =
{
	local entity effect;

	droptofloor();
	self.angles_z = self.angles_z + 2;

	if (self.alpha < 1)
		self.alpha = self.alpha + 0.01;
	else
		self.alpha = 1;

	if (self.scale > 0)
		self.scale = self.scale - 0.15;
	else
	{
		// Explode in spot!
		effect = spawn();
		setorigin(effect, self.origin);
		setmodel(effect, "progs/firecolm.mdl");
		effect.movetype = MOVETYPE_NONE; // Fixes PG making me fly off somewhere
		effect.angles_y = -90;
		effect.scale = 1;
		effect.solid = SOLID_NOT;
		effect.owner = self.owner;
		effect.flags = FL_MONSTER; // Don't hit owner
		effect.effects = EF_ADDITIVE | EF_FULLBRIGHT;
		effect.alpha = 0.7;
		effect.frame = 1;
		setsize (effect, '0 0 0', '0 0 0');

		sound (self, CHAN_WEAPON, "spells/flame.wav", 1, ATTN_NORM);

		effect.think = fire_buster_explode;
		effect.nextthink = time;
		
		remove(self);
		return;
	}
	frameskip (0.01);
};