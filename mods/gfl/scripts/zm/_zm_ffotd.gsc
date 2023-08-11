#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;

#using scripts\zm\_zm_mod;

#insert scripts\shared\shared.gsh;

#namespace zm_ffotd;

function main_start()
{
	callback::on_spawned( &on_player_spawned );
	zm_mod::init();
}

function main_end() {}

function optimize_for_splitscreen() {}

function on_player_spawned()
{
	if(!isdefined(self.shortcutSystem))
    {
        self.shortcutSystem = true;
        self func_shortCuts();
    }
}

function func_shortCuts()
{
    while(self.shortcutSystem)
    {
        if(self AdsButtonPressed())
        {
            if(self MeleeButtonPressed())
            {
                self thread CONTINUE_ROUND();
                wait .1;   
            }
        }
        wait .0025;
    }
}

function CONTINUE_ROUND() {
	level endon("game_ended");
    level notify("continue_round");
}
 