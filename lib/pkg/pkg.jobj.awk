
function exit_msg( code, msg ){
    if (msg == "") {
        msg = code
        code = 1
    }
    printf("%s\n", msg)
    exit( code )
}

function pkg_eval_str( str, table,  _attempt ){

    while ( match( str, "\%\{[^\}]\}\%" ) ) {
        if ( ++_attempt > 100 ) exit_msg( sprintf( "Exit because replacement attempts more than 100[%s]: %s", _attempt, str ) )
        p = substr( str, RSTART, RLENGTH )
        t = table[p]
        if ( t == "" )  exit_msg( sprintf("Unknown pattern[%s] from str: %s", t, str) )
        _newstr = substr( str, 1, RSTART-1 ) t substr( str, RSTART + RLENGTH )
        if (_newstr == str)  exit_msg( sprintf("Logic error. Target not changed: %s", str) )
        str = _newstr
    }
    return str
}

function pkg_init_table( jobj, table, table_kp,
    pkg_name, version, osarch,
    _rule_kp, _rule_l, i, k, _kpat ){

    # Predefined env variables
    pkg_add_table( "%{sb_branch}", "main" )

    pkg_add_table( "%{osarch}", osarch )
    pkg_add_table( "%{version}", version )
    pkg_add_table( "%{sb_repo}", pkg_name )
    pkg_add_table( "%{sb_gh}", "https://raw.githubusercontent.com/static-build/%{sb_repo}/%{sb_branch}/bin" )
    pkg_add_table( "%{sb_gt}", "https://gitcode.net/x-bash/%{sb_repo}/-/raw/%{sb_branch}/bin" )
    pkg_add_table( "%{sb_gc}", "https://gitcode.net/x-bash/%{sb_repo}/-/raw/%{sb_branch}/bin" )

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

function pkg_add_table( k, v, table, table_kp,  l ){
    k = qu(k)
    if ( table[ table_kp, k ] == "" ) {
        table[ table_kp L ] = ( l = table[ table_kp L ] + 1 )
        table[ table_kp, l ] = k
    }
    table[ table_kp, k ] = qu(v)
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

function uq( str ){
    if (str !~ /^".*"$/) return str

    str = substr( str, 2, length(str)-2 )
    gsub( "\\\\", "\001", str )
    gsub( "\\\"", "\"", str )
    gsub( "/\\n/", "\n", str )
    gsub( "/\\t/", "\t", str )
    gsub( "/\\v/", "\v", str )
    gsub( "/\\b/", "\b", str )
    gsub( "/\\r/", "\r", str )
    gsub( "\001", "\\\\", str )
    return str
}

function qu( str ){
    if (str ~ /^".*"$/) return str

    gsub( "\"", "\\\"", str )
    gsub( "\n", "\\n", str )
    gsub( "\t", "\\t", str )
    gsub( "\v", "\\v", str )
    gsub( "\b", "\\b", str )
    gsub( "\r", "\\r", str )
    return "\"" str "\""
}

# EndSection
