#include scripts\mp\m203\utility;
#include scripts\mp\m203\utility_element;
#include scripts\mp\m203\structure;
#include scripts\mp\m203\menu_index;

open_menu() {
    self.m203[ "hud" ]                      = [];
    self.m203[ "hud" ][ "title" ]           = self create_text( self get_title(), self.m203[ "utility" ].font, self.m203[ "utility" ].font_scale, "TOP_LEFT", "CENTER", ( self.m203[ "utility" ].x_offset + 4 ), ( self.m203[ "utility" ].y_offset + 2 ), self.m203[ "utility" ].color[ 4 ], 1, 10 );
    self.m203[ "hud" ][ "background" ][ 0 ] = self create_shader( "white", "TOP_LEFT", "CENTER", self.m203[ "utility" ].x_offset, ( self.m203[ "utility" ].y_offset - 1 ), 202, 30, self.m203[ "utility" ].color[ 0 ], 1, 1 );
    self.m203[ "hud" ][ "background" ][ 1 ] = self create_shader( "white", "TOP_LEFT", "CENTER", ( self.m203[ "utility" ].x_offset + 1 ), self.m203[ "utility" ].y_offset, 200, 28, self.m203[ "utility" ].color[ 1 ], 1, 2 );
    self.m203[ "hud" ][ "foreground" ][ 0 ] = self create_shader( "white", "TOP_LEFT", "CENTER", ( self.m203[ "utility" ].x_offset + 1 ), ( self.m203[ "utility" ].y_offset + 14 ), 200, 14, self.m203[ "utility" ].color[ 2 ], 0.8, 3 );
    self.m203[ "hud" ][ "foreground" ][ 1 ] = self create_shader( "white", "TOP_LEFT", "CENTER", ( self.m203[ "utility" ].x_offset + 1 ), ( self.m203[ "utility" ].y_offset + 14 ), 194, 14, self.m203[ "utility" ].color[ 3 ], 1, 4 );
    self.m203[ "hud" ][ "foreground" ][ 2 ] = self create_shader( "white", "TOP_RIGHT", "CENTER", ( self.m203[ "utility" ].x_offset + 201 ), ( self.m203[ "utility" ].y_offset + 14 ), 4, 14, self.m203[ "utility" ].color[ 3 ], 1, 4 );

    self create_option();
    self set_state();
}

close_menu() {
    self clear_option();
    self clear_all( self.m203[ "hud" ] );
    self set_state();
}

create_title( title ) {
    self.m203[ "hud" ][ "title" ] set_text( isdefined( title ) ? title : self get_title() );
}

