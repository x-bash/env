NR==1 {
    pkg_name = $0
}

NR==2 {
    meta = $0
}

NR==3 {
    version = $0
}

END {
    parse_pkg_meta_json( jobj, pkg_name, meta )
    parse_pkg_version_json( jobj, pkg_name, version )

    pkg_init_table( jobj, table, jqu(pkg_name), pkg_name, "v8.3.2", "linux-arm64")


    print jobj[ jqu(pkg_name), jqu("meta"), jqu("rule"), jqu("v*/win-*"), jqu("dot_exe") ]

    url_default = table[ jqu(pkg_name), jqu("url"), jqu("_") ]
    print url_default

    print jqu(pkg_name) SUBSEP jqu("sb_gh")

    print "--------"
    print table[ jqu(pkg_name), jqu("sb_repo") ]

    str = table[ jqu(pkg_name), jqu("sb_gh") ]

    print "---" pkg_eval_str( str, table, "nmap" )

}

