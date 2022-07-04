//+-------+
//|Pickups|
//+-------+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| All items that are able to be picked up and used are held here.            |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

void() SUB_regen =
{
	self.model = self.mdl;
	self.solid = SOLID_TRIGGER;
	setorigin (self, self.origin);
};

void() ItemTextFade =
{
	if (self.cnt2 > 0)
		self.cnt2 = self.cnt2 - 0.01;
	else
	{
		remove(self);
		return;
	}

	self.velocity_z = 25;
	self.SendFlags |= 1; // send origin
	frameskip(0.01);
};

void() item_health_CSQC_draw =
{
	local entity x;

	x = spawn();
	if (self.classname == "priest")
		setorigin (x, self.enemy.origin);
	else
		setorigin (x, self.origin);
	x.movetype = MOVETYPE_NOCLIP;
	x.classname = "DrawHealthEntity";
	x.cnt = self.cnt; // copy health value
	x.alpha = 1;
	x.effects = EF_NODEPTHTEST;
	x.cnt2 = 1.5; // removal 
	
	x.SendEntity = SendEntityToCSQC;

	x.SendFlags |= 32; // send health #
	x.SendFlags |= 1; // send origin
	x.SendFlags |= 8; // send effects
	x.SendFlags |= 16; // send classname
	
	x.think = ItemTextFade;
	x.nextthink = time + 0.1;
};

void() item_hpmaxup_think =
{
	if (framecount > 4) // This should only happen once on level change
		return;			// also this allows other co-op players to grab

	if (!self.spawnflags)
	{
		if (hp_max_ups & IT_HPMAXUP1) // HP Max UP 1
		{
			remove(self);
			return;
		}
	}
	if (self.spawnflags & 1)
	{
		if (hp_max_ups & IT_HPMAXUP2) // HP Max UP 2
		{
			remove(self);
			return;
		}
	}
	if (self.spawnflags & 2)
	{
		if (hp_max_ups & IT_HPMAXUP3) // HP Max UP 3
		{
			remove(self);
			return;
		}
	}
	if (self.spawnflags & 4)
	{
		if (hp_max_ups & IT_HPMAXUP4) // HP Max UP 4
		{
			remove(self);
			return;
		}
	}
	if (self.spawnflags & 8)
	{
		if (hp_max_ups & IT_HPMAXUP5) // HP Max UP 5
		{
			remove(self);
			return;
		}
	}
	if (self.spawnflags & 16)
	{
		if (hp_max_ups & IT_HPMAXUP6) // HP Max UP 6
		{
			remove(self);
			return;
		}
	}

	frameskip (0.1);
};

void() DisplayHPMaxUpThink =
{
	local vector x;
	x = self.owner.angles;
	x_x = 0;
	x_z = 0;
	makevectors(x);

	if (self.angles_y > 385)
	{
		remove(self);
		return;
	}
	self.angles_y = self.angles_y + 0.25 * (100 * frametime);

	self.origin_x = self.owner.origin_x;
	self.origin_y = self.owner.origin_y;
	self.origin_z = self.owner.origin_z + 48;
	frameskip(0.01);
};

void(entity h) DisplayHPMaxUp =
{
	local entity hpmax;

	hpmax = spawn();
	setorigin(hpmax, h.origin + v_up*48);
	setmodel(hpmax, "progs/hpmaxup.spr");
	setsize(hpmax, '0 0 0', '0 0 0');
	hpmax.solid = SOLID_NOT;
	hpmax.owner = h;
	hpmax.takedamage = DAMAGE_NO;
	hpmax.classname = "hpmaxupsign";
	hpmax.movetype = MOVETYPE_NOCLIP;
	hpmax.angles_y = 180; // -90 is flat, +45 is what I want
	hpmax.angles_x = 0; // display towards screen
	hpmax.fixangle = TRUE;
	hpmax.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
	hpmax.think = DisplayHPMaxUpThink;
	hpmax.nextthink = time;
};

