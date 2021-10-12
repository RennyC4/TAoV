//+------+
//|player|
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Almost all of Vigil's animation and his behavior is in this file.          |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

/*QUAKED player_spawn (0 0 1) (-16 -16 -24) (16 16 32)
Vigil's spawn point, usually put infront of the game camera
if not camera will then warp over
*/
void() player_spawn = {};

$frame base
$frame slash1 slash2 slash3 slash4 slash5 slash6 slash7
$frame stabs1 stabs2 stabs3 stabs4 stabs5 stabs6 stabs7 stabs8 stabs9 stabs10 stabs11 stabs12
$frame fstab1 fstab2 fstab3 fstab4 fstab5 fstab6 fstab7
$frame airkick1 airkick2 airkick3 airkick4 airkick5 airkick6 airkick7 airkick8 airkick9 airkick10 airkick11 airkick12 airkick13 airkick14
$frame airkick15 airkick16 airkick17
$frame bflip1 bflip2 bflip3 bflip4
$frame tired1 tired2 tired3 tired4 tired5 tired6
$frame stand1 stand2 stand3 stand4 stand5 stand6
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12
$frame run1 run2 run3 run4 run5 run6
$frame runatk1 runatk2 runatk3 runatk4 runatk5
$frame attacka1 attacka2 attacka3 attacka4 attacka5 attacka6 attacka7 attacka8 attacka9 attacka10 attacka11 attacka12 attacka13 attacka14 attacka15 attacka16 attacka17 attacka18 attacka19
$frame dashatk1 dashatk2 dashatk3 dashatk4 dashatk5 dashatk6
$frame spin1 spin2 spin3 spin4 spin5 spin6 spin7 spin8 spin9 spin10
$frame counter1 counter2 counter3 counter4 counter5 counter6 counter7 counter8 counter9 counter10
$frame kick1 kick2 kick3 kick4 kick5
$frame jump1 jump2
$frame jumpatk1 jumpatk2 jumpatk3
$frame jumpatkb1 jumpatkb2 jumpatkb3 jumpatkb4 jumpatkb5 jumpatkb6 jumpatkb7 jumpatkb8
$frame uppercut1 uppercut2 uppercut3 uppercut4 uppercut5
$frame pain1 pain2 pain3 pain4 pain5
$frame getup1 getup2 getup3 getup4 getup5
$frame magica1 magica2 magica3 magica4
$frame magicb1 magicb2
$frame magicc1 magicc2 magicc3 magicc4
$frame magicd1 magicd2 magicd3 magicd4 magicd5 magicd6 magicd7
$frame block1 block2 block3
$frame wallgrab
$frame grab1 grab2
$frame grabatk1 grabatk2 grabatk3 grabatk4 grabatk5 grabatk6 grabatk7 grabatk8 grabatk9 grabatk10 grabatk11 grabatk12 grabatk13 grabatk14
$frame jatkspc1 jatkspc2 jatkspc3 jatkspc4 jatkspc5 jatkspc6 jatkspc7
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10 idle11 idle12 idle13
$frame charge1 charge2 charge3 charge4 charge5 charge6 charge7 charge8 charge9
$frame ledgeg1 ledgeg2 ledgeg3 ledgeg4 ledgeg5 ledgeg6 ledgeg7 ledgeg8
$frame ledgec1 ledgec2 ledgec3 ledgec4 ledgec5 ledgec6
$frame djump
$frame standb1 standb2 standb3 standb4 standb5 standb6
$frame fflip1 fflip2 fflip3 fflip4 fflip5 fflip6 fflip7 fflip8
$frame dfattack1 dfattack2 dfattack3 dfattack4 dfattack5 dfattack6 dfattack7 dfattack8 dfattack9 dfattack10 dfattack11 dfattack12
$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9
$frame rwallrun1 rwallrun2 rwallrun3 rwallrun4
$frame lwallrun1 lwallrun2 lwallrun3 lwallrun4
$frame twist
$frame walled1 walled2 walled3 walled4 walled5
$frame getupb1 getupb2 getupb3
$frame hsblked1
$frame blockbrk1 blockbrk2 blockbrk3 blockbrk4
$frame dodgea1 dodgea2 dodgea3 dodgea4 dodgea5 dodgea6 dodgea7 dodgea8 dodgea9 dodgea10 dodgea11
$frame dodgeb1 dodgeb2 dodgeb3 dodgeb4 dodgeb5 dodgeb6 dodgeb7 dodgeb8 dodgeb9
$frame dodgec1 dodgec2 dodgec3 dodgec4 dodgec5 dodgec6 dodgec7
$frame dodged1 dodged2 dodged3 dodged4 dodged5 dodged6 dodged7
$frame swim1 swim2 swim3 swim4 swim5 swim6 swim7 swim8

void() PainSound;
void() player_ledgegrab1;
void() player_dashatk1;
void() player_move;
void() player_getup1;
void() player_getupb1;
void() player_fire;
void() player_pain;
void() player_die;
void() player_spinatk1;
void() player_bflip1;
void(float voice_type) player_yell;
void() player_grab;
void() player_grab1;
void() player_jatkspecial1;
void() player_chargeatk1;
void() player_wallgrab;
void() player_airdivings1;
void() player_doublejump1;
void() player_fflip1;
void() player_walled2;
void() player_dodgea1;
void() player_dodgeb1;
void() player_dodgec1;
void() player_dodged1;
void() player_dodgee1;
void() player_dodgef1;

// Remove me when FTE's MOVETYPE_FOLLOW is fixed
void() volbrand_think =
{
	setorigin (self, self.owner.origin);
	self.angles = self.owner.angles;
	self.frame = self.owner.frame;
	frameskip(0.01);
};

void() Setup_Dummy =
{
	local entity dummy, sword, spoint;
	local float f;

	f = cvar("gamecfg");

	dummy = spawn();

	spoint = find(world, classname, "player_spawn");
	while (spoint)
	{
		if (world.model == "maps/teleporter.bsp" || deathmatch)
			f = 0; // teleporter room doesn't require different spawn locations
		if (spoint.cnt == f)
		{
			setorigin(dummy, spoint.origin);
			dummy.angles = spoint.angles;
			dummy.fixangle = TRUE;
		}
		spoint = find(spoint, classname, "player_spawn");
	}

	setmodel(dummy, "progs/plyr.mdl");
	setsize(dummy, VEC_HULL_MIN, VEC_HULL_MAX);

	dummy.solid = SOLID_TRIGGER;
	dummy.hitcontentsmaski = CONTENTBIT_SOLID|0x00000002i|CONTENTBIT_BODY|CONTENTBIT_PLAYERCLIP;
	dummy.owner = self;

	if (deathmatch == FALSE) // Setup Dummy Parms for coop/sp
	{
		dummy.health = self.health;
		dummy.max_health = self.max_health;
		dummy.max_mana = self.max_mana;
		dummy.hflask_amt = self.hflask_amt;
		dummy.hflask_max_amt = self.hflask_max_amt;
	}
	else // deathmatch players have specific stats
	{
		dummy.health = dummy.max_health = 100;
		dummy.owner.health = dummy.owner.max_health = 100;

		self.hflask_amt = 0;
		dummy.hflask_amt = self.hflask_amt;
		self.hflask_max_amt = 25;
		dummy.hflask_max_amt = self.hflask_max_amt;

		dummy.max_mana = 100;
		dummy.owner.max_mana = 100;
		// Remove cooperative / single player stats
		self.swordlevel = 0;
		self.armorlevel = 0;
		// Give proper relics / spells / special moves to Vigil
		relics = relics | IT_RELIC1 | IT_RELIC2 | IT_RELIC3 | IT_RELIC4 | IT_RELIC5 | IT_RELIC8;
		spells = spells | IT_SPELL1 | IT_SPELL2 | IT_SPELL3 | IT_SPELL4;

		game_progress = game_progress | IT_PROGRESS2; // Add Cyclone Crush
		game_progress = game_progress | IT_PROGRESS4; // Add Diving Swallow
	}

	if (dummy.health > dummy.max_health)     // bug fix: don't allow health values to exceed max health values
		dummy.health = dummy.max_health;     // on a changelevel if player was dead (0 health = 255 on next level, now fixed)

	dummy.takedamage = DAMAGE_AIM;
	dummy.classname = "player";
	dummy.netname = "solid";
	dummy.speed = 120; // Maintained by client.qc
	dummy.view_ofs = '0 0 28'; // Set at eye level for Vigil not to drown
	
	if (cvar("developer") == 2)
		dummy.movetype = MOVETYPE_NONE;
	else
		dummy.movetype = MOVETYPE_WALK;

	dummy.colormap = self.colormap; // set colors to the owners
	self.char = dummy;
	dummy.think = player_move;
	dummy.nextthink = time;
	dummy.th_pain = player_pain;
	dummy.th_grab = player_grab1;
	dummy.th_die = player_die;
	dummy.th_stand = player_move;

	if (self.spawnflags & 2)
		self.telecam = FALSE; // don't teleport camera to vigil at map start, used for transition rooms
	else
		self.telecam = TRUE; // teleport camera to vigil at map start

	//
	// Game Progression Checks - Also occurs in ai.qc for specific monsters
	//

	if (world.model == "maps/map01.bsp")
	{
		if (game_progress & IT_PROGRESS1) // Reached Village bitwise
			game_progress = game_progress - IT_PROGRESS1; // Subtract it (False)
	}
	if (world.model == "maps/village.bsp")
	{
		if (!(game_progress & IT_PROGRESS1)) // Reached Village bitwise
			game_progress = game_progress | IT_PROGRESS1; // Add it (True)

		if (game_progress & IT_PROGRESS5) // Reached Castle bitwise
			game_progress = game_progress - IT_PROGRESS5; // Subtract it (False)
	}	
	if (world.model == "maps/castle.bsp")
	{
		if (!(game_progress & IT_PROGRESS5)) // Reached Castle bitwise
			game_progress = game_progress | IT_PROGRESS5; // Add it (True)
	}

	stuffcmd (self, "v_cshift\n"); // remove all v_cshift on level change
	if (!deathmatch && !coop)
		stuffcmd (self, "con_notify_w 0\n"); // Disallow sprint to show
	else
		stuffcmd (self, "con_notify_w 1\n"); // allowed in multiplayer
		
	//cvar_set("skyroom", ""); // reset skyroom on level load
	
	//
	// Spawn Vigil's sword - shader fun
	//
	
	sword = spawn();
	sword.owner = dummy;
	sword.classname = "volbrand";
	sword.movetype  = MOVETYPE_NOCLIP;
	sword.solid     = SOLID_NOT;
	sword.effects   = EF_FULLBRIGHT;
	setmodel (sword, "progs/plyr2.mdl");
	sword.think = volbrand_think;
	sword.nextthink = time;
	
	/* - Removed until Spike fixes the angle_x invert bug
	sword = spawn();
	sword.owner = self;
	sword.classname = "volbrand";
	sword.movetype  = MOVETYPE_FOLLOW;
	sword.solid     = SOLID_NOT;
	sword.effects   = EF_FULLBRIGHT;
	setmodel (sword, "progs/plyr2.mdl");
	dummy.vw_index = sword.modelindex;
	remove(sword); // weird, removes after being binded to the player I suppose
	*/
};

//
// Perfect Guard
//

void(entity plyr) PerfectGuard	=
{
	makevectors(plyr.angles);

	local vector x = plyr.origin + v_forward * 30 + v_up * 12;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, x_x);
	WriteCoord (MSG_BROADCAST, x_y);
	WriteCoord (MSG_BROADCAST, x_z);

	plyr.owner.camshake_finished = time + 0.1;
	if (plyr.flags & FL_ONGROUND)
	{
		if (random() < 0.5)
			plyr.frame = $block1;
		else
			plyr.frame = $block2;
	}
	else
		plyr.frame = $block3;

	plyr.owner.vcshift_ok = TRUE;
	plyr.owner.screentint_finished = time + 0.01 * (frametime * 100);
	stuffcmd (plyr.owner, "v_cshift 255 200 0 25\n"); // yellow tint quick

	freeze_finished = time + 0.05 * (frametime * 100);
	plyr.colormod = '2 2 1';
	plyr.alpha = 0.625; // ghost effect
	plyr.colormod = '5 5 0';
	plyr.perfectguard_buff = plyr.owner.perfectguard_buff = time + 3; // disallow setting vigil to DAMAGE_AIM
	plyr.takedamage = DAMAGE_NO;
	plyr.effects = EF_MUZZLEFLASH; // create light on melee impact
	sound (plyr, CHAN_AUTO, "player/perfblok.wav", 1, ATTN_NONE);
	
	local entity effect;

	// spawn a block sprite
	effect = spawn();
	setorigin(effect, plyr.origin);
	setmodel(effect, "progs/block.spr");
	effect.angles_y = -90;
	effect.angles_z = random()*360;
	effect.avelocity = '0 0 1500';
	effect.colormod = '-255 -255 9999';
	effect.effects = EF_NODEPTHTEST | EF_ADDITIVE;
	effect.movetype = MOVETYPE_NOCLIP;
	effect.owner = plyr;
	effect.alpha = 1;
	effect.think = perfectguard_fx_think;
	effect.nextthink = time;
	effect.solid = SOLID_NOT;
	
	if (plyr.classname != "player")
		error("Perfect Guard should only be set on Vigil entity\n");
};

//
// Status Effect Behaviors
//

void() StatusEffects =
{	
	if (self.char.health <= 0)
		return;

	// Blindness is handled through CSQC
	if (self.status_blind_finished > time)
	{
		if (self.blind_snd_tick_finished < time)
		{
			self.char.colormod = '7 0 7';
			sound (self.char, CHAN_AUTO, "player/blind.wav", 1, ATTN_NORM);
			self.blind_snd_tick_finished = time + 4;
		}
	}
	
	// Poison
	if (self.status_poison_finished > time)
	{
		if (self.poison_tick_finished < time && self.hflask_drink_finished < time)
		{
			if (self.char.health >= 2 && !self.flags & FL_GODMODE)
				self.char.health = self.char.health - 1;
			if (self.char.health <= 0) // cap it
				self.char.health = 1;
			if (self.poison_snd_tick_finished < time)
			{
				self.char.colormod = '0 5 0';
				sound (self.char, CHAN_AUTO, "player/poison.wav", 1, ATTN_NORM);
				self.poison_snd_tick_finished = time + 2;
			}
			self.poison_tick_finished = time + 0.25;
		}
	}
	
	// Broken
	if (self.status_broken_finished > time)
	{
		if (self.broken_tick_finished < time && self.hflask_drink_finished < time && !self.char.flypain && self.char.pain_finished < time && self.purge_toggle == FALSE)
		{
			self.char.colormod = '5 5 5';
			self.noblock_finished = time + 1; // don't allow block
			self.char.noblock_finished = time + 1; // don't allow block
			self.nospinatk_finished = time + 1; // don't allow spin attack
			self.nobackflip_finished = time + 1; // don't allow backflip
			sound (self.char, CHAN_AUTO, "player/broken.wav", 1, ATTN_NORM);
			if (self.char.perfectguard_buff < time) // remove i-frame stuff
				self.char.takedamage = DAMAGE_AIM;
			T_Damage (self.char, self, self, 0, 0); // do the annoying magic
			self.broken_tick_finished = time + 1 + ceil(random()*4 + 1);
		}
	}
};

//
// Health Flask Behavior -- Called from PlayerPreThink(); (client.qc)
//

void() hflask_drink_effect =
{
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	makevectors(self.owner.angles);
	setorigin (self, self.owner.origin + v_up*16);
	frameskip(0.01);
};

.float hflask_drink_speed;
.float hflask_sfx_finished;
void() HealthFlask =
{
	// Break out conditions
	if (self.attack_finished > time || self.char.pain_finished > time || self.char.block_finished > time || self.magicmenu == TRUE
	|| self.flypain || !self.char.onground || self.char.idle_count == 0)
	{
		self.hflask_drink_finished = time;
		return;
	}

	// How fast to heal
	if (self.hflask_drink_speed > time)
		return;
	else
		self.hflask_drink_speed = time + 0.05; // Drink speed

	if (self.char.health < self.char.max_health || self.status_poison_finished > time || self.status_blind_finished > time || self.status_broken_finished > time)
	{
		if (self.hflask_amt > 0)
		{
			// Remove status effects faster!
			if (self.status_poison_finished > time)
				self.status_poison_finished = self.status_poison_finished - 0.25;
			if (self.status_blind_finished > time)
				self.status_blind_finished = self.status_blind_finished - 0.25;
			if (self.status_broken_finished > time)
				self.status_broken_finished = self.status_broken_finished - 0.25;

			if (self.char.health < self.char.max_health)
				self.char.health = self.char.health + 1;
			
			if (self.hflask_sfx_finished < time)
			{
				local entity effect;

				makevectors (self.char.angles);
				
				effect = spawn();
				effect.owner = self.char;
				effect.classname = "hflask_effect";
				effect.movetype  = MOVETYPE_NOCLIP;
				effect.solid = SOLID_NOT;
				effect.drawonlytoclient = self; // reduce network traffic
				effect.flags = EF_NODEPTHTEST;
				effect.think = hflask_drink_effect;
				effect.nextthink = time;
				effect.attack_finished = time + 1;
				setmodel (effect, "progs/hflask.spr");	
				sound (self.char, CHAN_AUTO, "player/sipflask.wav", 1, ATTN_NORM);
				sound (self.char, CHAN_AUTO, "player/flaskmag.wav", 0.5, ATTN_NORM);
				self.hflask_sfx_finished = time + 0.5;
			}

			self.hflask_amt = self.hflask_amt - 1;
		}
	}
};

//
// Vigil's Water Physics are handled here
//

void() PlayerWaterPhysics =
{
	//
	// in damage.qc Vigil is given knockback of 4 if swimming
	//
	if (self.char.pain_finished > time || self.char.health < 1)
	{
		self.char.velocity_z = self.char.velocity_z - 6 * (frametime * 100);
		return;
	}
		
	if (self.button2 && self.ledgegrab == FALSE) // Player actively swimming up
	{
		if (self.char.velocity_z < 100)
				self.char.velocity_z = self.char.velocity_z + 2.5 * (frametime * 100);
		else
				self.char.velocity_z = 100;
	}
	else
	{
		if (self.char.velocity_z > -100)
		{
			if (self.ledgegrab == FALSE)
				self.char.velocity_z = self.char.velocity_z - 6 * (frametime * 100);
		}
		else
			self.char.velocity_z = 0;
	}

	// Slowly remove left/right/foreground/background speed
	if (self.char.velocity_y > 0)
		self.char.velocity_y = self.char.velocity_y - 1 * (frametime * 100);
	if (self.char.velocity_y < 0)
		self.char.velocity_y = self.char.velocity_y + 1 * (frametime * 100);
		
	if (self.char.velocity_x > 0)
		self.char.velocity_x = self.char.velocity_x - 1 * (frametime * 100);
	if (self.char.velocity_x < 0)
		self.char.velocity_x = self.char.velocity_x + 1 * (frametime * 100);

	//
	// Tilt Vigil forward while moving/swimming
	//
	if (self.char.health > 0)
	{
		if ((self.char.velocity_x > -5 && self.char.velocity_x < 5) && (self.char.velocity_y > -5 && self.char.velocity_y < 5))
		{
			if (self.char.angles_x != 0)
			{
				if (self.char.angles_x < 0)
				{
					if (self.char.onground)
						self.char.angles_x = self.char.angles_x + 3;
					else
						self.char.angles_x = self.char.angles_x + 0.5;
				}
				else
					self.char.angles_x = 0;
			}
		}
		else
		{
			if (self.char.angles_x > -35)
				self.char.angles_x = self.char.angles_x - 0.5;
			else
				self.char.angles_x = -35;
		}
	}
	self.char.inair = 0; // remove inair
	self.char.bigfall = FALSE; // remove bigfall
	self.char.charge_count = 0; // Can't charge attack underwater
	self.char.speed = 55;
};

void() speedline_think =
{
	local vector view;

	// NOTE: View_x == 270 is the speed lines completely facing downward

	makevectors (self.angles);
	view = vectoangles(self.owner.origin - self.origin);

	// prevent horizontal lines when Vigil's X Velocity is zero!
	if (self.owner.velocity_z == 0 && view_x == 270 && self.owner.onground == TRUE)
		view_x = 0;
	// speed lines must always face doward on Vigil's head smashes
	if (self.owner.frame == $jumpatk2 || self.owner.frame == $jumpatk3 && view_x == 0)
		view_x = 270;

	if (self.owner.angles_y == 0)
		self.angles_z = view_x;
	else
		self.angles_z = view_x * -1;

	if (self.attack_finished < time) // animate speed
	{
		if (random() < 0.5)
		{
			if (self.frame < 2)
				self.frame = self.frame + 1;
			else
				self.frame = 0;
		}
		else
			self.frame = random()*3;

		self.attack_finished = time + 0.05;
	}
	if (self.alpha > 0)
		self.alpha = self.alpha - 0.01;
	else
	{
		remove(self);
		return;
	}
	frameskip(0.01);
};

void() SpeedLine =
{
	if (self.nextspeed_time > time)
		return;

	makevectors (self.char.angles);

	local entity speedl;

	speedl = spawn();
	speedl.owner = self.char;
	speedl.classname = "speedline";
	speedl.movetype  = MOVETYPE_NOCLIP;
	speedl.effects  = EF_ADDITIVE | EF_FULLBRIGHT;
	speedl.solid = SOLID_NOT;
	speedl.alpha = 0.5;
	speedl.drawonlytoclient = self; // reduce network traffic
	speedl.angles_y = -90;

	setmodel (speedl, "progs/speed.spr");

	if (self.char.onground)
		setorigin (speedl, self.char.origin - v_forward * 30);
	else
		setorigin(speedl, self.char.origin);

	speedl.frame = random()*3;

	speedl.think = speedline_think;
	speedl.nextthink = time + 0.01;
	self.nextspeed_time = time + 0.15;
};

// called from client.qc
void() manashadows_think =
{
	if (self.alpha > 0)
	{
		self.alpha = self.alpha - 0.0080;
		self.scale = self.scale + 0.005;
	}
	else
	{
		remove(self);
		return;
	}
	self.angles = self.owner.angles;
	self.frame = self.owner.frame;
	setorigin (self, self.owner.origin);
	frameskip(0.01);
};

void() shadows_think =
{
	if (self.alpha > 0)
		self.alpha = self.alpha - 0.05;
	else
	{
		remove(self);
		return;
	}
	frameskip(0.04);
};

// called from playerprethink
.float nextshadow_time;
void() Shadows =
{
	if (self.nextshadow_time > time)
		return;

	local entity shadows;

	shadows = spawn();
	shadows.owner = self.char;
	shadows.classname = "shadows";
	shadows.movetype  = MOVETYPE_NOCLIP;
	shadows.solid     = SOLID_NOT;
	shadows.skin = 1; // shadow skin
	shadows.alpha = 0.65;
	shadows.drawonlytoclient = self; // reduce network traffic
	shadows.effects   = EF_ADDITIVE | EF_FULLBRIGHT;
	setmodel (shadows, "progs/plyr.mdl");

	shadows.frame = self.char.frame;
	shadows.angles = self.char.angles;
	setorigin(shadows, self.char.origin);

	shadows.think = shadows_think;
	shadows.nextthink = time + 0.04;
	self.nextshadow_time = time + 0.1;
};

.float nextsoftshadow_time;
void() SoftShadows = // same as red shadows, but more transparent and uses Vigil's skin
{
	if (self.nextsoftshadow_time > time)
		return;

	local entity shadows;

	shadows = spawn();
	shadows.owner = self.char;
	shadows.classname = "shadows";
	shadows.movetype  = MOVETYPE_NOCLIP;
	shadows.solid     = SOLID_NOT;
	shadows.effects   = EF_ADDITIVE | EF_FULLBRIGHT;
	shadows.alpha = 0.35;
	shadows.drawonlytoclient = self; // reduce network traffic
	shadows.skin = self.owner.skin;
	setmodel (shadows, "progs/plyr.mdl");

	shadows.frame = self.char.frame;
	shadows.angles = self.char.angles;
	setorigin(shadows, self.char.origin);
	shadows.colormap = self.char.owner.colormap;

	shadows.think = shadows_think;
	shadows.nextthink = time + 0.04;
	self.nextsoftshadow_time = time + 0.1;
};

void() SwordShadowsThink =
{
	if (self.alpha < 0.1)
	{
		remove(self);
		return;
	}
	self.alpha = self.alpha - 0.1;
	frameskip(0.1);
};

// called from playerprethink
void() SwordShadows =
{
	if (self.nextshadow_time > time)
		return;

	local entity shadows;

	shadows = spawn();
	shadows.owner = self;
	shadows.classname = "shadows";
	shadows.movetype  = MOVETYPE_NOCLIP;
	shadows.solid     = SOLID_NOT;
	shadows.alpha     = 0.25;
	shadows.drawonlytoclient = self; // reduce network traffic
	shadows.effects   = EF_ADDITIVE | EF_FULLBRIGHT;
	setmodel (shadows, "progs/swordfx.mdl");

	if (shadows.owner.swordlevel == 0)
		shadows.skin = 0;
	if (shadows.owner.swordlevel == 1)
		shadows.skin = 1;
	if (shadows.owner.swordlevel == 2)
		shadows.skin = 2;
	if (shadows.owner.swordlevel == 3)
		shadows.skin = 3;

	shadows.frame = self.char.frame;
	shadows.angles = self.char.angles;
	setorigin(shadows, self.char.origin);
	shadows.think = SwordShadowsThink;
	shadows.nextthink = time + 0.1;
	self.nextshadow_time = time + 0.1;
};

// called from vigils roundhouse kick in impulses.qc, put a shadow trail effect
void() LegShadowThink =
{
	if (self.attack_finished < time)
	{
		if (self.frame < 4)
		{
			self.frame = self.frame + 1;
			if (self.alpha > 0.01)
				self.alpha = self.alpha - 0.01;
		}
		else
		{
			remove(self);
			return;
		}
		self.attack_finished = time + 0.1;
	}
	if (self.owner.frame < $kick1 || self.owner.frame > $kick5)
	{
		remove(self);
		return;
	}
	setorigin(self, self.owner.origin);
	frameskip(0.01);
};

void() LegShadow =
{
	local entity shadows;

	shadows = spawn();
	shadows.owner = self;
	shadows.classname = "shadows";
	shadows.movetype  = MOVETYPE_NOCLIP;
	shadows.solid     = SOLID_NOT;
	shadows.alpha = 0.25;
	shadows.drawonlytoclient = self.owner; // reduce network traffic
	setmodel (shadows, "progs/shdowleg.mdl");
	shadows.effects   = EF_ADDITIVE | EF_FULLBRIGHT;

	shadows.angles = self.angles;
	setorigin(shadows, self.origin);

	shadows.think = LegShadowThink;
	shadows.nextthink = time + 0.1;
	self.nextshadow_time = time + 0.08;
};

//
// Vigil's combo display
//

.float combocompare1, combocompare2, combocompare3;
.float combometer_finished, combostep, combo_message_finished;

void() ComboMeter = // called from playerpostthink
{
	local string h;
	
	if (self.combometer_finished < time)
	{
		if (self.combocompare3 != self.combocompare2)
		{
			if (self.combostep == TRUE)
			{
				self.combocompare3 = self.combo;
				self.combostep = FALSE;
				self.combometer_finished = time + 1;
			}
		}
		if (self.combocompare2 != self.combocompare1)
		{
			if (self.combostep == FALSE)
			{
				self.combostep = TRUE;
				self.combocompare2 = self.combo;
				self.combometer_finished = time + 1;
			}
		}
		self.combocompare1 = self.combo;

		//
		// Congrats messages on combos
		//

		if (self.combocompare1 > 0 && self.combocompare1 == self.combocompare2 && self.combocompare2 == self.combocompare3)
		{
			self.last_combo = self.combo; // record and store it

			// Congrats messages to the player
			if (self.combo > 3 && self.combo < 7)
			{
				self.combo_message = 1;
				localsound("misc/combomsg1", 4, 1);
			}
			else if (self.combo > 7 && self.combo < 10)
			{
				self.combo_message = 2;
				localsound("misc/combomsg2", 4, 1);
			}
			else if (self.combo > 9 && self.combo < 15)
			{
				self.combo_message = 3;
				localsound("misc/combomsg3", 4, 1);
			}
			else if (self.combo > 14 && self.combo < 20)
			{
				self.combo_message = 4;
				localsound("misc/combomsg4", 4, 1);
			}
			else if (self.combo > 19 && self.combo < 30)
			{
				self.combo_message = 5;
				localsound("misc/combomsg5", 4, 1);
			}
			else if (self.combo > 29 && self.combo < 50)
			{
				self.combo_message = 6;
				localsound("misc/combomsg6", 4, 1);
			}
			else if (self.combo > 49 && self.combo < 75)
			{
				self.combo_message = 7;
				localsound("misc/combomsg7", 4, 1);
			}
			else if (self.combo > 74 && self.combo < 99)
			{
				self.combo_message = 8;
				localsound("misc/combomsg8", 4, 1);
			}
			else if (self.combo > 98)
			{
				self.combo_message = 9;
				localsound("misc/combomsg9", 4, 1);
			}
			else
				self.combo_message = 0;

			self.combo = self.combostep = self.combocompare1 = self.combocompare2 = self.combocompare3 = 0;
			if (self.combo_message != 0)
				self.combo_message_finished = time + 3;
		}
		self.combometer_finished = time + 1;
	}
	if (self.combo_message_finished < time)
		self.combo_message = 0;
};

void() invunerable_field_think =
{
	makevectors(self.owner.angles);

	if (self.owner.invunerability_finished < time)
	{
		self.owner.alpha = 1;
		remove(self);
		return;
	}
	self.owner.alpha = 0.5;
	setorigin (self, self.owner.origin);
	frameskip(0.01);
};

void() invunerable_field =
{
	local entity h = spawn();
	h.owner = self;
	h.movetype = MOVETYPE_NOCLIP;
	h.solid = SOLID_NOT;
	setmodel (h, "progs/null.spr");
	sound (h, CHAN_AUTO, "player/invun.wav", 1, ATTN_NORM);
	h.effects = EF_BRIGHTFIELD;
	h.think = invunerable_field_think;
	h.nextthink = time + 0.1;
};

// bring him back to life
void() Respawn_Dummy =
{
	self.health = self.max_health;
	self.takedamage = DAMAGE_AIM; // Give health, now allow him to take damage
	self.owner.mana = 0;
	self.deadflag = DEAD_NO;

	self.attack_finished = time + 10;
	self.flypain = TRUE; // stop AI from attacking while getting up
	self.movetype = MOVETYPE_WALK;
	self.angles_x = 0;
	self.block_finished = time; // remove blocking (minor fix)

	if (random() < 0.5)
		self.think = player_fflip1;
	else
		self.think = player_getup1;

	invunerable_field();
	self.invunerability_finished = time + 5;
	self.nextthink = time + 0.1;
};

//*
// magic menu
//*

.float bubbleshow;
void() SpellBubbleThink =
{
	// Display graphics for which spell is selected
	if (self.owner.currentspell == SPELL_FIREBALL)
	{
		if (self.frame != 0)
			self.frame = 0;
	}
	else if (self.owner.currentspell == SPELL_LIGHTNING)
	{
		if (self.frame != 1)
			self.frame = 1;
	}
	else if (self.owner.currentspell == SPELL_ICE)
	{
		if (self.frame != 2)
			self.frame = 2;
	}
	else if (self.owner.currentspell == SPELL_BEAM)
	{
		if (self.frame != 3)
			self.frame = 3;
	}
	else if (self.owner.currentspell == SPELL_TWISTER)
	{
		if (self.frame != 4)
			self.frame = 4;
	}
	if (self.owner.magicmenu == FALSE)
	{
		self.owner.bubbleshow = FALSE;
		remove(self);
		return;
	}

	makevectors(self.angles);
	if (self.owner.angles_y == 0)
		setorigin (self, self.owner.char.origin + v_up * 60 + v_forward * 10);
	else
		setorigin (self, self.owner.char.origin + v_up * 60 - v_forward * 10);
	self.nextthink = time + 0.01;
};

