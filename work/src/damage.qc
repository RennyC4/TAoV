//+------+
//|Damage|
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Damage routines are handled here, same with the blood.                     |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

float block_sparks_limit; // only allow 25 at a time
.float block_sparks;
.float half_health_trigger; // boolean

void() drop_gold;
void() HuntTarget;
void(entity plyr) PerfectGuard;
void() FireAwakeTargets;

void(entity attackerb) player_damage_physics =
{
	makevectors(self.angles);

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;

	// Vigil can be knocked out of the air easily if damage
	// is taken as going into player_hit1/2(); look/act silly.
	if (!deathmatch)
	{
		if (self.knockback < 1 && !self.onground)
			self.knockback = 4;
	}

	if (self.knockback == 1) // Hit backwards (small)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 300;

		if (attackerb.angles_y >= 90 && attackerb.angles_y <= 270)
			self.velocity_x = -100;
		else
			self.velocity_x = 100;
		
		if (!deathmatch)
			self.paincount = 2;
	}
	else if (self.knockback == 2) // Guard breaks, pop up Vigil
	{
		self.velocity = '0 0 0';
		self.velocity_z = 490;

		if (!deathmatch)
			self.paincount = 2;
	}
	else if (self.knockback == 3) // Guard breaks, hit backwards (big)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 300;

		if (attackerb.angles_y >= 90 && attackerb.angles_y <= 270)
			self.velocity_x = -300;
		else
			self.velocity_x = 300;

		if (!deathmatch)
			self.paincount = 2;
	}
	else if (self.knockback == 4) // Only knock down pain state to be used underwater
	{
		self.velocity = '0 0 0';

		if (!self.swimming)
			self.velocity_z = 200;
		else
			self.velocity_z = 100;

		if (attackerb.angles_y >= 90 && attackerb.angles_y <= 270)
			self.velocity_x = -50;
		else
			self.velocity_x = 50;

		if (!deathmatch)
			self.paincount = 2;
	}
	else if (self.knockback == 5) // Guard breaks
	{
		self.velocity = '0 0 0';
		self.velocity_z = 350;
		
		if (attackerb.angles_y >= 90 && attackerb.angles_y <= 270)
			self.velocity_x = -200;
		else
			self.velocity_x = 200;

		if (!deathmatch)
			self.paincount = 2;
	}
	else if (self.knockback == 6)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 0;

		if (attackerb.angles_y >= 90 && attackerb.angles_y <= 270)
			self.velocity_x = -400;
		else
			self.velocity_x = 400;
	}
	else if (self.knockback == 7) // last of airkicks, knocks target to ground
	{
		self.velocity = '0 0 0';
		self.velocity_z = -500;
	}
	if (self.knockback == 8) // Hit downwards, cannot backflip out (used for eternal dragon's rocks)
	{
		self.velocity = '0 0 0';
		self.velocity_z = -25;
		if (!deathmatch)
			self.paincount = 2;
	}
};

/*
============
Killed
============
*/

.float gold_dropped;
.float killed;
void(entity targ, entity attacker) Killed =
{
	entity oself = self;
	self = targ;

	self.enemy = attacker;
	self.targetname = ""; // remove being activated by triggers

	if (self.flags & FL_MONSTER && !self.killed)
	{
		if (self.target || self.target2 || self.target3 || self.target4 || self.target5 || self.target6 || self.target7 || self.target8 || self.target9)
			SUB_UseTargets();
		if (random() < 0.5) // 50% chance of gold drop
			drop_gold();
		if (attacker.enemy == self) // Clear Vigil's enemy flag
		{
			attacker.enemy = world;
			attacker.oldenemy = self; // Add to Vigil's oldenemy flag
		}
		self.killed = TRUE; // Run once
	}

	//
	// Half-health trigger for monsters - needed here as well in case purge/hard hitting attacks eliminates target before it's fired
	//

	if (!targ.half_health_trigger && targ.halfhealth_target != "")
	{
		FireTarget(targ.halfhealth_target); // Fire 'halfhealth_target'
		targ.half_health_trigger = TRUE; // Fire once
	}

	// give frags, display who killed who
	if (deathmatch && targ.classname == "player" && attacker.classname == "player")
	{
		bprint (attacker.owner.netname);
		bprint (" has defeated ");
		bprint (targ.owner.netname);
		bprint ("\n");
		attacker.owner.frags = attacker.owner.frags + 1;
	}

	if (self.th_die)
	{
		if (self.classname == "player") // Vigil should always be thrown back on death
		{
			if (!self.knockback)
				self.knockback = 1;
			player_damage_physics(self);
		}
		self.th_die();
	}

	makevectors(self.angles);

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;

	if (self.knockback == 1)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 300;
		if (attacker.angles_y == 0)
			self.velocity_x = 100;
		else
			self.velocity_x = -100;
	}
	else if (self.knockback == 2)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 490;
	}
	else if (self.knockback == 3)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 300;
		if (attacker.angles_y == 0)
			self.velocity_x = 300;
		else
			self.velocity_x = -300;
	}
	else if (self.knockback == 4)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 200;
		if (attacker.angles_y == 0)
			self.velocity_x = 50;
		else
			self.velocity_x = -50;
	}
	else if (self.knockback == 5)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 350;
		if (attacker.angles_y == 0)
			self.velocity_x = 200;
		else
			self.velocity_x = -200;
	}
	else if (self.knockback == 6)
	{
		self.velocity = '0 0 0';
		self.velocity_z = 0;
		if (attacker.angles_y == 0)
			self.velocity_x = 400;
		else
			self.velocity_x = -400;
	}
	else if (self.knockback == 7)
	{
		self.velocity = '0 0 0';
		self.velocity_z = -500;
	}

	if (self.classname == "player")
	{
		self.deadflag = DEAD_DEAD;
		self.takedamage = DAMAGE_NO;
	}
	else
		self.deadflag = DEAD_DYING;

	self.touch = SUB_Null;
	self = oself;
};