void() item_hpmaxup_touch =
{
	// make sure dead players can't pick up the health potion...
	if (other.classname != "player" || other.health < 1)
		return;
	if (!other.owner)
		return;
	
	// Give max HP to ALL players
	local entity y = find(world, classname, "player");
	while (y)
	{
		if (y) // dead bodies shant go solid
		{
			DisplayHPMaxUp(y);
			sound (self, CHAN_ITEM, "misc/hpmaxup.wav", 1, ATTN_NORM);	
			y.owner.max_health = y.owner.max_health + 5; // add + 5 max health
			y.max_health = y.max_health + 5; // add + 5 max health
			if (y.health > 0) // don't revive dead players and zombie them
				y.health = y.health + 5; // add + 5 health as well
			y.rainbow_finished = time + 1; // rainbow
		}
		y = find(y, classname, "player");
	}
	y = find(world, classname, "player");

	
	if (!self.spawnflags)
			hp_max_ups = hp_max_ups | IT_HPMAXUP1; // Add it
	else if (self.spawnflags & 1)
			hp_max_ups = hp_max_ups | IT_HPMAXUP2; // Add it
	else if (self.spawnflags & 2)
			hp_max_ups = hp_max_ups | IT_HPMAXUP3; // Add it
	else if (self.spawnflags & 4)
			hp_max_ups = hp_max_ups | IT_HPMAXUP4; // Add it
	else if (self.spawnflags & 8)
			hp_max_ups = hp_max_ups | IT_HPMAXUP5; // Add it
	else if (self.spawnflags & 16)
			hp_max_ups = hp_max_ups | IT_HPMAXUP6; // Add it


	freeze_finished = time + 10 * frametime; // slow-mo
	
	SUB_UseTargets(); // fire any activators

	remove(self);
	return;
};

/*QUAKED item_hpmaxup (0 .5 .8) (0 0 0) (20 20 20)
*/
void() item_hpmaxup =
{
	precache_model ("progs/hpmaxup.mdl");
	precache_model ("progs/hpmaxup.spr");
	precache_sound ("misc/hpmaxup.wav");

	self.movetype = MOVETYPE_NONE;
	setmodel (self, "progs/hpmaxup.mdl");
	setsize (self, '0 0 0', '0 0 0');
	self.solid = SOLID_TRIGGER;
	self.classname = "item_hpmaxup";
	self.flags = FL_ITEM;
	self.angles_y = 90;
	self.touch = item_hpmaxup_touch;
	self.think = item_hpmaxup_think;
	self.nextthink = time + 0.1;
	self.effects = EF_FULLBRIGHT;
	
	// Give off RT Light
	spawn_color_glow(3, 3, 3, 35, self);

	droptofloor();
};

//============
// Health potion
//============

void() item_health_touch =
{
	self.SendFlags |= 1; // send origin

	// make sure dead players can't pick up the health potion...
	if (other.classname != "player" || other.health < 1)
		return;
	if (!other.owner)
		return;
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1; // pick up time

	SUB_UseTargets(); // fire any activators

	if (other.health >= other.max_health && other.owner.hflask_amt >= other.owner.hflask_max_amt)
		return;

	if (difficulty == 0) // Easy mode
		self.cnt = self.cnt * ceil(1.25);
	if (!self.cnt2)
		self.cnt2 = self.cnt; // Store original value for safe keeping

	// Debug messages
	// local string s = ftos(self.cnt);
	// bprint ("First CNT Value: ", s, "\n");

	sound (self, CHAN_ITEM, "misc/pickup.wav", 1, ATTN_NORM);

	// Add Health to Flask First, if Flask is full then heal the player instead
	local float calc = other.owner.hflask_max_amt - other.owner.hflask_amt;
	local float calc2 = other.owner.max_health - other.owner.health;
	
	if (calc > self.cnt)
		calc = self.cnt;
	
	// Debug messages
	/*
	local string s = ftos(calc);
	bprint ("Calc: ", s, " ");
	local string s = ftos(calc2);
	bprint ("Calc2: ", s, " ");
	*/
	
	if (self.cnt > 0)
	{
		if (other.owner.hflask_amt < other.owner.hflask_max_amt)
		{
			other.owner.hflask_amt = other.owner.hflask_amt + calc;
			self.cnt = self.cnt - calc;
		}
		else if (calc <= 0 && other.health < other.max_health)
		{
			other.health = other.health + self.cnt; // flask is full, insta-heal player
			self.cnt = self.cnt - calc2;
		}
	}
	
	if (self.cnt < 0)
		self.cnt = 0;

	// Debug messages
	// local string s = ftos(self.cnt);
	// bprint ("Cnt: ", s, "\n");

	// spawn draw CSQC entity here
	item_health_CSQC_draw(); // Show how much .cnt is left in the bottle...

	if (other.health > other.max_health) // cap health
		other.health = other.max_health;
	if (other.owner.hflask_amt > other.owner.hflask_max_amt) // cap flask
		other.owner.hflask_amt = other.owner.hflask_max_amt;

	if (self.cnt <= 0)
	{
		if (deathmatch)
		{
			self.model = string_null;
			self.solid = SOLID_NOT;
			self.cnt = self.cnt2; // restore amount
			self.think = SUB_regen;
			self.nextthink = time + 60;
		}
		else
			remove(self);
	}
};

