#include scripts\mp\m203\utility;
#include scripts\mp\m203\structure;
#include scripts\mp\m203\function;

menu_index() {
    menu = self get_menu();

    switch( menu ) {
        case "Main Menu":
            self add_menu( "OffDaPorch Menu" );

            // self add_increment( "Set Health", ::set_health, 100, 100, 10000, 100 );
            if(getDvar("g_gametype") == "dm" || getDvar("g_gametype") == "war"){
                self add_option( "Fast Last", ::fast_last);
            }
            
            self add_option( "Game Options", ::new_menu, "Game Options" );
            self add_option( "Weapons", ::new_menu, "Weapons" );
            self add_option( "Drop Weapon", ::drop_weapon);
            self add_option( "Suicide" , ::commit_suicide);
            self add_toggle( "Enable Waypoints", ::waypoints_mode, self.waypoints_enabled );
            self add_toggle( "Enable UFO", ::ufo_mode, self.ufo_enabled );
            self add_toggle( "Enable Sniper Floor Suicide", ::floor_suicide_mode, self.floor_suicide_enabled );
            self add_option( "Get GUID", ::get_guid );
            break;
        case "Game Options":
            self add_menu( menu );
            self add_option( "Add Time", ::add_time, "Add Time" );
            break;
        case "Weapons":
            self add_menu( menu );
            self add_option( "Assault Rifles", ::new_menu, "Assault Rifles" );
            self add_option( "Submachine Guns", ::new_menu, "Submachine Guns" );
            self add_option( "Lightmachine Guns", ::new_menu, "Lightmachine Guns" );
            self add_option( "Sniper Rifles", ::new_menu, "Sniper Rifles" );
            self add_option( "Machine Pistols", ::new_menu, "Machine Pistols" );
            self add_option( "Shotguns", ::new_menu, "Shotguns" );
            self add_option( "Handguns", ::new_menu, "Handguns" );
            self add_option( "Launchers", ::new_menu, "Launchers" );
            self add_option( "Other", ::new_menu, "Other" );
            break;
        case "Assault Rifles":
            self add_menu( menu );
            self add_option( "M4A1", ::give_weapon, "m4_mp" );
            self add_option( "FAMAS", ::give_weapon, "famas_mp" );
            self add_option( "SCAR-H", ::give_weapon, "scar_mp" );
            self add_option( "TAR-21", ::give_weapon, "tavor_mp" );
            self add_option( "FAL", ::give_weapon, "fal_mp" );
            self add_option( "M16A4", ::give_weapon, "m16_mp" );
            self add_option( "ACR", ::give_weapon, "masada_mp" );
            self add_option( "F2000", ::give_weapon, "fn2000_mp" );
            self add_option( "AK47", ::give_weapon, "ak47_mp" );
            break;
        case "Submachine Guns":
            self add_menu( menu );
            self add_option( "MP5K", ::give_weapon, "mp5k_mp");
            self add_option( "UMP45", ::give_weapon, "ump45_mp");
            self add_option( "Vector", ::give_weapon, "kriss_mp");
            self add_option( "P90", ::give_weapon, "p90_mp");
            self add_option( "Mini-Uzi", ::give_weapon, "uzi_mp");
            break;
        case "Lightmachine Guns":
            self add_menu( menu );
            self add_option( "L86 LSW", ::give_weapon, "sa80_mp");
            self add_option( "RPD", ::give_weapon, "rpd_mp");
            self add_option( "MG4", ::give_weapon, "mg4_mp");
            self add_option( "AUG HBAR", ::give_weapon, "aug_mp");
            self add_option( "M240", ::give_weapon, "m240_mp");
            break;
        case "Sniper Rifles":
            self add_menu( menu );
            self add_option( "Intervention", ::give_weapon, "cheytac_mp");
            self add_option( "Barrett .50cal", ::give_weapon, "barrett_mp");
            self add_option( "WA2000", ::give_weapon, "wa2000_mp");
            self add_option( "M21 EBR", ::give_weapon, "m21_mp");
            break;
        case "Machine Pistols": 
            self add_menu( menu );
            self add_option( "PP2000", ::give_weapon, "pp2000_mp");
            self add_option( "G18", ::give_weapon, "glock_mp");
            self add_option( "M93 Raffica", ::give_weapon, "beretta393_mp");
            self add_option( "TMP", ::give_weapon, "tmp_mp");
            break;
	    case "Shotguns":
            self add_menu( menu );
            self add_option( "SPAS-12", ::give_weapon, "spas12_mp");
            self add_option( "AA-12", ::give_weapon, "aa12_mp");
            self add_option( "Striker", ::give_weapon, "striker_mp");
            self add_option( "Ranger", ::give_weapon, "ranger_mp");
            self add_option( "M1014", ::give_weapon, "m1014_mp");
            self add_option( "Model 1887", ::give_weapon, "model1887_mp");
            break;
        case "Handguns":
            self add_menu( menu );
            self add_option( "USP", ::give_weapon, "usp_mp");
            self add_option( "44 Magnum", ::give_weapon, "coltanaconda_mp");
            self add_option( "M9", ::give_weapon, "beretta_mp");
            self add_option( "Desert Eagle", ::give_weapon, "deserteagle_mp");
            self add_option( "Gold Desert Eagle", ::give_weapon, "deserteaglegold_mp");
            break;
        case "Launchers":
            self add_menu( menu );
            self add_option( "AT4-HS", ::give_weapon, "at4_mp");
            self add_option( "Thumper", ::give_weapon, "m79_mp");
            self add_option( "Stinger", ::give_weapon, "stinger_mp");
            self add_option( "Javelin", ::give_weapon, "javelin_mp");
            self add_option( "RPG", ::give_weapon, "rpg_mp");
            break;
        case "Other":
            self add_menu( menu );
            self add_option( "Riot Shield", ::give_weapon, "riotshield_mp");
            self add_option( "Laptop", ::give_weapon, "killstreak_predator_missile_mp");
            self add_option( "C4 Detonator", ::give_weapon, "c4_mp");
            self add_option( "Bomb", ::give_weapon, "briefcase_bomb_defuse_mp");
            self add_option( "OMA Bag", ::give_weapon, "onemanarmy_mp");
            break;
    }
}