/*
============
T_Damage
============
*/

void(entity targ, entity inflictor, entity attacker, float damage, float statusrand) T_Damage =
{
	local	entity	oldself;
	local	float	save, rs;

	if (attacker.classname == "camera" || inflictor.classname == "camera" || targ.classname == "camera")
		error ("T_Damage error! Camera/Client entity should never be hit!\n");
	
	save = 0; // fixes bug with save calculation, rare instance of Vigil being 'OHKO'
	rs = random()*100;

	if (!targ.takedamage && targ.nopain_time > time || targ.invunerability_finished > time)
		return;
	if (targ.flags & FL_MONSTER && attacker.flags & FL_MONSTER) // monsters cannot damage each other
		return;

	// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

	// save damage based on the players armor level
	if (targ.owner.armorlevel > 0 && targ.classname == "player")
		save = ceil(targ.owner.armorlevel * (damage / 5));

	if (save >= damage && damage > 0)
	{
		damage = 1;
		save = 0;
	}

	// Prevent underflow
	if (damage < 0) damage = 0;
	if (save < 0) save = 0;
	
	//
	// Put status effects from monster to client entity
	//
	
	local float r = random() * 1;
	if (targ.classname == "player" && r < statusrand && targ.block_finished < time)
	{
		// Only play notification sound when debuff doesn't exist
		if ((targ.owner.status_poison_finished < time && attacker.status_poison_finished > time) || (targ.owner.status_blind_finished < time && attacker.status_blind_finished > time) || (targ.owner.status_broken_finished < time && attacker.status_broken_finished > time))
			sound (targ.owner, CHAN_AUTO, "player/statushit.wav", 1, ATTN_NORM);

		targ.owner.status_poison_finished = attacker.status_poison_finished;
		targ.owner.status_blind_finished = attacker.status_blind_finished;
		targ.owner.status_broken_finished = attacker.status_broken_finished;
		targ.owner.broken_tick_finished = time + 1 + ceil(random()*2 + 1); // setup proper tic

		/* Uncomment for debugging status effect application on hit
		if (cvar("developer") == 1)
		{
			local string s = ftos(statusrand);
			dprint ("Status Rand: ", s);
			local string s = ftos(r);
			dprint (" / ", s, "\n");
		}
		*/
	}

	//
	// Half-health trigger for monsters
	//

	if (!targ.half_health_trigger && targ.halfhealth_target != "")
	{
		if (targ.health <= (targ.max_health / 2))
		{
			FireTarget(targ.halfhealth_target); // Fire 'halfhealth_target'
			targ.half_health_trigger = TRUE; // Fire once
		}
	}

	//
	// Damage handling - begin
	//

	// Vigil's sword upgrade damage math
	if (attacker.owner != world && attacker.owner.swordlevel > 0 && damage > 0)
	{
		// Fix so magic spells do not do additional damage!
		if (inflictor.classname != "fireball" && inflictor.classname != "lightning" &&
		inflictor.classname != "icefield" && inflictor.classname != "firebeam" &&
		inflictor.classname != "twister")
			damage = damage + attacker.owner.swordlevel * 2;
	}

	if (targ.classname == "player")
	{
		if (difficulty == 0) // easy difficulty savings
			damage = ceil(damage / 1.5);

		if (!targ.owner.flags & FL_GODMODE && targ.perfectguard_buff < time)
		{
			if (targ.tired_finished < time && targ.hflask_drink_finished < time)
				targ.health = targ.health - damage + save; // save health with better armor
			else
			{
				targ.health = targ.health - (damage * 1.5) + save; // Vigil takes 1.5x damage when tired or drinking
				targ.hflask_drink_finished = time;
				targ.tired_finished = time;
			}
		}
		targ.enemy = attacker; // update who attacked Vigil last
		if (attacker)
			attacker.izuna_exec_finished = time; // remove izuna ability on attacker hitting player
		
		if (deathmatch)
			targ.izuna_exec_finished = time + 0.5; // can be air izuna dropped after being hit
	}
	else
	{
		//
		// Zombie monsters have special properties, only killable by fire!
		//
		if (targ.classname == "zombieboss" || targ.classname == "zombie")
		{
			if (targ.damage_type != 2) // Not hit by fire
			{
				if (damage < targ.health)
				{
					targ.health = targ.health - damage;
					if (attacker.owner)
						attacker.owner.current_damage = attacker.owner.current_damage + ceil(damage); // Damage on HUD
				}
				if (targ.health < targ.state) // set zombie bosses health back to 1/3 if under
					targ.health = targ.state;
				if (attacker.classname == "player")
				{
					attacker.owner.bighit_freeze = time + 0.3; // hit an enemy within this allotted time for freeze effects
					attacker.owner.monster_health = targ.health;
					attacker.owner.monster_max_health = targ.max_health;
					attacker.owner.displayname = targ.displayname;
					attacker.owner.displayname_finished = time + 3;
				}
			}
			else
			{
				targ.health = targ.health - (damage * 1.5);
				if (attacker.owner)
					attacker.owner.current_damage = attacker.owner.current_damage + ceil(damage * 1.5); // Damage on HUD
				targ.state = targ.health; // lowered over all health due to fire damage
				if (attacker.classname == "player")
				{
					attacker.owner.bighit_freeze = time + 0.3; // hit an enemy within this allotted time for freeze effects
					attacker.owner.monster_health = targ.health;
					attacker.owner.monster_max_health = targ.max_health;
					attacker.owner.displayname = targ.displayname;
					attacker.owner.displayname_finished = time + 3;
				}
			}
		}
		else // normal damage, every other monster
		{
			if (targ.berserk_finished < time)
			{
				targ.health = targ.health - damage;
				if (attacker.owner)
					attacker.owner.current_damage = attacker.owner.current_damage + ceil(damage); // Damage on HUD
			}
			else
			{
				targ.health = targ.health - ceil(damage / 2); // berserk savings
				if (attacker.owner)
					attacker.owner.current_damage = attacker.owner.current_damage + ceil(damage / 2); // Damage on HUD
			}
			
			if (attacker.classname == "player")
			{
				attacker.owner.bighit_freeze = time + 0.3; // hit an enemy within this allotted time for freeze effects
				attacker.owner.monster_health = targ.health;
				attacker.owner.monster_max_health = targ.max_health;
				attacker.owner.displayname = targ.displayname;
				attacker.owner.displayname_finished = time + 3;
			}
		}
		if (attacker && (!attacker.onground || !attacker.flags & FL_ONGROUND))
			targ.izuna_exec_finished = time + 0.5; // can be air izuna dropped after being hit
	}

	//
	// Damage handling - end
	//

	// Tell AI to relaunch an attack as soon as possible, this fixes the bug where the AI will attack
	// once and hurt you, then stop, and then allows the player to beat on them
	if (attacker.flags & FL_MONSTER && attacker.attackedname != "breakable")
		attacker.ai_reattack = TRUE;

	if (targ.health < 1)
	{
		attacker.ai_reattack = FALSE;

		oldself = self;
		self = targ;
		if (self.classname == "player")
			player_damage_physics(attacker);
		self = oldself;

		Killed (targ, attacker);
		return;
	}

	//
	// react to the damage - start
	//

	oldself = self;
	self = targ;

	if (attacker.takedamage && attacker != self.enemy)
	{
		if (!self.enemy)
			FireAwakeTargets(); // Monster just woke up

		self.enemy = attacker;
		if (self.flags & FL_MONSTER && !self.flags & FL_BOSS)
			HuntTarget ();
	}

	//
	// player - run physics and pain animation
	//

	if (self.classname == "player")
	{
		player_damage_physics(attacker);
		self.th_pain();
	}
	else
	{
		if (self.flags & FL_MONSTER)
		{
			if (self.th_pain && self.health > 0 && (self.invunerability_finished < time && self.berserk_finished < time))
			{
				if (self.classname != "dragon")
					self.th_pain();
				else if (random() < 0.2) // dragon's only rarely enter pain frames
					self.th_pain();
			}
		}
	}

	//
	// clean up
	//

	self.knockback = 0; // clear physics stuff

	if (attacker)
	{
		if (attacker.classname != "player") // manually cleared on player
			attacker.attack_type = 0;
		else
		{
			if (attacker.perfectblock_cooldown > time)
				attacker.perfectblock_cooldown = time; // remove perfect guard cooldown on vigils strikes
		}
	}
	targ.damage_type = 0;
	targ.knockback = 0;

	self = oldself;

	//
	// react to the damage - end
	//
};

