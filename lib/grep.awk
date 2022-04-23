function compare(_,item){
    match($0,/[0-9]+\.[0-9+]+/)
    result = substr($0,RSTART+0,RLENGTH-0)

    comparator = result
    if (comparator != last_comparator){
        print item
        last_comparator = result
        return
    }
}
BEGIN{
    match($0,/[0-9]+\.[0-9+]/)
}
{
 compare(_,$0)
}