create_option() {
    self clear_option();
    self menu_index();
    if( !isdefined( self.structure ) || !self.structure.size )
        self add_option( "Currently No Options To Display" );
    
    if( !isdefined( self get_cursor() ) )
        self set_cursor( 0 );
    
    start = 0;
    if( ( self get_cursor() > int( ( ( self.m203[ "utility" ].option_limit - 1 ) / 2 ) ) ) && ( self get_cursor() < ( self.structure.size - int( ( ( self.m203[ "utility" ].option_limit + 1 ) / 2 ) ) ) ) && ( self.structure.size > self.m203[ "utility" ].option_limit ) )
        start = ( self get_cursor() - int( ( self.m203[ "utility" ].option_limit - 1 ) / 2 ) );
    
    if( ( self get_cursor() > ( self.structure.size - ( int( ( ( self.m203[ "utility" ].option_limit + 1 ) / 2 ) ) + 1 ) ) ) && ( self.structure.size > self.m203[ "utility" ].option_limit ) )
        start = ( self.structure.size - self.m203[ "utility" ].option_limit );
    
    self create_title();
    if( isdefined( self.structure ) && self.structure.size ) {
        limit = min( self.structure.size, self.m203[ "utility" ].option_limit );
        for( i = 0; i < limit; i++ ) {
            index      = ( i + start );
            cursor     = ( self get_cursor() == index );
            color[ 0 ] = cursor ? self.m203[ "utility" ].color[ 0 ] : self.m203[ "utility" ].color[ 4 ];
            color[ 1 ] = return_toggle( self.structure[ index ].toggle ) ? cursor ? self.m203[ "utility" ].color[ 0 ] : self.m203[ "utility" ].color[ 4 ] : cursor ? self.m203[ "utility" ].color[ 2 ] : self.m203[ "utility" ].color[ 1 ];
            if( isdefined( self.structure[ index ].function ) && self.structure[ index ].function == ::new_menu )
                self.m203[ "hud" ][ "submenu" ][ index ] = self create_shader( "ui_arrow_right", "TOP_RIGHT", "CENTER", ( self.m203[ "utility" ].x_offset + 192 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 19 ) ), 4, 4, color[ 0 ], 1, 10 );
            
            if( isdefined( self.structure[ index ].toggle ) )
                self.m203[ "hud" ][ "toggle" ][ index ] = self create_shader( "white", "TOP_LEFT", "CENTER", ( self.m203[ "utility" ].x_offset + 4 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 17 ) ), 8, 8, color[ 1 ], 1, 10 );
            
            if( return_toggle( self.structure[ index ].slider ) ) {
                if( isdefined( self.structure[ index ].array ) )
                    self.m203[ "hud" ][ "slider" ][ 0 ][ index ] = self create_text( self.structure[ index ].array[ self.slider[ self get_menu() + "_" + index ] ], self.m203[ "utility" ].font, self.m203[ "utility" ].font_scale, "TOP_RIGHT", "CENTER", ( self.m203[ "utility" ].x_offset + 190 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 16 ) ), color[ 0 ], 1, 10 );
                else {
                    if( cursor )
                        self.m203[ "hud" ][ "slider" ][ 0 ][ index ] = self create_text( self.slider[ self get_menu() + "_" + index ], self.m203[ "utility" ].font, ( self.m203[ "utility" ].font_scale - 0.1 ), "CENTER", "CENTER", ( self.m203[ "utility" ].x_offset + 166 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 21 ) ), self.m203[ "utility" ].color[ 4 ], 1, 10 );
                    
                    self.m203[ "hud" ][ "slider" ][ 1 ][ index ] = self create_shader( "white", "TOP_RIGHT", "CENTER", ( self.m203[ "utility" ].x_offset + 191 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 17 ) ), 50, 8, cursor ? self.m203[ "utility" ].color[ 2 ] : self.m203[ "utility" ].color[ 1 ], 1, 8 );
                    self.m203[ "hud" ][ "slider" ][ 2 ][ index ] = self create_shader( "white", "TOP_RIGHT", "CENTER", ( self.m203[ "utility" ].x_offset + 149 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 17 ) ), 8, 8, cursor ? self.m203[ "utility" ].color[ 0 ] : self.m203[ "utility" ].color[ 3 ], 1, 9 );
                }

                self set_slider( undefined, index );
            }
            
            if( return_toggle( self.structure[ index ].category ) ) {
                self.m203[ "hud" ][ "category" ][ 0 ][ index ] = self create_text( self.structure[ index ].text, self.m203[ "utility" ].font, self.m203[ "utility" ].font_scale, "CENTER", "CENTER", ( self.m203[ "utility" ].x_offset + 98 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 21 ) ), self.m203[ "utility" ].color[ 0 ], 1, 10 );
                self.m203[ "hud" ][ "category" ][ 1 ][ index ] = self create_shader( "white", "TOP_LEFT", "CENTER", ( self.m203[ "utility" ].x_offset + 4 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 21 ) ), 30, 1, self.m203[ "utility" ].color[ 0 ], 1, 10 );
                self.m203[ "hud" ][ "category" ][ 2 ][ index ] = self create_shader( "white", "TOP_RIGHT", "CENTER", ( self.m203[ "utility" ].x_offset + 193 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 21 ) ), 30, 1, self.m203[ "utility" ].color[ 0 ], 1, 10 );
            }
            else
                self.m203[ "hud" ][ "text" ][ index ] = self create_text( return_toggle( self.structure[ index ].slider ) ? self.structure[ index ].text + ":" : self.structure[ index ].text, self.m203[ "utility" ].font, self.m203[ "utility" ].font_scale, "TOP_LEFT", "CENTER", isdefined( self.structure[ index ].toggle ) ? ( self.m203[ "utility" ].x_offset + 15 ) : ( self.m203[ "utility" ].x_offset + 4 ), ( self.m203[ "utility" ].y_offset + ( ( i * self.m203[ "utility" ].option_spacing ) + 16 ) ), color[ 0 ], 1, 10 );
        }

        if( !isdefined( self.m203[ "hud" ][ "text" ][ self get_cursor() ] ) )
            self set_cursor( ( self.structure.size - 1 ) );
    }

    self update_resize();
}

