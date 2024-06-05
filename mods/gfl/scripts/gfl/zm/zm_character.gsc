#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using scripts\gfl\character_util;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_character;

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
	level.charactertable["zm"]["lenna"] = &swap_to_lenna;
	level.charactertable["zm"]["macqiato"] = &swap_to_macqiato;

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
	level.additional_bodystyle_table["t7_gfl_m4a1_v3_fb"] = 3;
	// ak12
	level.additional_bodystyle_table["c_zom_dlc3_nikolai_mpc_fb"] = 1;
	level.additional_bodystyle_table["t7_gfl_an94_fb"] = 3;
	// suomi
	level.additional_bodystyle_table["t7_gfl_rfb_fb"] = 1;
	// m4 sopmod ii
	level.additional_bodystyle_table["t7_gfl_ro635_fb"] = 1;
	level.additional_bodystyle_table["t7_gfl_st_ar15_v2_fb"] = 2;
	// p90
	level.additional_bodystyle_table["t7_gfl_g36c_fb"] = 1;
	// super sass
	level.additional_bodystyle_table["t7_gfl_macqiato_fb"] = 1;
	level.additional_bodystyle_table["t7_gfl_tac50_v2_fb"] = 2;
	// vepley
	level.additional_bodystyle_table["t7_gfl_vepley_fb"] = 1;
	// mp7
	level.additional_bodystyle_table["t7_gfl_mp7_casual_tights_fb"] = 1;
	// g11
	level.additional_bodystyle_table["t7_gfl_dima_fb"] = 1;
	// ump45
	level.additional_bodystyle_table["t7_gfl_lenna_fb"] = 1;


	level.model_to_character_table = [];
	level.model_to_character_table["der_dempsey"] = "m16a1_prime";
	level.model_to_character_table["dlc3_dempsey"] = "m16a1_prime";
	level.model_to_character_table["waw_dempsey"] = "m16a1";
	level.model_to_character_table["m16a1_prime"] = "m16a1_prime";
	level.model_to_character_table["m16a1_v2"] = "m16a1";
	level.model_to_character_table["m4a1"] = "m4a1";
	
	level.model_to_character_table["_nikolai_"] = "ak12";
	level.model_to_character_table["ak12"] = "ak12";
	level.model_to_character_table["an94"] = "an94";

	level.model_to_character_table["_richtofen_"] = "hk416";
	level.model_to_character_table["hk416"] = "hk416";

	level.model_to_character_table["_takeo_"] = "type89";
	level.model_to_character_table["type89"] = "type89";

	level.model_to_character_table["_boxer_"] = "tololo";
	level.model_to_character_table["tololo"] = "tololo";

	level.model_to_character_table["_detective_"] = "suomi";
	level.model_to_character_table["suomi"] = "suomi";
	level.model_to_character_table["rfb"] = "rfb";

	level.model_to_character_table["_femme_"] = "vepley_backpack";
	level.model_to_character_table["vepley_backpack"] = "vepley_backpack";
	level.model_to_character_table["vepley_fb"] = "vepley";

	level.model_to_character_table["_magician_"] = "mp7_tights";
	level.model_to_character_table["mp7_tights"] = "mp7_tights";
	level.model_to_character_table["mp7_casual"] = "mp7_casual_tights";

	level.model_to_character_table["super_sass"] = "super_sass";
	level.model_to_character_table["macqiato"] = "macqiato";
	level.model_to_character_table["tac50"] = "tac50";

	level.model_to_character_table["p90"] = "p90";
	level.model_to_character_table["g36c"] = "g36c";

	level.model_to_character_table["ump45"] = "ump45";
	level.model_to_character_table["lenna"] = "lenna";

	level.model_to_character_table["g11"] = "g11";
	level.model_to_character_table["dima"] = "dima";

	level.model_to_character_table["m4_sopmod_ii"] = "m4_sopmod_ii";
	level.model_to_character_table["st_ar15"] = "st_ar15";
	level.model_to_character_table["ro635"] = "ro635";

	level.model_to_character_table["9a91"] = "9a91";
	level.model_to_character_table["negev"] = "negev";
	level.model_to_character_table["rpk16"] = "rpk16";

	level.model_to_character_table["dreamer"] = "dreamer";
	level.model_to_character_table["ouroboros"] = "ouroboros";
	level.model_to_character_table["vespid"] = "vespid";
	level.model_to_character_table["ripper"] = "ripper";
	level.model_to_character_table["guard"] = "guard";
	level.model_to_character_table["jaeger"] = "jaeger";
	level.model_to_character_table["c_t7_zm_dlchd_origins_player_body_mpc"] = "jaeger";


	level.model_to_character_name_table = [];
	level.model_to_character_name_table["_dempsey_"] = "M16A1";
	level.model_to_character_name_table["m16a1"] = "M16A1";
	level.model_to_character_name_table["m4a1"] = "M4A1";

	level.model_to_character_name_table["_nikolai_"] = "AK-12";
	level.model_to_character_name_table["ak12"] = "AK-12";
	level.model_to_character_name_table["an94"] = "AN-94";

	level.model_to_character_name_table["_richtofen_"] = "HK416";
	level.model_to_character_name_table["hk416"] = "HK416";

	level.model_to_character_name_table["_takeo_"] = "Howa Type 89";
	level.model_to_character_name_table["type89"] = "Howa Type 89";

	level.model_to_character_name_table["_boxer_"] = "AK-Alfa";
	level.model_to_character_name_table["tololo"] = "AK-Alfa";

	level.model_to_character_name_table["_detective_"] = "Suomi";
	level.model_to_character_name_table["suomi"] = "Suomi";
	level.model_to_character_name_table["rfb"] = "RFB";

	level.model_to_character_name_table["_femme_"] = "Vepley";
	level.model_to_character_name_table["vepley"] = "Vepley";

	level.model_to_character_name_table["_magician_"] = "MP7";
	level.model_to_character_name_table["mp7"] = "MP7";

	level.model_to_character_name_table["super_sass"] = "Super SASS";
	level.model_to_character_name_table["macqiato"] = "WA2000";
	level.model_to_character_name_table["tac50"] = "TAC-50";

	level.model_to_character_name_table["p90"] = "P90";
	level.model_to_character_name_table["g36c"] = "G36C";

	level.model_to_character_name_table["ump45"] = "UMP45";
	level.model_to_character_name_table["lenna"] = "UMP9";

	level.model_to_character_name_table["g11"] = "G11";
	level.model_to_character_name_table["dima"] = "Dima";

	level.model_to_character_name_table["m4_sopmod_ii"] = "M4 SOPMOD II";
	level.model_to_character_name_table["st_ar15"] = "ST AR-15";
	level.model_to_character_name_table["ro635"] = "RO635";

	level.model_to_character_name_table["_beast_"] = "Beast";
	level.model_to_character_name_table["9a91"] = "9A-91";
	level.model_to_character_name_table["negev"] = "Negev";
	level.model_to_character_name_table["rpk16"] = "RPK-16";

	level.model_to_character_name_table["dreamer"] = "Dreamer";
	level.model_to_character_name_table["ouroboros"] = "Ouroboros";
	level.model_to_character_name_table["vespid"] = "Vespid";
	level.model_to_character_name_table["ripper"] = "Ripper";
	level.model_to_character_name_table["guard"] = "Guard";
	level.model_to_character_name_table["jaeger"] = "Jaeger";
	level.model_to_character_name_table["c_t7_zm_dlchd_origins_player_body_mpc"] = "Jaeger";
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

function swap_to_rfb()
{
	self.cc_bodytype = 6;
	self.cc_bodystyle = 1;
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

function swap_to_lenna()
{
	self.cc_bodytype = 12;
	self.cc_bodystyle = 1;
	self character_util::swap_to_cc();
}

function swap_to_super_sass()
{
	self.cc_bodytype = 13;
	self.cc_bodystyle = 0;
	self character_util::swap_to_cc();
}

function swap_to_macqiato()
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