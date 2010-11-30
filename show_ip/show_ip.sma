/*
Show IP
vim: set ft=cs :

This plugin show player's IP.

 Use:
    amx_ip <name>   // show ip for player 'name'
    amx_ip @<C|T>   // show ip for such team
    amx_ip *        // show all ip's

*/

#include <amxmodx>
#include <amxmisc>


public plugin_init() {
    register_plugin("Show IP","1.01","Bor");
    register_concmd("amx_ip","show_ip",ADMIN_KICK,"<player, @TEAM , *>");
    return PLUGIN_CONTINUE;
}


public show_ip(id, level, cid) {
    if(!cmd_access(id, level, cid, 2))
        return PLUGIN_HANDLED;

    new Arg[36];
    new szIP[46], szName[36];
    new Players[32], pnum;
    read_argv(1, Arg , 35);

    if (Arg[0] == '@') {
        switch( Arg[1] ) {
            case 'C' , 'c': {
                console_print(id , "[AMXX] IP print out for CT team");
                get_players(Players , pnum , "ce" , "CT");
                for (new i = 0; i < pnum; i++) {
                    get_user_ip(Players[i] , szIP , 45 , 1);
                    get_user_name(Players[i] , szIP , 35);
                    console_print(id , "%d) %s     - %s", (i + 1) , szName , szIP);
                }
            }
            case 'T' , 't': {
                console_print(id , "[AMXX] IP print out for T team");
                get_players(Players , pnum , "ce" , "TERRORIST");
                for (new i = 0; i < pnum; i++) {
                    get_user_ip(Players[i] , szIP , 45 , 1);
                    get_user_name(Players[i] , szIP , 35);
                    console_print(id , "%d) %s     - %s", (i + 1) , szName , szIP);
                }
            }
        }
    }
    else if(equal( Arg , "*")) {
        get_players( Players , pnum , "c");
        console_print(id , "[AMXX] IP print out for all players");
        for (new i=0; i < pnum; i++) {
            get_user_ip(Players[i],szIP , 45 , 1);
            get_user_name(Players[i] , szName , 35);
            console_print(id , "%d) %s     - %s", (i + 1), szName , szIP);
        }
    }
    else {
        new Target = cmd_target(id , Arg , 10);
        if (!is_user_connected(Target))
            return PLUGIN_HANDLED;
        get_user_ip( Target , szIP , 45 , 1);
        get_user_name( Target , szName , 35);
        console_print( id , "[AMXX] %s's IP address : %s", szName , szIP);
    }
    return PLUGIN_HANDLED;
}

