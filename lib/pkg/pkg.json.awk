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

# Section: calculate string
function pkg_eval_str( str, pkg_name, version, osarch,              _const ){
    pkg_const_init( _const, pkg_name, version, osarch )
    pkg_eval_str_from_const( str, _const )
}

function pkg_eval_str_from_const( str, const,    _newstr ){
    while ( match( str, "\%\{[^\}]\}\%" ) ) {
        p = substr( str, RSTART, RLENGTH )
        t = const[p]
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

function pkg_const_init( arr, pkg_name, version, osarch,            l ){
    if (pkg_name != "")     l = pkg_const_arr_push( arrl, arrm "%{pkg_name}", pkg_name )
    if (version != "")      l = pkg_const_arr_push( arrl, arrm "%{version}", version )

    l = pkg_const_arr_push( arrl, arrm "%{sb_branch}", "main" )
    l = pkg_const_arr_push( arrl, arrm "%{sb_gt}", "https://gitee.com/static-build/%{pkg_name}/raw/%{sb_branch}/bin" )
    l = pkg_const_arr_push( arrl, arrm "%{sb_gh}", "https://raw.githubusercontent.com/static-build/%{pkg_name}/%{sb_branch}/bin" )

    # load const string from meta.const

    # load const string from meta.osarch.const

    # load const string from version.osarch.const

    return l
}

function pkg_const_arr_push( arrl, arr, e ) {
    arr[ ++arrl ] = k
    arr[ k ] = v
    return arrl
}
# EndSection

# Section: raw attribute

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

# EndSection

