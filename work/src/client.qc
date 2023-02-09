//+------+
//|Client|
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-f=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Handle's "clients" (eg, Players) connecting, disconnecting, etc.           |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

void() CheckImpulseButtons;        // From Misc/Impulses.QC
void() player_think;

float(float v) anglemod2 =
{
	return v - floor(v/360) * 360;
};

float (float y1, float y2) angcomp = 
{
	local float answer;
	
	y1 = anglemod2(y1);
	y2 = anglemod2(y2);

	answer = y1 - y2;
	if (answer > 180)
		answer = answer - 360;
	else if (answer < -180)
		answer = answer + 360;
	return answer;
};

//
// TAoV's main camera
// Credit goes to: FrikaC, Reki, RennyC
//

.float cam_zcheck; // check up
.float zoom; // special zooming sent from trigger
.vector new_zoom; // special zooming sent from trigger
.vector origin_zoom; // store original cam Y pos for comparisons
.vector campos; // envenom camera style
.float camerastyle_old;
.float stylechange_time;
.float stylechange_length;
.float stylechange_angle;
void() InitCamera =
{
	local vector view, view2, ot, spot;
	local float bt, r;
	local entity y;
			
	//
	// Camera Underwater sound + fog
	//

	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_LAVA || pointcontents(self.origin) == CONTENT_SLIME)
	{
		if (self.sound_finished < time)
		{
			sound (self, CHAN_VOICE, "player/camh2o.wav", 1, ATTN_NORM);
			self.sound_finished = time + 9.9;
		}
		if (!self.cam_inwater)
		{
			if (self.fog != "0" && self.fog != "1 0 0 0.3 0.5 0" && self.fog != "1 1 0 0 0.5 0" && self.fog != "1 0 0.5 0 0.5 0")
				self.ofog = self.fog; // record old fog value that isn't water/lava/slime

			if (pointcontents(self.origin) == CONTENT_WATER)
				self.fog = "1 0 0 0.3 0.5 0";
			else if (pointcontents(self.origin) == CONTENT_LAVA)
				self.fog = "1 1 0 0 0.5 0";
			else if (pointcontents(self.origin) == CONTENT_SLIME)
				self.fog = "1 0 0.5 0 0.5 0";

			stuffcmd(self, sprintf("fog %s\n", self.fog));
			self.cam_inwater = TRUE; // Send to CSQC
		}
	}
	else
	{
		if (self.sound_finished > time)
		{
			sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
			self.sound_finished = time;
		}
		if (self.cam_inwater)
		{
			self.cam_inwater = FALSE; // Send to CSQC
			stuffcmd(self, sprintf("fog %s\n", self.ofog));
		}
	}
	
	//
	// Camera shake effect
	//

	if (self.camshake_finished > time)
	{
		local float s = random() * 4; // shake camera value
		if (random() < 0.5)
			self.punchangle_x = s;
		else
			self.punchangle_x = (s * -1);
	}
	
	spot = self.goalentity.origin;
	spot_y = 0;

	if (self.spawnflags & 2) // Camera doesn't move in transition rooms
		return;
	if (self.purge_toggle) // Camera doesn't move during purge attack
		return;

	view = vectoangles(self.goalentity.origin - self.origin);
	view2 = vectoangles(self.smooth_x_camera.origin - self.origin);
	ot = normalize(spot - self.origin);
	bt = vlen(spot - self.origin);

	//
	// Camera angle calculations first
	//

	if (cvar("scratch3") == 0) // dynamic camera
	{
		if (self.camerastyle == 5)
			self.angles_y = view_y; // Only Y tracking necessary
		else
		{
			// y angle can only look over so far, unless it's camerastyle 4
			if (self.camerastyle != 4)
			{
				local float view_y_bound = bound(250, view_y, 290);

				// if we're switching away from cinematic camera, we have to smooth properly
				if (self.camerastyle_old == 4)
				{
					self.stylechange_angle = self.angles_y;

					// turn rate (in degrees per second)
					local float turn_rate = 85;

					self.stylechange_length = angle_diff(view_y_bound, self.angles_y) / turn_rate;
					self.stylechange_time = time + self.stylechange_length;
				}
				
				// if we're still in the process of smoothing, we ignore the true view_y to avoid snapping
				if (self.stylechange_time)
				{
					local float frac = (self.stylechange_time - time) / self.stylechange_length; 

					if (frac > 0)
						self.angles_y = view_y_bound + angle_diff(view_y_bound, self.stylechange_angle) * frac;
					else
					{
						self.angles_y = view_y_bound;
						self.stylechange_time = 0;
					}
				}
				else
				{
					self.angles_y = view_y_bound;
				}
			}
			else // envenom style camera
				self.angles_y = view_y;

			self.angles_x = view2_x; // view2 is the new smooth camera entity
		}
	}

	//
	// TraceBox to ensure that the camera isn't going into the ceiling
	//

	// Check up direction
	local vector source, dest;
	local float test;

	source = self.origin;
	dest = self.origin + v_up * 44;

	tracebox (source, '-24 -24 -12', '24 24 12', dest, 1, self);

	if (trace_fraction < 1)
		self.cam_zcheck = TRUE;
	else
		self.cam_zcheck = FALSE;

	if (self.cam_zcheck) // Camera hit ceiling
	{
		if (self.goalentity.origin_z > self.origin_z)
		{
			self.camera_forcezoom_finished = time + 1; // Try a zoom out
			self.zoom_mode = 2;
		}
		else
			self.cam_zcheck =  FALSE;
	}

	//
	// Do actual camera movement here
	//
	
	if ((self.camerastyle == 0 || self.camerastyle >= 2) && self.camerastyle != 4) // normal camera tracking
	{
		if (self.camchangetarget_finished < time)
		{
			if (self.goalentity != self.char)
				self.goalentity = self.char;
		}
		else if (self.goalentity.health < 1 || self.goalentity == world)
			self.goalentity = self.char;

		if (cvar("scratch3") == 0)
		{
			if (self.camerastyle != 5)
			{
				if (self.goalentity.izunatarg)
					ot = ot * (bt * 1.5) * frametime; // izuna almost disables tracking temporarily
				else
					ot = ot * (bt * 3) * frametime; // the speed
				
			}
			else
				ot = ot * (bt * 10) * frametime; // speed increase to keep on top of Vigil faster
		}
		else
			ot = ot * (bt * 6) * frametime; // the speed
	}
	else if (self.camerastyle == 1 || self.camerastyle == 4) // camera sits idle
		ot = '0 0 0';

	view = self.lock_view.origin;
	if (self.camerastyle != 3)
		view_x = (ot_x / 2) + view_x; // dividing by 2 made the camera smoother..

	if (!self.cam_zcheck)
	{
		if (!self.goalentity.lowceil)
		{
			if (self.camerastyle == 0 || self.camerastyle == 3 || self.camerastyle == 5)
				view_z = ot_z + view_z + (80 * frametime); // note: if this line is removed, camera will raise up slowly on certain camstyles
		}
		else // low ceiling situation
			view_z = self.goalentity.origin_z - 16;
	}

	//
	// Camera zooming in and out is done here
	//

	if (self.camerastyle != 4)
	{
		/* DEBUG
		if (self.lock_view.origin_y < (self.new_zoom_y + self.min_zoom))
			bprint ("1\n");
		if (self.lock_view.origin_y > (self.new_zoom_y + self.max_zoom))
			bprint ("2\n");

		local string a = ftos(self.new_zoom_y);
		bprint ("NZ: ", a, " / ");
		local string s = ftos(self.lock_view.origin_y);
		bprint ("CZ: ", s, "\n");
		*/
	
		//
		// Trigger event zooming
		//
		
		if (self.lock_view.origin_y < (self.new_zoom_y + self.min_zoom) || self.lock_view.origin_y > (self.new_zoom_y + self.max_zoom))
		{
			if (self.new_zoom_y > self.lock_view.origin_y)
				view_y = view_y + 6; // zoom out
				//view_y = view_y + 2; // zoom out
			if (self.new_zoom_y < self.lock_view.origin_y)
				view_y = view_y - 6; // zoom in
				//view_y = view_y - 2; // zoom in

			// Teleport camera to proper zoom distance on level changes set by level designer
			if (framecount <= 10)
			{
				if (self.new_zoom_y < self.lock_view.origin_y)
					view_y = self.new_zoom_y + self.min_zoom;
				else
					view_y = self.new_zoom_y + self.max_zoom;
			}
		}
		else
		{
			//
			// Character event zooming
			//

			if (self.zoom_mode == 1) // Zoom in
			{
				if (self.current_zoom > self.min_zoom && self.goalentity.origin_y < self.origin_y - 85) // don't zoom in if too close to the camera
				{
					self.current_zoom = self.current_zoom - 1;
					view_y = view_y - 1; // zooms in
				}
			}
			else if (self.zoom_mode == 2) // Zoom out
			{
				if (self.current_zoom < self.max_zoom)
				{
					self.current_zoom = self.current_zoom + 1;
					view_y = view_y + 1; // zooms out
				}
			}
			else
			{
				if (self.current_zoom != 0)
				{
					if (self.current_zoom < 0)
					{
						self.current_zoom = self.current_zoom + 1;
						view_y = view_y + 1;
					}
					else
					{
						self.current_zoom = self.current_zoom - 1;
						view_y = view_y - 1;
					}
				}
			}
		}
	}
	
	//
	// Teleport the camera exactly to the players (x,z) position and turn off immediately
	//

	if (self.telecam)
	{
		view_x = self.goalentity.origin_x;
		view_z = self.goalentity.origin_z;
		self.stylechange_time = 0; // remove slow Y turn

		if (!self.force_final_campos)
			view_y = self.origin_zoom_y; // reset to default position
		else
		{
			if (self.camerastyle == 4)
			{
				view_x = view2_x = self.campos_x;
				view_y = self.campos_y;
				view_z = self.campos_z;
			}
			else
				view_y = self.new_zoom_y; // force to final zoom position
		}
		
		self.smooth_x_camera.origin_x = self.goalentity.origin_x;
		self.smooth_x_camera.origin_z = self.goalentity.origin_z;

		self.telecam = self.force_final_campos = FALSE;
	}

	//
	// Envenom style camera, upgraded smooth position movement
	//

	if (self.camerastyle == 4)
	{
		if (view_x > self.campos_x + 5)
			view_x = view_x - 200 * frametime;
		if (view_x < self.campos_x - 5)
			view_x = view_x + 200 * frametime;
		
		if (view_y > self.campos_y + 5)
			view_y = view_y - 200 * frametime;
		if (view_y < self.campos_y - 5)
			view_y = view_y + 200 * frametime;

		if (view_z > self.campos_z + 5)
			view_z = view_z - 200 * frametime;
		if (view_z < self.campos_z - 5)
			view_z = view_z + 200 * frametime;
	}

	//
	//
	//

	self.camerastyle_old = self.camerastyle;

	if (framecount < 20) // adjust cam at the start of the level before dynamic camera can take place
		self.angles_y = -90;

	self.fixangle = TRUE;
	setorigin(self, view);
	setorigin(self.lock_view, view);
	self.test_org = self.origin;
};