void() SpellBubble =
{
	local entity mg;

	makevectors (self.char.angles);

	mg = spawn();
	mg.owner = self;
	mg.classname = "spellbubble";
	mg.movetype  = MOVETYPE_NOCLIP;
	mg.effects = EF_NODEPTHTEST;
	mg.solid = SOLID_NOT;
	mg.drawonlytoclient = self.char.owner;

	setmodel (mg, "progs/spells.spr");
	setsize (mg, '0 0 0', '0 0 0');

	// Change the sprites graphics depending on what spell is selected
	if (mg.owner.currentspell == SPELL_FIREBALL)
		mg.frame = 0;
	else if (mg.owner.currentspell == SPELL_LIGHTNING)
		mg.frame = 1;
	else if (mg.owner.currentspell == SPELL_ICE)
		mg.frame = 2;
	else if (mg.owner.currentspell == SPELL_BEAM)
		mg.frame = 3;
	else if (mg.owner.currentspell == SPELL_TWISTER)
		mg.frame = 4;

	if (self.char.angles_y == 0)
		setorigin (mg, mg.owner.char.origin + v_up * 60 + v_forward * 10);
	else
		setorigin (mg, mg.owner.char.origin + v_up * 60 - v_forward * 10);

	mg.think = SpellBubbleThink;
	mg.nextthink = time + 0.1;
};

//*
// ledge grabbing checking
//*

void() player_checkledge =
{
	local float ledgegrab_ok = FALSE; // TRUE if can ledge grab
	local float test;
	local entity oself, grab;
	local vector source, x;
	
	// Remove angles X and Z on traces
	x_x = 0;
	x_y = self.char.angles_y;
	x_z = 0;

	// Remove turning angle on traces
	if (x_y == 45 || x_y == -45)
		x_y = 0;
	if (x_y == 225 || x_y == -225)
		x_y = 180;

	makevectors(x);
	
	source = self.char.origin;
	
	traceline (source, source + v_forward*20 + v_up*45, FALSE, self);

	grab = spawn();
	grab.owner = self.char;
	grab.movetype = MOVETYPE_TOSS;
	grab.solid = SOLID_TRIGGER;
	grab.classname = "ledgegrab";
	grab.drawonlytoclient = self; // reduce network traffic

	grab.origin_x = trace_endpos_x;
	grab.origin_y = trace_endpos_y;
	grab.origin_z = trace_endpos_z;

	setmodel (grab, string_null);
	setsize(grab, '-1 -1 -1', '1 1 1'); // Fixes Vigil grabbing onto func_plat/train
	grab.origin_y = self.char.origin_y;
	
	oself = self;
	self = grab;

	droptofloor();

	if (walkmove(0,0))
	{
		// use Z checking if it's okay for Vigil to grab, try to keep his hands near the ledge as close as possible...
		if (self.origin_z > self.owner.origin_z + 30 && self.origin_z < self.owner.origin_z + 45)
			ledgegrab_ok = TRUE;
	}
	else
		ledgegrab_ok = FALSE;

	self = oself;

	if (ledgegrab_ok == TRUE)
	{
		self.wallrun = FALSE;
		self.wallgrab = FALSE; // must be removed!
		self.char.inair = self.char.bigfall = 0; // remove BIG FALL
		self.char.djump_spincnt = 4; // Must be set 4 and above, fix a minor bug preventing blocking while ledge grabbing
		self.ledgegrab = TRUE;
		self.doublejump = TRUE; // bug fix: make sure player cannot double jump stuck himself
		self.char.running = FALSE;
		self.char.movetype = MOVETYPE_FLY; // Lock Vigil
		self.char.velocity = '0 0 0';
		self.char.attack_finished = time + 0.5;
		self.char.angles_x = 0; // must be reset to 0 incase of double jump
		self.softshadow_time = time;
		self.char.aircombo_count = 0;
		self.char.think = player_ledgegrab1;
		self.char.nextthink = time; // right away
		sound (self, CHAN_WEAPON, "player/ledge.wav", 1, ATTN_NORM);
	}
	if (grab != world)
		remove(grab);
	return;
};

//*
// main player thinking code, handles all of Vigil's physics and more and is updated each game frame
//*

.float jump_finished;
.float grabcooldown_finished;
void() player_bigfall1;

void() player_think =
{
	local entity oself, oldself;
	local vector source;

	// FL_ONGROUND is removed prematurely to allow Vigil to move with velocity
	// so we'll assign FL_ONGROUND to "onground" before it's tampered with
	if (self.char.flags & FL_ONGROUND)
	{
		self.char.onground = TRUE;
		self.char.inair = 0;
		
		if (self.char.bigfall == TRUE && self.char.health > 0)
		{
			self.attack_finished = time + 1;
			//self.char.movetype = MOVETYPE_TOSS; // Lock Vigil down
			self.camshake_finished = time + 0.2;
			sound (self.char, CHAN_WEAPON, "player/jmpflor.wav", 1, ATTN_NORM);
			self.char.movetype = MOVETYPE_WALK; // Allow Vigil to fall
			self.char.think = player_bigfall1;
			self.char.bigfall_recovery_finished = time + 0.5;
			self.char.inair = 0;
			self.char.bigfall = FALSE;
		}
	}
	else
	{
		if (self.ledgegrab == FALSE && self.char.pain_finished < time && self.wallgrab == FALSE && self.char.wallrun_height < 1 && !self.char.swimming)
		{
			self.char.inair = self.char.inair + 1 * (frametime * 100); // add 1 to the counter
			//local string s = ftos (self.char.inair);
			//bprint ("In Air: ", s, "\n");
		}
		else
			self.char.inair = 32; // 32 goes into immediate jump frame and is required for proper walljump/wallgrab
		self.char.onground = FALSE;
	}
	
	//
	// Forced walking bit for trigger_walk, keys are locked and Vigil auto walks!
	//
	if (self.forcewalk_finished > time && self.char.onground == TRUE)
	{
		makevectors (self.char.angles);
		touchtriggers (self.char, self.char.origin + v_forward * 1);
		self.char.takedamage = DAMAGE_NO; // cannot be hit while controls are locked
		self.char.block_finished = time; // fixes bug when vigil dodges into a trigger_walk
	}

	//
	// Lava Damage
	//

	if (self.char.watertype == CONTENT_LAVA || self.char.watertype == CONTENT_SLIME) // do damage
	{
		if (self.dmgtime < time && self.char.takedamage && self.char.invunerability_finished < time && !self.flags & FL_GODMODE)
		{
			if (self.char.liquidsound_finished < time)
			{
				if (self.char.watertype == CONTENT_LAVA)
					sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
				else
					sound (self, CHAN_BODY, "player/inslime.wav", 1, ATTN_NORM);
				self.char.liquidsound_finished = time + 2;
			}
			if (self.char.watertype == CONTENT_LAVA)
				self.dmgtime = time + 0.35;
			else
				self.dmgtime = time + 0.7;
			self.char.health = self.char.health - 1;
			if (self.char.health < 1)
				Killed(self.char, world);
		}
	}

	//
	// Magic Menu is done here
	//

	if (self.magicmenu == TRUE)
	{
		self.char.velocity_x = self.char.velocity_y = 0; // don't affect Z velocity

		if (self.bubbleshow == FALSE)
		{
			SpellBubble();
			self.bubbleshow = TRUE;
		}
		if (self.keyflags & (KEY_UP | KEY_DOWN))
		{
			if (self.keyflags & (KEY_UP) && self.FL_MGCPRESSED == FALSE)
			{
				sound (self, CHAN_ITEM, "player/mmenu1.wav", 1, ATTN_NORM);
				if (self.currentspell == SPELL_FIREBALL)
				{
					if (spells & IT_SPELL4)
						self.currentspell = SPELL_TWISTER;
					else // Spell not found, cycle to next ...
					{
						if (spells & IT_SPELL3)
							self.currentspell = SPELL_BEAM;
						else if (spells & IT_SPELL2)
							self.currentspell = SPELL_ICE;
						else if (spells & IT_SPELL1)
							self.currentspell = SPELL_LIGHTNING;
					}
				}
				else if (self.currentspell == SPELL_TWISTER)
				{
					if (spells & IT_SPELL3)
						self.currentspell = SPELL_BEAM;
					else // Spell not found, cycle to next ...
					{
						if (spells & IT_SPELL2)
							self.currentspell = SPELL_ICE;
						else if (spells & IT_SPELL1)
							self.currentspell = SPELL_LIGHTNING;
						else
							self.currentspell = SPELL_FIREBALL;
					}
				}
				else if (self.currentspell == SPELL_BEAM)
				{
					if (spells & IT_SPELL2)
						self.currentspell = SPELL_ICE;
					else // Spell not found, cycle to next ...
					{
						if (spells & IT_SPELL1)
							self.currentspell = SPELL_LIGHTNING;
						else
							self.currentspell = SPELL_FIREBALL;
					}
				}
				else if (self.currentspell == SPELL_ICE)
				{
					if (spells & IT_SPELL1)
						self.currentspell = SPELL_LIGHTNING;
					else
						self.currentspell = SPELL_FIREBALL;
				}
				else if (self.currentspell == SPELL_LIGHTNING)
					self.currentspell = SPELL_FIREBALL;
			}
			else if (self.keyflags & (KEY_DOWN) && self.FL_MGCPRESSED == FALSE)
			{
				sound (self, CHAN_ITEM, "player/mmenu1.wav", 1, ATTN_NORM);
				if (self.currentspell == SPELL_FIREBALL)
				{
					if (spells & IT_SPELL1)
						self.currentspell = SPELL_LIGHTNING;
					else // Spell not found, cycle to next ...
					{
						if (spells & IT_SPELL2)
							self.currentspell = SPELL_ICE;
						else if (spells & IT_SPELL3)
							self.currentspell = SPELL_BEAM;
						else if (spells & IT_SPELL4)
							self.currentspell = SPELL_TWISTER;
					}
				}
				else if (self.currentspell == SPELL_LIGHTNING)
				{
					if (spells & IT_SPELL2)
						self.currentspell = SPELL_ICE;
					else // Spell not found, cycle to next ...
					{
						if (spells & IT_SPELL3)
							self.currentspell = SPELL_BEAM;
						else if (spells & IT_SPELL4)
							self.currentspell = SPELL_TWISTER;
						else
							self.currentspell = SPELL_FIREBALL;
					}						
				}
				else if (self.currentspell == SPELL_ICE)
				{
					if (spells & IT_SPELL3)
						self.currentspell = SPELL_BEAM;
					else // Spell not found, cycle to next ...
					{
						if (spells & IT_SPELL4)
							self.currentspell = SPELL_TWISTER;
						else
							self.currentspell = SPELL_FIREBALL;
					}
				}
				else if (self.currentspell == SPELL_BEAM)
				{
					if (spells & IT_SPELL4)
						self.currentspell = SPELL_TWISTER;
					else
						self.currentspell = SPELL_FIREBALL;
				}
				else if (self.currentspell == SPELL_TWISTER)
					self.currentspell = SPELL_FIREBALL;
			}
			self.FL_MGCPRESSED = TRUE;
		}
		else
			self.FL_MGCPRESSED = FALSE;
	}

	//
	// Vigil's Ledge Grabbing routine ran under these circumstances
	//

	if (self.keyflags & (KEY_LEFT) || (self.keyflags & (KEY_RIGHT)) && self.ledgegrab == FALSE && self.char.onground == FALSE || self.wallgrab == TRUE)
	{
		if (self.char.health > 0 && self.char.aircombo_count < 5 && self.attack_finished < time && self.char.block_finished < time && self.char.pain_finished < time)
		{
			if (relics & IT_RELIC1 || self.char.swimming)
				player_checkledge();
		}
	}
	
	// Jump buffer for Run attack Hop
	if (self.button2 && self.char.runatk_speed > 70)
		self.button2_buffer = TRUE;

	//
	// Spin Attack
	//

	if (self.button0 && self.button2 && self.safezone == FALSE && self.attack_finished < time && self.char.tired_finished < time
	&& self.ledgegrab == FALSE && self.wallgrab == FALSE && self.char.deadflag != DEAD_DEAD && self.char.movetype != MOVETYPE_FLY
	&& self.wallrun == FALSE && self.forcewalk_finished < time && self.char.fly_time < time && self.char.guardbreak_finished < time
	&& self.char.dodge_finished < time && !self.char.swimming && self.char.health > 0 && self.nospinatk_finished < time && self.char.lowceil == FALSE && self.trigger_spincut_finished < time)
	{
		if (!self.char.flypain)
		{
			if (self.char.block_finished < time || self.char.velocity_z < 80)
			{
				if (self.mana > 0)
				{
					if (self.char.angles_y == 45 || self.char.angles_y == -45)
						self.char.angles_y = 0;
					if (self.char.angles_y == 225 || self.char.angles_y == -225)
						self.char.angles_y = 180;
					self.char.velocity_x = 0;
					self.char.pain_finished = time;
					self.char.flypain = FALSE;
					self.char.takedamage = DAMAGE_NO; // invunerability frames
					self.char.movetype = MOVETYPE_WALK; // very minor bug fix
					self.char.think = player_spinatk1;
					self.char.block_finished = time;
					self.char.charge_count = 0;
					self.char.bflipwall_finished = time; // minor bug fix
					self.char.angles_x = self.char.angles_z = 0; // bug fix: reset angle X/Z
					self.char.nextthink = time + 0.1;
					self.char.idle_count = 0; // reset pose
					self.magicmenu = FALSE;
					self.attack_finished = time + 1;
				}
			}
		}
	}

	if (self.button0 && self.char.tired_finished < time && self.char.deadflag != DEAD_DEAD && self.forcewalk_finished < time
	&& self.char.fly_time < time && self.safezone == FALSE && self.char.guardbreak_finished < time && self.char.health > 0 && self.char.lowceil == FALSE)
	{
		// Get out of turning angles
		if (self.char.angles_y == 45 || self.char.angles_y == -45)
			self.char.angles_y = 0;
		if (self.char.angles_y == 225 || self.char.angles_y == -225)
			self.char.angles_y = 180;
		self.char.idle_count = 0; // reset pose

		if (self.magicmenu == TRUE)
		{
			self.char.angles_y = self.char.turn_y;
			sound (self, CHAN_ITEM, "player/mmenu1.wav", 1, ATTN_NORM);
			self.magicmenu = FALSE;
		}
		player_fire();
		
		if (self.char.purge_cooldown < time)
			self.char.purge_finished = time + 0.06; // frame window
		self.char.purge_cooldown = time + 0.25;
		self.char.perfectblock_cooldown = time;
		
		self.FL_ATKPRESSED = TRUE;
	}
	else
	{
		self.FL_ATKPRESSED = FALSE;
		if (self.char.charge_count > 4 && self.char.health > 0)
		{
			self.char.think = player_chargeatk1;
			self.attack_finished = time + 99;
		}
		self.char.charge_count = 0;
	}

	//
	// Players launcher attack (attack (hold) + forward + forward)
	//

	if ((self.keyflags & (KEY_LEFT) && self.char.angles_y == 0) || (self.keyflags & (KEY_RIGHT) && self.char.angles_y == 180)
	&& self.magicmenu == FALSE && self.char.tired_finished < time && self.char.deadflag != DEAD_DEAD && self.char.grabbed == FALSE
	&& self.char.invunerability_finished < time && self.safezone == FALSE && self.char.dodge_finished < time && !self.char.swimming && self.char.health > 0 && self.char.lowceil == FALSE)
	{
		// Double tap dash attack - Begin
		if (self.dbltime == 0)
			self.dbltime = time + 0.5;
		else if (self.dbltime < 0)
		{
			if ((0 - self.dbltime) >= time && self.char.pain_finished < time && self.char.onground == TRUE && (self.attack_finished < time || (self.char.frame >= $stabs1 && self.char.frame <= $stabs12)))
			{
				if (self.button0)
				{
					// character dash attack here
					if (self.char.angles_y == 45 || self.char.angles_y == -45)
						self.char.angles_y = 0;
					if (self.char.angles_y == 225 || self.char.angles_y == -225)
						self.char.angles_y = 180;
					self.char.movetype = MOVETYPE_WALK; // Fixes getting hung up on MOVETYPE_STEP
					self.char.think = player_dashatk1;
					self.char.nextthink = time + 0.1;
					self.char.angles_x = 0;
					self.char.charge_count = 0;
					self.char.nextthink = time + 0.1;
					self.swordshadow_time = time + 0.4; // sword shadow
					self.attack_finished = time + 0.5;
					self.mashattack = FALSE;
				}
				else if (self.char.block_finished < time)
				{
					self.char.running = TRUE;
					self.zoom_mode = 2; // zoom out
				}
			}
			else
				self.dbltime = time;
		} // Double tap dashattack - End
	}
	else
	{
		// Double tap run - Start
		if (self.dbltime > 0)
		{
			if (self.dbltime >= time)
				self.dbltime = 0 - (time + 0.5);
			else
				self.dbltime = 0;
		}
		else if (self.dbltime < 0)
		{
		if ((0 - self.dbltime) < time)
			self.dbltime = 0;
		}
		// Double tap run - End
	}

	//
	// Vigil's backflip / double jump - start
	//

	if (self.char.onground == FALSE && self.ledgegrab == FALSE && self.char.health > 0) // not on ground
	{
		if (self.button2)
		{
			if (self.forcewalk_finished < time && self.char.fly_time < time && self.char.guardbreak_finished < time && self.ledgegrab_finished < time)
			{
				if (self.backflip_finished < time && self.char.deadflag != DEAD_DEAD && !self.char.swimming)
				{
					// double jump
					if (self.wallgrab == FALSE && self.doublejump == FALSE && self.FL_JMPPRESSED == FALSE
					&& self.char.pain_finished < time && self.attack_finished < time && (self.char.aircombo_count != 4)// && self.char.aircombo_count != 7)
					&& relics & IT_RELIC2 && self.char.bflipwall_finished < time && self.char.inair >= 20)
					{
						sound (self.char, CHAN_WEAPON, "player/djump.wav", 1, ATTN_NORM);
						self.char.djump_spincnt = 0;
						self.char.inair = 16; // reset how long he's been in-air
						self.char.bigfall = FALSE;
						self.char.movetype = MOVETYPE_WALK;
						self.doublejump = TRUE; // note: it is set to false when player jumps again
						self.char.think = player_doublejump1;
						self.doublejump_finished = time + 0.4; // time till animation is done
					}
					// backflip
					if ((self.char.pain_finished > time && self.char.paincount > 2) && self.char.velocity_z > 0 && self.nobackflip_finished < time
					|| self.char.bflipwall_finished > time)
					{
						self.char.movetype = MOVETYPE_WALK;
						self.doublejump = TRUE; // don't allow double jump out of a backflip
						self.backflip_finished = time + 0.7; // Perfect value! Player enters negative velocity by this itme...
						self.char.think = player_bflip1;
						self.char.aircombo_count = 0; // prevent animation glitch in player_jumpframe();
					}
				}
			}
			self.FL_JMPPRESSED = TRUE;
		}
		else
			self.FL_JMPPRESSED = FALSE;
	}

	//
	// Vigil's movement + speed control
	// also give minor air jumping control
	//

	if (self.char.onground == FALSE && !self.char.flypain && self.attack_finished < time && self.backflip_finished < time
	&& self.wallgrab == FALSE && self.char.deadflag != DEAD_DEAD && self.char.movetype != MOVETYPE_FLY
	&& self.ledgegrab == FALSE && self.ledgegrab_finished < time && self.char.fly_time < time
	&& self.char.guardbreak_finished < time && self.char.dodge_finished < time && self.char.health > 0 && self.char.grabbed == FALSE
	&& self.magicmenu == FALSE && self.char.tired_finished < time && self.wallrun == FALSE)
	{
		if (self.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			if (self.keyflags & KEY_RIGHT)
			{
				if (self.walljump == FALSE)
				{
					if (self.char.running == FALSE)
						self.char.velocity_x = 0 - (self.char.speed * 1.5 / 1.2);
					else
						self.char.velocity_x = 0 - (self.char.speed * 1.5);
					self.char.angles_y = 180;
				}
				else if (self.char.velocity_x <= 0)
					self.char.angles_y = 180;
			}
			else
			{
				if (self.walljump == FALSE)
				{
					if (self.char.running == FALSE)
						self.char.velocity_x = self.char.speed * 1.5 / 1.2;
					else
						self.char.velocity_x = self.char.speed * 1.5;
					self.char.angles_y = 0;
				}
				else if (self.char.velocity_x >= 0)
					self.char.angles_y = 0;
			}
		}
		else if (self.char.aircombo_count < 1 && self.button2_buffer == FALSE) // Slight mid-air friction
		{
			if (self.char.velocity_x != 0)
			{
				if (self.char.velocity_x > 0)
					self.char.velocity_x = self.char.velocity_x - 200 * frametime;
				if (self.char.velocity_x < 0)
					self.char.velocity_x = self.char.velocity_x + 200 * frametime;
			}
		}

		if (self.keyflags & (KEY_UP | KEY_DOWN))
		{
			if (self.keyflags & KEY_UP)
			{
				if (self.char.angles_y == 0 || self.char.angles_y == 45)
					self.char.angles_y = -45;
				if (self.char.angles_y == 180 || self.char.angles_y == -225)
					self.char.angles_y = 225;

				if (self.char.aircombo_count == 0)
				{
					if (self.char.running == FALSE)
						self.char.velocity_y = 0 - (self.char.speed * 1.5 / 1.2);
					else
						self.char.velocity_y = 0 - (self.char.speed * 1.5);
				}
			}
			else
			{
				if (self.char.angles_y == 0 || self.char.angles_y == -45)
					self.char.angles_y = 45;
				if (self.char.angles_y == 180 || self.char.angles_y == 225)
					self.char.angles_y = -225;

				if (self.char.aircombo_count == 0)
				{
					if (self.char.running == FALSE)
						self.char.velocity_y = self.char.speed * 1.5 / 1.2;
					else
						self.char.velocity_y = self.char.speed * 1.5;
				}
			}
		}
		else
		{
			if (self.char.velocity_y != 0) // Slight mid-air friction
			{
				if (self.char.velocity_y > 0)
					self.char.velocity_y = self.char.velocity_y - 325 * frametime;
				if (self.char.velocity_y < 0)
					self.char.velocity_y = self.char.velocity_y + 325 * frametime;
			}
		}
	}
	
	//
	// Finish movement speed
	//
	
	//
	// Vigil's Air Flying Swallow attack executor
	//

	if (self.button0 && self.char.health > 0 && self.char.onground == FALSE && self.char.deadflag != DEAD_DEAD && self.char.grabbed == FALSE
	&& self.char.aircombo_count == 9 && self.char.enemy != world && (game_progress & IT_PROGRESS4 || deathmatch == TRUE))
	{
		if (self.char.frame >= $kick1 && self.char.frame < $kick5) // Vigil performed a mid air round house kick
		{
			self.char.perform_flyingswallow = TRUE;
			self.noblock_finished = time + 999;
		}
	}

	//
	// Vigil's Jumping
	//

	if (self.char.onground == TRUE && self.char.deadflag != DEAD_DEAD && self.char.health > 0)
	{
		self.char.aircombo_count = 0;
		if (self.button2 && self.char.pain_finished < time && self.attack_finished < time && self.char.block_finished < time
		&& self.char.tired_finished < time && self.forcewalk_finished < time && self.conversation == FALSE &&
		self.char.guardbreak_finished < time && self.char.dodge_finished < time && self.nojump_finished < time && self.ledgegrab_finished < time)
		{
			if (self.FL_JMPPRESSED == FALSE)
			{
				if (self.magicmenu == FALSE)
				{
					traceline (self.char.origin, self.char.origin + v_up*45, FALSE, self);
					if (trace_fraction == TRUE && self.char.waterlevel < 2) // there isn't an object blocking Vigil's jump and he's not in water
					{
						if (self.char.movetype != MOVETYPE_WALK) // fix a potential ledge grab glitch that can RARELY but still happen
							self.char.movetype = MOVETYPE_WALK;
						self.doublejump = FALSE;
						if (self.char.enemy) // remove grab on enemy
							self.char.grabbed =	self.char.enemy.grabbed = FALSE;
						self.char.idle_count = 0; // reset pose
						self.char.velocity = '0 0 0';
						self.char.lastpos = self.char.origin; // for bottomless pits
						self.charge_count = 0; // disallow charge attack in air
						self.char.velocity_z = 425;
						self.char.frame = $jump1;
						// Remove grab on jump
						self.char.grabbed = FALSE;
						if (self.char.enemy)
							self.char.enemy.grabbed = FALSE;
						
						sound (self.char, CHAN_AUTO, "player/jump.wav", 1, ATTN_NORM);
					}
				}
				else
				{
					self.char.angles_y = self.char.turn_y;
					sound (self, CHAN_ITEM, "player/mmenu1.wav", 1, ATTN_NORM);
					self.magicmenu = FALSE;
				}
			}
			self.FL_JMPPRESSED = TRUE;
		}
		else
			self.FL_JMPPRESSED = FALSE;

		//
		// Vigil's moving code
		//

		if (self.magicmenu == FALSE) // Can't move with magic menu open
		{			
			if (self.keyflags & (KEY_LEFT | KEY_RIGHT) && self.char.pain_finished < time && self.char.block_finished < time &&
			self.char.tired_finished < time && self.attack_finished < time && self.char.deadflag != DEAD_DEAD &&
			self.wallgrab == FALSE && self.char.grabbed == FALSE && self.combo_finished < time && self.wallrun == FALSE
			&& self.char.guardbreak_finished < time && self.char.dodge_finished < time && self.char.health > 0)
			{
				if (self.keyflags & KEY_RIGHT)
				{
					if (self.char.running == FALSE)
						self.char.velocity_x = 0 - (self.char.speed / 1.1);
					else
						self.char.velocity_x = 0 - (self.char.speed * 1.5);
					self.char.angles_y = 180;
				}
				else
				{
					if (self.char.running == FALSE)
						self.char.velocity_x = self.char.speed / 1.1;
					else
						self.char.velocity_x = self.char.speed * 1.5;
					self.char.angles_y = 0;
				}
				self.char.movetype = MOVETYPE_WALK; // Fix for when Vigil holds his spin charge down and tries to move during it
			}
			else
			{
				if (self.char.running != FALSE)
					self.char.running = FALSE;
				if (self.char.velocity_time < time)
					self.char.velocity_x = 0;
			}

			if (self.keyflags & (KEY_UP | KEY_DOWN) && self.char.pain_finished < time && self.char.block_finished < time &&
			self.char.tired_finished < time && self.attack_finished < time && self.char.deadflag != DEAD_DEAD &&
			self.wallgrab == FALSE && self.char.grabbed == FALSE && self.combo_finished < time && self.wallrun == FALSE
			&& self.conversation == FALSE && self.char.guardbreak_finished < time && self.char.dodge_finished < time && self.char.health > 0)
			{
				if (self.keyflags & KEY_UP)
				{
					if (self.char.angles_y == 0 || self.char.angles_y == 45)
						self.char.angles_y = -45;
					if (self.char.angles_y == 180 || self.char.angles_y == -225)
						self.char.angles_y = 225;

					self.char.velocity_y = 0 - (self.char.speed);
				}
				else
				{
					if (self.char.angles_y == 0 || self.char.angles_y == -45)
						self.char.angles_y = 45;
					if (self.char.angles_y == 180 || self.char.angles_y == 225)
						self.char.angles_y = -225;
	
					self.char.velocity_y = self.char.speed;
				}
				self.char.movetype = MOVETYPE_WALK; // Fix for when Vigil holds his spin charge down and tries to move during it
			}
			else if (self.char.velocity_time < time)
				self.char.velocity_y = 0;
		}
	}
	
	//
	// Fix Physics (Slope-Sliding Issue)
	//

	if ((self.char.frame >= $stand1 && self.char.frame <= $stand6) || (self.char.frame >= $standb1 && self.char.frame <= $standb6) || (self.char.frame == $block1 || self.char.frame == $block2) || self.char.grab_count > 0)
	{
		//
		// TraceBox to ensure that the ground beneath Vigil's feet is still there
		//
		local vector dest;
		local float test;

		source = self.char.origin;
		dest = self.char.origin - v_up * 12;
		
		tracebox (source, VEC_HULL_MIN, VEC_HULL_MAX, dest, 1, self);

		if (trace_fraction == 1) // Hit nothing
			test = FALSE;
		else // on ground
			test = TRUE;
	
		// MOVETYPE has to be MOVETYPE_WALK for menus to work properly
		if ((self.char.velocity_x || self.char.velocity_y) || self.conversation == TRUE || (self.button0 && self.char.grab_count <= 0) || self.char.swimming || test == FALSE || self.char.frame == $block3)
			self.char.movetype = MOVETYPE_WALK;
		else										// Not moving, standing still
			self.char.movetype = MOVETYPE_STEP;		// STEP means no stupid slope-sliding, tracebox needed to make him fall if ground beneath his feet changes
	}
	
	
	//
	// Part of the Wall/Ledge Grabbing is done here, specifically the code to make Vigil jump in the other direction of the wall/ledge
	//

	if (!self.char.swimming && (self.wallgrab == TRUE || (self.ledgegrab == TRUE && self.char.frame >= $ledgeg1 && self.char.frame <= $ledgeg8)))
	{
		self.walljump = FALSE;
		self.doublejump = FALSE;
		if (self.button2)
		{
			if (self.char.attack_finished < time && self.walljump == FALSE && self.char.pain_finished < time)
			{
				self.FL_JMPPRESSED = TRUE; // clear flag
				self.ledgegrab = FALSE;
				self.char.movetype = MOVETYPE_WALK;
				self.char.running = TRUE; // Allow wall run after wall jump
				if (self.camera_forcezoom_finished < time)
					self.zoom_mode = 0; // No more zoom
				self.walljump = TRUE;
				self.wallrun = FALSE; // Fixes a bug
				self.wallgrab = FALSE;
				self.char.think = player_move;
				self.char.nextthink = time;
				self.char.velocity_z = 350;
				oself = self;
				self = self.char;
				player_yell(0);
				self = oself;
				if (self.char.angles_y == 0)
				{
					self.char.velocity_x = -180;
					self.char.angles_y = 180;
				}
				else
				{
					self.char.velocity_x = 180;
					self.char.angles_y = 0;
				}
				self.speedline_time = time + 0.1;
				sound (self.char, CHAN_AUTO, "player/jump.wav", 1, ATTN_NORM);
			}
		}
		else
			self.FL_JMPPRESSED = FALSE;
	}

	//
	// Vigil's Evasive Manuvers
	//
	if (self.char.block_finished > time && self.char.dodge_finished < time && self.char.onground == TRUE && self.char.health > 0 && self.char.bigfall_recovery_finished < time)
	{
		if (self.keyflags & KEY_UP)
		{
			if (self.char.angles_y == 0)
			{
				self.char.movetype = MOVETYPE_WALK; // Apply velocity
				self.char.angles_y = 0; // angle bug fix
				self.char.dodge_finished = time + 0.5;
				self.softshadow_time = time + 0.5;
				self.char.velocity_time = time + 0.5;
				self.char.think = player_dodgec1;
				self.char.nextthink = time;
			}
			else
			{
				self.char.movetype = MOVETYPE_WALK; // Apply velocity
				self.char.angles_y = 180; // angle bug fix
				self.char.dodge_finished = time + 0.5;
				self.softshadow_time = time + 0.5;
				self.char.velocity_time = time + 0.5;
				self.char.think = player_dodgee1;
				self.char.nextthink = time;
			}
			self.char.velocity = '0 0 0'; // BUG FIX: sliding while dodging under rare circumstances
		}
		else if (self.keyflags & KEY_DOWN)
		{
			if (self.char.angles_y == 0)
			{
				self.char.movetype = MOVETYPE_WALK; // Apply velocity
				self.char.angles_y = 0; // angle bug fix
				self.char.dodge_finished = time + 0.5;
				self.softshadow_time = time + 0.5;
				self.char.velocity_time = time + 0.5;
				self.char.think = player_dodged1;
				self.char.nextthink = time;
			}
			else
			{
				self.char.movetype = MOVETYPE_WALK; // Apply velocity
				self.char.angles_y = 180; // angle bug fix
				self.char.dodge_finished = time + 0.5;
				self.softshadow_time = time + 0.5;
				self.char.velocity_time = time + 0.5;
				self.char.think = player_dodgef1;
				self.char.nextthink = time;
			}
			self.char.velocity = '0 0 0'; // BUG FIX: sliding while dodging under rare circumstances
		}
		else if (self.keyflags & KEY_RIGHT) // Check facing direction also
		{
			if (self.char.angles_y == 0 && self.char.lowceil == FALSE) // Backwards Hand Spring
			{
				self.char.movetype = MOVETYPE_WALK; // Apply velocity
				self.char.angles_y = 0; // angle bug fix
				self.char.dodge_finished = time + 0.6;
				self.softshadow_time = time + 0.5;
				self.char.velocity_time = time + 0.6;
				self.char.think = player_dodgea1;
				self.char.nextthink = time;
			}
			else // Forward roll
			{
				self.char.movetype = MOVETYPE_WALK; // Apply velocity
				self.attack_finished = time + 0.5;
				self.char.angles_y = 180; // angle bug fix
				self.char.dodge_finished = time + 0.5;
				self.softshadow_time = time + 0.5;
				self.char.velocity_time = time + 0.4;
				self.char.think = player_dodgeb1;
				self.mashattack = FALSE;
				self.char.nextthink = time;
			}
			self.char.velocity = '0 0 0'; // BUG FIX: sliding while dodging under rare circumstances
		}
		else if (self.keyflags & KEY_LEFT) // Check facing direction also
		{
			if (self.char.angles_y == 0) // Forward roll
			{
				self.char.movetype = MOVETYPE_WALK; // Apply velocity
				self.attack_finished = time + 0.5;
				self.char.angles_y = 0; // angle bug fix
				self.char.dodge_finished = time + 0.5;
				self.softshadow_time = time + 0.5;
				self.char.velocity_time = time + 0.4;
				self.char.think = player_dodgeb1;
				self.mashattack = FALSE;
				self.char.nextthink = time;
			}
			else
			{
				if (self.char.lowceil == FALSE) // Backwards Hand Spring
				{
					self.char.movetype = MOVETYPE_WALK; // Apply velocity
					self.char.angles_y = 180; // angle bug fix
					self.char.dodge_finished = time + 0.6;
					self.softshadow_time = time + 0.5;
					self.char.velocity_time = time + 0.6;
					self.char.think = player_dodgea1;
					self.char.nextthink = time;
				}
				else
				{
					self.char.movetype = MOVETYPE_WALK; // Apply velocity
					self.attack_finished = time + 0.5;
					self.char.angles_y = 0; // angle bug fix
					self.char.dodge_finished = time + 0.5;
					self.softshadow_time = time + 0.5;
					self.char.velocity_time = time + 0.4;
					self.char.think = player_dodgeb1;
					self.mashattack = FALSE;
					self.char.nextthink = time;
				}
			}
			self.char.velocity = '0 0 0'; // BUG FIX: sliding while dodging under rare circumstances
		}
	}

	//
	// SPECIAL MOVE MOTIONS: Record keys if pressed, set timer till key is cleared
	//

	if (self.keyflags & KEY_UP)
	{
		if (self.FL_MP1PRESSED == FALSE)
		{
			self.moveprog1 = self.moveprog1 + 1; // increase counter
			self.moveprog1_finished = time + 0.2; // time till cleared
		}
		self.FL_MP1PRESSED = TRUE;
	}
	else if (!self.keyflags & KEY_UP)
		self.FL_MP1PRESSED = FALSE;

	if (self.keyflags & KEY_DOWN)
	{
		if (self.FL_MP2PRESSED == FALSE)
		{
			self.moveprog2 = self.moveprog2 + 1; // increase counter
			self.moveprog2_finished = time + 0.2; // time till cleared
		}
		self.FL_MP2PRESSED = TRUE;
	}
	else if (!self.keyflags & KEY_DOWN)
		self.FL_MP2PRESSED = FALSE;

	if (self.keyflags & KEY_LEFT)
	{
		if (self.FL_MP3PRESSED == FALSE)
		{
			self.moveprog3 = self.moveprog3 + 1; // increase counter
			self.moveprog3_finished = time + 0.2; // time till cleared
		}
		self.FL_MP3PRESSED = TRUE;
	}
	else if (!self.keyflags & KEY_LEFT)
		self.FL_MP3PRESSED = FALSE;

	if (self.keyflags & KEY_RIGHT)
	{
		if (self.FL_MP4PRESSED == FALSE)
		{
			self.moveprog4 = self.moveprog4 + 1; // increase counter
			self.moveprog4_finished = time + 0.2; // time till cleared
		}
		self.FL_MP4PRESSED = TRUE;
	}
	else if (!self.keyflags & KEY_RIGHT)
		self.FL_MP4PRESSED = FALSE;

	//
	// SPECIAL MOVE MOTIONS: Reset keys if timer is dropped
	//

	if (self.moveprog1_finished < time)
		self.moveprog1 = 0;
	if (self.moveprog2_finished < time)
		self.moveprog2 = 0;
	if (self.moveprog3_finished < time)
		self.moveprog3 = 0;
	if (self.moveprog4_finished < time)
		self.moveprog4 = 0;

	if (self.combo_finished < time)
		self.char.swing_count = 0;
};