/*QUAKED item_health (0 .5 .8) (0 0 0) (20 20 20)
"cnt":
25 (Default) how much vitality the health potion restores
*/
void() item_health =
{
	precache_model ("progs/hpot.mdl");

	self.movetype = MOVETYPE_NONE;
	setmodel (self, "progs/hpot.mdl");
	self.mdl = self.model; // can be restored on respawn
	setsize (self, '0 0 0', '0 0 0');
	self.solid = SOLID_TRIGGER;
	self.classname = "item_health";
	self.flags = FL_ITEM;
	self.effects = EF_FULLBRIGHT;
	self.angles_y = 90;
	self.touch = item_health_touch;

	// Give off RT Light
	spawn_color_glow(3, 0, 0, 35, self);
	
	if (!self.cnt)
		self.cnt = 35; // default health give amount
	droptofloor();
};


void() healthp_think =
{
	self.SendFlags |= 1; // send origin
	self.SendFlags |= 2; // send frame #

	if (vlen(self.velocity) < 1 || self.flags & FL_ONGROUND || self.velocity_z == 0 || self.origin == self.oldorigin)
	{
		if (self.angles_x != 0 || self.angles_z != 0)
		{
			self.avelocity = '0 0 0';
			self.angles_x = self.angles_z = 0;
			sound (self, CHAN_BODY, "misc/potland.wav", 1, ATTN_NORM);
			setorigin(self, self.origin + v_up*1);
			return;
		}
	}
	self.oldorigin = self.origin;
	
	frameskip(0.02);
};

void() drop_health =
{
	local entity healthp;

	if (deathmatch)
		return;

	healthp = spawn();
	healthp.velocity_z = 200;
	healthp.angles_y = random() * 360;
	makevectors (healthp.angles);
	healthp.velocity = v_forward * 50;
	healthp.movetype = MOVETYPE_TOSS;
	setorigin (healthp, self.origin);
	setmodel (healthp, "progs/hpot.mdl");
	setsize (healthp, '0 0 0', '0 0 0');
	healthp.solid = SOLID_TRIGGER;
	healthp.classname = "health potion";
	healthp.flags = FL_ITEM;
	healthp.effects = EF_FULLBRIGHT;
	healthp.touch = item_health_touch;
	healthp.avelocity = '300 -80 500';
	healthp.owner = world;

	if (self.cnt) // give barrels cnt value to potion
		healthp.cnt = self.cnt;
	else
		healthp.cnt = 5;

	// Give off RT Light
	spawn_color_glow(3, 0, 0, 35, healthp);
	
	//healthp.SendEntity = SendEntityToCSQC;
	healthp.SendFlags |= 1; // send origin
	healthp.SendFlags |= 8; // send .effects
	healthp.SendFlags |= 16; // send classname
	
	healthp.think = healthp_think;
	healthp.nextthink = time + 0.1;
	
};

//============
// Mana potion
//============

void() item_mana_CSQC_draw =
{
	local entity x;

	x = spawn();
	setorigin (x, self.origin);
	x.movetype = MOVETYPE_NOCLIP;
	x.classname = "DrawManaEntity";
	x.cnt = self.cnt; // copy health value
	x.alpha = 1;
	x.effects = EF_NODEPTHTEST;
	x.cnt2 = 1.5; // removal 

	x.SendEntity = SendEntityToCSQC;

	x.SendFlags |= 32; // send mana #
	x.SendFlags |= 1; // send origin
	x.SendFlags |= 8; // send effects
	x.SendFlags |= 16; // send classname
	
	x.think = ItemTextFade;
	x.nextthink = time + 0.1;
};

void() item_mana_touch =
{
	self.SendFlags |= 1; // send origin

	// make sure dead players can't pick up the mana potion...
	if (other.classname != "player" || other.health < 1)
		return;
	if (self.playerid & other.owner.playerid)
		return;
	if (!other.owner)
		return;
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1; // pick up time

	SUB_UseTargets(); // fire any activators
	
	if (other.owner.mana >= other.owner.char.max_mana)
		return;

	// spawn draw CSQC entity here
	item_mana_CSQC_draw();

	sound (self, CHAN_ITEM, "misc/pickup.wav", 1, ATTN_NORM);
	other.owner.mana = other.owner.mana + self.cnt; // give the mana

	if (other.owner.mana > other.owner.max_mana)
		other.owner.mana = other.owner.max_mana;
	
	if (deathmatch)
	{
		self.model = string_null;
		self.solid = SOLID_NOT;
		self.think = SUB_regen;
		self.nextthink = time + 30;
		return;
	}
	else
		remove(self);
};

