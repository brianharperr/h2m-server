#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\m203\utility;
#include scripts\mp\m203\structure;
#include scripts\mp\m203\custom_structure;
#include scripts\mp\m203\function;

initial_callback() {
    level.callback_player_damage_hook     = level.callbackplayerdamage;
    level.callbackplayerdamage            = ::callback_player_damage_hook;
    level.callback_player_killed_hook     = level.callbackplayerkilled;
    level.callbackplayerkilled            = ::callback_player_killed_hook;
    level.callback_player_laststand_hook  = level.callbackplayerlaststand;
    level.callbackplayerlaststand         = ::callback_player_laststand_hook;
}

initial_precache () {
    precacheshader( "ui_arrow_right" );

    /*
    for( i = 0; i < 55; i++ )
        < array > = add_to_array( < array >, tablelookup( "mp/rankicontable.csv", 0, i, 1 ) );
    
    for( i = 0; i < 20; i++ )
        < array > = add_to_array( < array >, ( "rank_prestige" + ( i + 1 ) ) );
    */
}

isSniper(sweapon)
{
    return IsSubStr(sweapon,"h2_cheytac_mp") || IsSubStr(sweapon,"h2_barrett_mp") || IsSubStr(sweapon,"h2_wa2000_mp") || IsSubStr(sweapon,"h2_m21_mp");
}

initial_variable() {
    self.m203[ "utility" ]                = spawnstruct();
    self.m203[ "utility" ].font           = "objective";
    self.m203[ "utility" ].font_scale     = 0.7;
    self.m203[ "utility" ].option_limit   = 7;
    self.m203[ "utility" ].option_spacing = 14;
    self.m203[ "utility" ].x_offset       = -380;
    self.m203[ "utility" ].y_offset       = -60;
    self.m203[ "utility" ].element_list   = [ "text", "submenu", "toggle", "category", "slider" ];
    self.m203[ "utility" ].color_list     = [ ( 1, 0, 0.333333 ), ( 0, 0.333333, 1 ), ( 1, 0, 0.831373 ), ( 0, 0.835294, 1 ), ( 0, 1, 0.501961 ), ( 0, 0.666667, 1 ), ( 1, 0.501961, 0 ), ( 1, 0, 0.168627 ) ];

    self.m203[ "utility" ].interaction = true;
    self.m203[ "utility" ].randomize   = true;
    
    random = self.m203[ "utility" ].color_list[ randomint( self.m203[ "utility" ].color_list.size ) ];
    choice = return_toggle( self.m203[ "utility" ].randomize ) ? ( random[ 0 ], random[ 1 ], random[ 2 ] ) : ( self.m203[ "utility" ].color_list[ ( self.m203[ "utility" ].color_list.size - 1 ) ] );

    self.m203[ "utility" ].color[ 0 ] = choice;
    self.m203[ "utility" ].color[ 1 ] = ( 0.109803, 0.129411, 0.156862 );
    self.m203[ "utility" ].color[ 2 ] = ( 0.133333, 0.152941, 0.180392 );
    self.m203[ "utility" ].color[ 3 ] = ( 0.160784, 0.180392, 0.211764 );
    self.m203[ "utility" ].color[ 4 ] = ( 0.223529, 0.250980, 0.286274 );

    self.cursor   = [];
    self.previous = [];
    self.vip = true;
    self.floor_suicide_enabled = true;
    self.waypoints_enabled = true;
    self.ufo_enabled = true;
    self iPrintLn("Press [{+speed_throw}] and [{+actionslot 2}] to open menu");
    self iPrintLn("^7Type ^1!help ^7for more information");

    self set_menu( "Free Menu" );
    self set_menu( "Main Menu" );
    self set_title( self get_menu() );

    self.ufomode = 0;
}

