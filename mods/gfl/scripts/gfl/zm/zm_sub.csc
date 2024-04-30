#using scripts\shared\util_shared;

#namespace zm_sub;

function autoexec init()
{
    util::register_system( "sendsub", &subtitlesMessage );
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