/*QUAKED item_mana (0 .5 .8) (0 0 0) (20 20 20)
"cnt":
25 (Default) how much mana the mana potion restores
*/
void() item_mana =
{
	precache_model ("progs/mpot.mdl");

	self.movetype = MOVETYPE_NONE;
	setmodel (self, "progs/mpot.mdl");
	self.mdl = self.model; // can be restored on respawn
	setsize (self, '0 0 0', '0 0 0');
	self.solid = SOLID_TRIGGER;
	self.classname = "mana potion";
	self.flags = FL_ITEM;
	self.effects = EF_FULLBRIGHT;
	self.angles_y = 90;
	self.touch = item_mana_touch;

	// Give off RT Light
	spawn_color_glow(0, 0, 3, 35, self);
	
	if (!self.cnt)
		self.cnt = 25; // default mana give amount

	droptofloor();
};

void() manap_think =
{
	self.SendFlags |= 1; // send origin
	self.SendFlags |= 2; // send frame #

	if (vlen(self.velocity) < 1 || self.flags & FL_ONGROUND || self.velocity_z == 0 || self.origin == self.oldorigin)
	{
		if (self.angles_x != 0 || self.angles_z != 0)
		{
			self.avelocity = '0 0 0';
			self.angles_x = self.angles_z = 0;
			sound (self, CHAN_BODY, "misc/potland.wav", 1, ATTN_NORM);
			setorigin(self, self.origin + v_up*1);
			return;
		}
	}
	self.oldorigin = self.origin;
	
	frameskip(0.02);
};

void() drop_mana =
{
	local entity manap;

	if (deathmatch)
		return;

	manap = spawn();
	manap.velocity_z = 200;
	manap.angles_y = random() * 360;
	makevectors (manap.angles);
	manap.velocity = v_forward * 50;
	manap.movetype = MOVETYPE_TOSS;
	setorigin (manap, self.origin);
	setmodel (manap, "progs/mpot.mdl");
	setsize (manap, '0 0 0', '0 0 0');
	manap.solid = SOLID_TRIGGER;
	manap.classname = "mana potion";
	manap.flags = FL_ITEM;
	manap.effects = EF_FULLBRIGHT;
	manap.touch = item_mana_touch;
	manap.avelocity = '300 -80 500';
	manap.owner = world;

	if (self.cnt) // give barrels cnt value to potion
		manap.cnt = self.cnt;
	else
		manap.cnt = 5;

	// Give off RT Light
	spawn_color_glow(0, 0, 3, 35, manap);
	
	//manap.SendEntity = SendEntityToCSQC;
	manap.SendFlags |= 1; // send origin
	manap.SendFlags |= 8; // send .effects
	manap.SendFlags |= 16; // send classname
	
	manap.think = manap_think;
	manap.nextthink = time + 0.1;
	
};

void() item_key_touch =
{
	if (other.classname != "player" || other.health <= 0)
		return;

	sound (self, CHAN_ITEM, "misc/pickup.wav", 1, ATTN_NORM);

	if (self.cnt == 0)
	{
		if (cvar("developer") != 3) // Demo / Attract recording mode
		{
			centerprint (other.owner, "/P^bChurch Key^b\n\n===========================\n\nYou found a key labelled ''Church''.\n\n\n^3Press ATTACK or JUMP to resume ...");
			setpause(1);
			keys = keys | IT_KEY1;
		}
	}
	else if (self.cnt == 1)
	{
		sprint (other.owner, "You found a mysterious silver key!\n");
		keys = keys | IT_KEY2;
	}
	SUB_UseTargets(); // fire any activators

	remove(self);
	return;
};

void() item_key_think =
{
	if (keys > 0 && self.cnt == 0) // User has gold key, remove it from level
	{
		remove(self);
		return;
	}
	else if (keys > 1 && self.cnt == 1) // User has silver key, remove it from level
	{
		remove(self);
		return;
	}
	frameskip(0.1);
};

/*QUAKED item_key (0 .5 .8) (0 0 0) (20 20 20)
Gold key item to open the main gold key door
*/
void() item_key =
{
	precache_model ("progs/key.mdl");

	self.movetype = MOVETYPE_NONE;
	setmodel (self, "progs/key.mdl");
	setsize (self, '0 0 0', '0 0 0');
	self.solid = SOLID_TRIGGER;
	self.classname = "key";
	self.flags = FL_ITEM;
	self.think = item_key_think;
	self.touch = item_key_touch;

	if (self.cnt == 0)
		self.skin = 0;
	else
		self.skin = 1;

	frameskip(0.1);
	droptofloor();
};


