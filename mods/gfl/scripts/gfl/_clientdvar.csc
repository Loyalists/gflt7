#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace clientdvar;

function autoexec init()
{
    util::register_system( "elmg_clientdvar", &clientdvar_logic );
}

function clientdvar_logic( n_local_client_num, dvar ) 
{
        if(IsSubStr( dvar, "," ))
        {
            tokenized = StrTok(dvar, ",");
            dvarh = tokenized[0];
            dvarv = tokenized[1];
            setdvar(dvarh,dvarv);
        }
}