void() player_wallgrab;
void() player_wallrun_right1;
void() player_wallrun_left1;
void() wallrunning_check =
{
	local vector source;
	local float direct = 0;

	makevectors(self.angles);
	source = self.origin;

	// wall running
	if (self.running == TRUE && self.owner.wallrun == FALSE && (self.frame == $jump1 || self.frame == $jump2))
	{
		if (self.owner.keyflags & KEY_UP && (self.owner.keyflags & KEY_LEFT || self.owner.keyflags & KEY_RIGHT))
		{
			traceline(source, source + '0 -25 -16', FALSE, self);

			// hint: never use direct == 0 unless you want weird glitches!
			if (self.owner.keyflags & KEY_RIGHT)
			{
				if (self.angles_y == 225)
					direct = 1;
			}
			else if (self.owner.keyflags & KEY_LEFT)
			{
				if (self.angles_y == -45)
					direct = 2;
			}
		}
		if (trace_fraction == 1.0)
			return;
		if (trace_ent.solid != SOLID_BSP)
			return;
		if (fabs(v_forward * trace_plane_normal) < 0.7)
			return;

		if (trace_plane_normal_z == FALSE)
		{
			if (direct == 1)
			{
				self.owner.wallrun = TRUE;
				self.angles_y = 180;
				self.wallrun_height = 150;
				self.think = player_wallrun_right1;
			}
			else if (direct == 2)
			{
				self.owner.wallrun = TRUE;
				self.angles_y = 0;
				self.wallrun_height = 150;
				self.think = player_wallrun_left1;
			}
			self.nextthink = time;
		}
	}
};

.float wallgrab_check_finished;
void() wallgrab_check =
{
	if (self.swimming)
		return;

	local vector source = self.origin;
	makevectors(self.angles);

	// wall grab
	if (self.angles_y == 0 || self.angles_y == 180 && self.wallgrab == FALSE && self.owner.ledgegrab == FALSE && self.owner.trigger_spincut_finished < time
	&& self.onground == FALSE && ((self.frame == $jump1 || self.frame == $jump2) || self.frame == $djump))
	{
		traceline (source, source + v_forward*25 + v_up*22, FALSE, self);
		if (trace_fraction == TRUE || trace_ent.solid != SOLID_BSP)
			return;

		traceline (source, source + v_forward*25 - v_up*22, FALSE, self);
		if (trace_fraction == TRUE || trace_ent.solid != SOLID_BSP)
			return;

		if (trace_plane_normal_z == FALSE) // Flat wall
			local float OK = TRUE;

		// Get Wall Texture
		local float surfnum = getsurfacenearpoint(world, trace_endpos);
		local string s = getsurfacetexture(world, surfnum);

/*
		// Check for clip brush by checking the floor (HACKY!)
		traceline (source, source - v_up*9999, FALSE, self);	
		local float surfnum2 = getsurfacenearpoint(world, trace_endpos);
		local string s2 = getsurfacetexture(world, surfnum2);

		if (s == s2) // Clip brushes only report floor texture, if floor and wall are the same
			return;   // don't allow a wall grab
		
		local vector v = getsurfaceclippedpoint(world, surfnum, trace_endpos);
*/

		// Check for 'sky' / 'clip2' text in texture
		local float r = strstrofs(s, "sky", 0);
		local float r2 = strstrofs(s, "{clip2", 0);
		if (!r || !r2) // found "sky" / '{clip2' string
			return;

		if ((self.owner.keyflags & (KEY_LEFT) && self.angles_y == 0) || (self.owner.keyflags & (KEY_RIGHT) && self.angles_y == 180))
		{
			if (OK && self.wallgrab_check_finished < time) // flat wall check
			{
				self.owner.aircombo_count = 0;
				if (self.owner.wallrun == TRUE) // bug fix: allow blocking again
					self.owner.wallrun = FALSE;
				self.wallgrab_check_finished = time + 0.2; // Don't spam
				self.think = player_wallgrab;
				self.nextthink = time;
			}
		}
	}
};

.float swimanimation_finished;
void() player_jumpframe =
{
	self.charge_count = 4; // set charge up attack somewhat when in air

	if ((self.onground == FALSE && self.inair > 31) || self.velocity_z > 100)
	{
		if (self.aircombo_count == 0 || self.aircombo_count == 3 || self.aircombo_count == 4 || self.aircombo_count >= 7)
		{
			if (self.velocity_z < 400) self.frame = $jump1;
			if (self.velocity_z < 100) self.frame = $jump2;
		}
		else if (self.aircombo_count == 1)
		{
			self.frame = $jumpatkb1; //
			if (self.attack_type == 6)
				FireMelee(3,25,1,25,1,0,0,FALSE,24,0); // Keep firing, needs to only hit target 1 time however, handled in damage.qc
		}
		else if (self.aircombo_count == 2)
		{
			self.frame = $jumpatkb3;
			if (self.attack_type == 7)
				FireMelee(3,25,1,25,1,0,0,FALSE,24,0); // Keep firing, needs to only hit target 1 time however, handled in damage.qc
		}
		// 4 Is reserved ............
		// Air uppercut slice
		else if (self.aircombo_count == 5)
			self.frame = $airkick10;
		else if (self.aircombo_count == 6)
			self.frame = $airkick12;
	}
	
	if (self.owner.safezone == FALSE) // Safezone means no wall running / wall grabbing
	{
		if (relics & IT_RELIC5)
			wallrunning_check(); // check if there's a wall to run on
		if (relics & IT_RELIC4)
			wallgrab_check(); // check if there's a wall to grab on
	}
};

//
// Grab opponents up-close
//

void() player_grab =
{
	local entity head, check, oself;
	local float cg;
	local vector source;
	
	if (self.running == TRUE || self.grabbed == TRUE)
		self.running = FALSE;

	MakeSolidList();
	
	local vector v;
	v = self.angles;

	// Removing turning angles on grab checks
	// otherwise enemies get grabbed closer and it looks odd
	if (self.angles_y == 45 || self.angles_y == -45)
		v_y = 0;
	if (self.angles_y == 225 || self.angles_y == -225)
		v_y = 180;

	makevectors (v);

	head = searchradius(self.origin, 40);
	while (head)
	{
		if (head.takedamage && head != self && self.grabbed == FALSE && head.grabbed == FALSE && self.invunerability_finished < time
		&& self.onground == TRUE && visible(head) && head.deadflag == DEAD_NO && head.twister_damage_finished < time
		&& ((head.flags & FL_ONGROUND && deathmatch == FALSE && head.flags & FL_MONSTER) || (deathmatch == TRUE
		&& (head.frame == $block1 || head.frame == $block2))))
		{
			if (head.th_grab) // check if it's safe to grab now
			{
				self.enemy = self.owner.enemy = head; // record which entity vigil+player grabbed

				check = spawn();
				check.movetype = MOVETYPE_NOCLIP;
				check.owner = self;
				check.drawonlytoclient = self; // reduce network traffic
				setmodel (check, string_null);
				setsize(check, self.enemy.mins, self.enemy.maxs);
				setorigin(check, self.origin + v_forward * 25 + v_up * 32); // added v_up for slopes
				check.origin_y = self.origin_y; // be sure to lock it

				oself = self;
				self = check; // to the check entity
				droptofloor(); // floor it instantly

				// look in the players direction
				if (self.origin_x < self.owner.origin_x)
					self.angles_y = 0;
				else
					self.angles_y = 180;

				cg = walkmove(self.angles_y, 0);

				source = self.origin;
				self = oself; // back to vigil

				if (!self.origin_z < head.origin_z + 12 && !self.origin_z > head.origin_z - 12 && !visible(head))
					cg = FALSE;

				if (self.origin_z < check.origin_z + 12 && self.origin_z > check.origin_z - 12 && visible(check))
				{
					if (cg) // can grab
					{
						self.counter_finished = time; // remove counter attack timer
						self.grabcooldown_finished = time + 1.5;
						if (self.owner.camera_forcezoom_finished < time)
							self.owner.zoom_mode = 0; // no zoom
						self.movetype = MOVETYPE_STEP; // Disable slope-slide
						self.velocity_x = self.velocity_y = 0;
						
						if (self.th_grab)
							self.th_grab();

						oself = self;
						self = head;
						self.angles = check.angles; // make sure to face player
						self.fixangle = TRUE;

						setorigin (self, check.origin); // bring enemy infront of vigil
						self.velocity = '0 0 0'; // remove velocity slide

						if (deathmatch == FALSE)
						{
							self.grabbed = TRUE; // enable grab flag on whoever vigil is grabbing
							self.th_grab();
						}
						else // grabbed = TRUE on Vigil will cause the grabbed player to assume they're grabbing as well
							self.th_pain();

						self = oself;
						sound (self, CHAN_WEAPON, "player/grab.wav", 1, ATTN_NORM);
						self.grabbed = TRUE;
						self.running = FALSE; // don't easily wake up monsters!
						self.attack_finished = time + 0.25; // Fix any sillyness
						self.owner.grab_finished = time + 1.5;
						self.owner.nojump_finished = time + 0.5;
					}
				}
				if (check != world)
				{
					remove(check);
					return;
				}
			}
		}
		head = head.chain;
	}
	UnmakeSolidList();
};

.float shadow;
.float walkani_finished;
.float new_walkframe;
void() player_tired1;
void() player_move = [0, player_move]
{
	local vector source;
	local float onefoot = FALSE;
	
	if (self.deadflag == DEAD_DEAD) // Zombie Vigil fix
		return;

	touchtriggers (self, self.origin);

	if (self.tired_finished > time)
		player_tired1();
	if (!self.shadow) // sprite shadow, drawn under Vigil
	{
		//spawn_shadow();
		self.shadow = TRUE;
	}
	// Reset X+Z angles
	if (!self.swimming)
		self.angles_x = self.angles_z = 0;

	if (self.owner.magicmenu == FALSE)
	{
		if (self.velocity_x || self.velocity_y && self.owner.keyflags & (KEY_LEFT | KEY_RIGHT | KEY_UP | KEY_DOWN) || self.owner.forcewalk_finished > time)
		{
			if (self.swimming)
			{
				self.running = FALSE; // don't easily wake up monsters!
				if (self.walkframe > 7)
					self.walkframe = 0;
				if (self.walkframe == 0)
					sound (self, CHAN_BODY, "hydra/swim.wav", 1, ATTN_NORM);
				self.frame = $swim1 + self.walkframe;
				frameskip(0.2);
			}
			else
			{
				if (self.running == FALSE) // walk frames
				{					
					if (self.walkani_finished < time) // needs to run on a seperate timer so player_grab(); is more reliable
					{
						if (self.new_walkframe == 1 || self.new_walkframe == 6 && self.onground == TRUE)
							sound (self, CHAN_BODY, "player/run.wav", 0.5, ATTN_NORM);
						self.new_walkframe = self.new_walkframe + 1;
						self.walkani_finished = time + 0.05;
					}
					if (self.new_walkframe > 11) // foot step sound, keep it in sync
						self.new_walkframe = 0;
					
					self.frame = $walk1 + self.new_walkframe;

					if (self.grabcooldown_finished < time && self.grabbed == FALSE && !self.swimming)
						player_grab(); // execute grabbing

					frameskip(0.01);
				}
				else // running frames
				{
					// running step sound
					if (self.walkframe == 1 || self.walkframe == 4 && self.onground == TRUE)
						sound (self, CHAN_BODY, "player/run.wav", 1, ATTN_NORM);
					if (self.walkframe > 5) // foot step sound, keep it in sync
						self.walkframe = 0;
					if (self.owner.zoom_mode != 2) // zoom out
						self.owner.zoom_mode = 2;
					self.frame = $run1 + self.walkframe;
				}
			}
			if (self.idle_count != 0)
				self.idle_count = 0;
			if (self.charge_count != 0)
				self.charge_count = 0;
		}
		else // stand frames
		{
			// Vigil's charge up attack, standing still only
			if (self.owner.button0 && self.invunerability_finished < time && self.safezone == FALSE && self.forcewalk_finished < time && self.char.fly_time < time)
			{
				if (self.charge_count < 6)
					self.charge_count = self.charge_count + 1;
				if (self.charge_count == 3)
					self.frame = $charge1;
				else if (self.charge_count == 4)
					self.frame = $charge2;
				else if (self.charge_count == 5)
					self.frame = $charge3;
				else if (self.charge_count == 6)
					self.frame = $charge4;
			}

			if (self.charge_count < 4)
			{
				//
				// Make sure both of Vigil's feet are touching the ground
				//
				makevectors(self.angles);
				source = self.origin;

				traceline (source, source + v_forward*18 - v_up*25, FALSE, self);
				if (trace_fraction == 1)
					onefoot = TRUE;

				traceline (source, source - v_forward*18 - v_up*25, FALSE, self);
				if (trace_fraction == 1)
					onefoot = TRUE;

				// 
				//
				//

				if (onefoot == TRUE)
				{
					if (self.walkframe > 5)
						self.walkframe = 0;
					self.frame = $standb1 + self.walkframe;
					if (!self.swimming)
					{
						// Animation slow down on idle frames
						if (self.idle_count > 50)
							frameskip(0.11);
						if (self.idle_count > 60)
							frameskip(0.12);
						if (self.idle_count > 80)
							frameskip(0.13);
						if (self.idle_count > 100)
							frameskip(0.14);
						if (self.idle_count > 120)
							frameskip(0.16);
						if (self.idle_count > 130)
							frameskip(0.18);
						if (self.idle_count > 135)
							frameskip(0.2);
					}
					else
						frameskip(0.2);
				}
				else
				{
					if (self.idle_count <= 150)
					{
						if (self.walkframe > 5)
							self.walkframe = 0;
						self.frame = $stand1 + self.walkframe;
						if (self.swimming)
							frameskip(0.2);
						// Animation slow down on idle frames
						if (self.idle_count > 50)
							frameskip(0.11);
						if (self.idle_count > 60)
							frameskip(0.12);
						if (self.idle_count > 80)
							frameskip(0.13);
						if (self.idle_count > 100)
							frameskip(0.14);
						if (self.idle_count > 120)
							frameskip(0.16);
						if (self.idle_count > 130)
							frameskip(0.18);
						if (self.idle_count > 135)
							frameskip(0.2);
					}
					else
					{
						if (self.walkframe > 12)
							self.walkframe = 0;
						self.frame = $idle1 + self.walkframe;
						if (self.swimming)
							frameskip(0.2);
						else
							frameskip(0.12);
					}
				}
			}
			self.idle_count = self.idle_count + 1;

			// Get out of turning angles
			if (self.angles_y == 45 || self.angles_y == -45)
				self.angles_y = 0;
			if (self.angles_y == 225 || self.angles_y == -225)
				self.angles_y = 180;
		}

		if (!self.flags & FL_ONGROUND) // in the air animation! (FL_ONGROUND: required, "onground" too slow for this purpose)
		{
			if (self.block_finished > time)
				player_block();
			else
			{
				if (!self.swimming)
					player_jumpframe();
				else
				{
					if (self.walkframe > 7)
						self.walkframe = 0;
					self.frame = $swim1 + self.walkframe;
					frameskip(0.2);
				}
			}
		}
		self.walkframe = self.walkframe + 1;
	}
	else // User entered the magic selection menu
		self.frame = $magica1;

	//
	// clear stuff up ...
	//

	if (self.onground == TRUE)
	{
		self.owner.doublejump = FALSE; // Allow double jump when falling off ledges
		self.owner.aircombo_finished = time;
		self.owner.wallrun = FALSE;
		self.owner.attack_finished = time; // only reset attack finish time on ground, this is to prevent cheap air combos
		self.owner.walljump = FALSE;
		self.owner.ledgegrab_finished = time;
		self.djump_spincnt = 0; // remove double jump flag
	}
	self.owner.purge_toggle = FALSE;
	self.pain_finished = time;
	self.paincount = 0;
	self.fly_time = time;
	self.flypain = FALSE;
	if (self.perfectguard_buff < time)
		self.takedamage = DAMAGE_AIM;
	if (self.owner.status_broken_finished < time)
		self.owner.noblock_finished = time;
	self.spin_finished = FALSE;
	self.fstab_cnt = 0;

	self.runatk_speed = 0;
	self.owner.wallgrab = FALSE;
	if (self.owner.zoom_mode != 0 && self.grabbed == FALSE && self.running == FALSE && self.owner.camera_forcezoom_finished < time)
		self.owner.zoom_mode = 0; // No more zoom
	
	// Don't set it here, messes with player_fire(); somehow
	// self.grabbed = FALSE;
	
	self.grab_count = 0;
	self.beams_shot = 0;
	self.pitdeath = FALSE;
	self.owner.swordshadow_time = time;
	self.owner.softshadow_time = time;
	self.chargespincnt = 0; // Remove spins from charge spin attack
	self.mashattack = FALSE;
	self.dodge_finished = time;
	self.ftspin_count = 0;
	self.knockback = 0; // reset his knockback! important
	self.sword_spincnt = 0; // reset sword 'spin' animation stuff (cyclone crush etc)

	if (self.flags & FL_ONGROUND && self.owner.button2_buffer)
		self.owner.button2_buffer = FALSE; // Reset short hop flag

	self.owner.button3 = self.owner.FL_BLKPRESSED = FALSE; // Reset block button flag
	self.block_finished = time; // auto-block fix
	self.lowceil = FALSE; // remove low ceiling flag
};

//*
//attacking
//*

void() player_kick1;
void() player_counter1;
void() player_runatk1
void() player_attacka1;
void() player_attacka5;
void() player_attacka10;
void() player_jumpatk1;
void() player_jumpatkb1;
void() player_jumpatkb2;
void() player_jumpatkb4;
void() player_airuppercut1;
void() player_grabatk1;
void() player_grabatk5;
void() player_grabatk11;
void() wallrun_divingswallow_init;
void() player_swordspin1;
void() player_airkick1;
void() player_airkick7;
void() player_airkick11;
void() player_airkick13;
void() player_fstab1;
void() player_stabs1;
void() player_slash1;
void() player_waterslash1;

