//+------+
//|Misc  |
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Misc code handled here, nowhere else to put it.                            |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

//
// Water splash effect
//

void() watersplash_think =
{
	local vector source, dest;

	if (!self.cnt2)
	{
		source = self.origin;
		dest = self.origin - v_up * 100;

		tracebox (source, self.mins, self.maxs, dest, TRUE, self);

		if (trace_fraction == 1) // Hit nothing
		{
			if (max_water_splash_ents > 0)
				max_water_splash_ents = max_water_splash_ents - 1;

			remove(self);
			return;
		}
		else
		{
			if (self.hitcontentsmaski)
			{
				
				if (!self.combo)
					dest = trace_endpos + v_up * 8;
				else if (self.combo == 1)
					dest = trace_endpos + v_up * 16;
				else
					dest = trace_endpos + v_up * 32;
				
				setorigin(self, dest);
				self.cnt2 = TRUE;
			}
		}
	}

	if (!self.combo)
	{
		self.alpha = self.alpha - 0.005;
		self.scale = self.scale + 0.0025;
		self.origin_z = self.origin_z + 0.025;
	}
	else if (self.combo == 1)
	{
		self.alpha = self.alpha - 0.015;
		self.scale = self.scale + 0.01;
		self.origin_z = self.origin_z + 0.075;
	}
	else
	{
		self.alpha = self.alpha - 0.0075;
		self.scale = self.scale + 0.01;
		self.origin_z = self.origin_z + 0.1;
	}

	if (self.alpha > 0)
	{
		if (!self.cnt)
			self.colormod = '1 1 1.5' * self.alpha; // Allow transparency without additive (water)
		else if (self.cnt == 1)
			self.colormod = '1 .25 .25' * self.alpha; // Allow transparency without additive (lava)
		else
			self.colormod = '.25 1 .25' * self.alpha; // Allow transparency without additive (slime)
	}
	else
	{
		if (max_water_splash_ents > 0)
			max_water_splash_ents = max_water_splash_ents - 1;

		remove(self);
		return;
	}

	frameskip(0.01);
};

//
// Water ripple effect
//

void() ripple_think =
{
	local vector source, dest;

	source = self.origin;
	dest = self.origin - v_up * 100;

	tracebox (source, self.mins, self.maxs, dest, TRUE, self);

	if (trace_fraction == 1) // Hit nothing
	{
		if (max_water_ripple_ents > 0)
			max_water_ripple_ents = max_water_ripple_ents - 1;

		remove(self);
		return;
	}
	else
	{
		if (self.hitcontentsmaski)
		{
			dest = trace_endpos;
			setorigin(self, dest);
		}
	}
	if (self.scale < 3)
		self.scale = self.scale + 0.01;
	else
	{
		if (max_water_ripple_ents > 0)
			max_water_ripple_ents = max_water_ripple_ents - 1;

		remove(self);
		return;
	}
	if (self.alpha > 0)
	{
		self.alpha = self.alpha - 0.005;
		if (!self.cnt)
			self.colormod = '1 1 1.25' * self.alpha; // Allow transparency without additive (water)
		else if (self.cnt == 1)
			self.colormod = '1 .25 .25' * self.alpha; // Allow transparency without additive (lava)
		else
			self.colormod = '.25 1 .25' * self.alpha; // Allow transparency without additive (slime)
	}
	frameskip(0.01);
};

void(entity own, float type, vector org) ripple_vfx =
{
	if (max_water_ripple_ents >= 12)
		return;

	local entity ripple;

	max_water_ripple_ents = max_water_ripple_ents + 1;

	ripple = spawn();
	ripple.owner = own;

	precache_model ("progs/ripple.spr");
	setmodel (ripple, "progs/ripple.spr");
	setsize(ripple, '-1 -1 -1', '1 1 1');
	setorigin (ripple, org);

	ripple.movetype = MOVETYPE_NOCLIP;
	ripple.solid = SOLID_NOT;

	ripple.hitcontentsmaski = CONTENTBIT_WATER | CONTENTBIT_SLIME | CONTENTBIT_LAVA;
	ripple.angles_x = 90;
	ripple.scale = 0.1;
	ripple.alpha = 1;
	ripple.cnt = type;

	if (!self.cnt)
		ripple.colormod = '1 1 1.25';
	else if (self.cnt == 1)
		ripple.colormod = '1 .25 .25';
	else
		ripple.colormod = '.25 1 .25';

	ripple.think = ripple_think;
	ripple.nextthink = time;
	if (own.classname == "player" && own.owner)
		ripple.drawonlytoclient = own.owner; // reduce network traffic
};

//
// Spawns a dynamic light for colored light glowing
//

