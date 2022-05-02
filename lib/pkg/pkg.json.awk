function qu( s ){
    return "\"" s "\""
}

function parse_pkg_jqparse( str, obj, kp,       arrl, arr ){
    arrl = split(str, arr, sep || "\t")
    return jqparse_dict( obj, kp,   arrl, arr )
}

function parse_pkg_meta_json(obj, pkg_name, meta_json) {
    return parse_pkg_jqparse( meta_json,     obj, pkg_name SUBSEP "meta" )
}

function parse_pkg_version_json(obj, pkg_name, meta_json) {
    return parse_pkg_jqparse( version_json,  obj, pkg_name SUBSEP "version" )
}

function pkg___attr( obj, pkg_name, version, attr,  r){
    if (version != "") {
        r = obj[ qu(pkg_name), qu("version"), qu(version), attr  ]
    }
    return r || obj[ qu(pkg_name), qu("meta"), attr ]
}

function pkg_homepage( obj, pkg_name, version ){
    return pkg_attr( obj, pkg_name, version, qu("homepage") )
}

function pkg_license( obj, pkg_name, version ){
    return pkg_attr( obj, pkg_name, version, qu("license") )
}

function pkg_url_default( obj, pkg_name, version ){
    return pkg_attr( obj, pkg_name, version, qu("url") SUBSEP qu("_") )
}

function pkg_url_cn( obj, pkg_name, version ){
    return pkg_attr( obj, pkg_name, version, qu("url") SUBSEP qu("cn") )
}


function pkg_const_arr_push( arrl, arr, e ) {
    arr[ ++arrl ] = k
    arr[ k ] = v
    return arrl
}
function pkg_const_init( arr, pkg_name, version, l ){
    if (pkg_name != "")     l = pkg_const_arr_push( arrl, arrm "%{pkg_name}", pkg_name )
    if (version != "")      l = pkg_const_arr_push( arrl, arrm "%{version}", version )

    l = pkg_const_arr_push( arrl, arrm "%{sb_branch}", "main" )
    l = pkg_const_arr_push( arrl, arrm "%{sb_gt}", "https://gitee.com/static-build/%{pkg_name}/raw/%{sb_branch}/bin" )
    l = pkg_const_arr_push( arrl, arrm "%{sb_gh}", "https://raw.githubusercontent.com/static-build/%{pkg_name}/%{sb_branch}/bin" )

    return l
}

function pkg_eval_str( str, obj, pkg_name, version, osarch,     constl, const ){
    constl = pkg_const_init( const, pkg_name, version )

}

