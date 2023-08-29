/*
*    Infinity Loader :: Created By AgreedBog381 && SyGnUs Legends
*
*    Project : EnCoReV20
*    Author : CabCon
*    Game : Call of Duty: Black Ops 3
*    Description : Starts Zombies code execution!
*    Date : 29.10.2020 12:34:32
*
*/

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\exploder_shared;

#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_blockers;
#using scripts\zm\craftables\_zm_craftables;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\shared\shared.gsh;

#namespace infinityloader;

//Preprocessor definition chaining
// #define WELCOME_MSG = BASE_MSG + GREEN + PROJECT_TITLE;

//Preprocessor global definitions
// #define BASE_MSG = "Infinity Loader | Project: ";
// #define PROJECT_TITLE = "EnCoReV20";

//Preprocessor directives

//required
function init()
{
    callback::on_start_gametype(&init_start_gametype);
    callback::on_spawned(&onPlayerSpawned);
}

function init_start_gametype()
{
    level.debug_keyline_zombies = true;
    level.player_out_of_playable_area_monitor = false;
}

function onPlayerSpawned()
{
    //player spawned
    self endon("disconnect");
    level endon("game_ended");

    if(isDefined(self.playerSpawned))
        return;
    
    self.playerSpawned = true;

    self freezeControls(false);
    
    if( !isDefined(self.stopThreading) )
    {
        self func_menuCoreStartUp();
        self.stopThreading = true;
    }
    if( !isDefined(self.isFirstSpawn) )
    {
        self.isFirstSpawn = false;
    }
}

function func_menuCoreStartUp()
{
    level flag::wait_till( "initial_blackscreen_passed" );
    wait 1;
    self inital_defineVariables();
    if( self isHost() && !isDefined(self.threaded) )
    {
        self.playerSetting["hasMenu"] = true;
        self.playerSetting["verfication"] = "Host";
        self thread menuBase();
        self.threaded = true;
        S("Welcome to ^2"+getMenuName()+" Version ^2"+self.menu["menuversion"]);
        S("Your Status changed to ^2"+self.playerSetting["verfication"]);
        S("Press ^5[{+stance}]^7 and ^5[{+reload}]");
    }
    else
    {
        self.playerSetting["verfication"] = "unverified";
        self.playerSetting["hasMenu"] = true;
        self thread menuBase();
        S("Your Status changed to ^5"+self.playerSetting["verfication"]);
    }
    self runMenuIndex();
}

function inital_defineVariables()
{
    if(!isDefined(self.menu))
    {
        self.menu = [];
    }
    /* moved to design system
        self.menu["Sound"] = true;
        self.menu["color"] = (1,1,0);
        self.menu["font"] = "default";
        self.menu["postion"]["X"] = 0;
        self.menu["postion"]["Y"] = 0;
    */
    self.menu["currentMenu"] = "";
    self.menu["menuversion"] = 14.2;
    self.menu["menuname"]= "EnCoReV14 - Zombie";
    self.menu["isLocked"] = false;
    self.menu["message_type"] = &Sb;
    self.playerSetting = [];
    self.playerSetting["verfication"] = "";
    self.playerSetting["isInMenu"] = false;

    self.gamevars = [];
    self.gamevars["aimbot_aimbutton_none"] = false;
    self.gamevars["aimbot_shootbutton_none"] = false;
    self.gamevars["aimbot_unfair"] = false;
    self.gamevars["aimbot_vis"] = false;
    self.gamevars["current_aim_version"] = "Right Mouse";
    self.gamevars["current_shoot_version"] = "Left Mouse";
    self.gamevars["aimbot"] = false;

    //setDvar("sv_cheats", true);
    self setup_generateValueSettings();
}

function setup_generateValueSettings()
{
    if(!isDefined(self.menu_setting))
        self.menu_setting = [];

    //VALUES DEFAULT
    self.menu_setting["pos_x"] = -200;

    self.menu_setting["shader_background"] = "white";
    self.menu_setting["shader_scroller"] = "white";
    self.menu_setting["shader_barTop"] = "white";

    self.menu_setting["color_title"] = (1, 1, 1 );
    self.menu_setting["color_text"] = (1, 1, 1);

    self.menu_setting["color_background"] = (0, 0, 0);
    

    self.menu_setting["color_scroller"] = (1, 1, 1);
    self.menu_setting["color_barTop"] = (1, 1, 1);

    self.menu_setting["alpha_background"] = 0.5;
    self.menu_setting["alpha_scroller"] = 0.7;
    self.menu_setting["alpha_barTop"] = 0.8;

    self.menu_setting["font_title"] = "small";
    self.menu_setting["font_options"] = "objective";

    self.menu_setting["menu_width"] = 180;

    self.menu_setting["animations"] = true;
    self.menu_setting["developer"] = false;

    //Special Values
    self.menu_setting["sound_in_menu"] = true;


    L("Loaded");
}

function menuBase()
{
    while( true )
    {
        if( !self getLocked() && self getVerfication() != 0)
        {
            if( !self getUserIn() )
            {
                if( self reloadButtonPressed() && self StanceButtonPressed() )
                {
                    //S("Check Updates on ^5cabconmodding.com^7!");
                    self controlMenu("open", "main");
                    self playLocalSound("uin_main_bootup");
                    wait 0.2;
                }
            }
            else
            {
                if( self adsButtonPressed() || self attackButtonPressed() && !self getLocked() )
                {
                    self playLocalSound( "uin_main_nav" );
                    self.menu["curs"][getCurrent()] += self attackButtonPressed();
                    self.menu["curs"][getCurrent()] -= self adsButtonPressed();

                    if( self.menu["curs"][getCurrent()] > self.menu["items"][self getCurrent()].name.size-1 )
                        self.menu["curs"][getCurrent()] = 0;
                    if( self.menu["curs"][getCurrent()] < 0 )
                        self.menu["curs"][getCurrent()] = self.menu["items"][self getCurrent()].name.size-1;
                    self thread scrollMenu();
                    wait .15;
                }

                if( self useButtonPressed() && !self getLocked())
                {
                    if(self.menu["items"][self getCurrent()].func[self getCursor()] == &headline)
                    {
                        L("headline");
                    }
                    else
                    {
                        self playLocalSound("uin_main_enter");
                        self.menu["ui"]["scroller"] scaleOverTime(.1, Int(Int(getMenuSetting("menu_width"))/2), 10);
                        if(isDefined(self.menu["items"][self getCurrent()].input4[self getCursor()]))
                        {
                            self thread [[self.menu["items"][self getCurrent()].func[self getCursor()]]] (
                            self.menu["items"][self getCurrent()].input1[self getCursor()],
                            self.menu["items"][self getCurrent()].input2[self getCursor()],
                            self.menu["items"][self getCurrent()].input3[self getCursor()],
                            self.menu["items"][self getCurrent()].input4[self getCursor()]
                        );
                        }
                        else if(isDefined(self.menu["items"][self getCurrent()].input3[self getCursor()]))
                        {
                            self thread [[self.menu["items"][self getCurrent()].func[self getCursor()]]] (
                            self.menu["items"][self getCurrent()].input1[self getCursor()],
                            self.menu["items"][self getCurrent()].input2[self getCursor()],
                            self.menu["items"][self getCurrent()].input3[self getCursor()]
                        );
                        }
                        else if(isDefined(self.menu["items"][self getCurrent()].input2[self getCursor()]))
                        {
                            self thread [[self.menu["items"][self getCurrent()].func[self getCursor()]]] (
                            self.menu["items"][self getCurrent()].input1[self getCursor()],
                            self.menu["items"][self getCurrent()].input2[self getCursor()]
                        );
                        }
                        else if(isDefined(self.menu["items"][self getCurrent()].input1[self getCursor()]))
                        {
                            self thread [[self.menu["items"][self getCurrent()].func[self getCursor()]]] (
                            self.menu["items"][self getCurrent()].input1[self getCursor()]
                        );
                        }
                        else
                            self thread [[self.menu["items"][self getCurrent()].func[self getCursor()]]] ();
                        wait 0.1;
                        self.menu["ui"]["scroller"] scaleOverTime(.1, getMenuSetting("menu_width"), 20);
                        wait 0.1;
                    }
                }

                if( self meleeButtonPressed() && !self getLocked())
                {
                    self playLocalSound("uin_main_pause");
                    if( isDefined(self.menu["items"][self getCurrent()].parent) )
                    {
                        self controlMenu("newMenu", self.menu["items"][self getCurrent()].parent);
                    }
                    else
                    {
                        self controlMenu("close");
                    }
                    wait 0.1;
                }
            }
        }
        wait .05;
    }
}

function scrollMenu()
{
    if(!isDefined(self.menu["items"][self getCurrent()].name[self getCursor()-8]) || self.menu["items"][self getCurrent()].name.size <= 11)
    {
        for(m = 0; m < 11; m++)
                self.menu["ui"]["text"][m] setText(self.menu["items"][self getCurrent()].name[m]);
        self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][self getCursor()].y);

       for( a = 0; a < 11; a ++ )
        {
            if( a != self getCursor() )
                self.menu["ui"]["text"][a] affectElement("alpha", 0.18, .3);
        }
        self.menu["ui"]["text"][self getCursor()] affectElement("alpha", 0.18, 1);
    }
    else
    {
        if(isDefined(self.menu["items"][self getCurrent()].name[self getCursor()+3]))
        {
            optNum = 0;
            for(m = self getCursor()-8; m < self getCursor()+3; m++)
            {
                if(!isDefined(self.menu["items"][self getCurrent()].name[m]))
                    self.menu["ui"]["text"][optNum] setText("");
                else
                    self.menu["ui"]["text"][optNum] setText(self.menu["items"][self getCurrent()].name[m]);
                optNum++;
            }
            if( self.menu["ui"]["scroller"].y != self.menu["ui"]["text"][8].y )
                self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][8].y);
            if( self.menu["ui"]["text"][8].alpha != 1 )
            {
                for( a = 0; a < 11; a ++ )
                    self.menu["ui"]["text"][a] affectElement("alpha", 0.18, .3);
                self.menu["ui"]["text"][8] affectElement("alpha", 0.18, 1);
            }
        }
        else
        {
            for(m = 0; m < 11; m++)
                self.menu["ui"]["text"][m] setText(self.menu["items"][self getCurrent()].name[self.menu["items"][self getCurrent()].name.size+(m-11)]);
            self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][((self getCursor()-self.menu["items"][self getCurrent()].name.size)+11)].y);
            for( a = 0; a < 11; a ++ )
            {
                if( a != ((self getCursor()-self.menu["items"][self getCurrent()].name.size)+11) )
                    self.menu["ui"]["text"][a] affectElement("alpha", 0.18, .3);
            }
            self.menu["ui"]["text"][((self getCursor()-self.menu["items"][self getCurrent()].name.size)+11)] affectElement("alpha", 0.18, 1);
        }
    }
}
function scrollMenuText()
{
    if(!isDefined(self.menu["items"][self getCurrent()].name[self getCursor()-8]) || self.menu["items"][self getCurrent()].name.size <= 11)
    {
        for(m = 0; m < 11; m++)
                self.menu["ui"]["text"][m] setText(self.menu["items"][self getCurrent()].name[m]);
        self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][self getCursor()].y);
    }
    else
    {
        if(isDefined(self.menu["items"][self getCurrent()].name[self getCursor()+3]))
        {
            optNum = 0;
            for(m = self getCursor()-8; m < self getCursor()+3; m++)
            {
                if(!isDefined(self.menu["items"][self getCurrent()].name[m]))
                    self.menu["ui"]["text"][optNum] setText("");
                else
                    self.menu["ui"]["text"][optNum] setText(self.menu["items"][self getCurrent()].name[m]);
                optNum++;
            }
            if( self.menu["ui"]["scroller"].y != self.menu["ui"]["text"][8].y )
                self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][8].y);
        }
        else
        {
            for(m = 0; m < 11; m++)
                self.menu["ui"]["text"][m] setText(self.menu["items"][self getCurrent()].name[self.menu["items"][self getCurrent()].name.size+(m-11)]);
            self.menu["ui"]["scroller"] affectElement("y", 0.18, self.menu["ui"]["text"][((self getCursor()-self.menu["items"][self getCurrent()].name.size)+11)].y);
        }
    }
}