vector() wall_velocity =
{
	local vector	vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};

float() crandom =
{
	return 2*(random() - 0.5);
};

void() BloodSplatThink =
{
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
	{
		self.origin_z = self.origin_z + 1;
		self.attack_finished = time + 0.75;
		self.angles_y = random() * 360;
		self.cnt2 = TRUE; // Hit water
		self.cnt = TRUE;
		self.alpha = 0.5;
		self.movetype = MOVETYPE_NOCLIP;
		self.velocity = '0 0 0';
		setmodel (self, "progs/bloodsplat.mdl");
		setsize (self, '0 0 0', '0 0 0');
	}

	if (checkground(self) && !self.cnt2)
	{
		if (!self.cnt)
		{
			sound (self, CHAN_AUTO, "misc/blood.wav", 1, ATTN_NORM);
			self.origin_z = self.origin_z + 1;
			self.attack_finished = time + 0.5;
			self.angles_y = random() * 360;
			self.cnt = TRUE;
			self.movetype = MOVETYPE_NOCLIP;
			self.velocity = '0 0 0';
			setmodel (self, "progs/bloodsplat.mdl");
			setsize (self, '0 0 0', '0 0 0');
		}
	}
	else if (!self.cnt2) // falling
	{
		self.angles = vectoangles(self.velocity);
		self.angles = self.angles * -1; // reverse angles otherwise blood looks backwards
	}
		
	if (self.cnt)
	{
		self.avelocity = '0 0 0';
		self.angles_x = self.angles_z = 0;

		self.scale = self.scale + 0.02;

		if (self.attack_finished < time)
		{
			if (self.alpha > 0)
			{
				self.alpha = self.alpha - 0.04;
				self.colormod = '1 1 1' * self.alpha; // Allow transparency without additive
			}
			else
			{
				max_blood_ents = max_blood_ents - 1;
				remove(self);
				return;
			}
		}
	}

	self.mode = self.mode + 1;
	frameskip(0.01);
};

