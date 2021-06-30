void m_init()
{
	blank_menu = memalloc(sizeof(menuElement));
	blank_menu.next = blank_menu;
	list_menu = blank_menu;
	
	blank_element = memalloc(sizeof(menuElement));
	blank_element.array = memalloc(sizeof(menuList));
	blank_element.type = ME_TYPE_NULL;
	
	selected_element = blank_element;
	over_element = blank_element;
	
	/* MAIN MENU */
	MENU_Main = createMenu();
	
	local menuElement *quit = addButton(MENU_Main,'-64 64', "quit");
	local menuElement *settings = addButton(MENU_Main,'-64 32', "settings");
	local menuElement *multiplayer = addButton(MENU_Main,'-64 0', "multiplayer");
	local menuElement *load = addButton(MENU_Main,'-64 -32', "load");
	local menuElement *restart = addButton(MENU_Main,'-64 -64', "restart");
	
	// quit button //
	quit.justify = '0.5 0.5';
	quit.text = "Exit to Desktop";
	quit.north = settings;
	quit.keydown = MainMenu_quit;
	
	// settings //
	settings.justify = '0.5 0.5';
	settings.text = "Settings";
	settings.north = multiplayer;
	settings.south = quit;
	settings.keydown = MainMenu_settings;
	
	// multiplayer //
	multiplayer.justify = '0.5 0.5';
	multiplayer.text = "Multiplayer";
	multiplayer.north = load;
	multiplayer.south = settings;
	multiplayer.keydown = MainMenu_multiplayer;
	
	// load //
	load.justify = '0.5 0.5';
	load.text = "Load Game";
	load.north = restart;
	load.south = multiplayer;
	load.keydown = MainMenu_load;
	MENU_Main.default_element = load;
	
	// restart //
	restart.justify = '0.5 0.5';
	restart.text = "Restart Game";
	restart.south = load;
	restart.keydown = MainMenu_restart;
	/* MENU END */
	
	Settings_Create();
	Savegame_Create();

	current_menu = MENU_Main;
	
	FONT_MENU = loadfont("", "fonts/console", "32", -1, 0, 0);
	
	registercommand("menu_save");
	registercommand("menu_load");
}

float m_consolecommand(string cmd)
{
	tokenize(cmd);
	
	cmd = argv(0);
	
	if (cmd == "menu_save")
	{
		m_toggle(TRUE);
		
		selected_element = blank_element;
		
		current_menu = MENU_Save;
		over_element = MENU_Save.default_element;
		Savegame_Save_ScanSaves();
		
		mousetimeout = time + 0.1;
		
		return TRUE;
	}
	else if (cmd == "menu_load")
	{
		m_toggle(TRUE);
		
		selected_element = blank_element;
		
		current_menu = MENU_LoadExit;
		over_element = MENU_LoadExit.default_element;
		Savegame_Load_ScanSaves();
		
		mousetimeout = time + 0.1;
		
		return TRUE;
	}
	
	return FALSE;
}

void m_shutdown()
{
	cleanupMenu(MENU_Main);
	cleanupMenu(MENU_Sett_Video);
	cleanupMenu(MENU_Save);
	cleanupMenu(MENU_Load);
}

void drawTextBox(menuElement *box)
{
	local vector scale = box.textsize;
	local vector just = box.justify;
	local vector tjust = box.textjustify;
	local vector textpos = box.textpos - [stringwidth(box.text,FALSE,scale_x)*tjust_x, 0];
	
	local vector position = box.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = box.size;
	
	if (mousepos_x > position_x && mousepos_x < position_x+size_x && mousepos_y > position_y && mousepos_y < position_y+size_y && mInputMode == M_INPUT_MOUSE) {
		over_element = box;
	}
	
	drawfill(position, size, '0 0 0', 0.8);
	
	local vector clr = box.color;
	if (selected_element == box)
		clr = box.coloralt;
	
	drawfill(position, [2, size_y], clr, 1);
	drawfill(position + [size_x - 2, 0], [2, size_y], clr, 1);
	
	drawfill(position, [size_x, 2], clr, 1);
	drawfill(position + [0, size_y - 2], [size_x, 2], clr, 1);
	
	drawstring(position + [textpos_x, textpos_y-(scale_y*0.5)], box.text, scale, '1 1 1', 1, 0);
}