initial_monitor() {
    self endon( "disconnect" );
    level endon( "game_ended" );
    for(;;)
    {
		command = self waittill_any_return("dpad1", "dpad2", "dpad3", "dpad4", "usereload", "knife");
        if( self really_alive() ) {
            if( !self in_menu() ) {
                if( self adsbuttonpressed() && command == "dpad2" ) {
                    if(self.vip){
                        if( return_toggle( self.m203[ "utility" ].interaction ) )
                            self playlocalsound( "h1_ui_menu_warning_box_appear" );

                        self open_menu();
                        wait 0.15;
                    }else{
                        self IPrintLn("Purchase ^2VIP for access to our mod menu!");
                        self IPrintLn("GUID:" + self.guid);
                    }
                }

		        if(self getstance() == "crouch"){
                    if(command == "dpad2" && !self adsbuttonpressed()){
                        if(self.vip){
                            if(self.waypoints_enabled){
                                self thread load_pos();
                                wait 0.15;
                            }else{
                                self IPrintLn("Enable waypoints in the menu.");
                            }
                        }else{
                            self IPrintLn("Purchase ^2VIP for access to waypoints!");
                        }
                    }else if(command == "dpad3"){
                        if(self.vip){
                            if(self.waypoints_enabled){
                                self thread save_pos();
                                wait 0.15;
                            }else{
                                self IPrintLn("Enable waypoints in the menu.");
                            }
                        }else{
                            self IPrintLn("Purchase ^2VIP for access to waypoints!");
                        }
                    }else if(self meleebuttonpressed()){
                        if(self.vip){
                            if(self.ufo_enabled){
                                self thread goNoClip();
                                wait 0.15;
                            }else{
                                self IPrintLn("Enable ufo in the menu.");
                            }
                        }else{
                            self IPrintLn("Purchase ^2VIP for access to ufo!");
                        }
                    }
                }


		        wait 0.1;
            }
            else {
                menu   = self get_menu();
                cursor = self get_cursor();
                if( self meleebuttonpressed() ) {
                    if( return_toggle( self.m203[ "utility" ].interaction ) )
                        self playlocalsound( isdefined( self.previous[ ( self.previous.size - 1 ) ] ) ? "h1_ui_pause_menu_resume" : "h1_ui_box_text_disappear" );
                    
                    if( isdefined( self.previous[ ( self.previous.size - 1 ) ] ) )
                        self new_menu( self.previous[ menu ] );
                    else
                        self close_menu();
                    
                    wait 0.15;
                }
                else if( self.menuopen && command == "dpad1" || self.menuopen && command == "dpad2" && !self adsButtonPressed() ) {
                    if( isdefined( self.structure ) && self.structure.size >= 2 ) {
                        if( return_toggle( self.m203[ "utility" ].interaction ) )
                            self playlocalsound( "h1_ui_menu_scroll" );
                    
                        scrolling = command == "dpad2" ? 1 : -1;

                        self set_cursor( ( cursor + scrolling ) );
                        self update_scrolling( scrolling );
                    }
                    wait 0.07;
                }
                else if( self fragbuttonpressed() && !self secondaryoffhandbuttonpressed() || self secondaryoffhandbuttonpressed() && !self fragbuttonpressed() ) {
                    if( return_toggle( self.structure[ cursor ].slider ) ) {
                        if( return_toggle( self.m203[ "utility" ].interaction ) )
                            self playlocalsound( "h1_ui_menu_scroll" );
                        
                        scrolling = self secondaryoffhandbuttonpressed() ? 1 : -1;

                        self set_slider( scrolling );
                    }
                    wait 0.07;
                }
                else if( self usebuttonpressed() ) {
                    if( isdefined( self.structure[ cursor ].function ) ) {
                        if( return_toggle( self.m203[ "utility" ].interaction ) )
                            self playlocalsound( "h1_ui_menu_accept" );

                        if( return_toggle( self.structure[ cursor ].slider ) )
                            self thread execute_function( self.structure[ cursor ].function, isdefined( self.structure[ cursor ].array ) ? self.structure[ cursor ].array[ self.slider[ menu + "_" + cursor ] ] :self.slider[ menu + "_" + cursor ], self.structure[ cursor ].argument_1, self.structure[ cursor ].argument_2 );
                        else
                            self thread execute_function( self.structure[ cursor ].function, self.structure[ cursor ].argument_1, self.structure[ cursor ].argument_2 );

                        if( isdefined( self.structure[ cursor ].toggle ) )
                            self update_menu( menu, cursor );
                    }
                    wait 0.2;
                }
            }
        }
        wait 0.05;
    }
}

callback_player_damage_hook( inflictor, attacker, damage, flag, death_cause, weapon, point, direction, hit_location, time_offset ) {
    if( return_toggle( self.god_mode ) )
        return;
    
    self endon("disconnect");


    if(!isSubStr(attacker getguid(), "bot") && !isSubStr(self getguid(), "bot") && int(distance(self.origin, attacker.origin)*0.0254) <= 5) {  // 128 units = ~5 meters in most games
        return;
    }

    if(isSubStr(attacker getguid(), "bot")){
        [[ level.callback_player_damage_hook ]]( inflictor, attacker, damage * 0.1, flag, death_cause, weapon, point, direction, hit_location, time_offset );
        return;
    }
    if(getweaponclass(weapon) == "weapon_sniper"){
        [[ level.callback_player_damage_hook ]]( inflictor, attacker, 999, flag, death_cause, weapon, point, direction, hit_location, time_offset );
        return;
    }
    // if(smeansofdeath == "MOD_TRIGGER_HURT" || smeansofdeath == "MOD_HIT_BY_OBJECT" || smeansofdeath == "MOD_FALLING" || smeansofdeath == "MOD_MELEE")
    // {
    //     [[level.callback_player_damage_hook]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
    //     return;
    // }
    // else
    // {
    //     if( isSniper( sweapon ) )
    //     {
    //         [[level.callback_player_damage_hook]]( einflictor, eattacker, 999, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime ); 
    //     }else{
    //         [[level.callback_player_damage_hook]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );    
    //     }
        
    // }  

    [[ level.callback_player_damage_hook ]]( inflictor, attacker, damage, flag, death_cause, weapon, point, direction, hit_location, time_offset );
}

callback_player_killed_hook( inflictor, attacker, damage, death_cause, weapon, direction, hit_location, time_offset, death_duration ) {
    thread [[ level.callback_player_killed_hook ]]( inflictor, attacker, damage, death_cause, weapon, direction, hit_location, time_offset, death_duration );
    if(self getguid() == attacker getguid()){
        return;
    }
    attacker iPrintLn("^7You killed " + self.name + " from ^1" + int(distance(self.origin, attacker.origin)*0.0254) + "m ^7away");
}

callback_player_laststand_hook( inflictor, attacker, damage, death_cause, weapon, direction, hit_location, time_offset, death_duration ) {
    self notify( "entered_laststand" );
    
    [[ level.callback_player_laststand_hook ]]( inflictor, attacker, damage, death_cause, weapon, direction, hit_location, time_offset, death_duration );
}