void() ClientKill = 
{
	if (self.char.classname == "player")
		T_Damage (self.char, self.char, self.char, 9999, 0);
};

void(optional float csqcactive) ClientConnect = 
{
	local float i, j;

	players = players + 1;
	if (players > 8) // only 4 players
		stuffcmd(self, "disconnect\n");
	else
	{
		// MauveBib's code
		i = 0;
		j = 1;
		while (i < self.colormap - 1)
		{
			j = j * 2;
			i = i + 1;
		}
		self.playerid = j;

		bprint ("The honorable ");
		bprint (self.netname);
		bprint (" has joined the realm.\n");
	}
};

void() ClientDisconnect =
{
	players = players - 1;
	self.classname = "disconnected";
	if (self.char)
	{
		self.char.classname = "disconnected";
		remove(self.char);
	}
	if (self.lock_view)
		remove(self.lock_view);
	bprint (self.netname);
	bprint (" has left the realm.\n");
};

void() cursor_follow =
{
	makevectors(self.angles);

	if (self.owner.perfectguard_buff < time)
	{
		setmodel (self, "progs/cursor2.spr");
		setorigin (self, self.owner.origin + v_up*42);
	}
	else
	{
		setmodel (self, "progs/cursor3.spr");
		setorigin (self, self.owner.origin + v_up*50);
	}

	// Multiplayer colour codes
	if (!self.colormod)
	{
		if (self.owner.owner.playerid == 1)
			self.colormod = '10 1 1'; // Red
		if (self.owner.owner.playerid == 2)
			self.colormod = '1 1 10'; // Blue
		if (self.owner.owner.playerid == 4)
			self.colormod = '1 10 1'; // Green
		if (self.owner.owner.playerid == 8)
			self.colormod = '10 10 1'; // Yellow
	}

	frameskip(0.01);
};

