function qu( s ){
    return "\"" s "\""
}

function parse_pkg_jqparse( str, obj, kp,       arrl, arr ){
    arrl = split(str, arr, sep || "\t")
    return jqparse_dict( obj, kp,   arrl, arr )
}

function parse_pkg_meta_json(obj, pkgname, meta_json) {
    return parse_pkg_jqparse( meta_json,     obj, pkgname SUBSEP "meta" )
}

function parse_pkg_version_json(obj, pkgname, meta_json) {
    return parse_pkg_jqparse( version_json,  obj, pkgname SUBSEP "version" )
}

function pkg_attr( obj, pkgname, version, attr,  r){
    if (version != "") {
        r = obj[ qu(pkgname), qu("version"), qu(version), qu(attr)  ]
    }
    return r || obj[ qu(pkgname), qu("meta"), qu(attr) ]
}

function pkg_homepage( obj, pkgname, version ){
    pkg_attr( obj, pkgname, version, "homepage" )
}

function pkg_license( obj, pkgname, version ){
    pkg_attr( obj, pkgname, version, "license" )
}

function pkg_url_default( obj, pkgname, version ){
    pkg_attr( obj, pkgname, version, "url" SUBSEP "_" )
}

function pkg_url_cn( obj, pkgname, version ){
    pkg_attr( obj, pkgname, version, "url" SUBSEP "cn" )
}


