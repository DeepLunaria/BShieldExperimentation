#!/system/bin/sh

# trash produced by nleloc, idea by XESSEX
# i'm not responsible for anything happended on your phone by using this shit
# like it randomly exploded, caused ww3 or nuclear war
NM_BIN=/data/adb/modules/nomount/bin/nm

# check if nomount LKM installed / baked into kernel / nm module installed
$NM_BIN version >/dev/null 2>&1 || exit 1

# add your custom package below
HIDE_FROM="
com.vnid
"

UID_LIST=""

# get exposed file list
EXPOSE=$( {
    find /system -iname '*lineage*' 2>/dev/null
    find /product -iname '*lineage*' 2>/dev/null
    find /system_ext -iname '*lineage*' 2>/dev/null
} )

until cmd package list packages >/dev/null 2>&1; do sleep 1; done

# get uid list
for pkg in $HIDE_FROM; do
    app_uid=$(cmd package list packages -U | sed -n "s/^package:$pkg uid://p")
    [ -n "$app_uid" ] && UID_LIST="$UID_LIST $app_uid"
done

# nothing to do
[ -z "$UID_LIST" ] && exit 0
[ -z "$EXPOSE" ] && exit 0

for uid in $UID_LIST; do
    #     $NM_BIN rule add --whiteout "/system/addon.d" --uid "$uid"
    #     ^^ this might not be useful for now

    while read -r file; do
        $NM_BIN rule add --whiteout "$file" --uid "$uid"
    done <<EOF
$EXPOSE
EOF
done
