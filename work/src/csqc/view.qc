#pragma warning disable Q207 // disable pos duplicate definition ignored warning

.string message;
entity head, head2, gold, gold2, key1, potion, potion2;
float pause_frame;
float hpbar_old_frac;
float hpbar_draw_frac;
float hpbar_draw_delay;

float mon_hpbar_old_frac;
float mon_hpbar_draw_frac;
float mon_hpbar_draw_delay;

void(float screenwidth, float screenheight) DrawLevelName =
{
	local vector pos = [(screenwidth - stringwidth(world.message, TRUE, '18 18 0'))/2, (screenheight - 18)/3];

	drawstring(pos - '1 1', world.message, '18 18', '0 0 0', (sin(cltime*0.95)*1), DRAWFLAG_NORMAL); // shadow
	drawstring(pos + '1 1', world.message, '18 18', '0 0 0', (sin(cltime*0.95)*1), DRAWFLAG_NORMAL); // shadow
	drawstring(pos, world.message, '18 18', '.9 .1 0', (sin(cltime*0.95)*1), DRAWFLAG_NORMAL);
};

void(vector pos) DrawGoldStatus =
{
	if (cvar("deathmatch") > 0)
		return;

	local float gold = getstatf(STAT_GOLD);
	local string h = ftos(gold);

	if (gold < 10)
		Hud_DrawLargeValue(pos+'-18 0 0', gold, 25); // 1st digit
	if (gold > 9 && gold < 100)
		Hud_DrawLargeValue(pos+'6 0 0', gold, 25); // 2nd digit
	if (gold > 99 && gold < 1000)
		Hud_DrawLargeValue(pos+'30 0 0', gold, 25); // 3rd digit
	if (gold > 999 && gold < 10000)
		Hud_DrawLargeValue(pos+'56 0 0', gold, 25); // 4th digit
	if (gold > 9999 && gold < 100000)
		Hud_DrawLargeValue(pos+'80 0 0', gold, 25); // 5th digit
	if (gold > 99999 && gold < 1000000)
		Hud_DrawLargeValue(pos+'105 0 0', gold, 25); // 6th digit
	if (gold > 999999 && gold < 10000000)
		Hud_DrawLargeValue(pos+'128 0 0', gold, 25); // 7th digit
	if (gold > 9999999 && gold < 100000000)
		Hud_DrawLargeValue(pos+'153 0 0', gold, 25); // 8th digit
	if (gold > 99999999 && gold < 1000000000)
		Hud_DrawLargeValue(pos+'177 0 0', gold, 25); // 9th digit
};

void(float screenwidth, float screenheight) DrawPouchIcon =
{
	local vector pos = [(screenwidth - stringwidth("", TRUE, '20 20 0'))/5.8, (screenheight - 18)/254];
	drawpic (pos + '1 1', "progs/pouch.png", '20 20', '0 0 0', 1, DRAWFLAG_NORMAL); // Shadow
	drawpic (pos, "progs/pouch.png", '20 20', '1 1 1', 1, DRAWFLAG_NORMAL);
};