void() relic_touch =
{
	if (other.classname != "player" || other.health <= 0)
		return;

	if (cvar("developer") != 3) // Demo / Attract recording mode
	{
		if (self.items & IT_RELIC1)
			centerprint (other.owner, "/P^bIron Grip Obtained!^b\n\n===========================\n\n\n^1Grab and hoist up ledges\n\n\nPerformed by jumping towards a ledge and using UP direction to climb,\nto let go and fall press DOWN or BLOCK\n\n\n\n^3Press ATTACK or JUMP to resume ...");
		else if (self.items & IT_RELIC2)
			centerprint (other.owner, "/P^bAscending Feather Obtained!^b\n\n===========================\n\n\n^1Perform a double jump\n\n\nPerformed by pressing JUMP again in mid-air\n\nYou may now perform Vigil's Uppercut Slice (UP + ATTACK in MID-AIR)\n\n\n\n^3Press ATTACK or JUMP to Resume ...");
		else if (self.items & IT_RELIC3)
			centerprint (other.owner, "/P^bSpin Slash Obtained!^b\n\n===========================\n\n\n^1Double jump can now damage and combo enemies, may slash through certain obstacles\n\n\nPerform by double jumping\n\n\n\n^3Press ATTACK or JUMP to resume ...");
		else if (self.items & IT_RELIC4)
			centerprint (other.owner, "/P^bSkewer Clutch Obtained!^b\n\n===========================\n\n\n^1Grab and jump off walls\n\n\nPerformed by JUMPING or being in MID-AIR and HOLDING the DIRECTION towards a flat wall\nPress ATTACK during a WALL GRAB to jump kick off the wall into enemies\n\n\n\n^3Press ATTACK or JUMP to resume ...");
		else if (self.items & IT_RELIC5)
			centerprint (other.owner, "/P^bSpider Boots Obtained!^b\n\n===========================\n\n\n^1Run across walls\n\n\nPerformed by pressing UP against a FLAT back wall and FORWARD direction while RUNNING\n\n\n\n^3Press ATTACK or JUMP to resume ...");
		else if (self.items & IT_RELIC6)
			centerprint (other.owner, "/P^bWater Breathing Amulet Obtained!^b\n\n===========================\n\n\n^1Breathe underwater forever\n\n\n\n^3Press ATTACK or JUMP to resume ...");
		else if (self.items & IT_RELIC7)
		{
			other.owner.displayname = ""; // Remove monster name on obtaining relic
			centerprint (other.owner, "/P^bCube of Knowledge Obtained!^b\n\n===========================\n\n\n^1Shows enemies name\n\n\n\n^3Press ATTACK or JUMP to resume ...");
		}
		else if (self.items & IT_RELIC8)
			centerprint (other.owner, "/P^bPerfect Guard Obtained!^b\n\n===========================\n\n\n^1Blocking an attack before it connects grants temporary invunerability as well as unblockable attacks, enemies are knocked back and any enhancements are negated\n\nPerfect Guarding a magic spell will absorb the mana cost and add it to Vigils MP\n\n\n\n^3Press ATTACK or JUMP to resume ...");
		else if (self.items & IT_RELIC9)
			centerprint (other.owner, "/P^bSoul Candle Obtained!^b\n\n===========================\n\n\n^1Automatically lights up pitch black areas\n\n\n\n^3Press ATTACK or JUMP to resume ...");
		else if (self.items & IT_RELIC10)
			centerprint (other.owner, "/P^bBurning Epitome Obtained!^b\n\n===========================\n\n^1Flaming head smash unlocked\n\n\nPerformed by pressing DOWN + ATTACK MID-AIR after performing a Spin slash double jump or Uppercut Slice (UP + ATTACK in MID-AIR)\n\n\n^3Press ATTACK or JUMP to resume ...");

		setpause(1); // pause game on pickup
	}
	sound (self, CHAN_BODY, "misc/relic.wav", 1, ATTN_NORM);

	SUB_UseTargets(); // fire any activators

	relics = relics | self.items; // give relic

	remove(self);
	return;
};

void() relic_think =
{
	local entity p;

	if (self.cnt == 2)
		self.colormod = '0 0 1';
	if (self.cnt == 9)
		self.colormod = '1 0 0';
	
	if (self.cnt == 0 && relics & IT_RELIC1)
	{
		remove(self);
		return;
	}
	if (self.cnt == 1 && relics & IT_RELIC2)
	{
		remove(self);
		return;
	}
	if (self.cnt == 2 && relics & IT_RELIC3)
	{
		remove(self);
		return;
	}	
	if (self.cnt == 3 && relics & IT_RELIC4)
	{
		remove(self);
		return;
	}	
	if (self.cnt == 4 && relics & IT_RELIC5)
	{
		remove(self);
		return;
	}	
	if (self.cnt == 5 && relics & IT_RELIC6)
	{
		remove(self);
		return;
	}
	if (self.cnt == 6 && relics & IT_RELIC7)
	{
		remove(self);
		return;
	}
	if (self.cnt == 7 && relics & IT_RELIC8)
	{
		remove(self);
		return;
	}
	if (self.cnt == 8 && relics & IT_RELIC9)
	{
		remove(self);
		return;
	}
	if (self.cnt == 9 && relics & IT_RELIC10)
	{
		remove(self);
		return;
	}	
	frameskip(0.05);
};

