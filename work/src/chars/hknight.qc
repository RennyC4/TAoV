/*
+--------+
|HKnight |
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Hell knights are dangerous, can block, also drops armor shards.            |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20
$frame run1 run2 run3 run4 run5 run6 run7 run8
$frame pain1 pain2 pain3 pain4 pain5
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9
$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16
$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14
$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13
$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6
$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10
$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11
$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20 
$frame w_attack21 w_attack22 
$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11

void() hellknight_run1;
void()	hellknight_block1	=[	$walk1,	hellknight_block1	] 
{
	monster_removeslide();
	ai_watercheck_removal();

	if (self.origin_x < self.enemy.origin_x)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	// Needs Logic to break out his block without spamming messages
	if (self.enemy.onground == TRUE && (self.enemy.owner.attack_finished < time || self.enemy.tired_finished > time))
	{
		if (self.th_run)
		{
			self.think = self.th_run;
			self.nextthink = time;
		}
		else
		{
			self.think = self.th_stand;
			self.nextthink = time;
		}
		return;
	}
	self.block_finished = time + 0.15;
};

void()	hellknight_stand1	=[	$stand1,	hellknight_stand2	] {ai_stand();};
void()	hellknight_stand2	=[	$stand2,	hellknight_stand3	] {ai_stand();};
void()	hellknight_stand3	=[	$stand3,	hellknight_stand4	] {ai_stand();};
void()	hellknight_stand4	=[	$stand4,	hellknight_stand5	] {ai_stand();};
void()	hellknight_stand5	=[	$stand5,	hellknight_stand6	] {ai_stand();};
void()	hellknight_stand6	=[	$stand6,	hellknight_stand7	] {ai_stand();};
void()	hellknight_stand7	=[	$stand7,	hellknight_stand8	] {ai_stand();};
void()	hellknight_stand8	=[	$stand8,	hellknight_stand9	] {ai_stand();};
void()	hellknight_stand9	=[	$stand9,	hellknight_stand1	] {ai_stand();};

void()	hellknight_walk1	=[	$walk1,		hellknight_walk2	] {ai_walk(8);};
void()	hellknight_walk2	=[	$walk2,		hellknight_walk3	] {ai_walk(8);};
void()	hellknight_walk3	=[	$walk3,		hellknight_walk4	] {ai_walk(8);};
void()	hellknight_walk4	=[	$walk4,		hellknight_walk5	] {ai_walk(8);};
void()	hellknight_walk5	=[	$walk5,		hellknight_walk6	] {ai_walk(8);};
void()	hellknight_walk6	=[	$walk6,		hellknight_walk7	] {ai_walk(8);};
void()	hellknight_walk7	=[	$walk7,		hellknight_walk8	] {ai_walk(8);};
void()	hellknight_walk8	=[	$walk8,		hellknight_walk9	] {ai_walk(8);};
void()	hellknight_walk9	=[	$walk9,		hellknight_walk10	] {ai_walk(8);};
void()	hellknight_walk10	=[	$walk10,		hellknight_walk11	] {ai_walk(8);};
void()	hellknight_walk11	=[	$walk11,		hellknight_walk12	] {ai_walk(8);};
void()	hellknight_walk12	=[	$walk12,		hellknight_walk13	] {ai_walk(8);};
void()	hellknight_walk13	=[	$walk13,		hellknight_walk14	] {ai_walk(8);};
void()	hellknight_walk14	=[	$walk14,		hellknight_walk15	] {ai_walk(8);};
void()	hellknight_walk15	=[	$walk15,		hellknight_walk16	] {ai_walk(8);};
void()	hellknight_walk16	=[	$walk16,		hellknight_walk17	] {ai_walk(8);};
void()	hellknight_walk17	=[	$walk17,		hellknight_walk18	] {ai_walk(8);};
void()	hellknight_walk18	=[	$walk18,		hellknight_walk19 ] {ai_walk(8);};
void()	hellknight_walk19	=[	$walk19,		hellknight_walk20	] {ai_walk(8);};
void()	hellknight_walk20	=[	$walk20,		hellknight_walk1	] {ai_walk(8);};

void()	hellknight_run1	=[	$run1,		hellknight_run2	] {ai_walk(12);};
void()	hellknight_run2	=[	$run2,		hellknight_run3	] {ai_walk(12);};
void()	hellknight_run3	=[	$run3,		hellknight_run4	] {ai_walk(12);};
void()	hellknight_run4	=[	$run4,		hellknight_run5	] {ai_walk(12);};
void()	hellknight_run5	=[	$run5,		hellknight_run6	] {ai_walk(12);};
void()	hellknight_run6	=[	$run6,		hellknight_run7	] {ai_walk(12);};
void()	hellknight_run7	=[	$run7,		hellknight_run8	] {ai_walk(12);};
void()	hellknight_run8	=[	$run8,		hellknight_run1	] {ai_walk(12);};

void()	hellknight_pain1	=[	$pain1,		hellknight_pain2	] {monster_removeslide();};
void()	hellknight_pain2	=[	$pain2,		hellknight_pain3	] {BlockCancel();monster_removeslide();};
void()	hellknight_pain3	=[	$pain3,		hellknight_pain4	] {BlockCancel();monster_removeslide();};
void()	hellknight_pain4	=[	$pain4,		hellknight_pain5	] {BlockCancel();monster_removeslide();};
void()	hellknight_pain5	=[	$pain5,		hellknight_walk1	] {BlockCancel();monster_removeslide();};

void() hellknight_pain =
{
	local float r;
	
	//
	// Enrage / Berserk
	//
	
	r = random();
	if (r <= 0.05 || self.spawnflags & 2)
	{
		if (self.health < self.max_health / 2.5 && self.mode == 0)
		{
			self.colormod = '3 1 1';
			self.berserk_finished = time + 8;
			enrage();
			self.mode = 1; // only enrage once
		}
	}
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "hknight/pain.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "hknight/pain2.wav", 1, ATTN_NORM);
	hellknight_pain1 (); 
	monster_pain(self.enemy);
};

void()	hellknight_deatha1	=[	$death1,		hellknight_deatha2	] {monster_death();};
void()	hellknight_deatha2	=[	$death2,		hellknight_deatha3	] {monster_death();};
void()	hellknight_deatha3	=[	$death3,		hellknight_deatha4	] {monster_death();};
void()	hellknight_deatha4	=[	$death4,		hellknight_deatha5	] {monster_death();};
void()	hellknight_deatha5	=[	$death5,		hellknight_deatha6	] {monster_death();};
void()	hellknight_deatha6	=[	$death6,		hellknight_deatha7	] {monster_death();};
void()	hellknight_deatha7	=[	$death7,		hellknight_deatha8	] {monster_death();};
void()	hellknight_deatha8	=[	$death8,		hellknight_deatha9	] {monster_death();};
void()	hellknight_deatha9	=[	$death9,		hellknight_deatha10	] {monster_death();};
void()	hellknight_deatha10	=[	$death10,		hellknight_deatha11	] {monster_death();};
void()	hellknight_deatha11	=[	$death11,		hellknight_deatha12	] {monster_death();};
void()	hellknight_deatha12	=[	$death12,		hellknight_deatha12	] {monster_death();};

void()	hellknight_deathb1	=[	$deathb1,		hellknight_deathb2	] {monster_death();};
void()	hellknight_deathb2	=[	$deathb2,		hellknight_deathb3	] {monster_death();};
void()	hellknight_deathb3	=[	$deathb3,		hellknight_deathb4	] {monster_death();};
void()	hellknight_deathb4	=[	$deathb4,		hellknight_deathb5	] {monster_death();};
void()	hellknight_deathb5	=[	$deathb5,		hellknight_deathb6	] {monster_death();};
void()	hellknight_deathb6	=[	$deathb6,		hellknight_deathb7	] {monster_death();};
void()	hellknight_deathb7	=[	$deathb7,		hellknight_deathb8	] {monster_death();};
void()	hellknight_deathb8	=[	$deathb8,		hellknight_deathb9	] {monster_death();};
void()	hellknight_deathb9	=[	$deathb9,		hellknight_deathb9	] {monster_death();};

void() hellknight_die =
{
	if (self.gaveexp != TRUE) // only give experience on first instance of death
	{				  		  // otherwise player can keep knocking corpse for EXP
		self.gaveexp = TRUE;
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		GiveExperience(self.experience);
		sound (self, CHAN_VOICE, "hknight/death.wav", 1, ATTN_NORM);
	}
	if (self.damage_type == 5) // Sliced/Gored in half
	{
		sound (self, CHAN_BODY, "misc/guts.wav", 1, ATTN_NORM);
		ThrowBodyPart("progs/hknig_c1.mdl");
		ThrowBodyPart("progs/hknig_c2.mdl");
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		ThrowBloodSplat(self.origin, self);
		remove(self);
		return;
	}
	if (self.knockback != 2 && self.knockback != 3)
	{
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 8;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	if (random() < 0.5)
		hellknight_deatha1();
	else
		hellknight_deathb1();
};

void() hellknight_attacka1 	=[	$char_a1,	hellknight_attacka2	] {BlockCancel();ai_forward(5);};
void() hellknight_attacka2 	=[	$char_a2,	hellknight_attacka3	] {BlockCancel();ai_forward(5);};
void() hellknight_attacka3 	=[	$char_a3,	hellknight_attacka4	] {BlockCancel();ai_forward(5);};
void() hellknight_attacka4 	=[	$char_a4,	hellknight_attacka5	] {BlockCancel();ai_forward(5);};
void() hellknight_attacka5 	=[	$char_a5,	hellknight_attacka6	] {BlockCancel();ai_forward(5);sound (self, CHAN_WEAPON, "hknight/swing.wav", 1, ATTN_NORM);};
void() hellknight_attacka6 	=[	$char_a6,	hellknight_attacka7	] {BlockCancel();ai_forward(5);frameskip(0.07);FireMelee(6,15,0,40,5,0,0,FALSE,0,0);};
void() hellknight_attacka7 	=[	$char_a7,	hellknight_attacka8	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_attacka8 	=[	$char_a8,	hellknight_attacka9	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_attacka9 	=[	$char_a9,	hellknight_attacka10	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_attacka10 	=[	$char_a10,	hellknight_attacka11	] {BlockCancel();ai_forward(5);frameskip(0.07);sound (self, CHAN_WEAPON, "hknight/swing.wav", 1, ATTN_NORM);};
void() hellknight_attacka11	=[	$char_a11,	hellknight_attacka12	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_attacka12 	=[	$char_a12,	hellknight_attacka13	] {BlockCancel();ai_forward(5);FireMelee(8,15,3,45,5,0,0,FALSE,0,0);};
void() hellknight_attacka13 	=[	$char_a13,	hellknight_attacka14	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_attacka14 	=[	$char_a14,	hellknight_attacka15	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_attacka15 	=[	$char_a15,	hellknight_attacka16	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_attacka16 	=[	$char_a16,	hellknight_walk1  	] {BlockCancel();ai_forward(5);frameskip(0.07);};

void() hellknight_attackb1 	=[	$char_b1,	hellknight_attackb2	] {BlockCancel();ai_forward(5);frameskip(0.2);};
void() hellknight_attackb2 	=[	$char_b2,	hellknight_attackb3	] {BlockCancel();ai_forward(5);frameskip(0.09);};
void() hellknight_attackb3 	=[	$char_b3,	hellknight_attackb4	] {BlockCancel();ai_forward(5);frameskip(0.09);sound (self, CHAN_WEAPON, "hknight/swing.wav", 1, ATTN_NORM);};
void() hellknight_attackb4 	=[	$char_b4,	hellknight_attackb5	] {BlockCancel();ai_forward(5);frameskip(0.09);};
void() hellknight_attackb5 	=[	$char_b5,	hellknight_attackb6	] {BlockCancel();ai_forward(5);FireMelee(15,15,3,45,5,0,0,FALSE,0,0);};
void() hellknight_attackb6 	=[	$char_b6,	hellknight_walk1	] {BlockCancel();ai_forward(5);frameskip(0.09);};

void() hellknight_slice1 	=[	$slice1,	hellknight_slice2	] {BlockCancel();ai_forward(5);frameskip(0.2);};
void() hellknight_slice2 	=[	$slice2,	hellknight_slice3	] {BlockCancel();ai_forward(5);frameskip(0.09);};
void() hellknight_slice3 	=[	$slice3,	hellknight_slice4	] {BlockCancel();ai_forward(5);frameskip(0.09);};
void() hellknight_slice4 	=[	$slice4,	hellknight_slice5	] {BlockCancel();ai_forward(5);frameskip(0.09);};
void() hellknight_slice5 	=[	$slice5,	hellknight_slice6	] {BlockCancel();FireMelee(5,20,0,35,0,0,0,FALSE,0,0);sound (self, CHAN_WEAPON, "hknight/swing.wav", 1, ATTN_NORM);};
void() hellknight_slice6 	=[	$slice6,	hellknight_slice7	] {BlockCancel();FireMelee(5,20,0,35,0,0,0,FALSE,0,0);};
void() hellknight_slice7 	=[	$slice7,	hellknight_slice8	] {BlockCancel();FireMelee(5,20,0,35,0,0,0,FALSE,0,0);};
void() hellknight_slice8 	=[	$slice8,	hellknight_slice9	] {BlockCancel();frameskip(0.05);};
void() hellknight_slice9 	=[	$slice9,	hellknight_slice10	] {BlockCancel();frameskip(0.07);};
void() hellknight_slice10 	=[	$slice10,	hellknight_walk1  	] {BlockCancel();frameskip(0.07);};

void() hellknight_smash1 	=[	$smash1,	hellknight_smash2	] {BlockCancel();ai_forward(5);frameskip(0.2);};
void() hellknight_smash2 	=[	$smash2,	hellknight_smash3	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_smash3 	=[	$smash3,	hellknight_smash4	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_smash4 	=[	$smash4,	hellknight_smash5	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_smash5 	=[	$smash5,	hellknight_smash6	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_smash6 	=[	$smash6,	hellknight_smash7	] {BlockCancel();ai_forward(5);frameskip(0.07);};
void() hellknight_smash7 	=[	$smash7,	hellknight_smash8	] {BlockCancel();ai_forward(5);frameskip(0.07);sound (self, CHAN_WEAPON, "hknight/swing.wav", 1, ATTN_NORM);};
void() hellknight_smash8 	=[	$smash8,	hellknight_smash9	] 
{
	BlockCancel();
	ai_forward(5);
	self.status_broken_finished = time + 16;
	FireMelee(18,15,3,45,5,0,0,FALSE,0,0.20);
};
void() hellknight_smash9 	=[	$smash9,	hellknight_smash10	] {BlockCancel();frameskip(0.07);};
void() hellknight_smash10 	=[	$smash10,	hellknight_smash11	] {BlockCancel();frameskip(0.07);};
void() hellknight_smash11 	=[	$smash11,	hellknight_walk1  	] {BlockCancel();frameskip(0.07);};

void() hellknight_jump	=[	$run5,	hellknight_jump	] 
{
	if (self.flags & FL_ONGROUND)
		hellknight_walk1();
};

void() hellknight_attack =
{
	local float r;

	r = random();
	if (self.invunerability_finished < time)
	{
		if (r < 0.25)
			hellknight_attacka1();
		else if (r < 0.5)
			hellknight_attackb1();
		else if (r < 0.75)
			hellknight_slice1();
		else
			hellknight_smash1();
	}
	else
		hellknight_smash1(); // he's mad!
};

void() hk_eball_think =
{
	if (self.alpha > 0.01)
		self.alpha = self.alpha - 0.03;
	else
	{
		remove(self);
		return;
	}
	self.scale = self.scale + 0.01;
	if (self.attack_finished < time)
	{
		self.angles_z = self.angles_z + random()*360;
		self.attack_finished = time + 0.05;
	}
	frameskip(0.01);
};

void() HellKnight_Lightning_BodyBlock =
{
	local float restore_solid;

	local entity head = searchradius(self.origin, 370); // 370 matches origin+length of traceline
	while (head)
	{
		if (head.flags & FL_MONSTER && head.grabbed == TRUE && head.enemy.onground && head.health > 0)
			self.char = head; // record the ent
		head = head.chain;
	}
};

void() HellKnight_Lightning =
{
	local vector org;
	local entity temp;
	local float restore_player_solid, restore_monster_solid;

	makevectors (self.angles);
	self.colormod = '1 1 5';
	sound (self, CHAN_WEAPON, "spells/thunder.wav", 1, ATTN_NORM);

	org = self.origin + '0 0 20' + v_forward * 20;

	// Make enemy solid for traceline to hit momentarily
	restore_player_solid = self.enemy.dimension_solid;
	if (self.enemy && self.enemy.takedamage)
		self.enemy.dimension_solid = 1;
	
	HellKnight_Lightning_BodyBlock(); // record monster grabbed
	if (self.char)
	{
		restore_monster_solid = self.char.dimension_solid;
		self.char.dimension_solid = 1;		
	}

	traceline (org, org + v_forward * 350, FALSE, self);

	if (trace_ent.health > 0 && trace_ent.takedamage && trace_ent.classname == "player" && trace_ent.perfectguard_buff < time)
	{
		temp = spawn ();
		temp.movetype = MOVETYPE_NONE;
		temp.solid = SOLID_NOT;
		temp.classname = "sprite";

		temp.alpha = 0.5;
		if (random() < 0.5)
			temp.frame = 0;
		else
			temp.frame = 1;

		temp.effects = EF_MUZZLEFLASH | EF_ADDITIVE;
		temp.alpha = 0.75;
		temp.think = SUB_Remove;
		temp.nextthink = time + 0.1;
		temp.angles_y = -90; // face screen
		temp.angles_z = random()*360; // random rotate
		setmodel (temp, "progs/lsprite.spr");
		setsize (temp, '0 0 0', '0 0 0');		
		setorigin (temp, trace_ent.origin);
		spawn_color_glow(0, 0, 5, 100, temp);
		
		if (self.angles_y >= 90 && self.angles_y <= 270)  // Attacker facing right
			trace_ent.angles_y = 0; // victim faces left
		else
			trace_ent.angles_y = 180; // victim faces right
		
		if (trace_ent.perfectblock < time)
		{
			if (trace_ent.block_finished < time) // hit target
			{
				trace_ent.knockback = 0;
				T_Damage (trace_ent, self, self, 8, 0);
			}
			else
			{
				trace_ent.purge_cooldown = time;
				// Check if Vigil is close, if so allow counter
				if (range(self, self.enemy) == RANGE_CLOSE || range(self, self.enemy) == RANGE_MELEE || range(self, self.enemy) == RANGE_NEAR)
				{
					trace_ent.enemy = self; // needed for counter attack to face the proper direction
					trace_ent.counter_finished = time + 0.5;
				}
			}
		}
		else // perfect guard
		{
			local entity temp2;
			temp2 = spawn ();
			temp2.movetype = MOVETYPE_NONE;
			temp2.solid = SOLID_NOT;
			temp2.classname = "sprite";

			temp2.alpha = 0.5;
			if (random() < 0.5)
				temp2.frame = 0;
			else
				temp2.frame = 1;

			temp2.effects = EF_MUZZLEFLASH | EF_ADDITIVE;
			temp2.alpha = 0.75;
			temp2.think = SUB_Remove;
			temp2.nextthink = time + 0.1;
			temp2.angles_y = -90; // face screen
			temp2.angles_z = random()*360; // random rotate
			setmodel (temp2, "progs/lsprite.spr");
			setsize (temp2, '0 0 0', '0 0 0');		
			setorigin (temp2, self.origin);

			spawn_color_glow(0, 0, 5, 100, temp2);

			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
			WriteEntity (MSG_BROADCAST, trace_ent);
			WriteCoord (MSG_BROADCAST, trace_endpos_x);
			WriteCoord (MSG_BROADCAST, trace_endpos_y);
			WriteCoord (MSG_BROADCAST, trace_endpos_z);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);

			trace_ent.knockback = 0;
			PerfectGuard(trace_ent); // call PG before T_Damage
			T_Damage (self, trace_ent, trace_ent, 24, 0);

			if (relics & IT_RELIC11) // Stalwart PG gives mana
			{
				trace_ent.owner.mana = trace_ent.owner.mana + 5;
				trace_ent.owner.absorb_finished = time + 3;
				if (trace_ent.owner.mana > trace_ent.owner.max_mana)
					trace_ent.owner.mana = trace_ent.owner.max_mana;
			}
			if (trace_ent.owner)
				trace_ent.owner.combo = trace_ent.owner.combo + 1; // raise combo counter

			if (self.angles_y >= 90 && self.angles_y <= 270) // Attacker facing right
				trace_ent.angles_y = 0; // victim faces left
			else
				trace_ent.angles_y = 180; // victim faces right

			if (range(self, self.enemy) == RANGE_CLOSE || range(self, self.enemy) == RANGE_MELEE || range(self, self.enemy) == RANGE_NEAR)
			{
				trace_ent.enemy = self; // needed for counter attack to face the proper direction
				trace_ent.counter_finished = time + 0.5;
			}
		}
		sound (trace_ent, CHAN_BODY, "weapons/lhit.wav", 1, ATTN_NORM);
	}
	else // hit nothing
	{
		temp = spawn ();
		temp.movetype = MOVETYPE_NOCLIP;
		temp.solid = SOLID_NOT;
		temp.classname = "sprite";
		temp.effects = EF_MUZZLEFLASH | EF_ADDITIVE;
		setmodel (temp, "progs/hk_eball.spr");
		setsize (temp, '0 0 0', '0 0 0');		
		temp.origin_x = trace_endpos_x;
		temp.origin_y = trace_endpos_y;
		temp.origin_z = trace_endpos_z;
		temp.think = hk_eball_think;
		temp.alpha = 1;
		temp.scale = 1;
		temp.angles_y = -90; // face towards camera
		spawn_color_glow(0, 0, 5, 100, temp);
		temp.nextthink = time;
	}

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	if (self.enemy)
	{
		if (restore_player_solid != 0)
			self.enemy.dimension_solid = restore_player_solid;
		else
			self.enemy.dimension_solid = 2;
	}
	if (self.char)
	{
		self.char.dimension_solid = restore_monster_solid;
		self.char = world; // clean up
	}
};

void() hellknight_lightning1	=[	$magicb1,	hellknight_lightning2	] 
{
	monster_removeslide();
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "hknight/cast1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "hknight/cast2.wav", 1, ATTN_NORM);
	if (difficulty < 2)
		self.nextthink = time + 0.4;
	else
		self.nextthink = time + 0.2;
		
	ai_forceface();
};
void() hellknight_lightning2	=[	$magicb2,	hellknight_lightning3	] {monster_removeslide();ai_forceface();};
void() hellknight_lightning3	=[	$magicb3,	hellknight_lightning4	] {monster_removeslide();};
void() hellknight_lightning4	=[	$magicb4,	hellknight_lightning5	] {monster_removeslide();};
void() hellknight_lightning5	=[	$magicb5,	hellknight_lightning6	] 
{
	monster_removeslide();
	HellKnight_Lightning();
};
void() hellknight_lightning6	=[	$magicb6,	hellknight_lightning7	] {monster_removeslide();};
void() hellknight_lightning7	=[	$magicb7,	hellknight_lightning8	] {monster_removeslide();};
void() hellknight_lightning8	=[	$magicb8,	hellknight_lightning9	] 
{
	monster_removeslide();
	if (difficulty < 2)
		self.nextthink = time + 0.4;
};
void() hellknight_lightning9	=[	$magicb9,	hellknight_lightning10	] {monster_removeslide();};
void() hellknight_lightning10	=[	$magicb10,	hellknight_lightning11	] {monster_removeslide();};
void() hellknight_lightning11	=[	$magicb11,	hellknight_lightning12	] 
{
	monster_removeslide();
	HellKnight_Lightning();
};
void() hellknight_lightning12	=[	$magicb12,	hellknight_lightning13	] {monster_removeslide();};
void() hellknight_lightning13	=[	$magicb13,	hellknight_walk1  	] {monster_removeslide();};

void()	hellknight_grabbed1	=[	$pain1,		hellknight_grabbed2	] {self.grab_finished = time + 1;};
void()	hellknight_grabbed2	=[	$pain1,		hellknight_grabbed2	] 
{
	if (!self.izunatarg)
	{
		if (self.grab_finished < time || self.grabbed == FALSE)
			self.th_walk();
	}
	else
		ai_watercheck_removal();
};

/*QUAKED monster_hell_knight (1 0 0) (-16 -16 -24) (16 16 32)
Drops armor shard on death
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
void() monster_hell_knight =
{
	if (deathmatch || (self.spawnflags & 4 && game_progress & IT_PROGRESS5))
	{
		remove(self);
		return;
	}

	precache_model ("progs/hknight.mdl");
	precache_model ("progs/hknig_c1.mdl");
	precache_model ("progs/hknig_c2.mdl");
	precache_model ("progs/hk_eball.spr");

	precache_sound ("hknight/death.wav");
	precache_sound ("hknight/swing.wav");
	precache_sound ("hknight/pain.wav");
	precache_sound ("hknight/pain2.wav");
	precache_sound ("hknight/cast1.wav");
	precache_sound ("hknight/cast2.wav");
	precache_sound ("spells/thunder.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");

	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/hknight.mdl");
	setsize (self, '-16 -16 -24', '16 16 40');

	if (difficulty < 2)
		self.health = self.max_health = 220; // regular health
	else
		self.health = self.max_health = 330; // hard health (50% tougher)

	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.classname = "hellknight";
	self.displayname = "Corrupted Commander"; // new name
	self.th_stand = hellknight_stand1;
	self.th_walk = hellknight_walk1;
	self.th_run = hellknight_run1;
	self.th_melee = hellknight_attack;
	self.th_magic = hellknight_lightning1;
	self.th_missile = hellknight_lightning1;
	self.th_pain = hellknight_pain;
	self.th_die = hellknight_die;
	self.th_jump = hellknight_jump;
	self.th_grab = hellknight_grabbed1;
	self.experience = 67;
	self.maxgold = 200;

	self.th_block = hellknight_block1;
	if (!self.ai_blockfreq) // frequency on how much the enemy blocks
	{
		if (difficulty < 2)
			self.ai_blockfreq = 0.1; // 10% skill 1
		else
			self.ai_blockfreq = 0.2; // 20% skill 2
	}

	//spawn_shadow();
	enemy_start();
};