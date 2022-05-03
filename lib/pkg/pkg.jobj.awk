
# Section: copy

function pkg_copy_table___dict( src_obj, src_kp, table, table_kp,       l, i, kl, tkl, k, _a, _al ){
    l = src_obj[ src_kp L ]
    kl = src_obj[ src_kp K ]
    tkl = table[ table_kp K ]

    _al = split(kl, _a, SUBSEP)
    for (i=1; i<=_al; ++i) {
        k = _a[i]
        if ( index(SUBSEP k SUBSEP, tkl) ) {

        }

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
    return pkg_jqparse_dict( jobj, kp,   arrl, arr )
}

function parse_pkg_meta_json(jobj, pkg_name, meta_json) {
    return parse_pkg_jqparse( meta_json,     jobj, pkg_name SUBSEP "meta" )
}

function parse_pkg_version_json(jobj, pkg_name, meta_json) {
    return parse_pkg_jqparse( version_json,  jobj, pkg_name SUBSEP "version") )
}

# EndSection