/*QUAKED item_relic (0 .5 .8) (0 0 0) (20 20 20)
Award relic technique to !all! players
*/
void() item_relic =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	if (self.cnt == 0) // Ledge Grab
	{
		precache_model ("progs/relic1.mdl");
		setmodel (self, "progs/relic1.mdl");
	}
	else if (self.cnt == 1) // Double Jump
	{
		precache_model ("progs/relic2.mdl");
		setmodel (self, "progs/relic2.mdl");
	}
	else if (self.cnt == 2) // Combat Relic (Spin Slash)
	{
		precache_model ("progs/relic3.mdl");
		setmodel (self, "progs/relic3.mdl");
	}
	else if (self.cnt == 3) // Wall Grab
	{
		precache_model ("progs/relic4.mdl");
		setmodel (self, "progs/relic4.mdl");
	}
	else if (self.cnt == 4) // Spider Boots / Wall Run
	{
		precache_model ("progs/relic5.mdl");
		setmodel (self, "progs/relic5.mdl");
	}
	else if (self.cnt == 5) // Water Breathing
	{
		precache_model ("progs/relic6.mdl");
		setmodel (self, "progs/relic6.mdl");
	}
	else if (self.cnt == 6) // Cube of Knowledge
	{
		precache_model ("progs/relic7.mdl");
		setmodel (self, "progs/relic7.mdl");
	}
	else if (self.cnt == 7) // Perfect Guard
	{
		precache_model ("progs/relic8.mdl");
		setmodel (self, "progs/relic8.mdl");
	}
	else if (self.cnt == 8) // Soul Candle
	{
		precache_model ("progs/relic9.mdl");
		setmodel (self, "progs/relic9.mdl");
	}
	else if (self.cnt == 9) // Combat Relic (Burning Epitome)
	{
		precache_model ("progs/relic3.mdl");
		setmodel (self, "progs/relic3.mdl");
	}
	else
	{
		precache_model ("progs/filler.spr");
		setmodel (self, "progs/filler.spr");
	}

	precache_sound ("misc/relic.wav");

	self.alpha = self.mode = 1;
	self.movetype = MOVETYPE_NOCLIP;
	setsize (self, '-1 -1 -1', '1 1 1');
	self.solid = SOLID_TRIGGER;
	self.classname = "relic";
	self.flags = FL_ITEM;

	if (self.cnt == 0)
		self.items = IT_RELIC1;
	else if (self.cnt == 1)
		self.items = IT_RELIC2;
	else if (self.cnt == 2)
		self.items = IT_RELIC3;
	else if (self.cnt == 3)
		self.items = IT_RELIC4;
	else if (self.cnt == 4)
		self.items = IT_RELIC5;
	else if (self.cnt == 5)
		self.items = IT_RELIC6;
	else if (self.cnt == 6)
		self.items = IT_RELIC7;
	else if (self.cnt == 7)
		self.items = IT_RELIC8;
	else if (self.cnt == 8)
		self.items = IT_RELIC9;
	else if (self.cnt == 9)
		self.items = IT_RELIC10;

	// Give off RT Light
	spawn_color_glow(3, 0, 5, 50, self);

	self.touch = relic_touch;
	self.think = relic_think;
	self.nextthink = time + 0.1;
};

void() spellbook_touch =
{
	if (other.classname != "player" || other.health <= 0)
		return;

	if (cvar("developer") != 3) // Demo / Attract recording mode
	{
		if (self.items & IT_SPELL1)
			centerprint (other.owner, "/P^bLightning Storm Obtained!^b\n\n===========================\n\n^1Press the MAGIC button to select your spell with UP and DOWN\nPress MAGIC again to cast the selected spell\nPress JUMP or BLOCK to cancel out\n\n\n\n^3Press ATTACK or JUMP to resume...");
		else if (self.items & IT_SPELL2)
			centerprint (other.owner, "/P^bIce Field Obtained!^b\n\n===========================\n\n^1Press the MAGIC button to select your spell with UP and DOWN\nPress MAGIC again to cast the selected spell\nPress JUMP or BLOCK to cancel out\n\n\n\n^3Press ATTACK or JUMP to resume...");
		else if (self.items & IT_SPELL3)
			centerprint (other.owner, "/P^bFire Beam Obtained!^b\n\n===========================\n\n^1Press the MAGIC button to select your spell with UP and DOWN\nPress MAGIC again to cast the selected spell\nPress JUMP or BLOCK to cancel out\n\n\n\n^3Press ATTACK or JUMP to resume...");
		else if (self.items & IT_SPELL4)
			centerprint (other.owner, "/P^bTwister Obtained!^b\n\n===========================\n\n^1Press the MAGIC button to select your spell with UP and DOWN\nPress MAGIC again to cast the selected spell\nPress JUMP or BLOCK to cancel out\n\n\n\n^3Press ATTACK or JUMP to resume...");

		setpause(1);
	}
	sound (self, CHAN_BODY, "misc/spellbook.wav", 1, ATTN_NORM);
	SUB_UseTargets(); // fire any activators

	spells = spells | self.items;
	remove(self);
	return;
};

