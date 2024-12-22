#using scripts\gfl\character_util;

#namespace character;

function init_character_table()
{
	if ( !isdefined(level.charactertable) )
	{
		level.charactertable = [];
	}
	
	level.charactertable["generic"] = [];
	level.charactertable["generic"]["ak12"] = &swap_to_ak12;
	level.charactertable["generic"]["p90"] = &swap_to_p90;
	level.charactertable["generic"]["rfb"] = &swap_to_rfb;
	// level.charactertable["generic"]["tac50"] = &swap_to_tac50;
	// level.charactertable["generic"]["tmp"] = &swap_to_tmp;
	level.charactertable["generic"]["type89"] = &swap_to_type89;
	// level.charactertable["generic"]["type97"] = &swap_to_type97;
	// level.charactertable["generic"]["mp7"] = &swap_to_mp7;
	level.charactertable["generic"]["mp7_tights"] = &swap_to_mp7_tights;
	level.charactertable["generic"]["mp7_casual_tights"] = &swap_to_mp7_casual_tights;
	level.charactertable["generic"]["suomi"] = &swap_to_suomi;
	level.charactertable["generic"]["9a91"] = &swap_to_9a91;
	level.charactertable["generic"]["super_sass"] = &swap_to_super_sass;
	level.charactertable["generic"]["g36c"] = &swap_to_g36c;
	level.charactertable["generic"]["negev"] = &swap_to_negev;
	// level.charactertable["generic"]["g11"] = &swap_to_g11;
	level.charactertable["generic"]["mishty"] = &swap_to_mishty;
	level.charactertable["generic"]["tololo"] = &swap_to_tololo;
	// level.charactertable["generic"]["vepley"] = &swap_to_vepley;
	level.charactertable["generic"]["vepley_backpack"] = &swap_to_vepley_backpack;
	level.charactertable["generic"]["an94"] = &swap_to_an94;
	level.charactertable["generic"]["lenna"] = &swap_to_lenna;
	level.charactertable["generic"]["macqiato"] = &swap_to_macqiato;
	level.charactertable["generic"]["centaureissi"] = &swap_to_centaureissi;

	level.charactertable["sf"] = [];
	level.charactertable["sf"]["vespid"] = &swap_to_vespid;
	level.charactertable["sf"]["ripper"] = &swap_to_ripper;
	level.charactertable["sf"]["guard"] = &swap_to_guard;
	level.charactertable["sf"]["jaeger"] = &swap_to_jaeger;

	level.charactertable["sf_boss"] = [];
	level.charactertable["sf_boss"]["dreamer"] = &swap_to_dreamer;
	level.charactertable["sf_boss"]["ouroboros"] = &swap_to_ouroboros;

	level.charactertable["hero"] = [];
	level.charactertable["hero"]["hk416"] = &swap_to_hk416_cp;
	level.charactertable["hero"]["m16a1"] = &swap_to_m16a1_cp;
	level.charactertable["hero"]["m4a1"] = &swap_to_m4a1_cp;
	level.charactertable["hero"]["m4_sopmod_ii"] = &swap_to_m4_sopmod_ii_cp;
	level.charactertable["hero"]["st_ar15"] = &swap_to_st_ar15_cp;
	level.charactertable["hero"]["ro635"] = &swap_to_ro635_cp;
	level.charactertable["hero"]["ump45"] = &swap_to_ump45_cp;

	level.charactertable["training_sim"] = [];
	level.charactertable["training_sim"] = arraycombine(level.charactertable["training_sim"], level.charactertable["generic"], true, true);
	level.charactertable["training_sim"] = arraycombine(level.charactertable["training_sim"], level.charactertable["sf"], true, true);
	level.charactertable["training_sim"] = arraycombine(level.charactertable["training_sim"], level.charactertable["sf_boss"], true, true);
	// level.charactertable["training_sim"] = arraycombine(level.charactertable["training_sim"], level.charactertable["hero"], true, true);
	level.charactertable["training_sim"]["m16a1_prime"] = &swap_to_m16a1_prime;
	level.charactertable["training_sim"]["rpk16"] = &swap_to_rpk16;
	level.charactertable["training_sim"]["dima"] = &swap_to_dima;

	level.charactertable["generic_infection"] = [];
	level.charactertable["generic_infection"] = arraycombine(level.charactertable["generic_infection"], level.charactertable["generic"], true, true);
	level.charactertable["generic_infection"]["m16a1_prime"] = &swap_to_m16a1_prime;
	level.charactertable["generic_infection"]["dima"] = &swap_to_dima;

	level.charactertable["generic_safehouse"] = [];
	level.charactertable["generic_safehouse"] = arraycombine(level.charactertable["generic_safehouse"], level.charactertable["generic"], true, true);
	level.charactertable["generic_safehouse"]["dima"] = &swap_to_dima;

	level.charactertable["generic_tdoll"] = [];
	level.charactertable["generic_tdoll"] = arraycombine(level.charactertable["generic_tdoll"], level.charactertable["generic"], true, true);
	// level.charactertable["generic_tdoll"] = arraycombine(level.charactertable["generic_tdoll"], level.charactertable["hero"], true, true);
	level.charactertable["generic_tdoll"]["m16a1_prime"] = &swap_to_m16a1_prime;
	// level.charactertable["generic_tdoll"]["rpk16"] = &swap_to_rpk16;
	level.charactertable["generic_tdoll"]["dima"] = &swap_to_dima;

	level.charactertable["generic_sf"] = [];
	level.charactertable["generic_sf"] = arraycombine(level.charactertable["generic_sf"], level.charactertable["generic_tdoll"], true, true);
	level.charactertable["generic_sf"] = arraycombine(level.charactertable["generic_sf"], level.charactertable["sf"], true, true);
}

