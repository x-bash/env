
function pkg_eval_str( str, table ){
    while ( match( str, "\%\{[^\}]\}\%" ) ) {
        p = substr( str, RSTART, RLENGTH )
        t = table[p]
        if ( t == "" )  {
            printf("Unknown pattern[%s] from str: %s", t, str)
            exit(1)
        }
        _newstr = substr( str, 1, RSTART-1 ) t substr( str, RSTART + RLENGTH )
        if (_newstr == str)  {
            printf("Logic error. Target not changed.")
            exit(1)
        }
        str = _newstr
    }
    return str
}


function pkg_init_table( jobj, table, table_kp,   pkg_name, version, osarch,      _rule_kp, _rule_l, i, k, _kpat ){
    pkg_copy_table( jobj, qu(pkg_name) SUBSEP qu("meta"), table, "" )

    version_osarch = version "/" osarch
    _rule_kp = qu(pkg_name) SUBSEP qu("meta") SUBSEP qu("rule")
    _rule_l = jobj[ _rule_kp L ]
    for (i=1; i<=_rule_l; ++i) {
        k = jobj[ _rule_kp, i ]
        _kpat = k
        gsub("*", "[^/]+", _kpat)
        if (match(k, "^" _kpat)) {
            pkg_copy_table( jobj, _rule_kp SUBSEP k, table, "" )
        }
    }
    pkg_copy_table( jobj, qu(pkg_name) SUBSEP qu("version") SUBSEP qu(version) SUBSEP qu(osarch), table, "" )
}

# Section: copy

function pkg_copy_table___dict( src_obj, src_kp, table, table_kp,       l, i, _l ){
    l = src_obj[ src_kp L ]

    for (i=1; i<=l; ++i) {
        k = src_obj[ src_kp, i ]
        if (k == "\"rule\"") continue       # skip the rule
        if ( table[ table_kp, k ] == "" ) {
            table[ table_kp L ] = ( _l = table[ table_kp L ] + 1 )
            table[ table_kp, _l ] = k
        }
        pkg_copy_table( src_obj, src_kp SUBSEP k, table, table_kp SUBSEP k )
    }
}

function pkg_copy_table(src_obj, src_kp, table, table_kp){
    if (src_obj[ src_kp ] == "{") return pkg_copy_table___dict(src_obj, src_kp, table, table_kp)
    if (src_obj[ src_kp ] == "[") {
        print "Not implemented"
        exit(1)
    }
    table[ table_kp ] = src_obj[ src_kp ]
}

# EndSetion

# Section: parsing

function parse_pkg_jqparse( str, jobj, kp,       arrl, arr ){
    arrl = split(str, arr, "\t")
    return jqparse_dict( jobj, kp,   arrl, arr )
}

function parse_pkg_meta_json(jobj, pkg_name, meta_json) {
    return parse_pkg_jqparse( meta_json,     jobj, pkg_name SUBSEP "meta" )
}

function parse_pkg_version_json(jobj, pkg_name, meta_json) {
    return parse_pkg_jqparse( version_json,  jobj, pkg_name SUBSEP "version") )
}

# EndSection
