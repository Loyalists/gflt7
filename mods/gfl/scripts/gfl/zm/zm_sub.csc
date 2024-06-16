#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\callbacks_shared;

#insert scripts\shared\shared.gsh;

#namespace zm_sub;

REGISTER_SYSTEM_EX( "zm_sub", &__init__, &__main__, undefined )

function private __init__()
{
    util::register_system( "sendsub", &subtitlesMessage );
}

function private __main__()
{

}

function subtitlesMessage( n_local_client_num, message ) 
{
	//player = getlocalplayer(n_local_client_num);
    //player.currentsubtitle[n_local_client_num] = undefined;
    message_og = message;
    if(IsSubStr( message, "…" ))
    {
        tokenized = StrTok(message, "…");
        message = "^7";
        foreach(string in tokenized)
        {
            message += MakeLocalizedString( string ); 
            message += "^7";
        }
    }
    time = calculate_time(message_og);
    /*player.currentsubtitle[n_local_client_num] =*/ SubtitlePrint(n_local_client_num, time, message);
}

function calculate_time(message)
{
    calc_time = 75 * message.size;

    return calc_time;

}