

void Savegame_back(float key, float ascii, menuElement *element)
{
	if (key != K_MOUSE1)
		return;
	
	over_element = blank_element;
	current_menu = MENU_Main;
}

void Savegame_exit(float key, float ascii, menuElement *element)
{
	if (key != K_MOUSE1)
		return;
	
	over_element = blank_element;
	current_menu = MENU_Main;
	
	menuIsOn = 0;
	setkeydest(KEY_GAME);
	setcursormode(FALSE,"");
}

void Savegame_l_draw()
{
	
}

const string save_slots[] =
{
	"s0",
	"s1",
	"s2",
	"s3",
	"s4",
	"s5",
	"s6",
};

/////
float(float f) fixbyte =
{
	f = rint(f);
	if (f > 255)
		f = 255;
	else if (f < 0)
		f = 0;
	return f & 255;
};

// no bit 24!! FIXME! For now use low values for 1st parm :)
float(float s1, float s2, float s3) encode =
{
	return fixbyte(s1) * 65536 + fixbyte(s2) * 256 + fixbyte(s3);
};

float(float parm, float which) decode =
{
	if (which == 1)
		return (parm / 65536) & 255;
	else if (which == 2)
		return (parm / 256) & 255;
	else
		return parm & 255;
};
/////

void Savegame_Load_Loadfromslot(float key, float ascii, menuElement *element)
{
	if (key != K_MOUSE1)
		return;
	
	localcmd(sprintf("loadgame %s\n", over_element.name));
	
	over_element = blank_element;
	current_menu = MENU_Main;
	
	menuIsOn = 0;
	setkeydest(KEY_GAME);
	setcursormode(FALSE,"");
}

void Savegame_Load_Blankslot(float key, float ascii, menuElement *element)
{
	
}

void Savegame_Load_ScanSaves()
{
	local menuElement *saveslot_last = blank_element;
	MENU_Load.default_element = elementByName(MENU_Load, "back");
	
	local float i;
	for(i=0; i<7; i++)
	{
		local menuElement *saveslot = elementByName(MENU_Load, save_slots[i]);
		local float fs = fopen(sprintf("%s.sav", save_slots[i]), FILE_READ);
		
		if (fs > -1)
		{
			//fgets(fs); // number at the top, version I think?
			//saveslot.text = strreplace("_", " ", fgets(fs));
			fgets(fs);
			fgets(fs);
			fgets(fs);
			fgets(fs);
			fgets(fs);
			local float level = stof(fgets(fs));
			level = decode(level, 2);

			saveslot.text = sprintf("SLOT #%d: Level %d", i, level);
			fclose(fs);
			
			saveslot.color = '1 0.2 0.05';
			saveslot.coloralt = '1.7 0.4 0.2';
			saveslot.keydown = Savegame_Load_Loadfromslot;
			
			if (saveslot_last != blank_element)
			{
				saveslot.north = saveslot_last;
				saveslot_last.south = saveslot;
			}
			else
			{
				MENU_Load.default_element = saveslot;
			}
			
			saveslot_last = saveslot;
			
			local menuElement *back = elementByName(MENU_Load, "back");
			saveslot.south = back;
			back.north = saveslot;
		}
		else
		{
			saveslot.text = "-EMPTY SLOT-";
			saveslot.color = '0.4 0.4 0.4';
			saveslot.coloralt = saveslot.color;
			saveslot.keydown = __NULL__;
		}
	}
}

void Savegame_LoadExit_ScanSaves()
{
	local menuElement *saveslot_last = blank_element;
	
	local float i;
	for(i=0; i<7; i++)
	{
		local menuElement *saveslot = elementByName(MENU_LoadExit, save_slots[i]);
		local float fs = fopen(sprintf("%s.sav", save_slots[i]), FILE_READ);
		
		if (fs > -1)
		{
			//fgets(fs); // number at the top, version I think?
			//saveslot.text = strreplace("_", " ", fgets(fs));
			fgets(fs);
			fgets(fs);
			fgets(fs);
			fgets(fs);
			fgets(fs);
			local float level = stof(fgets(fs));
			level = decode(level, 2);
			
			saveslot.text = sprintf("SLOT #%d: Level %d", i, level);
			fclose(fs);
			
			saveslot.color = '1 0.2 0.05';
			saveslot.coloralt = '1.7 0.4 0.2';
			saveslot.keydown = Savegame_Load_Loadfromslot;
			
			if (saveslot_last != blank_element)
			{
				saveslot.north = saveslot_last;
				saveslot_last.south = saveslot;
			}
			else
			{
				MENU_LoadExit.default_element = saveslot;
			}
			
			saveslot_last = saveslot;
			
			local menuElement *back = elementByName(MENU_LoadExit, "back");
			saveslot.south = back;
			back.north = saveslot;
		}
		else
		{
			saveslot.text = "-EMPTY SLOT-";
			saveslot.color = '0.4 0.4 0.4';
			saveslot.coloralt = saveslot.color;
			saveslot.keydown = __NULL__;
		}
	}
}