void(vector org, entity own) ThrowBloodSplat =
{
	if (max_blood_ents < 10)
	{
		local entity splat;

		splat = spawn();
		splat.movetype = MOVETYPE_TOSS;
		splat.solid = SOLID_NOT;

		splat.velocity_x = splat.velocity_x + crandom()*40;
		splat.velocity_y = splat.velocity_y + crandom()*40;
		splat.velocity_z = splat.velocity_z + 120 + 50*random();
		
		splat.alpha = 1;
		splat.think = BloodSplatThink;
		splat.nextthink = time;
		splat.classname = "blood";
		splat.dimension_hit = 0;
		splat.dimension_solid = 0;

		setmodel (splat, "progs/blooddrop.mdl");
		setsize (splat, '1 1 1', '1 1 1');     
		setorigin (splat, org);
		max_blood_ents = max_blood_ents + 1;
	}
};

void() ThrowBodyPartHitFloor_Think =
{
	if ((checkground(self) || self.origin == self.oldorigin) && !self.cnt)
	{
		sound (self, CHAN_BODY, "misc/hitgrond.wav", 1, ATTN_NORM);
		self.angles_x = 0;
		self.angles_z = 0;
		self.avelocity = '0 0 0';
		self.cnt = TRUE; // Run once
	}
	self.oldorigin = self.origin;

	if (self.flags & FL_ONGROUND) // Fix midair hang up
		self.flags = self.flags - (self.flags & FL_ONGROUND);

	frameskip(0.1);
};

void(string gibname) ThrowBodyPart =
{
	local float r = random()*200;

	local entity head = spawn();
	head.solid = SOLID_NOT;
	head.movetype = MOVETYPE_TOSS;

	head.angles_y = random() * 360;
	makevectors (head.angles);
	head.alpha = 1;
	head.owner = world;
	head.velocity = v_forward * r;
	head.velocity_z = 200 + random()*200;

	if (head.flags & FL_ONGROUND)
		head.flags = head.flags - FL_ONGROUND;

	head.think = ThrowBodyPartHitFloor_Think;
	head.nextthink = time + 0.1;

	if (random() < 0.35)
		head.avelocity = '250 100 100';
	else if (random() < 0.70)
		head.avelocity = '100 250 100';
	else
		head.avelocity = '100 100 250';

	setmodel (head, gibname);
	setorigin (head, self.origin);
	setsize(head, VEC_HULL_MIN, VEC_HULL_MAX);
};

void() ThrowGib_Remove =
{
	self.alpha = self.alpha - 0.05;
	if (self.alpha < 0.1)
	{
		remove(self);
		return;
	}
	frameskip(0.1);
};

void(string gibname) ThrowGib =
{
	local entity head;

	head = spawn();

	head.solid = SOLID_TRIGGER;
	head.movetype = MOVETYPE_BOUNCE;

	head.angles_y = random() * 360;
	makevectors (head.angles);
	head.owner = world;
	head.velocity = v_forward * 50;
	head.velocity_z = 200;
	head.alpha = 1;

	if (head.flags & FL_ONGROUND)
		head.flags = head.flags - FL_ONGROUND;

	head.think = ThrowGib_Remove;
	head.nextthink = time + 1;
	head.avelocity = '5000 1000 3000';

	setmodel (head, gibname);
	setorigin (head, self.origin);
	setsize (head, '0 0 0', '0 0 0');
};

