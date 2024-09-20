create_text( text, font, font_scale, alignment, relative, x_offset, y_offset, color, alpha, sorting ) {
    element                = self maps\mp\gametypes\_hud_util::createfontstring( font, font_scale );
    element.color          = color;
    element.alpha          = alpha;
    element.sort           = sorting;
    element.archived       = false;
    element.foreground     = true;
    element.hidewheninmenu = true;

    element maps\mp\gametypes\_hud_util::setpoint( alignment, relative, x_offset, y_offset );
    
    if( isnumber( text ) )
        element setvalue( text );
    else
        element set_text( text );

    return element;
}

set_text( text ) {
    if( !isdefined( self ) || !isdefined( text ) )
        return;
    
    self.text = text;
    self settext( text );
}

create_shader( shader, alignment, relative, x_offset, y_offset, width, height, color, alpha, sorting ) {
    element                = newclienthudelem( self );
    element.elemtype       = "icon";
    element.children       = [];
    element.color          = color;
    element.alpha          = alpha;
    element.sort           = sorting;
    element.archived       = true;
    element.foreground     = true;
    element.hidden         = false;
    element.hidewheninmenu = true;
    
    element maps\mp\gametypes\_hud_util::setpoint( alignment, relative, x_offset, y_offset );
    element set_shader( shader, width, height );
    element maps\mp\gametypes\_hud_util::setparent( level.uiparent );
        
    return element;
}

set_shader( shader, width, height ) {
    if( !isdefined( shader ) ) {
        if( !isdefined( self.shader ) )
            return;
        
        shader = self.shader;
    }

    if( !isdefined( width ) ) {
        if( !isdefined( self.width ) )
            return;
        
        width = self.width;
    }

    if( !isdefined( height ) ) {
        if( !isdefined( self.height ) )
            return;
        
        height = self.height;
    }

    self.shader = shader;
    self.width  = width;
    self.height = height;
    self setshader( shader, width, height );
}