void Load_Create()
{
	MENU_Load = createMenu();
	
	MENU_Load.draw = Savegame_l_draw;
	
	// back button //
	local menuElement *back = addButton(MENU_Load,'-64 -56', "back");
	back.justify = '0.5 1';
	back.text = "Back"; back.textjustify = '0.5 0.5';
	back.keydown = Savegame_back;
	
	local float yoff = -108;
	
	local float i;
	for(i=0; i<7; i++)
	{
		local menuElement *saveslot = addButton_custom(MENU_Load, [-64, yoff], save_slots[i]);
		saveslot.justify = '0.5 0.5'; saveslot.textjustify = '0.5 0.5';
		saveslot.text = "-EMPTY SLOT-"; saveslot.textpos = '64 18';
		saveslot.size = '128 32';
		
		yoff += 32;
	}
	
	Savegame_Load_ScanSaves();
}

void LoadExit_Create()
{
	MENU_LoadExit = createMenu();
	
	MENU_LoadExit.draw = Savegame_l_draw;
	
	// back button //
	local menuElement *back = addButton(MENU_LoadExit,'-64 -56', "back");
	back.justify = '0.5 1';
	back.text = "Back"; back.textjustify = '0.5 0.5';
	back.keydown = Savegame_exit;
	
	local float yoff = -108;
	
	local float i;
	for(i=0; i<7; i++)
	{
		local menuElement *saveslot = addButton_custom(MENU_LoadExit, [-64, yoff], save_slots[i]);
		saveslot.justify = '0.5 0.5'; saveslot.textjustify = '0.5 0.5';
		saveslot.text = "-EMPTY SLOT-"; saveslot.textpos = '64 18';
		saveslot.size = '128 32';
		
		yoff += 32;
	}
	
	Savegame_LoadExit_ScanSaves();
}

void Savegame_Save_ScanSaves()
{
	local menuElement *saveslot_last = blank_element;
	
	local float i;
	for(i=0; i<7; i++)
	{
		local menuElement *saveslot = elementByName(MENU_Save, save_slots[i]);
		local float fs = fopen(sprintf("%s.sav", save_slots[i]), FILE_READ);
		
		if (fs > -1)
		{
			//fgets(fs); // number at the top, version I think?
			//saveslot.text = strreplace("_", " ", fgets(fs));
			fgets(fs);
			fgets(fs);
			fgets(fs);
			fgets(fs);
			fgets(fs);
			local float level = stof(fgets(fs));
			level = decode(level, 2);
			
			saveslot.text = sprintf("SLOT #%d: Level %d", i, level);
			fclose(fs);
			
			saveslot.color = '0.4 0.4 0.6';
			saveslot.coloralt = '0.5 0.6 1';
		}
		else
		{
			saveslot.text = "-EMPTY SLOT-";
			
			saveslot.color = '1 0.2 0.05';
			saveslot.coloralt = '1.7 0.4 0.2';
		}
		
		
		if (saveslot_last != blank_element)
		{
			saveslot.north = saveslot_last;
			saveslot_last.south = saveslot;
		}
		else
		{
			MENU_Save.default_element = saveslot;
		}
		
		saveslot_last = saveslot;
		
		local menuElement *back = elementByName(MENU_Save, "back");
		saveslot.south = back;
		back.north = saveslot;
	}
}

void Savegame_Save_Saveinslot(float key, float ascii, menuElement *element)
{
	if (key != K_MOUSE1)
		return;
	
	localcmd(sprintf("savegame %s\n", over_element.name));
	
	over_element = blank_element;
	current_menu = MENU_Main;
	
	menuIsOn = 0;
	setkeydest(KEY_GAME);
	setcursormode(FALSE,"");
}

void Save_Create()
{
	MENU_Save = createMenu();
	
	MENU_Save.draw = Savegame_l_draw;
	
	// exit button //
	local menuElement *back = addButton(MENU_Save,'-64 -56', "back");
	back.justify = '0.5 1';
	back.text = "Exit"; back.textjustify = '0.5 0.5';
	back.keydown = Savegame_exit;
	
	local float yoff = -108;
	
	local float i;
	for(i=0; i<7; i++)
	{
		local menuElement *saveslot = addButton_custom(MENU_Save, [-64, yoff], save_slots[i]);
		saveslot.justify = '0.5 0.5'; saveslot.textjustify = '0.5 0.5';
		saveslot.text = "-EMPTY SLOT-"; saveslot.textpos = '64 18';
		saveslot.size = '128 32';
		saveslot.keydown = Savegame_Save_Saveinslot;
		
		yoff += 32;
	}
	
	Savegame_Save_ScanSaves();
}

void Savegame_Create()
{
	Save_Create();
	Load_Create();
	LoadExit_Create();
}