void(string gibname, vector org, entity own) ThrowHead =
{
	local entity gib;

	gib = spawn();
	gib.owner = self;
	gib.movetype = MOVETYPE_BOUNCE;
	gib.solid = SOLID_NOT;

	gib.angles_y = random() * 360;
	makevectors (gib.angles);
	gib.velocity = v_forward * 100;
	gib.velocity_z = 400;

	if (gib.flags & FL_ONGROUND)
		gib.flags = gib.flags - FL_ONGROUND;

	gib.avelocity = crandom() * '0 600 0';
	setmodel (gib, gibname);
	setsize (gib, '-16 -16 0', '16 16 56'); 
	setorigin (gib, org);
};

// spark effect for blocking
void()	sparks_fade1 = [0, sparks_fade2] {self.alpha = 0.8; frameskip(0.05);};
void()	sparks_fade2 = [0, sparks_fade3] {self.alpha = 0.6; frameskip(0.05);};
void()	sparks_fade3 = [0, sparks_fade4] {self.alpha = 0.4; frameskip(0.05);};
void()	sparks_fade4 = [0, SUB_Remove]   
{
	self.alpha = 0.2;
	frameskip(0.05);
	block_sparks_limit = block_sparks_limit - 1;
};

//
// Main combat melee function is executed here
//