// generic
function swap_to_ak12()
{
	self detachall();
	self setmodel("t7_gfl_ak12_fb");
	self thread character_util::set_character_name();
}

function swap_to_p90()
{
	self detachall();
	self setmodel("t7_gfl_p90_fb");
	self thread character_util::set_character_name();
}

function swap_to_rfb()
{
	self detachall();
	self setmodel("t7_gfl_rfb_fb");
	self thread character_util::set_character_name();
}

function swap_to_tac50()
{
	self detachall();
	self setmodel("t7_gfl_tac50_v2_fb");
	self thread character_util::set_character_name();
}

function swap_to_tmp()
{
	self detachall();
	self setmodel("t7_gfl_tmp_fb");
	self thread character_util::set_character_name();
}

function swap_to_type89()
{
	self detachall();
	self setmodel("t7_gfl_type89_fb");
	self thread character_util::set_character_name();
}

function swap_to_type97()
{
	self detachall();
	self setmodel("t7_gfl_type97_fb");
	self thread character_util::set_character_name();
}

function swap_to_mp7()
{
	self detachall();
	self setmodel("t7_gfl_mp7_fb");
	self thread character_util::set_character_name();
}

function swap_to_mp7_tights()
{
	self detachall();
	self setmodel("t7_gfl_mp7_tights_fb");
	self thread character_util::set_character_name();
}

function swap_to_mp7_casual_tights()
{
	self detachall();
	self setmodel("t7_gfl_mp7_casual_tights_fb");
	self thread character_util::set_character_name();
}

function swap_to_suomi()
{
	self detachall();
	self setmodel("t7_gfl_suomi_fb");
	self thread character_util::set_character_name();
}

function swap_to_9a91()
{
	self detachall();
	self setmodel("t7_gfl_9a91_fb");
	self thread character_util::set_character_name();
}

function swap_to_super_sass()
{
	self detachall();
	self setmodel("t7_gfl_super_sass_fb");
	self thread character_util::set_character_name();
}

function swap_to_g36c()
{
	self detachall();
	self setmodel("t7_gfl_g36c_fb");
	self thread character_util::set_character_name();
}