void drawText(menuElement *box)
{
	local vector scale = box.textsize;
	local vector just = box.justify;
	local vector tjust = box.textjustify;
	local vector textpos = box.textpos - [stringwidth(box.text,FALSE,scale_x)*tjust_x, 0];
	
	local vector position = box.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = box.size;
	
	if (mInputMode == M_INPUT_MOUSE)
	{
		if (size_x && size_y) {
			if (mousepos_x > position_x && mousepos_x < position_x+size_x && mousepos_y > position_y && mousepos_y < position_y+size_y) {
				over_element = box;
			}
		}
	}
	
	
	local vector clr = box.color;
	if (selected_element == box)
		clr = box.coloralt;
	
	drawstring(position + [textpos_x, textpos_y-(scale_y*0.5)], box.text, scale, clr, 1, 0);
}

void drawSlider(menuElement *slider)
{
	local vector scale = slider.textsize;
	local vector just = slider.justify;
	local vector textpos = slider.textpos;
	
	local vector position = slider.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = slider.size;
	
	if (mInputMode == M_INPUT_MOUSE)
	{
		if (mousepos_x > position_x && mousepos_x < position_x+size_x && mousepos_y > position_y && mousepos_y < position_y+size_y) {
			over_element = slider;
		}
	}
	
	//drawfill(position, size, '0 0 0', 0.8);
	
	local vector clr = '0.8 0.8 0.8';
	local vector nubclr = slider.coloralt;
	
	if (over_element == slider && mInputMode > M_INPUT_MOUSE)
	{
		clr = '1 1 1';
		nubclr = '1 0.6 0';
	}
	
	if (selected_element == slider)
		clr = '1 0.6 0';
	
	
	
	drawpic(position + '2 2', "gfx/menu/gradient", [size_x - 4, size_y - 4], slider.color, 1);
	
	drawfill(position, [2, size_y], clr, 1);
	drawfill(position + [size_x - 2, 0], [2, size_y], clr, 1);
	
	drawfill(position, [size_x, 2], clr, 1);
	drawfill(position + [0, size_y - 2], [size_x, 2], clr, 1);
	
	
	local float sldval = bound(0,slider.fvalue,1);
	drawfill(position + [-4, -2] + [sldval*size_x, 0], [8, size_y + 4], nubclr * 0.75, 1);
	drawfill(position + [-2, 0] + [sldval*size_x, 0], [4, size_y], nubclr, 1);
	
	//drawpic(position, "gfx/menu/slider", size, vector rgb, float alpha, optional float flag);
	
	drawstring(position + [textpos_x, textpos_y-(scale_y*0.5)], slider.text, scale, '1 1 1', 1, 0);
}

void drawList(menuElement *list)
{
	local vector scale = '18 18';
	local vector just = list.justify;
	
	local vector position = list.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector size = '450 320';
	position -= size*0.5;
	
	if (mInputMode == M_INPUT_MOUSE)
	{
		if (mousepos_x > position_x && mousepos_x < position_x+size_x && mousepos_y > position_y && mousepos_y < position_y+size_y) {
			over_element = list;
		}
	}
	
	drawfill(position, size, '0 0 0', 0.8);
	
	drawfill(position, [2, size_y], '1 1 1', 1);
	drawfill(position + [size_x - 2, 0], [2, size_y], '1 1 1', 1);
	
	drawfill(position, [size_x, 2], '1 1 1', 1);
	drawfill(position + [0, size_y - 2], [size_x, 2], '1 1 1', 1);
	
	local vector entpos = position + '0 2';
	local menuList *array = list.array;
	
	local float i = 0;
	while (i < 20) {
		local menuList_Entry *entry = &array.entries[i];
		
		if (i % 2)
			drawfill(entpos, [size_x, 15.8], '1 1 1', 0.05);
		
		if (array.selected == i && list == selected_element)
			drawfill(entpos, [size_x, 15.8], '1 0.2 0', 0.15);
		
		if (mousepos_x > entpos_x && mousepos_x < entpos_x+size_x && mousepos_y > entpos_y && mousepos_y < entpos_y+15.8) {
			drawfill(entpos, [size_x, 15.8], '1 1 1', 0.035);
		}
		
		drawstring(entpos + '4 1', entry.text[0], '8 8', entry.color[0], 1, 0);
		drawstring(entpos + '4 9', entry.text[1], '8 8', entry.color[1], 1, 0);
		
		drawstring(entpos + [size_x-(stringwidth(entry.text[2],FALSE,8)+4) ,1], entry.text[2], '8 8', entry.color[2], 1, 0);
		drawstring(entpos + [size_x-(stringwidth(entry.text[3],FALSE,8)+4) ,9], entry.text[3], '8 8', entry.color[3], 1, 0);
		
		entpos += '0 15.8';
		i++;
	}
}