void() glowy_think =
{
	// HACK this is the only method I've found to actually remove
	// the dynamic light entity properly, otherwise it starts to randomly
	// assign itself to other entities.
	if (self.owner.solid == SOLID_NOT || (self.owner.flags & FL_MONSTER && (self.owner.berserk_finished < time || self.owner.health < 0)))
	{
		self.pflags = 0;
		self.light_lev = 0;
		self.color = [0,0,0];
		remove(self);
		return;
	}
	
	makevectors(self.owner.angles);

	if (self.owner.classname == "cursor") // Move down cursors/perfect guard icon glow
		setorigin (self, self.owner.origin - v_up * 42);
	else
		setorigin (self, self.owner.origin + v_up * 10); // move slightly above ground

// Old code
/*
	if (!self.owner.flags & FL_ITEM) // Items don't move
		setorigin (self, self.owner.origin + v_up * 10); // move slightly above ground

	if (self.owner.classname == "cursor") // Move down cursors/perfect guard icon glow
			setorigin (self, self.owner.origin - v_up * 42);
*/
	frameskip(0.01);
};

void(float r, float g, float b, float light, entity spawner) spawn_color_glow =
{
	local entity glowy;
	
	glowy = spawn();

	glowy.movetype = MOVETYPE_NOCLIP;
	setorigin (glowy, spawner.origin + v_up*10);
	setmodel (glowy, "progs/null.spr");
	setsize (glowy, '0 0 0', '0 0 0');
	glowy.solid = SOLID_NOT;
	glowy.classname = "glowy";
	glowy.owner = spawner;
	
	// Give off RT Light
	glowy.pflags = PFLAGS_FULLDYNAMIC;
	glowy.light_lev = light;
	glowy.color = [r, g, b];
	
	glowy.think = glowy_think;
	glowy.nextthink = time + 0.1;
};

//
// Display Signs over Vigil
//

void() DisplaySignThink =
{
	local vector x;

	x = self.owner.angles;
	x_z = 0;
	makevectors(x);

	if (self.mode == 0)
	{
		if (self.attack_finished > time)
			self.angles_z = self.angles_z + 1500 * frametime;
		else
		{
			if (self.angles_z != 0)
			{
				self.mode = 1;
				self.attack_finished = time + 1;
				self.angles_z = 0;
			}
		}
	}
	else if (self.mode == 1)
	{
		if (self.attack_finished < time)
		{
			self.angles_z = self.angles_z - 1500 * frametime;
			self.velocity_y = -150;
	        if (self.alpha > 0.1)
			{
				self.effects = EF_NODEPTHTEST | EF_FULLBRIGHT | EF_ADDITIVE;
				self.alpha = self.alpha - 0.01;
			}
			else
			{
				remove(self);
				return;	
			}
		}
	}

	if (self.mode == 0 || self.attack_finished > time)
	{
		self.origin_x = self.owner.origin_x;
		self.origin_y = self.owner.origin_y;		
		self.origin_z = self.owner.origin_z + 48;
	}
	frameskip(0.01);
};

void(entity targ) DisplayArmor =
{
	local entity armoru;

	armoru = spawn();
	setorigin(armoru, targ.origin + v_up*48);
	setmodel(armoru, "progs/armorup.spr");
	setsize(armoru, '0 0 0', '0 0 0');
	armoru.solid = SOLID_NOT;
	armoru.owner = targ;
	armoru.takedamage = DAMAGE_NO;
	armoru.classname = "armorsign";
	armoru.movetype = MOVETYPE_NOCLIP;
	armoru.angles_y = -90; // face camera
	armoru.alpha = 1;
	armoru.attack_finished = time + 1;
	armoru.fixangle = TRUE;
	armoru.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
	armoru.think = DisplaySignThink;
	armoru.nextthink = time;
};

void(entity targ) DisplaySword =
{
	local entity swordu;

	swordu = spawn();
	setorigin(swordu, targ.origin + v_up*48);
	setmodel(swordu, "progs/volup.spr");
	setsize(swordu, '0 0 0', '0 0 0');
	swordu.solid = SOLID_NOT;
	swordu.owner = targ;
	swordu.takedamage = DAMAGE_NO;
	swordu.classname = "swordsign";
	swordu.movetype = MOVETYPE_NOCLIP;
	swordu.angles_y = -90; // face camera
	swordu.alpha = 1;
	swordu.attack_finished = time + 1;
	swordu.fixangle = TRUE;
	swordu.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
	swordu.think = DisplaySignThink;
	swordu.nextthink = time;
};

float title1_finished;

// Called from QuakeC
void(float howmuch) shake_camera =
{
	if (!howmuch)
		howmuch = 1;

	local entity y;

	y = find(world, classname, "camera");
	while(y)
	{
		y.camshake_finished = time + howmuch;
		y = find(y, classname, "camera");
	}
	y = find(world, classname, "camera");
};

// Fired from a misc_camshake entity
void() misc_shake_camera =
{
	local entity y;

	// Don't allow camera shake on level changes
	if (framecount < 7)
		return;

	y = find(world, classname, "camera");
	while(y)
	{
		y.camshake_finished = time + self.cnt;
		y = find(y, classname, "camera");
	}
	y = find(world, classname, "camera");
};

// Fire at it with a trigger_once/multiple/whatever
// uses .cnt to shake all cameras for # amount of seconds
void() misc_camshake =
{
	self.use = misc_shake_camera;
};

//
// Play a sound when triggered
//
void() misc_sound_use =
{
	if (!self.cnt)
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	else
		sound (self, CHAN_AUTO, self.noise, 1, ATTN_NONE);
};

void() misc_sound =
{
	if (!self.noise)
		error("misc_sound entity without noise set\n");
	
	precache_sound (self.noise);
	self.use = misc_sound_use;
};

