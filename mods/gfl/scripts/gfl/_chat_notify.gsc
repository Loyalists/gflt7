#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\music_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\system_shared;

#using scripts\gfl\_clientdvar;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace chat_notify;

REGISTER_SYSTEM_EX( "chat_notify", &__init__, &__main__, undefined )

function private __init__()
{
	callback::on_connect( &chat_notify );
    chat_notify::register_chat_notify_callback( &down_yourself, "s" );
    chat_notify::register_chat_notify_callback( &chathelp, "help" );
    chat_notify::register_chat_notify_callback( &chathelp, "?" );

    chat_LastMs = GetDvarInt("chat_LastMs", 0);
    SetDvar("chat_LastMs", chat_LastMs + 1);
}

function private __main__()
{

}

function chat_notify()
{
    self endon("disconnect");
	level endon("game_ended");
	level endon("end_game");

    level flagsys::wait_till("load_main_complete");

    // self thread chat_notify_test();
    while(1)
    {
        self waittill("menuresponse", menu, response);
        // self IPrintLnBold("msg received");
        if( IsSubStr(response,"ChatNotify") && menu == "popup_leavegame" )
        {
            chatArray = StrTok(response, "…");
            // IPrintLnBold(self.name + " is saying " + chatArray[1]);
            if(chatArray[1][0] == "/")
            {
                self thread exec_chatCMD(chatArray[1]);
            }
            else
            {
                result_text = chatArray[1];
                if(IsSubStr(chatArray[1],"¨"))
                {
                    rawtext = StrTok(chatArray[1], "¨");
                    output_text = "";
                    foreach(text in rawtext)
                    {
                        output_text += text;
                        output_text += " ";
                    }
                    result_text = output_text;
                }

                self notify("start_chat_sub", result_text);
            }
        }
        WAIT_SERVER_FRAME;
    }
}

function chat_notify_test()
{
    self endon("disconnect");
	level endon("game_ended");
	level endon("end_game");

    while(1)
    {
        chat_LastMs = GetDvarInt("chat_LastMs", 0);
        // chat_last_xuid = GetDvarString("chat_last_xuid", "");
        // chat_last_fullname = GetDvarString("chat_last_fullname", "");
        // chat_last_text = GetDvarString("chat_last_text", "");
        self IPrintLnBold(chat_LastMs);
        // self IPrintLnBold(chat_last_xuid);
        // self IPrintLnBold(chat_last_fullname);
        // self IPrintLnBold(chat_last_text);
        wait 2;
    }
}

function register_chat_notify_callback(callback, command)
{
	if(!isdefined(level.chat_notify_callbacks))
	{
		level.chat_notify_callbacks = [];
	}

	if(!isdefined(command))
	{
		return;
	}

	level.chat_notify_callbacks[command] = callback;
}

function process_chat_notify_callback(command, args)
{
	if(isdefined(level.chat_notify_callbacks))
	{
        callback = level.chat_notify_callbacks[command];
        if (isdefined(callback))
        {
            self thread [[callback]](args);
        }
	}
}

function exec_chatCMD(chat)
{
    chat = StrTok(chat, "/");

    for (i = 0; i < chat.size; i++) 
    {
        chat[i] = ToLower(chat[i]);
    }
    
    command = chat[0];
    if ( !isdefined(command) || command == "" )
    {
        return;
    }
    
    args = array::remove_index(chat, 0);
    self process_chat_notify_callback(command, args);
}

function down_yourself(args)
{
    self DoDamage(self.health, self.origin);
}

function chathelp(args)
{
    self notify("chathelp");
    self endon("chathelp");
    self endon("disconnect");
    self endon("death");
    self endon("entityshutdown");

    // if(isDefined(self.chathelp))
    // {
    //     self CloseLUIMenu(self.chathelp);
    //     wait 0.1;
    // }
    // self.chathelp = self hud::create_lui_text( &"EXT_HELP", 1, 200, 50, 720, (1,1,1) ,20 , "0,400,1");
    // wait 20;
    // self CloseLUIMenu(self.chathelp);
    usage_text = "usage: /[command]/[args]";
    desc_text = "commands: ";
    commands = GetArrayKeys(level.chat_notify_callbacks);
    foreach (cmd in commands)
    {
        desc_text += cmd;
        desc_text += " ";
    }
    self IPrintLnBold(usage_text);
    self IPrintLnBold(desc_text);
}