.float voice_finished; // don't allow Vigil's voice to overlap
void(float voice_type) player_yell =
{
	local float r, h;

	h = random();
	r = random();

	if (self.classname != "player")
		objerror ("Camera should not yell.\n");

	if (voice_type == 0)
	{
		if (h < 0.4 && self.voice_finished < time)
		{
			if (r < 0.25)
				sound (self, CHAN_VOICE, "player/yell1.wav", 1, ATTN_NORM);
			else if (r < 0.5)
				sound (self, CHAN_VOICE, "player/yell2.wav", 1, ATTN_NORM);
			else if (r < 0.75)
				sound (self, CHAN_VOICE, "player/yell3.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "player/yell4.wav", 1, ATTN_NORM);
			self.voice_finished = time + 0.8;
		}
	}
	else
	{
		if (h < 0.2 && self.voice_finished < time)
		{
			if (r < 0.20)
				sound (self, CHAN_VOICE, "player/taunt1.wav", 1, ATTN_NORM);
			else if (r < 0.40)
				sound (self, CHAN_VOICE, "player/taunt2.wav", 1, ATTN_NORM);
			else if (r < 0.60)
				sound (self, CHAN_VOICE, "player/taunt3.wav", 1, ATTN_NORM);
			else if (r < 0.80)
				sound (self, CHAN_VOICE, "player/taunt4.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "player/taunt5.wav", 1, ATTN_NORM);
			self.voice_finished = time + 1;
		}
	}
};

// note: self.char.aircombo_count = 9 is delt in impulses.qc for the round house
void() player_fire =
{
	local float r;
	local entity oself;

	if (self.FL_ATKPRESSED == TRUE || self.char.flypain || self.char.pain_finished > time || self.ledgegrab == TRUE
	|| self.char.movetype == MOVETYPE_FLY)
		return;
	if (self.wallrun == TRUE && self.doublejump == TRUE || self.char.invunerability_finished > time)
		return;
	if (self.char.angles_x != 0)
		self.char.angles_x = 0;
	if (self.purge_toggle) // Don't allow an attack to break out during purge animation
		return;
	if (self.trigger_spincut_finished > time)
		return;

	if (self.attack_finished > time)
	{
		if (!self.char.swimming)
			self.mashattack = TRUE;
		return;
	}

	if (self.wallrun == TRUE)
	{
		wallrun_divingswallow_init();
		return;
	}

	// reset to normal attack before animation is played
	// used to be delt with in damage.qc
	self.char.attack_type = 0;
	self.char.movetype = MOVETYPE_WALK; // Allow velocity

	// counter attack
	if (self.char.counter_finished > time && self.char.onground == TRUE)
	{
		self.char.takedamage = DAMAGE_NO;
		self.char.block_finished = time;
		self.char.dodge_finished = time;
		self.char.think = player_counter1;
		self.swordshadow_time = time + 0.7; // sword shadow
		self.attack_finished = time + 0.7;
		return;
	}

	if (self.char.block_finished > time || self.char.dodge_finished > time)
		return;

	r = random();

	//
	// Vigil can only do a simple sword swing under water
	//
	if (self.char.swimming)
	{
		if (self.combo_finished < time)
		{
			oself = self;
			self = self.char;
			player_yell(0); // vigil yell
			self = oself;
			
			if (self.char.angles_y == 45 || self.char.angles_y == -45)
				self.char.angles_y = 0;
			if (self.char.angles_y == 225 || self.char.angles_y == -225)
				self.char.angles_y = 180;
			
			if (self.zoom_mode != 0 && self.camera_forcezoom_finished < time)
				self.zoom_mode = 0; // No Zoom
			self.swordshadow_time = time + 0.4; // sword shadow
			self.char.think = player_waterslash1;
			self.attack_finished = time + 0.5;
			self.char.swing_count = 0;
		}
		return;
	}
	
	if (self.char.onground == TRUE || self.char.flags & FL_ONGROUND)
	{   // Fix Vigil doing normal attacks during a grab (TESTME)
		if (self.char.grabbed == FALSE)
		{
			if (self.moveprog2 > 0 && (self.moveprog3 > 0 || self.moveprog4 > 0) && (game_progress & IT_PROGRESS2 || deathmatch == TRUE))
			{
				self.char.sword_spincnt = 0;
				self.char.think = player_swordspin1;
				self.attack_finished = time + 3;
				self.noblock_finished = time + 3;
				return;
			}
			self.char.sword_spincnt = 0; // Fixes issue with screen shake after cyclone crush
			if (self.char.swing_count == 0)
			{
				if (!self.char.running)
				{
					if (self.keyflags & (KEY_LEFT | KEY_RIGHT))
					{
						oself = self;
						self = self.char;
						player_yell(0); // vigil yell
						self = oself;
						if (self.zoom_mode != 0 && self.camera_forcezoom_finished < time)
							self.zoom_mode = 0; // No Zoom
						self.swordshadow_time = time + 0.4; // sword shadow
						self.char.movetype = MOVETYPE_WALK; // Allow velocity
						self.mashattack = FALSE;
						self.char.think = player_attacka1;
						self.char.swing_count = 1;
						self.attack_finished = time + 0.5;
						self.combo_finished = time + 0.5;
					}
					else
					{
						oself = self;
						self = self.char;
						player_yell(0); // vigil yell
						self = oself;
						if (self.zoom_mode != 0 && self.camera_forcezoom_finished < time)
							self.zoom_mode = 0; // No Zoom
						self.swordshadow_time = time + 0.4; // sword shadow
						self.mashattack = FALSE; // clear on first swing always
						self.char.think = player_slash1;
						self.char.swing_count = 1;
						self.attack_finished = time + 0.5;
						self.combo_finished = time + 0.65;
					}
				}
				else
				{
					oself = self;
					self = self.char;
					player_yell(1); // vigil yell
					self = oself;
					if (self.zoom_mode != 0 && self.camera_forcezoom_finished < time)
						self.zoom_mode = 0; // No Zoom
					self.char.running = FALSE;
					self.shadow_time = time + 0.5;
					self.char.movetype = MOVETYPE_WALK;
					self.char.think = player_runatk1;
					self.char.nextthink = time;
					self.attack_finished = time + 0.8;
					self.noblock_finished = time + 0.8;
				}
			}
			else if (self.char.swing_count == 1)
			{
				if (self.keyflags & (KEY_LEFT | KEY_RIGHT))
				{
					oself = self;
					self = self.char;
					player_yell(0); // vigil yell
					self = oself;
					if (self.zoom_mode != 0 && self.camera_forcezoom_finished < time)
						self.zoom_mode = 0; // No Zoom
					self.char.think = player_attacka5;
					self.char.swing_count = 2;
					self.attack_finished = time + 1;
					self.combo_finished = time + 1;
					self.swordshadow_time = time + 0.3; // sword shadow
				}
				else
				{
					oself = self;
					self = self.char;
					player_yell(0); // vigil yell
					self = oself;
					if (self.zoom_mode != 0)
						self.zoom_mode = 0; // No Zoom
					self.swordshadow_time = time + 1; // sword shadow
					self.char.think = player_stabs1;
					self.char.swing_count = 2;
					self.attack_finished = time + 1;
					self.combo_finished = time + 1.2;
				}
			}
			else if (self.char.swing_count == 2)
			{
				if (self.keyflags & (KEY_LEFT | KEY_RIGHT))
				{
					oself = self;
					self = self.char;
					player_yell(0); // vigil yell
					self = oself;
					if (self.zoom_mode != 0 && self.camera_forcezoom_finished < time)
						self.zoom_mode = 0; // No Zoom
					self.char.swing_count = 0;
					self.swordshadow_time = time + 0.8; // sword shadow
					self.char.think = player_attacka10;
					self.attack_finished = time + 0.8;
					self.combo_finished = time + 0.8;
					self.noblock_finished = time + 0.8;

				}
				else
				{
					oself = self;
					self = self.char;
					self = oself;
					if (self.zoom_mode != 0 && self.camera_forcezoom_finished < time)
						self.zoom_mode = 0; // No Zoom
					self.char.think = player_fstab1;
					self.char.swing_count = 0;
					self.attack_finished = time + 0.7;
					self.combo_finished = time + 0.7;
				}
			}
		}
		else // grab attacks here
		{
			if (self.char.grab_count == 0)
			{
				self.grab_finished = time + 1.5; // reset break out timer
				self.char.think = player_grabatk1;
				self.attack_finished = time + 0.5;
				self.char.grab_count = 1;
			}
			else if (self.char.grab_count == 1)
			{
				self.grab_finished = time + 1.5; // reset break out timer
				self.char.think = player_grabatk5;
				self.attack_finished = time + 0.7;
				self.char.grab_count = 2;
			}
			else if (self.char.grab_count == 2)
			{
				self.grab_finished = time + 1.5; // reset break out timer
				self.char.think = player_grabatk11;
				self.attack_finished = time + 1.1;
				self.char.grab_count = 0;
			}
			self.char.movetype = MOVETYPE_WALK; // Remove Vigils MOVETYPE_NONE/TOSS; fix
		}
	}
	else if (self.pain_finished < time) // in air
	{
		if (self.wallgrab == FALSE)
		{
			if (self.keyflags & KEY_DOWN && self.char.inair > 15 && (self.char.frame != $airkick15 && self.char.frame != $airkick16 && self.char.frame != $airkick17))
			{
				if ((relics & IT_RELIC3 || deathmatch) && (self.char.aircombo_count == 4 || self.char.frame == $djump))
				{
					oself = self;
					self = self.char;
					player_yell(1);
					self = oself;
					self.char.aircombo_count = 6; // Deal more damage on headsmash
					self.noblock_finished = time + 999;
					self.swordshadow_time = time + 1; // sword shadow
					self.char.think = player_jatkspecial1;
				}
				else
				{
					oself = self;
					self = self.char;
					player_yell(1);
					self = oself;
					self.char.aircombo_count = 5; // Normal head smash
					sound (self.char, CHAN_WEAPON, "player/fast.wav", 1, ATTN_NORM);
					self.char.think = player_jumpatk1;
					self.noblock_finished = time + 999;
					if (self.char.velocity_z > -250)
						self.char.velocity_z = self.char.velocity_z - 250;
				}
				self.attack_finished = time + 999;
				self.aircombo_finished = time + 999;
			}
			else if (self.keyflags & KEY_UP)
			{
				if (!self.char.flypain && self.char.aircombo_count != 4 && self.backflip_finished < time && (relics & IT_RELIC2 || deathmatch == TRUE) && self.char.inair > 15)
				{
					self.char.aircombo_count = 4; // special, also stops foreground/background (Y) movement
					self.attack_finished = time + 0.55;
					self.softshadow_time = time + 0.6;
					self.aircombo_finished = time + 0.3;
					self.char.inair = 0; // remove inair
					self.char.bigfall = FALSE; // and big fall
					// remove possible situational cam shake
					self.char.fstab_cnt = 0;
					self.char.ftspin_count = 0;
					self.char.runatk_speed = 0;
					self.char.sword_spincnt = 0;
					//
					if (self.doublejump == TRUE)
					{
						if (self.char.velocity_z > 0)
							self.char.velocity_z = 0;
						self.char.velocity_y = 0;
						self.char.think = player_airuppercut1;
						if (!relics & IT_RELIC3) // Remove delay off Uppercut when you possess battle relic
							self.char.nextthink = time + 0.3;
						else
							self.char.nextthink = time;
						self.char.frame = $uppercut1; // force into frame
						self.char.takedamage = DAMAGE_NO; // i-frame
					}
					else
						self.char.think = player_airuppercut1;
				}
			}

			if (self.aircombo_finished > time) // Air combo / attacks
			{
				self.mashattack = TRUE;
				return;
			}
			else			
			{
				if (self.backflip_finished < time)
				{
					if (self.char.aircombo_count < 3) // Don't yell during triple air kick
					{
						oself = self;
						self = self.char;
						player_yell(0);
						self = oself;
					}
					if (self.zoom_mode != 0 && self.camera_forcezoom_finished < time)
							self.zoom_mode = 0; // No Zoom
					if (self.char.aircombo_count == 0)
					{
						self.char.inair = 33; // Fix silly animation issue
						self.char.aircombo_count = 1;
						self.aircombo_finished = time + 0.15;
						self.char.think = player_jumpatkb1;
					}
					else if (self.char.aircombo_count == 1)
					{
						self.char.aircombo_count = 2;
						self.aircombo_finished = time + 0.17;
						self.char.think = player_jumpatkb2;
					}
					// allow Vigil's jumpatkb2 frame to play before starting 3rd aircombo hit
					else if (self.char.aircombo_count == 2 && self.char.frame != $jumpatkb2)
					{
						self.char.aircombo_count = 3;
						self.char.think = player_jumpatkb4;
						self.aircombo_finished = time + 0.3;
					}
					else if (self.char.aircombo_count == 3)
					{
						self.char.aircombo_count = 5;
						self.softshadow_time = time + 0.35;
						self.aircombo_finished = time + 0.4;
						self.char.think = player_airkick1;
					}
					else if (self.char.aircombo_count == 5)
					{
						self.char.aircombo_count = 6;
						self.softshadow_time = time + 0.35;
						self.aircombo_finished = time + 0.4;
						self.char.think = player_airkick7;
					}
					else if (self.char.aircombo_count == 6)
					{
						self.char.aircombo_count = 7;
						self.softshadow_time = time + 0.35;
						self.aircombo_finished = time + 0.4;
						self.char.think = player_airkick11;
					}
					else if (self.char.aircombo_count == 7)
					{
						self.char.aircombo_count = 7;
						self.softshadow_time = time + 0.35;
						self.aircombo_finished = time + 999;
						self.char.think = player_airkick13;
					}
					//
					// 7 is reserved!!
					//
				}
			}
		}
	}
};

void() player_bigfall1	=[	$pain2,	player_move	]
{
	local entity effect;
	
	makevectors (self.angles);

	effect = spawn();
	setorigin(effect, self.origin - v_up * 18);
	setmodel(effect, "progs/dust.spr");	
	effect.solid = SOLID_NOT;
	effect.owner = self;
	effect.drawonlytoclient = self.owner; // reduce network traffic
	effect.movetype = MOVETYPE_NOCLIP;
		
	effect.think = dust_think;
	effect.nextthink = time + 0.01;

	PainSound();
	self.nextthink = time + 0.5;
};

void() player_grab1	=[	$grab1,	player_grab2	] 
{
	self.grabbed = TRUE;
	self.owner.grab_finished = time + 1.5; // set how long before vigil breaks out of grabbing
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_STEP;
};

void() player_grab2	=[	$grab2,	player_grab2	] 
{
	if (self.perfectguard_buff < time) // fixes perfect guard -> grab into invunerability glitch
		self.takedamage = DAMAGE_AIM;

	self.grabbed = TRUE;
	self.velocity_x = self.velocity_y = 0;
	self.movetype = MOVETYPE_STEP;

	// Fix for movement
	if (self.enemy.flags & FL_MONSTER)
		self.enemy.owner = self;

	// look in the grabbed enemies direction
	if (self.origin_x < self.enemy.origin_x)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	if (self.enemy.health < 1 || self.inair > 24 || self.owner.grab_finished < time || (self.owner.button2 && self.owner.nojump_finished < time))
	{
		self.grabbed = FALSE;
		self.enemy.grabbed = FALSE;
		self.movetype = MOVETYPE_WALK;
		player_move();
	}
	UnmakeSolidList();
};

// hit over head with hilt
void() player_grabatk1	=[	$grabatk1,	player_grabatk2	] {player_yell(0);};
void() player_grabatk2	=[	$grabatk2,	player_grabatk3	] {};
void() player_grabatk3	=[	$grabatk3,	player_grabatk4	] {frameskip(0.15);};
void() player_grabatk4	=[	$grabatk4,	player_grab2	] 
{
	sound (self, CHAN_BODY, "player/motion2.wav", 1, ATTN_NORM);
	FireMelee(12,10,0,30,3,0,1,TRUE,0,0);
	// Cancel punch-combo on already dead enemy
	if (self.enemy.health < 1)
	{
		self.grabbed = FALSE;
		self.enemy.grabbed = FALSE;
		self.movetype = MOVETYPE_WALK;
		player_move();
	}
	frameskip(0.05);
};

// double punch
void() player_grabatk5	=[	$grabatk5,	player_grabatk6	] {};
void() player_grabatk6	=[	$grabatk6,	player_grabatk7	] {player_yell(0);frameskip(0.15);};
void() player_grabatk7	=[	$grabatk7,	player_grabatk8	] {sound (self, CHAN_BODY, "player/motion2.wav", 1, ATTN_NORM);FireMelee(8,10,0,30,3,0,1,TRUE,0,0);frameskip(0.05);};
void() player_grabatk8	=[	$grabatk5,	player_grabatk9	] 
{
	// Cancel second punch on already dead enemy
	if (self.enemy.health < 1)
	{
		self.grabbed = FALSE;
		self.enemy.grabbed = FALSE;
		self.movetype = MOVETYPE_WALK;
		player_move();
	}
};
void() player_grabatk9	=[	$grabatk6,	player_grabatk10 ] {frameskip(0.15);};
void() player_grabatk10	=[	$grabatk7,	player_grab2	] {sound (self, CHAN_BODY, "player/motion2.wav", 1, ATTN_NORM);FireMelee(8,10,0,30,3,0,1,TRUE,0,0);frameskip(0.05);};

// double round house kick
void() player_grabatk11	=[	$grabatk8,	player_grabatk12	] 
{
	player_yell(0);
	self.owner.noblock_finished = time + 1; // don't allow block
	self.takedamage = DAMAGE_NO;
};
void() player_grabatk12	=[	$grabatk9,	player_grabatk13	] 		
{     // lift off here
	self.velocity = '0 0 0';
	self.velocity_z = 200;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
}; 	
void() player_grabatk13	=[	$grabatk10,	player_grabatk14	] {player_yell(0);};
void() player_grabatk14	=[	$grabatk11,	player_grabatk15	] 
{
	if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
	{
		if (freeze_finished < time) // don't interefere with level up/etc
			freeze_finished = time + (CONST_BIGHITSLOW * frametime);
	}
	sound (self, CHAN_BODY, "player/motion1.wav", 1, ATTN_NORM);
	FireMelee(18,10,0,40,1,0,1,TRUE,0,0);
};
void() player_grabatk15	=[	$grabatk12,	player_grabatk16	] 
{
	if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
	{
		if (freeze_finished < time) // don't interefere with level up/etc
			freeze_finished = time + (CONST_BIGHITSLOW * frametime);
	}
	sound (self, CHAN_BODY, "player/motion2.wav", 1, ATTN_NORM);
	FireMelee(1,10,3,40,4,0,1,TRUE,0,0);
};

void() player_grabatk17;
void() player_grabatk16	=[	$grabatk12,	player_grabatk16	] {if (self.flags & FL_ONGROUND)player_grabatk17();self.grabbed = FALSE;};

void() player_grabatk17	=[	$grabatk13,	player_grabatk18	] {frameskip (0.5);};
void() player_grabatk18	=[	$grabatk14,	player_move		] {self.takedamage = DAMAGE_AIM;};

// forward flip to get up
void() forwardflip_move =
{
	// Get out of turning angles
	if (self.angles_y == 45 || self.angles_y == -45)
		self.angles_y = 0;
	if (self.angles_y == 225 || self.angles_y == -225)
		self.angles_y = 180;
	self.velocity = '0 0 0';
	self.velocity_z = 220;

	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() player_fflip4;
void() player_fflip1	=[	$fflip1,	player_fflip2	] {self.angles_x = 0;};
void() player_fflip2	=[	$fflip2,	player_fflip3	] {};
void() player_fflip3	=[	$fflip3,	player_fflip4	] {self.nextthink = time + 0.2;};
void() player_fflip4	=[	$fflip4,	player_fflip5	] {forwardflip_move();player_yell(0);sound (self, CHAN_AUTO, "player/jump.wav", 1, ATTN_NORM);};
void() player_fflip5	=[	$fflip5,	player_fflip6	] {};
void() player_fflip6	=[	$fflip6,	player_fflip7	] {};
void() player_fflip7	=[	$fflip7,	player_fflip8	] {};
void() player_fflip8	=[	$fflip8,	player_fflip8	] 
{
	self.flypain = FALSE;
	self.pain_finished = self.fly_time = time; // allow blocking etc
	if (self.onground == TRUE || checkground(self) || self.velocity_z > 0) // Fixes animation jump button press before onground is done
		player_move();
};

void() backflip_move =
{
	// Get out of turning angles
	if (self.angles_y == 45 || self.angles_y == -45)
		self.angles_y = 0;
	if (self.angles_y == 225 || self.angles_y == -225)
		self.angles_y = 180;
	self.velocity = '0 0 0';
	self.velocity_z = self.velocity_z + 150;
	if (self.angles_y == 0 || self.angles_y == 360)
		self.velocity_x = -85;
	else
		self.velocity_x = 85;
};

void() player_bflip1	=[	$bflip1,	player_bflip2	] 
{
	self.movetype = MOVETYPE_WALK;
	self.takedamage = DAMAGE_NO;
	self.angles_z = self.angles_x = 0;
	self.owner.softshadow_time = time + 0.3;
	backflip_move();
	player_yell(0);
};
void() player_bflip2	=[	$bflip2,	player_bflip3	] 
{
	backflip_move();
	sound (self, CHAN_AUTO, "player/motion2.wav", 1, ATTN_NORM);
};
void() player_bflip3	=[	$bflip3,	player_bflip4	] {backflip_move();};
void() player_bflip4	=[	$bflip4,	player_move		] {sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);};

// player casted a spell without full mana requirements and is now tired
void() tired_check =
{
	if (self.owner.zoom_mode != 1 && self.owner.camera_forcezoom_finished < time)
		self.owner.zoom_mode = 1; // Zoom in
	if (self.tired_finished < time)
	{
		player_move();
		self.owner.attack_finished = time;
		self.attack_finished = time; // just in case...
	}
};

void() player_tired1	=[	$tired1,	player_tired1	] 
{
	if (self.perfectguard_buff < time) // reset from firebeam + tired
		self.takedamage = DAMAGE_AIM;
	if (self.walkframe > 4) // animation
		self.walkframe = 0;
	if (self.attack_finished < time)
	{
		sound (self, CHAN_VOICE, "player/breath.wav", 1, ATTN_NORM);
		self.attack_finished = time + 1;
	}

	self.frame = $tired1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	tired_check();
};

void() player_counter_move =
{
	local vector source, dest;
	local float test;

	makevectors(self.angles);
	source = self.origin;

	dest = self.origin + v_forward * (self.speed / 3); // 40 quake units ahead
	tracebox (dest + v_up*24, VEC_HULL_MIN, VEC_HULL_MAX, dest - v_up*24, 1, self); // 24 units z check

	self.velocity_time = time + 0.1; // allow velocity movement
	if (self.angles_y == 0)
	{
		if (trace_fraction == 1) // Hit nothing
			test = 1; // Failed.
		else
		{
			self.movetype = MOVETYPE_WALK;
			test = 0; // pass
		}
		
		if (test == 0)
		{
			self.velocity_x = self.speed / 1.2;
			droptofloor();
		}
		else
		{
			self.velocity_time = time; // disallow velocity movement
			self.velocity_x = 0;
		}
	}
	else if (self.angles_y == 180)
	{
		if (trace_fraction == 1) // Hit nothing
			test = 1; // Failed.
		else
		{
			self.movetype = MOVETYPE_WALK;
			test = 0; // pass
		}
		
		if (test == 0)
		{
			self.velocity_x = 0 - (self.speed / 1.2);
			droptofloor();
		}
		else
		{
			self.velocity_time = time; // disallow velocity movement
			self.velocity_x = 0;
		}	
	}
};

void() player_counter1	=[	$counter1,	player_counter2	] 
{
	// Face enemy direction properly first
	if (self.enemy)
	{
		if (self.enemy.classname == "Boss2Melee")
			self.angles_y = 180;
		else
		{
			if (self.origin_x < self.enemy.origin_x)
				self.angles_y = 0;
			else
				self.angles_y = 180;
		}
	}

	player_yell(1);
	player_counter_move();
	frameskip(0.05);
};
void() player_counter2	=[	$counter2,	player_counter3	] {frameskip(0.05);player_counter_move();};
void() player_counter3	=[	$counter3,	player_counter4	] {frameskip(0.05);player_counter_move();};
void() player_counter4	=[	$counter4,	player_counter5	] {frameskip(0.05);sound (self, CHAN_AUTO, "player/motion2.wav", 1, ATTN_NORM);player_counter_move();};
void() player_counter5	=[	$counter5,	player_counter6	] {frameskip(0.05);player_counter_move();};
void() player_counter6	=[	$counter6,	player_counter7	] {frameskip(0.05);player_counter_move();};
void() player_counter7	=[	$counter7,	player_counter8	] 
{
	frameskip(0.05);
	self.attack_type = 5; // Cut/gored/sliced in half!
	FireMelee(15,15,1,55,5,0,TRUE,TRUE,0,0);
	if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
	{
		if (freeze_finished < time) // don't interefere with level up/etc
			freeze_finished = time + (CONST_BIGHITSLOW * frametime);
	}

	sound (self, CHAN_WEAPON, "player/sword.wav", 1, ATTN_NORM);
};
void() player_counter8	=[	$counter8,	player_counter9		] {frameskip(0.05);};
void() player_counter9	=[	$counter9,	player_counter10	] {frameskip(0.05);};
void() player_counter10	=[	$counter10,	player_move 		] {frameskip(0.2);};

.vector rel_height;
void() spinattack_particle_think =
{
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	if (self.oldorigin)
		self.rel_height_z = self.rel_height_z + (self.origin_z - self.oldorigin_z);
	setorigin(self, self.owner.origin + self.rel_height - v_up * 32);
	self.oldorigin = self.origin;
	self.velocity_z = 150;
	makevectors(self.angles);
	particle(self.origin + v_forward * 50, '0 0 0', 12, 25);
	frameskip(0.05);
};

void() spinattack =
{
	local entity head, effect;

	head = searchradius(self.origin, 60);
	while (head)
	{
		if (head.takedamage && head != self && head.spin_finished < time && visible(head)
		&& ((coop == TRUE && head.classname != "player" && self.classname == "player") || (coop == FALSE || self.flags & FL_MONSTER))) // coop
		{
			if (head.th_pain || head.takedamage)
			{
				head.paincount = 0;
				head.velocity = '0 0 0';
				head.spin_finished = time + 0.2;

				if (self.owner.mana >= 15)
				{
					// spawn a hit sprite
					effect = spawn();
					setorigin(effect, head.origin + v_up*22);
					setmodel(effect, "progs/jhit.spr");
					effect.movetype = MOVETYPE_NOCLIP;
					effect.think = fx_think;
					effect.effects = EF_NODEPTHTEST;
					effect.nextthink = time;
					effect.solid = SOLID_NOT;
					self.owner.camshake_finished = time + 0.2;
					self.owner.combo = self.owner.combo + 1; // raise combo counter

					if (head.noblood == FALSE) // extra blood thrown
					{
						ThrowBloodSplat(head.origin, head);
						ThrowBloodSplat(head.origin, head);
					}
					
					sound (self, CHAN_WEAPON, "player/bigcut.wav", 1, ATTN_NORM);

					if (head.health > 0)
						self.owner.mana = self.owner.mana - 15;
					if (self.frame >= $spin8) // full blow back
						head.knockback = 3;
					else
						head.knockback = 0;
					head.damage_type = 5; // cut in half

					local float damg_calc = 25 + ceil(self.owner.swordlevel * 7.5);

					if (deathmatch == FALSE)
						T_Damage (head, self, self, damg_calc, 0);
					else
						T_Damage (head, self, self, 25 / 3.5, 0);
					
					if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
					{
						if (freeze_finished < time) // don't interefere with level up/etc
							freeze_finished = time + (CONST_BIGHITSLOW * frametime);
					}

					head.damage_type = 0; // reset damage type now
				}
				else if (self.owner.mana > 0)
				{
					// spawn a hit sprite
					effect = spawn();
					setorigin(effect, head.origin + v_up*22);
					setmodel(effect, "progs/jhit.spr");
					effect.movetype = MOVETYPE_NOCLIP;
					effect.think = fx_think;
					effect.effects = EF_NODEPTHTEST;
					effect.nextthink = time;
					effect.solid = SOLID_NOT;

					self.owner.combo = self.owner.combo + 1; // raise combo counter

					if (head.noblood == FALSE) // extra blood thrown
					{
						ThrowBloodSplat(head.origin, head);
						ThrowBloodSplat(head.origin, head);
					}

					if (self.frame >= $spin8) // minor blow back
						head.knockback = 1;
					else
						head.knockback = 0;

					sound (self, CHAN_WEAPON, "player/swordhit.wav", 1, ATTN_NORM);
					if (deathmatch == FALSE)
						T_Damage (head, self, self, self.owner.mana + 5,0);
					else
						T_Damage (head, self, self, self.owner.mana + 5 / 3.5, 0);

					self.owner.mana = 0;
				}

				if (self.spin_finished == FALSE)
					self.spin_finished = TRUE;
			}
		}
		head = head.chain;
	}

	if (self.onground == FALSE)
	{
		// slowly move the player in the direction they were facing in the air
		if (self.angles_y == 0) // facing left
			self.velocity_x = self.speed;
		else //if (self.angles_y == 180)
			self.velocity_x = 0 - (self.speed);
		self.velocity_z = self.velocity_z / 0.5 * frametime; // Spin attack in mid air causes slower descent to the ground
		self.aircombo_count = 0;
	}
	self.owner.swordshadow_time = time + 1;
};

void() spinattack_particle = // white particles to spin around vigil
{
	local entity parti;

	parti = spawn();
	parti.owner = self;
	parti.movetype = MOVETYPE_NOCLIP;
	parti.solid = SOLID_NOT;
	setorigin(parti, self.origin);
	setorigin (parti, self.origin - v_up * 32);
	parti.avelocity = '0 500 0';
	setmodel (parti, "progs/twisti.spr");
	parti.angles_y = random()*360;
	parti.attack_finished = time + 0.5;
	parti.drawonlytoclient = self.owner.owner; // reduce network traffic
	parti.think = spinattack_particle_think;
	parti.nextthink = time;
};

void() player_spinatk1	=[	$spin1,	player_spinatk2	] {frameskip(0.08);sound (self, CHAN_VOICE, "player/spinatk.wav", 1, ATTN_NORM);spinattack_particle();};
void() player_spinatk2	=[	$spin2,	player_spinatk3	] {frameskip(0.08);spinattack();};
void() player_spinatk3	=[	$spin3,	player_spinatk4	] {frameskip(0.08);};
void() player_spinatk4	=[	$spin4,	player_spinatk5	] {frameskip(0.08);spinattack();spinattack_particle();};
void() player_spinatk5	=[	$spin5,	player_spinatk6	] {frameskip(0.08);};
void() player_spinatk6	=[	$spin6,	player_spinatk7	] {frameskip(0.08);spinattack();};
void() player_spinatk7	=[	$spin7,	player_spinatk8	] {frameskip(0.08);spinattack_particle();};
void() player_spinatk8	=[	$spin8,	player_spinatk9	] {frameskip(0.08);spinattack();};
void() player_spinatk9	=[	$spin9,	player_spinatk10	] {frameskip(0.08);};
void() player_spinatk10	=[	$spin10,	player_move 	] {frameskip(0.08);spinattack();spinattack_particle();};

void() player_kickforward =
{
	self.velocity_time = time + 0.2;
	if (self.angles_y == 0)
		self.velocity_x = self.speed / 1.25;
	else if (self.angles_y == 180)
		self.velocity_x = 0 - (self.speed) / 1.25;
};

void() player_kick1	=[	$kick1,	player_kick2	] 
{
	sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);
	if (self.onground == TRUE)
		self.velocity_z = 250;
	else
	{
		if (self.velocity_z < 105)
			self.velocity_z = 105;
	}
	player_kickforward();
	player_yell(0);
	LegShadow();
};
void() player_kick2	=[	$kick2,	player_kick3	] 
{
	LegShadow();
	FireMelee(10,15,3,25,4,0,1,FALSE,0,0);
	player_kickforward();
	frameskip(0.15);
};
void() player_kick3	=[	$kick3,	player_kick4	] 
{
	LegShadow();
	player_kickforward();
	if (self.onground == TRUE)
		player_move();
};
void() player_kick4	=[	$kick4,	player_kick5 	] 
{
	player_kickforward();
	if (self.onground == TRUE)
		player_move();
};
void() player_kick5	=[	$kick5,	player_move 	] 
{
	player_kickforward();
	frameskip(0.15);
	player_kickforward();
	if (self.perform_flyingswallow == TRUE)
	{
		// Face enemy direction properly first
		if (self.enemy)
		{
			if (self.origin_x < self.enemy.origin_x)
				self.angles_y = 0;
			else
				self.angles_y = 180;
		}
		player_yell(1);
		self.velocity = '0 0 0';
		self.movetype = MOVETYPE_FLY; // Hold position mid-air
		self.think = player_airdivings1;
		self.nextthink = time + 0.2;
	}
	if (self.onground == TRUE)
		player_move();
};

// Running Attack
void() runattack_forward = // push player forward during animation
{
	local entity effect;

	makevectors(self.angles);

	self.movetype = MOVETYPE_WALK;
	if (self.onground == TRUE)
	{
		if (random() < 0.5)
		{
			effect = spawn();
			setorigin(effect, self.origin - v_up*16 - v_forward * 24); // back foot
			setmodel(effect, "progs/dust.spr");
			effect.solid = SOLID_NOT;
			effect.owner = self;
			effect.drawonlytoclient = self.owner.owner; // reduce network traffic
			effect.movetype = MOVETYPE_FLY;
			effect.velocity_z = 100;
			effect.think = dust_think;
			effect.nextthink = time + 0.01;
		}
		else
		{
			effect = spawn();
			setorigin(effect, self.origin - v_up*16 + v_forward * 4); // front foot
			setmodel(effect, "progs/dust.spr");
			effect.solid = SOLID_NOT;
			effect.owner = self;
			effect.drawonlytoclient = self.owner.owner; // reduce network traffic
			effect.movetype = MOVETYPE_FLY;
			effect.velocity_z = 100;
			effect.think = dust_think;
			effect.nextthink = time + 0.01;
		}
	}
	self.velocity_time = time + 0.2;
	self.runatk_speed = self.runatk_speed + 70;
	self.owner.speedline_time = time + 0.1;
	model_tilt();

	// slowly move the player in the direction they were facing in the air
	if (self.angles_y == 0) // facing left
	{
		self.velocity_x = self.speed * 4 - self.runatk_speed;
		self.angles_y = 0;
	}
	else if (self.angles_y == 180)
	{
		self.velocity_x = 0 - (self.speed * 4) + self.runatk_speed;
		self.angles_y = 180;
	}
	self.velocity_y = 0; // no foreground or background movement
};

void() player_runatk1	=[	$runatk1,	player_runatk2	] {sound (self, CHAN_BODY, "player/skid.wav", 1, ATTN_NORM);runattack_forward();};
void() player_runatk2	=[	$runatk2,	player_runatk3	] 
{
	runattack_forward();
	sound (self, CHAN_WEAPON, "player/sword3.wav", 1, ATTN_NORM);
	player_yell(1);
};
void() player_runatk3	=[	$runatk3,	player_runatk4	] {runattack_forward();};
void() player_runatk4	=[	$runatk4,	player_runatk5	] {runattack_forward();self.attack_type = 5;FireMelee(2,15,6,30,0,0,1,FALSE,0,0);};
void() player_runatk5	=[	$runatk5,	player_runatk6 	] {runattack_forward();self.attack_type = 5;FireMelee(4,15,6,30,0,0,1,FALSE,0,0);};
void() player_runatk6	=[	$runatk5,	player_runatk7 	] {runattack_forward();self.attack_type = 5;FireMelee(6,15,1,30,0,0,1,FALSE,0,0);};
void() player_runatk7	=[	$runatk5,	player_runatk8 	] 
{
	runattack_forward();
	self.attack_type = 5;
	FireMelee(8,15,3,30,5,1,1,FALSE,0,0);
	if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
	{
		if (freeze_finished < time) // don't interefere with level up/etc
			freeze_finished = time + (CONST_BIGHITSLOW * frametime);
	}
	// Modfied Jump - Short Hop
	if (self.owner.button2_buffer && self.onground == TRUE)
	{
		if (self.angles_y == 0)
			self.velocity_x = 200;
		else
			self.velocity_x = -200;

		if (self.movetype != MOVETYPE_WALK) // fix a potential ledge grab glitch that can RARELY but still happen
			self.movetype = MOVETYPE_WALK;
		self.owner.doublejump = FALSE;
		self.idle_count = 0; // reset pose
		self.lastpos = self.char.origin; // for bottomless pits
		self.owner.charge_count = 0; // disallow charge attack in air
		self.inair = 16;
		self.velocity_z = 325;
		self.frame = $jump1;
		self.think = player_move;
		self.nextthink = time;
		sound (self, CHAN_AUTO, "player/jump.wav", 1, ATTN_NORM);
	}
};
void() player_runatk8	=[	$runatk5,	player_move 	] {};

//
// Vigil Underwater Slash
//

void() player_waterslash1	=[	$slash1,	player_waterslash2	] {frameskip(0.1);};
void() player_waterslash2	=[	$slash2,	player_waterslash3	] {frameskip(0.1);};
void() player_waterslash3	=[	$slash3,	player_waterslash4	] {FireMelee(100,35,0,35,0,0,0,TRUE,0,0);frameskip(0.1);sound (self, CHAN_WEAPON, "player/sword4.wav", 1, ATTN_NORM);};
void() player_waterslash4	=[	$slash4,	player_waterslash5	] {frameskip(0.1);};
void() player_waterslash5	=[	$slash5,	player_waterslash6	] {frameskip(0.1);};
void() player_waterslash6	=[	$slash6,	player_waterslash7	] {frameskip(0.1);};
void() player_waterslash7	=[	$slash7,	player_move			] {frameskip(0.1);};

void() player_slash1	=[	$slash1,	player_slash2	] {frameskip(0.05);};
void() player_slash2	=[	$slash2,	player_slash3	] {frameskip(0.035);};
void() player_slash3	=[	$slash3,	player_slash4	] {FireMelee(2,35,0,35,0,0,0,FALSE,0,0);frameskip(0.035);sound (self, CHAN_WEAPON, "player/sword4.wav", 1, ATTN_NORM);};
void() player_slash4	=[	$slash4,	player_slash5	] {frameskip(0.035);};
void() player_slash5	=[	$slash5,	player_slash6	] {frameskip(0.035);};
void() player_slash6	=[	$slash6,	player_slash7	] {frameskip(0.035);};
void() player_slash7	=[	$slash7,	player_slash7	] 
{
	if (self.owner.mashattack == TRUE)
	{
		if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			self.swing_count = 2;
			self.think = player_attacka5;
			self.nextthink = time + 0.1;
			self.owner.attack_finished = time + 1;
			self.owner.combo_finished = time + 1;
			self.owner.swordshadow_time = time + 0.3; // sword shadow
		}
		else
		{
			self.swing_count = 2;
			self.think = player_stabs1;
			self.nextthink = time + 0.1;
			self.owner.mashattack = FALSE;
			self.owner.attack_finished = time + 1;
			self.owner.combo_finished = time + 1.2;
			self.owner.swordshadow_time = time + 1; // sword shadow
		}
		self.owner.mashattack = FALSE;
		return;
	}
	if (self.owner.combo_finished < time)
		player_move();
	frameskip(0.05);
};

void() player_stabs1b;
void() player_stabs6b;
void() player_stabs10b;

void() plyr_armstab_think =
{
	local entity effect, oself;

	if (self.owner.frame >= $stabs1 && self.owner.frame <= $stabs12)
	{
		makevectors (self.angles);
		setorigin(self, self.owner.origin - v_forward*2 - v_up*2); // Keep arm stab graphic on Vigil
		
		effect = spawn();
		setorigin(effect, self.origin + v_forward * 48); //- v_up*28 + v_forward * 48);
		setmodel(effect, "progs/dust.spr");

		if (self.angles_y == 0)
			effect.velocity_x = 1080;
		else
			effect.velocity_x = -1080;
	
		effect.solid = SOLID_NOT;
		effect.owner = self;
		effect.drawonlytoclient = self.owner.owner; // reduce network traffic
		effect.movetype = MOVETYPE_NOCLIP;
		effect.think = dust_think;
		effect.nextthink = time + 0.01;
		
		// Drop dust to the ground then half-way into the ground
		oself = self;
		self = effect;
		droptofloor();
		self.origin_z = self.origin_z - 20;
		self = oself;

		if (self.frame > 0)
			self.frame = self.frame - 1;
		else
		{
			self.cnt = self.cnt + 1;
			self.frame = 11;
			if (self.cnt > 1)
			{
				remove(self);
				return;
			}
		}
	}
	else
	{
		remove(self);
		return;
	}
	frameskip (0.02);
};

void() plyr_armstab =
{
	local entity effect;

	makevectors(self.angles);

	effect = spawn();
	setorigin(effect, self.origin - v_forward*2 - v_up*2);
	setmodel(effect, "progs/plyr_armstab.mdl");
	effect.solid = SOLID_NOT;
	effect.angles = self.angles;
	effect.avelocity = '-50 0 0';
	effect.effects = EF_ADDITIVE | EF_FULLBRIGHT;
	effect.alpha = 0.50;
	effect.owner = self;
	effect.movetype = MOVETYPE_NOCLIP;
	effect.frame = 11;
	effect.scale = 1.25;
	effect.drawonlytoclient = self.owner; // reduce network traffic
	effect.think = plyr_armstab_think;
	effect.nextthink = time;// + 0.1;
};

