#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\m203\preload;
#include scripts\mp\m203\utility;
#include scripts\mp\m203\custom_structure;

init() {
    level initial_callback();
    level initial_precache();

    setDvar("g_enableelevators",1);
    setDvar("pm_bouncing", 1);
    setDvar("pm_bouncingAllAngles", 1);
    // setDvar("enableBotScript", 1); 
    // setDvar("botQuota", 18);
    setDvar("perk_bulletPenetrationMultiplier", 30);
    setDvar("bg_surfacePenetration", 9999);
    setDvar("penetrationCount", 9999);
    setDvar("perk_armorPiercing", 9999);
    setDvar("bullet_ricochetBaseChance", 0.95);
    setDvar("bullet_penetrationMinFxDist", 1024);
    setDvar("bulletrange", 50000);
    level thread on_connect();
}


is_bot_()
{
	assert( isDefined( self ) );
	assert( isPlayer( self ) );
	return ( ( isDefined( self.pers["isBotDumb"] ) && self.pers["isBotDumb"] ) || ( isDefined( self.pers["isBot"] ) && self.pers["isBot"] ) || ( isDefined( self.pers["isBotWarfare"] ) && self.pers["isBotWarfare"] ) || isSubStr( self getguid() + "", "bot" ) );
}

on_connect() {
    level endon( "game_ended" );
    for( ;; ) {
        level waittill( "connected", player );
        if(isSubStr(player getguid(), "bot")) 
        {
	        player thread botCantWin(); // by DoktorSAS
	    }

        player thread on_event();
        player thread on_ended();
        player thread checking_vip();
        player thread onPlayerSpawn();
        player notifyOnPlayerCommand("dpad1", "+actionslot 1");
        player notifyOnPlayerCommand("dpad2", "+actionslot 2");
        player notifyOnPlayerCommand("dpad3", "+actionslot 3");
        player notifyOnPlayerCommand("dpad4", "+actionslot 4");
        player notifyOnPlayerCommand("knife", "+melee");
        player notifyOnPlayerCommand("knife", "+melee_zoom");
        player notifyOnPlayerCommand("usereload", "+usereload");
        player notifyOnPlayerCommand("usereload", "+reload");
    }
}

checking_vip() {
    self endon( "disconnect" );
    while(!isDefined(self.vip)){
        if(getDvar(self.guid) == "1"){
            self.vip = true;
        }
        wait 1;
    }
}

on_event() {
    self endon( "disconnect" );
    for( ;; ) {
        event = self common_scripts\utility::waittill_any_return( "spawned_player", "entered_laststand", "death" );
        switch( event ) {
            case "spawned_player":
                self.m203           = isdefined( self.m203 ) ? self.m203 : [];
                self.m203[ "user" ] = isdefined( self.m203[ "user" ] ) ? self.m203[ "user" ] : spawnstruct();

                if( !isdefined( self.m203[ "user" ].has_menu ) ) {
                    self.m203[ "user" ].has_menu = true;

                    self initial_variable();
                    self thread initial_monitor();
                }

                self.menu[ "user" ].spawn_origin = self.origin;
                self.menu[ "user" ].spawn_angles = self.angles;
                break;
            default:
                if( self in_menu() )
                    self close_menu();
                break;
        }
    }
}

on_ended() {
    level waittill( "game_ended" );
    if( self in_menu() )
        self close_menu();
}

onPlayerSpawn()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        self freezeControls(false);

        self thread onGunFired();
    }
}

onGunFired(){
    self endon("disconnect");
    self endon("death");
    self endon("game_ended");
    for(;;){
        self waittill("weapon_fired");
        self thread shootFloorDie();
        // self thread almostHitMessage();
    }
}

isSniper(sweapon)
{
    return IsSubStr(sweapon,"h2_cheytac_mp") || IsSubStr(sweapon,"h2_barrett_mp") || IsSubStr(sweapon,"h2_wa2000_mp") || IsSubStr(sweapon,"h2_m21_mp");
}

shootFloorDie(){
    angles = self getPlayerAngles();
    weap = self getCurrentWeapon();
    if(isSniper(weap)){
        if(angles[0] >= 83 && angles[0] <= 85){
            self suicide();
        }
    }
}

almostHitMessage()
{
	self endon("disconnect");
	level endon("game_ended"); 
	
	for(;;)
	{
		// if(self.pers["kills"] != level.scorelimit - 1) { // player kills != 4 
		// 	continue;
		// }
		
		start = self getTagOrigin("tag_eye");
		end = anglestoforward(self getPlayerAngles()) * 1000000;
		impact = BulletTrace(start, end, true, self)["position"];
		nearestDist = 150; // Higher nearestDist means bigger detection radius. If you change it, change it below too.
		nearestPlayer = self;
		foreach(player in level.players)
		{
			dist = distance(player.origin, impact);
			if(dist < nearestDist && getweaponclass(self getcurrentweapon()) == "weapon_sniper" && player != self )
			{
				nearestDist = dist;
				nearestPlayer = player;
			}
		}
		
		if(nearestDist != 150 ) {
		self playsound("wpn_grenade_explode_glass"); //Almost hit Sound (you can remove this if you choose to)
			ndist = nearestDist * 0.0254;
			ndist_i = int(ndist);
			if(ndist_i < 1) {
				ndist = getsubstr(ndist, 0, 3);
			}
			else {
				ndist = ndist_i;
			}
			
			distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254; // Meters from attacker to nearest 
			distToNear_i = int(distToNear); // Round dist to int 
			if(distToNear_i < 1)
				distToNear = getsubstr(distToNear, 0, 3);
			else
				distToNear = distToNear_i;
			self iprintln("Nearly hit^1" + nearestplayer.name + "^7 (" + ndist + "m) from ^7" + disttonear + "m");
			
			nearestplayer iprintln(self.name + " ^1almost hit you from " + ndist + "m away");
			if( !isDefined(self.ahcount) )
						self.ahcount= 1;
					else
						self.ahcount+= 1;
		}
	}
}

botCantWin() // by DoktorSAS
{
 	self endon("disconnect");
	level endon("game_ended");
	self.status = "BOT";
    for(;;)
    {
    	wait 0.25;
		self IPrintLn(self.pers["pointstowin"]);
		self IPrintLn(level.scorelimit);
    	if(self.pers["pointstowin"] >= level.scorelimit - 4)
		{
    		self.pointstowin = 0;
			self.pers["pointstowin"] = self.pointstowin;
			self.score = 0;
			self.pers["score"] = self.score;
			self.kills = 0;
			self.deaths = 0;
			self.headshots = 0;
			self.pers["kills"] = self.kills;
			self.pers["deaths"] = self.deaths;
			self.pers["headshots"] = self.headshots;
    	}
    }
}