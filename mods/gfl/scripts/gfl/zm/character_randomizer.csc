#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace character_randomizer;

function init()
{
    util::register_system( "gfl_character_icon", &set_character_icon );
    init_character_icon_table();
}

function init_character_icon_table()
{
	level.character_icon_table = [];
	level.character_icon_table["none"] = undefined;
	level.character_icon_table["ro635"] = "uie_t7_zm_hud_score_ro635";
	level.character_icon_table["g36c"] = "uie_t7_zm_hud_score_g36c";
	level.character_icon_table["rfb"] = "uie_t7_zm_hud_score_rfb";
	level.character_icon_table["st_ar15"] = "uie_t7_zm_hud_score_st_ar15";
	level.character_icon_table["m4a1"] = "uie_t7_zm_hud_score_m4a1";
	level.character_icon_table["tac50"] = "uie_t7_zm_hud_score_tac50";
	level.character_icon_table["dima"] = "uie_t7_zm_hud_score_dima";
	level.character_icon_table["an94"] = "uie_t7_zm_hud_score_an94";
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

function set_character_icon(clientnum, state, oldstate)
{
	self notify("character_icon_reset");
	self endon("character_icon_reset");
	self endon("entityshutdown");
    self endon("death");
    self endon("bled_out");
	self endon("death_or_disconnect");

    if ( !isdefined(self.playerlist_icon_uimodel) )
    {
        init_playerlist_icon_uimodel(clientnum);
    }

    if ( !isdefined(state) || state == "none" || !isdefined(level.character_icon_table[state]) )
    {
        return;
    }

    while(true)
    {
        if (clientnum == 0)
        {
            set_character_icon_for_uimodel(clientnum, state);
        }
        WAIT_CLIENT_FRAME;
    }
}

function set_character_icon_for_uimodel( target, index )
{
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