void(vector pos) DrawSwordStatus =
{
	if (cvar("deathmatch") > 0)
		return;

	local float sword = getstatf(STAT_SWORD);
	
	drawpic (pos - '5 9', "progs/swordicon.png", '14 24 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
	drawpic (pos - '7 10', "progs/swordicon.png", '14 24 0', '1 1 1', 1, DRAWFLAG_NORMAL); // sword pic

	Hud_DrawLargeValue_Items(pos - '50 0', sword, 25); // 1st digit
};

void(vector pos) DrawArmorStatus =
{
	if (cvar("deathmatch") > 0)
		return;

	local float armor = getstatf(STAT_ARMOR2);
	
	drawpic (pos - '8 8', "progs/armoricon.png", '24 24 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
	drawpic (pos - '10 10', "progs/armoricon.png", '24 24 0', '1 1 1', 1, DRAWFLAG_NORMAL); // armor pic

	Hud_DrawLargeValue_Items(pos - '45 0', armor, 25); // 1st digit
};

void(vector pos) DrawMonsterStats =
{
	local string display = getstats(STAT_MONSTER_NAME);

	local float maxhp = getstatf(STAT_MON_MAXHEALTH);
	local float hp = getstatf(STAT_MON_HEALTH);

	local float hpfrac = hp/maxhp;
	local float minfrac = min(mon_hpbar_draw_frac,hpfrac);
	local float maxfrac = max(mon_hpbar_draw_frac,hpfrac);

	pos_x = 3;
	pos_y = 460;

	local vector barpos = pos;
	if (display != "") // monster names on show
	{
		local float hpfrac = hp; ///maxhp;
		if (hpfrac != mon_hpbar_old_frac)
		{
			mon_hpbar_draw_delay = cltime + 0.1;
			mon_hpbar_old_frac = hpfrac;
		}
		if (cltime > mon_hpbar_draw_delay)
		{
			local float barspeed = frametime*0.65;
		
			if ((mon_hpbar_draw_frac-hpfrac) > barspeed)
			{
				mon_hpbar_draw_frac -= barspeed;
			} 
			else if ((hpfrac-mon_hpbar_draw_frac) > barspeed)
			{
				mon_hpbar_draw_frac += barspeed;
			} 
			else
			{
				mon_hpbar_draw_frac = hpfrac;
			}
		}
	
		drawsubpic(barpos, '164 16', "gfx/hpbar/new/hpbar_background", '0 0', '1 1', '0 0 0', 1, DRAWFLAG_NORMAL); 	//background
		drawsubpic(barpos, [164*minfrac, 16], "gfx/hpbar/new/monbar", '0 0', [minfrac, 1], '1 1 1', 1, DRAWFLAG_NORMAL); 	//hpbar
		drawsubpic(barpos, '164 16', "gfx/hpbar/new/hpbar_foreground", '0 0', '1 1', '1 1 1', 1, DRAWFLAG_NORMAL); 	//foreground

		// Draw Text
		drawstring (pos+'9.5 4.5', display, '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos+'10.5 5.5', display, '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos+'10 5', display, '8 8', '1 0 0', 1, DRAWFLAG_NORMAL);
	}
};

void(vector pos) DrawCurrentSelectedSpell =
{
	local float mp = getstatf(STAT_MANA);
	local float selected_spell = getstatf(STAT_SPELL);
	
	if (selected_spell == 0) //  Fireball
	{
		drawpic (pos + '1 1', "progs/spell1_s.png", '32 32 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawpic (pos, "progs/spell1_s.png", '32 32 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		// Draw Mana Cost
		drawstring (pos + '25 16', "10mp", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos + '24 16', "10mp", '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);

		if (mp >= 7 && mp < 10) // Draw tired icon
		{
			drawpic (pos + '17 21', "progs/arrow_d.png", '8 8 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos + '16 20', "progs/arrow_d.png", '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		else if (mp < 7) // Draw unavailable icon
		{
			drawstring (pos + '18 21', "^0X", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos + '17 20', "X", '8 8', '1 0 0', 1, DRAWFLAG_NORMAL);			
		}
	}
	else if (selected_spell == 1) // Lightning
	{
		drawpic (pos + '1 1', "progs/spell2_s.png", '32 32 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawpic (pos, "progs/spell2_s.png", '32 32 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		// Draw Mana Cost
		drawstring (pos + '25 16', "50mp", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos + '24 16', "50mp", '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);

		if (mp >= 33 && mp < 50) // Draw tired icon
		{
			drawpic (pos + '17 21', "progs/arrow_d.png", '8 8 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos + '16 20', "progs/arrow_d.png", '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		else if (mp < 33) // Draw unavailable icon
		{
			drawstring (pos + '18 21', "^0X", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos + '17 20', "X", '8 8', '1 0 0', 1, DRAWFLAG_NORMAL);
		}
	}
	else if (selected_spell == 2) // Ice Field
	{
		drawpic (pos + '1 1', "progs/spell3_s.png", '32 32 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawpic (pos, "progs/spell3_s.png", '32 32 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		// Draw Mana Cost
		drawstring (pos + '25 16', "30mp", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos + '24 16', "30mp", '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);

		if (mp >= 20 && mp < 30) // Draw tired icon
		{
			drawpic (pos + '17 21', "progs/arrow_d.png", '8 8 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos + '16 20', "progs/arrow_d.png", '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		else if (mp < 20) // Draw unavailable icon
		{
			drawstring (pos + '18 21', "^0X", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos + '17 20', "X", '8 8', '1 0 0', 1, DRAWFLAG_NORMAL);
		}
	}
	else if (selected_spell == 4) // Fire Beam
	{
		drawpic (pos + '1 1', "progs/spell4_s.png", '32 32 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawpic (pos, "progs/spell4_s.png", '32 32 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		// Draw Mana Cost
		drawstring (pos + '25 16', "100mp", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos + '24 16', "100mp", '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);

		if (mp >= 67 && mp < 100) // Draw tired icon
		{
			drawpic (pos + '17 21', "progs/arrow_d.png", '8 8 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos + '16 20', "progs/arrow_d.png", '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		else if (mp < 67) // Draw unavailable icon
		{
			drawstring (pos + '18 21', "^0X", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos + '17 20', "X", '8 8', '1 0 0', 1, DRAWFLAG_NORMAL);
		}
	}
	else if (selected_spell == 8) // Twister
	{
		drawpic (pos + '1 1', "progs/spell5_s.png", '32 32 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawpic (pos, "progs/spell5_s.png", '32 32 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		// Draw Mana Cost
		drawstring (pos + '25 16', "75mp", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos + '24 16', "75mp", '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);
		
		if (mp >= 50 && mp < 75) // Draw tired icon
		{
			drawpic (pos + '17 21', "progs/arrow_d.png", '8 8 0', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos + '16 20', "progs/arrow_d.png", '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		else if (mp < 50) // Draw unavailable icon
		{
			drawstring (pos + '18 21', "^0X", '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos + '17 20', "X", '8 8', '1 0 0', 1, DRAWFLAG_NORMAL);
		}		
	}
};

void(float screenwidth, float screenheight) DrawPriceDisplay =
{
	local float price = getstatf(STAT_PRICE);

	local string h = ftos(price);
	local vector pos = [(screenwidth - stringwidth(h, TRUE, '18 18 0'))/2-20, (screenheight - 18)/1.14];
	local vector pos2 = [(screenwidth - stringwidth(h, TRUE, '18 18 0'))/2, (screenheight - 18)/1.15];

	//draw order on screen, pic then string
	drawpic (pos2, "progs/goldicon.png", '32 32 0', '1 1 1', 1, DRAWFLAG_NORMAL);

	if (price < 10)
		Hud_DrawLargeValue(pos, price, 25); // 1st digit
	if (price > 9 && price < 100)
		Hud_DrawLargeValue(pos+'18 0 0', price, 25); // 2nd digit
	if (price > 99 && price < 1000)
		Hud_DrawLargeValue(pos+'46 0 0', price, 25); // 3rd digit
	if (price > 999 && price < 10000)
		Hud_DrawLargeValue(pos+'72 0 0', price, 25); // 4th digit
	if (price > 9999 && price < 100000)
		Hud_DrawLargeValue(pos+'94 0 0', price, 25); // 5th digit
	if (price > 99999 && price < 1000000)
		Hud_DrawLargeValue(pos+'116 0 0', price, 25); // 6th digit
	if (price > 999999 && price < 10000000)
		Hud_DrawLargeValue(pos+'140 0 0', price, 25); // 7th digit
	if (price > 9999999 && price < 100000000)
		Hud_DrawLargeValue(pos+'166 0 0', price, 25); // 8th digit
};

void(vector pos) DrawHPBar =
{
	local float maxhp = getstatf(STAT_MAXHEALTH);
	local float hp = getstatf(STAT_HEALTH);
	
	// HP gets set to 9999 on Vigil's death, so we'll show the user 0.
	if (hp == 9999)
		hp = 0;
	
	//drawfill('0 0', '256 256', 1, 1);
	
    //
    // HP Text
    //
    local string hp_str = sprintf("%d", hp);
    local string maxhp_str = sprintf(" / %d", maxhp);
    local float max_width = 50;
    local float scale = min(max_width/(stringwidth(hp_str,TRUE,'13 13') + stringwidth(hp_str,TRUE,'10 10')),1);
    
    //
	// HP Bar
	//
	
	local float hpfrac = hp/maxhp;
	if (hpfrac != hpbar_old_frac)
	{
		hpbar_draw_delay = cltime + 0.8;
		hpbar_old_frac = hpfrac;
	}
	
	if (cltime > hpbar_draw_delay)
	{
		local float barspeed = frametime*0.65;
		
		if ((hpbar_draw_frac-hpfrac) > barspeed)
		{
			hpbar_draw_frac -= barspeed;
		} 
		else if ((hpfrac-hpbar_draw_frac) > barspeed)
		{
			hpbar_draw_frac += barspeed;
		} 
		else
		{
			hpbar_draw_frac = hpfrac;
		}
	}

	local vector barpos = pos;
	local float minfrac = min(hpbar_draw_frac,hpfrac);
	local float maxfrac = max(hpbar_draw_frac,hpfrac);
	
	drawsubpic(barpos, '164 16', "gfx/hpbar/new/hpbar_background", '0 0', '1 1', '1 1 1', 1, DRAWFLAG_NORMAL); 	//background
	
	drawsubpic(barpos, [164*maxfrac, 16], "gfx/hpbar/new/hpbar_desat", '0 0', [maxfrac, 1], '1 0.9 0.6', 1, DRAWFLAG_NORMAL);  //hpbar desat
	drawsubpic(barpos, [164*minfrac, 16], "gfx/hpbar/new/hpbar", '0 0', [minfrac, 1], '1 1 1', 1, DRAWFLAG_NORMAL); 	//hpbar
	
	drawsubpic(barpos, '164 16', "gfx/hpbar/new/hpbar_foreground", '0 0', '1 1', '1 1 1', 1, DRAWFLAG_NORMAL); 	//foreground
	
	// Draw text over bar

	// Current hp
    local vector textpos = pos + '10 5 0';

    drawstring (textpos + '1 1', hp_str, [8*scale, 8], '0 0 0', 1, DRAWFLAG_NORMAL); // HP text shadow
    drawstring (textpos, hp_str, [8*scale, 8], '1 1 1', 1, DRAWFLAG_NORMAL);
    textpos_x += (stringwidth(hp_str, TRUE, [8*scale, 8])) + 1;
    
    // Max hp
    drawstring (textpos + '1 1', maxhp_str, [8*scale, 8], '0 0 0', 1, DRAWFLAG_NORMAL); // Max HP text shadow
    drawstring (textpos, maxhp_str, [8*scale, 8], '1 1 1', 1, DRAWFLAG_NORMAL);
};

float mpbar_old_frac;
float mpbar_draw_frac;
float mpbar_draw_delay;

void(vector pos) DrawMPBar =
{
	local float maxmp = getstatf(STAT_MAXMANA);
	local float mp = getstatf(STAT_MANA);
	
	//drawfill('0 0', '256 256', 1, 1);
	
	//
	// MP Bar
	//
	local float mpfrac = mp/maxmp;
	if (mpfrac != mpbar_old_frac)
	{
		mpbar_draw_delay = cltime + 0.35;
		mpbar_old_frac = mpfrac;
	}
	
	if (cltime > mpbar_draw_delay)
	{
		local float barspeed = frametime*0.45;
		
		if ((mpbar_draw_frac-mpfrac) > barspeed)
		{
			mpbar_draw_frac -= barspeed;
		} 
		else if ((mpfrac-mpbar_draw_frac) > barspeed)
		{
			mpbar_draw_frac += barspeed;
		} 
		else
		{
			mpbar_draw_frac = mpfrac;
		}
	}
	
	local vector barpos = pos;
	local float minfrac = min(mpbar_draw_frac,mpfrac);
	local float maxfrac = max(mpbar_draw_frac,mpfrac);
	
	drawsubpic(barpos, '124 12', "gfx/hpbar/new/hpbar_background", '0 0', '1 1', '1 1 1', 1, DRAWFLAG_NORMAL); 	//background
	
	drawsubpic(barpos, [124*maxfrac, 12], "gfx/hpbar/new/hpbar_desat", '0 0', [maxfrac, 1], '0.5 0.7 0.8', 1, DRAWFLAG_NORMAL); //desaturated mpbar
	drawsubpic(barpos, [124*minfrac, 12], "gfx/hpbar/new/hpbar_desat", '0 0', [minfrac, 1], '0.1 0.1 1', 1, DRAWFLAG_NORMAL); //mpbar
	
	drawsubpic(barpos, '124 12', "gfx/hpbar/new/hpbar_foreground", '0 0', '1 1', '1 1 1', 1, DRAWFLAG_NORMAL); 	//foreground

	//
	// MP Text
	//
	
	// Current mp
	local string str = sprintf("%d", mp);
	local vector textpos = pos + '8 3.5 0';
	drawstring (textpos + '1 1', str, '7 7', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
	drawstring (textpos, str, '7 7', '1 1 1', 1, DRAWFLAG_NORMAL);

	textpos_x += (stringwidth(str,1)*7) + 1;
	textpos_y += 0;
	
	// Max mp
	local string str = sprintf(" / %d", maxmp);
	drawstring (textpos + '1 1', str, '7 7', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
	drawstring (textpos, str, '7 7', '1 1 1', 1, DRAWFLAG_NORMAL);
}

float xpbar_old_frac;
float xpbar_draw_frac;
float xpbar_draw_delay;
float xpbar_old_level;

void(vector pos) DrawXPBar =
{
	local float level = getstatf(STAT_LEVEL);
	local float maxxp = level + (18 * level);
	local float xp = getstatf(STAT_EXP);
	
	if (level != xpbar_old_level)
	{
		xpbar_old_frac = xp/maxxp;
		xpbar_draw_frac = xpbar_old_frac;
		xpbar_old_level = level;
	}
	
	//drawfill('0 0', '256 256', 1, 1);

	//
	// XP Bar
	//
	
	local float xpfrac = xp/maxxp;
	if (xpfrac != xpbar_old_frac)
	{
		xpbar_draw_delay = cltime + 0.8;
		xpbar_old_frac = xpfrac;
	}
	
	if (cltime > xpbar_draw_delay)
	{
		local float barspeed = frametime*0.65;
		
		if ((xpbar_draw_frac-xpfrac) > barspeed)
		{
			xpbar_draw_frac -= barspeed;
		} 
		else if ((xpfrac-xpbar_draw_frac) > barspeed)
		{
			xpbar_draw_frac += barspeed;
		} 
		else
		{
			xpbar_draw_frac = xpfrac;
		}
	}
	
	local vector barpos = pos;
	local float minfrac = min(xpbar_draw_frac,xpfrac);
	local float maxfrac = max(xpbar_draw_frac,xpfrac);
	
	drawsubpic(barpos, '112 6', "gfx/hpbar/new/xpbar_background", '0 0', '1 1', '1 1 1', 1, DRAWFLAG_NORMAL); 	//background
	
	drawsubpic(barpos, [112*maxfrac, 6], "gfx/hpbar/new/xpbar", '0 0', [maxfrac, 1], '0.6 0.75 0.65', 1, DRAWFLAG_NORMAL);  //xpbar desat
	drawsubpic(barpos, [112*minfrac, 6], "gfx/hpbar/new/xpbar", '0 0', [minfrac, 1], '0 0.7 0', 1, DRAWFLAG_NORMAL); 	//xpbar
	
	drawsubpic(barpos, '112 6', "gfx/hpbar/new/xpbar_foreground", '0 0', '1 1', '1 1 1', 1, DRAWFLAG_NORMAL); 	//foreground
}

//
// Wad image names in array form, for easier access.
//

static string number[10] =
{
	"gfx/num_0",
	"gfx/num_1",
	"gfx/num_2",
	"gfx/num_3",
	"gfx/num_4",
	"gfx/num_5"
	"gfx/num_6",
	"gfx/num_7",
	"gfx/num_8",
	"gfx/num_9"
};

static string anumber[10] =
{
	"gfx/anum_0",
	"gfx/anum_1",
	"gfx/anum_2",
	"gfx/anum_3",
	"gfx/anum_4",
	"gfx/anum_5",
	"gfx/anum_6",
	"gfx/anum_7",
	"gfx/anum_8",
	"gfx/anum_9"
};

void Hud_DrawLargeValue(vector pos, float value, float threshhold);
void(float screenwidth, float screenheight) DrawComboDamageCounter =
{
	if (world.model == "maps/village.bsp")
		return;

	local float msg = getstatf(STAT_COMBOMSG);
	local float h = getstatf(STAT_COMBO);
	
	local float dmg = getstatf(STAT_CURRENT_DAMAGE);
	local float totaldmg = getstatf(STAT_TOTAL_DAMAGE);

	// Combo counter position
	local vector pos = [(screenwidth - stringwidth("", TRUE, '18 18 0'))/1.5, (screenheight - 18)/2.25];
	local vector pos2 = [(screenwidth - stringwidth("", TRUE, '122 40.5 0'))/1.30, (screenheight - 18)/2.5];

	// Damage text position
	local string g = ftos(dmg);
	local string f = ftos(totaldmg);
	local vector pos3 = [(screenwidth - stringwidth("", TRUE, '122 40.5 0'))/1.25, (screenheight - 18)/1.95];
	
	// Draw damage
	if (!msg)
	{
		if (dmg > 0 && h > 1)
		{
			// draw #
			drawstring (pos3 - '6 1', g, '16 16', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos3 - '4 -1', g, '16 16', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos3 - '5 0', g, '16 16', '1 1 1', 1, DRAWFLAG_NORMAL);
			// draw "damage" text
			drawstring (pos3 + '31 6', "Damage ", '12 12', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos3 + '29 4', "Damage ", '12 12', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos3 + '30 5', "Damage ", '12 12', '1 0 0', 1, DRAWFLAG_NORMAL);
		}
	}
	else // Draw total damage
	{
		// draw #
		drawstring (pos3 - '13 1', f, '16 16', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos3 - '11 -1', f, '16 16', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos3 - '12 0', f, '16 16', '1 1 1', 1, DRAWFLAG_NORMAL);
		// draw "damage" text
		drawstring (pos3 + '21 6', "Total Damage ", '12 12', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos3 + '19.5 4', "Total Damage ", '12 12', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos3 + '20 5', "Total Damage ", '12 12', '1 0 0', 1, DRAWFLAG_NORMAL);
	}

	if (h > 1)
	{
		Hud_DrawLargeValue_Red(pos, h, 25);
		drawpic (pos2 + '1 1', "progs/strikes.png", '122 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawpic (pos2, "progs/strikes.png", '122 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
	}

	if (msg > 0 && h < 2)
	{
		if (msg == 1)
		{
			drawpic (pos2 + '1 1', "progs/cmbomsg1.png", '196 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos2, "progs/cmbomsg1.png", '196 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		if (msg == 2)
		{
			drawpic (pos2 + '1 1', "progs/cmbomsg2.png", '196 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos2, "progs/cmbomsg2.png", '196 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		if (msg == 3)
		{
			drawpic (pos2 + '1 1', "progs/cmbomsg3.png", '196 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos2, "progs/cmbomsg3.png", '196 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		if (msg == 4)
		{
			drawpic (pos2 + '1 1', "progs/cmbomsg4.png", '196 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos2, "progs/cmbomsg4.png", '196 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		if (msg == 5) // Adjust slightly
		{
			drawpic (pos2 - '14 1', "progs/cmbomsg5.png", '196 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos2 - '15 0', "progs/cmbomsg5.png", '196 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		if (msg == 6) // Adjust slightly
		{
			drawpic (pos2 - '9 1', "progs/cmbomsg6.png", '196 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos2 - '10 0', "progs/cmbomsg6.png", '196 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		if (msg == 7)
		{
			drawpic (pos2 + '1 1', "progs/cmbomsg7.png", '196 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos2, "progs/cmbomsg7.png", '196 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		if (msg == 8)
		{
			drawpic (pos2 + '1 1', "progs/cmbomsg8.png", '196 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos2, "progs/cmbomsg8.png", '196 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
		if (msg == 9)
		{
			drawpic (pos2 + '1 1', "progs/cmbomsg9.png", '196 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawpic (pos2, "progs/cmbomsg9.png", '196 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
	}
};

void(float screenwidth, float screenheight) DrawPerfectGuard =
{
	local vector pos2 = [(screenwidth - stringwidth("", TRUE, '122 40.5 0'))/1.30, (screenheight - 18)/3];
	drawpic (pos2 + '1 1', "progs/perfgrd.png", '122 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
	drawpic (pos2, "progs/perfgrd.png", '122 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
};

void(float screenwidth, float screenheight) DrawAbsorption =
{
	local vector pos2 = [(screenwidth - stringwidth("", TRUE, '122 40.5 0'))/1.275, (screenheight - 18)/3.6];
	drawpic (pos2 + '1 1', "progs/absorb.png", '122 40.5', '0 0 0', 1, DRAWFLAG_NORMAL); // Shadow
	drawpic (pos2, "progs/absorb.png", '122 40.5', '1 1 1', 1, DRAWFLAG_NORMAL);
};

//
// Reki's Code to draw 3D Objects properly on the HUD
//

void(entity ent, vector pos, vector canvas_size, float zoom) entdraw =
{
    clearscene();
    setviewprop(VF_MIN, pos);
    setviewprop(VF_SIZE, canvas_size);
 
    setviewprop(VF_AFOV, 25);
    setviewprop(VF_DRAWWORLD, FALSE);
 
    setviewprop(VF_ORIGIN, [zoom, 0, 0]);
    setviewprop(VF_ANGLES, '0 0 0');
 
    addentity(ent);
    renderscene();
};

//
// Draw 3D Gold/Church Key on HUD
//

void() AnimateKey =
{
	key1.origin = [0, 0, -15 + (sin(cltime)*3)];
	key1.angles_y = cltime*50;
};

float Draw_Key_Once;
void(vector pos) DrawKey1 =
{
	if (!Draw_Key_Once) // Call this one time so we're not spawning infinite key entities
	{
		Draw_Key_Once = 1;
		
		key1 = spawn();
		precache_model("progs/key.mdl");
		setmodel(key1, "progs/key.mdl");
		setorigin(key1, '0 0 0');
		key1.effects = EF_FULLBRIGHT;
	}
	AnimateKey();
	entdraw(key1, pos,'32 32', -264);
};

//
// Draw 3D Gold on HUD
//

float Draw_Gold_Once;
void(vector pos) DrawGoldHUD =
{
	if (cvar("deathmatch") > 0)
		return;

	if (!Draw_Gold_Once) // Call this one time so we're not spawning infinite gold entities
	{
		Draw_Gold_Once = 1;
		
		gold = spawn();
		precache_model("progs/gold.mdl");
		setmodel(gold, "progs/gold.mdl");
		setorigin(gold, '0 0 0');
		gold.effects = EF_FULLBRIGHT;
		gold.frame = 0;
		gold.origin = '0 0 -15';
		gold.angles_x = -25;
		gold.scale = 0.5;

		gold2 = spawn();
		precache_model("progs/gold.mdl");
		setmodel(gold2, "progs/gold.mdl");
		setorigin(gold2, '0 0 0');
		gold2.frame = 0;
		gold2.origin = '0 0 -15';
		gold2.angles_x = -25;
		gold2.colormod = '-255 -255 -255'; // Shadow
		gold2.scale = 0.5;
	}
	entdraw(gold2, pos + '1 1', '14 100', -112); // Shadow
	entdraw(gold, pos, '14 100', -112);
};

//
// Draw Health Potion model on HUD
//

void(vector pos) DrawFlaskStatus =
{
	local float flask = getstatf(STAT_FLASK);
	local string h = ftos(flask);
	local string display_final = strcat("^b", h);

	// Draw current flask amount

	if (flask == 0) // blink with ^b on zero flask left
	{
		drawstring (pos + '22 0' + '1 1', display_final, '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos + '22 0', display_final, '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);
	}
	else
	{
		drawstring (pos + '22 0' + '1 1', h, '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos + '22 0', h, '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);
	}

	local float maxflask = getstatf(STAT_FLASK_MAX);
	local string s = ftos(maxflask);

	// Draw "-"/"--"
	if (maxflask < 99)
	{
		drawstring (pos + '24 7', "=", '20 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos + '23 6', "=", '20 8', '1 1 1', 1, DRAWFLAG_NORMAL);
	}
	else
	{
		drawstring (pos + '24 7', "==", '20 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawstring (pos + '23 6', "==", '20 8', '1 1 1', 1, DRAWFLAG_NORMAL);
	}

	// Draw max flask amount
	drawstring (pos + '22 14', s, '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
	drawstring (pos + '22 13', s, '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);

	// Draw X over flask on certain conditions

	local float maxhp = getstatf(STAT_MAXHEALTH);
	local float hp = getstatf(STAT_HEALTH);
    local float blind = getstatf(STAT_STATUS_BLIND);
    local float poison = getstatf(STAT_STATUS_POISON);
    local float broken = getstatf(STAT_STATUS_BROKEN);

	if (cltime % 1 < 0.50)
	{
		if (time < poison || time < blind || time < broken)
		{
			if (flask == 0)
			{
				drawstring (pos + '5 8', "X", '16 16', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
				drawstring (pos + '5 7', "X", '16 16', '1 1 1', 1, DRAWFLAG_NORMAL);
			}
			else
			{
				drawstring (pos + '10 9', "!", '16 16', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
				drawstring (pos + '10 8', "!", '16 16', '1 1 1', 1, DRAWFLAG_NORMAL);
			}
		}
		else if (hp >= maxhp || flask == 0)
		{
			drawstring (pos + '5 8', "X", '16 16', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
			drawstring (pos + '5 7', "X", '16 16', '1 1 1', 1, DRAWFLAG_NORMAL);
		}
	}
};

void() AnimateFlask =
{
	local float flask = getstatf(STAT_FLASK);
	local float maxhp = getstatf(STAT_MAXHEALTH);
	local float hp = getstatf(STAT_HEALTH);
	
	if (hp >= maxhp || flask == 0)
		potion.angles_y = 0;
	else
		potion.angles_y = 180 + sin(cltime*0.45)*65;
};


float Draw_Potion_Once;
void(vector pos) Draw_Health_Potion =
{
    if (!Draw_Potion_Once) // Call this one time so we're not spawning infinite potion entities
    {
        Draw_Potion_Once = 1;
 
        potion = spawn();
        precache_model("progs/hpot.mdl");
        setmodel(potion, "progs/hpot.mdl");
        setorigin(potion, '0 0 0');
		potion.drawflags = 7;
		potion.abslight = 355;
		potion.angles_y = 45;
		
        potion2 = spawn();
        setmodel(potion2, "progs/hpot.mdl");
        setorigin(potion2, '0 0 0');
		potion2.colormod = '0 0 0';
    }
	AnimateFlask();
    entdraw(potion2, pos + '1 1', '25 45', -175); // Shadow
	entdraw(potion, pos, '25 45', -175);
};

//
// Draw 3D Vigil Head on HUD
//

.float cnt;
.float blink;
.float blink_finished;
void() AnimateHead =
{
	local float blind = getstatf(STAT_STATUS_BLIND);
	local float poison = getstatf(STAT_STATUS_POISON);
	local float pg = getstatf(STAT_PERFECTGUARD);
	local float pf = getstatf(STAT_HEAD_PAIN);
	local float hp = getstatf(STAT_HEALTH);
	local float h = getstatf(STAT_COMBO);
	local float g = getstatf(STAT_HEAD_GOD);

	if (hp != 9999) // Not dead
	{
		if (g) // God mode on
		{
			head.skin = 4;
			head.angles_x = sin(cltime*0.65)*8;
			head.angles_y = 180 + sin(cltime*0.45)*25;
			head.colormod = '2 2 1';
		}
		else
		{
			head.origin = '0 0 -5';

			if (pg > time)
				head.colormod = '2 2 1';
			else if (blind > time)	
				head.colormod = '0.25 0.25 0.25';
			else if (poison > time)
				head.colormod = '0 1 0';
			else
				head.colormod = '1 1 1';

			if (h > 11 || pg > time && world.model != "maps/village.bsp") // angry face
			{
				if (pg > time)
					head.skin = 2; // smirk
				else
					head.skin = 1;
				head.angles_y = 180;
				head.angles_x = 15;
			}
			else // neutral face
			{
				if (pf > time) // pain face
				{
					if (!head.cnt)
					{
						// Randomize LEFT/RIGHT
						if (random() < 0.33)
							head.angles_y = 165;
						else if (random() < 0.66)
							head.angles_y = 195;
						else
							head.angles_y = 180;

						// Randomize UP/DOWN
						if (random() < 0.33)
							head.angles_x = -15;
						else if (random() < 0.66)
							head.angles_x = 0;
						else
							head.angles_x = 15;

						head.cnt = TRUE;
					}
					head.skin = 3;
				}
				else
				{
					// Add blinking, skin = 5;
					head.cnt = FALSE;
					if (head.blink)
					{
						head.skin = 5;
						if (head.blink_finished < time)
							head.blink = FALSE;
					}
					else
					{
						if (random() < 0.0025)
						{
							head.blink = TRUE;
							head.blink_finished = time + 0.225;
						}
						head.skin = 0;
					}
					head.angles_x = sin(cltime*0.65)*8;
					head.angles_y = 180 + sin(cltime*0.45)*25;
				}
			}
		}
	}
	else
	{
		head.skin = 0;
		head.origin = '0 0 -2';
		head.colormod = '.5 0 0';
		head.angles_y = 180;
		head.angles_x = 60;
	}
};

// Animate head shadow
void() AnimateHead_Shadow =
{
	head2.angles = head.angles;
	head2.origin = head.origin;
};

float Draw_Head_Once;
void(vector pos) Draw_Vigil_Head =
{
    if (!Draw_Head_Once) // Call this one time so we're not spawning infinite head entities
    {
        Draw_Head_Once = 1;
 
        head = spawn();
        precache_model("progs/hud_head.mdl");
        setmodel(head, "progs/hud_head.mdl");
        setorigin(head, '0 0 0');
		head.skin = 0;

        head2 = spawn();
        precache_model("progs/hud_head.mdl");
        setmodel(head2, "progs/hud_head.mdl");
        setorigin(head2, '0 0 0');
		head2.colormod = '-255 -255 -255';
		head2.scale = 1.075;
    }
	AnimateHead(); // entity head
	AnimateHead_Shadow(); // entity head2
	//entdraw(head2, pos + '0.3 0.3','37 37', -76); // Shadow
	entdraw(head2, pos,'36 36', -76);
	entdraw(head, pos,'36 36', -76);
};

//
// Draw Head Background
//

void(vector pos) DrawHeadBackground =
{
	drawpic (pos - '7 10', "progs/head_bg.png", '44 66 0', '1 1 1', 0.5, DRAWFLAG_NORMAL);
};

//
// Draw player status on HUD
//

void(vector pos) DrawPlayerStatus =
{
    local float blind = getstatf(STAT_STATUS_BLIND);
    local float poison = getstatf(STAT_STATUS_POISON);
    local float broken = getstatf(STAT_STATUS_BROKEN);
    local float pg = getstatf(STAT_PERFECTGUARD);
	
	local vector listpos = pos + '8 70';
    
	if (time < pg)
    {
        pg = ceil(pg-time);
        local string str = sprintf("^3Perfect Guard! %g",pg);
        
        drawstring (listpos + '1 1', str, '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
        drawstring (listpos, str, '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);
        listpos_y += 10;
    }
	
    if (time < poison)
    {
        poison = ceil(poison-time);
        local string str = sprintf("^x3F3Poisoned! %g",poison);
        
        drawstring (listpos + '1 1', str, '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
        drawstring (listpos, str, '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);
        listpos_y += 10;
    }
    
    if (time < blind)
    {
        blind = ceil(blind-time);
        local string str = sprintf("^xE7EBlind!    %g",blind);
        
        drawstring (listpos + '1 1', str, '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
        drawstring (listpos, str, '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);
        listpos_y += 10;
    }

    if (time < broken)
    {
        broken = ceil(broken-time);
        local string str = sprintf("^xF44Broken!   %g",broken);
        
        drawstring (listpos + '1 1', str, '8 8', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
        drawstring (listpos, str, '8 8', '1 1 1', 1, DRAWFLAG_NORMAL);
        listpos_y += 10;
    }
};

//
// Draw Vigil's Level on HUD
//

void(vector pos) Draw_Level_Number =
{
	//
	// Reposition vigils experience level according to number of digits
	//
	
	local float h = getstatf(STAT_LEVEL);
	local string z;
	z = ftos(h);

	// Draw drop shadow for readability
	string g = sprintf("^0%g", h);

	if (h > -1 && h < 10)
	{
		drawstring (pos + '4 1', g, '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL); // drop shadow
		drawstring (pos + '3 0', z, '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
	}
	if (h > 9 && h < 100)
	{
		drawstring (pos + '1 1', g, '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL); // drop shadow
		drawstring (pos, z, '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL);
	}
	drawstring (pos + '-14 1', "Lv.", '8 8 0', '0 0 0', 1, DRAWFLAG_NORMAL); // Lv. text Shadow
	drawstring (pos + '-15 0', "Lv.", '8 8 0', '1 1 1', 1, DRAWFLAG_NORMAL); // Lv. text
};

void(vector pos) DrawShrineHud =
{
	local float g = getstatf(STAT_CURRENTSHRINE);

	drawpic (pos-'-75 100', "gfx/shrine/shrinetxt.png", '275 73', '1 1 1', 1, DRAWFLAG_NORMAL);

	// Draw background
	local vector r = pos;
	r_x = r_x -18;
	r_y = r_y -18;
	drawpic (r, "gfx/shrine/shrinebg.png", '435 260', '0.25 0 0', 1, DRAWFLAG_NORMAL);
	if (g == 0) // Draw village
	{
		drawpic (pos, "gfx/shrine/shrine0.png", '400 225', '1 1 1', 1, DRAWFLAG_NORMAL);
		drawstring (pos+'142 -13', "Kharlia Village", '16 16 0', '0 0 0', 1, DRAWFLAG_NORMAL); // drop shadow
		drawstring (pos+'140 -15', "Kharlia Village", '16 16 0', '0.9 0.75 0', 1, DRAWFLAG_NORMAL);
	}
	if (g == 1) // Draw castle
	{
		drawpic (pos, "gfx/shrine/shrine1.png", '400 225', '1 1 1', 1, DRAWFLAG_NORMAL);
		drawstring (pos+'142 -13', "Kharlia Castle", '16 16 0', '0 0 0', 1, DRAWFLAG_NORMAL); // drop shadow
		drawstring (pos+'140 -15', "Kharlia Castle", '16 16 0', '0.9 0.75 0', 1, DRAWFLAG_NORMAL);
	}
	if (g == 2) // Draw cavern
	{
		drawpic (pos, "gfx/shrine/shrine2.png", '400 225', '1 1 1', 1, DRAWFLAG_NORMAL);
		drawstring (pos+'142 -13', "Cursed Cavern", '16 16 0', '0 0 0', 1, DRAWFLAG_NORMAL); // drop shadow
		drawstring (pos+'140 -15', "Cursed Cavern", '16 16 0', '0.9 0.75 0', 1, DRAWFLAG_NORMAL);
	}
	if (g == 4) // Draw cathedral
	{
		drawpic (pos, "gfx/shrine/shrine3.png", '400 225', '1 1 1', 1, DRAWFLAG_NORMAL);
		drawstring (pos+'142 -13', "Grand Cathedral", '16 16 0', '0 0 0', 1, DRAWFLAG_NORMAL); // drop shadow
		drawstring (pos+'140 -15', "Grand Cathedral", '16 16 0', '0.9 0.75 0', 1, DRAWFLAG_NORMAL);
	}

	pos_y = pos_y -(sin(cltime*1.5)*5); // cursor bounce
	drawpic (pos-'-352 16', "gfx/shrine/cursor_u.png", '50 50', '1 1 1', 1, DRAWFLAG_NORMAL);
	drawpic (pos-'-352 -192', "gfx/shrine/cursor_d.png", '50 50', '1 1 1', 1, DRAWFLAG_NORMAL);
};

float lightning_fullbright;
float lightning_fullbright_finished;

void() DrawLightning =
{
	local float f = cvar("r_shadow_realtime_dlight");
	if (random() < 0.0025 && !f && !lightning_fullbright) // full bright
	{
		lightstyle(0, "z");
		lightstyle(1, "z");
		lightstyle(2, "z");
		lightstyle(3, "z");
		lightstyle(4, "z");
		lightstyle(5,"z");
		lightstyle(6, "z");
		lightstyle(7, "z");
		lightstyle(8, "z");
		lightstyle(9, "z");
		lightstyle(10, "z");
		lightstyle(11, "z");
		lightstyle(63, "z");
		lightning_fullbright = TRUE;
		lightning_fullbright_finished = time + 0.2;
	}
	if (lightning_fullbright_finished < time && lightning_fullbright)
	{
		lightstyle(0, "m");
		lightstyle(1, "mmnmmommommnonmmonqnmmo");
		lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
		lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
		lightstyle(4, "mamamamamama");
		lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
		lightstyle(6, "nmonqnmomnmomomno");
		lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
		lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
		lightstyle(9, "aaaaaaaazzzzzzzz");
		lightstyle(10, "mmamammmmammamamaaamammma");
		lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
		lightstyle(63, "a");		
		lightning_fullbright = FALSE;
		lightning_fullbright_finished = time;
	}
};

//
//CSQC - INPUT EVENTS (Keyboard/Mouse Handling)
//

//float(string key, optional float assumevalue) serverkeyfloat = #0:serverkeyfloat; /*
//		Version of serverkey that returns the value as a float (which avoids tempstrings). */

float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent =
{
	if (isdemo() < 1)
	{
		if (world.model == "maps/start.bsp" && cltime < 1)
			return TRUE;

		//
		// Unpause game if attack or jump is pressed & clear centerprint
		//
		float pausestate = serverkeyfloat(SERVERKEY_PAUSESTATE);

		if (pausestate > 0)
		{
			switch (evtype)
			{
				case IE_KEYDOWN:
				if (getkeybind(scanx) == "+attack" || getkeybind(scanx) == "+jump" || getkeybind(scanx) == "pause" && pause_frame >= 75)
				{
					//
					// Stop pause and pass a blank centerprint to clear the screen
					//
					localcmd ("pause\n");
					cprint(""); // clear
				}
				if (getkeybind(scanx) == "screenshot")
					localcmd ("screenshot\n");
				
				return TRUE;
				case IE_KEYUP:
					return FALSE;
			}
		}
		return FALSE; // Engine can handle input when demo isn't playing		
	}
	else // demo playing
	{
		switch (evtype)
		{
			case IE_KEYDOWN:
			if (getkeybind(scanx) == "+attack" || getkeybind(scanx) == "+jump")
				localcmd("map start\n");
			return TRUE;
			case IE_KEYUP:
				return FALSE;
		}
	}
	return FALSE;
};

//
// CSQC SSQC -> CSQC Entity Handling
//

.float cnt;
void(float isnew) CSQC_Ent_Update =
{
	float enttype = readbyte();
	float flags;
	switch (enttype)
	{
	case 5:
		flags = readbyte();
		if (flags & 1) // origin
		{
			self.origin_x = readcoord();
			self.origin_y = readcoord();
			self.origin_z = readcoord();
			setorigin(self, self.origin);	//for correctness.
		}
		if (flags & 2) // frame
			self.frame = readbyte();
		if (flags & 4) // alpha
			self.alpha = readbyte() / 255;
		if (flags & 8) // effects
			self.effects = readbyte();
		if (flags & 16) // classname
			self.classname = readstring();
		if (flags & 32) // cnt
			self.cnt = readbyte();

		if (flags & 128)
		{
			setmodelindex(self, readbyte());
			self.drawmask = MASK_ENGINE;
		}
		break;
	default:
		error("Unknown entity type! Panic Error!");
	}
};

void() CSQC_Ent_Remove = {remove(self);};
void() SUB_Remove = {remove(self);return;};

//
// Main Loop
//

float loaded_settings;
.float mode;
float IT_RELIC7 = 64; // cube of knowledge
float blindness_fade;

void(float width, float height, float menushown) CSQC_UpdateView =
{
	clearscene();												//wipe entity lists. reset view properties to their defaults.
	Camera_Smooth();
	addentities((intermission?0:MASK_VIEWMODEL)|MASK_ENGINE);	//add various entities to the scene's lists.
	renderscene();												//draw the scene to the screen using the various properties.

	local vector twodcoord, twodcoord2;
	local string h;

	// Read game pause state
	float pausestate = serverkeyfloat(SERVERKEY_PAUSESTATE);
	if (pausestate > 0)
	{
		pause_frame = pause_frame + 1;
		//local vector pos = [(width - stringwidth("", TRUE, '321 28.5 0'))/3.5, (height - 50)];
		
		local vector pos = [(width)/3.25, (height - 50)];
		drawpic (pos + '1 1', "progs/gamepause.png", '321 28.5', '0 0 0', .1-(sin(cltime*3.5)*1), DRAWFLAG_NORMAL); // shadow
		drawpic (pos, "progs/gamepause.png", '321 28.5', '1 1 1', .1-(sin(cltime*3.5)*1), DRAWFLAG_NORMAL);
	}
	else
		pause_frame = 0;

	//
	// HACK - Fix menu opening after attract mode has finished playing
	//
	if (world.model == "maps/start.bsp" && cltime < 1)
		localcmd ("closemenu\n");

	// Draw DEMO signs on demo playback
	if (isdemo() > 0 || world.model == "maps/intro.bsp")
	{
		if (cltime < 1)
		{
			localcmd ("exec gfx.cfg\n"); // Fix wrong graphics on water shader on demo playback
			localcmd ("exec haze.cfg\n"); // Fix wrong graphics on particles on demo playback
			localcmd ("stopmusic\n"); // Stop music playback on demo
		}

		if (world.model != "maps/intro.bsp")
			local vector pos = [(width - stringwidth("", TRUE, '321 28.5 0'))/3.5, (height - 18)/1.15];
		else
			local vector pos = [(width - stringwidth("", TRUE, '321 28.5 0'))/3.5, (height - 18)/20];
		
		drawpic (pos + '1 1', "progs/demosign.png", '321 28.5', '0 0 0', .6-(sin(cltime*3.5)*1), DRAWFLAG_NORMAL); // shadow
		drawpic (pos, "progs/demosign.png", '321 28.5', '1 1 1', .6-(sin(cltime*3.5)*1), DRAWFLAG_NORMAL);

		local vector pos2 = [(width - stringwidth("", TRUE, '170 81 0'))/30, (height - 18)/30];
		drawpic (pos2 + '1 1', "progs/demosign2.png", '170 81', '0 0 0', 1, DRAWFLAG_NORMAL); // shadow
		drawpic (pos2, "progs/demosign2.png", '170 81', '1 1 1', 1, DRAWFLAG_NORMAL);
	}
	else
	{
		if (cltime > 1 && loaded_settings == FALSE)
		{
			// Execute command scripts
			if (world.model == "maps/start.bsp")
				localcmd("sensitivity 0;crosshair 0;exec settings.cfg;exec gfx.cfg;exec haze.cfg\n");
			else
				localcmd("sensitivity 0;crosshair 0;exec gfx.cfg;exec haze.cfg\n");
			
			if (cvar("developer") == 2)
				localcmd("viewsize 110\n");

			loaded_settings = TRUE;
		}
	}
	// Draw 2D elements
	if (world.model != "maps/start.bsp" && world.model != "maps/intro.bsp" && world.model != "maps/menu.bsp" && isdemo() == 0)
	{
		//
		// Draw Entity Number Pickups on Screen (Health / Gold / Mana) - START -
		//
		
		// This should all be done first because project(); function which is used for drawing 2D Coords in 3D space
		// get really weird when you start drawing 3D HUD elements

		local entity z = find(world, classname, "DrawGoldEntity");
		while (z)
		{
			if (z != world)
			{
				h = ftos(z.cnt);
				twodcoord = project(z.origin);
				twodcoord -= [8, 8]/2;
				if (z.alpha > 0)
				{
					z.alpha = z.alpha - 0.005;
					drawstring(twodcoord + '1 1', strcat("+", h, "\n"), '10 10 0', '0 0 0', z.alpha, DRAWFLAG_NORMAL); // shadow
					drawstring(twodcoord - '1 1', strcat("+", h, "\n"), '10 10 0', '0 0 0', z.alpha, DRAWFLAG_NORMAL); // shadow
					drawstring(twodcoord, strcat("+", h, "\n"), '10 10 0', '1 .8 0', z.alpha, DRAWFLAG_NORMAL);
				}
			}
			z = find(z, classname, "DrawGoldEntity");
		}
		
		local entity a = find(world, classname, "DrawHealthEntity");
		while (a)
		{
			if (a != world)
			{	
				h = ftos(a.cnt);
				twodcoord2 = project(a.origin);
				twodcoord2 -= [8, 8]/2;

				if (a.alpha > 0)
				{
					a.alpha = a.alpha - 0.005;
					if (a.cnt > 0)
					{
						drawstring(twodcoord2 + '1 1', strcat("+", h, "\n"), '10 10 0', '0 0 0', a.alpha, DRAWFLAG_NORMAL); // shadow
						drawstring(twodcoord2 - '1 1', strcat("+", h, "\n"), '10 10 0', '0 0 0', a.alpha, DRAWFLAG_NORMAL); // shadow
						drawstring(twodcoord2, strcat("+", h, "\n"), '12 12 0', '1 0 0', a.alpha, DRAWFLAG_NORMAL);
					}
					else
					{
						drawstring(twodcoord2 + '1 1', "Empty\n", '10 10 0', '0 0 0', a.alpha, DRAWFLAG_NORMAL); // shadow
						drawstring(twodcoord2 - '1 1', "Empty\n", '10 10 0', '0 0 0', a.alpha, DRAWFLAG_NORMAL); // shadow
						drawstring(twodcoord2, "Empty\n", '10 10 0', '1 0 0', a.alpha, DRAWFLAG_NORMAL);
					}
				}
			}
			a = find(a, classname, "DrawHealthEntity");
		}
		
		local entity b = find(world, classname, "DrawManaEntity");
		while (b)
		{
			if (b != world)
			{	
				h = ftos(b.cnt);
				twodcoord2 = project(b.origin);
				twodcoord2 -= [8, 8]/2;

				if (b.alpha > 0)
				{
					b.alpha = b.alpha - 0.005;
					drawstring(twodcoord2 + '1 1', strcat("+", h, "\n"), '10 10 0', '0 0 0', b.alpha, DRAWFLAG_NORMAL); // shadow
					drawstring(twodcoord2 - '1 1', strcat("+", h, "\n"), '10 10 0', '0 0 0', b.alpha, DRAWFLAG_NORMAL); // shadow
					drawstring(twodcoord2, strcat("+", h, "\n"), '10 10 0', '0 0 1', b.alpha, DRAWFLAG_NORMAL);
				}
			}
			b = find(b, classname, "DrawManaEntity");
		}

		//
		// Draw Entity Numbers on Screen (Health / Gold / Mana) - END -
		//

		local float blind = getstatf(STAT_STATUS_BLIND);
		local float swim = getstatf(STAT_CAM_INWATER);

		if (blind > time || swim)    
			blindness_fade = min(1,blindness_fade + frametime*7.5);
		else if (blindness_fade > 0 || swim)
			blindness_fade = max(0,blindness_fade - frametime*3);

		if (blindness_fade > 0 || swim)
		{
			local vector draw = [getstatf(STAT_ORIGINX), getstatf(STAT_ORIGINY), getstatf(STAT_ORIGINZ)];
			if (swim)
				DrawBlindness(draw, '640 540' + ('640 640'*(1-blindness_fade)), width, height, blindness_fade);
			else
				DrawBlindness(draw, '320 270' + ('640 640'*(1-blindness_fade)), width, height, blindness_fade);
		}
	
		// Draw the shrine selection HUD when in use
		local float shrine_hud = getstatf(STAT_SHRINEHUD);	// Draw Shrine HUD on screen
		if (world.model == "maps/teleporter.bsp" && shrine_hud == TRUE)
			DrawShrineHud('225 225');
		
		if (cvar("developer") == 2) // Disable HUD in Developer 2 mode
			return;

		DrawHeadBackground('20 10');				// Draw Head background border
		DrawGoldHUD('145 -60');						// Draws 3D Gold model
		Draw_Vigil_Head('18 16');					// Draws Vigil's 3D Head
		Draw_Health_Potion('51 2.5');				// Draws Health Potion bottle
		DrawFlaskStatus('51 5');
		if (cltime < 3.3)
			DrawLevelName(width, height);	// Draws level name at the beginning of a level
		DrawXPBar('54 26');
		DrawMPBar('18 48');
		DrawHPBar('46 32');
		DrawGoldStatus('130 8');					// Draws gold on HUD
		DrawSwordStatus('128 10');					// Draws sword level on HUD
		DrawArmorStatus('102 10');					// Draws armor level on HUD
		DrawCurrentSelectedSpell('132 38');			// Draws the selected spell on HUD
		DrawPlayerStatus('0 0');					// Draw "Status: " Text
		Draw_Level_Number('38 10');					// Draw Vigil's Level
		if (world.model == "maps/castle.bsp")
			DrawLightning();							// Fake lightning strikes

		local float keys = getstatf(STAT_KEYS);	// Draw Keys on screen
		if (keys == 1) // 1 = Gold, 2 = Silver
			DrawKey1('8 425');
		
		if (cvar("scratch2") == 0)
			DrawComboDamageCounter(width, height);			// Draws the "Strikes!" sign
		
		local float pg = getstatf(STAT_PERFECTGUARD);
		if (pg > time)
			DrawPerfectGuard(width, height);			// Draws the Perfect Guard sign

		local float absorb = getstatf(STAT_ABSORB);
		if (absorb > time)
			DrawAbsorption(width, height);				// Draws the Absorbtion sign

		local float relics = getstatf(STAT_RELIC);
		if (relics & IT_RELIC7) 
			DrawMonsterStats('0 0');				// Draws monster display name

		local float price = getstatf(STAT_PRICE);
		if (price > 0)
			DrawPriceDisplay(width, height);			// Draw prices on screen when buying

		local float pou = getstatf(STAT_POUCH);
		if (pou > 0)
			DrawPouchIcon(width, height);				// Draw Pouch Icon on screen
	}
};

//
// First loaded, run once
//
.float foo;
void() CSQC_WorldLoaded  =
{
	// Ask SSQC for values to send, fixes 0 display on HUD elements
	sendevent("GrabCSQCValues", "");
	cvar_set("skyroom", "");
	cvar_set("sv_gamespeed", "1"); // Fixes loaded save files from in-progress slowdown events
};