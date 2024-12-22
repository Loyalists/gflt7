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
	level.charactertable["zm"]["m16a1_prime"] = create_m16a1_prime();
	level.charactertable["zm"]["ak12"] = create_ak12();
	level.charactertable["zm"]["hk416"] = create_hk416();
	level.charactertable["zm"]["type89"] = create_type89();
	level.charactertable["zm"]["m16a1"] = create_m16a1();
	level.charactertable["zm"]["jaeger"] = create_jaeger();
	level.charactertable["zm"]["guard"] = create_guard();
	level.charactertable["zm"]["ripper"] = create_ripper();
	level.charactertable["zm"]["vespid"] = create_vespid();
	level.charactertable["zm"]["ouroboros"] = create_ouroboros();
	level.charactertable["zm"]["dreamer"] = create_dreamer();
	level.charactertable["zm"]["tololo"] = create_tololo();
	level.charactertable["zm"]["suomi"] = create_suomi();
	level.charactertable["zm"]["vepley_backpack"] = create_vepley_backpack();
	level.charactertable["zm"]["mp7_tights"] = create_mp7_tights();
	level.charactertable["zm"]["m4_sopmod_ii"] = create_m4_sopmod_ii();
	level.charactertable["zm"]["p90"] = create_p90();
	level.charactertable["zm"]["9a91"] = create_9a91();
	level.charactertable["zm"]["ump45"] = create_ump45();
	level.charactertable["zm"]["super_sass"] = create_super_sass();
	level.charactertable["zm"]["negev"] = create_negev();
	level.charactertable["zm"]["g11"] = create_g11();
	level.charactertable["zm"]["ro635"] = create_ro635();
	level.charactertable["zm"]["g36c"] = create_g36c();
	level.charactertable["zm"]["rfb"] = create_rfb();
	level.charactertable["zm"]["st_ar15"] = create_st_ar15();
	level.charactertable["zm"]["vepley"] = create_vepley();
	level.charactertable["zm"]["m4a1"] = create_m4a1();
	level.charactertable["zm"]["mp7_casual_tights"] = create_mp7_casual_tights();
	// level.charactertable["zm"]["tac50"] = create_tac50();
	level.charactertable["zm"]["dima"] = create_dima();
	level.charactertable["zm"]["an94"] = create_an94();
	level.charactertable["zm"]["lenna"] = create_lenna();
	level.charactertable["zm"]["macqiato"] = create_macqiato();
	level.charactertable["zm"]["centaureissi"] = create_centaureissi();

	level.charactertable["zm_moon"] = [];
	level.charactertable["zm_moon"]["m16a1"] = create_m16a1_moon();
	level.charactertable["zm_moon"]["ak12"] = create_ak12();
	level.charactertable["zm_moon"]["hk416"] = create_hk416();
	level.charactertable["zm_moon"]["type89"] = create_type89();
	level.charactertable["zm_moon"]["tololo"] = create_tololo();
	level.charactertable["zm_moon"]["suomi"] = create_suomi();
	level.charactertable["zm_moon"]["vepley_backpack"] = create_vepley_backpack();
	level.charactertable["zm_moon"]["mp7_tights"] = create_mp7_tights();
}

function create_m16a1_moon()
{
	obj = SpawnStruct();
	obj.bodytype = 0;
	obj.bodystyle = 0;
	obj.id = "m16a1";
	obj.keywords = array("m16a1_v2", "waw_dempsey");
	obj.name = "M16A1";
	return obj;
}

function create_m16a1_prime()
{
	obj = SpawnStruct();
	obj.bodytype = 0;
	obj.bodystyle = 1;
	obj.id = "m16a1_prime";
	obj.keywords = array("der_dempsey", "dlc3_dempsey");
	obj.name = "M16A1";
	return obj;
}

function create_m16a1()
{
	obj = SpawnStruct();
	obj.bodytype = 0;
	obj.bodystyle = 2;
	obj.id = "m16a1";
	obj.keywords = array("m16a1_v2", "waw_dempsey");
	obj.name = "M16A1";
	return obj;
}

