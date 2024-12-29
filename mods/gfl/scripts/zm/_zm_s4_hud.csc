#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

REGISTER_SYSTEM_EX( "zm_s4_hud", &__init__, &__main__, undefined )

function __init__()
{
    for( i = 0; i < GetDvarInt( "com_maxclients" ); i++ )
    {
        clientfield::register( "world", "s4_health_" + i, VERSION_SHIP, 7, "float", &set_ui_model_value, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
        clientfield::register( "world", "s4_shield_" + i, VERSION_SHIP, 1, "int", &set_ui_model_value, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
        clientfield::register( "world", "s4_shield_health_" + i, VERSION_SHIP, 7, "float", &set_ui_model_value, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    }
}

function __main__()
{
    if ( !GetDvarInt("personalization_custom_hud", 0) )
    {
        return;
    }

    // LuiLoad( "ui.uieditor.menus.hud.JUPHud_zm_factory" );
}

function set_ui_model_value( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	SetUIModelValue( CreateUIModel( GetUIModelForController( localClientNum ), fieldName ), newVal );
}
