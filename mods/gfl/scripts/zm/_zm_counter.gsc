#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\statstable_shared.gsh;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_faller;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_server_throttle;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_counter;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;

#namespace zm_counter;

function _INIT_ZCOUNTER()
{
	ZombieCounterHuds = [];
	ZombieCounterHuds["LastZombieText"] 	= "Zombie Left";
	ZombieCounterHuds["ZombieText"]			= "Zombies Left";
	ZombieCounterHuds["LastDogText"]		= "Dog Left";
	ZombieCounterHuds["DogText"]			= "Dogs Left";
	ZombieCounterHuds["DefaultColor"]		= (1,1,1);
	ZombieCounterHuds["HighlightColor"]		= (1, 0.55, 0);
	ZombieCounterHuds["FontScale"]			= 1.5;
	ZombieCounterHuds["DisplayType"]		= 0; // 0 = Shows Total Zombies and Counts down, 1 = Shows Currently spawned zombie count

	ZombieCounterHuds["counter"] = createNewHudElement("left", "top", 2, 10, 1, 1.5);
	ZombieCounterHuds["text"] = createNewHudElement("left", "top", 2, 10, 1, 1.5);

	ZombieCounterHuds["counter"] hudRGBA(ZombieCounterHuds["DefaultColor"], 0);
	ZombieCounterHuds["text"] hudRGBA(ZombieCounterHuds["DefaultColor"], 0);

	level thread _THINK_ZCOUNTER(ZombieCounterHuds);
}

function _THINK_ZCOUNTER(hudArray)
{
	level endon("end_game");
	for(;;)
	{
		level waittill("start_of_round");
		level _ROUND_COUNTER(hudArray);
		hudArray["counter"] SetValue(0);
		hudArray["text"] thread hudMoveTo((2, 10, 0), 4);
		
		hudArray["counter"] thread hudRGBA(hudArray["DefaultColor"], 0, 1);
		hudArray["text"] SetText("End of round"); hudArray["text"] thread hudRGBA(hudArray["DefaultColor"], 0, 3);
	}
}

function _ROUND_COUNTER(hudArray)
{
	level endon("end_of_round");
	lastCount = 0;
	numberToString = "";

	hudArray["counter"] thread hudRGBA(hudArray["DefaultColor"], 1.0, 1);
	hudArray["text"] thread hudRGBA(hudArray["DefaultColor"], 1.0, 1);
	hudArray["text"] SetText(hudArray["ZombieText"]);
	if(level flag::get("dog_round"))
		hudArray["text"] SetText(hudArray["DogText"]);

	for(;;)
	{
		zm_count = (zombie_utility::get_current_zombie_count() + level.zombie_total);
		if(hudArray["DisplayType"] == 1) zm_count = zombie_utility::get_current_zombie_count();
		if(zm_count == 0) {wait(1); continue;}
		hudArray["counter"] SetValue(zm_count);
		if(lastCount != zm_count)
		{
			lastCount = zm_count;
			numberToString = "" + zm_count;
			hudArray["text"] thread hudMoveTo((10 + (4 * numberToString.Size), 10, 0), 4);
			if(zm_count == 1 && !level flag::get("dog_round")) hudArray["text"] SetText(hudArray["LastZombieText"]);
			else if(zm_count == 1 && level flag::get("dog_round")) hudArray["text"] SetText(hudArray["LastDogText"]);

			hudArray["counter"].color = hudArray["HighlightColor"]; hudArray["counter"].fontscale = (hudArray["FontScale"] + 0.5);
			hudArray["text"].color = hudArray["HighlightColor"]; hudArray["text"].fontscale = (hudArray["FontScale"] + 0.5);
			hudArray["counter"] thread hudRGBA(hudArray["DefaultColor"], 1, 0.5); hudArray["counter"] thread hudFontScale(hudArray["FontScale"], 0.5);
			hudArray["text"] thread hudRGBA(hudArray["DefaultColor"], 1, 0.5); hudArray["text"] thread hudFontScale(hudArray["FontScale"], 0.5);
		}
		wait(0.1);
	}
}

function createNewHudElement(xAlign, yAlign, posX, posY, foreground, fontScale)
{
	hud = newHudElem();
	hud.horzAlign = xAlign; hud.alignX = xAlign;
	hud.vertAlign = yAlign; hug.alignY = yAlign;
	hud.x = posX; hud.y = posY;
	hud.foreground = foreground;
	hud.fontscale = fontScale;
	return hud;
}

function hudRGBA(newColor, newAlpha, fadeTime)
{
	if(isDefined(fadeTime))
		self FadeOverTime(fadeTime);

	self.color = newColor;
	self.alpha = newAlpha;
}

function hudFontScale(newScale, fadeTime)
{
	if(isDefined(fadeTime))
		self ChangeFontScaleOverTime(fadeTime);

	self.fontscale = newScale;
}

function hudMoveTo(posVector, fadeTime) // Just because MoveOverTime doesn't always work as wanted
{
	initTime = GetTime();
	hudX = self.x;
	hudY = self.y;
	hudVector = (hudX, hudY, 0);
	while(hudVector != posVector)
	{
		time = GetTime();
		hudVector = VectorLerp(hudVector, posVector, (time - initTime) / (fadeTime * 1000));
		self.x = hudVector[0];
		self.y = hudVector[1];
		wait(0.0001);
	}
}