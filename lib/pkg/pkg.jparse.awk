function pkg_jqparse_dict(jobj, kp,     token_arrl, token_arr,  idx,                 l, t){
    jobj[ kp ] = "{"
    ++ idx
    while ( idx <= token_arrl ) {
        t = token_arr[ idx ]
        if (t == "}") {
            jobj[ kp L ] = l
            return idx + 1
        }
        token_arr[ kp, ++ l ] = t
        idx = ___pkg_jqparse_value( jobj, kp SUBSEP t, token_arrl, token_arr, idx + 2 )
        if ( token_arr[ idx ] == "," )     idx ++
    }
    # return 11111111
}

function ___pkg_jqparse_value(jobj, kp,     token_arrl, token_arr,  idx,                     t ){
    t = token_arr[ idx ]
    if (t == "[")       return pkg_jqparse_list( jobj, kp, token_arrl, token_arr, idx )
    if (t == "{")       return pkg_jqparse_dict( jobj, kp, token_arrl, token_arr, idx )
    jobj[ kp ] = t;      return idx + 1
}

function pkg_jqparse_list(jobj, kp,     token_arrl, token_arr,  idx,                 l ){
    jobj[ kp ] = "["
    ++ idx
    while ( idx <= token_arrl ) {
        if (token_arr[ idx ] == "]") {
            jobj[ kp L ] = l
            return idx + 1
        }

        idx = ___pkg_jqparse_value( jobj, kp SUBSEP "\"" (++l) "\"", token_arrl, token_arr, idx )
        if ( token_arr[ idx ] == ",")     idx ++
    }
    # return 11111111
}