void drawButton(menuElement *button)
{
	local vector size = button.size;
	local vector scale = button.textsize;
	local vector just = button.justify;
	local vector tjust = button.textjustify;
	local vector position = button.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector textpos = button.textpos - ([stringwidth(button.text,FALSE,scale_x)*tjust_x, 0]);
	
	if (mInputMode == M_INPUT_MOUSE)
	{
		if (mousepos_x > position_x && mousepos_x < position_x+size_x && mousepos_y > position_y && mousepos_y < position_y+size_y) {
			over_element = button;
		}
	}
	
	local vector clr =  button.color;
	
	if (over_element == button) {
		if (button.coloralt) {
			clr = button.coloralt;
		}
		
		if (button.imgalt) {
			local float pulse = 1 + sin(time*1.45)*0.3;
			drawpic(position, button.imgalt, button.size, clr*pulse, 1);
			drawstring(position + [textpos_x, textpos_y-(scale_y*tjust_y)], button.text, scale, '0.95 0.4 0.05', 1, 0);
			return;
		}
	}
	
	drawpic(position, button.img, button.size, clr, 1);
	drawstring(position + [textpos_x, textpos_y-(scale_y*tjust_y)], button.text, scale, 1, 1, 0);
	
}

void drawCheckbox(menuElement *button)
{
	local vector size = button.size;
	local vector scale = button.textsize;
	local vector just = button.justify;
	local vector tjust = button.textjustify;
	local vector position = button.pos + (([screensize_x*just_x,screensize_y*just_y]));
	local vector textpos = button.textpos - ([stringwidth(button.text,FALSE,scale_x)*tjust_x, 0]);
	
	local vector clr =  button.color;
	if (mInputMode == M_INPUT_MOUSE)
	{
		if (mousepos_x > position_x && mousepos_x < position_x+size_x && mousepos_y > position_y && mousepos_y < position_y+size_y) {
			over_element = button;
		}
	}
	
	if (over_element == button)
	{
		if (button.coloralt) {
			clr = button.coloralt;
		}
	}
	
	if (button.fvalue) {
		if (button.coloralt) {
			clr = button.coloralt;
		}
		
		if (button.imgalt) {
			drawpic(position, button.imgalt, button.size, clr, 1);
			drawstring(position + [textpos_x, textpos_y-(scale_y*tjust_y)], button.text, scale, '0.85 0.6 0.05', 1, 0);
			
			if (over_element != button)
				drawpic(position, strcat(button.imgalt,"_hollow"), button.size, 1, 1);
			
			return;
		}
	}
	
	drawpic(position, button.img, button.size, clr, 1);
	drawstring(position + [textpos_x, textpos_y-(scale_y*tjust_y)], button.text, scale, 1, 1, 0);
}

void drawElement(menuElement *element)
{
	if !(element.hide) {
	switch (element.type) {
		case ME_TYPE_BUTTON: drawButton(element); break;
		case ME_TYPE_LIST: drawList(element); break;
		case ME_TYPE_TEXTBOX: drawTextBox(element); break;
		case ME_TYPE_SLIDER: drawSlider(element); break;
		case ME_TYPE_CHECKBOX: drawCheckbox(element); break;
		case ME_TYPE_TEXT: drawText(element); break;
	}
	}
}

void drawMenu(menuScreen *menu)
{
	local menuElement *lst = menu.list;
	
	//drawElement(lst);
	while (lst != blank_element) {
		drawElement(lst);
		
		lst = lst.next;
	}
}

