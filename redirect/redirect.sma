/*
Redirect Plugin
vim: set ft=cs :

Very simple redirect plugin.

CVARs:
  redirect_maxplayers <x>      // - begin redirection when more x players connected ( 0 = redirect all players )
  redirect_server <ip>         // - redirect server "ip" or "ip:port" string
*/

#include <amxmodx>

new g_redirect_maxplayers;
new g_redirect_server[32];

public plugin_init() {
    register_plugin("Redirect","1.03","Bor")
    register_cvar("redirect_maxplayers","0")
    register_cvar("redirect_server","")
    g_redirect_maxplayers = get_cvar_num("redirect_maxplayers")
    get_cvar_string("redirect_server",g_redirect_server,31)
    if ( strlen(g_redirect_server) <= 0 )
        set_fail_state("Bad server IP CVar")
    return PLUGIN_CONTINUE
}

public client_authorized(id) {
    if ( is_user_bot(id) || is_user_hltv_detect(id) )
        return PLUGIN_CONTINUE
    if ( get_user_flags(id) & ADMIN_RESERVATION )
        return PLUGIN_CONTINUE
    if ( get_playersnum() < g_redirect_maxplayers )
        return PLUGIN_CONTINUE
    new name[32], authid[32]
    get_user_name(id, name, 31)
    get_user_authid(id, authid, 31)
    log_message("[Redirect] %s <%s> to %s", name, authid, g_redirect_server)
    client_cmd(id,"echo ^"[AMXX] Redirecting to %s^"",g_redirect_server)
    client_cmd(id,"Connect %s",g_redirect_server)
    return PLUGIN_HANDLED
}

stock is_user_hltv_detect(id) {
    if ( is_user_connected(id) )
        return is_user_hltv(id)
    new is_hltv[2]
    get_user_info(id, "*hltv", is_hltv, 1)
    return equal(is_hltv, "1") ? 1 : 0
}