void() player_purge1;
void(entity e) player_prop;
void() player_block;
void() player_blockbrk1;
void(entity y) monster_pain;
void(float damg, float dist, float knokback, float rsize, float snd, float flsh, float ignoreair, float unblockable, float up, float statusrand, float sprite) FireMelee =
{
	local entity head, effect;
	local vector dir, h;

	makevectors(self.angles);

	head = searchradius(self.origin + v_forward * dist + v_up * up, rsize);

	while (head)
	{
		if (head.takedamage && head != self && head.nopain_time < time && head.deadflag != DEAD_DEAD && visible(head) && head.perfectguard_buff < time && !(head.flags & IT_BOSS2 && self.swimming)
		&& ((coop && head.classname != "player" && self.classname == "player") || (!coop || self.flags & FL_MONSTER))) // coop
		{
			if (head.block_finished < time || unblockable || self.perfectguard_buff > time || head.swimming)
			{
				if (self.flags & FL_MONSTER && !head.flags & FL_MONSTER || !self.flags & FL_MONSTER) // fix monsters pretending to hit each other
				{
					if (flsh)
					{
						if (self.owner)
							self.owner.screenflash_finished = time + 0.1; // hard hit -> screen flashes
					}

					//
					// Screen Shake on certain attacks
					//

					if (self.fstab_cnt > 4 || self.ftspin_count >= 5 || (self.runatk_speed > 0 && flsh) || self.sword_spincnt == 99 || self.chargespincnt >= 46)
						self.owner.camshake_finished = time + 0.1;

					//
					// Purge
					//
					
					if (head.classname == "player" && head.purge_finished > time && head.owner && self.flags & FL_MONSTER && !deathmatch && self.health > 0 && !head.swimming && !head.owner.button3 && !head.grabbed && !head.izunatarg &&
					(!(pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_LAVA || pointcontents(self.origin) == CONTENT_SLIME)))
					{
						head.purge_oldorigin = head.origin; // hold original position before warp
						head.purge_targ = self;
						head.owner.purge_toggle = TRUE; // stops camera from moving during purge
						
						player_prop(head); // spawn fading clone
						
						if (max_hit_ents < 10)
						{
							// spawn a hit sprite
							effect = spawn();
							setorigin(effect, self.origin);
							if (!sprite)
								setmodel(effect, "progs/hit.spr");
							else
								setmodel(effect, "progs/hit2.spr");

							effect.effects = EF_NODEPTHTEST;
							effect.movetype = MOVETYPE_NOCLIP;
							effect.alpha = 1;
							effect.scale = 1;
							effect.angles_z = random()*360;
							effect.angles_y = -90; // face camera
							effect.think = fx_think;
							effect.nextthink = time;
							effect.solid = SOLID_NOT;
							max_hit_ents = max_hit_ents + 1;
						}

						if (head.origin_x < self.origin_x)
							head.angles_y = 0;
						else
							head.angles_y = 180;

						WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
						WriteByte (MSG_BROADCAST, TE_TELEPORT);
						WriteCoord (MSG_BROADCAST, head.origin_x);
						WriteCoord (MSG_BROADCAST, head.origin_y);
						WriteCoord (MSG_BROADCAST, head.origin_z);

						setorigin (head, self.origin);

						WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
						WriteByte (MSG_BROADCAST, TE_TELEPORT);
						WriteCoord (MSG_BROADCAST, self.origin_x);
						WriteCoord (MSG_BROADCAST, self.origin_y);
						WriteCoord (MSG_BROADCAST, self.origin_z);

						// Damage stuff needs to go at the end otherwise fields get cleared improperly
						sound (self, CHAN_AUTO, "player/bigcut.wav", 1, ATTN_NORM);
						self.damage_type = 5; // cut in half

						local float purge_dmg = 100 + (33 * head.owner.swordlevel);
						T_Damage (self, head, head, purge_dmg, 0);

						head.owner.speedline_time = time + 0.35;
						head.think = player_purge1; // Do something cool
						head.nextthink = time;
						head.owner.combo = head.owner.combo + 1; // raise combo counter

						if (head.owner.mana < head.owner.max_mana)
							head.owner.mana = head.owner.mana + (head.owner.max_mana / 4);
						if (head.owner.mana > head.owner.max_mana)
							head.owner.mana = head.owner.max_mana;

						head.owner.screenflash_finished = time + 0.015;
						head.pain_finished = head.fly_time = time; // Fixes players keys being locked if broken is inflicted and a purge happens

						return;
					}

					//
					// Deathmatch properties
					//

					if (deathmatch) // All damage in deathmatch is divided by 3, aside from certain attacks
						damg = damg / 3;

					//

					// spawn a hit sprite
					if (max_hit_ents < 10)
					{
						effect = spawn();
						if (head.solid != SOLID_BSP)
							setorigin(effect, head.origin);
						else
						{
							h = head.absmin + ((head.absmax - head.absmin) * 0.5);
							setorigin(effect, h);
						}
						if (!sprite)
							setmodel(effect, "progs/hit.spr");
						else
							setmodel(effect, "progs/hit2.spr");

						effect.effects = EF_NODEPTHTEST;
						effect.movetype = MOVETYPE_NOCLIP;
						effect.alpha = 1;
						effect.scale = 1;
						effect.angles_z = random()*360;
						effect.angles_y = -90; // face camera
						effect.solid = SOLID_NOT;
						effect.think = fx_think;
						effect.nextthink = time;
						max_hit_ents = max_hit_ents + 1;
					}

					//
					// Hit sounds
					//

					if (snd == 0)
						sound (self, CHAN_AUTO, "player/swordhit.wav", 1, ATTN_NORM);
					else if (snd == 1)
						sound (self, CHAN_AUTO, "player/kickhit.wav", 1, ATTN_NORM);
					else if (snd == 2)
						sound (self, CHAN_AUTO, "player/jmphit.wav", 1, ATTN_NORM);
					else if (snd == 3)
						sound (self, CHAN_AUTO, "player/hit.wav", 1, ATTN_NORM);
					else if (snd == 4)
						sound (self, CHAN_AUTO, "player/bighit.wav", 1, ATTN_NORM);
					else if (snd == 5)
						sound (self, CHAN_AUTO, "player/bigcut.wav", 1, ATTN_NORM);
					else if (snd == 6)
						sound (self, CHAN_AUTO, "player/hugekick.wav", 1, ATTN_NORM);
					else if (snd == 7)
						sound (self, CHAN_AUTO, "player/izunahit.wav", 1, ATTN_NORM);
					// over 7 is blank/silent

					if (head.grabbed)
						head.grabbed = FALSE;

					if (!head.noblood)
					{
						ThrowBloodSplat(head.origin, head);
						// Throw particle blood
						local	vector	vel;
						vel = normalize(dir + v_up*crandom() + v_right*crandom());
						vel = vel * 200;
						particle (head.origin, vel*0.4, 79, 16);
					}
					
					if (self.classname == "player") // put mana on the dummy players owner, increase combo meter
					{
						if (self.owner.mana < self.owner.max_mana)
							self.owner.mana = self.owner.mana + 1;
						if (!deathmatch)
							self.owner.combo = self.owner.combo + 1; // raise combo counter
					}

					// Be sure not to turn breakable walls, it'll cause em to disappear/reappear
 					// flip the appropriate victim around to face attacker from behind
					if (head.solid != SOLID_BSP && head.classname != "breakable" && !head.flags & FL_BOSS)
					{
						if (self.angles_y > 90 && self.angles_y < 270) // Attacker facing right
							head.angles_y = 0; // victim faces left
						else
							head.angles_y = 180; // victim faces right
					}

					//
					// Knock Back physics / T_Damage
					//
					
					head.knockback = knokback;
						
					if (head.swimming) // Vigil only takes one type of knock back underwater
						head.knockback = 4;
					if (knokback == 2) // send opponent straight up in the air
						head.nopain_time = time + 0.3;
					if (self.attack_type == 6) // jump kick 1 hit
						self.attack_type = 7;
					else if (self.attack_type == 7) // jump kick 2 hit
						self.attack_type = 0;

					head.damage_type = self.attack_type;
					T_Damage (head, self, self, damg, statusrand);

					// Vigil's attack_type is set to 0 in player_fire (each attack button press)
					if (self.attack_type < 6 && self.flags & FL_MONSTER)
						self.attack_type = 0;

					if (self.classname == "player" && head.solid != SOLID_BSP && head.classname != "breakable")
						self.enemy = head; // record which entity vigil hit

					self.attackedname = head.classname; // record on every strike

					self.beenblocked = time; // remove blocking on attacker
					self.attackhit = time + 0.35;
						
					//
					// Air Comboing physics, Y axis (Up/Down) is halted
					//

					if (!self.flags & FL_ONGROUND && !ignoreair && !self.grabbed) // If in air
					{
						head.aircombo_finished = time + 0.5; // Allow the monster to be tracked!
						if (!self.swimming)
						{
							if (self.frame != 241) // non-spin cut physics
							{
								self.velocity_x = 0; // reset x velocity
								if (self.angles_y >= 90 && self.angles_y <= 270)
									self.velocity_x = head.velocity_x = -100;
								else
									self.velocity_x = head.velocity_x = 100;
							}
							else
								head.velocity = self.velocity; // spin cut physics

							self.velocity_z = self.velocity_y = 0;
							if (!head.ignoreaircombo)
								self.velocity_z = head.velocity_z = self.velocity_z + 150; // raise player/monsters in the air after each successful air hit
							else
								self.velocity_z = self.velocity_z + 150; // Only raise player
						}
					}
				}
			}
			else // Blocking routine
			{
				if (self.flags & FL_MONSTER && !head.flags & FL_MONSTER || !self.flags & FL_MONSTER) // fix monsters pretending to hit each other
				{
					if (self.attackhit < time)
						self.beenblocked = time + 0.35;

					if (self.attack_type == 6) // jump kick 1 hit
						self.attack_type = 7;
					else if (self.attack_type == 7) // jump kick 2 hit
						self.attack_type = 0;

					if (self.attack_type < 6)
					{
						if (self.flags & FL_MONSTER) // Vigil's attack_type is set to 0 on each attack button press
							self.attack_type = 0;
					}
					self.attackedname = head.classname; // record on every strike

					// flip the player around to face attacker from behind, except if it's a breakable wall
					// or a destroyable object - that'd just be silly...
					if (head.solid != SOLID_BSP && head.classname != "breakable")
					{
						if (self.angles_y >= 90 && self.angles_y <= 270) // Attacker facing right
							head.angles_y = 0; // Block victim faces left
						else
							head.angles_y = 180; // Block victim faces right
					}

					// spawn a block sprite, except on PG timing
					if (head.perfectblock < time)
					{
						if (max_block_ents < 6)
						{
							effect = spawn();
							setorigin(effect, head.origin);
							setmodel(effect, "progs/block.spr");
							effect.classname = "blockfx";
							effect.angles_y = -90;
							effect.angles_z = random()*360;
							effect.effects = EF_NODEPTHTEST;
							effect.movetype = MOVETYPE_NONE;
							effect.solid = SOLID_NOT;
							effect.owner = head;

							// Guard break vfx
							if (head.perfectblock < time && head.perfectguard_buff < time && head.classname == "player" && !deathmatch)
								effect.knockback = knokback; // For guard breaking
							// block count updates below this
							if (!deathmatch && head.blockcount > 0 || effect.knockback == 2 || effect.knockback == 3 || effect.knockback == 5)
							{
								if (head.blockcount == 1)
								{
									effect.scale = 1.25;
									effect.frame = 1;
								}
								if (head.blockcount == 2)
								{
									effect.frame = 2;
									effect.scale = 1.5;
								}
								if (head.blockcount == 3 || effect.knockback == 2 || effect.knockback == 3 || effect.knockback == 5)
								{
									sound (effect, CHAN_AUTO, "player/gardcrsh.wav", 1, ATTN_NORM);
									effect.frame = 3;
									effect.scale = 2;
								}
							}
							effect.think = fx_think;
							effect.nextthink = time + 0.1;
							max_block_ents = max_block_ents + 1;
						}
					}
					head.knockback = 0; // remove knockback on block

					// throw particle effects
					if (block_sparks_limit < 25)
					{
						local float i;
						if (!coop && !deathmatch)
						{
							if (head.perfectblock < time)
								self.block_sparks = 4;
							else
								self.block_sparks = 8;
						}
						else
							self.block_sparks = 2; // multiplayer optimization
						i = -0.25*self.block_sparks + random()*0.5*self.block_sparks;
						while (i < self.block_sparks)
						{
							local entity spark;
							spark = spawn();
							spark.owner = self;
							setmodel (spark, "progs/particle.mdl");
							setorigin (spark, head.origin);
							spark.movetype = MOVETYPE_BOUNCE;
							spark.solid = SOLID_NOT;
							spark.gravity = 0.3;
							if (head.angles_y == 0)
							{
								spark.velocity_x = 0 + random() * 140;
								spark.velocity_y = 0 + random() * 140;
							}
							else
							{
								spark.velocity_x = 0 + random() * -140;
								spark.velocity_y = 0 + random() * -140;
							}
							spark.velocity_z = 0 + random() * 140;					
							spark.avelocity = '3000 3000 3000';
							spark.nextthink = time + 0.2 + 0.8*random();
							spark.think = sparks_fade1;
							spark.classname = "spark";

							if (head.perfectblock < time)
							{
								if (random() < 0.33)
									spark.skin = 0;
								else if (random() < 0.5)
									spark.skin = 1;
								else
									spark.skin = 2;
							}
							else // blue sparks on PG
							{
								spark.skin = 3;
								spark.colormod = '0 0 255';
							}

							setsize (spark, '0 0 0', '0 0 0');
							i = i + 1;
							block_sparks_limit = block_sparks_limit + 1;
						}
					}

					// block
					makevectors (self.angles);
					if (head.classname == "player")
					{
						head.purge_cooldown = time; // successful block removes any purge cooldowns
						head.enemy = self; // Update who attacked Vigil last
						if (head.perfectblock < time && head.perfectguard_buff < time)
							head.knockback = knokback; // For guard breaking
						else
							head.knockback = 0;
							
						head.effects = EF_MUZZLEFLASH; // create light on melee impact
						if (head.knockback == 2 || head.knockback == 3 || head.knockback == 5) // Guard break + Chip damage
						{
							// Set the knockback, deal the damage, then have the player run his animation in proper order
							float chip_d = floor(damg / 4); // Guard breaks have chip damage
							self.knockback = head.knockback = 0; // Knockback movement is done by $blockbrk1

							T_Damage (head, self, self, chip_d, statusrand);

							if (head.health > 0 && head.health > chip_d) // Don't override death routine
								head.think = player_blockbrk1;
							else
								return; // needed otherwise death physics on chip-damage death get overwritten
						}
						else
						{
							if (!deathmatch)
								head.blockcount = head.blockcount + 1;
							head.blockcount_finished = time + 0.75; // blockcount reset timer
							if (head.blockcount > 3) // guard crushed
							{
								self.knockback = head.knockback = 0; // Knockback movement is done by $blockbrk1
								head.owner.block_finished = time;
								head.think = player_blockbrk1;
								head.blockcount = 0; // reset guard crush
							}
							else
							{
								head.think = player_block;
								if (head.onground)
									head.counter_finished = time + 0.3;
							}
						}
						head.knockback = 0; // reset!
						head.nextthink = time;
					}
					if (self.flags & FL_MONSTER || deathmatch) // Only monsters are pushed backwards if attack is perfect guarded, unless deathmatch
					{
						self.velocity = '0 0 0'; // reset velocity
						if (self.flags & FL_ONGROUND) // required
							self.flags = self.flags - (self.flags & FL_ONGROUND);

						// Perfect block was performed on me!
						// give Vigil buffs!
						if (head.perfectblock > time)
						{
							if (self.berserk_finished > time) // perfect block removes
								self.berserk_finished = time; // monsters being enraged

							self.velocity_z = 175;
							if (self.angles_y == 0) // push back
								self.velocity_x = -80;
							else
								self.velocity_x = 80;

							PerfectGuard(head); // Call PG before pain, for conditional checks on monsters self.th_pain status
							if (self.th_pain) // stun em
							{
								self.knockback = 0; // reset knockback, don't hold it!
								if (self.paincount > 0)
									self.paincount = self.paincount - 1; // counteract
								if (self.th_pain)
									self.th_pain();
								self.colormod = '5 5 0'; // melee monsters get a colormod effect
							}
						}
					}

					//
					// Air Comboing physics
					//

					if (!self.flags & FL_ONGROUND)
					{
						head.knockback = knokback;
						if (head.flags & FL_MONSTER) // apply monster physics
						{
							monster_pain(head);
							head.knockback = 0; // reset

							head.aircombo_finished = time + 0.5; // Tell monsters he's being air comboed
							if (!ignoreair && !self.grabbed)
							{
								if (self.frame != 241) // non-spin cut physics
								{
									self.velocity_x = 0; // reset x velocity
									if (self.angles_y >= 90 && self.angles_y <= 270)
										self.velocity_x = head.velocity_x = -100;
									else
										self.velocity_x = head.velocity_x = 100;
								}
								else
									head.velocity = self.velocity; // spin cut physics

								self.velocity_z = 0; // reset Z velocity first
								self.velocity_z = head.velocity_z = self.velocity_z + 150; // raise vigil/monsters in the air after each successful air hit
							}
							self.velocity_y = 0; // remove Vigil's foreground / background movement
						}
						// apply player physics
						else if (head.classname == "player" && !head.onground)
						{
							player_damage_physics(head);
							head.knockback = 0; // reset
						}
					}
					if (head.perfectblock < time)
						sound (self, CHAN_BODY, "player/block.wav", 1, ATTN_NORM);
				}
			}
		}
		head = head.chain; // cycle to next entity
	}
};

//
//
//