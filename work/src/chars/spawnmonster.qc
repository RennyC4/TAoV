/*
+------------------+
|Spawn Monster     |
+------------------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| When triggered is able to spawn a monster at it's origin                   |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/

//
// Cnt value spawns which monster
//

// 0 = Corrupted Knight
// 1 = Hunting Hound
// 2 = Corrupted Commander
// 3 = Baron
// 4 = Skeleton
// 5 = Horror
// 6 = Gaunt
// 7 = Arch-Ghoul
// 8 = Ghost
// 9 = Wraith
// 10 = Electric Squid
// 11 = Gremlin
// 12 = Ghoul
// 13 = Archer
// 14 = Zombie
// 15 = Zombie Boss
// 16 = Toglod
// 17 = Green Dragon
// 18 = Hydra (Water Only)
// 19 = Needles (Water Only)
// 20 = Merman
// 21 = Ethereal Skull
// 22 = Lesser Wraith
// 23 = Raven
// 24 = Corrupted Captain
// 25 = Werewolf
// 26 = Sorrowful Spirit
// 27 = Stone Golem

// 99 = Turn spawn_monster into a Medusa Head Spawner

void() spawn_monster_use =
{
	local entity monster;

	//
	// Setup the monster spawn and teleport effect
	//

	if (!self.spawnflags & 1) // Silent teleport with spawnflag 1
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_TELEPORT);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	monster = spawn();
	setorigin (monster, self.origin);
	monster.angles = self.angles;
	monster.nodrop = TRUE; // don't droptofloor();
	if (!self.spawnflags & 1)
		monster.enemy = activator; // target player automatically
	monster.flags = FL_MONSTER;

	// Carry properties from spawn_monster into the monster itself
	monster.mode = self.mode; // mainly to set 'monster_archers' mode
	monster.awareness = self.awareness;
	
	monster.targetname = self.targetname;
	monster.halfhealth_target = self.halfhealth_target;

	monster.target = self.target;
	monster.target2 = self.target2;
	monster.target3 = self.target3;
	monster.target4 = self.target4;
	monster.target5 = self.target5;
	monster.target6 = self.target6;
	monster.target7 = self.target7;
	monster.target8 = self.target8;
	monster.target9 = self.target9;

	monster.awaketarget = self.awaketarget;
	monster.awaketarget2 = self.awaketarget2;
	monster.awaketarget3 = self.awaketarget3;
	monster.awaketarget4 = self.awaketarget4;
	monster.awaketarget5 = self.awaketarget5;
	monster.awaketarget6 = self.awaketarget6;
	monster.awaketarget7 = self.awaketarget7;
	monster.awaketarget8 = self.awaketarget8;
	monster.awaketarget9 = self.awaketarget9;

	if (!self.spawnflags & 1)
		sound (self, CHAN_VOICE, "misc/teleport.wav", 1, ATTN_NORM);
	
	//
	// Spawn Corrupted Knight
	//
	
	if (self.cnt == 0)
	{
		precache_sound ("knight/death.wav");
		precache_sound ("knight/pain1.wav");
		precache_sound ("knight/pain2.wav");
		precache_sound ("knight/pain3.wav");
		precache_sound ("knight/sword1.wav");
		precache_sound ("knight/yell1.wav");
		precache_sound ("knight/yell2.wav");
		precache_sound ("knight/yell3.wav");

		precache_model ("progs/knight.mdl");
		precache_model ("progs/knig_c1.mdl");
		precache_model ("progs/knig_c2.mdl");

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/knight.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		if (difficulty < 2)
			monster.health = 100; // regular health
		else
			monster.health = 150; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "knight";
		monster.displayname = "Corrupted Knight";

		if (random() < 0.5)
			monster.th_stand = knight_stand1;
		else
			monster.th_stand = knight_standing1;
	
		monster.th_walk = knight_walk1;
		monster.th_run = knight_run1;
		monster.th_melee = knight_atk1;
		monster.th_missile = knight_atkb1;
		monster.th_pain = knight_pain;
		monster.th_grab = knight_grabbed1;
		monster.th_die = knight_die;
		monster.th_jump = knight_jump;
		monster.experience = 18; // how much exp to give on death
		monster.maxgold = 100;

		monster.th_block = knight_block1;
		if (!monster.ai_blockfreq) // frequency on how much the enemy blocks
		{
			if (difficulty < 2)
				monster.ai_blockfreq = 0.03; // 3% skill 1
			else
				monster.ai_blockfreq = 0.7;  // 10% skill 2
		}
	}
	
	//
	// Spawn Hunting Hound
	//
	
	if (self.cnt == 1)
	{
		precache_model ("progs/dog.mdl");
		precache_model ("progs/dog_c1.mdl");
		precache_model ("progs/dog_c2.mdl");
		precache_sound ("dog/bite.wav");
		precache_sound ("dog/yelp.wav");
		precache_sound ("dog/cry.wav");
		precache_sound ("dog/growl.wav");

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/dog.mdl");
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);

		if (difficulty < 2)
			monster.health = 51; // regular health, add 1 so fire headsmash doesn't kill in 1 hit every time
		else
			monster.health = 100; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "dog";
		monster.displayname = "Hunting Hound";
		monster.experience = 10;
		monster.maxgold = 50;
	
		monster.th_stand = dog_stand1;
		monster.th_walk = dog_walk1;
		monster.th_run = dog_run1;
		monster.th_pain = dog_pain;
		monster.th_die = dog_die;
		monster.th_melee = dog_atta1;
		monster.th_missile = dog_leap1;
		monster.th_jump = dog_jump;
	}
	
	//
	// Spawn Corrupted Commander
	//
	
	if (self.cnt == 2)
	{
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

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/hknight.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');

		if (difficulty < 2)
			monster.health = monster.max_health = 220; // regular health
		else
			monster.health = monster.max_health = 330; // hard health (50% tougher)

		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "hellknight";
		monster.displayname = "Corrupted Commander"; // new name
		monster.th_stand = hellknight_stand1;
		monster.th_walk = hellknight_walk1;
		monster.th_run = hellknight_run1;
		monster.th_melee = hellknight_attack;
		monster.th_magic = hellknight_lightning1;
		monster.th_missile = hellknight_lightning1;
		monster.th_pain = hellknight_pain;
		monster.th_die = hellknight_die;
		monster.th_jump = hellknight_jump;
		monster.th_grab = hellknight_grabbed1;
		monster.experience = 67;
		monster.maxgold = 200;

		monster.th_block = hellknight_block1;
		if (!monster.ai_blockfreq) // frequency on how much the enemy blocks
		{
			if (difficulty < 2)
				monster.ai_blockfreq = 0.10; // 3% skill 1
			else
				monster.ai_blockfreq = 0.20; // 20% skill 2
		}
	}
	
	//
	// Spawn Baron
	//
	
	if (self.cnt == 3)
	{
		precache_model ("progs/baron.mdl");
		precache_model ("progs/baron_c1.mdl");
		precache_model ("progs/baron_c2.mdl");

		precache_sound ("baron/swordraw.wav");
		precache_sound ("baron/sword.wav");
		precache_sound ("baron/sight.wav");
		precache_sound ("baron/smash.wav");
		precache_sound ("baron/pain.wav");
		precache_sound ("baron/death.wav");

		monster.solid = SOLID_SLIDEBOX;
		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/baron.mdl");

		if (difficulty < 2)
			monster.health = 300; // regular health
		else
			monster.health = 450; // hard health (50% tougher)

		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "baron";
		monster.displayname = "Baron";
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.experience = 105;
		monster.maxgold = 345;

		monster.th_stand = baron_idle1;
		monster.th_misc = baron_sight1;
		monster.th_run = baron_run1;
		monster.th_grab = baron_grabbed1;
		monster.th_pain = baron_pain;
		monster.th_die = baron_die;
		monster.th_melee = baron_melee;

		monster.th_block = baron_block1;
		if (!monster.ai_blockfreq) // frequency on how much the enemy blocks
		{
			if (difficulty < 2)
				monster.ai_blockfreq = 0.3; // 30% skill 1
			else
				monster.ai_blockfreq = 0.5; // 50% skill 2
		}
	}

	//
	// Spawn Skeleton
	//
	
	if (self.cnt == 4)
	{
		precache_model ("progs/skeleton.mdl");
		precache_model ("progs/skelhead.mdl");

		precache_sound ("skeleton/smash.wav");
		precache_sound ("skeleton/bounce.wav");
		precache_sound ("skeleton/attack.wav");
		precache_sound ("skeleton/death.wav");

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/skeleton.mdl");
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		if (difficulty < 2)
			monster.health = 160; // regular health
		else
			monster.health = 240; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "skeleton";
		monster.displayname = "Skeleton";
		monster.experience = 50;
		monster.maxgold = 166;

		monster.th_stand = skel_stand1;
		monster.th_run = skel_run1;
		monster.th_melee = skel_atk1;
		monster.th_pain = skel_pain;
		monster.th_die = skel_die;
		monster.noblood = TRUE;
		monster.th_grab = skel_grabbed1;
		monster.th_jump = skel_jump1;
	}
	
	//
	// Spawn Horror
	//
	
	if (self.cnt == 5)
	{
		precache_model ("progs/horror.mdl");

		precache_sound ("horror/pain.wav");
		precache_sound ("horror/crunch.wav");
		precache_sound ("horror/death.wav");
		precache_sound ("horror/taunt.wav");

		monster.movetype = MOVETYPE_FLY;
		setmodel (monster, "progs/horror.mdl");
		setsize(monster, '-21 -31 -16', '22 33 35');
		if (difficulty < 2)
			monster.health = 75; // regular health
		else
			monster.health = 113; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "horror";
		monster.displayname = "Horror";
		monster.experience = 31;
		monster.maxgold = 130;

		monster.th_stand = horror_stand1;
		monster.th_run = horror_run1;
		monster.th_missile = horror_fireball1;
		monster.th_pain = horror_pain;
		monster.th_die = horror_die;
	}

	//
	// Spawn Gaunt
	//
	
	if (self.cnt == 6)
	{
		precache_model ("progs/gaunt.mdl");
		precache_model ("progs/b_gaunt.mdl");
		precache_model ("progs/h_gaunt.mdl");

		precache_sound ("gaunt/charge.wav");
		precache_sound ("gaunt/pain.wav");
		precache_sound ("gaunt/death.wav");
		precache_sound ("gaunt/talk1.wav");
		precache_sound ("gaunt/talk2.wav");
		precache_sound ("gaunt/talk3.wav");
		precache_sound ("gaunt/talk4.wav");
		precache_sound ("gaunt/talk5.wav");
		precache_sound ("gaunt/talk6.wav");
		precache_sound ("gaunt/talk7.wav");
		precache_sound ("gaunt/talk8.wav");
		precache_sound ("gaunt/talk9.wav");
		precache_sound ("gaunt/talk10.wav");
		precache_sound ("gaunt/talk11.wav");
		precache_sound ("gaunt/talk12.wav");
		precache_sound ("gaunt/talk13.wav");
		precache_sound ("gaunt/talk14.wav");
		precache_sound ("gaunt/scream1.wav");
		precache_sound ("gaunt/scream2.wav");
		precache_sound ("gaunt/scream3.wav");
		precache_sound ("gaunt/scream4.wav");
		precache_sound ("gaunt/scream5.wav");
		precache_sound ("gaunt/scream6.wav");
		precache_sound ("gaunt/scream7.wav");
		precache_sound ("gaunt/scream8.wav");

		monster.solid = SOLID_SLIDEBOX;
		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/gaunt.mdl");
		if (difficulty < 2)
			monster.health = 175; // regular health
		else
			monster.health = 263; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "gaunt";
		monster.displayname = "Gaunt";
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.mana = 150; // mana, 150 is max for gaunts
		monster.th_stand = gaunt_stand1;
		monster.th_walk = gaunt_walk1;
		monster.th_run = gaunt_run1;
		monster.th_grab = gaunt_grabbed1;
		monster.th_pain = gaunt_pain;
		monster.th_die = gaunt_die;
		monster.th_melee = gaunt_finger1;
		monster.th_magic = gaunt_magic;
		monster.experience = 77;
		monster.maxgold = 166;
	}
	
	//
	// Spawn Arch Ghoul
	//
	
	if (self.cnt == 7)
	{
		precache_model ("progs/archg.mdl");
		precache_sound ("archg/pain.wav");
		precache_sound ("archg/death.wav");
		precache_sound ("gaunt/charge.wav");

		monster.solid = SOLID_SLIDEBOX;
		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/archg.mdl");
		if (difficulty < 2)
			monster.health = 225; // regular health
		else
			monster.health = 338; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "archg";
		monster.displayname = "Arch-Ghoul";
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.mana = 200; // mana, 200 is max for arch ghouls
		monster.experience = 150;
		monster.maxgold = 333;

		monster.th_stand = archg_stand1;
		monster.th_walk = archg_walk1;
		monster.th_pain = archg_pain;
		monster.th_die = archg_die;
		monster.th_grab = archg_grabbed1;
		monster.th_melee = archg_melee;

		monster.th_magic = archg_magic;
	}
	
	//
	// Spawn Ghost / Malevolent Spirit
	//
	
	if (self.cnt == 8)
	{
		precache_sound ("ghost/taunt.wav");
		precache_sound ("ghost/pain.wav");
		precache_sound ("ghost/death.wav");

		monster.movetype = MOVETYPE_NOCLIP;
		setmodel (monster, "progs/null.spr");
		monster.health = 20; // never changes
		monster.health = monster.max_health = 20; // never changes
		monster.netname = "solid";
		monster.effects = EF_DIMLIGHT;
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.experience = 21;
		monster.maxgold = 20;
		monster.flags = FL_MONSTER;
		monster.classname = "ghost";
		monster.displayname = "Malevolent Spirit";
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.noblood = TRUE;
		monster.th_stand = ghost_think;
		monster.th_run = ghost_think;
		monster.th_pain = ghost_pain;
		monster.th_die = ghost_die;
		monster.think = ghost_think;
		monster.nextthink = time + 0.1;
	}
	
	//
	// Spawn Wraith
	//
	
	if (self.cnt == 9)
	{
		precache_model ("progs/wraith.mdl");
		precache_model ("progs/wr_sword.mdl");

		precache_sound ("ghost/taunt.wav");
		precache_sound ("wraith/idle1.wav");
		precache_sound ("wraith/idle2.wav");
		precache_sound ("wraith/death.wav");
		precache_sound ("ghost/pain.wav");
		precache_sound ("ghost/death.wav");

		monster.solid = SOLID_SLIDEBOX;
		monster.movetype = MOVETYPE_NOCLIP;
		setmodel (monster, "progs/wraith.mdl");
		if (difficulty < 2)
			monster.health = 175; // regular health
		else
			monster.health = 263; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "wraith";
		monster.displayname = "Wraith";
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		monster.experience = 100;
		monster.maxgold = 360;

		monster.effects = EF_NODEPTHTEST;
		monster.alpha = 0.2;
		monster.th_stand = wraith_stand1;
		monster.th_walk = wraith_walk1;
		monster.th_pain = wraith_pain;
		monster.th_die = wraith_die;
		monster.th_melee = wraith_melee;
		monster.noblood = TRUE;	
	}
	
	//
	// Spawn Electric Squid
	//
	
	if (self.cnt == 10)
	{
		precache_model ("progs/esquid.mdl");
		precache_model ("progs/esquidcr.spr");

		precache_sound ("esquid/pain.wav");
		precache_sound ("esquid/death.wav");
		precache_sound ("esquid/deflate.wav");
		precache_sound ("esquid/charge.wav");
		precache_sound ("esquid/attack.wav");

		monster.solid = SOLID_SLIDEBOX;
		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/esquid.mdl");
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		
		if (difficulty < 2)
			monster.health = 215; // regular health
		else
			monster.health = 247; // hard health (50% tougher)
			
		monster.experience = 66;
		monster.maxgold = 141;

		monster.netname = "solid";
		monster.takedamage = DAMAGE_YES;
		monster.solid = SOLID_NOT;
		monster.classname = "esquid";
		monster.displayname = "Electric Squid";
		monster.noblood = TRUE;
		monster.th_stand = esquid_stand1;
		monster.th_walk = esquid_run1;
		monster.th_pain = esquid_pain;
		monster.th_die = esquid_die;

		monster.th_missile = esquid_lightning;
	}
	
	//
	// Spawn Gremlin
	//
	
	if (self.cnt == 11)
	{
		precache_model ("progs/grem.mdl");
		precache_sound ("gremlin/idle1.wav");
		precache_sound ("gremlin/idle2.wav");
		precache_sound ("gremlin/idle3.wav");
		precache_sound ("gremlin/idle4.wav");
		precache_sound ("gremlin/attack1.wav");
		precache_sound ("gremlin/attack2.wav");
		precache_sound ("gremlin/leap.wav");
		precache_sound ("gremlin/pain1.wav");
		precache_sound ("gremlin/pain2.wav");
		precache_sound ("gremlin/pain3.wav");
		precache_sound ("gremlin/death1.wav");
		precache_sound ("gremlin/death2.wav");

		monster.solid = SOLID_TRIGGER;
		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/grem.mdl");

		if (difficulty < 2)
			monster.health = 80; // regular health
		else
			monster.health = 120; // hard health (50% tougher)

		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.classname = "grem";
		monster.displayname = "Gremlin";
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.experience = 22;
		monster.maxgold = 90;

		monster.th_stand = grem_stand1;
		monster.th_run = grem_run1;
		monster.th_pain = grem_pain;
		monster.th_die = grem_die;
		monster.th_grab = grem_grabbed1;
		monster.th_jump = grem_jump;
		monster.th_missile = grem_leap1;
		monster.th_melee = grem_melee;
	}
	
	//
	// Spawn Ghoul
	//
	
	if (self.cnt == 12)
	{
		precache_model ("progs/ghoul.mdl");
		precache_sound ("ghoul/pain.wav");
		precache_sound ("ghoul/death.wav");

		monster.solid = SOLID_SLIDEBOX;
		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/ghoul.mdl");

		if (difficulty < 2)
			monster.health = 115; // regular health
		else
			monster.health = 173; // hard health (50% tougher)

		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "ghoul";
		monster.displayname = "Ghoul";
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.experience = 43;
		monster.maxgold = 85;

		monster.th_stand = ghoul_rise1;
		monster.th_run = ghoul_walk1;
		monster.th_pain = ghoul_pain;
		monster.th_die = ghoul_die;
		monster.th_melee = ghoul_hit1;
		monster.th_missile = ghoul_hit1;
		monster.th_grab = ghoul_grabbed1;
	}
	
	//
	// Spawn Archer
	//
	
	if (self.cnt == 13)
	{
		precache_model ("progs/archer.mdl");
		precache_model ("progs/archer_c1.mdl");
		precache_model ("progs/archer_c2.mdl");
		precache_model ("progs/arrow.mdl");

		precache_sound ("archer/arrowhit.wav");
		precache_sound ("archer/arrowuse.wav");
		precache_sound ("archer/pain1.wav");
		precache_sound ("archer/pain2.wav");
		precache_sound ("archer/death.wav");

		monster.solid = SOLID_SLIDEBOX;
		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/archer.mdl");

		if (difficulty < 2)
		{
			if (monster.mode == 0)
				monster.health = 75; // regular health
			else
				monster.health = 25; // regular health
		}
		else
		{
			if (monster.mode == 0)
				monster.health = 113; // hard health (50% tougher)
			else
				monster.health = 45;
		}

		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "archer";
		monster.displayname = "Archer";
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.experience = 19; // how much exp to give on death
		monster.maxgold = 70;

		monster.th_stand = archer_stand1;
		monster.th_run = archer_move1;
		monster.th_grab = archer_grabbed1;
		monster.th_pain = archer_pain;
		monster.th_die = archer_die;

		if (monster.mode == 0)
			monster.th_missile = archer_fire1;
		else
		{
			monster.th_missile = archer_fireb1;
			if (!monster.awareness)
				monster.awareness = 3;
		}
	}
	
	//
	// Spawn Zombie
	//
	
	if (self.cnt == 14)
	{
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

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/zombie.mdl");
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		if (difficulty < 2)
			monster.health = 150; // regular health
		else
			monster.health = 225; // hard health (50% tougher)
		monster.state = monster.health / 3; // Hold 1/3 health value for testing in damage.qc
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "zombie";
		monster.displayname = "Zombie";
		monster.experience = 32;
		monster.maxgold = 110;
		
		monster.th_stand = zombie_stand1;
		monster.th_run = zombie_run1;
		monster.th_pain = zombie_pain;
		monster.th_die = zombie_die;
		monster.th_grab = zombie_grabbed1;
		monster.th_magic = zombie_missile;
	}
	
	//
	// Spawn Zombie Boss
	//
	
	if (self.cnt == 15)
	{
		precache_model ("progs/zombieb.mdl");
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

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/zombieb.mdl");
		setsize(monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		if (difficulty < 2)
			monster.health = monster.max_health = 225; // regular health
		else
			monster.health = monster.max_health = 383; // hard health (50% tougher)
		monster.state = monster.max_health / 3; // Hold 1/3 health value for testing in damage.qc
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "zombieboss";
		monster.displayname = "Greater Zombie";
		monster.experience = 56;
		monster.maxgold = 175;

		monster.th_stand = zombie_boss_stand1;
		monster.th_run = zombie_boss_run1;
		monster.th_pain = zombie_boss_pain;
		monster.th_die = zombie_boss_die;
		monster.th_grab = zombie_boss_grabbed1;
		monster.th_magic = zombie_boss_missile;
	}

	//
	// Spawn Troglod
	//
	
	if (self.cnt == 16)
	{
		precache_sound ("troglod/tidle1.wav");
		precache_sound ("troglod/tidle2.wav");
		precache_sound ("troglod/tpain.wav");
		precache_sound ("troglod/tdeath1.wav");
		precache_sound ("troglod/tdeath2.wav");
		precache_sound ("troglod/tidle2.wav");
		precache_sound ("gaunt/charge.wav");

		precache_model ("progs/troglod.mdl");

		monster.movetype = MOVETYPE_NONE;
		setmodel (monster, "progs/troglod.mdl");
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);
		if (difficulty < 2)
			monster.health = 160; // regular health
		else
			monster.health = 240; // hard health (50% tougher)
		monster.mana = 200; // mana, 200 is max for troglod

		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "troglod";
		monster.displayname = "Troglodyte";
		monster.experience = 175;
		monster.maxgold = 400;
		
		monster.th_stand = troglod_stand1;
		monster.th_run = troglod_run1;
		monster.th_missile	= troglod_magic;
		monster.th_pain = troglod_pain;
		monster.th_die = troglod_die;
	}
	
	//
	// Spawn Dragon
	//
	
	if (self.cnt == 17)
	{
		precache_sound ("dragon/idle.wav");
		precache_sound ("dragon/pain.wav");
		precache_sound ("dragon/bite.wav");
		precache_sound ("dragon/death.wav");

		precache_model ("progs/dragon.mdl");

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/dragon.mdl");
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		if (difficulty < 2)
			monster.health = 250; // regular health
		else
			monster.health = 375; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "dragon";
		monster.displayname = "Green Dragon";
		monster.experience = 81;
		monster.maxgold = 221;

		monster.th_stand = dragon_stand;
		monster.th_walk = dragon_walk;
		monster.th_melee = dragon_atk;
		monster.th_pain = dragon_pain;
		monster.th_die = dragon_die;
		monster.ignoreaircombo = TRUE; // Aircombos do not raise Dragon off ground
	}
	
	//
	// Spawn Hydra
	//
	
	if (self.cnt == 18)
	{
		precache_sound ("hydra/die.wav");
		precache_sound ("hydra/pain.wav");
		precache_sound ("hydra/spit.wav");
		precache_sound ("hydra/attack.wav");
		
		precache_model ("progs/hydra.mdl");

		monster.movetype = MOVETYPE_FLY;
		setmodel (monster, "progs/hydra.mdl");
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		if (difficulty < 2)
			monster.health = 2; // regular health
		else
			monster.health = 5; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "hydra";
		monster.displayname = "Hydra";
		monster.flags = monster.flags | FL_MONSTER | FL_SWIM;
		monster.experience = 25;
		monster.maxgold = 115;
		
		monster.th_stand = hydra_idle;
		monster.th_walk = hydra_move;
		monster.th_melee = hydra_attack;
		monster.th_pain = hydra_pain;
		monster.th_die = hydra_die;
	}
	
	//
	// Spawn Needles
	//
	
	if (self.cnt == 19)
	{
		precache_sound ("needles/die.wav");
		
		precache_model ("progs/needles.mdl");
		setmodel (monster, "progs/needles.mdl");
		setsize(monster, VEC_HULL_MIN, VEC_HULL_MAX);

		monster.movetype = MOVETYPE_FLY;
		monster.health = 1;
		monster.solid = SOLID_TRIGGER;
		monster.takedamage = DAMAGE_AIM;
		monster.classname = "needles";
		monster.displayname = "Needles";
		monster.netname = "solid";
		monster.avelocity = '0 50 0';
		monster.cnt = 0;
		if (!monster.scale)
			monster.scale = 1;
		monster.flags = monster.flags | FL_MONSTER;
		monster.experience = 20;
		monster.maxgold = 30;
		monster.noblood = TRUE;
	
		monster.th_die = needles_die;
		monster.think = needles_think;
		monster.nextthink = time + 0.1;
		
		// This monster has it's own think function to start
		remove(self);
		return;
	}

	//
	// Spawn Merman
	//
	
	if (self.cnt == 20)
	{
		precache_model ("progs/spit.mdl");
		precache_model ("progs/merman.mdl");
		precache_sound ("merman/die.wav");
		precache_sound ("merman/pain.wav");
		precache_sound ("merman/spit.wav");
		precache_sound ("merman/dissolve.wav");

		monster.movetype = MOVETYPE_STEP; // Movetype FLY when in-water

		setmodel (monster, "progs/merman.mdl");
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		if (difficulty < 2)
			monster.health = monster.oldhealth = 77; // regular health
		else
			monster.health = monster.oldhealth = 132; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "merman";
		monster.displayname = "Merman";
		monster.experience = 44;
		monster.maxgold = 88;
		
		monster.th_stand = merman_idle;
		monster.th_walk = merman_walk;
		monster.th_run = merman_run;
		monster.th_melee = merman_attack;
		monster.th_missile = merman_spit;
		monster.th_magic = merman_spit;
		monster.th_pain = merman_pain;
		monster.th_grab = merman_grabbed1;
		monster.th_die = merman_die;
		monster.th_jump = merman_jump1;
		monster.th_swim = merman_swim;
	}

	//
	// Spawn Ethereal Skull
	//
	
	if (self.cnt == 21)
	{
		precache_model ("progs/ethskull.mdl");
		precache_model ("progs/ethflame.mdl");
		precache_sound ("skeleton/smash.wav");
		precache_sound ("ethskull/idle.wav");
		precache_sound ("ethskull/death.wav");

		monster.solid = SOLID_SLIDEBOX;
		monster.movetype = MOVETYPE_NOCLIP;
		setmodel (monster, "progs/ethskull.mdl");
		if (difficulty < 2)
			monster.health = 100; // regular health
		else
			monster.health = 150; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;

		monster.classname = "ethskull";
		monster.displayname = "Ethereal Skull";
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);

		monster.colormod = '1 1 3';
		monster.scale = 3;
		monster.alpha = 0.9;
		monster.effects = EF_NODEPTHTEST;
		monster.experience = 44;
		monster.maxgold = 118;

		monster.th_stand = ethskull_1;
		monster.th_walk = ethskull_2;
		monster.th_pain = ethskull_3;
		monster.th_die = ethskull_die;

		monster.noblood = TRUE;
		
		// Hack to properly start the flame on spawn
		local entity oself;
		oself = self;
		self = monster;
		ethskull_flame();
		self = oself;
	}

	//
	// Spawn Lesser Wraith
	//
	
	if (self.cnt == 22)
	{
		precache_model ("progs/lwraith.mdl");

		precache_sound ("wraith/idle1.wav");
		precache_sound ("wraith/idle2.wav");
		precache_sound ("wraith/death.wav");

		monster.solid = SOLID_SLIDEBOX;
		monster.movetype = MOVETYPE_NOCLIP;
		setmodel (monster, "progs/lwraith.mdl");
		if (difficulty < 2)
			monster.health = 88; // regular health
		else
			monster.health = 132; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "lesserwraith";
		monster.displayname = "Lesser Wraith";
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.experience = 67;
		monster.maxgold = 168;

		monster.alpha = 0.2;
		monster.effects = EF_NODEPTHTEST;
		
		monster.th_stand = lesserwraith_stand1;
		monster.th_walk = lesserwraith_walk1;
		monster.th_run = lesserwraith_run1;
		monster.th_pain = lesserwraith_pain;
		monster.th_die = lesserwraith_die;
		monster.th_melee = lesserwraith_melee;
		
		monster.noblood = TRUE;
	}

	//
	// Spawn Raven
	//
	
	if (self.cnt == 23)
	{
		precache_model ("progs/raven.mdl");
		precache_sound ("raven/sight.wav");
		precache_sound ("raven/flap.wav");
		precache_sound ("raven/idle.wav");
		precache_sound ("raven/melee.wav");
		precache_sound ("raven/melee2.wav");
		precache_sound ("raven/pain.wav");
		precache_sound ("raven/death.wav");
		
		setmodel (monster, "progs/raven.mdl");

		monster.health = 5;
		monster.alpha = 1;
		monster.solid = SOLID_NOT;

		monster.takedamage = DAMAGE_AIM;
		monster.classname = "raven";
		monster.displayname = "Mad Raven";
		monster.netname = "solid";
		setsize (monster, '-16 -16 -24', '16 16 24');
		monster.experience = 20;
		monster.maxgold = 33;

		monster.th_stand = raven_idle;
		monster.th_misc = raven_misc;
		monster.th_melee = raven_atk;
		monster.th_pain = raven_pain;
		monster.th_die = raven_die;
		
		if (monster.nodrop == FALSE)
		{
			monster.movetype = MOVETYPE_STEP;
			droptofloor();
		}
		else
		{
			monster.movetype = MOVETYPE_NOCLIP;
			monster.health = 1;
		}
	}

	//
	// Spawn Corrupted Captain (Knight Lv. 2)
	//
	
	if (self.cnt == 24)
	{
		precache_sound ("knight/death.wav");
		precache_sound ("knight/pain1.wav");
		precache_sound ("knight/pain2.wav");
		precache_sound ("knight/pain3.wav");
		precache_sound ("knight/sword1.wav");
		precache_sound ("knight/yell1.wav");
		precache_sound ("knight/yell2.wav");
		precache_sound ("knight/yell3.wav");

		precache_model ("progs/knight2.mdl");
		precache_model ("progs/knig2_c1.mdl");
		precache_model ("progs/knig2_c2.mdl");

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/knight2.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		if (difficulty < 2)
			monster.health = 150; // regular health
		else
			monster.health = 200; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "knight2";
		monster.displayname = "Corrupted Captain";

		monster.th_stand = knight2_stand1;	
		monster.th_walk = knight2_walk1;
		monster.th_run = knight2_run1;
		monster.th_melee = knight2_atk1;
		monster.th_missile = knight2_atkb1;
		monster.th_pain = knight2_pain;
		monster.th_grab = knight2_grabbed1;
		monster.th_die = knight2_die;
		monster.th_jump = knight2_jump;
		monster.experience = 80; // how much exp to give on death
		monster.maxgold = 220;

		monster.th_block = knight2_block1;
		if (!monster.ai_blockfreq) // frequency on how much the enemy blocks
		{
			if (difficulty < 2)
				monster.ai_blockfreq = 0.1;
			else
				monster.ai_blockfreq = 0.85;
		}
	}

	//
	// Spawn Werewolf
	//

	if (self.cnt == 25)
	{
		precache_sound ("player/twoosh.wav");
		precache_sound ("werewolf/walk1.wav");
		precache_sound ("werewolf/walk2.wav");
		precache_sound ("werewolf/pain.wav");
		precache_sound ("werewolf/idle.wav");
		precache_sound ("werewolf/attack.wav");
		precache_sound ("werewolf/howl.wav");
		precache_model ("progs/werewolf.mdl");

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/werewolf.mdl");
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		if (difficulty < 2)
			monster.health = 200; // regular health
		else
			monster.health = 300; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "werewolf";
		monster.displayname = "Werewolf";
		monster.experience = 88;
		monster.maxgold = 266;

		monster.th_stand = werewolf_stand;
		monster.th_walk = werewolf_walk;
		monster.th_run = werewolf_run;
		monster.th_melee = werewolf_atk;
		monster.th_pain = werewolf_pain_decide;
		monster.th_die = werewolf_die;
		monster.th_grab = werewolf_grabbed1;
		monster.ignoreaircombo = TRUE; // Aircombos do not raise werewolf off ground
	}
	
	//
	// Spawn Ghost 2 / Sorrowful Spirit
	//
	
	if (self.cnt == 26)
	{
		precache_sound ("ghost/taunt.wav");
		precache_sound ("ghost/pain.wav");
		precache_sound ("ghost/death.wav");

		monster.movetype = MOVETYPE_NOCLIP;
		setmodel (monster, "progs/null.spr");
		monster.health = 20; // never changes
		monster.health = monster.max_health = 20; // never changes
		monster.netname = "solid";
		monster.effects = EF_DIMLIGHT;
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.experience = 21;
		monster.maxgold = 20;
		monster.flags = FL_MONSTER;
		monster.classname = "ghost2";
		monster.displayname = "Sorrowful Spirit";
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.noblood = TRUE;
		monster.th_stand = ghost2_think;
		monster.th_run = ghost2_think;
		monster.th_pain = ghost2_pain;
		monster.th_die = ghost2_die;
		monster.think = ghost2_think;
		monster.nextthink = time + 0.1;
	}
	
	//
	// Spawn Stone Golem
	//

	if (self.cnt == 27)
	{
		precache_sound ("golem/walk1.wav");
		precache_sound ("golem/walk2.wav");
		precache_sound ("golem/death.wav");
		precache_sound ("golem/pain1.wav");
		precache_sound ("golem/pain2.wav");

		precache_sound ("player/twoosh.wav");
		precache_sound ("baron/smash.wav");
		precache_sound ("misc/explode.wav");

		precache_model ("progs/rubble1.mdl");
		precache_model ("progs/rubble2.mdl");
		precache_model ("progs/rubble3.mdl");
		precache_model ("progs/golem.mdl");

		monster.movetype = MOVETYPE_STEP;
		setmodel (monster, "progs/golem.mdl");
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		if (difficulty < 2)
			monster.health = monster.max_health = 138; // regular health
		else
			monster.health = monster.max_health = 207; // hard health (50% tougher)
		monster.netname = "solid";
		monster.takedamage = DAMAGE_AIM;
		monster.solid = SOLID_NOT;
		monster.classname = "golem";
		monster.displayname = "Stone Golem";
		monster.experience = 44;
		monster.maxgold = 125;

		monster.th_stand = golem_stand;
		monster.th_walk = golem_walk;
		monster.th_run = golem_run;
		monster.th_melee = golem_decide_atk;	
		monster.th_pain = golem_pain;
		monster.th_die = golem_die;
		
		monster.ignoreaircombo = TRUE; // Aircombos do not raise golem off ground
		monster.noblood = TRUE;
	}

	//
	// Spawn Medusa Head Spawner - Directly turns the spawn_monster entity into a medusahead_spawner entity
	//
	
	if (self.cnt == 99)
	{
		if (!self.cnt2) // how fast to spawn + random 4 seconds
			self.cnt2 = 5;
		if (!self.speed) // speed it moves forward at
			self.speed = 70;
		if (!self.flytime) // medusa head decides to move up/down by second
			self.flytime = 1;
		if (!self.attack_finished) // how long to fly before removing itself
			self.attack_finished = time + 60;

		precache_sound ("medusa/headdie.wav");
		precache_model ("progs/medusahead.mdl");
		setmodel (self, "progs/null.spr");

		self.movetype = MOVETYPE_NOCLIP;
		self.solid = SOLID_NOT;
		self.takedamage = DAMAGE_NO;
		self.classname = "medusaspawner";
		setsize(self, '0 0 0', '0 0 0');

		self.think = medusa_spawn;
		self.nextthink = time + self.cnt2;
		
		// Medusa Head Spawner is setup and there's no need to continue
		return;
	}

	if (self.experience) // override default experience if given
		monster.experience = self.experience;

	monster.max_health = monster.health; // Setup half-health triggers
	monster.spawnflags = self.spawnflags; // carry spawnflags
	
	monster.think = enemy_start; // start the monster after spawn
	monster.nextthink = time;
	
	remove(self);
	return;
};

void() spawn_monster =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/null.spr");
	precache_sound ("misc/teleport.wav");

	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "spawnmonster";
	setsize(self, '0 0 0', '0 0 0');

	self.use = spawn_monster_use;
};