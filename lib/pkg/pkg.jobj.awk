function pkg_eval_str( str, table, pkg_name, _attempt ){
    print "hhh"
    pkg_name = jqu( pkg_name )

    str = juq(str)
    while ( match( str, "\%\{[^}]+\}" ) ) {
        print "going: " str
        if ( ++_attempt > 100 ) exit_msg( sprintf( "Exit because replacement attempts more than 100[%s]: %s", _attempt, str ) )
        p = substr( str, RSTART+2, RLENGTH-3 )
        print "pat:\t" p
        t = table[ pkg_name, jqu(p) ]
        if ( t == "" )  exit_msg( sprintf("Unknown pattern[%s] from str: %s", (pkg_name SUBSEP jqu(p)), str) )
        _newstr = substr( str, 1, RSTART-1 ) juq(t) substr( str, RSTART + RLENGTH )
        if (_newstr == str)  exit_msg( sprintf("Logic error. Target not changed: %s", str) )
        str = _newstr
        print "next: " str
    }

    return str
}

function pkg_init_table( jobj, table, table_kp,
    pkg_name, version, osarch,
    _rule_kp, _rule_l, i, k, _kpat ){

    # Predefined env variables
    pkg_add_table( "sb_branch", "main", table, table_kp )

    pkg_add_table( "osarch", osarch, table, table_kp )
    pkg_add_table( "version", version, table, table_kp )
    pkg_add_table( "sb_repo", pkg_name, table, table_kp )
    pkg_add_table( "sb_gh", "https://raw.githubusercontent.com/static-build/%{sb_repo}/%{sb_branch}/bin", table, table_kp )
    pkg_add_table( "sb_gt", "https://gitcode.net/x-bash/%{sb_repo}/-/raw/%{sb_branch}/bin", table, table_kp )
    pkg_add_table( "sb_gc", "https://gitcode.net/x-bash/%{sb_repo}/-/raw/%{sb_branch}/bin", table, table_kp )

    pkg_copy_table( jobj, jqu(pkg_name) SUBSEP jqu("meta"), table, jqu(pkg_name) )

    version_osarch = version "/" osarch
    _rule_kp = jqu(pkg_name) SUBSEP jqu("meta") SUBSEP jqu("rule")
    _rule_l = jobj[ _rule_kp L ]
    for (i=1; i<=_rule_l; ++i) {
        k = jobj[ _rule_kp, i ]
        _kpat = k
        gsub("\\*", "[^/]+", _kpat)
        # print "kpat:\t" _kpat
        if (match(version_osarch, "^" _kpat)) {
            pkg_copy_table( jobj, _rule_kp SUBSEP k, table, "" )
        }
    }
    pkg_copy_table( jobj, jqu(pkg_name) SUBSEP jqu("version") SUBSEP jqu(version) SUBSEP jqu(osarch), table, "" )
}

function pkg_add_table( k, v, table, table_kp,  l ){
    k = jqu(k)
    if ( table[ table_kp, k ] == "" ) {
        table[ table_kp L ] = ( l = table[ table_kp L ] + 1 )
        table[ table_kp, l ] = k
    }
    print table_kp SUBSEP k "---" v
    table[ table_kp, k ] = jqu(v)
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

function pkg_copy_table___list( src_obj, src_kp, table, table_kp,       l, i, _l ){
    l = src_obj[ src_kp L ]
    table[ table_kp L ] = l

    for (i=1; i<=l; ++i) {
        pkg_copy_table( src_obj, src_kp SUBSEP i, table, table_kp SUBSEP i )
    }
}

function pkg_copy_table(src_obj, src_kp, table, table_kp){
    if (src_obj[ src_kp ] == "{") return pkg_copy_table___dict(src_obj, src_kp, table, table_kp)
    if (src_obj[ src_kp ] == "[") return pkg_copy_table___list(src_obj, src_kp, table, table_kp)
    table[ table_kp ] = src_obj[ src_kp ]
}

# EndSetion

# Section: parsing

function parse_pkg_jqparse( str, jobj, kp,       arrl, arr ){
    arrl = split(str, arr, "\t")
    return jqparse_dict( jobj, kp,   arrl, arr, 1 )
}

function parse_pkg_meta_json(jobj, pkg_name, meta_json) {
    return parse_pkg_jqparse( meta_json,     jobj, jqu(pkg_name) SUBSEP jqu("meta") )
}

function parse_pkg_version_json(jobj, pkg_name, meta_json) {
    return parse_pkg_jqparse( version_json,  jobj, jqu(pkg_name) SUBSEP jqu("version") )
}


# EndSection
