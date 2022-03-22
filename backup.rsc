/system script rem [find where name~"backup"]
add name=backup source={
/file remove [find where name~".backup"]
/file remove [find where name~".rsc"]
:local curdate [([/sy identity get name]."-".[:pick [/system clock get date] 7 11].\
[:pick [/system clock get date] 0 3].[:pick [/system clock get date] 4 6]."-".[:pick\
 [/system clock get time] 0 2].[:pick [/system clock get time] 3 5])]
/system backup save encryption=aes-sha256
/export compact file=$curdate
}
