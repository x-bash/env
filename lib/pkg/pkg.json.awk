function parse_pkg_jqparse( str, obj, kp,       arrl, arr ){
    arrl = split(str, arr, sep || "\t")
    return jqparse_str( obj, kp,   arrl, arr )
}

function parse_pkg_meta_json(obj, pkgname, meta_json) {
    parse_pkg_jqparse( meta_json,     obj, pkgname S "meta" )
}

function parse_pkg_version_json(obj, pkgname, meta_json) {
    parse_pkg_jqparse( version_json,  obj, pkgname S "version" )
}

{

}