void() player_stabs1	=[	$stabs1,	player_stabs2	] {plyr_armstab();frameskip(0.02);};
void() player_stabs2	=[	$stabs2,	player_stabs3	] {frameskip(0.02);};
void() player_stabs3	=[	$stabs3,	player_stabs4	] {FireMelee(1,35,0,35,0,0,1,FALSE,0,0);sound (self, CHAN_WEAPON, "player/sword4.wav", 1, ATTN_NORM);};
void() player_stabs4	=[	$stabs4,	player_stabs5	] {frameskip(0.02);};
void() player_stabs5	=[	$stabs5,	player_stabs6	] {FireMelee(1,35,0,35,0,0,1,FALSE,0,0);frameskip(0.02);};
void() player_stabs6	=[	$stabs6,	player_stabs7	] {frameskip(0.02);};
void() player_stabs7	=[	$stabs7,	player_stabs8	] {FireMelee(1,35,0,35,0,0,1,FALSE,0,0);sound (self, CHAN_WEAPON, "player/sword4.wav", 1, ATTN_NORM);};
void() player_stabs8	=[	$stabs8,	player_stabs9	] {frameskip(0.02);};
void() player_stabs9	=[	$stabs9,	player_stabs10	] {FireMelee(1,35,0,35,0,0,1,FALSE,0,0);frameskip(0.02);};
void() player_stabs10	=[	$stabs10,	player_stabs11	] {frameskip(0.02);};
void() player_stabs11	=[	$stabs11,	player_stabs12	] {FireMelee(1,35,0,35,0,0,1,FALSE,0,0);sound (self, CHAN_WEAPON, "player/sword4.wav", 1, ATTN_NORM);};
void() player_stabs12	=[	$stabs12,	player_stabs12	] 
{
	if (self.owner.mashattack == TRUE)
	{
		self.swing_count = 1;
		self.think = player_stabs1b;
		self.nextthink = time + 0.1;
		self.owner.attack_finished = time + 0.3;
		self.owner.combo_finished = time + 0.3;
		self.owner.mashattack = FALSE;
	}
	else
	{
		if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			self.swing_count = 0;
			self.think = player_attacka10;
			self.nextthink = time + 0.1;
			self.owner.mashattack = FALSE;
			self.owner.attack_finished = time + 0.8;
			self.owner.combo_finished = time + 0.8;
			self.owner.swordshadow_time = time + 0.8; // sword shadow
		}
		else
		{
			self.swing_count = 0;
			self.think = player_fstab1;
			self.nextthink = time + 0.1;
			self.owner.attack_finished = time + 0.7;
			self.owner.combo_finished = time + 0.7;
		}
	}
	frameskip(0.02);
};

void() player_stabs1b	=[	$stabs1,	player_stabs2b	] {plyr_armstab();frameskip(0.02);FireMelee(1,35,0,35,0,0,1,FALSE,0,0);};
void() player_stabs2b	=[	$stabs2,	player_stabs3b	] {frameskip(0.02);};
void() player_stabs3b	=[	$stabs3,	player_stabs4b	] {FireMelee(1,35,0,35,0,0,1,FALSE,0,0);sound (self, CHAN_WEAPON, "player/sword4.wav", 1, ATTN_NORM);};
void() player_stabs4b	=[	$stabs4,	player_stabs5b	] {frameskip(0.02);};
void() player_stabs5b	=[	$stabs5,	player_stabs5b	] 
{
	if (self.owner.mashattack == TRUE)
	{
		self.swing_count = 1;
		self.think = player_stabs6b;
		self.nextthink = time + 0.1;
		self.owner.attack_finished = time + 0.3;
		self.owner.combo_finished = time + 0.3;
		self.owner.mashattack = FALSE;
	}
	else
	{
		if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			self.swing_count = 0;
			self.think = player_attacka10;
			self.nextthink = time + 0.1;
			self.owner.mashattack = FALSE;
			self.owner.attack_finished = time + 0.8;
			self.owner.combo_finished = time + 0.8;
			self.owner.swordshadow_time = time + 0.8; // sword shadow
		}
		else
		{
			self.swing_count = 0;
			self.think = player_fstab1;
			self.nextthink = time + 0.1;
			self.owner.attack_finished = time + 0.7;
			self.owner.combo_finished = time + 0.7;
		}
	}
	frameskip(0.02);
};
void() player_stabs6b	=[	$stabs6,	player_stabs7b	] {frameskip(0.02);FireMelee(1,35,0,35,0,0,1,FALSE,0,0);};
void() player_stabs7b	=[	$stabs7,	player_stabs8b	] {sound (self, CHAN_WEAPON, "player/sword4.wav", 1, ATTN_NORM);};
void() player_stabs8b	=[	$stabs8,	player_stabs9b	] {frameskip(0.02);FireMelee(1,35,0,35,0,0,1,FALSE,0,0);};
void() player_stabs9b	=[	$stabs9,	player_stabs9b	] 
{
	if (self.owner.mashattack == TRUE)
	{
		self.swing_count = 1;
		self.think = player_stabs10b;
		self.nextthink = time + 0.1;
		self.owner.attack_finished = time + 0.3;
		self.owner.combo_finished = time + 0.3;
		self.owner.mashattack = FALSE;
	}
	else
	{
		if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			self.swing_count = 0;
			self.think = player_attacka10;
			self.nextthink = time + 0.1;
			self.owner.mashattack = FALSE;
			self.owner.attack_finished = time + 0.8;
			self.owner.combo_finished = time + 0.8;
			self.owner.swordshadow_time = time + 0.8; // sword shadow
		}
		else
		{
			self.swing_count = 0;
			self.think = player_fstab1;
			self.nextthink = time + 0.1;
			self.owner.attack_finished = time + 0.7;
			self.owner.combo_finished = time + 0.7;
		}
	}
	frameskip(0.02);
};
void() player_stabs10b	=[	$stabs10,	player_stabs11b	] {frameskip(0.02);};
void() player_stabs11b	=[	$stabs11,	player_stabs12b	] {FireMelee(1,35,0,35,0,0,1,FALSE,0,0);sound (self, CHAN_WEAPON, "player/sword4.wav", 1, ATTN_NORM);};
void() player_stabs12b	=[	$stabs12,	player_stabs12b	] 
{
	if (self.owner.mashattack == TRUE)
	{
		if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			self.swing_count = 0;
			self.think = player_attacka10;
			self.nextthink = time + 0.1;
			self.owner.mashattack = FALSE;
			self.owner.attack_finished = time + 0.8;
			self.owner.combo_finished = time + 0.8;
			self.owner.swordshadow_time = time + 0.8; // sword shadow
		}
		else
		{
			self.swing_count = 0;
			self.think = player_fstab1;
			self.nextthink = time + 0.1;
			self.owner.attack_finished = time + 0.7;
			self.owner.combo_finished = time + 0.7;
		}
		self.owner.mashattack = FALSE;
		return;
	}
	else
	{
		self.swing_count = 0;
		self.think = player_fstab1;
		self.nextthink = time + 0.1;
		self.owner.attack_finished = time + 0.7;
		self.owner.combo_finished = time + 0.7;
	}
};

void() swordstareffect3;
void() player_fstab4;

void() player_fstab1	=[	$fstab1,	player_fstab2	]
{
	if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
	{
		if (self.owner.keyflags & KEY_LEFT)
			self.angles_y = 0;
		else
			self.angles_y = 180;
	}
	frameskip(0.15);
	player_yell(1);
};
void() player_fstab2	=[	$fstab2,	player_fstab3	] {frameskip(0.03);};
void() player_fstab3	=[	$fstab3,	player_fstab3	] 
{
	local entity effect;
	
	makevectors (self.angles);

	effect = spawn();
	setorigin(effect, self.origin - v_up*28);
	setmodel(effect, "progs/dust.spr");	
	effect.solid = SOLID_NOT;
	effect.owner = self;
	effect.drawonlytoclient = self.owner; // reduce network traffic
	effect.movetype = MOVETYPE_NOCLIP;
	effect.think = dust_think;
	effect.nextthink = time + 0.01;
	
	if (self.fstab_cnt == 5) // Do it once
	{
		if (!deathmatch)
			FireMelee(10,35,3,35,5,1,1,FALSE,0,0);
		else
			FireMelee(10,35,6,35,5,1,1,FALSE,0,0); // Don't guard break in deathmatch on first hit
		if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
		{
			if (freeze_finished < time) // don't interefere with level up/etc
				freeze_finished = time + (CONST_BIGHITSLOW * frametime);
		}
		sound (self, CHAN_AUTO, "player/sword3.wav", 1, ATTN_NORM);
		sound (self, CHAN_BODY, "player/skid.wav", 1, ATTN_NORM);
	}

	if (self.fstab_cnt >= 25) // and twice...
	{
		FireMelee(10,35,3,35,5,1,1,FALSE,0,0);
		if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
		{
			if (freeze_finished < time) // don't interefere with level up/etc
				freeze_finished = time + (CONST_BIGHITSLOW * frametime);
		}
		self.fstab_cnt = 0;
		self.think = player_fstab4;
		self.nextthink = time + 0.2;
		return;
	}
	else
		self.fstab_cnt = self.fstab_cnt + 1;

	self.owner.shadow_time = time + 0.1;

	local vector source, dest;
	local float test;

	makevectors(self.angles);
	source = self.origin;

	dest = self.origin + v_forward * (self.speed / 3); // 40 quake units ahead
	tracebox (dest + v_up*24, VEC_HULL_MIN, VEC_HULL_MAX, dest - v_up*24, 1, self); // 24 units z check

	self.velocity_time = time + 0.1; // allow velocity movement
	if (self.angles_y == 0)
	{
		if (trace_fraction == 1) // Hit nothing
			test = 1; // Failed.
		else
		{
			self.movetype = MOVETYPE_WALK;
			test = 0; // pass
		}
		
		if (test == 0)
		{
			self.velocity_x = self.speed * 5.0 / 1.8;
			droptofloor();
		}
		else
		{
			self.velocity_time = time; // disallow velocity movement
			self.velocity_x = 0;
		}

		//walkmove (self.angles_y, 3.5);
	}
	else if (self.angles_y == 180)
	{
		if (trace_fraction == 1) // Hit nothing
			test = 1; // Failed.
		else
		{
			self.movetype = MOVETYPE_WALK;
			test = 0; // pass
		}
		
		if (test == 0)
		{
			self.velocity_x = 0 - (self.speed * 5.0 / 1.8);
			droptofloor();
		}
		else
		{
			self.velocity_time = time; // disallow velocity movement
			self.velocity_x = 0;
		}	
		//walkmove (self.angles_y, 3.5);
	}

	self.owner.speedline_time = time + 0.1;

	frameskip(0.01);
};

void() player_fstab4	=[	$fstab4,	player_fstab5	] {frameskip(0.05);};
void() player_fstab5	=[	$fstab5,	player_fstab6	] {frameskip(0.05);};
void() player_fstab6	=[	$fstab6,	player_fstab7	] {frameskip(0.05);};
void() player_fstab7	=[	$fstab7,	player_move	] {frameskip(0.05);};

void() player_attacka1	=[	$attacka1,	player_attacka2	] 
{
	self.movetype = MOVETYPE_WALK; // Allow velocity
	frameskip(0.05);
	player_yell(0);
};

void() player_attacka2	=[	$attacka2,	player_attacka3	] 
{
	frameskip(0.05);
};

void() player_attacka3	=[	$attacka3,	player_attacka4	] 
{
	local entity effect;
	
	makevectors (self.angles);

	effect = spawn();
	setorigin(effect, self.origin - v_up * 22);
	setmodel(effect, "progs/dust.spr");	
	effect.solid = SOLID_NOT;
	effect.owner = self;
	effect.drawonlytoclient = self.owner; // reduce network traffic
	effect.movetype = MOVETYPE_NOCLIP;
		if (self.angles_y == 0)
		effect.velocity_x = 500;
	else
		effect.velocity_x = -500;
		
	effect.think = dust_think;
	effect.nextthink = time + 0.01;

	sound (self, CHAN_WEAPON, "player/sword.wav", 1, ATTN_NORM);
	sound (self, CHAN_BODY, "player/skid.wav", 1, ATTN_NORM);
	FireMelee(5,35,6,35,0,0,1,FALSE,0,0);

	self.velocity_time = time + 0.1;
	if (self.angles_y == 0)
		self.velocity_x = self.speed * 5.0 / 1.8;
	else if (self.angles_y == 180)
		self.velocity_x = 0 - (self.speed * 5.0 / 1.8);

	frameskip(0.05);
};

void() player_attacka4	=[	$attacka4,	player_attacka4	]
{
	if (self.owner.mashattack == TRUE)
	{
		if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			self.think = player_attacka5;
			self.nextthink = time + 0.15;
			self.owner.mashattack = FALSE;
			self.owner.attack_finished = time + 0.8;
			self.owner.combo_finished = time + 0.8;
			self.owner.swordshadow_time = time + 0.3; // sword shadow
		}
		else
		{
			self.swing_count = 2;
			self.think = player_stabs1;
			self.nextthink = time + 0.1;
			self.owner.attack_finished = time + 1;
			self.owner.combo_finished = time + 1.2;
			self.owner.swordshadow_time = time + 1; // sword shadow
			
		}
		self.owner.mashattack = FALSE;
		return;
	}
	if (self.owner.combo_finished < time)
	{
		player_move();
		self.velocity_time = time;
	}
	frameskip(0.08);
};

void() player_attacka5	=[	$attacka5,	player_attacka6	] 
{
	if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
	{
		if (self.owner.keyflags & KEY_LEFT)
			self.angles_y = 0;
		else
			self.angles_y = 180;
	}
	
	frameskip(0.07);
};

void() player_attacka6	=[	$attacka6,	player_attacka7	] 
{
	FireMelee(2,30,6,25,0,0,1,FALSE,0,0);

	if (self.onground == TRUE) // Only add/set onground
	{
		local entity effect;
	
		makevectors (self.angles);

		effect = spawn();
		setorigin(effect, self.origin - v_up * 22);
		setmodel(effect, "progs/dust.spr");	
		effect.solid = SOLID_NOT;
		effect.owner = self;
		effect.drawonlytoclient = self.owner; // reduce network traffic
		effect.movetype = MOVETYPE_NOCLIP;
		if (self.angles_y == 0)
			effect.velocity_x = 500;
		else
			effect.velocity_x = -500;
		
		effect.think = dust_think;
		effect.nextthink = time + 0.01;
	
		self.velocity_z = 100;
		self.velocity_time = time + 0.1;
		if (self.angles_y == 0)
			self.velocity_x = self.speed * 3.0 / 1.8;
		else if (self.angles_y == 180)
			self.velocity_x = 0 - (self.speed * 3.0 / 1.8);
	}
	sound (self, CHAN_AUTO, "player/jump.wav", 1, ATTN_NORM);
	sound (self, CHAN_WEAPON, "player/sword3.wav", 1, ATTN_NORM);
};

void() player_attacka7	=[	$attacka7,	player_attacka8	] 
{
	// Hit all around
	FireMelee(1,0,4,60,0,0,1,FALSE,0,0);
	frameskip(0.07);
};

void() player_attacka8	=[	$attacka8,	player_attacka9	] 
{
	// Hit all around
	FireMelee(1,0,6,60,0,0,1,FALSE,0,0);
	frameskip(0.07);
};

void() swordstareffect;
void() player_attacka9  =[	$attacka9,	player_attacka9b ]
{
	sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);
	sound (self, CHAN_WEAPON, "player/sword2.wav", 1, ATTN_NORM);
	swordstareffect();
	player_yell(0);
	FireMelee(5,30,6,25,0,0,1,FALSE,0,0);
	frameskip(0.05);
};

void() player_attacka9b	=[	$attacka9,	player_attacka9b ] 
{
	if (self.movetype != MOVETYPE_WALK) // Allow Velocity Fix
		self.movetype = MOVETYPE_WALK;
	if (self.owner.mashattack == TRUE)
	{
		if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			self.think = player_attacka10;
			self.nextthink = time + 0.15;
			self.owner.mashattack = FALSE;
			self.owner.attack_finished = time + 0.8;
			self.owner.combo_finished = time + 0.8;
			self.owner.noblock_finished = time + 0.8;
			self.owner.swordshadow_time = time + 0.8; // sword shadow
		}
		else
		{
			self.swing_count = 0;
			self.think = player_fstab1;
			self.nextthink = time + 0.1;
			self.owner.attack_finished = time + 0.7;
			self.owner.combo_finished = time + 0.7;
		}
		self.owner.mashattack = FALSE;
		return;
	}
	if (self.owner.combo_finished < time)
		player_move();
	frameskip(0.02);
};

.vector oangles;
void() spinpush =
{
	local entity effect;
	
	makevectors (self.angles);

	effect = spawn();
	setorigin(effect, self.origin - v_up*28);
	setmodel(effect, "progs/dust.spr");	
	effect.solid = SOLID_NOT;
	effect.owner = self;
	effect.movetype = MOVETYPE_NOCLIP;
	effect.think = dust_think;
	effect.nextthink = time + 0.01;
		
	if (self.movetype != MOVETYPE_WALK) // Allow Velocity Fix
		self.movetype = MOVETYPE_WALK;
	self.velocity_time = time + 0.1;
	if (self.oangles_y == 0)
		self.velocity_x = self.speed * 1.5 / 1.8;
	else if (self.oangles_y == 180)
		self.velocity_x = 0 - (self.speed * 1.5 / 1.8);
};

void() player_attacka10	=[	$attacka10,	player_attacka11	] 
{
	if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
	{
		if (self.owner.keyflags & KEY_LEFT)
			self.angles_y = 0;
		else
			self.angles_y = 180;
	}
	frameskip(0.07);
	self.oangles = self.angles;
};

void() player_attacka11	=[	$attacka11,	player_attacka12	] {frameskip(0.07);spinpush();};
void() player_attacka12	=[	$attacka12,	player_attacka13	] 
{
	if (self.owner.mashattack != FALSE) // QOL issue
		self.owner.mashattack = FALSE;  // Allows user to spam attack key and safely end the combo if wanted
	frameskip(0.07);
	spinpush();
	sound (self, CHAN_WEAPON, "player/sword.wav", 1, ATTN_NORM);
	player_yell(0);
	sound (self, CHAN_AUTO, "player/motion2.wav", 1, ATTN_NORM);
};

void() player_attacka14;
void() player_attacka15;
void() player_attacka17;
void() player_attacka13	=[	$attacka13,	player_attacka13	] 
{
	if (self.ftspin_count == 3)
		sound (self, CHAN_WEAPON, "player/sword3.wav", 1, ATTN_NORM);
	if (self.ftspin_count == 1 || self.ftspin_count == 4)
	{
		if (random() < 0.5)
			sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_AUTO, "player/motion2.wav", 1, ATTN_NORM);
	}
	if (self.ftspin_count < 5)
	{
		FireMelee(1,0,0,65,0,0,1,FALSE,0,0);
		self.angles_y = self.angles_y + 65;
		self.ftspin_count = self.ftspin_count + 1;
	}
	else
	{
		player_attacka14();
	}
	spinpush();
	frameskip (0.05);
};

void() player_attacka14	=[	$attacka14,	player_attacka15	]
{
	if (self.owner.mashattack == TRUE)
	{
		if (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			if (self.owner.keyflags & KEY_LEFT)
				self.angles_y = 0;
			else
				self.angles_y = 180;
		}

		self.think = player_attacka17;
		self.nextthink = time + 0.15;
		self.owner.mashattack = FALSE;
		self.owner.attack_finished = time + 0.4;
		self.owner.combo_finished = time + 0.4;
		self.angles = self.oangles;
		return;
	}
	else
	{
		self.attack_type = 5;
		self.angles = self.oangles; // FIXME: Set angle before firing Melee
		self.owner.shadow_time = time + 0.1; // red shadow
		FireMelee(8,0,3,65,5,1,1,FALSE,0,0); // to prevent monster from getting hit the wrong way
		if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
		{
			if (freeze_finished < time) // don't interefere with level up/etc
				freeze_finished = time + (CONST_BIGHITSLOW * frametime);
		}
		player_attacka15();
	}
	self.angles = self.oangles;
	self.ftspin_count = 0;
	spinpush();
};

void() player_attacka15	=[	$attacka15,	player_attacka16	]  
{
	sound (self, CHAN_BODY, "player/skid.wav", 1, ATTN_NORM);
};

void() player_attacka16	=[	$attacka16,	player_attacka16	]  
{
	if (self.owner.combo_finished < time)
	{
		self.angles = self.oangles;
		player_move();
	}
	local entity effect, oself;
	
	makevectors (self.angles);

	effect = spawn();
	setorigin(effect, self.origin + v_forward * 44);
	setmodel(effect, "progs/dust.spr");	
	effect.solid = SOLID_NOT;
	effect.owner = self;
	effect.drawonlytoclient = self.owner; // reduce network traffic
	effect.movetype = MOVETYPE_NOCLIP;
	
	// Drop dust to the ground then half-way into the ground
	oself = self;
	self = effect;
	droptofloor();
	self.origin_z = self.origin_z - 20;
	self = oself;
		
	if (self.angles_y == 0)
		effect.velocity_x = 500;
	else
		effect.velocity_x = -500;
		
	effect.think = dust_think;
	effect.nextthink = time + 0.01;
};

void() player_attacka17	=[	$attacka17,	player_attacka18	] {};
void() player_attacka18	=[	$attacka18,	player_attacka19	] 
{
	sound (self, CHAN_WEAPON, "player/sword.wav", 1, ATTN_NORM);
	FireMelee(5,30,0,25,0,0,1,FALSE,0,0);
};
void() player_attacka19	=[	$attacka19,	player_attacka19	] 
{
	if (self.owner.combo_finished < time)
		player_move();
};

void() swordstareffect_think =
{
	if (self.cnt < time)
	{
		if (self.frame < 3)
			self.frame = self.frame + 1;
		else
		{
			remove(self);
			return;
		}
		self.cnt = time + 0.1;
	}
	frameskip(0.01);
};

void() swordstareffect =
{
	local entity effect;

	makevectors(self.angles);

	effect = spawn();
	setorigin(effect, self.origin + v_forward * 34 + v_up*7);
	setmodel(effect, "progs/star2.spr");
	effect.solid = SOLID_NOT;
	if (self.angles_y == 0)
		effect.velocity_x = 80;
	else
		effect.velocity_x = -80;
	effect.avelocity = '0 0 2000';
	effect.effects = EF_ADDITIVE | EF_FULLBRIGHT;
	effect.alpha = 0.9;
	effect.owner = self;
	effect.drawonlytoclient = self.owner.owner; // reduce network traffic
	effect.angles_y = -90; // face screen
	effect.movetype = MOVETYPE_NOCLIP;
	effect.think = swordstareffect_think;
	effect.nextthink = time + 0.1;
};

void() swordstareffect3_think =
{
	if (self.frame < 3)
		self.frame = self.frame + 1;
	else
	{
		remove(self);
		return;
	}
	frameskip(0.1);
};

void() swordstareffect3 =
{
	local entity effect;

	makevectors(self.angles);

	effect = spawn();
	setorigin(effect, self.origin + v_forward * 54 + v_up * 25);
	setmodel(effect, "progs/star.spr");
	effect.solid = SOLID_NOT;
	effect.owner = self;
	effect.drawonlytoclient = self.owner.owner; // reduce network traffic
	effect.movetype = MOVETYPE_NOCLIP;
	effect.think = swordstareffect3_think;
	effect.nextthink = time + 0.1;
};


// Vigil's air launcher
void() dashattack_forward = // push player forward during animation
{
	self.movetype = MOVETYPE_WALK;
	self.velocity_time = time + 0.3;
	self.velocity_y = 0; // no foreground or background movement

	if (self.angles_y == 0)
		self.velocity_x = self.speed * 1.8 / 1.8;
	else if (self.angles_y == 180)
		self.velocity_x = 0 - (self.speed * 1.8 / 1.8);
};

void() player_dashatk1	=[	$dashatk1,	player_dashatk2	] {frameskip(0.07);dashattack_forward();};
void() player_dashatk2	=[	$dashatk2,	player_dashatk3	] {frameskip(0.07);dashattack_forward();};
void() player_dashatk3	=[	$dashatk3,	player_dashatk4	] {frameskip(0.07);dashattack_forward();sound (self, CHAN_WEAPON, "player/sword3.wav", 1, ATTN_NORM);};
void() player_dashatk4	=[	$dashatk4,	player_dashatk5	] {frameskip(0.07);dashattack_forward();self.attack_type = 5;FireMelee(10,25,2,30,2,0,1,FALSE,0,0);};
void() player_dashatk5	=[	$dashatk5,	player_dashatk6	] {frameskip(0.07);dashattack_forward();self.attack_type = 5;FireMelee(10,25,2,30,2,0,1,FALSE,0,0);};
void() player_dashatk6	=[	$dashatk6,	player_move 	] {frameskip(0.07);dashattack_forward();self.attack_type = 5;FireMelee(10,25,2,30,2,0,1,FALSE,0,0);};

//*
// charge up attack
//*
void() player_chargeatk4;
void() player_chargeatk5;

void() player_chargeatkmovement =
{
	self.movetype = MOVETYPE_WALK;
	self.velocity = '0 0 0';
	self.velocity_z = 250;
	if (self.angles_y == 0)
		self.velocity_x = self.speed * 1;
	else if (self.angles_y == 180)
		self.velocity_x = 0 - (self.speed * 1);
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;

};

void() player_chargeatk1	=[	$charge5,	player_chargeatk2	] 
{
	self.takedamage = DAMAGE_NO; // I-Frames
	sound (self, CHAN_AUTO, "player/jump.wav", 1, ATTN_NORM);
	self.noblock_finished = time + 999;
	self.owner.swordshadow_time = time + 0.5; // sword shadow
	player_yell(2);
	player_chargeatkmovement();
	frameskip(0.05);
};
void() player_chargeatk2	=[	$charge6,	player_chargeatk3	] {frameskip(0.05);};

void() player_chargeatk3	=[	$charge7,	player_chargeatk3	]
{
	if (self.chargespincnt < 46)
	{
		if (self.chargespincnt == 0 || self.chargespincnt == 20 || self.chargespincnt == 40)
			sound (self, CHAN_WEAPON, "player/twoosh.wav", 1, ATTN_NORM);

		if (self.chargespincnt == 3 || self.chargespincnt == 12 || self.chargespincnt == 25 || self.chargespincnt == 35)
		{
			self.attack_type = 5;
			FireMelee(9,0,0,60,5,0,1,FALSE,0,0); // Hit all around
		}
		self.angles_x = self.angles_x - 15; // spin Vigil
		self.chargespincnt = self.chargespincnt + 1;
	}
	else
	{
		self.angles_x = 0;
		player_chargeatk4();
	}
	self.owner.shadow_time = time + 0.5; // red shadow
	frameskip(0.01);
};

void() player_chargeatk4	=[	$charge8,	player_chargeatk4	] 
{
	if (self.swimming)
	{
		self.angles_x = 0;
		self.owner.attack_finished = time;
		self.chargespincnt = 0;
		self.noblock_finished = time;
		player_move();
	}

	if (self.onground == TRUE || self.flags & FL_ONGROUND)
		player_chargeatk5();
};
void() player_chargeatk5	=[	$charge9,	player_chargeatk5	] 
{
	// Hard hit
	self.attack_type = 5;
	FireMelee(22,30,6,30,2,1,1,TRUE,0,0);
	self.chargespincnt = 0;
	self.takedamage = DAMAGE_AIM; // I-Frames off
	if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
	{
		if (freeze_finished < time) // don't interefere with level up/etc
			freeze_finished = time + (CONST_BIGHITSLOW * frametime);
	}

	if (self.owner.mashattack == TRUE)
	{
		self.think = player_attacka17;
		self.nextthink = time + 0.15;
		self.owner.mashattack = FALSE;
		self.owner.attack_finished = time + 0.4;
		self.owner.combo_finished = time + 0.4;
		return;
	}
	else
	{
		self.think = player_move;
		self.nextthink = time + 0.3;
	}
};


//*
// jump attack
//*


//
// special animation for comboing into headsmash
//

void() player_jumpatk1;
void() jatk_particle_think =
{
	particle (self.origin, '0 0 0', 111, 6); // yellow particles

	if (self.attack_finished < time)
		remove(self);

	frameskip(0.05);
};

void() jatk_particle =
{
	local entity spark;

	spark = spawn ();
	spark.angles_y = random() * 360;
	makevectors (spark.angles);
	spark.velocity = v_forward * 100;
	spark.velocity_z = 150;
	spark.owner = self;
	spark.movetype = MOVETYPE_FLY;
	spark.solid = SOLID_NOT;
	spark.classname = "spark";
	setmodel (spark, string_null);
	setsize (spark, '0 0 0', '0 0 0');
	makevectors (self.angles);
	setorigin (spark, self.origin - v_up * 32);
	spark.attack_finished = time + 0.2;
	spark.drawonlytoclient = self.owner.owner; // reduce network traffic
				
	spark.think = jatk_particle_think;
	spark.nextthink = time + 0.1;
};

void() jatkspecial_muzzle_think =
{
	// remove headsmash graphical flaming / particle effect
	if (self.owner.frame != $jatkspc7 && self.owner.frame != $jumpatk1 && self.owner.frame != $jumpatk2)
	{
		remove(self);
		return;
	}

	makevectors(self.owner.angles);
	setorigin(self, self.owner.origin - v_up * 36 + v_forward * 10);
	
	// We use drawonlytoclientnow
	if (!coop && !deathmatch)
		jatk_particle();
	
	self.avelocity = '0 1000 0';
	frameskip(0.01);
};

void() jatkspecial_muzzle =
{
	local entity s;

	makevectors(self.angles);

	s = spawn();
	s.owner = self;
	setorigin(s, self.origin - v_up * 30 + v_forward * 10);
	setmodel(s, "progs/jatkspc.mdl");
	setsize (s, '0 0 0', '0 0 0');
	s.movetype = MOVETYPE_FLY;
	s.alpha = 0.7;
	s.effects = EF_ADDITIVE | EF_FULLBRIGHT;
	s.solid = SOLID_NOT;
	s.think = jatkspecial_muzzle_think;
	s.nextthink = time + 0.1;
};

void() jatkspecial =
{
	self.velocity = '0 0 0';
	if (self.angles_y == 0)
		self.velocity_x = self.speed / 2;
	else if (self.angles_y == 180)
		self.velocity_x = 0 - (self.speed / 2);
	self.velocity_z = self.velocity_z + 200;
};

void() player_jatkspecial1	=[	$jatkspc1,	player_jatkspecial2	] {jatkspecial();frameskip(0.06);FireMelee(3,15,0,35,0,0,1,FALSE,0,0);sound (self, CHAN_ITEM, "player/swrdspin.wav", 1, ATTN_NORM);};
void() player_jatkspecial2	=[	$jatkspc2,	player_jatkspecial3	] {jatkspecial();frameskip(0.06);FireMelee(3,15,0,35,0,0,1,FALSE,0,0);}
void() player_jatkspecial3	=[	$jatkspc3,	player_jatkspecial4	] {jatkspecial();frameskip(0.06);FireMelee(3,15,0,35,0,0,1,FALSE,0,0);};
void() player_jatkspecial4	=[	$jatkspc4,	player_jatkspecial5	] {jatkspecial();frameskip(0.06);FireMelee(3,15,0,35,0,0,1,FALSE,0,0);};
void() player_jatkspecial5	=[	$jatkspc5,	player_jatkspecial6	] {jatkspecial();frameskip(0.06);};
void() player_jatkspecial6	=[	$jatkspc6,	player_jatkspecial7	] {jatkspecial();frameskip(0.06);};
void() player_jatkspecial7	=[	$jatkspc7,	player_jumpatk2		]
{
	self.velocity = '0 0 0';
	if (self.velocity_z > -500)
		self.velocity_z = self.velocity_z - 500;
	player_yell(1);
	sound (self, CHAN_BODY, "player/fast.wav", 1, ATTN_NORM);
	jatkspecial_muzzle();
	frameskip(0.15);
};

void() jumpatk_grounded =
{
	local entity effect;

	effect = spawn();
	setorigin(effect, self.origin);
	setmodel(effect, "progs/grounded.mdl");
	effect.solid = SOLID_NOT;
	setsize (effect, '-21 -21 -16', '22 23 31');
	effect.movetype = MOVETYPE_FLY;
	effect.think = effect_think;
	effect.alpha = 0.8;
	effect.effects = EF_ADDITIVE | EF_FULLBRIGHT;
	effect.nextthink = time + 0.1;
};

void() player_hsblked	=[	$hsblked1,	player_hsblked	] 
{
	local vector view;

	view = vectoangles(self.enemy.origin - self.origin);
	self.angles_y = view_y;
	self.fixangle = TRUE;

	if (self.onground == TRUE)
	{
		if (self.angles_y > 90 && self.angles_y < 270)
			self.angles_y = 180;
		else
			self.angles_y = 0;

		player_move();
		return;
	}
	frameskip(0.01);
};

//
// Function is used for testy checking to see if the players z origin
// changed and if it hasn't bail them out of the headsmash attacks
//
void() player_jumpatk3;
void() hsmash_testzcheck =
{
	local entity oself;

	if (self.owner)
	{
		if (self.owner.origin_z == self.origin_z && self.owner.onground == FALSE)
		{
			oself = self;
			self = self.owner;

			jumpatk_grounded();
			player_jumpatk3();
			self.owner.camshake_finished = time + 0.2;
			sound (self, CHAN_WEAPON, "player/jmpflor.wav", 1, ATTN_NORM);
			self.aircombo_count = 0;
			self = oself;
		}
	}
	remove(self);
	return;
};