update_scrolling( scrolling ) {
    if( return_toggle( self.structure[ self get_cursor() ].category ) ) {
        self set_cursor( ( self get_cursor() + scrolling ) );
        return self update_scrolling( scrolling );
    }

    if( ( self.structure.size > self.m203[ "utility" ].option_limit ) || ( self get_cursor() >= 0 ) || ( self get_cursor() <= 0 ) ) {
        if( ( self get_cursor() >= self.structure.size ) || ( self get_cursor() < 0 ) )
            self set_cursor( ( self get_cursor() >= self.structure.size ) ? 0 : ( self.structure.size - 1 ) );
        
        self create_option();
    }

    self update_resize();
}

update_resize() {
    limit    = min( self.structure.size, self.m203[ "utility" ].option_limit );
    height   = int( ( limit * self.m203[ "utility" ].option_spacing ) );
    adjust   = ( self.structure.size > self.m203[ "utility" ].option_limit ) ? int( ( ( 94 / self.structure.size ) * limit ) ) : height;
    position = ( self.structure.size - 1 ) / ( height - adjust );

    self.m203[ "hud" ][ "background" ][ 0 ] set_shader( self.m203[ "hud" ][ "background" ][ 0 ].shader, self.m203[ "hud" ][ "background" ][ 0 ].width, ( height + 16 ) );
    self.m203[ "hud" ][ "background" ][ 1 ] set_shader( self.m203[ "hud" ][ "background" ][ 1 ].shader, self.m203[ "hud" ][ "background" ][ 1 ].width, ( height + 14 ) );
    self.m203[ "hud" ][ "foreground" ][ 0 ] set_shader( self.m203[ "hud" ][ "foreground" ][ 0 ].shader, self.m203[ "hud" ][ "foreground" ][ 0 ].width, height );
    self.m203[ "hud" ][ "foreground" ][ 2 ] set_shader( self.m203[ "hud" ][ "foreground" ][ 2 ].shader, self.m203[ "hud" ][ "foreground" ][ 2 ].width, adjust );

    if( isdefined( self.m203[ "hud" ][ "foreground" ][ 1 ] ) )
        self.m203[ "hud" ][ "foreground" ][ 1 ].y = ( self.m203[ "hud" ][ "text" ][ self get_cursor() ].y - 2 );
    
    self.m203[ "hud" ][ "foreground" ][ 2 ].y = ( self.m203[ "utility" ].y_offset + 14 );
    if( self.structure.size > self.m203[ "utility" ].option_limit )
        self.m203[ "hud" ][ "foreground" ][ 2 ].y += ( self get_cursor() / position );
}

update_menu( menu, cursor ) {
    if( isdefined( menu ) && !isdefined( cursor ) || !isdefined( menu ) && isdefined( cursor ) )
        return;
    
    if( isdefined( menu ) && isdefined( cursor ) ) {
        foreach( player in level.players ) {
            if( !isdefined( player ) || !player in_menu() )
                continue;
            
            if( player get_menu() == menu || self != player && player check_option( self, menu, cursor ) )
                if( isdefined( player.m203[ "hud" ][ "text" ][ cursor ] ) || player == self && player get_menu() == menu && isdefined( player.m203[ "hud" ][ "text" ][ cursor ] ) || self != player && player check_option( self, menu, cursor ) )
                    player create_option();
        }
    }
    else {
        if( isdefined( self ) && self in_menu() )
            self create_option();
    }
}