function swap_to_negev()
{
	self detachall();
	self setmodel("t7_gfl_negev_fb");
	self thread character_util::set_character_name();
}

function swap_to_g11()
{
	self detachall();
	self setmodel("t7_gfl_g11_fb");
	self thread character_util::set_character_name();
}

function swap_to_mishty()
{
	self detachall();
	self setmodel("t7_gfl_mishty_fb");
	self thread character_util::set_character_name();
}

function swap_to_rpk16()
{
	self detachall();
	self setmodel("t7_gfl_rpk16_fb");
	self thread character_util::set_character_name();
}

function swap_to_tololo()
{
	self detachall();
	self setmodel("t7_gfl_tololo_fb");
	self thread character_util::set_character_name();
}

function swap_to_vepley()
{
	self detachall();
	self setmodel("t7_gfl_vepley_fb");
	self thread character_util::set_character_name();
}

function swap_to_vepley_backpack()
{
	self detachall();
	self setmodel("t7_gfl_vepley_backpack_fb");
	self thread character_util::set_character_name();
}

function swap_to_dima()
{
	self detachall();
	self setmodel("t7_gfl_dima_fb");
	self thread character_util::set_character_name();
}

function swap_to_an94()
{
	self detachall();
	self setmodel("t7_gfl_an94_fb");
	self thread character_util::set_character_name();
}

function swap_to_lenna()
{
	self detachall();
	self setmodel("t7_gfl_lenna_fb");
	self thread character_util::set_character_name();
}

function swap_to_m16a1_prime()
{
	self detachall();
	self setmodel("t7_gfl_m16a1_prime_fb");
	self thread character_util::set_character_name();
}

function swap_to_macqiato()
{
	self detachall();
	self setmodel("t7_gfl_macqiato_fb");
	self thread character_util::set_character_name();
}

function swap_to_centaureissi()
{
	self detachall();
	self setmodel("t7_gfl_centaureissi_fb");
	self thread character_util::set_character_name();
}

// sf
function swap_to_vespid()
{
	self detachall();
	self setmodel("t7_gfl_vespid_fb");
	self thread character_util::set_character_name();
}

function swap_to_ripper()
{
	self detachall();
	self setmodel("t7_gfl_ripper_fb");
	self thread character_util::set_character_name();
}

function swap_to_guard()
{
	self detachall();
	self setmodel("t7_gfl_guard_fb");
	self thread character_util::set_character_name();
}

function swap_to_jaeger()
{
	self detachall();
	self setmodel("t7_gfl_jaeger_fb");
	self thread character_util::set_character_name();
}

function swap_to_dreamer()
{
	self detachall();
	self setmodel("t7_gfl_dreamer_fb");
	self thread character_util::set_character_name();
}

function swap_to_ouroboros()
{
	self detachall();
	self setmodel("t7_gfl_ouroboros_fb");
	self thread character_util::set_character_name();
}

// campaign hero
function swap_to_hk416_cp()
{
	self detachall();
	self setmodel("c_hro_hendricks_base_fb");
	self thread character_util::set_character_name();
}

function swap_to_m16a1_cp()
{
	self detachall();
	self setmodel("c_hro_taylor_base_fb");
	self thread character_util::set_character_name();
}

function swap_to_m4a1_cp()
{
	self detachall();
	self setmodel("c_hro_sarah_base_fb");
	self thread character_util::set_character_name();
}

function swap_to_m4_sopmod_ii_cp()
{
	self detachall();
	self setmodel("c_hro_diaz_base_fb");
	self thread character_util::set_character_name();
}

function swap_to_st_ar15_cp()
{
	self detachall();
	self setmodel("c_hro_maretti_base_fb");
	self thread character_util::set_character_name();
}

function swap_to_ro635_cp()
{
	self detachall();
	self setmodel("c_hro_rachel_egypt_fb");
	self thread character_util::set_character_name();
}

function swap_to_ump45_cp()
{
	self detachall();
	self setmodel("c_hro_playerfemale_prologue_fb");
	self thread character_util::set_character_name();
}