void() player_jumpatk1	=[	$jumpatk1,	player_jumpatk2	] {frameskip(0.05);self.velocity_y = 0;};
void() player_jumpatk2	=[	$jumpatk2,	player_jumpatk2	] 
{
	local entity head, effect, fx;
	local vector no = '0 0 0';
	local vector h;

	self.owner.speedline_time = time + 0.1; // speedline

	if (self.aircombo_count == 6) // add a tad of forward velocity
	{
		if (self.angles_y == 0)
			self.velocity_x = self.speed / 1.2;
		else if (self.angles_y == 180)
			self.velocity_x = 0 - (self.speed / 1.2);
	}

	MakeSolidList();
	head = searchradius(self.origin - v_up*20, 50); // 50 radius hit box on head smash
	while (head)
	{
		if (head.takedamage && head.nopain_time < time && head != self && visible(head)
		&& ((coop == TRUE && head.classname != "player" && self.classname == "player") || (coop == FALSE || self.flags & FL_MONSTER))) // coop
		{
			if (head.block_finished < time || head.dodge_finished > time || self.perfectguard_buff > time)
			{
				if (self.aircombo_count == 6) // cover enemy in explosion sprite
				{
					effect = spawn();
					if (head.solid != SOLID_BSP)
						setorigin(effect, head.origin);
					else
					{
						h = head.absmin + ((head.absmax - head.absmin) * 0.5);
						setorigin(effect, h);
					}
					setmodel(effect, "progs/explode1.mdl");
					effect.movetype = MOVETYPE_NOCLIP;
					effect.think = explodemodel_think;
					effect.effects = EF_NODEPTHTEST | EF_FULLBRIGHT | EF_ADDITIVE;
					effect.nextthink = time;
					effect.alpha = 1;
					effect.solid = SOLID_NOT;
					sound (self, CHAN_BODY, "spells/fhit.wav", 1, ATTN_NORM);

					fx = spawn(); // special flash
					if (head.solid != SOLID_BSP)
						setorigin(fx, head.origin);
					else
					{
						h = head.absmin + ((head.absmax - head.absmin) * 0.5);
						setorigin(fx, h);
					}
					setmodel(fx, "progs/efxflash.mdl");
					fx.movetype = MOVETYPE_NOCLIP;
					fx.alpha = fx.scale = 1;
					fx.effects = EF_NODEPTHTEST | EF_FULLBRIGHT | EF_ADDITIVE;
					fx.think = efxflashe_think;
					fx.nextthink = time;
					fx.solid = SOLID_NOT;
				}
				else
				{
					// spawn a hit sprite
					effect = spawn();
					if (head.solid != SOLID_BSP)
						setorigin(effect, head.origin + v_up*22);
					else
					{
						h = head.absmin + ((head.absmax - head.absmin) * 0.5);
						setorigin(effect, h);
					}
					setmodel(effect, "progs/jhit.spr");
					effect.movetype = MOVETYPE_NOCLIP;
					effect.think = fx_think;
					effect.effects = EF_NODEPTHTEST;
					effect.nextthink = time;
					effect.solid = SOLID_NOT;
					sound (self, CHAN_AUTO, "player/jmphit.wav", 1, ATTN_NORM);
				}
				self.owner.camshake_finished = time + 0.2;
			}
			else if (self.aircombo_count != 6 || deathmatch == TRUE) // Only regular headsmash is blockable, both blockable in deathmatch
			{
				// spawn a block sprite
				effect = spawn();
				setorigin(effect, head.origin);
				setmodel(effect, "progs/block.spr");
				effect.angles_y = -90;
				effect.angles_z = random()*360;
				effect.effects = EF_NODEPTHTEST;
				effect.movetype = MOVETYPE_NOCLIP;
				effect.think = fx_think;
				effect.nextthink = time;
				effect.solid = SOLID_NOT;

				// block
				if (head.classname == "player")
				{
					if (self.angles_y > 90 && self.angles_y < 270) // Attacker facing right
						head.angles_y = 0; // Block victim faces left
					else
						head.angles_y = 180; // Block victim faces right
					head.effects = EF_MUZZLEFLASH; // create light on melee impact
					head.think = player_block;
					head.nextthink = time;
					head.counter_finished = time + 0.5;
				}
				
				local float i;
				if (!coop && !deathmatch)
					self.block_sparks = 30;
				else
					self.block_sparks = 3; // multiplayer optimization
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
					spark.nextthink = time + 0.5 + 1.5*random();
					spark.think = sparks_fade1;
					spark.classname = "spark";

					if (random() < 0.33)
						spark.skin = 0;
					else if (random() < 0.5)
						spark.skin = 1;
					else
						spark.skin = 2;

					setsize (spark, '0 0 0', '0 0 0');
					i = i + 1;
				}
				
				self.velocity_z = 270; // popped back up
				sound (head, CHAN_BODY, "player/block.wav", 1, ATTN_NORM);

				self.enemy = head;
				player_hsblked(); // blocked headsmash frame
				return;
			}

			if (self.owner.zoom_mode != 1 && self.owner.camera_forcezoom_finished < time)
				self.owner.zoom_mode = 1; // Zoom in

			head.nopain_time = time + 0.6; // prevent double hits
			self.owner.combo = self.owner.combo + 1; // raise combo counter
			self.owner.screenflash_finished = time + 0.1;
				
			if (head.noblood == FALSE) // extra blood thrown
			{
				ThrowBloodSplat(head.origin, head);
				ThrowBloodSplat(head.origin, head);
				ThrowBloodSplat(head.origin, head);
				ThrowBloodSplat(head.origin, head);
			}

			if (self.aircombo_count == 6) // deal more damage if it's a fire headsmash
			{
				head.knockback = 5;
				self.attack_type = head.damage_type = 2; // fire damage
				if (deathmatch == TRUE) // damage in multiplayer is divided by 3
					T_Damage (head, self, self, 18, 0);
				else
				{
					local float damg_calc;
					damg_calc = 50;
					damg_calc = damg_calc + ceil(self.owner.swordlevel * 10);
					T_Damage (head, self, self, damg_calc, 0);
				}
				if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
				{
					if (freeze_finished < time) // don't interefere with level up/etc
					freeze_finished = time + (CONST_BIGHITSLOW * frametime);
				}
			}
			else
			{
				head.knockback = 3;
				self.attack_type = head.damage_type = 5; // gore em
				if (deathmatch == TRUE) // damage in multiplayer is divided by 3
					T_Damage (head, self, self, 10, 0);
				else
				{
					//local float damg_calc;
					damg_calc = 30;
					damg_calc = damg_calc + ceil(self.owner.swordlevel * 10);
					T_Damage (head, self, self, damg_calc, 0);
				}
				if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
				{
					if (freeze_finished < time) // don't interefere with level up/etc
						freeze_finished = time + (CONST_BIGHITSLOW * frametime);
				}
			}
			if (self.owner.mana < self.owner.max_mana)
				self.owner.mana = self.owner.mana + 3;
			if (self.owner.mana > self.owner.max_mana)
				self.owner.mana = self.owner.max_mana;
		}
		head = head.chain;
	}

	//
	// Check if his Z origin (up/down) moved
	//

	local entity testx, oself;
	local float cg;

	makevectors(self.angles);

	testx = spawn();
	testx.owner = self;
	testx.drawonlytoclient = self.owner.owner; // reduce network traffic
	testx.movetype = MOVETYPE_NOCLIP;
	testx.solid = SOLID_NOT;
	testx.think = hsmash_testzcheck;
	testx.nextthink = time + 0.03;
	setmodel(testx, string_null);
	setsize(testx, '0 0 0', '0 0 0');
	setorigin(testx, self.origin);

	if (self.onground == TRUE)
	{	
		makevectors (self.angles);

		effect = spawn();
		setorigin(effect, self.origin - v_up * 22);
		setmodel(effect, "progs/dust.spr");	
		effect.solid = SOLID_NOT;
		effect.owner = self;
		effect.drawonlytoclient = self.owner; // reduce network traffic
		effect.movetype = MOVETYPE_NOCLIP;
		
		effect.think = dust_think;
		effect.nextthink = time + 0.01;
	
		jumpatk_grounded();
		player_jumpatk3();
		self.owner.camshake_finished = time + 0.2;
		sound (self, CHAN_WEAPON, "player/jmpflor.wav", 1, ATTN_NORM);
	}
	if (self.swimming)
	{
		self.aircombo_count = 0;
		self.speedline_time = time;
		self.owner.shadow_time = time;
		player_move();
		self.owner.attack_finished = time;
		return;
	}
	UnmakeSolidList();
	self.velocity_y = 0;
	self.owner.shadow_time = time + 0.1;
};

void() player_jumpatk3	=[	$jumpatk3,	player_jumpatk4	] 
{
	self.speedline_time = time;
	model_tilt();
	self.headsmash_recovery_finished = time + 0.5; // tag AI to charge me
	self.nextthink = time + 0.5;
};

void() player_jumpatk4	=[	$pain2,	player_move	] 
{
	self.speedline_time = time;
	self.headsmash_recovery_finished = time + 0.3; // tag AI to charge me
	self.nextthink = time + 0.3;
};

void() airuppercut =
{
	FireMelee(7,8,0,40,5,0,0,FALSE,20,0);

	if (self.owner.walljump == TRUE)
   		self.owner.walljump = FALSE;

	self.velocity = '0 0 0';
	self.velocity_z = 150;

	// slowly move the player in the direction they were facing in the air
	if (self.angles_y == 0) // facing left
		self.velocity_x = self.speed * 1.5;
	else if (self.angles_y == 180)
		self.velocity_x = 0 - (self.speed * 1.5);
};

void() player_airuppercut1	=[	$uppercut1,	player_airuppercut2	]
{
	self.takedamage = DAMAGE_AIM; // Remove delayed versions I-Frames
	frameskip(0.05);
	player_yell(1);
};
void() player_airuppercut2	=[	$uppercut2,	player_airuppercut3	] {frameskip(0.05);sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);};
void() player_airuppercut3	=[	$uppercut3,	player_airuppercut4	] {airuppercut();}; // hit here
void() player_airuppercut4	=[	$uppercut3,	player_airuppercut5	] {airuppercut();}; // hit here
void() player_airuppercut5	=[	$uppercut3,	player_airuppercut6	] {airuppercut();}; // hit here
void() player_airuppercut6	=[	$uppercut4,	player_airuppercut7	] {self.velocity_x = 0;}; 
void() player_airuppercut7	=[	$uppercut5,	player_move			] {};

void() player_jumpatkb1	=[	$jumpatkb1,	player_move 	] {if (self.onground == TRUE) player_move();self.attack_type = 6;FireMelee(3,25,1,25,1,0,0,FALSE,24,0);sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);};
void() player_jumpatkb2	=[	$jumpatkb2,	player_jumpatkb3] {if (self.onground == TRUE) player_move();self.attack_type = 7;frameskip(0.08);};
void() player_jumpatkb3	=[	$jumpatkb3,	player_move 	] {if (self.onground == TRUE) player_move();FireMelee(3,25,1,25,1,0,0,FALSE,24,0);sound (self, CHAN_AUTO, "player/motion2.wav", 1, ATTN_NORM);};

void() player_jumpatkbb8;
void() player_jumpatkb4	=[	$jumpatkb4,	player_jumpatkb5 	] {if (self.onground == TRUE) player_move();frameskip(0.04);};
void() player_jumpatkb5	=[	$jumpatkb5,	player_jumpatkb6 	] {if (self.onground == TRUE) player_move();frameskip(0.04);};
void() player_jumpatkb6	=[	$jumpatkb6,	player_jumpatkb7 	] {if (self.onground == TRUE) player_move();frameskip(0.04);};
void() player_jumpatkb7	=[	$jumpatkb7,	player_jumpatkb8 	] {if (self.onground == TRUE) player_move();frameskip(0.04);};
void() player_jumpatkb8	=[	$jumpatkb8,	player_move		] 
{
	sound (self, CHAN_WEAPON, "player/sword.wav", 1, ATTN_NORM);
	FireMelee(10,25,1,30,5,0,0,FALSE,24,0);
	if (self.onground == TRUE)
	{
		player_move();
		return;
	}
	if (self.owner.mashattack == TRUE)
	{
		self.think = player_jumpatkbb8;
		self.nextthink = time;
		self.aircombo_count = 5;
		self.owner.aircombo_finished = time + 0.3;
		self.owner.mashattack = FALSE;
		return;
	}

};
void() player_jumpatkbb8	=[	$jumpatkb8,	player_airkick1		] {}

void() player_airkick6b;
void() player_airkick1		=[	$airkick1,	player_airkick2 	] {frameskip(0.06);sound (self, CHAN_VOICE, "player/yell2.wav", 1, ATTN_NORM);};
void() player_airkick2		=[	$airkick2,	player_airkick3 	] {frameskip(0.06);};
void() player_airkick3		=[	$airkick3,	player_airkick4 	] {frameskip(0.07);sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);};
void() player_airkick4		=[	$airkick4,	player_airkick5 	] {FireMelee(3,25,1,25,1,0,0,FALSE,24,0);frameskip(0.2);};
void() player_airkick5		=[	$airkick5,	player_airkick6 	] {frameskip(0.08);};
void() player_airkick6		=[	$airkick6,	player_airkick6 	] 
{
	if (self.onground == TRUE || self.swimming)
	{
		player_move();
		return;
	}
	if (self.owner.mashattack == TRUE)
	{
		self.think = player_airkick6b;
		self.nextthink = time;// + 0.1;
		self.aircombo_count = 6;
		self.owner.aircombo_finished = time + 0.3;
		self.owner.mashattack = FALSE;
		return;
	}
	frameskip(0.08);
};
void() player_airkick6b		=[	$airkick6,	player_airkick7 	] {frameskip(0.03);}

void() player_airkick10b;
void() player_airkick7		=[	$airkick7,	player_airkick8 	] {frameskip(0.1);sound (self, CHAN_VOICE, "player/yell2.wav", 1, ATTN_NORM);sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);};
void() player_airkick8		=[	$airkick8,	player_airkick9 	] {FireMelee(3,25,1,25,1,0,0,FALSE,24,0);frameskip(0.2);};
void() player_airkick9		=[	$airkick9,	player_airkick10 	] {frameskip(0.1);};
void() player_airkick10		=[	$airkick10,	player_airkick10	] 
{
	if (self.onground == TRUE || self.swimming)
	{
		player_move();
		return;
	}
	if (self.owner.mashattack == TRUE)
	{
		self.think = player_airkick10b;
		self.nextthink = time;// + 0.1;
		self.aircombo_count = 7;
		self.owner.aircombo_finished = time + 0.3;
		self.owner.mashattack = FALSE;
		return;
	}
	frameskip(0.1);
};
void() player_airkick10b		=[	$airkick10,	player_airkick11	] {frameskip(0.1);}

void() player_airkick12b;
void() player_airkick11		=[	$airkick11,	player_airkick12 	] {FireMelee(3,25,1,25,1,0,0,FALSE,24,0);sound (self, CHAN_VOICE, "player/yell2.wav", 1, ATTN_NORM);frameskip(0.2);sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);self.velocity_y = 0;};
void() player_airkick12		=[	$airkick12,	player_airkick12 	] 
{
	if (self.onground == TRUE || self.swimming)
	{
		player_move();
		return;
	}
	if (self.owner.mashattack == TRUE)
	{
		self.aircombo_count = 7;
		self.think = player_airkick12b;
		self.nextthink = time;// + 0.1;
		self.owner.aircombo_finished = time + 999;
		self.owner.mashattack = FALSE;
		return;
	}
	frameskip(0.1);
};
void() player_airkick12b	=[	$airkick12,	player_airkick13 	] {frameskip(0.05);}

void() player_airkick13		=[	$airkick13,	player_airkick14 	] {frameskip(0.1);sound (self, CHAN_VOICE, "player/yell1.wav", 1, ATTN_NORM);sound (self, CHAN_AUTO, "player/sword.wav", 1, ATTN_NORM);self.velocity_y = 0;};
void() player_airkick14		=[	$airkick14,	player_airkick15 	] {frameskip(0.1);};

void() windspiral_think =
{
	if (self.scale < 5)
		self.scale = self.scale + 0.1;
	if (self.alpha > 0)
		self.alpha = self.alpha - 0.015;
	else
	{
		remove(self);
		return;
	}
	self.angles_y = self.angles_y + 10;
	frameskip (0.01);
};

void() player_airkick15		=[	$airkick15,	player_airkick16 	] 
{
	local entity effect;
	
	makevectors (self.angles);

	effect = spawn();
	setorigin(effect, self.origin + v_forward * 32);
	setmodel(effect, "progs/windsprl.mdl");
	effect.angles_y = random()*360;
	effect.effects = EF_ADDITIVE | EF_FULLBRIGHT | EF_NODEPTHTEST;
	effect.movetype = MOVETYPE_NOCLIP;
	effect.classname = "windspiral_effect";
	effect.solid = SOLID_NOT;
	effect.owner = self;
	effect.alpha = 1;
	setsize (effect, '0 0 0', '0 0 0');

	effect.think = windspiral_think;
	effect.nextthink = time;
	sound (self, CHAN_AUTO, "player/woosh.wav", 1, ATTN_NORM);

	self.owner.camshake_finished = time + 0.2;
	self.owner.shadow_time = time + 0.05; // red shadow
	self.velocity = '0 0 0';
	self.velocity_z = self.velocity_z + 150;

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
		
	FireMelee(10,25,7,30,6,1,1,TRUE,24,0);

	if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
	{
		if (freeze_finished < time) // don't interefere with level up/etc
			freeze_finished = time + (CONST_BIGHITSLOW * frametime);
	}
	frameskip(0.2);
};
void() player_airkick16		=[	$airkick16,	player_airkick17 	] {};
void() player_airkick17		=[	$airkick17,	player_move	 	] {};

//*
// pain
//*

void() PainSound =
{
	local float		rs;

	rs = rint((random() * 3) + 1);

	self.noise = "";
	if (rs == 1)
		self.noise = "player/pain1.wav";
	else if (rs == 2)
		self.noise = "player/pain2.wav";
	else if (rs == 3)
		self.noise = "player/pain3.wav";
	else
		self.noise = "player/pain4.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	return;
};

void() player_knockedup1;
void() player_hit5;

void() player_hit1	=[	$pain1,	player_move	] 
{
	if (deathmatch == TRUE)
	{
		self.nextthink = time + 0.5;
		return;
	}
	self.movetype = MOVETYPE_STEP;
	self.velocity = '0 0 0';
	self.nextthink = time + 1;
};

void() player_hit2	=[	$pain2,	player_move	] 
{
	if (deathmatch == TRUE)
	{
		self.nextthink = time + 0.5;
		return;
	}
	self.movetype = MOVETYPE_STEP;
	self.velocity = '0 0 0';
	self.nextthink = time + 1;
};

void() player_hit3	=[	$pain3,	player_hit4	]
{
	self.angles_z = 0;
	self.nextthink = time + 0.3;
	if (!deathmatch)
		self.takedamage = DAMAGE_NO;
};

void() pain_testzcheck =
{
	local entity oself;

	if (self.owner)
	{
		if (self.owner.origin_x == self.origin_x && self.owner.onground == FALSE)
		{
			oself = self;
			self = self.owner;
			self.owner.camshake_finished = time + 0.2;
			PainSound();
			self.takedamage = DAMAGE_NO;
			player_hit5();
			
			self = oself;
		}
	}
	remove(self);
	return;
};

void() player_hit4	=[	$pain4,	player_hit4	]
{
	//
	// Check for walls for Vigil to smack into
	//

	self.angles_x = 0;
	makevectors (self.angles);
	
	// asdf: tracebox me?
	traceline(self.origin, self.origin - v_forward * 24, FALSE, self); // used to be 24 (prevent in-wall problem)
	//
	
	if (trace_fraction < 1 && trace_ent.solid == SOLID_BSP && !self.swimming)
	{
		self.owner.camshake_finished = time + 0.2;
		PainSound();
		self.takedamage = DAMAGE_NO;
		self.wallhit_count = 0;
		self.velocity = '0 0 0';
		player_walled2();
		return;
	}
	if (self.onground == TRUE)
	{
		self.owner.camshake_finished = time + 0.2;
		PainSound();
		self.takedamage = DAMAGE_NO;
		player_hit5();
	}

	//
	// Check if his Z origin (up/down) moved
	//

	local entity testz;

	makevectors(self.angles);

	testz = spawn();
	testz.owner = self;
	testz.drawonlytoclient = self.owner.owner; // reduce network traffic
	testz.movetype = MOVETYPE_NOCLIP;
	testz.solid = SOLID_NOT;
	testz.think = pain_testzcheck;
	testz.nextthink = time + 0.1;
	setmodel(testz, string_null); // debug return to string null
	setsize(testz, '0 0 0', '0 0 0');
	setorigin(testz, self.origin);
};

void() player_knockedup1    =[	$walled1,	player_knockedup1 ] 
{
	self.inair = self.bigfall = 0; // remove BIG FALL
	if (self.velocity_z > 0)
	{
		if (!self.swimming)
			self.angles_x = -90; // going up!
	}
	else
	{
		if (self.angles_x < 90)
		{
			if (!self.swimming)
				self.angles_x = self.angles_x + 6;
			else
				self.angles_x = self.angles_x + 2;
		}
	}
	if (self.swimming) // sink slower when hit than in normal air
		self.velocity_z = self.velocity_z / 1.05;
	
	if (self.onground == TRUE)
	{
		PainSound();
		sound (self, CHAN_BODY, "player/jmpflor.wav", 1, ATTN_NORM);
		self.angles_x = 0;
		player_hit4();
		return;
	}
	frameskip(0.01);
};

void() player_knockedfar1    =[	$walled1,	player_knockedfar1 ] 
{
	//
	// Check for walls for Vigil to smack into
	//
	local vector v;
	v = self.angles;
	v_x = 0;
	makevectors (v);

	// Change to TraceBox?
	traceline(self.origin, self.origin - v_forward * 24, FALSE, self); // used to be 17, upped to 32: prevent stuck in wall problem
	
	if (trace_fraction < 1 && trace_ent.solid == SOLID_BSP && !self.swimming)
	{
		PainSound();
		self.owner.camshake_finished = time + 0.2;
		self.wallhit_count = 0;
		self.takedamage = DAMAGE_NO;
		player_walled2();
		return;
	}

	if (self.velocity_z > 0)
		self.angles_x = -45;
	else
	{
		if (self.angles_x < 90)
			self.angles_x = self.angles_x + 3;
	}
	if (self.onground == TRUE)
	{
		PainSound();
		sound (self, CHAN_BODY, "player/jmpflor.wav", 1, ATTN_NORM);
		self.angles_x = 0;
		player_hit4();
		return;
	}
	frameskip(0.01);
};

void() player_walled3;
void() player_walled2    =[	$walled2,	player_walled2	] 
{
	if (self.wallhit_count >= 4)
	{
		self.movetype = MOVETYPE_WALK;
		makevectors (self.angles);
		self.velocity = aim(self, 35);
		self.velocity = self.velocity * 35;
		self.angles = vectoangles(self.velocity);
		player_walled3(); // falling at this point
		self.wallhit_count = 0;
		return;
	}
	else
	{
		self.owner.softshadow_time = time;
		self.angles_x = 0;
		self.angles_z = 0;
		self.velocity = '0 0 0';
		self.movetype = MOVETYPE_FLY;

		if (self.wallhit_count == 1)
			sound (self, CHAN_BODY, "player/jmpflor.wav", 1, ATTN_NORM);

		self.wallhit_count = self.wallhit_count + 1;
	}
	frameskip (0.1);
};

void() player_walled4 	 =[     $walled5,        player_getupb1 ]
{
	model_tilt();
	self.owner.softshadow_time = time;
	self.angles_z = 0;
	self.nextthink = time + 0.5;
};

void() player_walled3    =[	0,	player_walled3	] 
{
	// Tilt realistically
	if (self.angles_x > -90)
		self.angles_x = self.angles_x - 3;

	if (self.walkframe > 1)
		self.walkframe = 0;
	self.frame = $walled3 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	self.movetype = MOVETYPE_WALK;

	if (self.onground == TRUE && self.angles_x < -75) // face plant
	{
		self.owner.camshake_finished = time + 0.2;
		PainSound();
		self.takedamage = DAMAGE_NO;
		self.angles_x = self.angles_z = 0;
		player_walled4();
		sound (self, CHAN_BODY, "player/owhit.wav", 1, ATTN_NORM);
		self.velocity = '0 0 0';
		return;
	}
	frameskip(0.01);
};

void() twist_testxcheck =
{
	local entity oself;

	if (self.owner)
	{
		if (self.owner.origin_x == self.origin_x && self.owner.onground == FALSE)
		{
			oself = self;
			self = self.owner;
			
			PainSound();
			self.takedamage = DAMAGE_NO;
			if (random() < 0.5)
			{
				player_hit3();
				sound (self, CHAN_BODY, "player/jmpflor.wav", 1, ATTN_NORM);
			}
			else
			{
				// Fix angles to match animation!
				if (self.angles_y > 90 && self.angles_y < 270)
					self.angles_y = 0;
				else
					self.angles_y = 180;
				player_walled4();
				sound (self, CHAN_BODY, "player/owhit.wav", 1, ATTN_NORM);
				return;
			}
			self = oself;
		}
	}
	remove(self);
	return;
};

void() player_twist    =[	$twist,	player_twist		] 
{
	local vector v;

	//
	// Check for walls for Vigil to smack into
	//

	v = self.angles;	  //
	v_x = v_x + 25;       // Remove tilt on traceline!
	makevectors (v);	  //

	traceline(self.origin, self.origin - v_forward * 24, FALSE, self);
	if (trace_fraction < 1 && trace_ent.solid == SOLID_BSP && !self.swimming)
	{
		self.owner.camshake_finished = time + 0.2;
		self.velocity = '0 0 0';
		PainSound();
		self.takedamage = DAMAGE_NO;
		self.wallhit_count = 0;
		player_walled2();
		return;
	}
	
	if (self.velocity_z > 0)
		self.angles_x = -25;
	else
	{
		if (self.angles_x < 45)
			self.angles_x = self.angles_x + 1;
	}

	if (!self.swimming)
		self.angles_z = self.angles_z + 15; // spin Vigil
	else
		self.angles_z = self.angles_z + 8; // spin Vigil underwater
	
	//
	// Check if his X origin (left/right) moved
	//

	local entity testx;

	makevectors(self.angles);

	testx = spawn();
	testx.owner = self;
	testx.drawonlytoclient = self.owner.owner; // reduce network traffic
	testx.movetype = MOVETYPE_NOCLIP;
	testx.solid = SOLID_NOT;
	testx.think = twist_testxcheck;
	testx.nextthink = time + 0.1;
	setmodel(testx, string_null); // debug return to string null
	setsize(testx, '0 0 0', '0 0 0');
	setorigin(testx, self.origin);
	
	if (self.onground == TRUE)
	{
		self.velocity = '0 0 0';
		self.owner.camshake_finished = time + 0.2;
		PainSound();
		self.takedamage = DAMAGE_NO;
		if (random() < 0.5)
		{
			player_hit3();
			sound (self, CHAN_BODY, "player/jmpflor.wav", 1, ATTN_NORM);
		}
		else
		{
			// Fix angles to match animation!
			if (self.angles_y > 90 && self.angles_y < 270)
				self.angles_y = 0;
			else
				self.angles_y = 180;
			player_walled4();
			sound (self, CHAN_BODY, "player/owhit.wav", 1, ATTN_NORM);
			return;
		}
	}
	frameskip(0.01);
};

void() player_getup1	=[	$getup1,	player_getup2	] {self.angles_z = self.angles_x = 0;};
void() player_getup2	=[	$getup2,	player_getup3	] {self.angles_z = self.angles_x = 0;};
void() player_getup3	=[	$getup3,	player_getup4	] {self.angles_z = self.angles_x = 0;};
void() player_getup4	=[	$getup4,	player_getup5	] {self.pain_finished = time;self.angles_z = self.angles_x = 0;};
void() player_getup5	=[	$getup5,	player_move 	] {self.angles_z = self.angles_x = 0;};

void() player_hit5	=[	$pain5,	player_hit6 	] {self.movetype = MOVETYPE_TOSS;self.velocity_x = self.velocity_y = 0;model_tilt();self.owner.softshadow_time = time;frameskip (0.7);};

void() player_hit6	=[	$pain5,	player_hit6 	]
{
	self.movetype = MOVETYPE_WALK;
	self.velocity_x = self.velocity_y = 0;
	model_tilt();
	self.owner.softshadow_time = time;
	if (!self.swimming)
	{
		if (random() < 0.5)
			player_getup1();
		else
		{
			player_fflip1();
			self.fly_time = time + 999; // stop backflip bug
		}
	}
	else
		player_getup1();
	self.nextthink = time + 0.1;
};

void() player_getupb1	=[	$getupb1,	player_getupb2	] {self.angles_z = self.angles_x = 0;};
void() player_getupb2	=[	$getupb2,	player_getupb3	] {};
void() player_getupb3	=[	$getupb3,	player_getupb4	] {self.pain_finished = time;};
void() player_getupb4	=[	$getup5,	player_move	] {};

void() player_pain =
{
	local float rs;

	makevectors(self.angles);

	// clear some stuff up on getting hurt
	self.owner.purge_toggle = FALSE;
	self.owner.goalentity = self; // reset camera back to Vigil
	self.owner.shadow_time = time;

	self.owner.walljump = self.walljump = FALSE;
	self.owner.ledgegrab = self.ledgegrab = FALSE;
	self.owner.wallgrab = self.wallgrab = FALSE;
	self.owner.wallrun = self.wallrun = FALSE;
	
	self.owner.swordshadow_time = time; // disable sword shadow
	self.grabbed = FALSE;
	self.idle_count = 0; // reset pose

	if (self.owner.status_broken_finished < time)
	{
		self.colormod = '3 1 1'; // flash red
		if (self.block_finished > time)
			self.block_finished = time;
		if (self.owner.noblock_finished > time)
			self.owner.noblock_finished = time; // Allow Vigil to block again
	}
		
	self.movetype = MOVETYPE_WALK; // reset movetype (stops ledge grab flying up)
	self.angles_x = self.angles_z = 0; // angle fixed up
	self.charge_count = 0;
	if (self.owner.camera_forcezoom_finished < time)
		self.owner.zoom_mode = 0; // no zoom
	self.beams_shot = 0;

	rs = random()*100;

	if (self.angles_y > 90 && self.angles_y < 270)
		self.angles_y = 180;
	else
		self.angles_y = 0;

	if (self.enemy != world && deathmatch == FALSE)
		self.enemy.grabbed = FALSE;

	self.tired_finished = time;
	self.owner.magicmenu = FALSE;

	PainSound();
	self.perfectblock_cooldown = time + 0.5; // can't PG after being hit
	self.purge_cooldown = time + 0.5; // can't purge right after being hit

	//
	// Vigil's pain behavior works a bit differently in deathmatch
	//

	if (deathmatch == TRUE)
	{
		if (self.knockback == 0)
		{
			if (random() < 0.5)
				player_hit1();
			else
				player_hit2();
			self.fly_time = time + 0.8;
			self.pain_finished = time + 0.8;
		}
		if (self.knockback == 1)
		{
			// aircombo
			if (self.onground == FALSE)
			{
				if (random() < 0.5)
					player_hit1();
				else
					player_hit2();
				self.fly_time = time + 1.3;
				self.pain_finished = time + 1.3;
			}
			else // hit on ground
			{
				self.think = player_knockedfar1;
				self.nextthink = time + 0.1;
				self.fly_time = time + 999;
				self.pain_finished = time + 999;
				self.velocity = '0 0 0';
				self.flags = self.flags - (self.flags & FL_ONGROUND);
				self.velocity = self.velocity - 9 * v_forward * 8;
				self.velocity = self.velocity + 90 * '0 0 3';
			}
		}
		else if (self.knockback == 2 || self.knockback == 3 || self.knockback == 5 || self.knockback == 7)
		{
			self.owner.softshadow_time = time + 999;
			if (self.knockback == 2)
			{
				self.think = player_knockedup1;
				self.nextthink = time + 0.1;
			}
			else if (self.knockback == 3)
			{
				self.think = player_twist;
				self.nextthink = time + 0.1;
			}
			else if (self.knockback == 5)
			{
				self.think = player_knockedfar1;
				self.nextthink = time + 0.1;
			}
			else if (self.knockback == 7)
			{
				self.think = player_knockedup1;
				self.nextthink = time + 0.1;
			}
			else
				player_hit3();
			self.fly_time = time + 999;
			self.pain_finished = time + 999;
		}
		else if (self.knockback == 4)
		{
			if (self.onground == FALSE)
				player_knockedup1();
			else
			{
				if (random() < 0.5)
					player_hit1();
				else
					player_hit2();
			}
			self.fly_time = time + 1;
			self.pain_finished = time + 1;
		}
		return;
	}

	//
	// End deathmatch pain behavior
	//

	if (self.paincount == 0)
	{
		player_hit1();
		self.pain_finished = time + 1;
	}
	if (self.paincount == 1)
	{
		player_hit2();
		self.pain_finished = time + 1;
	}
	if (self.paincount == 2)
	{
		if (self.knockback == 1)
		{
			self.think = player_knockedfar1;
			self.nextthink = time + 0.1;
		}
		else if (self.knockback == 2)
		{
			self.owner.camshake_finished = time + 0.2;
			self.velocity_x = 0;
			self.think = player_knockedup1;
			self.nextthink = time + 0.1;
		}
		else if (self.knockback == 3)
		{
			self.owner.camshake_finished = time + 0.2;
			self.think = player_twist;
			self.nextthink = time + 0.1;
		}
		else if (self.knockback == 4)
		{
			self.think = player_knockedup1;
			self.nextthink = time + 0.1;
		}
		else if (self.knockback == 5)
		{
			self.owner.camshake_finished = time + 0.2;
			self.think = player_knockedfar1;
			self.nextthink = time + 0.1;
		}
		else
		{
			player_hit3();
			self.velocity = '0 0 0';
			self.flags = self.flags - (self.flags & FL_ONGROUND);
			self.velocity = self.velocity - 9 * v_forward * 8;
			self.velocity = self.velocity + 90 * '0 0 3';
		}
		self.pain_finished = time + 999;
		self.owner.softshadow_time = time + 999;
		self.flypain = TRUE;
		self.knockback = 0;
	}
	self.owner.attack_finished = self.attack_finished = time;
	self.paincount = self.paincount + 1;
};

