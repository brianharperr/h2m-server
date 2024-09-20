return_toggle( variable ) {
    return isdefined( variable ) && variable;
}

really_alive() {
    return isalive( self ) && !return_toggle( self.laststand ) && self.sessionstate != "spectator";
}

get_menu() {
    return self.m203[ "menu" ];
}

set_menu( menu ) {
    if( isdefined( menu ) )
        self.m203[ "menu" ] = menu;
}

get_cursor() {
    return self.cursor[ self get_menu() ];
}

set_cursor( cursor, menu ) {
    if( isdefined( cursor ) )
        self.cursor[ isdefined( menu ) ? menu : self get_menu() ] = cursor;
}

get_title() {
    return self.m203[ "title" ];
}

set_title( title ) {
    if( isdefined( title ) )
        self.m203[ "title" ] = title;
}

in_menu() {
    return return_toggle( self.m203[ "utility" ].in_menu );
}

set_state() {
    self.m203[ "utility" ].in_menu = !return_toggle( self.m203[ "utility" ].in_menu );
}

execute_function( function, argument_1, argument_2, argument_3 ) {
    if( !isdefined( function ) )
        return;
    
    if( isdefined( argument_3 ) )
        return self thread [[ function ]]( argument_1, argument_2, argument_3 );

    if( isdefined( argument_2 ) )
        return self thread [[ function ]]( argument_1, argument_2 );
    
    if( isdefined( argument_1 ) )
        return self thread [[ function ]]( argument_1 );
    
    return self thread [[ function ]]();
}

clear_all( array ) {
    if( !isdefined( array ) )
        return;

    keys = getarraykeys( array );
    for( a = 0; a < keys.size; a++ ) {
        if( isarray( array[ keys[ a ] ] ) ) {
            foreach( value in array[ keys[ a ] ] )
                if( isdefined( value ) )
                    value destroy();
        }
        else
            if( isdefined( array[ keys[ a ] ] ) )
                array[ keys[ a ] ] destroy();
    }
}

set_slider( scrolling, index ) {
    menu    = self get_menu();
    index   = isdefined( index ) ? index : self get_cursor();
    storage = ( menu + "_" + index );
    if( !isdefined( self.slider[ storage ] ) )
        self.slider[ storage ] = isdefined( self.structure[ index ].array ) ? 0 : self.structure[ index ].start;

    if( isdefined( self.structure[ index ].array ) ) {
        self notify( "string_slider" );
        if( scrolling == -1 )
            self.slider[ storage ]++;
        
        if( scrolling == 1 )
            self.slider[ storage ]--;
        
        if( self.slider[ storage ] > ( self.structure[ index ].array.size - 1 ) )
            self.slider[ storage ] = 0;
        
        if( self.slider[ storage ] < 0 )
            self.slider[ storage ] = ( self.structure[ index ].array.size - 1 );
        
        self.m203[ "hud" ][ "slider" ][ 0 ][ index ] scripts\mp\m203\utility_element::set_text( self.structure[ index ].array[ self.slider[ storage ] ] );
    }
    else {
        self notify( "increment_slider" );
        if( scrolling == -1 )
            self.slider[ storage ] += self.structure[ index ].increment;
        
        if( scrolling == 1 )
            self.slider[ storage ] -= self.structure[ index ].increment;
        
        if( self.slider[ storage ] > self.structure[ index ].maximum )
            self.slider[ storage ] = self.structure[ index ].minimum;
        
        if( self.slider[ storage ] < self.structure[ index ].minimum )
            self.slider[ storage ] = self.structure[ index ].maximum;
        
        position = abs( ( self.structure[ index ].maximum - self.structure[ index ].minimum ) ) / ( ( 50 - 8 ) );
        self.m203[ "hud" ][ "slider" ][ 0 ][ index ] setvalue( self.slider[ storage ] );
        self.m203[ "hud" ][ "slider" ][ 2 ][ index ].x = ( self.m203[ "hud" ][ "slider" ][ 1 ][ index ].x + ( abs( ( self.slider[ storage ] - self.structure[ index ].minimum ) ) / position ) - 42 );
    }
}

clear_option() {
    for( i = 0; i < self.m203[ "utility" ].element_list.size; i++ ) {
        clear_all( self.m203[ "hud" ][ self.m203[ "utility" ].element_list[ i ] ] );
        self.m203[ "hud" ][ self.m203[ "utility" ].element_list[ i ] ] = [];
    }
}

check_option( player, menu, cursor ) {
    if( isdefined( self.structure ) && self.structure.size )
        for( i = 0; i < self.structure.size; i++ )
            if( player.structure[ cursor ].text == self.structure[ i ].text && self get_menu() == menu )
                return true;
    
    return false;
}