/*
* misc_model.qc
*
* Author: Joshua Skelton joshua.skelton@gmail.com
*/

.float first_frame; // The starting frame of the animation
.float last_frame; // The ending frame of the animation

void() misc_model_think =
{
    self.nextthink = time + fabs(self.speed);
    self.frame = self.frame + sign(self.speed);
    self.frame = wrap(self.frame, self.first_frame, self.last_frame);
};

/*
* misc_model
*
* An entity for displaying models. A frame range can be given to animate the
* model.
*
* mdl: The model to display. Can be of type mdl, bsp, or spr.
* frame: The frame to display. Can be used to offset the animation.
* first_frame: The starting frame of the animation.
* last_frame: The last frame of the animation.
*/

void() misc_model =
{
    precache_model(self.model);
    setmodel(self, self.model);

    if (self.first_frame)
		self.frame = self.first_frame;
	
    // Only animate if given a frame range
    if (!self.last_frame)
        return;

	// Randomize start from between first/last frame
	if (self.spawnflags & 1)
	{
		self.frame = self.first_frame;
		local float diff;
		diff = self.last_frame - self.first_frame;

		self.frame = self.frame + ceil(random()*diff);
	}
	
    // Default animation speed to 10 fps
    if (!self.speed)
        self.speed = 10 / 60;

	self.nextthink = time + self.speed;
	self.think = misc_model_think;
};

/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void() t_movetarget =
{
local entity	temp;

	if (other.movetarget != self)
		return;
	
	if (other.enemy)
		return;		// fighting, not following a path

	temp = self;
	self = other;
	other = temp;

	self.goalentity = self.movetarget = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if (!self.movetarget)
	{
		self.pausetime = time + 999999;
		self.th_stand ();
		return;
	}
};

void() movetarget_f =
{
	if (!self.targetname)
		objerror ("monster_movetarget: no targetname");
		
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
	
};

/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
*/
void() path_corner =
{
	movetarget_f ();
};

/*QUAKED ambience_speaker (0 1 0) (-10 -10 -10) (10 10 10)
ambience_speaker allows any ambience sound to be put into a map
"model":
define the sounds path and name here

* it's important that ambience sounds should be placed near the camera
*/
void() ambience_speaker =
{
	precache_sound (self.model);
	ambientsound(self.origin, self.model, 1, ATTN_STATIC);
};

// tilt an entity according to the geometry below them
void() model_tilt =
{
	local vector v1, v2;
	local vector l1, l2;
	local vector v, k;

	self.angles_x = 0;
	makevectors(self.angles);

	v1 = self.origin + v_forward * 16;
	v2 = self.origin + v_forward * -16;

	traceline (v1 + '0 0 64', v1 - '0 0 64', TRUE,  self);
	l1 = trace_endpos;
	traceline (v2 + '0 0 64', v2 - '0 0 64', TRUE, self);
	l2 = trace_endpos;

	v = l1 - l2;
	k = vectoangles(v);

	self.angles_x = k_x;
};

/*QUAKED ambience_waterfall (0 1 0) (-10 -10 -10) (10 10 10)
a large waterfall
* it's important that ambience sounds should be placed near the camera
*/

void() ambience_waterfall =
{
	precache_sound ("ambience/waterfall.wav");
	ambientsound(self.origin, "ambience/waterfall.wav", 1, ATTN_STATIC);
};

/*QUAKED ambience_lava (0 1 0) (-10 -10 -10) (10 10 10)
lava sounds
* it's important that ambience sounds should be placed near the camera
*/

void() ambience_lava =
{
	precache_sound ("ambience/lava.wav");
	ambientsound(self.origin, "ambience/lava.wav", 1, ATTN_STATIC);
};

/*QUAKED ambience_rain (0 1 0) (-10 -10 -10) (10 10 10)
rain sound
* it's important that ambience sounds should be placed near the camera
*/

void() ambience_rain =
{
	precache_sound ("ambience/rain.wav");
	ambientsound(self.origin, "ambience/rain.wav", 1, ATTN_STATIC);
};

/*QUAKED ambience_river (0 1 0) (-10 -10 -10) (10 10 10)
a running river ambience sound
* it's important that ambience sounds should be placed near the camera
*/
void() ambience_river =
{
	precache_sound ("ambience/river.wav");
	ambientsound(self.origin, "ambience/river.wav", 1, ATTN_STATIC);
};

/*QUAKED ambience_waterdrops (0 1 0) (-10 -10 -10) (10 10 10)
a water drop ambience sound
* it's important that ambience sounds should be placed near the camera
*/

void() ambience_waterdrops =
{
	precache_sound ("ambience/drip1.wav");
	ambientsound(self.origin, "ambience/drip1.wav", 1, ATTN_STATIC);
};

/*QUAKED ambience_suffering (0 1 0) (-10 -10 -10) (10 10 10)
ambience_suffering is an ambient sound of a person moaning
from past tortures
* it's important that ambience sounds should be placed near the camera
*/

void() ambience_suffering =
{
	precache_sound ("misc/suffer.wav");
	ambientsound(self.origin, "misc/suffer.wav", 1, ATTN_STATIC);
};