//*
// death
//*
.float dead_lockkey_finished;
.float respawn_count;
.float deathmenu;

void() player_die3;
void() player_die1	=[	$pain3,	player_die2	] {};
void() player_die2	=[	$pain4,	player_die2	]
{
	if (self.swimming) // sink slower when hit than in normal air
		self.velocity_z = self.velocity_z / 1.55;
	self.angles_x = 0;
	if (self.onground == TRUE || self.origin == self.oldorigin)
	{
		player_die3();
		self.dead_lockkey_finished = time + 1; // don't allow key presses until menu is up for a second
	}
	self.oldorigin = self.origin;
};

void() player_die3	=[	$pain5,	player_die3 ] 
{
	self.deadflag = DEAD_DEAD; // Enforce
	self.movetype = MOVETYPE_WALK;

	model_tilt();

	if (coop)
	{
		if (players_dead >= players)
		{
			if (self.respawn_count > 499)
				changelevel (mapname);
			self.respawn_count = self.respawn_count + 1;
		}
		centerprint (self.owner, "/P«·ÌÂ ÔˆÂÚ\nÖÖÖÖ ÖÖÖÖ\n\nYou have been vanquished ...\n");
		self.velocity = '0 0 0'; // stop moving
		frameskip(0.01);
		return;
	}

	if (deathmatch == FALSE)
	{	
		if (!(game_progress & IT_PROGRESS1)) // Reached Village bitwise
		{
			centerprint (self.owner, "/P«·ÌÂ ÔˆÂÚ\nÖÖÖÖ ÖÖÖÖ\n\nYou have been vanquished ...\n\n\nç ^b‘Ú˘ ¡Á·ÈÓ^b");
			if (self.owner.button0 && self.dead_lockkey_finished < time)
			{
				self.health = ceil(self.max_health);
				self.owner.health = ceil(self.owner.max_health);
				if (self.owner.pouch == FALSE && self.lip == 0)
				{
					self.owner.gold = ceil(self.owner.gold / 1.25);
					self.lip = 1;
				}
				else
				{
					self.owner.pouch = FALSE; // remove pouch if held
					self.lip = 1;
				}
				changelevel (mapname);
			}
		}
		else // reached safety offer new option
		{
			if (self.deathmenu == 0)
				centerprint (self.owner, "/P«·ÌÂ ÔˆÂÚ\nÖÖÖÖ ÖÖÖÖ\n\nYou have been vanquished ...\n\n\nç           ^b‘Ú˘ ¡Á·ÈÓ^b\n       ◊·Ú ÙÔ ”·ÊÂÙ˘");
			else
				centerprint (self.owner, "/P«·ÌÂ ÔˆÂÚ\nÖÖÖÖ ÖÖÖÖ\n\nYou have been vanquished ...\n\n\n             ‘Ú˘ ¡Á·ÈÓ\nç     ^b◊·Ú ÙÔ ”·ÊÂÙ˘^b");
	
			// Fix to stop immediate accidental key presses on death
			if (self.dead_lockkey_finished < time)
			{
				if (self.owner.keyflags & KEY_UP)
				{
					if (self.menu_declick == FALSE)
					{
						self.deathmenu = self.deathmenu - 1;
						localsound("misc/menu1", 4, 1);
					}
				}
				
				if (self.owner.keyflags & KEY_DOWN)
				{
					if (self.menu_declick == FALSE)
					{
						self.deathmenu = self.deathmenu + 1;
						localsound("misc/menu1", 4, 1);
					}
				}

				if (self.owner.keyflags & KEY_UP || self.owner.keyflags & KEY_DOWN)
					self.menu_declick = TRUE;
				else
					self.menu_declick = FALSE;

				if (self.deathmenu > 1)
					self.deathmenu = 0;
				if (self.deathmenu < 0)
					self.deathmenu = 1;
			
				if (self.owner.button0)
				{
					if (self.deathmenu == 0)
					{
						self.health = ceil(self.max_health);
						self.owner.health = ceil(self.owner.max_health);
					
						if (self.owner.pouch == FALSE && self.lip == 0)
						{
							self.owner.gold = ceil(self.owner.gold / 1.25);
							self.lip = 1;
						}
						else
						{
							self.owner.pouch = FALSE; // remove pouch if held
							self.lip = 1;
						}
						
						changelevel (mapname);
					}
					else // warp back to safety (village.bsp)...
					{
						local string h;
						h = ftos(2);
						cvar_set("gamecfg", h);
						changelevel ("village");
					}
				}
			}
		}
	}
	else
	{
		if (self.respawn_count >= 175)
		{
			if (self.tired_finished > time) // no longer tired
				self.tired_finished = time;
			Respawn_Dummy();
			self.respawn_count = 0;
		}
		self.respawn_count = self.respawn_count + 1;
	}
	// Remove Status Effects
	if (self.owner.status_poison_finished > time)
		self.owner.status_poison_finished = time;
	if (self.owner.status_blind_finished > time)
		self.owner.status_blind_finished = time;
	if (self.owner.status_broken_finished > time)
		self.owner.status_broken_finished = time;

	self.block_finished = time;
	self.velocity = '0 0 0'; // stop moving
	frameskip(0.01);
};

void() player_die =
{
	// Get out of turning angles
	if (self.angles_y == 45 || self.angles_y == -45)
		self.angles_y = 0;
	if (self.angles_y == 225 || self.angles_y == -225)
		self.angles_y = 180;

	players_dead = players_dead + 1;

	self.movetype = MOVETYPE_WALK;   // set proper movetype on death

	self.takedamage = DAMAGE_NO;
	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;

	// Remove status effects on death
	self.status_poison_finished = time;
	self.status_blind_finished = time;
	self.status_broken_finished = time;
	
	self.angles_z = 0;
	self.owner.magicmenu = FALSE;
	self.pain_finished = time + 999;
	self.flypain = TRUE;

	sound (self, CHAN_VOICE, "player/death.wav", 1, ATTN_NONE);

	self.dead_lockkey_finished = time + 999; // don't allow key presses until Vigil hit the ground on death
	player_die1();
};

//*
// blocking
//*
void() player_block3;

void() player_block1	=[	$block1,	player_block1	] 
{
	if (self.swimming)
	{
		if (self.perfectguard_buff < time)
			self.takedamage = DAMAGE_AIM;
		self.block_finished = time;
		player_move();
		return;
	}
	if (self.angles_x != 0)
		self.angles_x = 0;
	if (self.angles_y == 360) // lame bug fix
		self.angles_y = 0;
	if (self.block_finished < time)
		player_move();
	if (self.onground == FALSE)
		player_block3();
	if (self.perfectguard_buff < time)
		self.takedamage = DAMAGE_AIM;
};

void() player_block2	=[	$block2,	player_block2	] 
{
	if (self.swimming)
	{
		if (self.perfectguard_buff < time)
			self.takedamage = DAMAGE_AIM;
		self.block_finished = time;
		player_move();
		return;
	}
	if (self.angles_x != 0)
		self.angles_x = 0;
	if (self.angles_y == 360) // lame bug fix
		self.angles_y = 0;

	tracebox (self.origin, VEC_HULL_MIN, VEC_HULL_MAX, self.origin, 1, self);
	if (trace_startsolid)
	{
		self.lowceil = TRUE;
		self.takedamage = DAMAGE_NO;
		self.block_finished = time + 999;
	}
	else
	{
		self.lowceil = FALSE;
		if (self.perfectguard_buff < time)
			self.takedamage = DAMAGE_AIM;
	}

	if (self.block_finished < time && self.lowceil == FALSE)
		player_move();
	if (self.onground == FALSE)
		player_block3();
};

void() player_block3	=[	$block3,	player_block3	] 
{
	if (self.swimming)
	{
		if (self.perfectguard_buff < time)
			self.takedamage = DAMAGE_AIM;
		self.block_finished = time;
		player_move();
		return;
	}
	// don't allow air blocking frames when Vigil is touching the ground, looks silly
	if (self.onground == TRUE)
	{
		player_block2(); // always have vigil land in block2 frame from an air block

		// Get out of turning angles
		if (self.angles_y == 45 || self.angles_y == -45)
			self.angles_y = 0;
		if (self.angles_y == 225 || self.angles_y == -225)
			self.angles_y = 180;
	}
	if (self.flags & FL_ONGROUND) // Don't allow hover
		self.flags = self.flags - FL_ONGROUND;
	if (self.block_finished < time)
		player_move();
	if (self.perfectguard_buff < time)
		self.takedamage = DAMAGE_AIM;
};

void() player_blockbrk_movement =
{
	local entity effect;

	makevectors(self.angles);
	if (self.onground == TRUE)
	{
		if (random() < 0.5)
		{
			effect = spawn();
			setorigin(effect, self.origin - v_up*16 - v_forward * 24); // back foot
			setmodel(effect, "progs/dust.spr");
			effect.solid = SOLID_NOT;
			effect.owner = self;
			effect.drawonlytoclient = self.owner.owner; // reduce network traffic
			effect.movetype = MOVETYPE_FLY;
			effect.velocity_z = 100;
			effect.think = dust_think;
			effect.nextthink = time + 0.01;
		}
		else
		{
			effect = spawn();
			setorigin(effect, self.origin - v_up*16 + v_forward * 4); // front foot
			setmodel(effect, "progs/dust.spr");
			effect.solid = SOLID_NOT;
			effect.owner = self;
			effect.drawonlytoclient = self.owner.owner; // reduce network traffic
			effect.movetype = MOVETYPE_FLY;
			effect.velocity_z = 100;
			effect.think = dust_think;
			effect.nextthink = time + 0.01;
		}
	}
	self.block_finished = time;
	self.owner.noblock_finished = time + 0.2;
	self.guardbreak_finished = time + 0.2;

	self.velocity_time = time + 0.2;
	self.velocity_y = 0; // no foreground or background movement
	if (self.angles_y == 180)
		self.velocity_x = self.speed * 2;
	else if (self.angles_y == 0)
		self.velocity_x = 0 - (self.speed * 2);
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() player_blockbrk1	=[	$blockbrk1,	player_blockbrk2	] 
{
	if (freeze_finished < time) // don't interefere with level up/etc
		freeze_finished = time + (CONST_BIGHITSLOW * frametime);

	self.movetype = MOVETYPE_WALK;
	self.aircombo_count = 0; // reset combo count, fixes animation glitch as well
	self.knockback = 0; // remove knockback
	player_blockbrk_movement();
	if (self.onground == TRUE)
		sound (self, CHAN_BODY, "player/skid.wav", 1, ATTN_NORM);
	PainSound();
};
void() player_blockbrk2	=[	$blockbrk1,	player_blockbrk3	] {player_blockbrk_movement();};
void() player_blockbrk3	=[	$blockbrk2,	player_blockbrk4	] {player_blockbrk_movement();};
void() player_blockbrk4	=[	$blockbrk3,	player_blockbrk5	] {};
void() player_blockbrk5	=[	$blockbrk4,	player_block		] {};

void() player_block =
{
	tracebox (self.origin, VEC_HULL_MIN, VEC_HULL_MAX, self.origin, 1, self);
	if (trace_startsolid)
	{
		self.takedamage = DAMAGE_NO;
		self.lowceil = TRUE;
		player_block2();
		return;
	}

	if (self.onground == TRUE)
	{
		self.lowceil = FALSE;
		if (random() < 0.5)
			player_block1();
		else
			player_block2(); // crouching block
	}
	else
		player_block3();
};

//*
// magic spells
//*

void() player_fireball1	=[	$magicb1,	player_fireball2	] {spawn_magicfog();self.effects = EF_MUZZLEFLASH;};
void() player_fireball2	=[	$magicb2,	player_move	] 
{
	self.angles_y = self.turn_y;
	self.colormod = '3 2 1';
	Fireball(25,15);

	// Subtract mana for the spell accordingly
	if (self.owner.mana >= 10)
		self.owner.mana = self.owner.mana - 10;
	else if (self.owner.mana >= 10 / 1.5)
		self.owner.mana = self.owner.mana - 10 / 1.5;

	self.nextthink = time + 0.5;
};

void() player_lightning1	=[	$magica2,	player_lightning2	] {spawn_magicfog();};
void() player_lightning2	=[	$magica3,	player_lightning3	] 
{
	// Subtract mana at first frame of the lightning spell
	if (self.lcount == 0)
	{
		sound (self, CHAN_AUTO, "spells/lightn.wav", 1, ATTN_NORM);
		// Subtract mana for the spell accordingly
		if (self.owner.mana >= 50)
			self.owner.mana = self.owner.mana - 50;
		else if (self.owner.mana >= 50 / 1.5)
			self.owner.mana = self.owner.mana - 50 / 1.5;
	}
	if (self.lcount > 24)
		player_move();
	else
		LightningStorm();

	self.colormod = '5 5 5';
	self.lcount = self.lcount + 1; // count up till end

	if (self.owner.zoom_mode != 2)
		self.owner.zoom_mode = 2; // Zoom out
	frameskip(0.05);
};
void() player_lightning3	=[	$magica4,	player_lightning2	] {frameskip(0.05);};

void() player_icefield2;
void() player_icefield1	=[	$magicc1,	player_icefield1	] 
{
	local entity effect;

	if (self.owner.zoom_mode != 2)
		self.owner.zoom_mode = 2; // Zoom out

	self.owner.attack_finished = time + 3.5;
	if (self.icefield_count == 0)
	{
		spawn_magicfog();

		makevectors (self.angles);

		effect = spawn();
		effect.owner = self;
		setorigin(effect, self.origin + v_up * 50);
		setmodel(effect, "progs/chargice.spr");
		effect.movetype = MOVETYPE_NOCLIP;
		effect.solid = SOLID_NOT;
		effect.alpha = 0.2;
		effect.classname = "IceFieldChargeSpritePlayer";
		effect.think = chargeice_effect;
		effect.nextthink = time;
		sound (effect, CHAN_AUTO, "spells/charge.wav", 1, ATTN_NORM);
		self.colormod = '1 1 10'; // colormod change
	}
	if (self.icefield_count > 7)
	{
		player_icefield2();
		return;
	}
	self.icefield_count = self.icefield_count + 1;
};
void() player_icefield2	=[	$magicc2,	player_icefield3	] {};
void() player_icefield3	=[	$magicc3,	player_icefield4	] {};
void() player_icefield4	=[	$magicc4,	player_move	] 
{
	self.owner.noblock_finished = time + 999;

	// Subtract mana for the spell accordingly
	if (self.owner.mana >= 30)
		self.owner.mana = self.owner.mana - 30;
	else if (self.owner.mana >= 30 / 1.5)
		self.owner.mana = self.owner.mana - 30 / 1.5;

	IceField();
	self.nextthink = time + 2;
};

void() swordstareffect_2 =
{
	local entity effect;

	effect = spawn();
	effect.owner = self;
	effect.drawonlytoclient = self.owner.owner; // reduce network traffic
	setorigin(effect, self.origin - v_up * 22 + v_right * 30);
	setmodel(effect, "progs/star.spr");
	effect.solid = SOLID_NOT;
	effect.movetype = MOVETYPE_NOCLIP;
	effect.think = swordstareffect_think;
	effect.nextthink = time + 0.1;
};

void() player_magicd1	=[	$magicd1,	player_magicd2	] 
{
	spawn_magicfog();

	if (self.owner.camera_forcezoom_finished < time)
		self.owner.zoom_mode = 1; // Zoom in
};
void() player_magicd2	=[	$magicd2,	player_magicd3	] {};
void() player_magicd3	=[	$magicd3,	player_magicd4	] {};
void() player_magicd4	=[	$magicd4,	player_magicd5	] {sound (self, CHAN_BODY, "player/wallgrab.wav", 1, ATTN_NORM);};
void() player_magicd5	=[	$magicd5,	player_magicd6	] 
{
	local entity effect;

	makevectors(self.angles);

	effect = spawn();
	setorigin(effect, self.origin);
	setmodel(effect, "progs/chrgebm.mdl");
	effect.movetype = MOVETYPE_NOCLIP;
	effect.solid = SOLID_NOT;
	effect.owner = self;
	effect.scale = effect.alpha = 1;
	effect.effects = EF_NODEPTHTEST;
	effect.think = chargebeam_effect;
	effect.nextthink = time + 0.1;
	sound (effect, CHAN_AUTO, "spells/charge.wav", 1, ATTN_NORM);
	swordstareffect_2();
	self.nextthink = time + 1;
	self.colormod = '5 0 0';
};

void() player_magicd6	=[	$magicd6,	player_magicd7 	] 
{
	self.angles_y = self.turn_y;
	self.owner.zoom_mode = 2; // Zoom out
};

void() player_magicd7	=[	$magicd7,	player_magicd7 	] 
{
	if (!deathmatch)
		self.takedamage = DAMAGE_NO;
	if (self.beams_shot == 0)
	{
		Firebeam_Muzzle();

		// Subtract mana for the spell accordingly
		if (self.owner.mana >= 100)
			self.owner.mana = self.owner.mana - 100;
		else if (self.owner.mana >= (100 / 1.5))
			self.owner.mana = self.owner.mana - (100 / 1.5);
	}
	// Fire beam here
	if (self.beams_shot < 35) // 35 beams
	{
		Firebeam(5, 12, 20);
		self.beams_shot = self.beams_shot + 1; // increase beam by 1
	}
	else
	{
		self.beams_shot = 0;
		player_move();
	}
	self.colormod = '5 0 0';
	self.owner.camshake_finished = time + 0.1;
};

void() player_twister4;
void() player_twister1	=[	$magica2,	player_twister2	] {spawn_magicfog();self.colormod = '0 5 0';}
void() player_twister2	=[	$magica3,	player_twister3	] {sound (self, CHAN_AUTO, "spells/twister.wav", 1, ATTN_NORM);};
void() player_twister3	=[	$magica4,	player_twister3	] 
{
	// Subtract mana at first frame of the twister spell
	if (self.tcount == 0)
	{
		// Subtract mana for the spell accordingly
		if (self.owner.mana >= 75)
			self.owner.mana = self.owner.mana - 75;
		else if (self.owner.mana >= (75 / 1.5))
			self.owner.mana = self.owner.mana - (75 / 1.5);
	}

	if (self.tcount > 50)
		player_twister4();
	else
		self.owner.attack_finished = time + 1;
	if (self.tcount < 6)
		Twister();

	self.tcount = self.tcount + 1; // count up till end

	self.owner.noblock_finished = time + 999;
	if (self.owner.zoom_mode != 2)
		self.owner.zoom_mode = 2; // Zoom out
};
void() player_twister4	=[	$magica4,	player_move	] {};

void() spark_think =
{
	particle (self.origin, '0 0 0', 111, 4); // yellow particles
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.1;
};

//
// Function is used for testx checking to see if the players x origin
// changed and if it hasn't bail them out of the swallow attacks
//

void() swallow_testxcheck =
{
	local entity oself;

	if (self.owner)
	{
		if (self.owner.origin_x == self.origin_x && self.owner.onground == FALSE)
		{
			oself = self;
			self = self.owner;
			self.owner.backflip_finished = time + 0.7; // Perfect value
			player_bflip1();
			self.aircombo_count = 0; // prevent animation glitch in player_jumpframe();
			self = oself;
		}
	}
	remove(self);
	return;
};

void() divingswallow_hit =
{
	local entity head, effect;
	local vector dir;

	makevectors(self.angles);

	head = searchradius(self.origin + v_forward * 16, 40);
	while (head)
	{
		if (head.takedamage && head != self && visible(head)
		&& ((coop == TRUE && head.classname != "player" && self.classname == "player")
		|| (coop == FALSE || self.flags & FL_MONSTER))) // coop
		{
			if (head.th_pain)
			{
				if (head.noblood == FALSE)
				{
					ThrowBloodSplat(head.origin, head);
					ThrowBloodSplat(head.origin, head);
					ThrowBloodSplat(head.origin, head);
					ThrowBloodSplat(head.origin, head);
				}

				if (self.owner.wallrun == FALSE)
					self.bflipwall_finished = time + 0.3;
				head.paincount = 0;
				head.velocity = '0 0 0';
				head.flags = head.flags - (head.flags & FL_ONGROUND);
				head.velocity = self.velocity; // drag enemy in the air along with Vigil

				if (self.aircombo_count == 8) // for air diving swallow
				{
					head.damage_type = self.attack_type = 5; // Cut/gored/sliced in half!

					// spawn a hit sprite
					effect = spawn();
					setorigin(effect, head.origin + v_forward*15);
					setmodel(effect, "progs/divs_hit.mdl");
					effect.movetype = MOVETYPE_NOCLIP;
					effect.effects = EF_NODEPTHTEST | EF_ADDITIVE | EF_FULLBRIGHT;
					effect.alpha = 1;
					effect.solid = SOLID_NOT;
					if (self.angles_y != 0)
						effect.angles_x = self.angles_x * -1;
					else
						effect.angles_x = self.angles_x;
					effect.think = divingshit_think;
					effect.nextthink = time;

					head.knockback = 5;
					self.owner.camshake_finished = time + 0.2;
					sound (self, CHAN_WEAPON, "player/hugekick.wav", 1, ATTN_NORM);
					self.owner.screenflash_finished = time + 0.1;

					local float damg_calc;
					damg_calc = 35;
					damg_calc = damg_calc + ceil(self.owner.swordlevel * 10);
					
					if (deathmatch == FALSE)
						T_Damage (head, self, self, damg_calc, 0);
					else
						T_Damage (head, self, self, 8, 0);
					
					if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
					{
						if (freeze_finished < time) // don't interefere with level up/etc
							freeze_finished = time + (CONST_BIGHITSLOW * frametime);
					}

					if (deathmatch == FALSE)
						self.owner.mana = self.owner.mana + 3;	
					else
						self.owner.mana = self.owner.mana + 6;

					self.think = player_bflip1;
					self.owner.backflip_finished = time + 0.7; // Perfect value! Player enters negative velocity by this itme...
				}
				else
				{
					// spawn a hit sprite
					effect = spawn();
					setorigin(effect, head.origin + v_up*22);
					setmodel(effect, "progs/jhit.spr");
					effect.movetype = MOVETYPE_NOCLIP;
					effect.think = fx_think;
					effect.effects = EF_NODEPTHTEST;
					effect.nextthink = time;
					effect.solid = SOLID_NOT;

					if (deathmatch == FALSE)
						T_Damage (head, self, self, 8, 0);
					else
						T_Damage (head, self, self, 3, 0);
					sound (self, CHAN_WEAPON, "player/kickhit.wav", 1, ATTN_NORM);
					if (deathmatch == FALSE)
						self.owner.mana = self.owner.mana + 1;
					else
						self.owner.mana = self.owner.mana + 2;
				}
				self.owner.combo = self.owner.combo + 1; // raise combo counter
			}
		}
		head = head.chain;
	}
};

void() player_walljumpkickslide   =[	$pain2,	player_walljumpkickslide 	]
{
	local entity effect;

	if (self.runatk_speed > 15)
	{
		player_move();
		return;
	}

	makevectors(self.angles);
	if (self.onground == TRUE)
	{
		if (random() < 0.5)
		{
			effect = spawn();
			setorigin(effect, self.origin - v_up*16 - v_forward * 24); // back foot
			setmodel(effect, "progs/dust.spr");
			effect.solid = SOLID_NOT;
			effect.owner = self;
			effect.drawonlytoclient = self.owner.owner; // reduce network traffic
			effect.movetype = MOVETYPE_FLY;
			effect.velocity_z = 100;
			effect.think = dust_think;
			effect.nextthink = time;
		}
		else
		{
			effect = spawn();
			setorigin(effect, self.origin - v_up*16 + v_forward * 4); // front foot
			setmodel(effect, "progs/dust.spr");
			effect.solid = SOLID_NOT;
			effect.owner = self;
			effect.drawonlytoclient = self.owner.owner; // reduce network traffic
			effect.movetype = MOVETYPE_FLY;
			effect.velocity_z = 100;
			effect.think = dust_think;
			effect.nextthink = time;
		}
	}

	self.velocity_time = time + 0.2;
	self.owner.attack_finished = time + 0.2;
	self.runatk_speed = self.runatk_speed + 5;
	model_tilt();

	// slowly move the player in the direction they were facing in the air
	if (self.angles_y == 0) // facing left
		self.velocity_x = self.speed * 2 - self.runatk_speed;
	else if (self.angles_y == 180)
		self.velocity_x = 0 - (self.speed * 2) + self.runatk_speed;
	self.velocity_y = 0; // no foreground or background movement
};

.float divingswallow_wallcheck_finished;
void() player_walljumpkick1	=[	$jumpatkb1,	player_walljumpkick1	]
{
	self.owner.noblock_finished = time + 5;
	self.inair = 16; // fixes rare issue
	if (self.angles_y == 0)
		self.velocity_x = 500;
	else
		self.velocity_x = -500;

	self.velocity_z = -250;

	if (self.owner.camera_forcezoom_finished < time)
		self.owner.zoom_mode = 2;
	divingswallow_hit();
	self.owner.attack_finished = time + 0.2;
	self.owner.shadow_time = time + 0.1;

	//
	// Check if his X origin (left/right) moved
	//

	local entity testx, oself;
	local float cg;

	makevectors(self.angles);

	testx = spawn();
	testx.owner = self;
	testx.drawonlytoclient = self.owner.owner; // reduce network usage
	testx.movetype = MOVETYPE_NOCLIP;
	testx.solid = SOLID_NOT;
	testx.think = swallow_testxcheck;
	testx.nextthink = time + 0.05;
	setmodel(testx, string_null); // debug return to string null
	setsize(testx, '0 0 0', '0 0 0');
	setorigin(testx, self.origin);

	if (self.onground == TRUE)
	{
		self.angles_x = 0;
		player_walljumpkickslide();
		sound (self, CHAN_BODY, "player/skid.wav", 1, ATTN_NORM);
		return;
	}
	self.owner.speedline_time = time + 0.2; // speedline
	frameskip(0.05);
};

.float wallsound_finished;
void() player_wallgrab	=[	$wallgrab,	player_wallgrab 	] 
{
	local entity spark;
	local vector source, org;

	self.aircombo_count = 0; // this needs to be set to 0, prevents a weird looking animation glitch
							 // if the user is air comboing then wall jumps
	self.owner.softshadow_time = time;

	self.owner.FL_JMPPRESSED = FALSE; // Release jump pressed flag

	if (self.owner.wallgrab == FALSE)
	{
		sound (self, CHAN_WEAPON, "player/wallgrab.wav", 1, ATTN_NORM);
		self.owner.wallgrab = TRUE;
		self.attack_finished = time + 0.2; // attack_finished in this case is a brief pause to allow wall hang animation to play
	}

	// Get out of turning angles
	if (self.angles_y == 45 || self.angles_y == -45)
		self.angles_y = 0;
	if (self.angles_y == 225 || self.angles_y == -225)
		self.angles_y = 180;

	makevectors(self.angles);

	spark = spawn ();
	spark.owner = self;
	spark.drawonlytoclient = self.owner.owner; // reduce network traffic
	spark.movetype = MOVETYPE_NOCLIP;
	spark.solid = SOLID_NOT;
	spark.classname = "swordspark";
	setmodel (spark, string_null);
	spark.think = spark_think;
	spark.nextthink = time + 0.1;
	spark.velocity_z = 25;
	spark.attack_finished = time + 0.4;
	setorigin(spark, self.origin + v_forward * 20);

	if (self.owner.zoom_mode != 0 && self.owner.camera_forcezoom_finished < time)
		self.owner.zoom_mode = 0; // No zoom

	self.velocity = '0 0 15';

	if (self.onground == TRUE)
		player_move();

	// attack_finished in this case is a brief pause to allow wall hang animation to play
	if (self.owner.button0 && self.attack_finished < time && self.invunerability_finished < time && self.safezone == FALSE)
	{
		if (self.angles_y == 0)
		{
			self.velocity_x = -500;
			self.angles_y = 180;
		}
		else
		{
			self.velocity_x = 500;
			self.angles_y = 0;
		}
		self.angles_x = -15;

		self.owner.walljump = TRUE;
		self.owner.wallgrab = FALSE;
		self.divingswallow_wallcheck_finished = time + 0.2;
		player_walljumpkick1();
		player_yell(1); 

		sound (self, CHAN_BODY, "player/fast.wav", 1, ATTN_NORM);
		self.velocity_z = 50;
		return;
	}
	if (self.wallsound_finished < time)
	{
		sound (self, CHAN_AUTO, "player/swrdwall.wav", 1, ATTN_NORM);
		self.wallsound_finished = time + 0.5;
	}

	makevectors(self.angles);
	source = self.origin;

	traceline (source, source + v_forward*35, FALSE, self);
	org = trace_endpos + v_up*4;

	if (trace_fraction == 1)
	{
		player_move();
		self.owner.wallgrab = FALSE;
	}
};

void() player_ledgehoist = 
{
	// move vigil up
	self.velocity = '0 0 0';
	self.velocity_z = 250;
	self.inair = self.bigfall = 0;

	if (self.frame == $ledgec4 || self.frame == $ledgec5 || self.frame == $ledgec6)
	{
		// move vigil to left/right here
		if (self.angles_y == 0) // facing left
			self.velocity_x = self.speed * 1;
		else if (self.angles_y == 180)
			self.velocity_x = 0 - (self.speed * 1);
	}
};

void() player_ledgeclimb1	=[	$ledgec1,	player_ledgeclimb2	] {player_ledgehoist();};
void() player_ledgeclimb2	=[	$ledgec2,	player_ledgeclimb3	] {player_ledgehoist();};
void() player_ledgeclimb3	=[	$ledgec3,	player_ledgeclimb4	] {player_ledgehoist();};
void() player_ledgeclimb4	=[	$ledgec4,	player_ledgeclimb5	] {player_ledgehoist();};
void() player_ledgeclimb5	=[	$ledgec5,	player_ledgeclimb6	] {player_ledgehoist();};
void() player_ledgeclimb6	=[	$ledgec6,	player_move 		] 
{
	player_ledgehoist();
	self.velocity = '0 0 0';
	self.owner.ledgegrab_finished = time + 9999; // Disallow mid-air movement + disable jump button
	self.owner.ledgegrab = FALSE;
};

.float ledgegrab_animation_finished;
void() player_ledgegrab1	=[	$ledgeg1,	player_ledgegrab1 	]
{
	if (self.owner.camera_forcezoom_finished < time)
		self.owner.zoom_mode = 1; // zoom in camera
	if (self.walkframe > 7) // animation
		self.walkframe = 0;
	self.frame = $ledgeg1 + self.walkframe;
	if (self.ledgegrab_animation_finished < time)
	{
		self.walkframe = self.walkframe + 1;
		if (self.swimming)
			self.ledgegrab_animation_finished = time + 0.2;
		else
			self.ledgegrab_animation_finished = time;
	}

	// Get out of turning angles, I've witnessed it on a ledge grab before so let's stop it for sure
	if (self.angles_y == 45 || self.angles_y == -45)
		self.angles_y = 0;
	if (self.angles_y == 225 || self.angles_y == -225)
		self.angles_y = 180;

	self.movetype = MOVETYPE_FLY; // Lock Vigil
	self.velocity = '0 0 0';

	if (self.attack_finished < time)
	{   // fix for user pressing more then 2 directions causing odd annoying glitch
		if (self.owner.keyflags & KEY_UP && (!(self.owner.keyflags & KEY_LEFT || self.owner.keyflags & KEY_RIGHT))) // hoist yourself up
		{
			self.inair = self.bigfall = 0;
			self.movetype = MOVETYPE_WALK;
			self.velocity = '0 0 0';
			sound (self, CHAN_WEAPON, "player/climb.wav", 1, ATTN_NORM);
			player_ledgeclimb1();
			return;
		}
		else if (self.owner.keyflags & KEY_DOWN && (!(self.owner.keyflags & KEY_LEFT || self.owner.keyflags & KEY_RIGHT))) // drop off ledge
		{
			self.velocity_x = self.velocity_y = 0;
			player_move();
			self.owner.ledgegrab = FALSE;
			self.movetype = MOVETYPE_WALK;
		}
	}
};

void() player_doublejump1	=[	$djump,	player_doublejump1	] 
{
	self.angles_x = self.angles_x - 45; // spin

	if (self.djump_spincnt == 0)
	{
		self.djump_spincnt = 1;
		player_yell(0);
		self.velocity_z = self.walkframe = 0;
		self.velocity_z = self.velocity_z + 300; // additional height
	}

	if (relics & IT_RELIC3)
	{
		if (self.djump_spincnt > 4)
		{
			self.djump_spincnt = 1; // (kind of) remove double jump flag - concerns trigger_spincut as well
			self.angles_x = 0; // remove spin
			player_move();
			return;
		}
	}
	else
	{
		if (self.djump_spincnt > 1)
		{
			self.djump_spincnt = 1; // (kind of) remove double jump flag - concerns trigger_spincut as well
			self.angles_x = 0; // remove spin
			player_move();
			return;
		}
	}

	// Spin Slash Sound
	if (self.walkframe == 0 && relics & IT_RELIC3)
		sound (self, CHAN_BODY, "player/swrdspin.wav", 1, ATTN_NORM);
	else if (self.walkframe == 2) // Spin slash damage
	{
		if (self.invunerability_finished < time && self.owner.safezone == FALSE)
		{
			self.owner.aircombo_finished = time + 0.2;
			FireMelee(2,0,0,50,0,0,1,TRUE,25,0);
		}
	}
	else if (self.walkframe > 6)
	{
		self.djump_spincnt = self.djump_spincnt + 1;
		if (relics & IT_RELIC4)
			wallgrab_check();
		self.walkframe = -1; // it'll increase to 0 right after
	}
	if (self.onground == TRUE)
	{
		self.angles_x = 0; // remove spin
		player_move();
		return;
	}

	self.owner.softshadow_time = time + 1;
	self.walkframe = self.walkframe + 1;
	frameskip(0.02);
};

void() player_airdivings1 =
{
	local vector view;
	local float bt;

	self.owner.noblock_finished = time + 0.2;
	self.movetype = MOVETYPE_WALK;
	self.takedamage = DAMAGE_NO;

	view = vectoangles(self.enemy.origin - self.origin);
	bt = vlen(self.enemy.origin - self.origin);

	if (self.frame != $jumpatkb1) // only execute once...
	{
		self.frame = $jumpatkb1;
		sound (self, CHAN_BODY, "player/fast.wav", 1, ATTN_NORM);
	}

	// a noclip monster may of exited the level, so just get out of this...
	// also make sure that vigil hasn't somehow gone passed his target or it hasn't died anyways, if so break out
	if (!visible(self.enemy) || (self.origin_x > self.enemy.origin_x && self.angles_y == 0) || (self.origin_x < self.enemy.origin_x && self.angles_y == 180)
	|| self.origin == self.oldorigin || (self.enemy.deadflag == DEAD_DEAD || self.enemy == world))
	{
		self.think = player_bflip1;
		self.owner.backflip_finished = time + 0.7; // Perfect value! Player enters negative velocity by this itme...
	}

	self.angles_x = view_x * -1;

	makevectors (self.angles);
	self.velocity = aim(self, 750);
	self.velocity = self.velocity * 750;
	self.angles = vectoangles(self.velocity);

	// keep vigil inline with his target just incase
	if (self.enemy.origin_y > self.origin_y)
		self.velocity_y = self.velocity_y + (bt * 100) * frametime; // the speed
	else
		self.velocity_y = self.velocity_y + (bt * 100) * frametime * -1; // the speed

	self.owner.zoom_mode = 2;

	if (self.aircombo_count != 8)
		self.aircombo_count = 8; // used in divingswallowhit();
	divingswallow_hit();

	self.owner.attack_finished = time + 0.2;
	self.owner.shadow_time = time + 0.1;
	self.owner.speedline_time = time + 0.2; // speedline

	//
	// Check if his X origin (left/right) moved
	//

	local entity testx, oself;
	local float cg;

	makevectors(self.angles);

	testx = spawn();
	testx.owner = self;
	testx.drawonlytoclient = self.owner.owner; // reduce network traffic
	testx.movetype = MOVETYPE_NOCLIP;
	testx.solid = SOLID_NOT;
	testx.think = swallow_testxcheck;
	testx.nextthink = time + 0.05;
	setmodel(testx, string_null);
	setsize(testx, '0 0 0', '0 0 0');
	setorigin(testx, self.origin);

	frameskip(0.1);
};

// Need to check for wall grabbing during his wall running frames!
void() wallrunning_think =
{
	local float n = 0;
	local vector source = self.origin;

	makevectors(self.angles);

	if (self.angles_y == 0 || self.angles_y == 180 && self.wallgrab == FALSE && self.owner.wallrun == TRUE)
	{
		traceline (source, source + v_forward*25 + v_up*22, FALSE, self);
		if (trace_fraction == TRUE || trace_ent.solid != SOLID_BSP)
			n = 1;

		traceline (source, source + v_forward*25 - v_up*22, FALSE, self);
		if (trace_fraction == TRUE || trace_ent.solid != SOLID_BSP)
			n = 1;

		if (trace_plane_normal_z == FALSE) // Flat Wall
			local float OK = TRUE;

		// Get Wall Texture
		local float surfnum = getsurfacenearpoint(world, trace_endpos);
		local string s = getsurfacetexture(world, surfnum);

/*
		// Check for clip brush by checking the floor (HACKY!)
		traceline (source, source - v_up*9999, FALSE, self);	
		local float surfnum2 = getsurfacenearpoint(world, trace_endpos);
		local string s2 = getsurfacetexture(world, surfnum2);

		if (s == s2) // Clip brushes only report floor texture, if floor and wall are the same
			return;  // don't allow a wall grab
*/

		// Check for 'sky' / 'clip2' text in texture
		local float r = strstrofs(s, "sky", 0);
		local float r2 = strstrofs(s, "{clip2", 0);
		if (!r || !r2) // found "sky" / '{clip2' string
			return;

		if ((self.owner.keyflags & (KEY_LEFT) && self.angles_y == 0) || (self.owner.keyflags & (KEY_RIGHT) && self.angles_y == 180) && relics & IT_RELIC4)
		{
			if (OK && n == 0) // flat wall check
			{
				self.owner.aircombo_count = 0;
				if (self.owner.wallrun == TRUE) // bug fix: allow blocking again
					self.owner.wallrun = FALSE;
				self.think = player_wallgrab;
				self.nextthink = time;
			}
		}
	}
};

void() player_wallrun_right1	=[ 0,	player_wallrun_right1	] 
{
	local vector source;

	makevectors(self.angles);
	source = self.origin;

	traceline(source, source + '0 -25 -16', FALSE, self);

	self.angles_y = 180;
	if (self.walkframe > 3)
	{
		sound (self, CHAN_BODY, "player/wrun1.wav", 1, ATTN_NONE);
		self.walkframe = 0;
	}
	if (self.walkframe == 2)
		sound (self, CHAN_BODY, "player/wrun2.wav", 1, ATTN_NONE);

	self.frame = $rwallrun1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	self.velocity_x = -180; // move Vigil along
	self.velocity_z = self.wallrun_height;
	self.wallrun_height = self.wallrun_height - 10;
	self.wallrun_finished = time + 0.1;

	if (trace_fraction == TRUE || self.onground == TRUE || self.wallrun_height < 0 || !self.owner.keyflags & (KEY_RIGHT))
		player_move();

	wallrunning_think();
};

void() player_wallrun_left1	=[ 0,	player_wallrun_left1	] 
{
	local vector source;

	makevectors(self.angles);
	source = self.origin;

	traceline(source, source + '0 -25 -16', FALSE, self);

	self.angles_y = 0;
	if (self.walkframe > 3)
	{
		sound (self, CHAN_BODY, "player/wrun1.wav", 1, ATTN_NONE);
		self.walkframe = 0;
	}
	if (self.walkframe == 2)
		sound (self, CHAN_BODY, "player/wrun2.wav", 1, ATTN_NONE);

	self.frame = $lwallrun1 + self.walkframe;
	self.walkframe = self.walkframe + 1;

	self.velocity_x = 180; // move Vigil along
	self.velocity_z = self.wallrun_height;
	self.wallrun_height = self.wallrun_height - 10;
	self.wallrun_finished = time + 0.1;

	if (trace_fraction == TRUE || self.onground == TRUE || self.wallrun_height < 0 || !self.owner.keyflags & (KEY_LEFT))
		player_move();

	wallrunning_think();
};

/*
=============
wallrun_divingswallow_infront

returns 1 if the entity is in front (in sight) of self
=============
*/

float(entity targ) wallrun_divingswallow_infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.char.angles);
	vec = normalize (targ.origin - self.char.origin);
	dot = vec * v_forward;

	if (dot > 0)
		return TRUE;
	else
		return FALSE;
};

