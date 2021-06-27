void() MainMenu_goto
{
	current_menu = MENU_Main;
	over_element = MENU_Main.default_element;
	selected_element = blank_element;
	
	mInputMode = M_INPUT_KEYBOARD;
	mousetimeout = time + 0.1;
}


void MainMenu_quit(float key, float ascii, menuElement *element)
{
	if (key == K_MOUSE1) {
		selected_element = blank_element;
		
		localcmd("cfg_save\nquit\n");
	}
}

void MainMenu_restart(float key, float ascii, menuElement *element)
{
	if (key == K_MOUSE1) {
		over_element = blank_element;
		current_menu = MENU_Main;
		
		menuIsOn = 0;
		setkeydest(KEY_GAME);
		setcursormode(FALSE,"");
		localcmd("map start\n");
	}
}

void MainMenu_multiplayer(float key, float ascii, menuElement *element)
{
	if (key == K_MOUSE1) {
		menuIsOn = FALSE;
		setkeydest(KEY_GAME);
		localcmd("menu_servers\n");
	}
}

void MainMenu_load(float key, float ascii, menuElement *element)
{
	if (key == K_MOUSE1) {
		selected_element = blank_element;
		
		//menuIsOn = 0;
		//setkeydest(KEY_GAME);
		//setcursormode(FALSE,"");
		current_menu = MENU_Load;
		over_element = MENU_Load.default_element;
		Savegame_Load_ScanSaves();
	}
}

void MainMenu_settings(float key, float ascii, menuElement *element)
{
	if (key == K_MOUSE1) {
		selected_element = blank_element;
		
		current_menu = MENU_Sett_Video;
		over_element = current_menu.default_element;
	}
}