// FETCH INPUTS FROM OS
float Menu_InputEvent(float evtype, float scanx, float chary, float devid)
{
	menuElement *oldsel_element = selected_element;
	
	if (evtype == IE_KEYDOWN) {
		
		// change input mode if keys are pressed
		if (scanx >= K_UPARROW && scanx <= K_RIGHTARROW)
		{
			mInputMode = M_INPUT_KEYBOARD;
			
			if (over_element == blank_element && current_menu.default_element)
			{
				over_element = current_menu.default_element;
				return FALSE;
			}
		}
		else if (scanx >= K_GP_A && scanx <= K_GP_RTHUMB_RIGHT)
		{
			mInputMode = M_INPUT_XINPUT;
			
			if (over_element == blank_element && current_menu.default_element)
			{
				over_element = current_menu.default_element;
				return FALSE;
			}
		}
		//
		
		// key input aliasing for different input types
		if (mInputMode == M_INPUT_KEYBOARD)
		{
			if (scanx == K_ENTER)
				scanx = K_MOUSE1;
		}
		else if (mInputMode == M_INPUT_XINPUT)
		{
			if (scanx == K_GP_X || scanx == K_GP_START)
				scanx = K_MOUSE1;
			
			if (scanx == K_GP_B)
				scanx = K_ESCAPE;
			
			if (scanx == K_GP_DPAD_UP || scanx == K_GP_LTHUMB_DOWN)
				scanx = K_UPARROW;
			else if (scanx == K_GP_DPAD_DOWN || scanx == K_GP_LTHUMB_UP)
				scanx = K_DOWNARROW;
			else if (scanx == K_GP_DPAD_LEFT || scanx == K_GP_LTHUMB_LEFT)
				scanx = K_LEFTARROW;
			else if (scanx == K_GP_DPAD_RIGHT || scanx == K_GP_LTHUMB_RIGHT)
				scanx = K_RIGHTARROW;
		}
		//
		
		switch (scanx) {
			case K_ESCAPE: {
				localsound("misc/menu3", 4, 1);
				menuIsOn = 0;
				setkeydest(KEY_GAME);
				setcursormode(FALSE,"");
			} break;
			
			case K_UPARROW:
				if (over_element.north != over_element && over_element.north) {
					over_element = over_element.north;
					selected_element = blank_element;
					localsound("misc/menu1", 4, 1);
				
				} break;
				
			case K_RIGHTARROW:
				if (selected_element.type == ME_TYPE_SLIDER)
				{
					selected_element.keydown(scanx, chary, selected_element);
					return FALSE;
				}
				
				if (over_element.east != over_element && over_element.east) {
					over_element = over_element.east;
					localsound("misc/menu1", 4, 1);
				
				} break;
				
			case K_DOWNARROW:
				if (over_element.south != over_element && over_element.south) {
					over_element = over_element.south;
					selected_element = blank_element;
					localsound("sound/misc/menu1", 4, 1);
				
				} break;
				
			case K_LEFTARROW:
				if (selected_element.type == ME_TYPE_SLIDER)
				{
					selected_element.keydown(scanx, chary, selected_element);
					return FALSE;
				}
				
				if (over_element.west != over_element && over_element.west) {
					over_element = over_element.west;
					localsound("sound/misc/menu1", 4, 1);
				
				
				} break;
			
			
			case K_MOUSE1: {
				
			} break;
		}
		
		if (current_menu.keydown) {
			current_menu.keydown(scanx, chary);
		}
		
		if (over_element.keydown) {
			over_element.keydown(scanx, chary, over_element);
		}
		
		if (selected_element.selectedkeydown && selected_element == oldsel_element) {
			selected_element.selectedkeydown(scanx, chary, selected_element);
		}
	} else if (evtype == IE_KEYUP) {	
		if (M_INPUT_KEYBOARD)
		{
			if (scanx == K_ENTER)
			{
				scanx = K_MOUSE1;
				localsound("misc/menu2", 4, 1);
			}
		}
	
		if (over_element.keyup) {
			over_element.keyup(scanx, chary, over_element);
		}
		
		if (selected_element.selectedkeyup && selected_element == oldsel_element) {
			selected_element.selectedkeyup(scanx, chary, selected_element);
		}
	} else if (evtype == IE_MOUSEABS) {
		mousepos_x = scanx;
		mousepos_y = chary;
		
		if (time > mousetimeout)
			mInputMode = M_INPUT_MOUSE;
	}
	
	return FALSE;
}

void m_toggle (float flWantmode)
{
	if (time < 2)
		return;

	menuIsOn = flWantmode;
	
	setcursormode(TRUE,"cursor");
	setkeydest(KEY_MENU);

	localsound("misc/menu2", 4, 1);
	MainMenu_goto();
}

void m_draw(vector scrsz)
{
	frametime = time - lastframe;
	lastframe = time;
	screensize = scrsz;
	
	if (mInputMode == M_INPUT_MOUSE)
		over_element = blank_element;
	
	if (menuIsOn)
	{
		if (current_menu == MENU_Main)
		{
			drawpic ('336 76', "progs/demosign2.png", '170 81', '0 0 0', 1, 0); // shadow
			drawpic ('335 75', "progs/demosign2.png", '170 81', '2 2 2', 1, 0);
		}
		
		drawfont = FONT_MENU;
		
		drawfill('0 0', scrsz, '0 0 0', 0.65);
		drawMenu(current_menu);
		
		if (current_menu.draw)
			current_menu.draw();

		drawfont = FONT_DEFAULT;
		
		clearscene();
		renderscene();
	}
}