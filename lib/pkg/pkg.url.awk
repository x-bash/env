NR==1 {
    meta = $0
}

NR==2 {
    version = $0
}

END {
    parse_pkg_meta_json( jobj, "", meta )
    parse_pkg_version_json( jobj, "", version )

    pkg_init_table( jobj, table, "", "", "v8.3.2", "linux-arm64")


    print jobj[ jqu(""), jqu("meta"), jqu("rule"), jqu("v*/win-*"), jqu("dot_exe") ]
}