function create_m4a1()
{
	obj = SpawnStruct();
	obj.bodytype = 0;
	obj.bodystyle = 3;
	obj.id = "m4a1";
	obj.keywords = array();
	obj.name = "M4A1";
	return obj;
}

function create_ak12()
{
	obj = SpawnStruct();
	obj.bodytype = 1;
	obj.bodystyle = 0;
	obj.id = "ak12";
	obj.keywords = array("_nikolai_");
	obj.name = "AK-12";
	return obj;
}

function create_an94()
{
	obj = SpawnStruct();
	obj.bodytype = 1;
	obj.bodystyle = 3;
	obj.id = "an94";
	obj.keywords = array();
	obj.name = "AN-94";
	return obj;
}

function create_hk416()
{
	obj = SpawnStruct();
	obj.bodytype = 2;
	obj.bodystyle = 0;
	obj.id = "hk416";
	obj.keywords = array("_richtofen_");
	obj.name = "HK416";
	return obj;
}

function create_type89()
{
	obj = SpawnStruct();
	obj.bodytype = 3;
	obj.bodystyle = 0;
	obj.id = "type89";
	obj.keywords = array("_takeo_");
	obj.name = "Howa Type 89";
	return obj;
}

function create_jaeger()
{
	obj = SpawnStruct();
	obj.bodytype = 4;
	obj.bodystyle = 0;
	obj.id = "jaeger";
	obj.keywords = array();
	obj.name = "Jaeger";
	return obj;
}

function create_guard()
{
	obj = SpawnStruct();
	obj.bodytype = 4;
	obj.bodystyle = 1;
	obj.id = "guard";
	obj.keywords = array();
	obj.name = "Guard";
	return obj;
}

function create_ripper()
{
	obj = SpawnStruct();
	obj.bodytype = 4;
	obj.bodystyle = 2;
	obj.id = "ripper";
	obj.keywords = array();
	obj.name = "Ripper";
	return obj;
}

function create_vespid()
{
	obj = SpawnStruct();
	obj.bodytype = 4;
	obj.bodystyle = 3;
	obj.id = "vespid";
	obj.keywords = array();
	obj.name = "Vespid";
	return obj;
}

function create_ouroboros()
{
	obj = SpawnStruct();
	obj.bodytype = 4;
	obj.bodystyle = 5;
	obj.id = "ouroboros";
	obj.keywords = array();
	obj.name = "Ouroboros";
	return obj;
}

function create_dreamer()
{
	obj = SpawnStruct();
	obj.bodytype = 4;
	obj.bodystyle = 6;
	obj.id = "dreamer";
	obj.keywords = array();
	obj.name = "Dreamer";
	return obj;
}

function create_tololo()
{
	obj = SpawnStruct();
	obj.bodytype = 5;
	obj.bodystyle = 0;
	obj.id = "tololo";
	obj.keywords = array("_boxer_");
	obj.name = "AK-Alfa";
	return obj;
}

function create_suomi()
{
	obj = SpawnStruct();
	obj.bodytype = 6;
	obj.bodystyle = 0;
	obj.id = "suomi";
	obj.keywords = array("_detective_");
	obj.name = "Suomi";
	return obj;
}

function create_rfb()
{
	obj = SpawnStruct();
	obj.bodytype = 6;
	obj.bodystyle = 1;
	obj.id = "rfb";
	obj.keywords = array("rfb");
	obj.name = "RFB";
	return obj;
}

function create_vepley_backpack()
{
	obj = SpawnStruct();
	obj.bodytype = 7;
	obj.bodystyle = 0;
	obj.id = "vepley_backpack";
	obj.keywords = array("vepley_backpack", "_femme_");
	obj.name = "Vepley";
	return obj;
}

function create_vepley()
{
	obj = SpawnStruct();
	obj.bodytype = 7;
	obj.bodystyle = 1;
	obj.id = "vepley";
	obj.keywords = array("vepley_fb");
	obj.name = "Vepley";
	return obj;
}

