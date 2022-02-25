/*
+--------+
|Boss2   |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Eternal Dragon, second boss monster that Vigil must defeat in order to win.|
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/     

$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10
$frame rise11 rise12 rise13 rise14 rise15 rise16 rise17

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15
$frame stand16 stand17 stand18 stand19 stand20 stand21 stand22
$frame stand23 stand24 stand25 stand26 stand27 stand28 stand29 stand30 stand31

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attack16 attack17 attack18 attack19 attack20 attack21 attack22
$frame attack23
$frame shocka1 shocka2 shocka3 shocka4 shocka5 shocka6 shocka7 shocka8
$frame shocka9 shocka10 
$frame shockb1 shockb2 shockb3 shockb4 shockb5 shockb6
$frame shockc1 shockc2 shockc3 shockc4 shockc5 shockc6 shockc7 shockc8 
$frame shockc9 shockc10

void() boss_deaththink =
{
	local float ox,oy,oz;
	local entity effect, fx;

	if (self.cnt2 == 0)
	{
		shake_camera(0.5);
		self.effects = 0;
		self.cnt2 = 1;
		self.nextthink = time + 3;
		return;
	}
	if (self.cnt2 < 10)
	{
		shake_camera(0.1);
		ox = self.origin_x + random() * 32 - 16;
		oy = self.origin_y + random() * 32 - 16;
		oz = self.origin_z + random() * 16;

		sound (self, CHAN_BODY, "misc/explode.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, ox);
		WriteCoord (MSG_BROADCAST, oy);
		WriteCoord (MSG_BROADCAST, oz);
		if (self.cnt2 == 1)
			GiveExperience(999999);
		self.cnt2 = self.cnt2 + 1;
	}
	else
	{
		if (self.enemy.owner)
			self.enemy.owner.screenflash_finished = time + 0.5;

		effect = spawn();
		setorigin(effect, self.origin);
		setmodel(effect, "progs/explode1.mdl");
		effect.movetype = MOVETYPE_NONE;
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

		remove(self);
		return;
	}
	self.nextthink = time + 0.3;
};

//
//	Boss
//

void() boss_face =
{
	local vector view;
	view = vectoangles(self.enemy.origin - self.origin);
	self.angles_y = view_y;
};

float(entity targ) boss_range =
{
	local float		r;
	
	r = vlen (self.origin - targ.origin);
	if (r < 250)
		return RANGE_MELEE;
	else
		return RANGE_FAR;
};

void() boss_attack1;
void() boss_rockdrop1;

void() boss_idle1 = [0, boss_idle1]
{
	local vector view;
	local float r;
	local float rand_fb;

	if (self.enemy)
	{
		boss_face();

		// Don't allow Vigil to hit the boss while swimming for a cheap kill
		// TODO: Needs to work in multiplayer
		if (self.enemy.swimming)
			self.takedamage = DAMAGE_NO;
		else
			self.takedamage = DAMAGE_AIM;

		// Combat code here!
		if (self.attack_finished < time)
		{
			r = boss_range(self.enemy);
			if (r == RANGE_MELEE)
			{
				if (self.level > 1)
				{
					self.attack_finished = time + 5;
					self.level = 0;
				}
				else
				{
					boss_attack1();
					self.level = self.level + 1;
				}
			}
			else
			{
				if (self.level > 3)
				{
					self.attack_finished = time + 5;
					self.level = 0;
				}
				else
				{
					boss_rockdrop1();
					self.level = self.level + 1;
				}
			}
		}
		if (self.enemy.health <= 0)
		{
			self.enemy = world;
			//ASDF: Not a bug, but something to check if the last fix fails
			//self.solid = SOLID_NOT;
		}
	}
		
	if (self.stand_finished < time)
	{
		self.walkframe = self.walkframe + 1;
		self.stand_finished = time + 0.1; // Animation speed.
	}
	self.frame = $stand1 + self.walkframe;
	if (self.walkframe > 29)
		self.walkframe = 0;
	self.velocity = '0 0 0';

	frameskip(0.01);
};

void() boss_rockdrop =
{
	local entity y, oldself;

	y = find(world, classname, "bossboulderspawner");
	while (y)
	{
		self.cnt = floor(random() * 3); // floor() == vitally important
		if (self.cnt == y.cnt)
		{
			oldself = self;
			self = y;
			if (self.use)
				self.use();
			self = oldself;
		}
		y = find(y, classname, "bossboulderspawner");
	}
	y = find(world, classname, "bossboulderspawner");
};

void() boss_rockdrop1 = [$shockc1, boss_rockdrop2] // Shake the camera for a second!
{
	local entity y;

	y = find(world, classname, "camera");
	while(y)
	{
		y.camshake_finished = time + 1;
		y = find(y, classname, "camera");
	}
	y = find(world, classname, "camera");

	sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM); // scream
};

void() boss_rockdrop2 = [$shockc2, boss_rockdrop3] {};
void() boss_rockdrop3 = [$shockc3, boss_rockdrop4] {boss_rockdrop();};
void() boss_rockdrop4 = [$shockc4, boss_rockdrop5] {};
void() boss_rockdrop5 = [$shockc5, boss_rockdrop6] {};
void() boss_rockdrop6 = [$shockc6, boss_rockdrop7] {boss_rockdrop();};
void() boss_rockdrop7 = [$shockc7, boss_rockdrop8] {};
void() boss_rockdrop8 = [$shockc8, boss_rockdrop9] {};
void() boss_rockdrop9 = [$shockc9, boss_rockdrop10] {boss_rockdrop();};
void() boss_rockdrop10 = [$shockc10, boss_idle1] {};

void() Boss2Melee =
{
	FireMelee(40,0,3,100,5,0,1,FALSE,0,0);

	// Damage boss from purge attacks
	// '.char' refers to the Eternal Dragon itself as .owner is used for other means

	local float calc = self.char.health - self.health;
	local string s = ftos(calc);

	if (calc > 0 && calc != self.char.health)
		self.char.health = self.char.health - calc;
	
	if (self.char.health < 1)
		Killed (self.char, self.enemy);

	remove(self);
};

void() boss_attack1 = [$attack1, boss_attack2] 
{
	local float b = random()*4 * 0.1;  // stagger first frame
	frameskip(0.08 + b);
};
void() boss_attack2 = [$attack2, boss_attack3] {sound (self, CHAN_WEAPON, "dragon/bite.wav", 1, ATTN_NORM);frameskip(0.5);};
void() boss_attack3 = [$attack3, boss_attack4] {frameskip(0.08);};
void() boss_attack4 = [$attack4, boss_attack5] {frameskip(0.08);};
void() boss_attack5 = [$attack5, boss_attack6] {frameskip(0.08);};
void() boss_attack6 = [$attack6, boss_attack7]
{
	local entity h;

	makevectors (self.angles);

	h = spawn();
	setmodel (h, string_null);
	setsize (h, '0 0 0', '0 0 0');
	setorigin (h, self.origin + v_up * 100 + v_forward * 120);
	h.char = self;
	h.flags = FL_BOSS | FL_MONSTER; // Do not allow Boss to be hit by his own melee!
	h.movetype = MOVETYPE_NOCLIP;
	h.classname = "Boss2Melee";
	h.health = self.health; // store eternal dragon's health
	h.solid = SOLID_NOT;
	h.angles = '0 0 0';
	h.think = Boss2Melee;
	h.nextthink = time;

	frameskip(0.08);
};
void() boss_attack7 = [$attack7, boss_attack8] {frameskip(0.08);};
void() boss_attack8 = [$attack8, boss_attack9] {frameskip(0.08);};
void() boss_attack9 = [$attack9, boss_attack10] {frameskip(0.08);};
void() boss_attack10 = [$attack10, boss_attack11] {frameskip(0.08);};
void() boss_attack11 = [$attack11, boss_attack12] {frameskip(0.08);};
void() boss_attack12 = [$attack12, boss_attack13] {frameskip(0.08);};
void() boss_attack13 = [$attack13, boss_attack14] {frameskip(0.08);};
void() boss_attack14 = [$attack14, boss_attack15] {frameskip(0.08);};
void() boss_attack15 = [$attack15, boss_attack16] {frameskip(0.08);};
void() boss_attack16 = [$attack16, boss_attack17] 
{
	local float b = random()*4 * 0.1;  // stagger first frame
	frameskip(0.5 + b);
	sound (self, CHAN_WEAPON, "dragon/bite.wav", 1, ATTN_NORM);
};
void() boss_attack17 = [$attack17, boss_attack18] {frameskip(0.08);};
void() boss_attack18 = [$attack18, boss_attack19] 
{
	local entity h;

	makevectors (self.angles);

	h = spawn();
	setmodel (h, string_null);
	setsize (h, '0 0 0', '0 0 0');
	setorigin (h, self.origin + v_up * 100 + v_forward * 120);
	h.char = self;
	h.flags = FL_BOSS | FL_MONSTER; // Do not allow Boss to be hit by his own melee!
	h.movetype = MOVETYPE_NOCLIP;
	h.classname = "Boss2Melee";
	h.health = self.health; // store eternal dragon's health
	h.solid = SOLID_NOT;
	h.angles = '0 0 0';
	h.think = Boss2Melee;
	h.nextthink = time;

	frameskip(0.08);
};
void() boss_attack19 = [$attack19, boss_attack20] {frameskip(0.08);};
void() boss_attack20 = [$attack20, boss_attack21] {frameskip(0.08);}
void() boss_attack21 = [$attack21, boss_attack22] {frameskip(0.08);};
void() boss_attack22 = [$attack22, boss_attack23] {frameskip(0.08);};
void() boss_attack23 = [$attack23, boss_idle1] {frameskip(0.08);};

void() boss_death1 = [$death1, boss_death2] {sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);};
void() boss_death2 = [$death2, boss_death3] {};
void() boss_death3 = [$death3, boss_death4] {};
void() boss_death4 = [$death4, boss_death5] {};
void() boss_death5 = [$death5, boss_death6] {};
void() boss_death6 = [$death6, boss_death7] {};
void() boss_death7 = [$death7, boss_death8] {};
void() boss_death8 = [$death8, boss_death9] {};
void() boss_death9 = [$death9, boss_death10]{};
void() boss_death10 = [$death9, boss_death10]
{
	local entity form;

	sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	// Dramatic death here
	self.cnt2 = 0;
	self.think = boss_deaththink;
	self.nextthink = time + 1;
	
	bosses = bosses | IT_BOSS2; // Defeated Boss 2, record it
};

void() boss_fbeam1 = [$shockb1, boss_fbeam2] 
{
	if (self.beams_shot < 20)
	{
		Firebeam(3, 90, 90);
		self.beams_shot = self.beams_shot + 1;
		boss_rockdrop();
		shake_camera(0.1);
	}
	else
	{
		self.attack_finished = time + 1; // brief pause
		self.beams_shot = 0;
		boss_idle1();
	}
	frameskip(0.05);
};
void() boss_fbeam2 = [$shockb2, boss_fbeam3] {frameskip(0.03);};
void() boss_fbeam3 = [$shockb3, boss_fbeam4] {frameskip(0.03);};
void() boss_fbeam4 = [$shockb4, boss_fbeam5] {frameskip(0.03);};
void() boss_fbeam5 = [$shockb5, boss_fbeam6] {frameskip(0.03);};
void() boss_fbeam6 = [$shockb6, boss_fbeam1] {frameskip(0.03);};

void() boss_pain =
{
	self.colormod = '3 1 1';
	self.cnt2 = self.cnt2 + 1;
	if (self.attack_finished > time)
	{
		sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);
		self.mode = 0;
		self.velocity = '0 0 0';
	}
	if ((self.enemy.owner.combo > 9 || self.cnt2 > 16) && self.mode != 1) // Get pissed, unleash fire beam
	{
		self.mode = 1;
		self.cnt2 = 0;
		self.attack_finished = time;
		
		if (random() < 0.5)
		{
			local entity effect;

			effect = spawn();
			setmodel(effect, "progs/chrgebm.mdl");
			setorigin(effect, self.origin + v_up * 100);
			effect.movetype = MOVETYPE_NOCLIP;
			effect.solid = SOLID_NOT;
			effect.alpha = 0.8;
			effect.scale = 2; // enlarge it
			effect.owner = self;
			effect.effects = EF_NODEPTHTEST;
			effect.think = chargebeam_effect;
			effect.nextthink = time + 0.01;
			sound (effect, CHAN_AUTO, "spells/charge.wav", 1, ATTN_NORM);

			self.think = boss_fbeam1;
			self.nextthink = time + 2;
		}
		else
		{
			boss_attack1();
		}
	}
	// Help Vigil not fall off me
	self.enemy.velocity_x = self.enemy.velocity_y = 0;
};

void() boss_die =
{
	self.solid = SOLID_NOT;
	self.deadflag = DEAD_DEAD;
	self.takedamage = DAMAGE_NO;
	boss_death1();
};

void() boulder_thinker =
{
	if (self.mode == 1 || self.attack_finished < time)
	{
		if (self.alpha > 0.1)
			self.alpha = self.alpha - 0.1;
		else
		{
			remove(self);
			return;
		}
	}
	else
	{
		self.flags = self.flags | FL_MONSTER; // Don't hit boss
		FireMelee(8,0,1,35,0,0,1,FALSE,0,0);
		if (self.flags & FL_ONGROUND)
			self.mode = 1;
	}
	if (self.attackedname == "player")
	{
		self.mode = 1; // Only hit once
		ThrowRubble();
		sound (self, CHAN_BODY, "misc/rocks.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}
	frameskip(0.1);
};

void() boulder_spawner_use =
{
	local entity bould;

	bould = spawn();
	setmodel (bould, "progs/boulder.mdl");
	setsize (bould, '-27 -13 -1', '12 20 1');
	setorigin (bould, self.origin);
	bould.alpha = 1;
	bould.movetype = MOVETYPE_TOSS;
	bould.solid = SOLID_TRIGGER;
	bould.classname = "bossboulder";
	bould.angles_y = bould.angles_x = bould.angles_z = random()*360;
	bould.attack_finished = time + 5;
	bould.think = boulder_thinker;
	bould.nextthink = time + 0.1;
};

void() boulder_spawner_think =
{
	local entity targ;

	if (self.velocity_z == 0)
	{
 		if (self.enemy) // move close
		{
			if (self.origin_x < self.enemy.origin_x)
				self.velocity_x = self.velocity_x + 50;
			if (self.origin_x > self.enemy.origin_x)
				self.velocity_x = self.velocity_x - 50;
			if (self.origin_y < self.enemy.origin_y)
				self.velocity_y = self.velocity_y + 50;
			if (self.origin_y > self.enemy.origin_y)
				self.velocity_y = self.velocity_y - 50;

			if (self.airtight_finished < time)
			{
				self.velocity_x = self.velocity_x / 1.2;
				self.velocity_y = self.velocity_y / 1.2;
			}
			self.airtight_finished = time + random()*25;
		}
		else
		{

			targ = find(world, classname, "player");
			while (targ)
			{
				if (targ.health > 0)
					self.enemy = targ;
				targ = find(targ, classname, "player");
			}
			targ = find(world, classname, "player");
		}
		self.cnt = floor(random() * 3); // used to randomize who drops rocks, floor() == vitally important
	}
	else
		self.velocity_z = 0;
		
	frameskip(0.1);
};

void() spawn_boulder_spawner =
{
	local entity b, targ;
	b = spawn();

	setmodel (b, "progs/null.spr");
	setsize (b, '-27 -13 -1', '12 20 1');
	setorigin (b, self.origin + v_up * 64);
	b.movetype = MOVETYPE_FLY;
	b.velocity_z = 999999; // Hit roof immediately!
	b.use = boulder_spawner_use;
	b.classname = "bossboulderspawner"; // crappy classname
	b.think = boulder_spawner_think;
	b.nextthink = time + 1;

	targ = find(world, classname, "player");
	while (targ)
	{
		if (targ.health > 0)
			self.enemy = targ;
		targ = find(targ, classname, "player");
	}
	targ = find(world, classname, "player");
};

void() boss_rise1	=[	$rise1, boss_rise2 ] 
{
	sound (self, CHAN_AUTO, "boss1/out1.wav", 1, ATTN_NORM);
	boss_face();

	// spawn his boulder spawners
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
};
void() boss_rise2	=[	$rise2, boss_rise3 ] {boss_face();};
void() boss_rise3	=[	$rise3, boss_rise4 ] {boss_face();};
void() boss_rise4	=[	$rise4, boss_rise5 ] {boss_face();};
void() boss_rise5	=[	$rise5, boss_rise6 ] {boss_face();};
void() boss_rise6	=[	$rise6, boss_rise7 ] {boss_face();};
void() boss_rise7	=[	$rise7, boss_rise8 ] {boss_face();freeze_finished = time + 0.1 * (frametime * 100);};
void() boss_rise8	=[	$rise8, boss_rise9 ] {boss_face();};
void() boss_rise9	=[	$rise9, boss_rise10 ] {boss_face();};
void() boss_rise10	=[	$rise10, boss_rise11 ] {boss_face();};
void() boss_rise11	=[	$rise11, boss_rise12 ] {boss_face();};
void() boss_rise12	=[	$rise12, boss_rise13 ] {boss_face();};
void() boss_rise13	=[	$rise13, boss_rise14 ] {boss_face();};
void() boss_rise14	=[	$rise14, boss_rise15 ] {boss_face();};
void() boss_rise15	=[	$rise15, boss_rise16 ] {boss_face();};
void() boss_rise16	=[	$rise16, boss_rise17 ] {boss_face();};
void() boss_rise17	=[	$rise17, boss_idle1 ]  {boss_face();};

void() boss2_awake =
{
	if (bosses & IT_BOSS2) // defeated
	{
		remove(self);
		return;
	}	
	self.solid = SOLID_SLIDEBOX;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.enemy = activator;

	boss_rise1();
}

void() monster_boss2 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/boss.mdl");
	precache_model ("progs/bossh.mdl");
	precache_model ("progs/boulder.mdl");
	precache_model ("progs/rubble1.mdl");
	precache_model ("progs/rubble2.mdl");
	precache_model ("progs/rubble3.mdl");

	precache_sound ("boss1/out1.wav");
	precache_sound ("boss1/sight1.wav");
	precache_sound ("boss1/pain.wav");
	precache_sound ("boss1/death.wav");
	precache_sound ("dragon/bite.wav");
	precache_sound ("misc/rocks.wav");
	precache_sound ("misc/explode.wav");

	self.use = boss2_awake;

	setmodel (self, "progs/boss.mdl");
	setsize (self, '-121 -89 11', '120 83 277');
	self.movetype = MOVETYPE_NONE;
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "breakable"; // stay solid
	self.displayname = "Eternal Dragon";
	self.health = self.max_health = 1333;
	self.deadflag = DEAD_NO;
	self.noblood = TRUE;
	self.flags = FL_MONSTER | FL_BOSS | IT_BOSS2;

	self.th_die = boss_die;
	self.th_stand = boss_idle1;
	self.th_pain = boss_pain;
};