void() smoothcamera_x_follow =
{
	local float x;
	x = vlen(self.origin - self.owner.origin);
	
	makevectors(self.angles);
	self.origin_x = self.owner.origin_x;
	self.origin_y = self.owner.origin_y;

	if (self.origin_z < self.owner.origin_z)
		self.origin_z = self.origin_z + 4 * frametime * x;
	if (self.origin_z > self.owner.origin_z)
		self.origin_z = self.origin_z - 4 * frametime * x;

	setorigin (self, self.origin);
	frameskip(0.01);
};

//=========================================================================
//
// WATER EFFECTS / Physics
//
//==========================================================================

void() bubble_remove;
void() bubble_bob;
.float air_finished;
.float bubble_count;
.float liquidsound_finished;
void() PainSound;

void() splash_particle_think =
{
	if (!self.cnt)
		setmodel (self, "progs/splash_w.spr");
	else if (self.cnt == 1)
		setmodel (self, "progs/splash_l.spr");
	else
		setmodel (self, "progs/splash_s.spr");

	if (self.attack_finished < time)
	{
		if (max_water_splash_ents > 0)
			max_water_splash_ents = max_water_splash_ents - 1;

		remove(self);
		return;
	}
	frameskip(0.1);
};

void(entity own, float style, float type, optional vector org) watersplash_particle =
{
		if (max_water_splash_ents > 12)
			return;
		
		local entity splash, particle;

		max_water_splash_ents = max_water_splash_ents + 1; // spawns 2 ents, but we'll count these vfx as one-together

		// Spawn particle
		particle = spawn();
		particle.angles_y = random() * 360;
		makevectors (particle.angles);
		particle.velocity = v_forward * 100;
		particle.owner = own;
		particle.movetype = MOVETYPE_BOUNCE;
		particle.hitcontentsmaski = 0; // No collision
		particle.solid = SOLID_NOT;
		particle.classname = "splashparticle";
		particle.cnt = type;
		setmodel (particle, string_null);
		setsize (particle, '0 0 0', '0 0 0');
		if (!org)
			setorigin (particle, own.origin);
		else
			setorigin (particle, org);

		// Spawn splash
		splash = spawn();
		makevectors (splash.angles);
		splash.owner = own;
		splash.angles_y = -90;
		splash.movetype = MOVETYPE_NOCLIP;
		splash.hitcontentsmaski = CONTENTBIT_WATER | CONTENTBIT_SLIME | CONTENTBIT_LAVA;
		splash.solid = SOLID_NOT;
		splash.classname = "watersplash";
		splash.cnt = type;
		setmodel (splash, "progs/watersplash.spr");
		setsize (splash, '0 0 0', '0 0 0');
		if (!org)
			setorigin (splash, own.origin);
		else
			setorigin (splash, org);

		if (style == 0) // Small particle splash
		{
			splash.alpha = 0.5;
			splash.scale = 0.5;
			particle.attack_finished = time + 0.3;
			particle.velocity_z = 125;
		}
		else if (style == 1) // Medium particle splash
		{
			splash.alpha = 0.75;
			splash.scale = 1;
			particle.attack_finished = time + 0.3;
			particle.velocity_z = 250;
		}
		else // Big particle splash
		{
			splash.alpha = 1;
			splash.scale = 2.5;
			particle.attack_finished = time + 0.75;
			particle.velocity_z = 450;
		}
		splash.combo = style;

		particle.think = splash_particle_think;
		particle.nextthink = time;
		splash.think = watersplash_think;
		splash.nextthink = time;
};

void() bubble_remove =
{
	if (other.classname == self.classname)
		return;

	remove(self);
};

void() bubble_split =
{
	local entity	bubble;

	bubble = spawn();
	setmodel (bubble, "progs/bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.effects = EF_ADDITIVE;
	bubble.cnt = 10;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.cnt = 10;
	if (self.waterlevel != 3)
		remove(self);
};

void() bubble_bob =
{
	local float		rnd1, rnd2, rnd3;
	local vector	vtmp1, modi;

	if (pointcontents(self.origin) != CONTENT_WATER)
	{
        remove(self);
		return;
	}
		
	self.cnt = self.cnt + 1;
	if (self.cnt == 4)
		bubble_split();
	if (self.cnt == 20)
		remove(self);

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));
	rnd3 = self.velocity_z + 10 + random() * 10;

	if (rnd1 > 10)
		rnd1 = 5;
	if (rnd1 < -10)
		rnd1 = -5;
		
	if (rnd2 > 10)
		rnd2 = 5;
	if (rnd2 < -10)
		rnd2 = -5;
		
	if (rnd3 < 10)
		rnd3 = 15;
	if (rnd3 > 30)
		rnd3 = 25;
	
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;

	self.nextthink = time + 0.5;
	self.think = bubble_bob;
};