void() ambience_heartbeat_think =
{
	// Boss defeated, heart beat sound perma-removed
	if (bosses & IT_BOSS1 && world.model == "maps/boss1.bsp")
	{
		remove(self);
		return;
	}
	if (bosses & IT_BOSS2 && world.model == "maps/boss2.bsp")
	{
		remove(self);
		return;
	}

	sound (self, CHAN_VOICE, "misc/heart.wav", 2, ATTN_NORM);
	self.nextthink = time + 2;
};

//
// called when bosses 'wake up'
//
void() heartbeat_remove =
{
	local entity y;

	y = find(world, classname, "heartbeat");
	while (y)
	{
		if (y != world)
		{
			y.think = SUB_Remove;
			y.nextthink = time + 0.1;
			return;
		}
		y = find(world, classname, "heartbeat");	
	}
	y = find(world, classname, "heartbeat");
};

/*QUAKED ambience_heartbeat (0 1 0) (-10 -10 -10) (10 10 10)
ambience_heartbeat, pretty self explanatory ... targetname will
cause it to remove itself, usually used when a boss wakes up the
heartbeat should be removed.
* it's important that ambience sounds should be placed near the camera
*/
void() ambience_heartbeat =
{
	precache_sound ("misc/heart.wav");
	self.classname = "heartbeat";
	self.think = ambience_heartbeat_think;
	self.use = SUB_Remove;
	self.nextthink = time + 1;
};

/*QUAKED ambience_thunder (0 1 0) (-10 -10 -10) (10 10 10)
ambience_thunder is an ambient sound of stormy weather, suitable with lightning
entities also; only one of this entity is required as it plays over the whole map
*/
void() ambience_thunder =
{
	precache_sound ("ambience/thunder.wav");
	ambientsound(self.origin, "ambience/thunder.wav", 1, ATTN_NONE);
};

void() fire_remove1 =[ 0, fire_remove2] 
{
	sound (self, CHAN_BODY, "misc/fireout.wav", 1, ATTN_NONE);
	frameskip(0.05);
};
void() fire_remove2 =[ 1, fire_remove3] {frameskip(0.05);};
void() fire_remove3 =[ 2, fire_remove4] {frameskip(0.05);};
void() fire_remove4 =[ 3, fire_remove5] {frameskip(0.05);};
void() fire_remove5 =[ 4, fire_remove6] {frameskip(0.05);};
void() fire_remove6 =[ 5, fire_remove7] {frameskip(0.05);};
void() fire_remove7 =[ 6, SUB_Remove] {frameskip(0.05);};

void() BecomeFlame =
{
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	setorigin(self, self.origin + v_up*10);
	setmodel (self, "progs/fire.spr");
	fire_remove1();
	spawn_embers();
};

/*
// Shadows have been disabled as FTE handles shadow blobs
// in-game engine and are done a lot nicer.

// shadows underneath entities
void() shadow_tilt =
{
	local vector v1, v2, l1, l2, v, k, p;

	p = self.owner.angles;
	p_y = 180;
	makevectors(p);

	v1 = self.owner.origin + v_forward * 16;
	v2 = self.owner.origin + v_forward * -16;

	traceline (v1 + '0 0 64', v1 - '0 0 64', TRUE,  self);
	l1 = trace_endpos;
	traceline (v2 + '0 0 64', v2 - '0 0 64', TRUE, self);
	l2 = trace_endpos;

	v = l1 - l2;
	k = vectoangles(v);

	self.angles_x = k_x + 90;

	if ((k_x == 45 || k_x == 270 || k_x == 90 || k_x == 315) && self.owner.onground == FALSE)
	{
		setmodel(self, string_null);
	}
	else
	{
		setmodel(self, "progs/shadow.spr");
	}
};

void() shadow_think = 
{
	shadow_tilt();
	self.alpha = 0.5;
	self.origin_x = self.owner.origin_x;
	self.origin_y = self.owner.origin_y;

	traceline (self.owner.origin, self.origin - v_up * 9999, TRUE, self);

	self.origin_z = trace_endpos_z + 1;
	if (self.owner.health < 1 && self.owner.classname != "player")
	{
		remove(self);
		return;
	}

	setsize (self, '0 0 0', '0 0 0');
	self.nextthink = time + 0.01;
};

void() spawn_shadow =
{
	local entity s;

	s = spawn();

	s.owner = self;
	setorigin(s, s.owner.origin);
	setmodel(s, "progs/shadow.spr");
	setsize (s, '0 0 0', '0 0 0');
	s.movetype = MOVETYPE_NOCLIP;
	s.solid = SOLID_NOT;
	s.classname = "shadow";
	s.think = shadow_think;
	s.angles_x = 90;
	s.nextthink = time + 0.01;
};
*/

//
// Silly little function to fix music_track# entities playing properly
//
void() music_track_play =
{
	localcmd ("music ", self.netname, "\n");
};