void() spellbook_think =
{
	local entity p;

	// spawn a particle moving around - single player only
	// to keep network traffic down
	if (!deathmatch && !coop)
	{
		p = spawn();
		p.movetype = MOVETYPE_NOCLIP;
		p.solid = SOLID_NOT;
		p.angles_x = random() * 360;
		makevectors (p.angles);
		p.velocity = v_forward * 75;
		setmodel (p, "progs/null.spr");
		setsize (p, '0 0 0', '0 0 0');
		setorigin (p, self.origin);
	}
	
	if (self.cnt == 0 && spells & IT_SPELL1)
	{
		remove(self);
		return;
	}
	if (self.cnt == 1 && spells & IT_SPELL2)
	{
		remove(self);
		return;
	}
	if (self.cnt == 2 && spells & IT_SPELL3)
	{
		remove(self);
		return;
	}
	if (self.cnt == 3 && spells & IT_SPELL4)
	{
		remove(self);
		return;
	}
	frameskip(0.05);
};

/*QUAKED item_spellbook (0 .5 .8) (0 0 0) (20 20 20)
Award spells to !all! players
*/
void() item_spellbook =
{
	precache_model("progs/book.mdl");
	setmodel (self, "progs/book.mdl");
	
	if (self.cnt == 0) // 
		self.skin = 0; // lightning storm
	else if (self.cnt == 1) //
		self.skin = 1; // ice field
	else if (self.cnt == 2) //
		self.skin = 2; // beam
	else
		self.skin = 3; // twister

	precache_sound ("misc/spellbook.wav");

	self.alpha = self.mode = 1;
	self.movetype = MOVETYPE_NONE;
	setsize (self, '-1 -1 -1', '1 1 1');
	self.solid = SOLID_TRIGGER;
	self.classname = "spellbook";
	self.flags = FL_ITEM;
	
	// Give off RT Light
	spawn_color_glow(0, 3, 0, 50, self);
	
	if (self.cnt == 0)
		self.items = IT_SPELL1;
	else if (self.cnt == 1)
		self.items = IT_SPELL2;
	else if (self.cnt == 2)
		self.items = IT_SPELL3;
	else if (self.cnt == 3)
		self.items = IT_SPELL4;

	self.touch = spellbook_touch;
	self.think = spellbook_think;
	self.nextthink = time + 0.1;
};

/*QUAKED item_gold (0 .5 .8) (0 0 0) (20 20 20)
Give gold to whomever touches
*/

void() item_gold_CSQC_draw =
{
	local entity x;

	x = spawn();
	setorigin (x, self.origin);
	x.movetype = MOVETYPE_NOCLIP;
	x.velocity_z = 25;
	x.classname = "DrawGoldEntity";
	x.cnt = self.cnt; // copy gold value
	x.alpha = 1;
	x.cnt2 = 1.5; // removal 
	
	x.SendEntity = SendEntityToCSQC;

	x.SendFlags |= 32; // send gold #
	x.SendFlags |= 1; // send origin
	x.SendFlags |= 8; // send effects
	x.SendFlags |= 16; // send classname
	
	x.think = ItemTextFade;
	x.nextthink = time + 0.1;
};

void() gold_think =
{
	self.SendFlags |= 1; // send origin
	self.SendFlags |= 2; // send frame #

	if (checkground(self)) //vlen(self.velocity) < 1 || self.flags & FL_ONGROUND || self.velocity_z == 0 || self.origin == self.oldorigin)
	{
		if (self.angles_x != 0 || self.angles_z != 0)
		{
			self.avelocity = '0 0 0';
			self.angles_x = self.angles_z = 0;
			sound (self, CHAN_BODY, "misc/gold.wav", 1, ATTN_NORM);
			self.frame = 0; // no spin
			self.angles_y = random()*360;
			setorigin(self, self.origin + v_up*1);
			return;
		}
	}
	self.oldorigin = self.origin;
	
	frameskip(0.02);
};