function create_mp7_tights()
{
	obj = SpawnStruct();
	obj.bodytype = 8;
	obj.bodystyle = 0;
	obj.id = "mp7_tights";
	obj.keywords = array("mp7_tights", "_magician_");
	obj.name = "MP7";
	return obj;
}

function create_mp7_casual_tights()
{
	obj = SpawnStruct();
	obj.bodytype = 8;
	obj.bodystyle = 1;
	obj.id = "mp7_casual_tights";
	obj.keywords = array("mp7_casual");
	obj.name = "MP7";
	return obj;
}

function create_m4_sopmod_ii()
{
	obj = SpawnStruct();
	obj.bodytype = 9;
	obj.bodystyle = 0;
	obj.id = "m4_sopmod_ii";
	obj.keywords = array();
	obj.name = "M4 SOPMOD II";
	return obj;
}

function create_ro635()
{
	obj = SpawnStruct();
	obj.bodytype = 9;
	obj.bodystyle = 1;
	obj.id = "ro635";
	obj.keywords = array();
	obj.name = "RO635";
	return obj;
}

function create_st_ar15()
{
	obj = SpawnStruct();
	obj.bodytype = 9;
	obj.bodystyle = 2;
	obj.id = "st_ar15";
	obj.keywords = array();
	obj.name = "ST AR-15";
	return obj;
}

function create_p90()
{
	obj = SpawnStruct();
	obj.bodytype = 10;
	obj.bodystyle = 0;
	obj.id = "p90";
	obj.keywords = array();
	obj.name = "P90";
	return obj;
}

function create_g36c()
{
	obj = SpawnStruct();
	obj.bodytype = 10;
	obj.bodystyle = 1;
	obj.id = "g36c";
	obj.keywords = array();
	obj.name = "G36C";
	return obj;
}

function create_centaureissi()
{
	obj = SpawnStruct();
	obj.bodytype = 10;
	obj.bodystyle = 2;
	obj.id = "centaureissi";
	obj.keywords = array();
	obj.name = "G36";
	return obj;
}

function create_9a91()
{
	obj = SpawnStruct();
	obj.bodytype = 11;
	obj.bodystyle = 0;
	obj.id = "9a91";
	obj.keywords = array();
	obj.name = "9A-91";
	return obj;
}

function create_ump45()
{
	obj = SpawnStruct();
	obj.bodytype = 12;
	obj.bodystyle = 0;
	obj.id = "ump45";
	obj.keywords = array();
	obj.name = "UMP45";
	return obj;
}

function create_lenna()
{
	obj = SpawnStruct();
	obj.bodytype = 12;
	obj.bodystyle = 1;
	obj.id = "lenna";
	obj.keywords = array();
	obj.name = "UMP9";
	return obj;
}

function create_super_sass()
{
	obj = SpawnStruct();
	obj.bodytype = 13;
	obj.bodystyle = 0;
	obj.id = "super_sass";
	obj.keywords = array();
	obj.name = "Super SASS";
	return obj;
}

function create_macqiato()
{
	obj = SpawnStruct();
	obj.bodytype = 13;
	obj.bodystyle = 1;
	obj.id = "macqiato";
	obj.keywords = array();
	obj.name = "WA2000";
	return obj;
}

function create_tac50()
{
	obj = SpawnStruct();
	obj.bodytype = 13;
	obj.bodystyle = 2;
	obj.id = "tac50";
	obj.keywords = array();
	obj.name = "TAC-50";
	return obj;
}

function create_negev()
{
	obj = SpawnStruct();
	obj.bodytype = 14;
	obj.bodystyle = 0;
	obj.id = "negev";
	obj.keywords = array();
	obj.name = "Negev";
	return obj;
}

function create_g11()
{
	obj = SpawnStruct();
	obj.bodytype = 15;
	obj.bodystyle = 0;
	obj.id = "g11";
	obj.keywords = array("mishty");
	obj.name = "G11";
	return obj;
}

function create_dima()
{
	obj = SpawnStruct();
	obj.bodytype = 15;
	obj.bodystyle = 1;
	obj.id = "dima";
	obj.keywords = array();
	obj.name = "Dima";
	return obj;
}