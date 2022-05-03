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

    pkg_init_table( jobj, table, pkg_name, pkg_name, "v8.3.2", "linux-arm64")


    print jobj[ jqu(pkg_name), jqu("meta"), jqu("rule"), jqu("v*/win-*"), jqu("dot_exe") ]
}