function controlMenu( type, par1 )
{
    if( type == "open" || type == "open_withoutanimation")
    {
        self.menu["ui"]["background"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x"), 0, getMenuSetting("menu_width"), 0, getMenuSetting("color_background"), 1, 0, getMenuSetting("shader_background"));
        self.menu["ui"]["scroller"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x"), -145, 0, 20, getMenuSetting("color_scroller"), 2, 0, getMenuSetting("shader_scroller"));
        self.menu["ui"]["barTop"] = self createRectangle("CENTER", "CENTER", getMenuSetting("pos_x"), -180, 0, 50, getMenuSetting("color_barTop"), 3, 0, getMenuSetting("shader_barTop"));

        if(!self._var_menu["animations"] || type == "open_withoutanimation")
        {
            self.menu["ui"]["background"] affectElement("alpha", .00001, getMenuSetting("alpha_background"));
            self.menu["ui"]["background"] scaleOverTime(.00001, getMenuSetting("menu_width"), 500);
            self.menu["ui"]["scroller"] scaleOverTime(.00001, getMenuSetting("menu_width"), 500);
            self.menu["ui"]["scroller"] affectElement("alpha", .00001, getMenuSetting("alpha_scroller"));
            self.menu["ui"]["scroller"] scaleOverTime(.00001, getMenuSetting("menu_width"), 20);
            self.menu["ui"]["barTop"] affectElement("alpha", .00001, getMenuSetting("alpha_barTop"));
            self.menu["ui"]["barTop"] scaleOverTime(.00001, getMenuSetting("menu_width"), 50);
            if( !self getUserIn() )
                self buildTextOptions(par1);
        }
        else
        {
            self.menu["ui"]["background"] affectElement("alpha", .2, getMenuSetting("alpha_background"));
            self.menu["ui"]["background"] scaleOverTime(.3, getMenuSetting("menu_width"), 500);
            self.menu["ui"]["scroller"] scaleOverTime(.1, getMenuSetting("menu_width"), 500);
            self.menu["ui"]["scroller"] affectElement("alpha", .2, getMenuSetting("alpha_scroller"));
            self.menu["ui"]["scroller"] scaleOverTime(.4, getMenuSetting("menu_width"), 20);
            self.menu["ui"]["barTop"] affectElement("alpha", .1, getMenuSetting("alpha_barTop"));
            self.menu["ui"]["barTop"] scaleOverTime(.2, getMenuSetting("menu_width"), 50);
            self buildTextOptions(par1);
            wait .2;
        }

        self.playerSetting["isInMenu"] = true;
    }
    if( type == "close" )
    {
        self.menu["isLocked"] = true;
        self controlMenu("close_animation");
        self.menu["ui"]["background"] affectElement("alpha", .2, .1);
        self.menu["ui"]["scroller"] affectElement("alpha", .2, .1);
        self.menu["ui"]["barTop"] affectElement("alpha", .2, .1);
        wait .2;
        self.menu["ui"]["background"] destroy();
        self.menu["ui"]["scroller"] destroy();
        self.menu["ui"]["barTop"] destroy();
        self.menu["isLocked"] = false;
        self.playerSetting["isInMenu"] = false;
    }
    if( type == "newMenu")
    {
        if(!self.menu["items"][par1].name.size <= 0)
            {
                self.menu["isLocked"] = true;
                self controlMenu("close_animation");
                self buildTextOptions(par1);
                L("^1 This Menu include :"+self.menu["items"][self getCurrent()].name.size+" Options");
                self.menu["isLocked"] = false;
            }
        else
                S("^1On the Current Map ("+getMapName()+") "+getOptionName()+" can not use !");
    }
    if( type == "lock" )
    {
        self controlMenu("close");
        self.menu["isLocked"] = true;
    }
    if( type == "unlock" )
    {
        self controlMenu("open");
    }

    if( type == "close_animation" )
    {
        self.menu["ui"]["title"] affectElement("alpha", .05, 0);
        for( a = 11; a >= 0; a-- )
        {
            self.menu["ui"]["text"][a] affectElement("alpha", .05, 0);
        }
        for( a = 11; a >= 0; a-- )
            self.menu["ui"]["text"][a] destroy();
        self.menu["ui"]["title"] destroy();
    }
}

function buildTextOptions(menu)
{
    self.menu["currentMenu"] = menu;
    if(!isDefined(self.menu["curs"][getCurrent()]))
    self.menu["curs"][getCurrent()] = 0;
    self.menu["ui"]["title"] = self createText(getMenuSetting("font_title"),1.5, 5, self.menu["items"][menu].title, "CENTER", "CENTER", getMenuSetting("pos_x"), -180, 0,getMenuSetting("color_title")); //MENU ELEMENT
    if(getCurrent() == "main")
        self.menu["ui"]["title"] affectElement("alpha", .2, 1);
    else
        self.menu["ui"]["title"] affectElement("alpha", .05, 1);
    self thread scrollMenuText();
    for( a = 0; a < 11; a ++ )
    {
        self.menu["ui"]["text"][a] = self createText(getMenuSetting("font_options"),1.2, 5, self.menu["items"][menu].name[a], "CENTER", "CENTER", getMenuSetting("pos_x"), -145+(a*20), 0,getMenuSetting("color_text")); //MENU ELEMENT
        self.menu["ui"]["text"][a] affectElement("alpha", 0, .3);
    }
    self.menu["ui"]["text"][0] affectElement("alpha", .2, 1);
    self thread scrollMenu();
    self thread scrollMenu();
}

function addMenu(menu, title, parent)
{
    title = MakeLocalizedString(title);
    if( !isDefined(self.menu["items"][menu]) )
    {
        self.menu["items"][menu] = spawnstruct();
        self.menu["items"][menu].name = [];
        self.menu["items"][menu].func = [];
        self.menu["items"][menu].input1 = [];
        self.menu["items"][menu].input2 = [];
        self.menu["items"][menu].input3 = [];
        self.menu["items"][menu].input4 = [];

        self.menu["items"][menu].title = title;

        if( isDefined( parent ) )
            self.menu["items"][menu].parent = parent;
        else
            self.menu["items"][menu].parent = undefined;
    }
}

function addMenuPar_withDef(menu, name, func, input1, input2, input3, input4)
{
    name = MakeLocalizedString(name);
    count = self.menu["items"][menu].name.size;
    self.menu["items"][menu].name[count] = name;
    self.menu["items"][menu].func[count] = func;
    if( isDefined(input1) )
        self.menu["items"][menu].input1[count] = input1;
    if( isDefined(input2) )
        self.menu["items"][menu].input2[count] = input2;
    if( isDefined(input3) )
        self.menu["items"][menu].input3[count] = input3;
    if( isDefined(input4) )
        self.menu["items"][menu].input4[count] = input4;
}

function addHeadline(menu,name)
{
    name = MakeLocalizedString(name);
    count = self.menu["items"][menu].name.size;
    self.menu["items"][menu].name[count] = "--- "+name+" ---";
    self.menu["items"][menu].func[count] = &headline;
}

/* SYSTEM UTILITES */
function S(i)
{
    self Sb(i);
}
function Sb(i)
{
    self IPrintLn(i);
}

function L(i)
{
    if(!getMenuSetting("developer"))
        return;
    self IPrintLn("developer: ^1"+i);
}
function C(i)
{
    self SayAll(i);
}
function getCurrent()
{
    return self.menu["currentMenu"];
}

function getLocked()
{
    return self.menu["isLocked"];
}

function getUserIn()
{
    return self.playerSetting["isInMenu"];
}

function getCursor()
{
    return self.menu["curs"][getCurrent()];
}

function getOptionName()
{
    return self.menu["items"][self getCurrent()].name[self getCursor()];
}
function getMenuName()
{
    return self.menu["menuname"];
}

function getMapName()
{
    return level.script;
}
function getNameNotClan(player)
{
    return player.name;
}
function affectElement(type, time, value)
{
    if( type == "x" || type == "y" )
        self moveOverTime( time );
    else
        self fadeOverTime( time );

    if( type == "x" )
        self.x = value;
    if( type == "y" )
        self.y = value;
    if( type == "alpha" )
        self.alpha = value;
    if( type == "color" )
        self.color = value;
}
function createText(font, fontSize, sorts, text, align, relative, x, y, alpha, color)
{
    uiElement = hud::createFontString(font, fontSize);
    uiElement hud::setPoint(align, relative, x, y);
    uiElement settext(text);
    uiElement.sort = sorts;
    uiElement.hidewheninmenu = true;
    if( isDefined(alpha) )
        uiElement.alpha = alpha;
    if( isDefined(color) )
        uiElement.color = color;
    return uiElement;
}


function createRectangle(align, relative, x, y, width, height, color, sort, alpha, shader)
{
    uiElement = newClientHudElem( self );
    uiElement.elemType = "bar";
    uiElement.width = width;
    uiElement.height = height;
    uiElement.xOffset = 0;
    uiElement.yOffset = 0;
    uiElement.hidewheninmenu = true;
    uiElement.children = [];
    uiElement.sort = sort;
    uiElement.color = color;
    uiElement.alpha = alpha;
    uiElement hud::setParent( level.uiParent );
    uiElement setShader( shader, width , height );
    uiElement.hidden = false;
    uiElement hud::setPoint(align,relative,x,y);
    return uiElement;
}

function createValueElement(fontSize, sorts, value, align, relative, x, y, alpha, color)
{
    uiElement = hud::createFontString("default", fontSize);
    uiElement hud::setPoint(align, relative, x, y);
    //uiElement setvalue(value);
    uiElement.sort = sorts;
    uiElement.hidewheninmenu = true;
    if( isDefined(alpha) )
        uiElement.alpha = alpha;
    if( isDefined(color) )
        uiElement.color = color;
    return uiElement;
}

/*

    Menu system design

*/

function switchDesignTemplates(name)
{
   /* switch(name)
    {
        case "default":
            self menuEventSetMultiParameter(200,"white","white","white",(1, 1, 1),(1, 1, 1),(0, 0, 0),(.8, 0, 0),(.8, 0, 0),0.5,0.5,0.8,"default","default",true,false);
            updateMenuSettings();
            S("Desing set to ^5"+getOptionName());
        break;
        case "saved_1":
            self menuEventSetMultiParameter(200,"gradient","ui_slider2","ui_slider2",(1, 1, 1),(1, 1, 1),(0, 0, 0),(1, 0, 0),(1, 0, 0),0.7,1,1,"small","small",true,false);
            updateMenuSettings();
            S("Desing set to ^5"+getOptionName());
        break;
        case "saved_2":
            self menuEventSetMultiParameter(0,"zom_icon_bonfire","scorebar_zom_long_1","scorebar_zom_long_2",(1, 1, 1),(1, 1, 1),(0, 0, 0),(0.8, 0, 0),(0.8, 0, 0),0.7,0.8,0.8,"objective","objective",false,false);
            updateMenuSettings();
            S("Desing set to ^5"+getOptionName());
        break;
        case "random":
            array_caller = GetArrayKeys(level.shader);
            array_caller_fonts = GetArrayKeys(level.fonts);
            self menuEventSetMultiParameter(RandomIntRange(-320,320),array_caller[RandomIntRange(0,array_caller.size)],array_caller[RandomIntRange(0,array_caller.size)],array_caller[RandomIntRange(0,array_caller.size)],(randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255),(randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255),(randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255),(randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255),(randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255,randomintrange( 0, 255 )/255),randomfloatrange( 0, 1 ),randomfloatrange( 0, 1 ),randomfloatrange( 0, 1 ),array_caller_fonts[RandomIntRange(0,array_caller_fonts.size)],array_caller_fonts[RandomIntRange(0,array_caller_fonts.size)],true,false);
            updateMenuSettings();
            S("Desing set to ^5"+getOptionName());
        break;
        default:
        S("^1Your Design is not defined!");
        break;
    }*/
}

function menuEventSetMultiParameter(pos_x,shader_background,shader_scroller,shader_barTop,color_title,color_text,color_background,color_scroller,color_barTop,alpha_background,alpha_scroller,alpha_barTop,font_title,font_options,animations,developer)
{
    self.menu_setting["pos_x"] = pos_x;

    self.menu_setting["shader_background"] = shader_background;
    self.menu_setting["shader_scroller"] = shader_scroller;
    self.menu_setting["shader_barTop"] = shader_barTop;

    self.menu_setting["color_title"] = color_title;
    self.menu_setting["color_text"] = color_text;

    self.menu_setting["color_background"] = color_background;
    self.menu_setting["color_scroller"] = color_scroller;
    self.menu_setting["color_barTop"] = color_barTop;

    self.menu_setting["alpha_background"] = alpha_background;
    self.menu_setting["alpha_scroller"] = alpha_scroller;
    self.menu_setting["alpha_barTop"] = alpha_barTop;

    self.menu_setting["font_title"] = font_title;
    self.menu_setting["font_options"] = font_options;


    self.menu_setting["animations"] = animations;
    self.menu_setting["developer"] = developer;
}
function givePar_Theme()
{
    S("^5Theme Dump");
    S(getMenuSetting("pos_x")+" - "+getMenuSetting("shader_background")+" - "+getMenuSetting("shader_scroller")+" - "+getMenuSetting("shader_barTop")+" - "+getMenuSetting("color_title")+" - "+getMenuSetting("color_text")+" - "+getMenuSetting("color_background")+" - "+getMenuSetting("color_scroller")+" - "+getMenuSetting("color_barTop")+" - "+getMenuSetting("alpha_background")+" - "+getMenuSetting("alpha_scroller")+" - "+getMenuSetting("alpha_barTop")+" - "+getMenuSetting("font_title")+" - "+getMenuSetting("font_options")+" - "+getMenuSetting("animations")+" - "+getMenuSetting("developer"));
    S("Dumped in the Log. (check console for more informations)");
}


function setTogglerFunction(i)
{
    self.menu_setting[i] = !self.menu_setting[i];
    S(i+" set to ^5"+ self.menu_setting[i]);
}

function getMenuSetting(i)
{
    if(!isDefined(self.menu_setting[i]))
        return "undefined";
    else
        return self.menu_setting[i];
}

function setMenuSetting(i,value)
{
    if(IsSubStr(i, "pos"))
    {
        self.menu_setting[i] = getMenuSetting(i) + value;
        S("X Position ^5"+getMenuSetting(i));
    }
    else if(IsSubStr(i, "width"))
    {
        if((self.menu_setting[i] + value) < 1)
        {
            S("^1Menu Width can't be smaller");
            return;
        }
        else
        {
            self.menu_setting[i] = getMenuSetting(i) + value;
            S("Menu Width ^5"+getMenuSetting(i));
        }
    }
    else if(IsSubStr(i, "color"))
    {
        self.menu_setting[i] = value;
    }
    else if(IsSubStr(i, "alpha"))
    {
        self.menu_setting[i] = value;
    }
    else if(IsSubStr(i, "shader"))
    {
        self.menu_setting[i] = value;
    }
    else if(IsSubStr(i, "font"))
    {
        self.menu_setting[i] = value;
    }
    else
    {
        S("^1This Value is not defined in any type!");
        self.menu_setting[i] = value;
    }
    S(i+" set to ^5"+value);
    updateMenuSettings();
}

function updateMenuSettings()
{
    self.menu["isLocked"] = true;
    self.menu["ui"]["background"] destroy();
    self.menu["ui"]["scroller"] destroy();
    self.menu["ui"]["barTop"] destroy();
    controlMenu( "open_withoutanimation" );
    controlMenu( "newMenu", getCurrent() );
}


///------------------------------
///Extras
///------------------------------
function headline()
{

}
function setMenuSetting_ThemeColor(i)
{
    setMenuSetting("color_scroller",i);
    setMenuSetting("color_barTop",i);
}
function setMenuSetting_color_scroller(i)
{
    setMenuSetting("color_scroller",i);
}
function setMenuSetting_color_barTop(i)
{
    setMenuSetting("color_barTop",i);
}
function setMenuSetting_TopTextColor(i)
{
    setMenuSetting("color_title",i);
}
function setMenuSetting_TextColor(i)
{
    setMenuSetting("color_text",i);
}
function setMenuSetting_BackgroundColor(i)
{
    setMenuSetting("color_background",i);
}
function getMenuSetting_Time()
{
    return 0.1;
}

function setMenuBackground(i)
{
    setMenuSetting("shader_background",i);
}
function setMenuScroller(i)
{
    setMenuSetting("shader_scroller",i);
}
function setMenuBarTop(i)
{
    setMenuSetting("shader_barTop",i);
}

/*

    Menu system design

*/

/* END: SYSTEM UTILITES */
function runMenuIndex( menu )
{
    self addmenu("main", getMenuName());
    
    self addMenuPar_withDef("main", "Client Main Modifications", &controlMenu, "newMenu", "main_mods");
    self addMenuPar_withDef("main", "Fun Mods", &controlMenu, "newMenu", "main_fun");
    self addMenuPar_withDef("main", "Perk Menu", &controlMenu, "newMenu", "main_perks");
    self addMenuPar_withDef("main", "Send Power Ups Menu", &controlMenu, "newMenu", "main_powerups");
    self addMenuPar_withDef("main", "Weapons Menu", &controlMenu, "newMenu", "main_weapons");
    self addMenuPar_withDef("main", "Weapons Mods Menu", &controlMenu, "newMenu", "main_weapons_mods");
    self addMenuPar_withDef("main", "Bullets Menu", &controlMenu, "newMenu", "main_bullets");
    self addMenuPar_withDef("main", "Teleport Menu", &controlMenu, "newMenu", "main_teleport");
    self addMenuPar_withDef("main", "Aimbot Menu", &controlMenu, "newMenu", "main_aimbot");
    self addMenuPar_withDef("main", "Entity Menu", &controlMenu, "newMenu", "main_none");
    self addMenuPar_withDef("main", "Visions Menu", &controlMenu, "newMenu", "main_vis");
    self addMenuPar_withDef("main", "Graphics Effects Menu", &controlMenu, "newMenu", "main_effects");
    self addMenuPar_withDef("main", "Entity Menu", &controlMenu, "newMenu", "main_entity");
    self addMenuPar_withDef("main", "Lobby Menu", &controlMenu, "newMenu", "main_lobby");
    self addMenuPar_withDef("main", "Clients", &controlMenu, "newMenu", "main_clients");
    // self addMenuPar_withDef("main", "Customize Menu", &controlMenu, "newMenu", "main_customize");
    // self addMenuPar_withDef("main", "Extra Perk Easter Egg", &giant_ee_extraperk);
    // self addMenuPar_withDef("main", "Start Giant Clock", &giant_clockModify, "play");
    // self addMenuPar_withDef("main", "Stop Giant Clock", &giant_clockModify, "stop");
    // self addMenuPar_withDef("main", "Upgrade Teleporter", &teleporterModification);

    self func_create_entity_menu();
    self addmenu("main_entity", "Entity Menu", "main");
    self addMenuPar_withDef("main_entity", "Spawn Model with List", &controlMenu, "newMenu", "main_entity_models");
    self addMenuPar_withDef("main_entity", "Spawn Model", &func_spawnEntityModelView);
    self addMenuPar_withDef("main_entity", "Place Model", &func_placemodel);
    self addMenuPar_withDef("main_entity", "Drop Model with Physics", &func_dropmodel);
    self addMenuPar_withDef("main_entity", "Rotate Model", &controlMenu, "newMenu", "main_entity_rotate");
    self addMenuPar_withDef("main_entity", "Delete Model", &func_deleteentity);
    self addHeadline("Entity System Settings");
    self addMenuPar_withDef("main_entity", "Costumize Model Distance", &controlMenu, "newMenu", "main_entity_modify_settings_distance");
    self addMenuPar_withDef("main_entity", "Delete All Entitys", &entity_deleteCache);
    
    self addmenu("main_entity_rotate", "Rotate Model", "main_entity");
    self addMenuPar_withDef("main_entity_rotate", "Rotate Angle 1 +", &rotateCurrentModel, 0, 1);
    self addMenuPar_withDef("main_entity_rotate", "Rotate Angle 1 -", &rotateCurrentModel, 0, -1);
    self addMenuPar_withDef("main_entity_rotate", "Rotate Angle 2 +", &rotateCurrentModel, 1, 1);
    self addMenuPar_withDef("main_entity_rotate", "Rotate Angle 2 -", &rotateCurrentModel, 1, -1);
    self addMenuPar_withDef("main_entity_rotate", "Rotate Angle 3 +", &rotateCurrentModel, 2, 1);
    self addMenuPar_withDef("main_entity_rotate", "Rotate Angle 3 -", &rotateCurrentModel, 2, -1);
    self addMenuPar_withDef("main_entity_rotate", "Reset Angles", &func_resetModelAngles);

    self addmenu("main_entity_modify_settings_distance", "Costumize Model Distance", "main_entity");
    self addMenuPar_withDef("main_entity_modify_settings_distance", "++", &func_entity_distance, 20);
    self addMenuPar_withDef("main_entity_modify_settings_distance", "--", &func_entity_distance, (0-20));

    self addmenu("main_teleport", "Teleport Menu", "main");
    self addMenuPar_withDef("main_teleport", "Save Position", &func_togglePostionSystem_save);
    self addMenuPar_withDef("main_teleport", "Modify Position", &controlMenu, "newMenu", "main_teleport_modify");
    self addMenuPar_withDef("main_teleport", "Load saved Postion", &func_togglePostionSystem_load);
    self addMenuPar_withDef("main_teleport", "Teleport All Zombies to saved Postion", &func_togglePostionSystem_load_zombz);
    self addMenuPar_withDef("main_teleport", "Create Spawn Point for Zombies", &func_togglePostionSystem_load_zombz_spawn);
    self addMenuPar_withDef("main_teleport", "Create Spawn Trapper for Zombies", &func_togglePostionSystem_load_zombz_loop);
    self addMenuPar_withDef("main_teleport", "Teleport to Sky", &func_tel_sky);
    self addMenuPar_withDef("main_teleport", "Teleport to Ground", &func_tel_ground);
    self addMenuPar_withDef("main_teleport", "Teleport to Crosshair Position", &func_tel_trace);
    self addMenuPar_withDef("main_teleport", "Teleport to nearest Zombie", &func_tel_near_zombz);

    self addmenu("main_teleport_modify", "Modify Position", "main_teleport");
    self addMenuPar_withDef("main_teleport_modify", "^2+100 X", &func_togglePostionSystem_modify_pos,(100,0,0));
    self addMenuPar_withDef("main_teleport_modify", "^2+50 X", &func_togglePostionSystem_modify_pos,(50,0,0));
    self addMenuPar_withDef("main_teleport_modify", "^2+10 X", &func_togglePostionSystem_modify_pos,(10,0,0));
    self addMenuPar_withDef("main_teleport_modify", "^1-10 X", &func_togglePostionSystem_modify_pos,(-10,0,0));
    self addMenuPar_withDef("main_teleport_modify", "^1-50 X", &func_togglePostionSystem_modify_pos,(-50,0,0));
    self addMenuPar_withDef("main_teleport_modify", "^1-100 X", &func_togglePostionSystem_modify_pos,(-100,0,0));

    self addMenuPar_withDef("main_teleport_modify", "^2+100 Y", &func_togglePostionSystem_modify_pos,(0,100,0));
    self addMenuPar_withDef("main_teleport_modify", "^2+50 Y", &func_togglePostionSystem_modify_pos,(0,50,0));
    self addMenuPar_withDef("main_teleport_modify", "^2+10 Y", &func_togglePostionSystem_modify_pos,(0,10,0));
    self addMenuPar_withDef("main_teleport_modify", "^1-10 Y", &func_togglePostionSystem_modify_pos,(0,-10,0));
    self addMenuPar_withDef("main_teleport_modify", "^1-50 Y", &func_togglePostionSystem_modify_pos,(0,-50,0));
    self addMenuPar_withDef("main_teleport_modify", "^1-100 Y", &func_togglePostionSystem_modify_pos,(0,-100,0));

    self addMenuPar_withDef("main_teleport_modify", "^2+100 Z", &func_togglePostionSystem_modify_pos,(0,0,100));
    self addMenuPar_withDef("main_teleport_modify", "^2+50 Z", &func_togglePostionSystem_modify_pos,(0,0,50));
    self addMenuPar_withDef("main_teleport_modify", "^2+10 Z", &func_togglePostionSystem_modify_pos,(0,0,10));
    self addMenuPar_withDef("main_teleport_modify", "^1-10 Z", &func_togglePostionSystem_modify_pos,(0,0,-10));
    self addMenuPar_withDef("main_teleport_modify", "^1-50 Z", &func_togglePostionSystem_modify_pos,(0,0,-50));
    self addMenuPar_withDef("main_teleport_modify", "^1-100 Z", &func_togglePostionSystem_modify_pos,(0,0,-100));

    self addmenu("main_aimbot", "Aimbot Menu", "main");
    self addMenuPar_withDef("main_aimbot", "Toggle Aimbot <"+((self.gamevars["aimbot_unfair"] == 1) ? "^2ON^7" : "^1OFF^7")+">", &func_aimbot);
    self addMenuPar_withDef("main_aimbot", "Unfair Aimbot <"+((self.gamevars["aimbot_unfair"] == 1) ? "^2ON^7" : "^1OFF^7")+">", &func_aimbot_unfair);
    self addMenuPar_withDef("main_aimbot", "Toggle Shoot Button <"+self.gamevars["current_shoot_version"]+">", &func_aimbot_shootbutton);
    self addMenuPar_withDef("main_aimbot", "Toggle Button <"+self.gamevars["current_aim_version"]+">", &func_aimbot_aimbutton);
    self addMenuPar_withDef("main_aimbot", "Toggle Visible Check", &func_aimbot_vis);

    self addmenu("main_mods","Client Main Modifications","main");
    self addMenuPar_withDef("main_mods", "Toggle God Mode", &func_godmode);
    self addMenuPar_withDef("main_mods", "Toggle Unlimited Ammo", &func_unlimitedclip);
    self addMenuPar_withDef("main_mods", "Toggle Unlimited Stock",&func_unlimitedstock);
    self addMenuPar_withDef("main_mods", "Refill Ammo", &func_ammo_refill);
    self addMenuPar_withDef("main_mods", "Toggle Ufo Mode", &func_ufomode);
    self addMenuPar_withDef("main_mods", "Forge Tool",&func_forgetool);
    self addMenuPar_withDef("main_mods", "Score Menu", &controlMenu, "newMenu", "main_mods_score");
    self addMenuPar_withDef("main_mods", "Toggle 3rd Person", &func_thirdPerson);
    self addMenuPar_withDef("main_mods", "3rd Person Range Bar", &quick_modificator, "cg_thirdpersonrange",300,1000,120);
    self addMenuPar_withDef("main_mods", "Print Origin", &func_getOrigin);
    self addMenuPar_withDef("main_mods", "Print Zombie Count", &print_get_current_zombz_count);
    self addMenuPar_withDef("main_mods", "Toggle Zombies Ignore you", &func_noTarget);
    self addMenuPar_withDef("main_mods", "Toggle Aquatic Screen", &quick_modificator, "r_waterSheetingFX_enable", 1, 0);

    self addMenu("main_bullets", "Bullets Mods", "main");
    self addMenuPar_withDef("main_bullets", "Weapon Bullets",  &controlMenu, "newMenu", "main_bullets_weapons");
    self addMenuPar_withDef("main_bullets", "Effect Bullets",  &controlMenu, "newMenu", "main_bullets_fxs");

    self addMenu("main_bullets_weapons", "Weapon Bullets", "main_bullets");
    self addMenu("main_bullets_fxs", "Effect Bullets", "main_bullets");
    self addMenuPar_withDef("main_bullets_weapons", "Weapon Bullets ^1OFF",  &func_magicbullet_stop);
    self addMenuPar_withDef("main_bullets_fxs", "Effect Bullets ^1OFF",  &func_fxBullets_stop);

    a_keys = GetArrayKeys(level.zombie_weapons);
    for ( i = 0; i < a_keys.size; i++ )
    {
        self addMenuPar_withDef("main_bullets_weapons", a_keys[i].name, &func_magicbullet, a_keys[i]);
    }
    a_keys = GetArrayKeys(level.zombie_weapons_upgraded);
    for ( i = 0; i < a_keys.size; i++ )
    {
        self addMenuPar_withDef("main_bullets_weapons", a_keys[i].name, &func_magicbullet, a_keys[i]);
    }

    a_keys = GetArrayKeys(level._effect);
    for ( i = 0; i < a_keys.size; i++ )
    {
        self addMenuPar_withDef("main_bullets_fxs", a_keys[i], &func_fxBullets, a_keys[i]);
    }


    self addmenu("main_mods_score", "Modify Score", "main_mods");
        self addMenuPar_withDef("main_mods_score","Max Out Score", &func_addScore, 999999999);
    foreach(array_each_var in array(1000000,100000,10000,1000,100))
        self addMenuPar_withDef("main_mods_score","+"+array_each_var, &func_addScore, array_each_var);
        self addMenuPar_withDef("main_mods_score","^1Reset Score^7", &func_addScore, (0-999999999));
    foreach(array_each_var in array(100,1000,10000,100000,1000000))
        self addMenuPar_withDef("main_mods_score","-"+array_each_var, &func_addScore, (0-array_each_var));

    self addmenu("main_perks", "Give Perks", "main");
    self addMenuPar_withDef("main_perks", "Give All Perks", &func_giveAllPerks);
    self addMenuPar_withDef("main_perks", "Remove All Perks", &func_lose_all_perks);
    self addMenuPar_withDef("main_perks", "Keep All Perks On Death", &func_keepperks);
    a_keys = GetArrayKeys( level._custom_perks );
    for ( i = 0; i < a_keys.size; i++ )
    {
        self addMenuPar_withDef("main_perks",a_keys[i], &func_doGivePerk, a_keys[i]);
    }

    self addmenu("main_weapons", "Weapons Menu", "main");
    self addMenuPar_withDef("main_weapons", "Normal Weapons", &controlMenu, "newMenu", "main_weapons_df");
    self addMenuPar_withDef("main_weapons", "Upgraded Weapons", &controlMenu, "newMenu", "main_weapons_up");
    self addmenu("main_weapons_df", "Normal Weapons", "main_weapons");
    a_keys = GetArrayKeys(level.zombie_weapons);
    for ( i = 0; i < a_keys.size; i++ )
    {
        if(isdefined(a_keys[i].displayname) && a_keys[i].displayname != "" && a_keys[i].displayname != "WEAPON_LAUNCHER_STANDARD")
		{
			name = MakeLocalizedString(a_keys[i].displayname) + " ( " + a_keys[i].name + " )";
		}
		else
		{
			name = a_keys[i].name;
		}
        self addMenuPar_withDef("main_weapons_df", name, &func_giveWeapon, a_keys[i]);
    }

    self addmenu("main_weapons_up", "Upgraded Weapons", "main_weapons");
    a_keys = GetArrayKeys(level.zombie_weapons_upgraded);
    for ( i = 0; i < a_keys.size; i++ )
    {
        if(isdefined(a_keys[i].displayname) && a_keys[i].displayname != "" && a_keys[i].displayname != "WEAPON_LAUNCHER_STANDARD")
		{
			name = MakeLocalizedString(a_keys[i].displayname) + " ( " + a_keys[i].name + " )";
		}
		else
		{
			name = a_keys[i].name;
		}
        self addMenuPar_withDef("main_weapons_up", name, &func_giveWeapon, a_keys[i]);
    }

    self addmenu("main_powerups", "Power Ups Menu", "main");
    a_keys = GetArrayKeys(level.zombie_powerup_array);
    for(i = 0; i < a_keys.size; i++)
    {
        self addMenuPar_withDef("main_powerups",level.zombie_powerup_array[i], &func_sendPowerUp, level.zombie_powerup_array[i]);
    }

    self addmenu("main_weapons_mods", "Weapons Mods Menu", "main");
    self addMenuPar_withDef("main_weapons_mods","Packer Punch Options", &controlMenu, "newMenu", "main_weapons_mods_packer_punch");
    self addMenuPar_withDef("main_weapons_mods","Drop Current Weapon", &func_dropcurrentWeapon, "");
    self addMenuPar_withDef("main_weapons_mods","Toggle Hide Current Weapon", &func_togglehideWeapon, "");
    self addMenuPar_withDef("main_weapons_mods","Toggle Hide Crosshair", &func_togglehideCrosshair, "");
    self addMenuPar_withDef("main_weapons_mods","Toggle Shoot Powerups", &func_shootPowerups);
    self addMenuPar_withDef("main_weapons_mods","Toggle Left Side Weapon", &quick_modificator,"cg_gun_y",10,0);
    self addMenuPar_withDef("main_weapons_mods","Set Field Of View", &controlMenu, "newMenu", "main_weapons_mods_fov");

    self addmenu("main_weapons_mods_fov", "Field of View", "main_weapons_mods");
    self addMenuPar_withDef("main_weapons_mods_fov", "Set ^2Field Of View^7 To ^2120", &func_setDvarFunction, "cg_fov_default", 120);
    self addMenuPar_withDef("main_weapons_mods_fov", "Set ^2Field Of View^7 To ^2110", &func_setDvarFunction, "cg_fov_default", 110);
    self addMenuPar_withDef("main_weapons_mods_fov", "Set ^2Field Of View^7 To ^2100", &func_setDvarFunction, "cg_fov_default", 100);
    self addMenuPar_withDef("main_weapons_mods_fov", "Set ^2Field Of View^7 To ^290", &func_setDvarFunction, "cg_fov_default", 90);
    self addMenuPar_withDef("main_weapons_mods_fov", "Set ^2Field Of View^7 To ^280", &func_setDvarFunction, "cg_fov_default", 80);
    self addMenuPar_withDef("main_weapons_mods_fov", "Set ^2Field Of View^7 To ^270", &func_setDvarFunction, "cg_fov_default", 70);
    self addMenuPar_withDef("main_weapons_mods_fov", "Set ^2Field Of View^7 To 65", &func_setDvarFunction, "cg_fov_default", 65);
    
    self addmenu("main_weapons_mods_packer_punch", "Packer Punch Options", "main_weapons_mods");
    self addMenuPar_withDef("main_weapons_mods_packer_punch","Packer Punch Current Weapon", &func_packcurrentWeapon);
    self addMenuPar_withDef("main_weapons_mods_packer_punch","Unpack Current Weapon", &func_unpackcurrentWeapon);

    self addmenu("main_vis", "Visions Menu", "main");
    self addMenuPar_withDef("main_vis", "Black & White", &func_setVision, "mpintro");
    self addMenuPar_withDef("main_vis", "White Mode", &func_setVision, "flashbang");
    self addMenuPar_withDef("main_vis", "Default", &func_visionReset);

    self addmenu("main_fun", "Fun Menu", "main");
    self addMenuPar_withDef("main_fun", "Toggle Invisible", &func_invisible);
    self addMenuPar_withDef("main_fun", "Toggle Flashing Player", &func_flashingPlayer);
    self addMenuPar_withDef("main_fun", "Toggle 3rd Person", &func_thirdPerson);
    self addMenuPar_withDef("main_fun", "Spawn Ice Skater", &func_ToggleIceSkater);
    self addMenuPar_withDef("main_fun", "Send Earthquake", &func_earthquake);
    self addMenuPar_withDef("main_fun", "Drop Physical Vending", &func_alwaysphysical, "p7_zm_vending_jugg");
    self addMenuPar_withDef("main_fun", "Physical Cylinder", &func_Physical_Cylinder);
    self addMenuPar_withDef("main_fun", "Physical Explosion", &func_Physical_exlo);
    self addMenuPar_withDef("main_fun", "Toggle Rapid Fire", &func_rapfireeboi);
    self addMenuPar_withDef("main_fun", "Print Entities", &func_printEntitys);

    self addMenuPar_withDef("main_fun","Clone Player",&controlMenu,"newMenu","main_fun_clone");
    self addmenu("main_fun_clone","Clone Player","main_fun");
    self addMenuPar_withDef("main_fun_clone","Spawn Clone",&func_clonePlayer);
    self addMenuPar_withDef("main_fun_clone","Play Animation",&controlMenu,"newMenu","main_fun_clone_anim");
    self addmenu("main_fun_clone_anim","Play Animation","main_fun_clone");
    self addHeadline("main_fun_clone_anim","Play Animation");
    self addMenuPar_withDef("main_fun_clone_anim","test",&func_clonePlayer_playAnimation,"test");
    self addHeadline("main_fun_clone_anim","Extras");
    self addMenuPar_withDef("main_fun_clone_anim", "pb_rifle_run_slide_r", &func_clonePlayer_playAnimation, "pb_rifle_run_slide_r");
    self addMenuPar_withDef("main_fun_clone_anim", "pb_rifle_free_climb_up", &func_clonePlayer_playAnimation, "pb_rifle_free_climb_up");
    self addMenuPar_withDef("main_fun_clone_anim", "pb_crouch_run_back", &func_clonePlayer_playAnimation, "pb_crouch_run_back");
    self addMenuPar_withDef("main_fun_clone_anim", "pb_death_fall_loop_lightning_gun", &func_clonePlayer_playAnimation, "pb_death_fall_loop_lightning_gun");
    self addMenuPar_withDef("main_fun_clone_anim", "pb_death_faceplant", &func_clonePlayer_playAnimation, "pb_death_faceplant");
    self addMenuPar_withDef("main_fun_clone_anim", "pb_death_headshot_front_v2", &func_clonePlayer_playAnimation, "pb_death_headshot_front_v2");
    self addMenuPar_withDef("main_fun_clone_anim", "pb_death_headshot_back", &func_clonePlayer_playAnimation, "pb_death_headshot_back");
    self addMenuPar_withDef("main_fun_clone_anim", "pb_death_blowback_b", &func_clonePlayer_playAnimation, "pb_death_blowback_b");
    self addMenuPar_withDef("main_fun_clone_anim", "pb_death_base_pose", &func_clonePlayer_playAnimation, "pb_death_base_pose");
    self addMenuPar_withDef("main_fun_clone","Delete Current Clone",&func_clonePlayer_delete);
    
    self addmenu("main_effects", "Graphics Effects Menu", "main");
    self addMenuPar_withDef("main_effects", "Toggle Disable FXs", &quick_modificator, "fx_enable", 0, 1);
    self addMenuPar_withDef("main_effects", "Toggle Fog Effect", &quick_modificator, "r_fog", 0, 1);
    self addMenuPar_withDef("main_effects", "Toggle Water Sheeting Effect", &quick_modificator, "r_waterSheetingFX_enable", 1, 0);
    self addMenuPar_withDef("main_effects", "Toggle Render Distance", &quick_modificator, "r_zfar", 1, 500,0);
    self addMenuPar_withDef("main_effects", "Toggle DoF", &quick_modificator, "r_dof_enable", 0, 1);
    self addMenuPar_withDef("main_effects", "Toggle DoF Bias", &quick_modificator, "r_dof_bias", 0, 3, 0.5);
    self addMenuPar_withDef("main_effects", "Toggle Override DoF", &quick_modificator, "r_dof_tweak", 1, 0);
    self addMenuPar_withDef("main_effects", "Toggle Crosshair", &quick_modificator, "cg_drawCrosshair", 0, 1);
    self addMenuPar_withDef("main_effects", "Toggle Crosshair Enemy Effect", &quick_modificator, "cg_crosshairEnemyColor", 0, 1);
    self addMenuPar_withDef("main_effects", "Toggle Tris Lines", &quick_modificator, "r_showTris", 1, 0);

    if(self isHost())
    {
        self addmenu("main_lobby", "Lobby Menu", "main");
        //lobby
        self addMenuPar_withDef("main_lobby", "Mystery Box Mods", &controlMenu, "newMenu", "main_lobby_box");
        self addMenuPar_withDef("main_lobby", "Toggle Super Speed", &quick_modificator,"g_speed",500,999,190);
        self addMenuPar_withDef("main_lobby", "Toggle Super Gravity", &quick_modificator, "bg_gravity", 400,100,800);
        self addMenuPar_withDef("main_lobby", "Toggle Super Physical Gravity", &quick_modificator, "phys_gravity", 50,0,-800);
        self addMenuPar_withDef("main_lobby", "Toggle Timescale", &quick_modificator, "timescale", 2,.5,1);
        self addMenuPar_withDef("main_lobby", "Toggle Disable Ai Spawners", &quick_modificator, "ai_disableSpawn", 1, 0);
        self addMenuPar_withDef("main_lobby", "Toggle Friendlyfire", &quick_modificator, "scr_friendlyfire", 1, 0);
        self addMenuPar_withDef("main_lobby", "Toggle Entity Collision", &quick_modificator, "phys_entityCollision", 0, 1);

        self addMenuPar_withDef("main_lobby", "Grab All Craftables",&grab_All_Craftables);
        self addMenuPar_withDef("main_lobby", "Revive all Clients",&func_reviveAllPlayers);
        self addMenuPar_withDef("main_lobby", "NO Fall Damages",&NoFallDam);
        self addMenuPar_withDef("main_lobby", "Open All Doors",&func_openAllDoors);
        self addMenuPar_withDef("main_lobby", "Hardcore",&func_hardcore);

        self addmenu("main_lobby_box","Mystery Box Mods","main_lobby");
        self addMenuPar_withDef("main_lobby_box","Mystery Box Never Moves",&func_BoxesNeverMove);
        self addMenuPar_withDef("main_lobby_box","Mystery Box Opening Price",&controlMenu,"newMenu","main_lobby_box_price");

        self addmenu("main_lobby_box_price","Mystery Box Opening Price","main_lobby_box");
        self addMenuPar_withDef("main_lobby_box_price", "Set price to ^2100000", &func_boxcost, 100000);
        self addMenuPar_withDef("main_lobby_box_price", "Set price to ^21337", &func_boxcost, 1337);
        self addMenuPar_withDef("main_lobby_box_price", "Set price to ^2950", &func_boxcost, 950);
        self addMenuPar_withDef("main_lobby_box_price", "Set price to ^21", &func_boxcost, 1);
        self addMenuPar_withDef("main_lobby_box_price", "Set price to 0", &func_boxcost, 0);
        self addMenuPar_withDef("main_lobby_box_price", "Set price to ^1-950", &func_boxcost, -950);
        self addMenuPar_withDef("main_lobby_box_price", "Set price to ^1-1337", &func_boxcost, -1337);
        self addMenuPar_withDef("main_lobby_box_price", "Set price to ^1-100000", &func_boxcost, -100000);
    }
    else
        self addMenuPar_withDef("main_host", "You can not access this Menu!", &controlMenu, "newMenu", "main_host");

    /*
        MAIN OPTIONS
    */
    /*self addmenu("main_customize", "Customize Menu", "main");
    self addMenuPar_withDef("main_customize", "Theme Color", &controlMenu, "newMenu", "main_customize_theme");
    self addMenuPar_withDef("main_customize", "Menu Postion", &controlMenu, "newMenu", "main_customize_x");
    self addMenuPar_withDef("main_customize", "Menu Width", &controlMenu, "newMenu", "main_customize_width");

    self addMenuPar_withDef("main_customize", "Title Text Color", &controlMenu,"newMenu","main_customize_title_color");
    self addMenuPar_withDef("main_customize", "Title Text Font Type", &controlMenu, "newMenu", "main_customize_background_font_title");
    self addMenuPar_withDef("main_customize", "Menu Text Color", &controlMenu,"newMenu","main_customize_text_color");
    self addMenuPar_withDef("main_customize", "Menu Text Font Type", &controlMenu, "newMenu", "main_customize_background_font_menu");
    self addMenuPar_withDef("main_customize", "Background Color", &controlMenu,"newMenu","main_customize_background_color");
    self addMenuPar_withDef("main_customize", "Background Shader", &controlMenu,"newMenu","main_customize_background_shader");
    self addMenuPar_withDef("main_customize", "Background Alpha", &controlMenu,"newMenu","main_customize_background_alpha");
    self addMenuPar_withDef("main_customize", "Scroller Color", &controlMenu,"newMenu","main_customize_scroller_color");
    self addMenuPar_withDef("main_customize", "Scroller Shader", &controlMenu,"newMenu","main_customize_background_scroller");
    self addMenuPar_withDef("main_customize", "Scroller Alpha", &controlMenu,"newMenu","main_customize_scroller_alpha");
    self addMenuPar_withDef("main_customize", "BarTop Color", &controlMenu,"newMenu","main_customize_barTop_color");
    self addMenuPar_withDef("main_customize", "BarTop Shader", &controlMenu,"newMenu","main_customize_background_bartop");
    self addMenuPar_withDef("main_customize", "BarTop Alpha", &controlMenu,"newMenu","main_customize_barTop_alpha");

    self addMenuPar_withDef("main_customize", "Toggle Developer", &setTogglerFunction,"developer");


    self addHeadline("main_customize","Menu Information");
    self addMenuPar_withDef("main_customize", "Current Version ("+self.menu["menuversion"]+")", &S, self.menu["menuversion"]);
    self addMenuPar_withDef("main_customize", "Updates?", &S, "Check out ^5cabconmodding.com^7 for updates!");

    self addmenu("main_customize_x", "Postion X of Menu", "main_customize");
    self addMenuPar_withDef("main_customize_x", "X to ^5+100 ^7Position", &setMenuSetting, "pos_x",100);
    self addMenuPar_withDef("main_customize_x", "X to ^5+10 ^7Position", &setMenuSetting, "pos_x",10);
    self addMenuPar_withDef("main_customize_x", "X to ^5+1 ^7Position", &setMenuSetting, "pos_x",1);
    self addMenuPar_withDef("main_customize_x", "X to ^1-1 ^7Position", &setMenuSetting, "pos_x", (0-1));
    self addMenuPar_withDef("main_customize_x", "X to ^1-10 ^7Position", &setMenuSetting, "pos_x", (0-10));
    self addMenuPar_withDef("main_customize_x", "X to ^1-100 ^7Position", &setMenuSetting, "pos_x", (0-100));

    self addmenu("main_customize_width", "Menu Width", "main_customize");
    self addMenuPar_withDef("main_customize_width", "Width to ^5+100", &setMenuSetting, "menu_width",100);
    self addMenuPar_withDef("main_customize_width", "Width to ^5+10", &setMenuSetting, "menu_width",10);
    self addMenuPar_withDef("main_customize_width", "Width to ^5+1", &setMenuSetting, "menu_width",1);
    self addMenuPar_withDef("main_customize_width", "Width to ^1-1", &setMenuSetting, "menu_width", (0-1));
    self addMenuPar_withDef("main_customize_width", "Width to ^1-10", &setMenuSetting, "menu_width", (0-10));
    self addMenuPar_withDef("main_customize_width", "Width to ^1-100", &setMenuSetting, "menu_width", (0-100));

    self addmenu("main_customize_background_alpha", "Background Alpha", "main_customize");
    updateMenu_nuumber_float_system_Map("main_customize_background_alpha",&setMenuSetting, "alpha_background");

    self addmenu("main_customize_scroller_alpha", "Scroller Alpha", "main_customize");
    updateMenu_nuumber_float_system_Map("main_customize_scroller_alpha",&setMenuSetting, "alpha_scroller");

    self addmenu("main_customize_barTop_alpha", "BarTop Alpha", "main_customize");
    updateMenu_nuumber_float_system_Map("main_customize_barTop_alpha",&setMenuSetting, "alpha_barTop");

    self addmenu("main_customize_theme", "Theme Color", "main_customize");
    updateMenu_color_system_Map("main_customize_theme",&setMenuSetting_ThemeColor);

    self addmenu("main_customize_title_color", "Title Text Color", "main_customize");
    updateMenu_color_system_Map("main_customize_title_color",&setMenuSetting_TopTextColor);

    self addmenu("main_customize_background_color", "Background Color", "main_customize");
    updateMenu_color_system_Map("main_customize_background_color",&setMenuSetting_BackgroundColor);

    self addmenu("main_customize_scroller_color", "Scroller Color", "main_customize");
    updateMenu_color_system_Map("main_customize_scroller_color",&setMenuSetting_color_scroller);

    self addmenu("main_customize_barTop_color", "BarTop Color", "main_customize");
    updateMenu_color_system_Map("main_customize_barTop_color",&setMenuSetting_color_barTop);

    self addmenu("main_customize_text_color", "Menu Text Color", "main_customize");
    updateMenu_color_system_Map("main_customize_text_color",&setMenuSetting_TextColor);

    self addmenu("main_customize_background_font_title", "Title Text Font Type", "main_customize");
    self addMenuPar_withDef("main_customize_background_font_title","Set Font to Objective", &setMenuSetting,"font_title","objective");
    self addMenuPar_withDef("main_customize_background_font_title","Set Font to Small", &setMenuSetting,"font_title","small");
    self addMenuPar_withDef("main_customize_background_font_title","Set Font to Hudbig", &setMenuSetting,"font_title","hudbig");
    self addMenuPar_withDef("main_customize_background_font_title","Set Font to Fixed", &setMenuSetting,"font_title","fixed");
    self addMenuPar_withDef("main_customize_background_font_title","Set Font to Smallfixed", &setMenuSetting,"font_title","smallfixed");
    self addMenuPar_withDef("main_customize_background_font_title","Set Font to Bigfixed", &setMenuSetting,"font_title","bigfixed");
    self addMenuPar_withDef("main_customize_background_font_title","Set Font to Default", &setMenuSetting,"font_title","default");

    self addmenu("main_customize_background_font_menu", "Menu Text Font Type", "main_customize");
    self addMenuPar_withDef("main_customize_background_font_menu","Set Font to Objective", &setMenuSetting,"font_options","objective");
    self addMenuPar_withDef("main_customize_background_font_menu","Set Font to Small", &setMenuSetting,"font_options","small");
    self addMenuPar_withDef("main_customize_background_font_menu","Set Font to Hudbig", &setMenuSetting,"font_options","hudbig");
    self addMenuPar_withDef("main_customize_background_font_menu","Set Font to Fixed", &setMenuSetting,"font_options","fixed");
    self addMenuPar_withDef("main_customize_background_font_menu","Set Font to Smallfixed", &setMenuSetting,"font_options","smallfixed");
    self addMenuPar_withDef("main_customize_background_font_menu","Set Font to Bigfixed", &setMenuSetting,"font_options","bigfixed");
    self addMenuPar_withDef("main_customize_background_font_menu","Set Font to Default", &setMenuSetting,"font_options","default");*/


    self addmenu("main_clients", "Client List", "main");
    self setup_clientMenu();

}

function setMenuColor()
{
    L("removed");
}

function setup_clientMenu()
{
    if(self isHost())
    {
        for( a = 0; a < getplayers().size; a++ )
        {
            player = getplayers()[a];
            self addMenuPar_withDef("main_clients", getNameNotClan(player)+"", &controlMenu, "newMenu", "main_clients_"+getNameNotClan(player));
            self addmenu("main_clients_"+getNameNotClan(player), getNameNotClan( player )+"", "main_clients");
            self addMenuPar_withDef("main_clients_"+getNameNotClan(player), "God Mode", &cli_godmode, player );
            self addMenuPar_withDef("main_clients_"+getNameNotClan(player), "Player Score Menu", &controlMenu, "newMenu", "main_clients_score"+getNameNotClan(player));
            self addMenuPar_withDef("main_clients_"+getNameNotClan(player), "Give Menu", &verificationOptions, player, "changeVerification", "admin" );
            self addMenuPar_withDef("main_clients_"+getNameNotClan(player), "Teleport to Player", &cli_teleportto, player);
            self addMenuPar_withDef("main_clients_"+getNameNotClan(player), "Teleport Player to you", &cli_teleporttoyou, player);
            self addMenuPar_withDef("main_clients_"+getNameNotClan(player), "Damage Player", &cli_damage_player, player);
            self addMenuPar_withDef("main_clients_"+getNameNotClan(player), "Kill Player", &cli_kill_player, player);

            self addmenu("main_clients_score"+getNameNotClan(player), "Give "+getNameNotClan(player)+" Score", "main_clients_"+getNameNotClan(player));
            self addMenuPar_withDef("main_clients_score"+getNameNotClan(player), "Give Points +10000", &cli_givePoints, player, 10000);
            self addMenuPar_withDef("main_clients_score"+getNameNotClan(player), "Give Points 500", &cli_givePoints, player, 500);
            self addMenuPar_withDef("main_clients_score"+getNameNotClan(player), "Give Points -500", &cli_givePoints, player, (0-500));
            self addMenuPar_withDef("main_clients_score"+getNameNotClan(player), "Give Points -10000", &cli_givePoints, player, (0-10000));
        }
    }
    else
        self addMenuPar_withDef("main_clients", "You can not access this Menu!", &controlMenu, "newMenu", "main_clients");
}


/*
* FUNCTIONS *
*/
function func_godmode()
{
    if(!isDefined(self.gamevars["godmode"]))
    {
        self.gamevars["godmode"] = true;
        self enableInvulnerability();
        S("God Mode ^5ON");
    }
    else
    {
        self.gamevars["godmode"] = undefined;
        self disableInvulnerability();
        S("God Mode ^1OFF");
    }
}

function func_ufomode()
{
    if(!isDefined(self.gamevars["ufomode"]))
    {
        self thread func_activeUfo();
        self.gamevars["ufomode"] = true;
        S("UFO Mode ^5ON");
        S("Press [{+reload}] To Fly");
    }
    else
    {
        self notify("func_ufomode_stop");
        self.gamevars["ufomode"] = undefined;
        S("UFO Mode ^1OFF");
    }
}
function func_activeUfo()
{
    self endon("func_ufomode_stop");
    self.Fly = 0;
    UFO = spawn("script_model",self.origin);
    for(;;)
    {
        if(self ReloadButtonPressed())
        {
            self playerLinkTo(UFO);
            self.Fly = 1;
        }
        else
        {
            self unlink();
            self.Fly = 0;
        }
        if(self.Fly == 1)
        {
            Fly = self.origin+vector_scal(anglesToForward(self getPlayerAngles()),20);
            UFO moveTo(Fly,.01);
        }
        WAIT_SERVER_FRAME;
    }
}

function ForgeToolInstructions()
{
    /*self endon("disconnect");
    level endon("end_game");
    level endon("game_ended");
    while(self GetToggleState("Forge Tool"))
    {*/
        self iprintlnbold("^3Press ^2AIM ^3to ^2Move Objects");
        wait 2;
        self iprintlnbold("^3Press ^2AIM + SHOOT ^3to ^2Paste Objects");
        wait 2;
        self iprintlnbold("^3Press ^2AIM + [{+use}] ^3to ^2Copy Objects");
        wait 2;
        self iprintlnbold("^3Press ^2AIM + [{+gostand}] ^3to ^2Delete Objects");
        wait 2;
        self iprintlnbold("^3Press ^2DPAD & GRENADE BUTTONS ^3to ^2Rotate Objects");
        wait 30;
    //}
}

function func_forgetool()
{
    if(!isDefined(self.gamevars["forgetool"]))
    {
        self thread func_forgetoolinit();
        self.gamevars["forgetool"] = true;
        S("forgetool ^5ON");
        //S("Press [{+reload}] To Fly");
    }
    else
    {
        self notify("func_forgetool_stop");
        self.gamevars["forgetool"] = undefined;
        S("forgetool ^1OFF");
    }
}

function GetNormalTrace(distance = 1000000)
{
    return bullettrace(self GetEye(), self GetEye() + anglesToForward(self getplayerangles()) * distance, 0, self);
}

function func_forgetoolinit()
{
    self endon("func_forgetool_stop");
    self.forgetool = 0;
    self thread ForgeToolInstructions();
    object = undefined;
    trace = undefined;
    cannotsetmodel = undefined;
    currentent = undefined;
    //while(self GetToggleState("Forge Tool"))
    for(;;)
    {
        if(self adsbuttonpressed())
        {
            trace = GetNormalTrace();
            if(!isDefined(trace["entity"]))
            {
                cannotsetmodel = false;
                foreach(model in getEntArray("script_brushmodel", "classname"))
                {
                    if(!isDefined(currentent) && Distance(model.origin, trace["position"]) < 100)
                    {
                        currentent = model;
                        cannotsetmodel = true;
                    }
                    if( isDefined(currentent) && closer(trace["position"], model.origin, currentent.origin) )
                    {
                        currentent = model;
                        cannotsetmodel = true;
                    }
                }
                foreach(model in getEntArray("script_model", "classname"))
                {
                    if(!isDefined(currentent) && Distance(model.origin, trace["position"]) < 100)
                    {
                        currentent = model;
                        cannotsetmodel = false;
                    }
                    if( isDefined(currentent) && closer(trace["position"], model.origin, currentent.origin) )
                    {
                        currentent = model;
                        cannotsetmodel = false;
                    }
                }
                trace["entity"] = currentent;
            }
            //#ifndef serious killserver(); #endif
            while(self adsbuttonpressed())
            {
                trace["entity"] setOrigin(self GetEye() + anglesToForward(self GetPlayerAngles()) * 200);
                trace["entity"].origin = self GetEye() + anglesToForward(self GetPlayerAngles()) * 200;
                if(self attackbuttonpressed())
                {
                    if(isDefined(object))
                    {
                        if(isDefined(trace["entity"]) && !cannotsetmodel)
                        {
                            self iprintlnbold("Overwrote Objects Model With:^2 "+object);
                            trace["entity"] setModel(object);
                            trace["entity"] thread alwaysphysical();
                        }
                        else
                        {
                            trace = GetNormalTrace();
                            obj = spawn("script_model", trace["position"], 1);
                            obj setModel(object);
                            obj thread alwaysphysical();
                            self iprintlnbold("Spawned Object:^2 "+object);
                        }
                    }
                    wait .75;
                }
                if(self usebuttonpressed())
                {
                    if(isDefined(trace["entity"].model))
                    {
                        object = trace["entity"].model;
                        thread func_alwaysphysical(object);
                        self iprintlnbold("Copied Model: ^2"+ object);
                    }
                    wait .75;
                    break;
                }
                if(self jumpbuttonpressed())
                {
                    if(!isDefined(trace["entity"]))
                    {
                    }
                    else
                    {
                        trace["entity"] delete();
                        self iprintlnbold("Entity ^1Deleted");
                    }
                    wait .75;
                    break;
                }
                if(self actionslotonebuttonpressed())
                {
                    if(isDefined(trace["entity"]))
                    {
                        trace["entity"] rotatePitch(6, .05);
                    }
                    else
                    {
                        wait .5;
                        break;
                    }
                    wait .1;
                }
                if(self actionslottwobuttonpressed())
                {
                    if(isDefined(trace["entity"]))
                    {
                        trace["entity"] rotatePitch(-6, .05);
                    }
                    else
                    {
                        wait .5;
                        break;
                    }
                    wait .1;
                }
                if(self actionslotthreebuttonpressed())
                {
                    if(isDefined(trace["entity"]))
                    {
                        trace["entity"] rotateYaw(-6, .05);
                    }
                    else
                    {
                        wait .5;
                        break;
                    }
                    wait .1;
                }
                if(self actionslotfourbuttonpressed())
                {
                    if(isDefined(trace["entity"]))
                    {
                        trace["entity"] rotateYaw(6, .05);
                    }
                    else
                    {
                        wait .5;
                        break;
                    }
                    wait .1;
                }
                if(self secondaryoffhandbuttonpressed())
                {
                    if(isDefined(trace["entity"]))
                    {
                        trace["entity"] rotateRoll(-6, .05);
                    }
                    else
                    {
                        wait .5;
                        break;
                    }
                    wait .1;
                }
                if(self fragbuttonpressed())
                {
                    if(isDefined(trace["entity"]))
                    {
                        trace["entity"] rotateRoll(6, .05);
                    }
                    else
                    {
                        wait .5;
                        break;
                    }
                    wait .1;
                }
                wait 0.05;
            }
        }
        wait .1;
    }
}

function vector_scal(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}

function func_unlimitedclip()
{
    if(!isDefined(self.gamevars["clip_weap"]))
    {
        self notify("stop_clip");
        self thread func_clip();
        S("Unlimited clip ^5ON");
        self.gamevars["clip_weap"] = true;
    }
    else
    {
        self notify("stop_clip");
        self.gamevars["clip_weap"] = undefined;
        S("Unlimited clip ^1OFF");
    }
}

function func_unlimitedstock()
{
    if(!isDefined(self.gamevars["stock_weap"]))
    {
        self notify("stop_stock");
        self thread func_stock();
        S("Unlimited stock ^5ON");
        self.gamevars["stock_weap"] = true;
    }
    else
    {
        self notify("stop_stock");
        self.gamevars["stock_weap"] = undefined;
        S("Unlimited stock ^1OFF");
    }
}

function func_clip()
{
    self endon("stop_clip");
    for(;;)
    {
            if(self.gamevars["clip_weap"]==true)
            {
                if ( self getcurrentweapon() != "none" )
                {
                    self setweaponammoclip( self getcurrentweapon(), 1337 );
                }
            }
        WAIT_SERVER_FRAME;
    }
}

function func_stock()
{
    self endon("stop_stock");
    for(;;)
    {
            if(self.gamevars["stock_weap"]==true)
            {
                if ( self getcurrentweapon() != "none" )
                {
                    self setweaponammostock( self getcurrentweapon(), 1337 );
                }
            }
        WAIT_SERVER_FRAME;
    }
}

function func_ammo_refill()
{
    if ( self getcurrentweapon() != "none" )
    {
        self setweaponammostock( self getcurrentweapon(), 1337 );
        self setweaponammoclip( self getcurrentweapon(), 1337 );
    }
    S("Ammo ^5refilled");
}

function func_addScore(i)
{
    self.score += i;
    S("Score set to ^5"+self.score);
}

function func_thirdPerson()
{
    if(!isDefined(self.gamevars["thirdPerson"]))
    {
        self SetClientThirdPerson( 1 );
        self SetClientThirdPersonAngle( 354 );
        self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
        self.gamevars["thirdPerson"] = true;
    }
    else
    {
        self SetClientThirdPerson( 0 );
        self SetClientThirdPersonAngle( 0 );
        self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
        self.gamevars["thirdPerson"] = undefined;
    }
    self resetFov();
}

function func_doGivePerk(perk)
{
    if (!(self hasperk(perk) || self zm_perks::has_perk_paused(perk)))
    {
        self zm_perks::vending_trigger_post_think( self, perk );
    }
    else
    {
        self notify(perk + "_stop");
        self iprintln("Perk [" + perk + "] ^1Removed");
    }
}

function func_giveAllPerks()
{
    self zm_utility::give_player_all_perks();
    S("All Perks ^5given");
}
function func_lose_all_perks()
{
    all_perks = GetArrayKeys( level._custom_perks );
    for ( i = 0; i < all_perks.size; i++ )
    {
        if ( isdefined( self.perk_purchased ) && self.perk_purchased == all_perks[i] )
        {
            continue;
        }
        if ( self HasPerk( all_perks[i] ) || self zm_perks::has_perk_paused( all_perks[i] ) )
        {
            self notify(all_perks[i] + "_stop");
        }
    }
    if ( zm_perks::use_solo_revive() && all_perks[i] == PERK_QUICK_REVIVE )
    {
        self.lives--;
    }
S("All Perks ^1removed");
}

function perklist()
{
/*perks_list = array("specialty_accuracyandflatspread",
"specialty_additionalprimaryweapon",
"specialty_ammodrainsfromstockfirst",
"specialty_anteup",
"specialty_armorpiercing",
"specialty_armorvest",
"specialty_bulletaccuracy",
"specialty_bulletdamage",
"specialty_bulletflinch",
"specialty_bulletpenetration",
"specialty_combat_efficiency",
"specialty_deadshot",
"specialty_decoy",
"specialty_delayexplosive",
"specialty_detectexplosive",
"specialty_detectnearbyenemies",
"specialty_directionalfire",
"specialty_disarmexplosive",
"specialty_doubletap2",
"specialty_earnmoremomentum",
"specialty_electriccherry",
"specialty_extraammo",
"specialty_fallheight",
"specialty_fastads",
"specialty_fastequipmentuse",
"specialty_fastladderclimb",
"specialty_fastmantle",
"specialty_fastmeleerecovery",
"specialty_fastreload",
"specialty_fasttoss",
"specialty_fastweaponswitch",
"specialty_finalstand",
"specialty_fireproof",
"specialty_flakjacket",
"specialty_flashprotection",
"specialty_gpsjammer",
"specialty_grenadepulldeath",
"specialty_healthregen",
"specialty_holdbreath",
"specialty_immunecounteruav",
"specialty_immuneemp",
"specialty_immunemms",
"specialty_immunenvthermal",
"specialty_immunerangefinder",
"specialty_immunesmoke",
"specialty_immunetriggerbetty",
"specialty_immunetriggerc4",
"specialty_immunetriggershock",
"specialty_jetcharger",
"specialty_jetnoradar",
"specialty_jetpack",
"specialty_jetquiet",
"specialty_killstreak",
"specialty_locdamagecountsasheadshot",
"specialty_longersprint",
"specialty_loudenemies",
"specialty_lowgravity",
"specialty_marksman",
"specialty_microwaveprotection",
"specialty_movefaster",
"specialty_nokillstreakreticle",
"specialty_nomotionsensor",
"specialty_noname",
"specialty_nottargetedbyairsupport",
"specialty_nottargetedbyaitank",
"specialty_nottargetedbyraps",
"specialty_nottargetedbyrobot",
"specialty_nottargetedbysentry",
"specialty_overcharge",
"specialty_phdflopper",
"specialty_pin_back",
"specialty_pistoldeath",
"specialty_playeriszombie",
"specialty_proximityprotection",
"specialty_quickrevive",
"specialty_quieter",
"specialty_rof",
"specialty_scavenger",
"specialty_sengrenjammer",
"specialty_shellshock",
"specialty_showenemyequipment",
"specialty_showenemyvehicles",
"specialty_showscorestreakicons",
"specialty_sixthsensejammer",
"specialty_spawnpingenemies",
"specialty_sprintequipment",
"specialty_sprintfire",
"specialty_sprintfirerecovery",
"specialty_sprintgrenadelethal",
"specialty_sprintgrenadetactical",
"specialty_sprintrecovery",
"specialty_stalker",
"specialty_staminup",
"specialty_stunprotection",
"specialty_teflon",
"specialty_tombstone",
"specialty_tracer",
"specialty_tracker",
"specialty_trackerjammer",
"specialty_twogrenades",
"specialty_twoprimaries",
"specialty_unlimitedsprint",
"specialty_vultureaid",
"specialty_whoswho",
"specialty_widowswine"
);
return perks_list;*/
}

function func_giveWeapon(weapon)
{
    S(getOptionName()+" ^5Given");
    self zm_weapons::weapon_give(weapon,undefined,undefined,true,undefined );
}

function func_sendPowerUp(i)
{
    S(getOptionName()+" ^5droped");
    self zm_powerups::specific_powerup_drop(i, self.origin);
}


function func_fxBullets(i)
{
    if(self.gamevars["magicbullet"] == true)
    {
        self func_magicbullet_stop();
    }
    self notify("func_fxBullets_stop");
    self endon("func_fxBullets_stop");
    self.gamevars["fx_bullets"] = true;
    S("Fx Bullets set to ^5"+i);
    for(;;)
    {
        self waittill("weapon_fired");
        if(IsInArray(level._effect, level._effect[ i ]))
            TriggerFX(spawnFX(level._effect[ i ] , BulletTrace(self gettagorigin("tag_eye"), anglestoforward(self getPlayerAngles())* 1000000, true, self)["position"]));
        else
            S("ERROR: level._effect "+i+" is not in the array level._effect!");
    }
}
function func_fxBullets_stop()
{
    if(!isDefined(self.gamevars["fx_bullets"]) || self.gamevars["fx_bullets"] == false)
        S("^1Fx Bullets is already OFF. Choose a Fx to turn it on!");
    else
    {
        self notify("func_fxBullets_stop");
        self.gamevars["fx_bullets"] = undefined;
        S("FX Bullets ^1OFF");
    }
}

function func_magicbullet(i)
{
    if(self.gamevars["fx_bullets"] == true)
        self func_fxBullets_stop();
    self notify("func_magicbullettest_stop");
    self endon("func_magicbullettest_stop");
    self.gamevars["magicbullet"] = true;
    self iprintln("Weapon Bullets set to ^5"+i.name);
    for(;;)
    {
        self waittill( "weapon_fired" );
        MagicBullet( i, self GetEye(), BulletTrace(self GetEye(), self GetEye() + AnglesToForward(self GetPlayerAngles()) * 100000, false, self)["position"], self);
        wait .02;
    }
}
function func_magicbullet_stop()
{
    if(!isDefined(self.gamevars["magicbullet"]) || self.gamevars["magicbullet"] == false)
        S("^1Weapon Bullets is already OFF. Choose a Fx to turn it on!");
    else
    {
        self notify("func_magicbullettest_stop");
        self.gamevars["magicbullet"] = undefined;
        S("Weapon Bullets ^1OFF");
    }
}


////////////
// WP MODS
////////////

function func_packcurrentWeapon()
{
    weapon = self getCurrentWeapon();
    if(!self zm_weapons::can_upgrade_weapon(weapon))
    {
        S("^1Can not upgrade this weapon!");
        return;
    }
    aat_weapon = zm_weapons::weapon_supports_aat( weapon );
    if(aat_weapon)
    {

    }
    upgrade_weapon = zm_weapons::get_upgrade_weapon( weapon, aat_weapon);
    self func_giveWeapon(upgrade_weapon);
}
function func_unpackcurrentWeapon()
{
    weapon = self getCurrentWeapon();
    if(!zm_weapons::is_weapon_upgraded(weapon))
    {
        S("^1Weapon is not upgraded!");
        return;
    }
    weapon = zm_weapons::get_base_weapon(weapon);
    self func_giveWeapon(weapon);
}

function func_dropcurrentWeapon()
{
    weapon = self getCurrentWeapon();
    self DropItem(weapon);
    S("Weapon ^5Dropped");
}


function func_messageSend(i)
{
    for( a = 0; a < getplayers().size; a++ )
        getplayers()[a] [[self.menu["message_type"]]](i);
}

function func_printMessage()
{
    if( self.menu["message_type"] == &Sb)
    {
        self.menu["message_type"] = &S;S("Print Methode Changed to ^5Left Corner Message");
    }
    /*else if( self.menu["message_type"] == &S)
    {
        self.menu["message_type"] = &C;S("Print Methode Changed to ^5Lobby Chat");
    }*/
    else if( self.menu["message_type"] == &S)
    {
        self.menu["message_type"] = &Sb;S("Print Methode Changed to ^5Center Screen Message");
    }
}
function cli_givePoints(player, ammount)
{
    player thread func_addScore(ammount);
    S(getNameNotClan(player)+" score set to "+player.score);
}

function cli_godmode(player)
{
    player thread func_godmode();
    //S(getNameNotClan(player)+" GodMode "+ (player.gamevars["godmode"]? "^5ON" : "^1OFF"));
    if(player == self)
        return;
    if(player.gamevars["godmode"] == true)
        S(getNameNotClan(player)+" Godmode ^5ON");
    else
        S(getNameNotClan(player)+" Godmode ^1OFF");
}


function verificationOptions(player, par2, par3)
{
    if( par2 == "changeVerification" )
    {
        if( player == getplayers()[0] )
             return S( "You can not modify the host");
        player setVerification(par3);
        S(getNameNotClan( player )+"'s verification has been changed to "+par3);
        player iPrintLn("Your verification has been changed to "+par3);
        player iPrintLn("Press ^5[{stance}]^7 + ^5[{reload}]");
    }
}

function setVerification( type )
{
    self.playerSetting["verfication"] = type;
    S("Your Status changed to ^5"+self.playerSetting["verfication"]);
}

function getVerfication()
{
    if( self.playerSetting["verfication"] == "admin" )
        return 3;
    if( self.playerSetting["verfication"] == "co-host" )
        return 2;
    if( self.playerSetting["verfication"] == "verified" )
        return 1;
    if( self.playerSetting["verfication"] == "unverified" )
        return 0;
}

function quick_modificator(input,i_1,i_2,i_3)
{

    if(isEmpty(i_3))
        i_3 = undefined;
    if(self.gamevars[input]==0 || !isDefined(self.gamevars[input]))
    {
        SetDvar( input , i_1 );
        self.gamevars[input]=1;
        S(getOptionName()+" ^5ON^7 - var "+input+" set to "+i_1);
    }
    else if(self.gamevars[input]==1)
    {
        SetDvar( input, i_2 );
        if(isDefined(i_3))
        {
            self.gamevars[input]=2;
            S(getOptionName()+" ^5ON^7 - var "+input+" set to "+i_2);
        }
        else
        {
            self.gamevars[input]=0;
            S(getOptionName()+" ^1OFF^7 - var "+input+" set to "+i_2);
        }
    }
    else if(self.gamevars[input]==2)
    {
        SetDvar( input,i_3 );
        self.gamevars[input]=0;
        S(getOptionName()+" ^1OFF^7 - var "+input+" set to "+i_3);
    }

}

function isEmpty(i)
{
    if(i == "" || !isDefined(i))
        return true;
    else
        return false;
}

function func_setDvarFunction(dvar,i)
{
    SetDvar( dvar, i );
    S("Var ^5"+dvar+"^7 setted to ^5"+i);
}

function func_togglehideWeapon()
{
    if(getDvarint("cg_drawGun") == 0)
       setDvar("cg_drawGun", "1");
    else
       setDvar("cg_drawGun", "0");
    self S("Hide Gun " + ((getDvarint("cg_drawGun") == 0) ? "^5ON" : "^1OFF"));
}
function func_togglehideCrosshair()
{
    if(getDvarint("cg_drawCrosshair") == 0)
       setDvar("cg_drawCrosshair", 1);
    else
       setDvar("cg_drawCrosshair", 0);
    self S("Crosshair " + ((getDvarint("cg_drawCrosshair") == 0) ? "^5ON" : "^1OFF"));
}

function func_getOrigin()
{
    S("Your Origin ^5"+self GetOrigin());
}

function cli_teleportto(i)
{
    self SetOrigin(i GetOrigin());
}

function cli_teleporttoyou(i)
{
    i SetOrigin(self GetOrigin());
}

function cli_damage_player(player)
{
    player DoDamage(player.health, player.origin);
}

function cli_kill_player(player)
{
    player Kill();
}

function updateMenu_color_system_Map(menu,i)
{
    /*self addMenuPar_withDef(menu, "Set To Royal Blue", i, ((34/255),(64/255),(139/255)));
    self addMenuPar_withDef(menu, "Set To Raspberry", i, ((135/255),(38/255),(87/255)));
    self addMenuPar_withDef(menu, "Set To Skyblue", i, ((135/255),(206/255),(250/250)));
    self addMenuPar_withDef(menu, "Set To Hot Pink", i, ((1),(0.0784313725490196),(0.5764705882352941)));
    self addMenuPar_withDef(menu, "Set To Lime Green", i, (0,1,0));
    self addMenuPar_withDef(menu, "Set To Dark Green", i, (0/255, 51/255, 0/255));
    self addMenuPar_withDef(menu, "Set To Brown", i, ((0.5450980392156863),(0.2705882352941176),(0.0745098039215686)));
    self addMenuPar_withDef(menu, "Set To Blue", i, (0,0,1));
    self addMenuPar_withDef(menu, "Set To Red", i, (1,0,0));
    self addMenuPar_withDef(menu, "Set To Maroon Red", i, (128/255,0,0));
    self addMenuPar_withDef(menu, "Set To Orange", i, (1,0.5,0));
    self addMenuPar_withDef(menu, "Set To Purple", i, ((0.6274509803921569),(0.1254901960784314),(0.9411764705882353)));
    self addMenuPar_withDef(menu, "Set To Cyan", i, (0,1,1));
    self addMenuPar_withDef(menu, "Set To Yellow", i, (1,1,0));
    self addMenuPar_withDef(menu, "Set To Black", i, (0,0,0)); 
    self addMenuPar_withDef(menu, "Set To White", i, (1,1,1));*/
}
function updateMenu_nuumber_float_system_Map(menu,i,i_2)
{
    /*self addMenuPar_withDef(menu,"1", i, i_2, 1);
    self addMenuPar_withDef(menu,".9", i, i_2, .9);
    self addMenuPar_withDef(menu,".8", i, i_2, .8);
    self addMenuPar_withDef(menu,".7", i, i_2, .7);
    self addMenuPar_withDef(menu,".6", i, i_2, .6);
    self addMenuPar_withDef(menu,".5", i, i_2, .5);
    self addMenuPar_withDef(menu,".4", i, i_2, .4);
    self addMenuPar_withDef(menu,".3", i, i_2, .3);
    self addMenuPar_withDef(menu,".2", i, i_2, .2);
    self addMenuPar_withDef(menu,".1", i, i_2, .1);
    self addMenuPar_withDef(menu,"0", i, i_2, 0);*/
}
function func_invisible()
{
    if(!self.gamevars["invisible"])
    {
        self hide();
        self.gamevars["invisible"] = true;
        S("You are ^5Invisible");
    }
    else
    {
        self show();
        self.gamevars["invisible"] = false;
        S("You are ^1Visible");
    }
}

function func_flashingPlayer()
{
    if(!isDefined(self.gamevars["flashingPlayer"]))
    {
        self.gamevars["flashingPlayer"] = true;
        self thread doFlashyPlayer();
        S("Flashing Player ^5ON^7");
    }
    else
    {
        self.gamevars["flashingPlayer"] = undefined;
        self notify("flashingPlayer_over");
        S("Flashing Player ^1OFF^7");
        self show();
    }
}

function doFlashyPlayer()
{
    self endon("death");
    self endon("disconnect");
    self endon("flashingPlayer_over");
    for(;;)
    {
        self show();
        wait .1;
        self hide();
        wait .1;
    }
}

/*function func_roundsystem(value,set)
{
    if(set == true)
        //level.round_number = value;
        //thread motherfucker::goto_round(value);
    else
        //level.round_number += value;
        round_number = zm::get_round_number();
        round_number += value;
        //thread motherfucker::goto_round(round_number);
    S("End the current Round to jump to round ^5"+zm::get_round_number());
}*/

function func_setVision(i = "default")
{
    self UseServerVisionset( true );
    self SetVisionSetForPlayer( i, 1 );
    S("Vision set to ^5"+getOptionName());
    L("visionserver: "+i);
}
function func_visionReset()
{
    self func_setVision("default");
    S("Modded Vision ^1OFF");
}

function func_sound(i)
{
    self PlaySound(i);
    S("You are playing ^5"+getOptionName());
    L(i);
}

function func_clonePlayer( player = self )
{
    if(isDefined(self.gamevars["Clone"]))
    {
        S("^1You already spawned a Clone, delete the current to spawn a new one.");
        return;
    }
    self.gamevars["Clone"] = player util::spawn_player_clone( player, "t7_loot_gesture_goodgame_salute" );
    S("Clone ^5Spawned");
}
function func_clonePlayer_playAnimation(animname)
{
    if(!isDefined(self.gamevars["Clone"]))
    {
        S("^1Spawn a Clone first!");
        return;
    }
    self.gamevars["Clone"] AnimScripted( "clone_anim", self.gamevars["Clone"].origin, self.gamevars["Clone"].angles, animname );
    S("Animation "+animname+" ^5Played");
}
function func_clonePlayer_delete()
{
    if(!isDefined(self.gamevars["Clone"]))
    {
        S("^1Spawn a Clone first!");
        return;
    }
    self.gamevars["Clone"] AnimScripted( "clone_anim", self.gamevars["Clone"].origin, self.gamevars["Clone"].angles, "pb_death_headshot_back" );
    wait 2;
    self.gamevars["Clone"] delete();
    self.gamevars["Clone"] = undefined;
    S("Clone ^5deleted");
}
function func_clonePlayer_teleportToYou()
{
    if(!isDefined(self.gamevars["Clone"]))
    {
        S("^1Spawn a Clone first!");
        return;
    }
    self.gamevars["Clone"] SetOrigin(self.origin);
    self.gamevars["Clone"] AnimScripted( "clone_anim", self.origin, self.angles, "pb_death_base_pose" );
    S("Clone ^5teleported");
}

function flashlowammo()
{

}



/*

Aimbot

    self.gamevars["aimbot_aimbutton_none"] = false
    self.gamevars["aimbot_shootbutton_none"] = false
    self.gamevars["aimbot_unfair"] = false

*/
function func_aimbot()
{
    if(!isDefined(self.gamevars["aimbot"]) || !self.gamevars["aimbot"])
    {
        self.gamevars["aimbot"] = true;
        self thread func_core_aimbot();
        S("Aimbot ^5ON");
    }
    else
    {
        self.gamevars["aimbot"] = false;
        S("Aimbot ^1OFF");
    }
    self func_setCurrentMenu("Toggle Aimbot <"+((self.gamevars["aimbot"] == 1) ? "^5ON^7" : "^1OFF^7")+">");
    self func_overwirdefunction(0, "main_aimbot", "Toggle Aimbot <"+((self.gamevars["aimbot"] == 1) ? "^5ON^7" : "^1OFF^7")+">", &func_aimbot);
}

function func_core_aimbot()
{
    self endon("death");
    self endon("disconnect");
    while( self.gamevars["aimbot"] )
    {
        while ( self adsButtonPressed() || self.gamevars["aimbot_aimbutton_none"] && self.gamevars["aimbot"] )
        {
            zom = ArrayGetClosest(self getOrigin(), getAiSpeciesArray("axis", "all"));
            if(!BulletTracePassed(self getTagOrigin("j_head"), zom getTagOrigin("j_head"), false, self) && self.gamevars["aimbot_vis"])
            {
                wait .001;
                continue;
            }
            self setPlayerAngles(vectorToAngles(zom getTagOrigin("j_head") - self getTagOrigin("j_head")));
            if( self.gamevars["aimbot_unfair"] )
            {
                if(self attackbuttonpressed() || self.gamevars["aimbot_shootbutton_none"])
                    zom DoDamage( zom.health + 1, zom GetOrigin(), self);
            }
            wait .01;
        }
        wait .05;
    }
}


function func_aimbot_unfair()
{
    self.gamevars["aimbot_unfair"] = !self.gamevars["aimbot_unfair"];
    self S("Aimbot Unfair Mode " + ((self.gamevars["aimbot_unfair"] == 1) ? "^5ON" : "^1OFF"));
    self func_setCurrentMenu("Unfair Aimbot <"+((self.gamevars["aimbot_unfair"] == 1) ? "^5ON^7" : "^1OFF^7")+">");
    self func_overwirdefunction(1, "main_aimbot", "Unfair Aimbot <"+((self.gamevars["aimbot_unfair"] == 1) ? "^5ON^7" : "^1OFF^7")+">", &func_aimbot_unfair);
}

function func_aimbot_aimbutton()
{
    self.gamevars["aimbot_aimbutton_none"] = !self.gamevars["aimbot_aimbutton_none"];
    //self S("aimbot_aimbutton_none " + ((self.gamevars["aimbot_aimbutton_none"] == 1) ? "^5ON" : "^1OFF"));
    if(self.gamevars["aimbot_aimbutton_none"])
        self.gamevars["current_aim_version"] = "None";
    else
        self.gamevars["current_aim_version"] = "Right Mouse";
    self func_setCurrentMenu("Toggle Button <"+self.gamevars["current_aim_version"]+">");
    self func_overwirdefunction(3, "main_aimbot", "Toggle Button <"+self.gamevars["current_aim_version"]+">", &func_aimbot_aimbutton);
}

function func_aimbot_shootbutton()
{
    self.gamevars["aimbot_shootbutton_none"] = !self.gamevars["aimbot_shootbutton_none"];
    //self S("aimbot_shootbutton_none " + ((self.gamevars["aimbot_shootbutton_none"] == 1) ? "^5ON" : "^1OFF"));
    if(self.gamevars["aimbot_shootbutton_none"])
        self.gamevars["current_shoot_version"] = "None";
    else
        self.gamevars["current_shoot_version"] = "Left Mouse";
    self func_setCurrentMenu("Toggle Shoot Button <"+self.gamevars["current_shoot_version"]+">");
    self func_overwirdefunction(2, "main_aimbot", "Toggle Shoot Button <"+self.gamevars["current_shoot_version"]+">", &func_aimbot_shootbutton);
}
function func_aimbot_vis()
{
    self.gamevars["aimbot_vis"] = !self.gamevars["aimbot_vis"];
    self S("Aimbot Target Visible Check " + ((self.gamevars["aimbot_vis"] == 1) ? "^5ON" : "^1OFF"));
}


function func_setCurrentMenu(i)
{
    self.menu["ui"]["text"][self getCursor()] setText(i);
}

function func_overwirdefunction(count, menu, name, func, input1, input2, input3, input4)
{
    self.menu["items"][menu].name[count] = name;
    self.menu["items"][menu].func[count] = func;
    if( isDefined(input1) )
        self.menu["items"][menu].input1[count] = input1;
    if( isDefined(input2) )
        self.menu["items"][menu].input2[count] = input2;
    if( isDefined(input3) )
        self.menu["items"][menu].input3[count] = input3;
    if( isDefined(input4) )
        self.menu["items"][menu].input4[count] = input4;
}

/*

*/

function func_togglePostionSystem_save()
{
    self.gamevars["pos_self_saved"] = self.origin;
    S("Position ^5Saved");
}

function func_togglePostionSystem_load()
{
    if(isDefined(self.gamevars["pos_self_saved"]))
    {
        self setOrigin(self.gamevars["pos_self_saved"]);
        S("Position ^5Loaded");L(self.gamevars["pos_self_saved"]);
    }
    else
        S("^1You need to save a position first!");
}

function func_togglePostionSystem_load_zombz()
{
    if(isDefined(self.gamevars["pos_self_saved"]))
    {
        if(!isDefined(self.gamevars["pos_zombz_loop"]) || self.gamevars["pos_zombz_loop"] == false )
        {
            S("Zombies Teleported to the Saved Location.");
            self ThreadAtAllZombz(&teleportZomZtoPosition,self.gamevars["pos_self_saved"]);
        }
        else
            S("^1Turn Location Spawn Trapper ^1OFF");
    }
    else
        S("^1You need to save a position first!");
}

function func_togglePostionSystem_load_zombz_spawn()
{
    if(isDefined(self.gamevars["pos_self_saved"]))
    {
        if(!isDefined(self.gamevars["pos_zombz_spawn"]) || self.gamevars["pos_zombz_spawn"] == false )
        {
            self.gamevars["pos_zombz_spawn"] = true;
            self.gamevars["pos_zombz_loop"] = false;
            S("Zombies spawn set to the Saved Location.");
            while(self.gamevars["pos_zombz_spawn"] == true)
            {
                self ThreadAtAllZombz(&teleportZomZtoPosition_just_onetime,self.gamevars["pos_self_saved"]);
                wait .1;
            }
        }
        else
        {
            self.gamevars["pos_zombz_spawn"] = false;
            S("Location Spawn Trapper ^1OFF");
        }

    }
    else
        S("^1You need to save a position first!");
}
function func_togglePostionSystem_load_zombz_loop()
{
    if(isDefined(self.gamevars["pos_self_saved"]))
    {
        if(!isDefined(self.gamevars["pos_zombz_loop"]) || self.gamevars["pos_zombz_loop"] == false )
        {
            self.gamevars["pos_zombz_loop"] = true;
            self.gamevars["pos_zombz_spawn"] = false;
            S("Zombies will teleport in a loop to the Saved Location.");
            while(self.gamevars["pos_zombz_loop"] == true)
            {
                self ThreadAtAllZombz(&teleportZomZtoPosition,self.gamevars["pos_self_saved"]);
                wait .1;
            }
        }
        else
        {
            self.gamevars["pos_zombz_loop"] = false;
            S("Location Spawn Trapper ^1OFF");
        }

    }
    else
        S("^1You need to save a position first!");
}


function getZombz()
{
    return GetAiSpeciesArray( "axis", "all" );
}

function ThreadAtAllZombz(func_ , input)
{
    for (i = 0; i < getZombz().size; i++)
    {
        getZombz()[i] [[func_]](input);
    }
}

function func_tel_trace()
{
    self setOrigin(self findTracePosition());
    S("Teleported to Trace Position ^5Successful");
}
function func_tel_sky()
{
    self setOrigin(self getOrigin()+(0,0,100000));
    S("Teleported to Sky ^5Successful");
}
function func_tel_ground()
{
    self setOrigin(findGround(self getOrigin()));
    S("Teleported to Ground ^5Successful");
}
function findGround(origin)
{
    return BulletTrace(origin,(origin+(0,0,-100000)),false,self)["position"];
}
function findTracePosition()
{
    return BulletTrace(self gettagorigin("tag_eye"), anglestoforward(self getPlayerAngles())* 1000000, true, self)["position"];
}
function func_tel_near_zombz()
{
    //var_zom = get_closest_ai( self.origin, "axis" );
    //if(isDefined(var_zom))
    //{
    //    self setOrigin(var_zom.origin);
    //    self S("Teleported to the nearest ^5Zombie");
    //}
    //else {
        self S("^1Error^7: There are no Enemys to Teleport to.");
    //}
}

function teleportZomZtoPosition(i)
{
    self forceTeleport( i );
    self zm_spawner::zombie_setup_attack_properties();
    self zombie_utility::reset_attack_spot();
}
function teleportZomZtoPosition_just_onetime(i)
{
    if(!isDefined(self.teleported_already))
        self.teleported_already = false;
    if(!self.teleported_already)
    {
        self.teleported_already = true;
        wait 1.5;
        self forceTeleport( i );
        self zm_spawner::zombie_setup_attack_properties();
        self zombie_utility::reset_attack_spot();
    }
}

function func_togglePostionSystem_modify_pos(i)
{
    if(isDefined(self.gamevars["pos_self_saved"]))
    {
        self.gamevars["pos_self_saved"] += i;
        S("X:^5"+self.gamevars["pos_self_saved"][0]+"^7 Y:^5"+self.gamevars["pos_self_saved"][1]+"^7 Z:^5"+self.gamevars["pos_self_saved"][2]+"^7");
    }
    else
        S("^1You need to save a position first!");
}

//
// ENDE TELPORT
//

function func_earthquake()
{
   S("Earthquake ^5Started");
   earthquake(0.6,5,self.origin,100000000);
}

function func_rapfireeboi()
{
    if(!isDefined(self.gamevars["israpfireonorno"]))
    {
        self.gamevars["israpfireonorno"] = true;
        self S( "Rapid Fire ^5ON" );
        setdvar( "perk_weapRateMultiplier", "0.001" );
        setdvar( "perk_weapReloadMultiplier", "0.001" );
        setdvar( "perk_fireproof", "0.001" );
        setdvar( "cg_weaponSimulateFireAnims", "0.001" );
        self setperk( "specialty_rof" );
        self setperk( "specialty_fastreload" );
    }
    else
    {
        self.gamevars["israpfireonorno"] = undefined;
        self S( "Rapid Fire ^1OFF" );
        setdvar( "perk_weapRateMultiplier", "1" );
        setdvar( "perk_weapReloadMultiplier", "1" );
        setdvar( "perk_fireproof", "1" );
        setdvar( "cg_weaponSimulateFireAnims", "1" );
        self unsetperk( "specialty_rof" );
        self unsetperk( "specialty_fastreload" );
    }

}

function func_noTarget()
{
    if(!self.ignoreme)
    {
        S("No Target ^5ON");
        self.ignoreme = true;
    }
    else
    {
        S("No Target ^1OFF");
        self.ignoreme = false;
    }
}

function print_get_current_zombz_count()
{
self S("Current Zombie Count ^5"+getZombz().size);
}

function func_Physical_exlo()
{
    PhysicsExplosionSphere( self.origin, 500, 450, 5 );
    S("Physical Explosion ^5Sended");
}

function func_Physical_Cylinder()
{
    PhysicsExplosionCylinder( self.origin, 500, 450, 5 );
    S("Physical Cylinder ^5Sended");
}


////

function func_printEntitys()
{
    _var_names = getentarray("script_model", "classname");
    for( i = 0; i < _var_names.size; i++ )
    {
        S("*");
        S(_var_names[i].model);
        S(_var_names[i]);
        S(i);
        wait 1;
    }
}

///



/*
Entities
*/
function func_create_entity_menu()
{
    var_names = getentarray("script_model", "classname");
    self addmenu("main_entity_models", "Entity Menu", "main_entity");
    for( i = 0; i < var_names.size; i++ )
    {
        if(!isDefined(level._objectModels))
            level._objectModels = [];
        if(!isDefined(level._objectModels[var_names[i].model]) || IsSubStr(var_names[i].model, "collision")  || IsSubStr(var_names[i].model, "tag_")) // ! entfernt TODO
        {
            level._objectModels[var_names[i].model] = var_names[i].model;
            level._objectModels[var_names[i].model].name = getEntityModelName(var_names[i].model);
            self addMenuPar_withDef("main_entity_models", getEntityModelName(var_names[i].model), &func_entitySelection, level._objectModels[var_names[i].model]);
        }
    }
}

function addCostumModel(i)
{
    if(!isDefined(level._objectModels))
            level._objectModels = [];
    if(!isDefined(level._objectModels[i]))
    {
        level._objectModels[i] = i;
        level._objectModels[i].name = getEntityModelName(i);
    }
}
function getEntityModelName(i)
{
    switch(i)
    {
        case "zombie_skull": i = "Zombie Skull";  break;
        default:  i = "&"+i; break;
    }
    return i;
}

function func_spawnEntityModelView()
{
    self endon("disconnect");
    self.menu["isLocked"] = true;
    self controlMenu("close");
    wait 0.5;
    self.menu["isLocked"] = true;
    self S("Press ^3[{+attack}]^7/^3[{+speed_throw}]^7 to Change Model");
    self S("Press ^3F ^7to select Model");
    self S("Press ^3[{+melee}]^7 to close.");
    entity_models = GetArrayKeys(level._objectModels);
    if(!isDefined(self.curser))
        self.curser = 0;
    self func_entitySelection(entity_models[self.curser]);
    for(;;)
    {
        if( self attackButtonPressed() || self adsButtonPressed())
        {
            self.curser -= self adsButtonPressed();
            self.curser += self attackButtonPressed();
            if(self.curser < 0)
                self.curser = entity_models.size-1;
            if(self.curser > entity_models.size-1)
                self.curser = 0;
            L("model key: "+self.curser);
            self func_entitySelection(entity_models[self.curser]);
            wait 0.5;
        }
        if( self useButtonPressed())
        {
            if(!isDefined(self.selectedModel))
                S("^1You need to select a model!");
            else
                S("Selceted Model is ^5"+self.selectedModel);
            wait 0.5;
            self.menu["isLocked"] = false;
            self controlMenu("open_withoutanimation","main_entity");
            break;
        }
        if(self meleeButtonPressed())
        {
            func_deleteentity();
            wait 0.5;
            self.menu["isLocked"] = false;
            self controlMenu("open_withoutanimation","main_entity");
            break;
        }
        wait 0.05;
    }
}


function func_entitySelection(model)
{
    vector = self getEye()+vector_scal(anglesToForward(self getPlayerAngles()), 50); // changes this maybe later to a other value
    if(!isDefined(self.selectedModel))
    {
        self.selectedModel = spawn("script_model", vector);
        entity_cacheFunction(self.selectedModel);
        self thread func_moveCurrentModel();
    }
    self.selectedModel setModel(model);
    if(!isDefined(self.selectedModel.spin))
        self.selectedModel.spin = [];
    self func_resetModelAngles();
    S("Your selected Model is ^5"+getEntityModelName(model));
}

function func_moveCurrentModel()//credits to programmer v2 creator!
{
    self notify("func_moveCurrentModel_stop");
    self endon("func_moveCurrentModel_stop");
    self endon("disconnect");
    self endon("death");
    if(!isDefined(self.modelDistance))
        self.modelDistance = 250;
    while(isDefined(self.selectedModel))
    {
        self.selectedModel moveTo(bulletTrace(self getEye(), self getEye()+vector_scal(anglesToforward(self getPlayerAngles()), self.modelDistance), false, self.selectedModel)["position"], .1);
        wait .05;
    }
}

function func_placemodel()
{
    if(isdefined(self.selectedModel))
    {
        self notify("func_moveCurrentModel_stop");
        self.selectedModel = undefined;
    }
    else
        S("^1You need to select a model first!");
}

function func_dropmodel()
{
    self.selectedModel thread alwaysphysical();
    if(isdefined(self.selectedModel))
    {
        self notify("func_moveCurrentModel_stop");
        self.selectedModel = undefined;
    }
    else
        S("^1You need to select a model first!");
}
function func_deleteentity()
{
    if(!isDefined(self.selectedModel))
    {
        S("^1You need to select a model first!");
        return;
    }
    self notify("func_moveCurrentModel_stop");
    level._cachedEntitys[level._cachedEntitys.size-1] Delete();
    level._cachedEntitys[level._cachedEntitys.size-1] = undefined;
    self.selectedModel = undefined;
    S("Model deleted");
}

function func_entity_distance(i)
{
    self.modelDistance = self.modelDistance + i;
    S("Model Distance set to ^5"+self.modelDistance);
}

function alwaysphysical()
{
    self endon("death");
    self endon("alwaysphysical_stop");
    for(;;)
    {
        self physicslaunch();
        wait 0.1;
    }
}

function entity_cacheFunction(entity)
{
    if(!isDefined(level._cachedEntitys))
        level._cachedEntitys = [];
    level._cachedEntitys[level._cachedEntitys.size] = entity;
}

function entity_deleteCache()
{
    if(!isDefined(level._cachedEntitys))
    {
        S("^1No Entitys in spawned!");
        return;
    }
    else
    {
        S("All Entitys ("+level._cachedEntitys.size+") deleted.");
        for(i = 0; i < level._cachedEntitys.size; i++)
        {
            level._cachedEntitys[i] notify("alwaysphysical_stop");
            level._cachedEntitys[i] delete();
        }
        level._cachedEntitys = undefined;

    }
}

function rotateCurrentModel(num, times)
{
    self.selectedModel.spin[num]+= (10*(times));
    self.selectedModel rotateTo((self.selectedModel.spin[0], self.selectedModel.spin[1], self.selectedModel.spin[2]), 1, 0, 1);
}

function func_resetModelAngles()
{
    self.selectedModel.spin[0] = 0;
    self.selectedModel.spin[1] = 0;
    self.selectedModel.spin[2] = 0;
    self.selectedModel.angles = (self.selectedModel.spin[0],self.selectedModel.spin[1],self.selectedModel.spin[2]);
}

function func_alwaysphysical(model)
{
    self.modelEnt = spawn("script_model",self.origin+(0,0,100));
    self.modelEnt setmodel(model);
    self.modelEnt thread alwaysphysical();
    entity_cacheFunction(self.modelEnt);
}

function func_boxcost(i){
    self S("Box Opening price set to ^5" +i);
     foreach(box in level.chests)
        box.zombie_cost = i;
}
function func_ShowBoxess() {
        self S("All Mystery Boxes ^5Spawned");
        foreach(box in level.chests)
            box thread zm_magicbox::show_chest();
}
function func_HideBoxess() {
    self S("All Mystery Boxes ^5Hidden");
    foreach(box in level.chests)
        box thread zm_magicbox::hide_chest(0);
}
function func_BoxesNeverMove() {
    self S("Unlimited Chest Rolls ^5Successful");
    level.chest_min_move_usage = 999;
}

function func_reviveAllPlayers() {
    self S("All Players are ^5Revived");
    a = getPlayers();
    for (i = 0; i <= a.size - 1; i++) {
        if (IsDefined(a[i].revivetrigger)) {
            a[i] zm_laststand::auto_revive(level);
        }
    }
}
function func_keepperks() {
    if (!isDefined(self._retain_perks)) {
        self S("Keep all Perks on death ^5ON");
        self._retain_perks = true;
    } else {
        self._retain_perks = undefined;
        self S("Keep all Perks on death ^1OFF");
    }
}
function func_autoTeaBag() {
    if (!isDefined(self.gamevars["autoTeaBag"])) {
        self.gamevars["autoTeaBag"] = true;
        self S("Auto T-Bag ^5ON");
        self thread doAutoTeabag();
    } else {
        self.gamevars["autoTeaBag"] = undefined;
        self S("Auto T-Bag ^1OFF");
        self notify("autoTeabag_over");
    }
}
function doAutoTeabag()
{
    self endon("death");
    self endon("disconnect");
    self endon("autoTeabag_over");
    for (;;)
    {
        self setStance("crouch");
        wait .2;
        self setStance("stand");
        wait .2;
    }
}

function func_ToggleIceSkater() {
    if (!isDefined(self.gamevars["func_ToggleIceSkater"])) {
        self.gamevars["func_ToggleIceSkater"] = true;
        self thread func_IceSkater();
        self S("Spawn Ice Skater ^5ON");
    } else {
        self.gamevars["func_ToggleIceSkater"].model Delete();
        self notify("func_ToggleIceSkater_stop");
        self.gamevars["func_ToggleIceSkater"] = undefined;
        self S("Spawn Ice Skater ^1OFF");
    }
}

function func_IceSkater()
{
    self endon("death");
    self endon("func_ToggleIceSkater_stop");
    self.gamevars["func_ToggleIceSkater"].model = spawn("script_model", self.origin);
    self.gamevars["func_ToggleIceSkater"].model setmodel("defaultactor");
    entity_cacheFunction(self.gamevars["func_ToggleIceSkater"].model);
    while (1) {
        self.gamevars["func_ToggleIceSkater"].model RotateYaw(9000, 9);
        self.gamevars["func_ToggleIceSkater"].model MoveY(-180, 1);
        wait 1;
        self.gamevars["func_ToggleIceSkater"].model MoveY(180, 1);
        wait 1;
        self.gamevars["func_ToggleIceSkater"].model MoveX(-180, 1);
        wait 1;
        self.gamevars["func_ToggleIceSkater"].model MoveX(180, 1);
        wait 1;
        self.gamevars["func_ToggleIceSkater"].model MoveZ(90, .5);
        wait .5;
        self.gamevars["func_ToggleIceSkater"].model MoveZ(-90, .5);
        wait .5;
        self.gamevars["func_ToggleIceSkater"].model MoveY(180, 1);
        wait 1;
        self.gamevars["func_ToggleIceSkater"].model MoveY(-180, 1);
        wait 1;
        self.gamevars["func_ToggleIceSkater"].model MoveX(180, 1);
        wait 1;
        self.gamevars["func_ToggleIceSkater"].model MoveX(-180, 1);
        wait 1;
    }
}

function func_shootPowerups() {
    if (!isDefined(self.gamevars["gamevars"])) {
        self.gamevars["gamevars"] = true;
        self S("Toogle Shoot Power Ups ^5ON");
        self thread run_shootPowerups();
    } else {
        self.gamevars["gamevars"] = undefined;
        self S("Toogle Shoot Power Ups ^1OFF");
        self notify("run_shootPowerups_stop");
    }
}
function run_shootPowerups() {
    self endon("death");
    self endon("disconnect");
    self endon("run_shootPowerups_stop");
    for (;;) {
        self waittill("weapon_fired");
        level.zombie_vars["zombie_drop_item"] = true;
        level.powerup_drop_count = false;
        self thread zm_powerups::powerup_drop(self findTracePosition());
    }
}

/*function func_openAllDoors() 
{
    if(isDefined(level.all_doors_open) && !moon_doors_supported())
    return;

    
    level.all_doors_open = !bool(level.all_doors_open);
    self iPrintLn("All Doors " + (!level.all_doors_open ? "^1Closed" : "^2Open") );
    types = array("zombie_door", "zombie_airlock_buy");

    foreach(type in types)
    {
        zombie_doors = GetEntArray(type, "targetname");
        for(i=0;i<zombie_doors.size;i++)
        {
            if(zombie_doors[i]._door_open == 1 && !level.all_doors_open)
                zombie_doors[i] thread SetDoorsClosed();

            else if(zombie_doors[i]._door_open == 0 && level.all_doors_open)
                zombie_doors[i] thread SetDoorsOpen();
        } 
    }
    //S("^2All Doors Are Open");
}*/

function NoFallDam()
{
    iPrintLnBold("No Fall Damage " + (GetDvarInt("bg_fallDamageMinHeight") == 9999 ? "^1OFF" : "^2ON") );
    SetDvar("bg_fallDamageMinHeight", (GetDvarInt("bg_fallDamageMinHeight") != 9999 ? 9999 : 256));
    SetDvar("bg_fallDamageMaxHeight", (GetDvarInt("bg_fallDamageMaxHeight") != 9999 ? 9999 : 512));
}

function grab_All_Craftables()
{
    if(isdefined(level.all_parts_required))
        return;

    level.all_parts_required = true;
    foreach(s_craftable in level.zombie_include_craftables)
    {
        foreach(s_piece in s_craftable.a_piecestubs)
        {
            if(isdefined(s_piece.pieceSpawn))
                self zm_craftables::player_take_piece(s_piece.pieceSpawn);
        }
    }
}

function bool(variable)
{
    return isdefined(variable) && int(variable);
}

function func_openAllDoors() 
{
    thread OpenAllDebris();
    if(isDefined(level.all_doors_open) && !moon_doors_supported())
        return;

    
    level.all_doors_open = !bool(level.all_doors_open);
    iPrintLnBold("All Doors " + (!level.all_doors_open ? "^1Closed" : "^2Open") );
    types = array("zombie_door", "zombie_airlock_buy");

    foreach(type in types)
    {
        zombie_doors = GetEntArray(type, "targetname");
        for(i=0;i<zombie_doors.size;i++)
        {
            if(zombie_doors[i]._door_open == 1 && !level.all_doors_open)
                zombie_doors[i] thread SetDoorsClosed();

            else if(zombie_doors[i]._door_open == 0 && level.all_doors_open)
                zombie_doors[i] thread SetDoorsOpen();
        } 
    }
}



function func_hardcore() 
{
    if(!isDefined(level.gamevars["hardcore"]))
    {
        level.gamevars["hardcore"] = true;
        foreach(player in Getplayers()) 
        {
            player setClientUIVisibilityFlag("hud_visible", 0);
        }
    }
    else
    {
        level.gamevars["hardcore"] = undefined;        
        foreach(player in Getplayers()) 
        {
            player setClientUIVisibilityFlag("hud_visible", 1);
        }
    }
}
    
function moon_doors_supported()
{
    array = array("zm_sumpf", "zm_asylum", "zm_factory", "zm_theater", "zm_cosmodrome");

    if(isInArray(array, GetDvarString("mapname")))
        return true;

    return false;    
}

function SetDoorsOpen()
{
    while(isdefined(self.door_is_moving) && self.door_is_moving)
        wait .05;

    self zm_blockers::door_opened(0);
}

function SetDoorsClosed(Bool)
{
    while(isdefined(self.door_is_moving) && self.door_is_moving)
        wait .05;

    self zm_blockers::door_opened(0);

    if(!isDefined(Bool))
    {
        all_trigs = GetEntArray(self.target, "target");
        foreach(trig in all_trigs)
        {
            cost = (isdefined(self.zombie_cost) ? self.zombie_cost : 1000);
            trig zm_utility::set_hint_string(trig, "default_buy_door", cost);
            trig TriggerEnable(1);
        }
    }
}

function OpenAllDebris()
{
    if(isDefined(level.OpenAllDebris))
        return;

    iPrintLnBold("All Debris ^2Cleared");
    level.OpenAllDebris = true;
    zombie_debris = GetEntArray("zombie_debris", "targetname");
    foreach(debris in zombie_debris)
    {
        debris.zombie_cost = 0;
        debris notify("trigger", self, true);
    }
}

// Map Functions Giant

function giant_ee_extraperk() {
    s_scene = struct::get( "top_dial" );
    exploder::kill_exploder( "teleporter_controller_red_light_1" );
    exploder::exploder( "teleporter_controller_light_1" );
    s_scene thread scene::play();


    s_scene = struct::get( "middle_dial" );
    exploder::kill_exploder( "teleporter_controller_red_light_2" );
    exploder::exploder( "teleporter_controller_light_2" );
    s_scene thread scene::play();

    s_scene = struct::get( "bottom_dial" );
    exploder::kill_exploder( "teleporter_controller_red_light_3" );
    exploder::exploder( "teleporter_controller_light_3" );
    s_scene thread scene::play();

    S("Extra Perk Easter Egg ^5Ready");
}


function giant_clockModify(type) {
    clock = GetEnt( "factory_clock", "targetname" );
    if(type == "play") {
        clock thread scene::play( "p7_fxanim_zm_factory_clock_bundle" );
    } else if(type == "igc") {
        clock thread scene::play( "p7_fxanim_zm_factory_clock_igc_bundle" );
    } else if(type == "stop") {
        clock thread scene::stop();
    }
    S(getOptionName() + " ^5Successful");
}


function teleporterModification() {
    level.teleport_cost = 0;
    level.teleport_cooldown = 0;
    S("Teleporter is free now without any cooldown!");
}