#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud;
#include maps\mp\gametypes\_hud_util;

init()
{
    level thread onPlayerConnect();
    level.onplayerdamage = ::onplayerdamage;
}

onplayerdamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{

    if(sweapon == "cheytac_mp" || sweapon == "barrett_mp" || sweapon == "wa2000_mp" || sweapon == "m21_mp"){
        self.health -= 100;
    }

}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);

        if(player is_bot())
        {
	    player thread botCantWin(); // by DoktorSAS
	    }

    }
}

onPlayerSpawn()
{
    self endon("disconnect";
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
        self shootFloorDie();
        self almostHitMessage();
        wait 0.5;
    }
}

shootFloorDie(){
    angles = self getPlayerAngles();
    weap = self getCurrentWeapon();
	self IPrintLn(angles);
	self IPrintLn(weap);
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
		self waittill("weapon_fired");
		
		if(self.pers["kills"] != level.scorelimit - 1) { // player kills != 4 
			continue;
		}
		
		start = self getTagOrigin("tag_eye");
		end = anglestoforward(self getPlayerAngles()) * 1000000;
		impact = BulletTrace(start, end, true, self)["position"];
		nearestDist = 150; // Higher nearestDist means bigger detection radius. If you change it, change it below too.
		
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