void() BubblesSpawn =
{
	local entity	bubble;
	
	if (self.owner.waterlevel != 3)
		return;

	bubble = spawn();
	setmodel (bubble, "progs/bubble.spr");
	makevectors(self.owner.angles);
	setorigin (bubble, self.owner.origin + v_forward*8 + v_up*24);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.cnt = 0;
	bubble.effects = EF_ADDITIVE;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + 0.1;
	self.think = BubblesSpawn;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count)
		remove(self);
};

void(float num_bubbles) Bubbles =
{
	local entity bubble_spawner;
	
	bubble_spawner = spawn();
	makevectors(self.char.angles);
	setorigin (bubble_spawner, self.char.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time + 0.1;
	bubble_spawner.think = BubblesSpawn;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self.char;
	bubble_spawner.bubble_count = num_bubbles;
};

//
// END
//

void(entity own) Shadows;
void() manashadows_think;
void() SwordShadows;
void() StatusEffects;
void() HealthFlask;
void(entity own) SoftShadows;
void() SpeedLine;
void() PlayerWaterPhysics;
.float screenflash_mode;
.float freeze_done;
.float rainbow_stage; // stages for colormod rainbow effect on Vigil
.float neardeath_tint; // boolean if the screen gets tinted red near death
.float fullmana_display; // boolean to have an effect not spammed
.float fullmana_display_timer;
.float absorb_display_timer;
.float inwater_finished;

void() PlayerPreThink = 
{
	local entity manashadow;

	//
	// Fixes bug for loading the proper music during save game load
	//
	if (framecount > 9 && SAVE_GAME_LOADED && world.model == "maps/village.bsp" && self.music != "chuch_load")
	{
		self.music = "chuch_load"; // do it once
		self.char.music = "sound/music/track17.ogg"; // same value as the triggers inside the church, prevents it from restarting when trigger is hit
		stuffcmd (self, "music sound/music/track17.ogg\n");
	}
	
	if (cvar("developer") == 2)
		return;

	// Silly way of doing this to send to CSQC
	if (self.flags & FL_GODMODE)
		self.god = TRUE;
	else
		self.god = FALSE;

	//
	// screen flashing seizure effect
	//

	if (self.screenflash_finished > time && (cvar("scratch1") == 0))
	{
		if (!self.screenflash_mode)
		{
			if (freeze_finished < time || self.purge_toggle) // Don't spam screen with flashes
			{
				self.vcshift_ok = TRUE;
				self.screentint_finished = time + 0.01 * (frametime * 100);
				stuffcmd (self, "v_cshift 255 255 255 100\n");
			}
			else
				self.screenflash_mode = TRUE;
		}
		else
			self.screenflash_mode = FALSE;
	}
	else if (self.screenflash_mode)
		self.screenflash_mode = FALSE;

	//
	//
	//

	if (self.spawntime)
	{
		if (time > self.spawntime)
		{
			msg_entity = self;
			WriteByte(MSG_ONE, 5);
			WriteEntity(MSG_ONE, self.lock_view);

			if (world.model == "maps/start.bsp")
			{
				stuffcmd(self, "gamecfg 0\n"); // reset warps
				stuffcmd(self, "viewsize 110\n");
				stuffcmd(self, "stopmusic\n");	
				sound (self, CHAN_VOICE, "music/track2.ogg", 1, ATTN_NONE);
			}
			else if (world.model == "maps/menu.bsp")
			{
				//stuffcmd(self, "wf\n");
				stuffcmd(self, "viewsize 110\n");
				stuffcmd(self, "stopmusic\n");	
			}
			else if (world.model == "maps/intro.bsp")
			{
				stuffcmd(self, "viewsize 110\n");
				stuffcmd(self, "stopmusic\n");
				sound (self, CHAN_VOICE, "music/track3.ogg", 1, ATTN_NONE);
			}
			else
				stuffcmd(self, "viewsize 110\n");
			self.spawntime = 0;
		}
	}

	if (self.char)
	{
		// Debugging for Vigil enemy field checking
		//if (self.char.enemy != world)
		//	bprint ("Vigil Enemy: ", self.char.enemy.classname, "\n");
	
		// Perma-fix for zombie vigil (health = 0)
		if (!self.char.health)
		{
			Killed(self.char, world);
			self.char.health = -1; // Don't loop
		}
		if (self.shadow_time > time)
			Shadows(self.char);
		if (self.softshadow_time > time)
			SoftShadows(self.char);
		if (self.swordshadow_time > time)
			SwordShadows();
		if (self.speedline_time > time)
			SpeedLine();

		if (self.char.classname == "player" && self.char.health > 0)
			CheckImpulseButtons();
		if (self.impulse != 0)
			self.impulse = 0;

		// Angle fix (!Important!)
		if (self.char.angles_y >= 270)
			self.char.angles_y = -90;
			
		// Hidden entity that follows Vigil for smoother X camera movements
		if (!self.smooth_x_camera)
		{
			local entity smoothcamera_x;

			smoothcamera_x = spawn();
			setmodel(smoothcamera_x, string_null);
			setsize (smoothcamera_x, '0 0 0', '0 0 0');
			setorigin (smoothcamera_x, self.char.origin);
			smoothcamera_x.movetype = MOVETYPE_NOCLIP;
			smoothcamera_x.owner = self.char;
			smoothcamera_x.think = smoothcamera_x_follow;
			smoothcamera_x.nextthink = time;
			self.smooth_x_camera = smoothcamera_x; // binded
			smoothcamera_x.drawonlytoclient = self; // reduce network traffic
		}
		InitCamera(); // Main game camera
		//

		if (self.char.classname == "player")
		{
			// Send Vigil's origin to CSQC for Blind status mainly
			self.vigil_x = self.char.origin_x;
			self.vigil_y = self.char.origin_y;
			self.vigil_z = self.char.origin_z;

			if (self.char.pain_finished > time) // Send to CSQC
				self.pain_finished = time = self.char.pain_finished;
			else
				self.pain_finished = time - 1;

			//
			//	Full Mana visual indicator
			//

			if (self.mana >= self.max_mana)
			{
				if (!self.fullmana_display)
				{
					if (self.fullmana_display_timer < time)
					{
						manashadow = spawn();
						manashadow.owner = self.char;
						manashadow.classname = "manashadow";
						manashadow.movetype = MOVETYPE_NOCLIP;
						manashadow.solid = SOLID_NOT;
						manashadow.scale = 1;
						manashadow.alpha = 0.5;
						manashadow.colormod = '0 255 255';
						manashadow.drawonlytoclient = self; // reduce network traffic
						manashadow.effects = EF_ADDITIVE | EF_FULLBRIGHT | EF_NODEPTHTEST;
						manashadow.attack_finished = time + 0.35;
						setmodel (manashadow, "progs/plyr.mdl");

						manashadow.frame = self.char.frame;
						manashadow.angles = self.char.angles;
						setorigin(manashadow, self.char.origin);
						self.fullmana_display_timer = time + 0.5; // cooldown
						sound (self, CHAN_AUTO, "player/fullmp.wav", 1, ATTN_NORM);

						manashadow.think = manashadows_think;
						manashadow.nextthink = time;
						
					}
					self.fullmana_display = TRUE; // Only do this once
				}
			}
			else if (self.fullmana_display)
				self.fullmana_display = FALSE;
		
			//
			//	Spell Absorption visual indicator
			//

			if (self.absorb_finished > time && self.absorb_display_timer < time)
			{
				self.fullmana_display = FALSE; // Allow it to remind the player again
				
				manashadow = spawn();
				manashadow.owner = self.char;
				manashadow.classname = "manashadow";
				manashadow.movetype = MOVETYPE_NOCLIP;
				manashadow.solid = SOLID_NOT;
				manashadow.scale = 1;
				manashadow.alpha = 0.5;
				manashadow.colormod = '218 0 218'; // purple
				manashadow.drawonlytoclient = self; // reduce network traffic
				manashadow.effects = EF_ADDITIVE | EF_FULLBRIGHT | EF_NODEPTHTEST;
				manashadow.attack_finished = time + 0.35;
				setmodel (manashadow, "progs/plyr.mdl");

				manashadow.frame = self.char.frame;
				manashadow.angles = self.char.angles;
				setorigin(manashadow, self.char.origin);

				manashadow.think = manashadows_think;
				manashadow.nextthink = time;

				self.absorb_display_timer = time + 3.5; // Display once as the display timer is normally 3 seconds
				sound (self, CHAN_AUTO, "spells/absorb.wav", 1, ATTN_NORM);
			}

			//
			// ColorMod Rainbow for HP Max Up bottles and slowly reverting Vigil's colormod to default when changed
			//

			if (self.char.rainbow_finished > time)
			{
				if (self.char.rainbow_stage == 0)
				{
					if (self.char.colormod_x < 2)
						self.char.colormod_x = 1 + self.char.colormod_x + (0.075 * 100) * frametime;
					else
					{
						self.char.rainbow_stage = 1;
						self.char.colormod_x = 1;
					}
				}
				else if (self.char.rainbow_stage == 1)
				{
					if (self.char.colormod_y < 2)
						self.char.colormod_y = 1 + self.char.colormod_y + (0.075 * 100) * frametime;
					else
					{
						self.char.rainbow_stage = 2;
						self.char.colormod_y = 1;
					}
				}
				else if (self.char.rainbow_stage == 2)
				{
					if (self.char.colormod_z < 2)
						self.char.colormod_z = 1 + self.char.colormod_z + (0.075 * 100) * frametime;
					else
					{
						self.char.rainbow_stage = 0;
						self.char.colormod_y = 1;
					}		
				}
			}
			else if (self.char.colormod != '1 1 1' && self.char.perfectguard_buff < time) // perfect guard is off
			{
				if (self.char.colormod_x > 1)
					self.char.colormod_x = self.char.colormod_x - (0.03 * 100) * frametime;
				else
					self.char.colormod_x = 1;

				if (self.char.colormod_y > 1)
					self.char.colormod_y = self.char.colormod_y - (0.03 * 100) * frametime;
				else
					self.char.colormod_y = 1;

				if (self.char.colormod_z > 1)
					self.char.colormod_z = self.char.colormod_z - (0.03 * 100) * frametime;
				else
					self.char.colormod_z = 1;
			}
			
			//
			// HACK: Quake/FTE engine will not check SOLID_TRIGGER entities for .push,
			//		 causes issues where plats will go through Vigil and set his bbox to null
			//
			if (self.char.dodge_finished < time && !self.char.lowceil)
				setsize(self.char, VEC_HULL_MIN, VEC_HULL_MAX);

			if (cvar("developer") < 1 && !deathmatch && !coop) // Disable slow-mo during attract demo recording mode, deathmatch and coop
			{
				if (freeze_finished > time)
				{
					if (turbo_mode)
						localcmd ("sv_gamespeed 0.25\n");
					else
						localcmd ("sv_gamespeed 0.1\n");

					if (self.freeze_done != FALSE)
						self.freeze_done = FALSE;
				}
				else
				{
					if (!self.freeze_done)
					{
						if (turbo_mode)
							localcmd ("sv_gamespeed 1.25\n");
						else
							localcmd ("sv_gamespeed 1\n");
						if (self.freeze_done != TRUE)
							self.freeze_done = TRUE;
					}
				}
			}

			//
			// Red screen tint, applies on near-death
			//
			
			if (self.screentint_finished < time)
			{
				if (self.char.health <= (self.char.max_health / 4))
				{
					if (!self.neardeath_tint)
					{
						if (framecount > 10) // Don't play sound again on level load
							sound (self, CHAN_AUTO, "player/lowhealth.wav", 1, ATTN_NORM);
						stuffcmd (self, "v_cshift 255 0 0 25\n");
						self.neardeath_tint = TRUE;
					}
					if (self.vcshift_ok)
						stuffcmd (self, "v_cshift 255 0 0 25\n");
				}
				else
				{
					if (self.vcshift_ok)
						stuffcmd (self, "v_cshift 0 0 0 0\n");
					else
					{
						if (self.char.health > (self.char.max_health / 4) && self.neardeath_tint)
							stuffcmd (self, "v_cshift 0 0 0 0\n");
					}
					self.neardeath_tint = FALSE;
				}
				self.vcshift_ok = FALSE;
			}

			//
			// Vigil's brace for Impact after a large fall
			//

			if (self.char.inair > 84 && self.char.velocity_z < -549 && (self.char.aircombo_count != 5 && self.char.aircombo_count != 6))
				self.char.bigfall = TRUE;

			if (self.displayname_finished < time && self.displayname != "")
			{
				self.displayname = "";
				if (self.char.enemy.health < 1)
					self.char.enemy = world; // Enemy is dead, clear Vigil's .enemy field
			}
			if (self.hflask_drink_finished > time)
				HealthFlask();
			if (self.char.perfectguard_buff < time && self.char.invunerability_finished < time &&self.char.alpha != 1)
				self.char.alpha = 1;

			// Debug inair time
			//local string f = ftos(self.char.inair);
			//bprint ("In Air: ", f, "\n");

			if (self.forcewalk_finished < time && (self.status_blind_finished > time || self.status_poison_finished > time || self.status_broken_finished > time))
				StatusEffects();
		}

		//
		// Vigil overhead cursor / perfect guard buff symbol
		//

		if ((!visible(self.char) || self.char.perfectguard_buff > time) || coop)
		{
			if (!self.charcursor)
			{
				local entity cursor = spawn();
				if (self.char.perfectguard_buff < time)
					setmodel (cursor, "progs/cursor2.spr");
				else
				{
					setmodel (cursor, "progs/cursor3.spr");
					spawn_color_glow(1, 1, 0, 100, cursor); // spawn glow
				}
				setsize (cursor, '0 0 0', '0 0 0');
				setorigin (cursor, self.char.origin + v_up*42);
				cursor.classname = "cursor";
				cursor.effects = EF_NODEPTHTEST;
				cursor.movetype = MOVETYPE_NOCLIP;
				cursor.solid = SOLID_NOT;
				cursor.owner = self.char;
				cursor.think = cursor_follow;
				if (coop)
					cursor.nextthink = time + 0.1;
				else
					cursor.nextthink = time;
				self.charcursor = cursor; // binded
			}
		}
		else if (self.charcursor)
		{
			self.charcursor.solid = SOLID_NOT; // remove glow
			remove(self.charcursor);
			self.charcursor = world;
		}

		if (self.char.health > 0)
			self.health = self.char.health;
		else
			self.health = 9999; // Anything under 1 will stop the death menu from working with keys (keyflags are disabled engine-wise)
	}
	else if (title1_finished < time)
	{
		self.angles_y = -90;
		self.fixangle = TRUE;
	}

	//
	// FTE sometimes sets the roll angle when changing graphic options
	//

	local float b;
	b = cvar("cl_rollangle");
	if (b > 0)
		stuffcmd (self, "cl_rollangle 0\n");
};

float title1_finished;
void() ComboMeter;
void() PlayerPostThink =
{
	// Fix me, continual messages cram client
	// cause lag/fixme/ we only need this maybe once or twice during
	// game
	local vector tree;

	if (cvar("developer") == 2)
		return;

	if (world.model != "maps/start.bsp")
	{
		// FrikaC: keyflag control system begin
		if (self.origin != self.test_org && self.forcewalk_finished < time && self.char.dodge_finished < time)
		{
			makevectors(self.angles);
			self.keyflags = 0;
			tree = self.test_org - self.origin;
			
			if (framecount > 29) // Prevent accidental key press on map change
			{
				if (tree_z < -1)
					self.keyflags = self.keyflags | KEY_UP;
				else if (tree_z > 1)
					self.keyflags = self.keyflags | KEY_DOWN;
				if (v_right * tree < -1)
					self.keyflags = self.keyflags | KEY_RIGHT;
				else if (v_right * tree > 1)
					self.keyflags = self.keyflags | KEY_LEFT;
			}
		}
		else
			self.keyflags = 0;
		setorigin(self, self.test_org);
	}
	
	if (self.char)
	{
		local float i;

		//
		// Swimming Physics are applied
		//

		// We use pointcontents due to MOVETYPE_STEP changes on Vigil
		// causing 'waterlevel' not to update, that only happens on MOVETYPE_WALK entities
		if (self.char.classname == "player")
		{
			self.swimming = self.char.swimming;
			if (pointcontents(self.char.origin) == CONTENT_WATER || pointcontents(self.char.origin) == CONTENT_LAVA || pointcontents(self.char.origin) == CONTENT_SLIME)
			{
				self.char.movetype = MOVETYPE_WALK; // Needed otherwise odd problems occur

				if (!self.swimming) // First entered water
				{
					self.char.aircombo_count = 0;
					self.ledgegrab = FALSE;
					self.walljump = FALSE;
					// Don't remove flypain, stops players from moving vigil when knocked from land into water which is intended behavior
					//self.char.flypain = FALSE;
					self.wallrun = FALSE;
					self.ledgegrab_finished = time;
					self.attack_finished = time;
					self.char.tired_finished = time;
					self.char.block_finished = time; // remove any left over block timers

					self.inwater_finished = time + 0.6;
					self.char.velocity_x = self.char.velocity_x / 4 * (frametime * 100);
					self.char.velocity_y = self.char.velocity_y / 4 * (frametime * 100);
					self.char.velocity_z = self.char.velocity_z / 4 * (frametime * 100);

					if (self.splash_finished < time)
					{
						for (i = 0; i < 4; i = i+1)
						{
							if (pointcontents(self.char.origin) == CONTENT_WATER)
								watersplash_particle(self.char, 1, 0, self.char.origin);
							if (pointcontents(self.char.origin) == CONTENT_LAVA)
								watersplash_particle(self.char, 1, 1, self.char.origin);
							if (pointcontents(self.char.origin) == CONTENT_SLIME)
								watersplash_particle(self.char, 1, 2, self.char.origin);
						}
						self.bubble_count = time + 3;
					}
				}
				PlayerWaterPhysics();

				if (self.char.waterlevel < 3) // Only drown on water level 3
					self.char.dmgtime = time + 8; // 8 second breath holding

				if (self.bubble_count < time) // spawn bubbles
				{
					Bubbles(1);
					self.bubble_count = time + 3;
				}

				// Drowning
				if (self.char.dmgtime < time && (!relics & IT_RELIC6) && !self.flags & FL_GODMODE && !self.char.flypain)
				{
					if (self.char.takedamage && self.char.invunerability_finished < time)
					{
						if (self.char.liquidsound_finished < time)
						{
							sound (self.char, CHAN_VOICE, "player/drown.wav", 1, ATTN_NORM);
							self.char.liquidsound_finished = time + 1;
						}
						self.char.health = self.char.health - 1;
						if (self.char.health < 1)
							Killed(self.char, world);
					}
					self.char.dmgtime = time + 0.25;
				}
				self.char.swimming = TRUE;
			}
			else
			{
				self.char.swimming = FALSE;
				self.char.speed = 120; // Vigil's default speed is set here...
			}
		}
		
		if (world.model != "maps/village.bsp")
			ComboMeter(); // display combo count
		else if (!self.safezone && self.combo)
			self.combo = 0; // combo should always be zero in village and safe zones

		// now do the movement
		if (self.char.classname == "player")
			player_think(); // player.qc
		
		// For debugging status effects
		//self.char.tired_finished = time + 3;
		//self.status_poison_finished = time + 3;
		//self.status_blind_finished = time + 3;
		
		//if (self.broken_tick_finished < time && framecount > 29) // Needed otherwise keys lock in safezones
		//	self.broken_tick_finished = time + 1 + ceil(random()*4 + 1);
		//self.status_broken_finished = time + 3;
		
		//self.char.purge_finished = time + 3;
	}

	// Enforce TAoV defaults
	if (cvar("viewsize") != 110)
		stuffcmd (self, "viewsize 110\n");
	if (cvar("fov") != 105)
		stuffcmd (self, "fov 105\n");
	if (cvar("chase_active") != 0)
		stuffcmd (self, "chase_active 0\n");
	if (cvar("scr_fov_mode") != 5)
		stuffcmd (self, "scr_fov_mode 5\n");

	//* title screen *
	if (world.model == "maps/start.bsp")
	{
		if (self.button0 && framecount > 79 && !self.cnt)
		{
			if (title1_finished > time)
				return;

			self.cnt = TRUE;
			stuffcmd(self, "bf\n");
			sound (self, CHAN_VOICE, "misc/title2.wav", 1, ATTN_NONE);

			title1_finished = time + 3;
		}

		if (title1_finished > time) // Move camera after hitting attack to start game
		{
			msg_entity = self;
			WriteByte(MSG_ONE, 5);
			WriteEntity(MSG_ONE, self.lock_view);

			self.lock_view.movetype = MOVETYPE_FLY;
			if (time + 2.05 > title1_finished)
			{
				if (self.lock_view.angles_y >= -165)
				{
					self.lock_view.angles_y = self.lock_view.angles_y - (500 * frametime);
					self.angles_y = self.angles_y - (500 * frametime);
				}
				else
				{
					self.lock_view.angles_y = -180;
					self.angles_y = -180;
				}		
			}

			self.lock_view.movetype = MOVETYPE_FLY;
			self.lock_view.hitcontentsmaski = CONTENTBIT_SOLID|0x00000002i|CONTENTBIT_BODY|CONTENTBIT_PLAYERCLIP;
			self.lock_view.angles = self.angles;
			makevectors (self.angles);
			self.lock_view.velocity = aim(self.lock_view, 500);
			self.lock_view.velocity = self.lock_view.velocity * 500;
		
			self.fixangle = TRUE;
			setorigin (self, self.lock_view.origin);
		}
	}

	//* graphical menu *
	if (world.model == "maps/menu.bsp" || world.model == "maps/start.bsp")
	{
		self.angles_x = 0;
		self.fixangle = TRUE; // Fixes weird angle left overs from intro.bsp

		if (world.model == "maps/menu.bsp")
			MenuCommands();
	}

	//* camera targetting code for intro.bsp *
	local vector view;
	if (world.model == "maps/intro.bsp")
	{
		local entity e;

		if (!self.cnt)
		{
			if (self.button0) // skip
			{
				title1_finished = time + 1.5;	
				self.cnt = TRUE;
				sound (self, CHAN_VOICE, "misc/title2.wav", 1, ATTN_NONE);
				stuffcmd(self, "wf\n");
			}
		}
		else
		{
			if (title1_finished < time)
				changelevel ("menu");
		}

		e = find (world, classname, "cameratarget");

		while (e)
		{
			view = vectoangles(e.origin - self.origin);
			self.angles = view;
			self.angles_x = view_x;// * -1;
			self.fixangle = TRUE;
			e = find (e, classname, "cameratarget");
		}
	}
};

//----
// Spawning the Player
//----

/*QUAKED info_player_start (0 0 1) (-10 -10 -10) (10 10 10)
Game camera spawn, be sure to give it enough zooming in / out
room, you can set it's default zoom by how close you've put it
to Vigil; seperated from the gameplay by a clip brush.
*/

void() info_player_start = {};
void() Setup_Vigil;
void() PutClientInServer =
{
	local entity spawn_spot;
	spawn_spot = find (world, classname, "info_player_start");

	self.spawnflags = spawn_spot.spawnflags; // important
	self.classname = "camera";
	self.health = decode(parm1, 1);
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER;

	if (!self.lock_view)
		self.lock_view = spawn();	// used to remove jitters
	setmodel(self.lock_view, "progs/null.spr");

	self.origin = spawn_spot.origin; // Move to the spawnspot location
	setorigin(self.lock_view, spawn_spot.origin);
	
	self.movetype = MOVETYPE_NOCLIP;
	self.flags = FL_CLIENT;
	self.origin = spawn_spot.origin;
	self.campos = spawn_spot.origin;
	setmodel (self, "progs/null.spr");
	setsize (self, '0 0 0', '0 0 0');
	self.view_ofs = '0 0 22';
	self.velocity = '0 0 0';
	self.modelindex = 0;
	self.fullmana_display = TRUE; // Don't spam on level load
	self.spawntime = time + 0.1;
	self.fog = self.ofog = "0";

	DecodeLevelParms();

	// These two lines must stay
	self.level = decode(parm4, 2); // level	
	self.armorvalue = self.level; // Display level on HUD properly

	self.test_org = self.origin;

	if (world.model == "maps/start.bsp" || world.model == "maps/intro.bsp" || world.model == "maps/menu.bsp")
		return;

	self.zoom_mode = 2;
	self.current_zoom = 0;
	self.min_zoom = -30;
	self.max_zoom = 23;

	if (players <= 8)
		Setup_Vigil();

	self.origin_zoom = self.origin;
	self.new_zoom = self.origin; // store initial camera position

	// Set proper commands on game load
	if (cvar("developer") != 1) // allow slow-mo in dev mode
	{
		if (turbo_mode)
			localcmd ("sv_gamespeed 1.25\n"); // needs to be set
		else
			localcmd ("sv_gamespeed 1\n"); // needs to be set
	}

	stuffcmd (self, "v_cshift\n"); // remove cshift effects
	// Remove any left over sticky centerprints
	centerprint (self, "\n");
};

//================
// Level Up System
//================

void() DisplayLevelThink =
{
	local vector x;

	x = self.owner.angles;
	x_z = 0;
	makevectors(x);
	
	self.angles_x = self.angles_x + (50 * frametime);
	if (self.angles_x > 90)
	{
		remove(self);
		return;
	}
	
	self.origin_x = self.owner.origin_x;
	self.origin_y = self.owner.origin_y;
	self.origin_z = self.owner.origin_z + 48;
	frameskip(0.01);
};

void() DisplayLevel =
{
	local entity levelu;

	levelu = spawn();
	setorigin(levelu, self.origin + v_up*48);
	setmodel(levelu, "progs/levelup.spr");
	setsize(levelu, '0 0 0', '0 0 0');
	levelu.solid = SOLID_NOT;
	levelu.owner = self;
	levelu.takedamage = DAMAGE_NO;
	levelu.classname = "levelsign";
	levelu.movetype = MOVETYPE_NOCLIP;
	levelu.angles_y = -90;
	levelu.angles_x = -90;
	levelu.fixangle = TRUE;
	levelu.effects = EF_NODEPTHTEST | EF_FULLBRIGHT;
	levelu.think = DisplayLevelThink;
	levelu.nextthink = time;
};

void() SetLevel = 
{        
	local float NextLevelExp;
	local float num;

	if (cvar("developer") == 3)
		return;

	if (self.owner.level < 99) // 99 is max
	{
		NextLevelExp = self.owner.level + 18 * self.owner.level;
		if (self.owner.experience >= NextLevelExp)
		{
			if (!coop)
			{
				if (self.owner.level == 1)
				{
					setpause(1);
					centerprint (self.owner, "/P^bLevel Up!^b\n\nKilling foes increases Vigil's strength & resolve\n\n===========================\n\n\n^1Enemies give varying amounts of experience points which strengthens Vigil, leveling up increases Vigil's maximum HP & MP!\n\n\n^3Press ATTACK or JUMP to resume ...");
				}
				if (self.owner.level == 19)
				{
					setpause(1);
					centerprint (self.owner, "/P^bFireball Level Up!^b\n\n===========================\n\n^1Vigil now shoots 2 fireballs for 1.5x more damage if both hit their target!\n\n\n^3Press ATTACK or JUMP to resume ...");
				}				
			}
			sound (self, CHAN_AUTO, "misc/levelup.wav", 1, ATTN_NORM);
			self.owner.level = self.owner.level + 1;
	
			self.max_health = self.max_health + 3;
			self.owner.max_health = self.owner.max_health + 3;

			self.health = self.health + 3;
			self.owner.health = self.owner.health + 3;

			self.max_mana = self.max_mana + 3;
			self.owner.max_mana = self.owner.max_mana + 3;

			self.mana = self.mana + 3;
			self.owner.mana = self.owner.mana + 3;

			self.owner.experience = 0; // reset back
			//self.owner.armorvalue = self.owner.level; // Update HUD
			DisplayLevel(); // display sprite sign
			freeze_finished = time + 5 * frametime;
	    }
	}
};

void(float amount) GiveExperience =
{
	local entity temp;
	
	if (self.enemy.classname != "player" || deathmatch)
		return;
	if (cvar("developer") == 3)
		return;
		
	temp = self;
	self = self.enemy; // make enemy the dummy
	
    // calculate diminishing returns
	if (self.owner.level < 10)
		amount = amount - self.owner.level;
    else if (self.owner.level >= 10 && self.owner.level <= 19)
        amount = amount - (self.owner.level * 1.05);
    else if (self.owner.level >= 20 && self.owner.level <= 29)
        amount = amount - (self.owner.level * 1.10);
    else if (self.owner.level >= 30 && self.owner.level <= 39)
        amount = amount - (self.owner.level * 1.15);
    else if (self.owner.level >= 40 && self.owner.level <= 49)
        amount = amount - (self.owner.level * 1.20);
    else if (self.owner.level >= 50 && self.owner.level <= 59)
        amount = amount - (self.owner.level * 1.25);
    else
        amount = amount - (self.owner.level * 1.30);
	
	//amount -= self.owner.level * (1 + floor(self.owner.level/10)*0.05);

	amount = ceil(amount); // round up
	
	if (amount < 1)
		amount = 1; // always give Vigil at least 1 EXP minimum	

	self.owner.experience = self.owner.experience + amount;

	if (self.classname == "player")
	{
		local string s;
		s = ftos(amount);
		dprint (s, " EXP Given to player\n");
	}
	else
		error("EXP given to wrong entity! Debug with developer.. !!\n");

	SetLevel();
	self = temp;
};