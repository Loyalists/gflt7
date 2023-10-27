#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using scripts\gfl\character_util;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace character_zm;

function init_character_table()
{
	if ( !isdefined(level.charactertable) )
	{
		level.charactertable = [];
	}

	level.charactertable["zm"] = [];
	level.charactertable["zm"]["m16a1_prime"] = &swap_to_m16a1_prime;
	level.charactertable["zm"]["ak12"] = &swap_to_ak12;
	level.charactertable["zm"]["hk416"] = &swap_to_hk416;
	level.charactertable["zm"]["type89"] = &swap_to_type89;
	level.charactertable["zm"]["m16a1"] = &swap_to_m16a1;
	level.charactertable["zm"]["tololo"] = &swap_to_tololo;
	level.charactertable["zm"]["suomi"] = &swap_to_suomi;
	level.charactertable["zm"]["vepley_backpack"] = &swap_to_vepley_backpack;
	level.charactertable["zm"]["mp7_tights"] = &swap_to_mp7_tights;
	level.charactertable["zm"]["m4_sopmod_ii"] = &swap_to_m4_sopmod_ii;
	level.charactertable["zm"]["p90"] = &swap_to_p90;
	level.charactertable["zm"]["9a91"] = &swap_to_9a91;
	level.charactertable["zm"]["ump45"] = &swap_to_ump45;
	level.charactertable["zm"]["super_sass"] = &swap_to_super_sass;
	level.charactertable["zm"]["negev"] = &swap_to_negev;
	level.charactertable["zm"]["g11"] = &swap_to_g11;
	level.charactertable["zm"]["ro635"] = &swap_to_ro635;
	level.charactertable["zm"]["g36c"] = &swap_to_g36c;
	level.charactertable["zm"]["rfb"] = &swap_to_rfb;
	level.charactertable["zm"]["st_ar15"] = &swap_to_st_ar15;
	level.charactertable["zm"]["vepley"] = &swap_to_vepley;
	level.charactertable["zm"]["m4a1"] = &swap_to_m4a1;
	level.charactertable["zm"]["mp7_casual_tights"] = &swap_to_mp7_casual_tights;
	level.charactertable["zm"]["tac50"] = &swap_to_tac50;
	level.charactertable["zm"]["dima"] = &swap_to_dima;
	level.charactertable["zm"]["an94"] = &swap_to_an94;

	level.charactertable["zm_moon"] = [];
	level.charactertable["zm_moon"]["m16a1"] = &swap_to_m16a1_moon;
	level.charactertable["zm_moon"]["ak12"] = &swap_to_ak12;
	level.charactertable["zm_moon"]["hk416"] = &swap_to_hk416;
	level.charactertable["zm_moon"]["type89"] = &swap_to_type89;
	level.charactertable["zm_moon"]["tololo"] = &swap_to_tololo;
	level.charactertable["zm_moon"]["suomi"] = &swap_to_suomi;
	level.charactertable["zm_moon"]["vepley_backpack"] = &swap_to_vepley_backpack;
	level.charactertable["zm_moon"]["mp7_tights"] = &swap_to_mp7_tights;

	// lookup table of model name substr to its bodystyle index
	level.additional_bodystyle_table = [];
	// m16a1
	level.additional_bodystyle_table["c_zom_der_dempsey_mpc_fb"] = 1;
	level.additional_bodystyle_table["c_zom_dlc3_dempsey_mpc_fb"] = 1;
	level.additional_bodystyle_table["c_t7_zm_dlchd_waw_dempsey_mpc_fb"] = 2;
	level.additional_bodystyle_table["t7_gfl_m4a1_v2_fb"] = 3;
	// ak12
	level.additional_bodystyle_table["c_zom_dlc3_nikolai_mpc_fb"] = 1;
	level.additional_bodystyle_table["t7_gfl_an94_fb"] = 3;
	// m4 sopmod ii
	level.additional_bodystyle_table["t7_gfl_ro635_fb"] = 1;
	level.additional_bodystyle_table["t7_gfl_st_ar15_v2_fb"] = 2;
	// p90
	level.additional_bodystyle_table["t7_gfl_g36c_fb"] = 1;
	// super sass
	level.additional_bodystyle_table["t7_gfl_rfb_fb"] = 1;
	level.additional_bodystyle_table["t7_gfl_tac50_v2_fb"] = 2;
	// vepley
	level.additional_bodystyle_table["t7_gfl_vepley_fb"] = 1;
	// mp7
	level.additional_bodystyle_table["t7_gfl_mp7_casual_tights_fb"] = 1;
	// g11
	level.additional_bodystyle_table["t7_gfl_dima_fb"] = 1;

	level.model_to_character_table = [];
	level.model_to_character_table["t7_gfl_m4a1_v2_fb"] = "m4a1";
	level.model_to_character_table["t7_gfl_ro635_fb"] = "ro635";
	level.model_to_character_table["t7_gfl_st_ar15_v2_fb"] = "st_ar15";
	level.model_to_character_table["t7_gfl_g36c_fb"] = "g36c";
	level.model_to_character_table["t7_gfl_rfb_fb"] = "rfb";
	level.model_to_character_table["t7_gfl_tac50_v2_fb"] = "tac50";
	level.model_to_character_table["t7_gfl_dima_fb"] = "dima";
	level.model_to_character_table["t7_gfl_an94_fb"] = "an94";
}

