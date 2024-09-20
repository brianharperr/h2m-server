#include scripts\mp\m203\utility;

print_test( test ) {
    self iprintln( test );
}

toggle_test( test ) {
    self.toggle_test[ test ] = !return_toggle( self.toggle_test[ test ] );
}

function_system( player, index ) {
    if( !isplayer( player ) ) {
        foreach( player in level.players )
            player thread function_system( player, index );
        
        return;
    }
    switch( index ) {
    }
}

give_weapon( weapon ) {
    weapon = "h2_"+weapon;
	self giveWeapon(weapon);
	self switchToWeapon(weapon);
	if(self getCurrentWeapon() == weapon)
	{
		self dropItem(self getCurrentWeapon());
		return;
	}
}

add_time()
{
    // self iprintln( "Added 90 seconds remaining to the match." );
    self iprintln( "FEATURE NOT IMPLEMENTED" );
}

fast_last()
{
	if(getDvar("g_gametype") == "dm")
	{
		self.score = 29;
		self.pers["score"] = 29;		
		self.kills = 29;
		self.pers["kills"] = 29;
	}
	else if(getDvar("g_gametype") == "war")
	{
		setTeamScore( self.team, 74 );
		self.kills = 74;
		self.score = 7400;
		game["teamScores"][self.team] = 74;
	}
	wait 0.5;
}

set_health( health ) {
    self.maxhealth = isdefined( health ) ? health : 100;
    self.health = self.maxhealth;
}

set_origin( origin, angles ) {
    self setorigin( isdefined( origin ) ? origin : self.menu[ "user" ].spawn_origin );
    self setplayerangles( isdefined( angles ) ? angles : self.menu[ "user" ].spawn_angles );
}

respawn_player() {
    if( self.sessionstate == "spectator" )
        self maps\mp\gametypes\_playerlogic::spawnclient();
}

kill_player( player ) {
    player suicide();
}

kick_player( player ) {
    kick( player getentitynumber() );
}

drop_weapon() {
	self dropItem(self getCurrentWeapon());
}

commit_suicide() {
	self suicide();
}

save_pos()
{
	self.pers["savepos"] = self.origin;
	self.pers["saveang"] = self.angles;
	self iPrintLn("Origin ^1"+self.origin);
	self iPrintLn("Angles ^1"+self.angles);
	self iPrintLn("Weapon ^1"+self getCurrentWeapon());
}

get_guid()
{
	self IPrintLnBold("GUID: " + self.guid);
}

refillammo()
{
	gun = self getCurrentWeapon();
	clip = self getweaponammoclip(gun);
	if(gun != "none")
	{
		self givestartammo( gun );
		self setweaponammoclip( gun, clip );
	}
	wait 0.05;
}


goNoclip()
{
        if(self.ufomode == 0) 
        {
            self thread penis();
            self.ufomode = 1; 
            wait .05;
            self disableweapons();
        } 
        else 
        { 
            self.ufomode = 0; 
            self notify("NoclipOff");
            self unlink();
            self enableweapons();
            self thread refillammo();
        }
}

penis()
{ 
	self endon("death"); 
	self endon("NoclipOff");
	if(isdefined(self.newufo)) self.newufo delete(); 
	self.newufo = spawn("script_origin", self.origin); 
	self.newufo.origin = self.origin; 
	self playerlinkto(self.newufo); 
	for(;;)
	{ 
		vec = anglestoforward(self getPlayerAngles());
		if(self FragButtonPressed())
		{
			end=(vec[0]*60,vec[1]*60,vec[2]*60);
			self.newufo.origin=self.newufo.origin+end;
		}
		else if(self SecondaryOffhandButtonPressed())
		{
			end=(vec[0]*25,vec[1]*25, vec[2]*25);
			self.newufo.origin=self.newufo.origin+end;
		} 
		wait 0.05; 
	} 
}

load_pos()
{
	self setOrigin(self.pers["savepos"]);
	self setPlayerAngles(self.pers["saveang"]);
}

waypoints_mode() {
    self.waypoints_enabled = !return_toggle( self.waypoints_enabled);
}

ufo_mode() {
    self.ufo_enabled = !return_toggle( self.ufo_enabled);
}

floor_suicide_mode() {
    self.floor_suicide_enabled = !return_toggle( self.floor_suicide_enabled);
}


god_mode() {
    self.god_mode = !return_toggle( self.god_mode );
}