/*
=============
visibleds (diving swallow)

returns 1 if the entity is visible at any angle
=============
*/

float (entity targ) visibleds =
{
 	traceline (self.char.origin, targ.origin, TRUE, self); // "true", see through other monsters
 
	if (trace_fraction == 1 || (targ.solid == SOLID_BSP && targ.takedamage != DAMAGE_NO))
 		return TRUE;
	else
	 	return FALSE;
};


void() player_wallrunningjumpkick1;
void() wallrun_divingswallow_init =
{
	local entity targ;
	local vector view;

	makevectors (self.char.angles);

	targ = find(world, netname, "solid");
	while (targ)
	{
		if (targ.health > 0 && visibleds(targ) && wallrun_divingswallow_infront(targ) && targ.origin_z < self.char.origin_z
		&& self.char.wallrun_finished > time)
		{
			if ((deathmatch == FALSE && targ.flags & FL_MONSTER) || (deathmatch == TRUE && targ.owner.flags & FL_CLIENT))
			{
				self.char.enemy = targ;
				self.velocity = '0 0 0';
				self.char.think = player_wallrunningjumpkick1;
				self.char.nextthink = time;
			}
		}
		targ = find(targ, netname, "solid");
	}
	targ = find(world, netname, "solid");
};


void() player_wallrunningjumpkickslide   =[	$pain2,	player_wallrunningjumpkickslide	]
{
	local entity effect;

	if (self.runatk_speed > 4)
	{
		if (self.angles_y > 0 && self.angles_y < 180)
			self.angles_y = 180;
		else
			self.angles_y = 0;

		player_move();
		return;
	}
	self.runatk_speed = self.runatk_speed + 1;
	self.owner.attack_finished = time + 0.2;
	self.velocity = '0 0 0';
};

void() player_wallrunningjumpkick1	=[	$wallgrab,	player_wallrunningjumpkick2	]
{
	sound (self, CHAN_WEAPON, "player/wallgrab.wav", 1, ATTN_NORM);
	self.angles_y = -90;
	self.fixangle = TRUE;
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_FLY;
	frameskip (0.3);
};

void() player_wallrunningjumpkick2	=[	$wallgrab,	player_wallrunningjumpkick3	]
{
	local vector view;

	view = vectoangles(self.enemy.origin - self.origin);
	self.angles_y = view_y;
	sound (self, CHAN_BODY, "player/fast.wav", 1, ATTN_NORM);
	frameskip (0.01);
};

void() player_wallrunningjumpkick3	=[	$jumpatkb1,	player_wallrunningjumpkick3	]
{
	self.movetype = MOVETYPE_WALK;
	makevectors(self.angles);

	self.oldorigin = self.origin;
	self.owner.noblock_finished = time + 5;
	self.inair = 16; // fixes rare issue

	self.velocity = aim(self, 500);
	self.velocity = self.velocity * 500;
	self.velocity_z = -250;
	self.angles_x = -15;

	//
	// Check if his X origin (left/right) moved
	//

	local entity testx, oself;
	local float cg;

	makevectors(self.angles);

	testx = spawn();
	testx.owner = self;
	testx.drawonlytoclient = self.owner.owner; // reduce network traffic
	testx.movetype = MOVETYPE_NOCLIP;
	testx.solid = SOLID_NOT;
	testx.think = swallow_testxcheck;
	testx.nextthink = time + 0.05;
	setmodel(testx, string_null);
	setsize(testx, '0 0 0', '0 0 0');
	setorigin(testx, self.origin);

	if (self.onground == TRUE)
	{
		self.angles_x = 0;
		player_wallrunningjumpkickslide();
		sound (self, CHAN_BODY, "player/skid.wav", 1, ATTN_NORM);
		return;
	}
	divingswallow_hit();
	self.runatk_speed = 0;
	self.owner.attack_finished = time + 0.2;
	self.owner.shadow_time = time + 0.1;
	frameskip(0.05);
};

void() player_swordspin1   =[	$dfattack1,	player_swordspin2	] {frameskip(0.05);};
void() player_swordspin2   =[	$dfattack2,	player_swordspin3	] {frameskip(0.05);};
void() player_swordspin3   =[	$dfattack3,	player_swordspin4	] 
{player_yell(0);sound (self, CHAN_WEAPON, "player/swrdspin.wav", 1, ATTN_NORM);self.owner.swordshadow_time = time + 1;frameskip(0.02);};
void() player_swordspin4   =[	$dfattack4,	player_swordspin5	] {FireMelee(1,35,0,25,0,0,1,FALSE,0,0);frameskip(0.02);};
void() player_swordspin5   =[	$dfattack5,	player_swordspin6	] {frameskip(0.02);};

// Actual spinning (6 to 21 and back)
void() player_swordspin22;
void() player_swordspin6   =[	$dfattack6,	player_swordspin7	] 
{
	if (self.sword_spincnt > 5)
	{
		player_swordspin22();
		return;
	}
	sound (self, CHAN_WEAPON, "player/swrdspin.wav", 1, ATTN_NORM);
	self.sword_spincnt = self.sword_spincnt + 1;
	frameskip(0.02);
};
void() player_swordspin7    =[	$dfattack6,		player_swordspin8		] {frameskip(0.02);};
void() player_swordspin8    =[	$dfattack7,		player_swordspin9		] {frameskip(0.02);};
void() player_swordspin9    =[	$dfattack8,		player_swordspin10		] {FireMelee(1,35,0,25,0,0,1,FALSE,0,0);frameskip(0.02);};
void() player_swordspin10   =[	$dfattack9, 		player_swordspin11		] {frameskip(0.02);};
void() player_swordspin11   =[	$dfattack10,		player_swordspin12		] {frameskip(0.02);};
void() player_swordspin12   =[	$dfattack11,		player_swordspin13		] {frameskip(0.02);};
void() player_swordspin13   =[	$dfattack12,		player_swordspin5		] {FireMelee(1,35,0,25,0,0,1,FALSE,0,0);frameskip(0.02);};

// End, start "Tennis Smash"
void() player_swordspin22   =[	$dfattack2,		player_swordspin23		] {frameskip(0.05);};
void() player_swordspin23   =[	$smash1,		player_smashdown1		] {frameskip(0.05);};

void() smashdown_move =
{
	if (self.angles_y == 0 || self.angles_y == 360)
		self.velocity_x = 75;
	else
		self.velocity_x = -75;
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() player_smashdown1    =[	$smash2,	player_smashdown2		] {frameskip(0.05);self.takedamage = DAMAGE_NO;};
void() player_smashdown2    =[	$smash3,	player_smashdown3		] {frameskip(0.05);};
void() player_smashdown3    =[	$smash4,	player_smashdown4		] {frameskip(0.05);};
void() player_smashdown4    =[	$smash5,	player_smashdown5		] {self.velocity_z = 150;player_yell(1);smashdown_move();frameskip(0.1);};
void() player_smashdown5    =[	$smash6,	player_smashdown6		] {smashdown_move();frameskip(0.1);};
void() player_smashdown6    =[	$smash7,	player_smashdown7		] {smashdown_move();sound (self, CHAN_WEAPON, "player/sword3.wav", 1, ATTN_NORM);frameskip(0.05);};
void() player_smashdown7    =[	$smash8,	player_smashdown8		] 
{
	smashdown_move();
	self.owner.swordshadow_time = time + 0.05;
	self.attack_type = 5;
	self.sword_spincnt = 99; // screen shake in FireMelee
	FireMelee(20,35,3,35,5,1,1,TRUE,0,0);
	if (self.owner.bighit_freeze > time) // check if attack landed, needs to be called after FireMelee();
	{
		if (freeze_finished < time) // don't interefere with level up/etc
			freeze_finished = time + (CONST_BIGHITSLOW * frametime);
	}
	frameskip(0.05);
};
void() player_smashdown8    =[	$smash9,	player_move			] {smashdown_move();frameskip(0.2);};

// Backhand Spring
void() dodgea1_move =
{
	self.movetype = MOVETYPE_WALK;
	if (self.angles_y == 0 || self.angles_y == 360)
		self.velocity_x = -175;
	else
		self.velocity_x = 175;
};

void() player_dodgea1	    =[	$dodgea1,	player_dodgea2		 	] {frameskip(0.05);sound (self, CHAN_AUTO, "player/motion2.wav", 1, ATTN_NORM);self.takedamage = DAMAGE_NO;};
void() player_dodgea2	    =[	$dodgea2,	player_dodgea3		 	] {frameskip(0.05);player_yell(0);};
void() player_dodgea3	    =[	$dodgea3,	player_dodgea4		 	] {frameskip(0.05);};
void() player_dodgea4	    =[	$dodgea4,	player_dodgea5		 	] {frameskip(0.05);dodgea1_move();};
void() player_dodgea5	    =[	$dodgea5,	player_dodgea6		 	] {frameskip(0.05);dodgea1_move();};
void() player_dodgea6	    =[	$dodgea6,	player_dodgea7		 	] {frameskip(0.05);dodgea1_move();};
void() player_dodgea7	    =[	$dodgea7,	player_dodgea8		 	] {frameskip(0.05);dodgea1_move();};
void() player_dodgea8	    =[	$dodgea8,	player_dodgea9		 	] {frameskip(0.05);dodgea1_move();sound (self, CHAN_AUTO, "player/motion1.wav", 1, ATTN_NORM);};
void() player_dodgea9	    =[	$dodgea9,	player_dodgea10		 	] {frameskip(0.05);dodgea1_move();};
void() player_dodgea10	    =[	$dodgea10,	player_dodgea11		 	] {frameskip(0.05);dodgea1_move();};
void() player_dodgea11	    =[	$dodgea11,	player_block		 	]
{
	frameskip(0.05);
	dodgea1_move();
	if (self.perfectguard_buff < time)
		self.takedamage = DAMAGE_AIM;
};

//
// Forward Roll
//
void() dodgeb1_move = 
{	
	setsize(self, VEC_HULL_MIN, '16 16 12');

	tracebox (self.origin, VEC_HULL_MIN, VEC_HULL_MAX, self.origin, 1, self);
	if (trace_startsolid)
		self.lowceil = TRUE;
	else
		self.lowceil = FALSE;

	if (self.angles_y == 0 || self.angles_y == 360)
		self.velocity_x = 175;
	else
		self.velocity_x = -175;
};

void() player_dodgeb1	    =[	$dodgeb1,	player_dodgeb2		 	] {frameskip(0.05);dodgeb1_move();player_yell(0);self.takedamage = DAMAGE_NO;};
void() player_dodgeb2	    =[	$dodgeb2,	player_dodgeb3		 	] {frameskip(0.05);dodgeb1_move();};
void() player_dodgeb3	    =[	$dodgeb3,	player_dodgeb4		 	] {frameskip(0.05);dodgeb1_move();};
void() player_dodgeb4	    =[	$dodgeb4,	player_dodgeb5		 	] {frameskip(0.05);dodgeb1_move();sound (self, CHAN_AUTO, "player/skid.wav", 1, ATTN_NORM);};
void() player_dodgeb5	    =[	$dodgeb5,	player_dodgeb6		 	] {frameskip(0.05);dodgeb1_move();};
void() player_dodgeb6	    =[	$dodgeb6,	player_dodgeb7		 	] {frameskip(0.05);dodgeb1_move();};
void() player_dodgeb7	    =[	$dodgeb7,	player_dodgeb8		 	] {frameskip(0.05);dodgeb1_move();};
void() player_dodgeb8	    =[	$dodgeb8,	player_dodgeb9		 	] {frameskip(0.05);dodgeb1_move();};
void() player_dodgeb9	    =[	$dodgeb9,	player_block		 	]
{
	if (self.perfectguard_buff < time)
		self.takedamage = DAMAGE_AIM;

	tracebox (self.origin, VEC_HULL_MIN, VEC_HULL_MAX, self.origin, 1, self);
	if (trace_startsolid)
		self.lowceil = TRUE;
	else
		self.lowceil = FALSE;

	if (self.owner.mashattack == TRUE && self.onground && self.lowceil == FALSE)
	{
		self.swing_count = 0;
		self.think = player_fstab2;
		self.nextthink = time + 0.1;
		self.owner.mashattack = FALSE;
		self.owner.attack_finished = time + 0.7;
		self.owner.combo_finished = time + 0.7;
		return;
	}
	frameskip(0.05);
};

//
// Dodging up and down
//
void() DodgeUp = 
{
	tracebox (self.origin, VEC_HULL_MIN, VEC_HULL_MAX, self.origin, 1, self);
	if (trace_startsolid)
	{
		self.lowceil = TRUE;
		setsize(self, VEC_HULL_MIN, '16 16 12');
	}

	self.velocity_y = 175 / 1.35;
};

void() DodgeDown = 
{
	tracebox (self.origin, VEC_HULL_MIN, VEC_HULL_MAX, self.origin, 1, self);
	if (trace_startsolid)
	{
		self.lowceil = TRUE;
		setsize(self, VEC_HULL_MIN, '16 16 12');
	}
	self.velocity_y = -175 / 1.35;
};

void() player_dodgec1	    =[	$dodgec1,	player_dodgec2		 	] {player_yell(0);DodgeDown();frameskip(0.05);self.takedamage = DAMAGE_NO;};
void() player_dodgec2	    =[	$dodgec2,	player_dodgec3		 	] {DodgeDown();frameskip(0.05);sound (self, CHAN_AUTO, "player/skid.wav", 1, ATTN_NORM);};
void() player_dodgec3	    =[	$dodgec3,	player_dodgec4		 	] {DodgeDown();frameskip(0.05);};
void() player_dodgec4	    =[	$dodgec4,	player_dodgec5		 	] {DodgeDown();frameskip(0.05);};
void() player_dodgec5	    =[	$dodgec5,	player_dodgec6		 	] {DodgeDown();frameskip(0.05);};
void() player_dodgec6	    =[	$dodgec6,	player_dodgec7		 	] {DodgeDown();frameskip(0.05);};
void() player_dodgec7	    =[	$dodgec7,	player_block		 	] 
{
	if (self.perfectguard_buff < time)
		self.takedamage = DAMAGE_AIM;
};

void() player_dodged1	    =[	$dodged1,	player_dodged2		 	] {player_yell(0);DodgeUp();frameskip(0.05);self.takedamage = DAMAGE_NO;};
void() player_dodged2	    =[	$dodged2,	player_dodged3		 	] {DodgeUp();frameskip(0.05);sound (self, CHAN_AUTO, "player/skid.wav", 1, ATTN_NORM);};
void() player_dodged3	    =[	$dodged3,	player_dodged4		 	] {DodgeUp();frameskip(0.05);};
void() player_dodged4	    =[	$dodged4,	player_dodged5		 	] {DodgeUp();frameskip(0.05);};
void() player_dodged5	    =[	$dodged5,	player_dodged6		 	] {DodgeUp();frameskip(0.05);};
void() player_dodged6	    =[	$dodged6,	player_dodged7		 	] {DodgeUp();frameskip(0.05);};
void() player_dodged7	    =[	$dodged7,	player_block		 	] 
{
	if (self.perfectguard_buff < time)
		self.takedamage = DAMAGE_AIM;
};

void() player_dodgee1	    =[	$dodged1,	player_dodgee2		 	] {player_yell(0);DodgeDown();frameskip(0.05);self.takedamage = DAMAGE_NO;};
void() player_dodgee2	    =[	$dodged2,	player_dodgee3		 	] {DodgeDown();frameskip(0.05);sound (self, CHAN_AUTO, "player/skid.wav", 1, ATTN_NORM);};
void() player_dodgee3	    =[	$dodged3,	player_dodgee4		 	] {DodgeDown();frameskip(0.05);};
void() player_dodgee4	    =[	$dodged4,	player_dodgee5		 	] {DodgeDown();frameskip(0.05);};
void() player_dodgee5	    =[	$dodged5,	player_dodgee6		 	] {DodgeDown();frameskip(0.05);};
void() player_dodgee6	    =[	$dodged6,	player_dodgee7		 	] {DodgeDown();frameskip(0.05);};
void() player_dodgee7	    =[	$dodged7,	player_block		 	] 
{
	if (self.perfectguard_buff < time)
		self.takedamage = DAMAGE_AIM;
};

void() player_dodgef1	    =[	$dodgec1,	player_dodgef2		 	] {player_yell(0);DodgeUp();frameskip(0.05);self.takedamage = DAMAGE_NO;};
void() player_dodgef2	    =[	$dodgec2,	player_dodgef3		 	] {DodgeUp();frameskip(0.05);sound (self, CHAN_AUTO, "player/skid.wav", 1, ATTN_NORM);};
void() player_dodgef3	    =[	$dodgec3,	player_dodgef4		 	] {DodgeUp();frameskip(0.05);};
void() player_dodgef4	    =[	$dodgec4,	player_dodgef5		 	] {DodgeUp();frameskip(0.05);};
void() player_dodgef5	    =[	$dodgec5,	player_dodgef6		 	] {DodgeUp();frameskip(0.05);};
void() player_dodgef6	    =[	$dodgec6,	player_dodgef7		 	] {DodgeUp();frameskip(0.05);};
void() player_dodgef7	    =[	$dodgec7,	player_block		 	] 
{
	if (self.perfectguard_buff < time)
		self.takedamage = DAMAGE_AIM;
};

//
// Purge
//
void() player_purge_prop_think =
{
	if (self.alpha > 0)
		self.alpha = self.alpha - 0.01;
	else
	{
		remove(self);
		return;
	}
	frameskip(0.01);
};

void() player_purge_prop =
{
	local entity effect;
	
	// spawn a hit sprite
	effect = spawn();
	effect.owner = self;
	setorigin(effect, self.origin);
	setmodel(effect, "progs/plyr.mdl");
	effect.effects = EF_NODEPTHTEST;
	effect.movetype = MOVETYPE_NOCLIP;
	effect.frame = self.frame;
	effect.solid = SOLID_NOT;
	effect.angles = self.angles;
	effect.alpha = 1;
	if (effect.frame == $attacka4)
		effect.skin = 1;
	effect.effects = EF_NODEPTHTEST | EF_ADDITIVE | EF_FULLBRIGHT;
	effect.think = player_purge_prop_think;
	effect.nextthink = time;
};

void() player_purge1	=[	$attacka4,	player_purge2	]
{
	player_yell(1);
	self.effects = EF_NODEPTHTEST;
	self.angles_x = 0; // fix rare angle bug
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.owner.camshake_finished = time + 0.2;
	sound (self, CHAN_AUTO, "player/purge.wav", 1, ATTN_NORM);
	sound (self, CHAN_AUTO, "misc/teleport.wav", 1, ATTN_NORM);
	self.takedamage = DAMAGE_NO;
	self.owner.noblock_finished = time + 1;
	self.owner.attack_finished = time + 1;

	// Freeze timer is longer by default on purge, so it's okay to overwrite other active freeze timers
	freeze_finished = time + (6 * frametime);

	frameskip(1);
};

void() player_purge2	=[	$attacka4,	player_move	]
{
	player_purge_prop();
	self.movetype = MOVETYPE_WALK;
	self.takedamage = DAMAGE_AIM;
	self.effects = 0;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.purge_oldorigin_x);
	WriteCoord (MSG_BROADCAST, self.purge_oldorigin_y);
	WriteCoord (MSG_BROADCAST, self.purge_oldorigin_z);

	self.origin_x = self.purge_oldorigin_x;
	self.origin_y = self.purge_oldorigin_y;
	self.origin_z = self.purge_oldorigin_z;
	setorigin(self, self.origin);
	sound (self, CHAN_AUTO, "misc/teleport.wav", 1, ATTN_NORM);
};

void() player_miniswordspin1   =[	$dfattack1,	player_miniswordspin2	] {frameskip(0.05);};
void() player_miniswordspin2   =[	$dfattack2,	player_miniswordspin3	] {frameskip(0.05);};
void() player_miniswordspin3   =[	$dfattack3,	player_miniswordspin4	] 
{player_yell(0);sound (self, CHAN_WEAPON, "player/swrdspin.wav", 1, ATTN_NORM);self.owner.swordshadow_time = time + 0.5;frameskip(0.02);};
void() player_miniswordspin4   =[	$dfattack4,	player_miniswordspin5	] {FireMelee(1,35,4,25,0,0,1,TRUE,0,0);frameskip(0.02);};
void() player_miniswordspin5   =[	$dfattack5,	player_miniswordspin6	] {frameskip(0.02);};

// Actual spinning (6 to 21 and back)
void() player_miniswordspin22;
void() player_miniswordspin6   =[	$dfattack6,	player_miniswordspin7	] 
{
	if (self.sword_spincnt > 1)
	{
		player_miniswordspin22();
		return;
	}
	sound (self, CHAN_WEAPON, "player/swrdspin.wav", 1, ATTN_NORM);
	self.sword_spincnt = self.sword_spincnt + 1;
	frameskip(0.02);
};
void() player_miniswordspin7    =[	$dfattack6,		player_miniswordspin8		] {frameskip(0.02);};
void() player_miniswordspin8    =[	$dfattack7,		player_miniswordspin9		] {frameskip(0.02);};
void() player_miniswordspin9    =[	$dfattack8,		player_miniswordspin10		] {FireMelee(1,35,4,25,0,0,1,TRUE,0,0);frameskip(0.02);};
void() player_miniswordspin10   =[	$dfattack9, 	player_miniswordspin11		] {frameskip(0.02);};
void() player_miniswordspin11   =[	$dfattack10,	player_miniswordspin12		] {frameskip(0.02);};
void() player_miniswordspin12   =[	$dfattack11,	player_miniswordspin13		] {frameskip(0.02);};
void() player_miniswordspin13   =[	$dfattack12,	player_miniswordspin5		] {FireMelee(1,35,4,25,0,0,1,TRUE,0,0);frameskip(0.02);};
void() player_miniswordspin22   =[	$dfattack2,		player_move					] 
{
	if (self.angles_y == 0)
		self.velocity_x = 100;
	else
		self.velocity_x = -100;

	if (self.movetype != MOVETYPE_WALK) // fix a potential ledge grab glitch that can RARELY but still happen
		self.movetype = MOVETYPE_WALK;
	self.owner.doublejump = FALSE;
	self.idle_count = 0; // reset pose
	self.lastpos = self.char.origin; // for bottomless pits
	self.owner.charge_count = 0; // disallow charge attack in air
	self.inair = 16;
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	self.velocity_z = 300;
	self.frame = $jump1;
	self.think = player_move;
	self.nextthink = time;
	sound (self, CHAN_AUTO, "player/jump.wav", 1, ATTN_NORM);

	frameskip(0.05);
};