function swap_to_m16a1_moon()
{
	self.cc_bodytype = 0;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_m16a1_prime()
{
	self.cc_bodytype = 0;
	self.cc_bodystyle = 1;
	self character_util::swap_to_cc();
}

function swap_to_m16a1()
{
	self.cc_bodytype = 0;
	self.cc_bodystyle = 2;
	self character_util::swap_to_cc();
}

function swap_to_m4a1()
{
	self.cc_bodytype = 0;
	self.cc_bodystyle = 3;
	self character_util::swap_to_cc();
}

function swap_to_ak12()
{
	self.cc_bodytype = 1;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_an94()
{
	self.cc_bodytype = 1;
	self.cc_bodystyle = 3;
	self character_util::swap_to_cc();
}

function swap_to_hk416()
{
	self.cc_bodytype = 2;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_type89()
{
	self.cc_bodytype = 3;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_tololo()
{
	self.cc_bodytype = 5;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_suomi()
{
	self.cc_bodytype = 6;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_vepley_backpack()
{
	self.cc_bodytype = 7;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_vepley()
{
	self.cc_bodytype = 7;
	self.cc_bodystyle = 1;
	self character_util::swap_to_cc();
}

function swap_to_mp7_tights()
{
	self.cc_bodytype = 8;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_mp7_casual_tights()
{
	self.cc_bodytype = 8;
	self.cc_bodystyle = 1;
	self character_util::swap_to_cc();
}

function swap_to_m4_sopmod_ii()
{
	self.cc_bodytype = 9;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_ro635()
{
	self.cc_bodytype = 9;
	self.cc_bodystyle = 1;
	self character_util::swap_to_cc();
}

function swap_to_st_ar15()
{
	self.cc_bodytype = 9;
	self.cc_bodystyle = 2;
	self character_util::swap_to_cc();
}

function swap_to_p90()
{
	self.cc_bodytype = 10;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_g36c()
{
	self.cc_bodytype = 10;
	self.cc_bodystyle = 1;
	self character_util::swap_to_cc();
}

function swap_to_9a91()
{
	self.cc_bodytype = 11;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_ump45()
{
	self.cc_bodytype = 12;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_super_sass()
{
	self.cc_bodytype = 13;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_rfb()
{
	self.cc_bodytype = 13;
	self.cc_bodystyle = 1;
	self character_util::swap_to_cc();
}

function swap_to_tac50()
{
	self.cc_bodytype = 13;
	self.cc_bodystyle = 2;
	self character_util::swap_to_cc();
}

function swap_to_negev()
{
	self.cc_bodytype = 14;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_g11()
{
	self.cc_bodytype = 15;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_dima()
{
	self.cc_bodytype = 15;
	self.cc_bodystyle = 1;
	self character_util::swap_to_cc();
}