void() gold_touch =
{
	local float i, j, k;

	self.SendFlags |= 1; // send origin
	self.SendFlags |= 2; // send frame #

	if (self.playerid & other.owner.playerid)
		return;
	if (!self.flags & FL_ONGROUND)
		return;
	if (other.classname != "player")
		return;
	if (!other.owner)
		return;

	self.playerid = self.playerid + other.owner.playerid;

	i = 0;
	j = k = 1;

	while (i < players - 1)
	{
		j = j * 2;
		k = k + j;	
		i = i + 1;
	}

	//
	// Give gold start
	//
	
	sound (other, CHAN_AUTO, "misc/pickup.wav", 1, ATTN_NORM);

	// Display first pick up message
	if (other.owner.gold == 0 && players == 1 && cvar("developer") != 3)
	{
		centerprint (other.owner, "/P^bAcquired Gold^b\n\nGold can be used to buy upgrades & more\n\n===========================\n\n\n^1The higher number of strikes Vigil is able to chain together allows for more gold to be given when picked up!\n\n\n^3Press ATTACK or JUMP to resume ...");
		setpause(1);
	}

	local float aprice = 100 * floor(other.owner.level / 3.5); // Tied to wizards teleport to castle stuff
	if (world.model != "maps/village.bsp")
	{
		if (self.message == "breakable") // message string is used to see who dropped the gold without classname getting in the way from being removed
		{
			self.cnt = other.owner.level * 13 + ceil(random()*9);
			self.cnt = floor(self.cnt / 6);
		}
		else
		{
			if (other.owner.last_combo > 0)
				self.cnt = other.owner.level * 13 + ceil(random()*9) + ceil(other.owner.last_combo / 2);
			else
				self.cnt = other.owner.level * 13 + ceil(random()*9);
		}
	}
	else
	{
		if (other.owner.gold < aprice)
			self.cnt = other.owner.level * 13 + ceil(random()*9); // normal calc
		else
			self.cnt = 1 + random()*11; // give cheap change after reaching teleporter price
	}

	// Cap gold by maxgold amount set
	if (self.cnt > self.maxgold && self.maxgold > 0)
	{
		if (other.owner.last_combo > 0)
			self.cnt = self.maxgold + ceil(other.owner.last_combo / 2);
		else
			self.cnt = self.maxgold;
	}

	other.owner.last_combo = 0; // remove calculation

	other.owner.gold = other.owner.gold + self.cnt; // give the gold
	self.SendFlags |= 32; // send gold # to CSQC

	SUB_UseTargets(); // fire any activators

	//
	// Give gold end
	//

	// spawn draw CSQC entity here
	item_gold_CSQC_draw();

	SUB_UseTargets(); // fire any activators

	if (coop || deathmatch)
	{
		if (self.playerid >= k)
			remove(self);
	}
	else
		remove(self);
};

void() drop_gold =
{
	local entity goldg;

	if (deathmatch)
		return;
	if (self.flags & FL_BOSS)
		return;

	goldg = spawn();
	goldg.movetype = MOVETYPE_TOSS;
	setorigin (goldg, self.origin);
	setmodel (goldg, "progs/gold.mdl");
	setsize (goldg, '-9 -12 -1', '10 10 5');
	setsize (goldg, '0 0 0', '0 0 0');
	goldg.solid = SOLID_TRIGGER;
	goldg.classname = "gold";
	goldg.effects = EF_FULLBRIGHT;
	goldg.alpha = 1;
	goldg.flags = FL_ITEM;
	goldg.owner = self;
	goldg.message = self.classname; // store the classname of who spawned me
	goldg.maxgold = self.maxgold;
	goldg.frame = 1; // spin
	goldg.touch = gold_touch;
	goldg.avelocity = '300 -80 500';
	goldg.think = gold_think;

	// Give off RT Light
	spawn_color_glow(1, 1, 0, 75, goldg);

	//goldg.SendEntity = SendEntityToCSQC;
	goldg.SendFlags |= 1; // send origin
	goldg.SendFlags |= 2; // send frame #
	goldg.SendFlags |= 8; // send .effects
	goldg.SendFlags |= 16; // send classname
	
	goldg.nextthink = time + 0.1;

	//local string h = ftos(goldg.maxgold);
	//bprint ("Owner: ", goldg.owner.classname, "\n", "Gold: ", h, "\n");
};

void() item_gold =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	setmodel (self, "progs/gold.mdl");
	setsize (self, '-9 -12 -1', '10 10 5');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	self.classname = "gold";
	self.effects = EF_FULLBRIGHT;
	self.alpha = 1;
	self.flags = FL_ITEM;
	self.touch = gold_touch;
	
	// Give off RT Light
	spawn_color_glow(1, 1, 0, 75, self);

	//self.SendEntity = SendEntityToCSQC;
	self.SendFlags |= 1; // send origin
	self.SendFlags |= 2; // send frame #
	self.SendFlags |= 8; // send .effects
	self.SendFlags |= 16; // send classname
	droptofloor();
};