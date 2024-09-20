#include scripts\mp\m203\utility;
#include scripts\mp\m203\custom_structure;

add_menu( title ) {
    if( isdefined( title ) )
        self set_title( title );
    
    self.structure = [];
}

add_option( text, function, argument_1, argument_2 ) {
    option            = spawnstruct();
    option.text       = text;
    option.function   = function;
    option.argument_1 = argument_1;
    option.argument_2 = argument_2;

    self.structure[ self.structure.size ] = option;
}

add_toggle( text, function, toggle, array, argument_1, argument_2 ) {
    option            = spawnstruct();
    option.text       = text;
    option.function   = function;
    option.toggle     = return_toggle( toggle );
    option.argument_1 = argument_1;
    option.argument_2 = argument_2;

    if( isdefined( array ) ) {
        option.slider = true;
        option.array  = array;
    }

    self.structure[ self.structure.size ] = option;
}

add_string( text, function, array, argument_1, argument_2 ) {
    option            = spawnstruct();
    option.text       = text;
    option.function   = function;
    option.slider     = true;
    option.array      = array;
    option.argument_1 = argument_1;
    option.argument_2 = argument_2;

    self.structure[ self.structure.size ] = option;
}

add_increment( text, function, start, minimum, maximum, increment, argument_1, argument_2 ) {
    option            = spawnstruct();
    option.text       = text;
    option.function   = function;
    option.slider     = true;
    option.start      = start;
    option.minimum    = minimum;
    option.maximum    = maximum;
    option.increment  = increment;
    option.argument_1 = argument_1;
    option.argument_2 = argument_2;

    self.structure[ self.structure.size ] = option;
}

add_category( text ) {
    option          = spawnstruct();
    option.text     = text;
    option.category = true;

    self.structure[ self.structure.size ] = option;
}

new_menu( menu ) {
    if( !isdefined( menu ) ) {
        menu                                        = self.previous[ ( self.previous.size - 1 ) ];
        self.previous[ ( self.previous.size - 1 ) ] = undefined;
    }
    else
        self.previous[ self.previous.size ] = self get_menu();

    self set_menu( menu );
    self clear_option();
    self create_option();
}
