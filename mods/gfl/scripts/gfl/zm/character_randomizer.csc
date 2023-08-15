#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace character_randomizer;

function init()
{
	clientfield::register("toplayer", "gfl_character_icon", VERSION_SHIP, 4, "int", &set_character_icon, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT);
	init_character_icon_table();
}

function init_character_icon_table()
{
	level.character_icon_table = [];
	level.character_icon_table[0] = undefined;
	level.character_icon_table[1] = "uie_t7_zm_hud_score_ro635";
	level.character_icon_table[2] = "uie_t7_zm_hud_score_g36c";
	level.character_icon_table[3] = "uie_t7_zm_hud_score_rfb";
	level.character_icon_table[4] = "uie_t7_zm_hud_score_st_ar15";
	level.character_icon_table[5] = "uie_t7_zm_hud_score_m4a1";
}

function init_playerlist_icon_uimodel( n_local_client )
{
    controllerModel = GetUIModelForController( n_local_client );
	self.playerlist_icon_uimodel = [];
    // for ( i = 0; i < GetLocalPlayers().size; i++ )
    // {
    //     self.playerlist_icon_uimodel[i] = CreateUIModel( controllerModel, "PlayerList." + i + ".zombiePlayerIcon" );
    // }
    self.playerlist_icon_uimodel[0] = CreateUIModel( controllerModel, "PlayerList." + 0 + ".zombiePlayerIcon" );
}

function set_character_icon( n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump )
{
	self notify("character_icon_reset");
	self endon("character_icon_reset");
	self endon("entityshutdown");
	self endon("death_or_disconnect");

    if ( !isdefined(self.playerlist_icon_uimodel) )
    {
        init_playerlist_icon_uimodel(n_local_client);
    }

    index = n_new;
    if ( index == 0 || index >= level.character_icon_table.size )
    {
        return;
    }

    while(true)
    {
        if (n_local_client == 0)
        {
            set_character_icon_for_uimodel(n_local_client, index);
        }
        WAIT_CLIENT_FRAME;
    }
}

function set_character_icon_for_uimodel( target, index )
{
	self endon("death_or_disconnect");
    model = get_icon_uimodel(target);
    if ( !isdefined(model) )
    {
        return;
    }

    image_name = level.character_icon_table[index];
    if ( isdefined(image_name) )
    {
        SetUIModelValue( model, image_name );
    }
}

function get_icon_uimodel( target )
{
    if ( !isdefined(self.playerlist_icon_uimodel) || target >= self.playerlist_icon_uimodel.size )
    {
        return undefined;
    }

    return self.playerlist_icon_uimodel[target];
}