/*QUAKED music_track0 (0 1 0) (-10 -10 -10) (10 10 10)
Map02's music
*/
void() music_track0 =
{
	precache_sound ("music/track0.ogg");
	self.netname = "sound/music/track0.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track1 (0 1 0) (-10 -10 -10) (10 10 10)
play the wilderness music in the level
*/
void() music_track1 =
{
	precache_sound ("music/track1.ogg");
	self.netname = "sound/music/track1.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track2 (0 1 0) (-10 -10 -10) (10 10 10)
play the first castle levels music in the level
*/
void() music_track2 =
{
	precache_sound ("music/track5.ogg");
	self.netname = "sound/music/track5.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track3 (0 1 0) (-10 -10 -10) (10 10 10)
play the first dungeon music in the level
*/
void() music_track3 =
{
	precache_sound ("music/track6.ogg");
	self.netname = "sound/music/track6.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track4 (0 1 0) (-10 -10 -10) (10 10 10)
play the second level of the castles music in the level
*/
void() music_track4 =
{
	precache_sound ("music/track7.ogg");
	self.netname = "sound/music/track7.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track5 (0 1 0) (-10 -10 -10) (10 10 10)
play arena1's music
*/
void() music_track5 =
{
	precache_sound ("music/track8.ogg");
	self.netname = "sound/music/track8.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track6 (0 1 0) (-10 -10 -10) (10 10 10)
play boss music
*/
void() music_track6 =
{
	precache_sound ("music/track9.ogg");
	self.netname = "sound/music/track9.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track7 (0 1 0) (-10 -10 -10) (10 10 10)
play tower music
*/
void() music_track7 =
{
	precache_sound ("music/track10.ogg");
	self.netname = "sound/music/track10.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track8 (0 1 0) (-10 -10 -10) (10 10 10)
play village music
*/
void() music_track8 =
{
	precache_sound ("music/track11.ogg");
	self.netname = "sound/music/track11.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track9 (0 1 0) (-10 -10 -10) (10 10 10)
play castle entrance music
*/
void() music_track9 =
{
	precache_sound ("music/track12.ogg");
	self.netname = "sound/music/track12.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track10 (0 1 0) (-10 -10 -10) (10 10 10)
play cavern music
*/
void() music_track10 =
{
	precache_sound ("music/track13.ogg");
	self.netname = "sound/music/track13.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track11 (0 1 0) (-10 -10 -10) (10 10 10)
play transporter/teleporter room music
*/
void() music_track11 =
{
	precache_sound ("music/track14.ogg");
	self.netname = "sound/music/track14.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

/*QUAKED music_track12 (0 1 0) (-10 -10 -10) (10 10 10)
play the outer wall music in the level
*/
void() music_track12 =
{
	precache_sound ("music/track15.ogg");
	self.netname = "sound/music/track15.ogg";
	self.classname = "music";
	self.think = music_track_play;
	self.nextthink = time + 1.25;
};

//===
// title screen map stuff
//===

void() misc_title1_think =
{
	if (title1_finished > time)
	{
		self.velocity_y = -1000; // Shoot back from title screen properly
		self.effects = 0;

		self.scale = self.scale - 0.005;
		if (self.alpha > 0)
			self.alpha = self.alpha - 0.0055;
		else
			setmodel (self, "progs/null.spr");

		self.angles_z = self.angles_z + 5; // spin
	}
	else
	{
		self.angles_y = -90 + sin(time*0.45)*4;
		self.angles_z = sin(time*0.45)*4;
	}
	if (self.mode == 0)
	{
		if (self.origin_z > self.cnt2)
		{
			self.origin_z = self.origin_z - self.speed;
			self.speed = self.speed + 0.05;
		}
		else
		{
			self.cnt2 = self.cnt2 + 150;
			self.mode = 1;
		}
	}
	else if (self.mode == 1)
	{
		self.origin_z = self.origin_z + self.speed;
		self.speed = self.speed - 0.1;
		if (self.speed <= 0 && self.origin_z <= self.cnt)
		{
			self.mode = 2;
			self.speed = 0;
			if (title1_finished < time)
			{
				sound (self, CHAN_AUTO, "misc/title.wav", 0.85, ATTN_NONE);
				sound (self, CHAN_AUTO, "misc/titlesay.wav", 1, ATTN_NONE);
			}
		}
	}
	frameskip(0.01);
};

void() misc_title1 =
{
	precache_sound ("misc/title.wav");
	precache_sound ("misc/titlesay.wav");
	precache_sound ("misc/title2.wav");
	setmodel (self, "progs/title.spr");
	self.mode = 0;
	self.speed = 1;
	self.movetype = MOVETYPE_NOCLIP;
	self.cnt = self.origin_z;
	self.cnt2 = self.cnt;
	self.origin_z = self.origin_z + 300;
	self.angles_y = -90;
	self.effects = EF_NODEPTHTEST;
	self.think = misc_title1_think;
	self.nextthink = time;
	self.scale = self.alpha = 1;
};

void() title2_think =
{
	if (title1_finished > time)
		self.mode = TRUE;

	if (self.mode != TRUE) // stop moving if true
	{
		if (self.attack_finished < time)
		{
			self.origin_x = self.cnt;
			self.attack_finished = time + 4.5;
		}
		self.origin_x = self.origin_x + 1;
	}
	else
	{
		self.origin_x = self.cnt2;
		if (self.scale > 0.01)
			self.scale = self.scale - 0.01;
	}

	if (title1_finished < time && self.mode == 1)
		changelevel ("menu");

	frameskip (0.01);
};

void() misc_title2 =
{
	setmodel (self, "progs/title2.spr");
	self.think = title2_think;
	self.cnt2 = self.origin_x;
	self.origin_x = self.origin_x - 175;
	self.cnt = self.origin_x;
	self.nextthink = time;
	self.scale = 1;
	self.effects = EF_NODEPTHTEST;
};

//===
// introduction misc
//===

void() intro_dummy =
{
	precache_model ("progs/intro.spr"); // precache this in here for ram saving
	precache_model ("progs/vigintro.mdl"); // precache this in here for ram saving
	precache_sound ("misc/title2.wav");
	precache_sound ("music/track3.ogg"); // precache this in here for ram saving

	setmodel (self, "progs/vigintro.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.classname = "cameratarget";
	droptofloor();
};

void() intro_text_think =
{
	localsound("misc/introsay", 4, 1);
};

// introduction text that tells the games story
void() intro_text =
{
	setmodel (self, "progs/intro.spr");
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.velocity_z = 5; // move upward slowly
	self.effects = EF_NODEPTHTEST;
	self.think = intro_text_think;
	self.nextthink = time + 6; // narrator speak time
};


/*QUAKED sign_roll_right (0 1 0) (-10 -10 -10) (10 10 10)
A sign saying "Roll" with an arrow pointing right
* Can be switch on/off by targetting
*/

void() sign_roll_right_think =
{
	if (self.mode)
	{
		if (self.alpha < 1)
		{
			self.alpha = self.alpha + 0.005;
			setmodel (self, "progs/sign_rol.spr");
		}
		else
		{
			self.alpha = 1;
			if (self.pain_finished < time && self.alpha == 1) // blink the sign
			{
				if (!self.lip)
				{
					setmodel (self, "progs/null.spr");
					self.lip = TRUE;
				}
				else
				{
					setmodel (self, "progs/sign_rol.spr");
					self.lip = FALSE;
				}
				self.pain_finished = time + 0.4;
			}
		}
	}
	else
	{
		if (self.alpha > 0)
			self.alpha = self.alpha - 0.005;
		else
		{
			self.alpha = 0;
			setmodel (self, "progs/null.spr");
		}
	}
	
	frameskip(0.01);
};

void() sign_roll_right_use =
{
	if (!self.mode)
		self.mode = TRUE;
	else
	{
		setmodel (self, "progs/sign_rol.spr");
		self.mode = FALSE;
		self.lip = FALSE;
	}
};

void() sign_roll_right =
{
	precache_model("progs/null.spr");
	precache_model("progs/sign_rol.spr");
	setmodel (self, "progs/null.spr");
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.effects = EF_NODEPTHTEST | EF_ADDITIVE;
	self.think = sign_roll_right_think;
	self.nextthink = time + 0.1;
	self.use = sign_roll_right_use;
	self.mode = 0;
	self.alpha = 0;
	self.lip = FALSE;
	self.scale = .5;
};

/*QUAKED sign_attack_down (0 1 0) (-10 -10 -10) (10 10 10)
A sign saying "Attack!" with an arrow pointing down
* Can be switch on/off by targetting
*/

void() sign_attack_down_think =
{
	if (self.mode)
	{
		if (self.alpha < 1)
		{
			self.alpha = self.alpha + 0.005;
			setmodel (self, "progs/sign_atk.spr");
		}
		else
		{
			self.alpha = 1;
			if (self.pain_finished < time && self.alpha == 1) // blink the sign
			{
				if (!self.lip)
				{
					setmodel (self, "progs/null.spr");
					self.lip = TRUE;
				}
				else
				{
					setmodel (self, "progs/sign_atk.spr");
					self.lip = FALSE;
				}
				self.pain_finished = time + 0.4;
			}
		}
	}
	else
	{
		if (self.alpha > 0)
			self.alpha = self.alpha - 0.005;
		else
		{
			self.alpha = 0;
			setmodel (self, "progs/null.spr");
		}
	}
	
	frameskip(0.01);
};

void() sign_attack_down_use =
{
	if (!self.mode)
		self.mode = TRUE;
	else
	{
		setmodel (self, "progs/sign_atk.spr");
		self.mode = FALSE;
		self.lip = FALSE;
	}
};

void() sign_attack_down =
{
	precache_model("progs/null.spr");
	precache_model("progs/sign_atk.spr");
	setmodel (self, "progs/null.spr");
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.effects = EF_NODEPTHTEST | EF_ADDITIVE;
	self.think = sign_attack_down_think;
	self.nextthink = time + 0.1;
	self.use = sign_attack_down_use;
	self.mode = 0;
	self.alpha = 0;
	self.lip = FALSE;
	self.scale = .5;
};

/*
==============================================================================

GRAPHICAL MENU INTERFACE

==============================================================================
*/

.float menu_debounce, menu_declick; // boolean to make the menu less sensitive
.float menu_choice; // what choice the user is on
.float menu_which;  // which menu the player is currently on
				    // 0 = Main menu
                    // 1 = Option menu

void() MenuCommands =
{
	if (self.angles_x != 0)
		self.angles_x = 0;
	self.fixangle = TRUE;

	local entity y, h;
	h = world;

	// Only host/player 1 can move the menu
	if (self.playerid != 1)
		return;

	// Menu cursor movement
	if (self.keyflags & (KEY_DOWN | KEY_UP))
	{
		if (self.menu_debounce == FALSE)
		{
			y = find(world, classname, "menu");
			while(y)
			{
				if (y.menu_which == 0)
				{
					if (self.keyflags & KEY_DOWN)
					{
						if (y.menu_choice < 3)
							y.menu_choice = y.menu_choice + 1; // move down the list
						else
							y.menu_choice = 0;
					}
					else if (self.keyflags & KEY_UP)
					{
						if (y.menu_choice > 0)
							y.menu_choice = y.menu_choice - 1; // move up the list
						else
							y.menu_choice = 3;
					}
				}
				else if (y.menu_which == 1)
				{
					if (self.keyflags & KEY_DOWN)
					{
						if (y.menu_choice < 6)
							y.menu_choice = y.menu_choice + 1; // move down the list
						else
							y.menu_choice = 0;
					}
					else if (self.keyflags & KEY_UP)
					{
						if (y.menu_choice > 0)
							y.menu_choice = y.menu_choice - 1; // move up the list
						else
							y.menu_choice = 6;
					}
				}

				sound (self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NORM);
				y = find(y, classname, "menu");
			}
		}
		self.menu_debounce = TRUE;
		self.cnt2 = time + 0.05;
	}
	else // fixed for DP by adding cnt2 time checking
	{
		if (self.cnt2 < time)
			self.menu_debounce = FALSE;
	}

	// Menu select code
	if (self.button0)
	{
		if (self.menu_declick == FALSE)
		{
			h = find(world, classname, "cursor");
			y = find(world, classname, "menu");
			{
				if (y.menu_which == 0)
				{
					//cvar_set ("con_notify_w", "0");
					if (h.owner.menu_choice == 0) // Start new game
						changelevel ("map01");
					else if (h.owner.menu_choice == 1) // Load game
						stuffcmd (self, "menu_load\n");
					else if (h.owner.menu_choice == 2) // Switch to option menu
					{
						//stuffcmd (self, "con_notify_w 1\n"); // Allow sprint to show on options screen
						h.owner.menu_which = 1;
						h.owner.menu_choice = 0; // Reset cursor to 0
					}
					else if (h.owner.menu_choice == 3) // Quit
						stuffcmd (self, "quit\n");
				}
				else if (y.menu_which == 1)
				{
					//cvar_set ("con_notify_w", "1"); // Allow sprint to show on options screen
					if (h.owner.menu_choice == 0) // Difficulty
					{
						if (menu_difficulty < 2)
						{
							menu_difficulty = menu_difficulty + 1;
							if (menu_difficulty == 1)
							{
								setpause(1);
								centerprint (self, "/PDifficulty set to ^3Vigilant^7\n\nEnemies have 50% more health\nEnemies are smarter\nRemixed encounters and item placement");
								localcmd ("skill 2\n");
							}
							else if (menu_difficulty == 2)
							{
								setpause(1);
								centerprint (self, "/PDifficulty set to ^3Casual^7\n\nEnemies do 75% of normal damage\nHealth potions give 25% more");
								localcmd ("skill 0\n");
							}
						}
						else
						{
							setpause(1);
							centerprint (self, "/PDifficulty set to ^3Normal^7 (default)");
							localcmd ("skill 1\n");
							menu_difficulty = 0;
						}
					}
					if (h.owner.menu_choice == 1) // Turbo Mode Toggle
					{
						if (menu_turbo < 1)
						{
							turbo_mode = TRUE;
							menu_turbo = menu_turbo + 1;
							setpause(1);
							centerprint (self, "/PTurbo Mode set to ^3On^7\n\nIncreases game speed by 25%");
						}
						else
						{
							turbo_mode = FALSE;
							menu_turbo = 0;
							setpause(1);
							centerprint (self, "/PTurbo Mode set to ^3Off^7 (default)");
						}
					}
					if (h.owner.menu_choice == 2) // Seizure Effects Toggle
					{
						if (menu_seizurefx < 1)
						{
							localcmd ("scratch1 1\n");
							menu_seizurefx = menu_seizurefx + 1;
							setpause(1);
							centerprint (self, "/PSeizure Effects (screen flash) set to ^3Off^7");
						}
						else
						{
							localcmd ("scratch1 0\n");
							menu_seizurefx = 0;
							setpause(1);
							centerprint (self, "/PSeizure Effects (screen flash) set to ^3On^7 (default)");
						}
					}
					if (h.owner.menu_choice == 3) // Volume
					{
						if (menu_volume < 3)
						{
							menu_volume = menu_volume + 1;
							if (menu_volume == 1)
							{
								setpause(1);
								centerprint (self, "/PSound volume set to ^3Loud^7");
								stuffcmd (self, "volume 1\n");
							}
							if (menu_volume == 2)
							{
								setpause(1);
								centerprint (self, "/PSound volume set to ^3Off^7");
								stuffcmd (self, "volume 0\n");
							}
							if (menu_volume == 3)
							{
								setpause(1);
								centerprint (self, "/PSound volume set to ^3Soft^7");
								stuffcmd (self, "volume 0.3\n");
							}
						}
						else
						{
							menu_volume = 0;
							setpause(1);
							centerprint (self, "/PSound volume set to ^3Normal^7 (default)");
							stuffcmd (self, "volume 0.5\n");
						}
					}
					if (h.owner.menu_choice == 4) // Combo Counter Toggle
					{
						if (menu_ccounter < 1)
						{
							localcmd ("scratch2 1\n");
							menu_ccounter = menu_ccounter + 1;
							setpause(1);
							centerprint (self, "/PCombo Counter HUD set to ^3Off^7");
						}
						else
						{
							localcmd ("scratch2 0\n");
							menu_ccounter = 0;
							setpause(1);
							centerprint (self, "/PCombo Counter HUD set to ^3On^7 (default)");
						}
					}
					if (h.owner.menu_choice == 5) // Camera toggle
					{
						if (menu_camera < 1)
						{
							localcmd ("scratch3 1\n");
							menu_camera = menu_camera + 1;
							setpause(1);
							centerprint (self, "/PCamera set to ^3Classic^7\n\nChanges the camera behavior to follow Vigil forward facing only");
						}
						else
						{
							localcmd ("scratch3 0\n");
							menu_camera = 0;
							setpause(1);
							centerprint (self, "/PCamera set to ^3Dynamic^7 (default)\n\nChanges the camera behavior to follow Vigil with additional movement");
						}
					}

					if (h.owner.menu_choice == 6) // Switch to main menu
					{
						//stuffcmd (self, "con_notify_w 0\n"); // Disallow sprint to show on options screen
						h.owner.menu_which = 0;
						h.owner.menu_choice = 0; // Reset cursor to 0
					}
				}
				sound (self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NORM);
				self.menu_declick = TRUE;
			}
		}
		h = find(h, classname, "cursor");
	}
	else
		self.menu_declick = FALSE;
};

void() cursor_think =
{
	if (self.attack_finished < time)
	{
		if (self.frame < 11)
			self.frame = self.frame + 1;
		else
			self.frame = 0;
		self.attack_finished = time + 0.1;

		if (self.mode == FALSE) // grow
		{
			self.scale = self.scale + 0.05;
			if (self.scale > 1.3)
				self.mode = TRUE;
		}
		else // shrink
		{
			self.scale = self.scale - 0.05;
			if (self.scale < 0.7)
				self.mode = FALSE;
		}
	}

	if (self.origin_y != self.owner.origin_y)
		self.origin_y = self.owner.origin_y;

	if (self.owner.menu_which == 0) // main menu
	{
		self.origin_x = self.owner.origin_x + 57;
		if (self.owner.menu_choice == 0)
			self.origin_z = self.owner.origin_z - 50; // put cursor at original position
		else if (self.owner.menu_choice == 1)
			self.origin_z = self.owner.origin_z - 65;
		else if (self.owner.menu_choice == 2)
			self.origin_z = self.owner.origin_z - 80;
		else if (self.owner.menu_choice == 3)
			self.origin_z = self.owner.origin_z - 95;
	}
	else if (self.owner.menu_which == 1) // option menu
	{
		if (self.owner.menu_choice != 7)
			self.origin_x = self.owner.origin_x + 65;
		else
			self.origin_x = self.owner.origin_x + 40;

		if (self.owner.menu_choice == 0)
			self.origin_z = self.owner.origin_z - 10; // put cursor at original position
		else if (self.owner.menu_choice == 1)
			self.origin_z = self.owner.origin_z - 25;
		else if (self.owner.menu_choice == 2)
			self.origin_z = self.owner.origin_z - 39;
		else if (self.owner.menu_choice == 3)
			self.origin_z = self.owner.origin_z - 52;
		else if (self.owner.menu_choice == 4)
			self.origin_z = self.owner.origin_z - 65;
		else if (self.owner.menu_choice == 5)
			self.origin_z = self.owner.origin_z - 80;
		else if (self.owner.menu_choice == 6)
			self.origin_z = self.owner.origin_z - 115;
	}
	frameskip(0.01);
};

void() menuscreen_think =
{
	if (self.menu_which == 0)
		setmodel (self, "progs/menu1.spr");
	else if (self.menu_which == 1)
		setmodel (self, "progs/menu2.spr");
		
	self.nextthink = time;
};

void() misc_menu1 =
{
	local entity cursor;

	precache_model ("progs/menu1.spr");
	precache_model ("progs/menu2.spr");
	precache_model ("progs/cursor.spr");
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");

	self.classname = "menu";
	self.think = menuscreen_think;
	self.nextthink = time + 0.01;

	precache_sound ("music/track4.ogg");
	ambientsound ('0 0 0', "music/track4.ogg", 1, ATTN_NONE);
	
	// Spawn cursor
	cursor = spawn();
	cursor.owner = self;
	cursor.classname = "cursor";
	setorigin(cursor, self.origin);
	setmodel(cursor, "progs/cursor.spr");
	cursor.scale = 1;
	cursor.think = cursor_think;
	cursor.nextthink = time;
};

/*QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for lightning.
*/
void() info_notnull = {};