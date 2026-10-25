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
EXPOSE=$(find /system /product /system_ext /vendor \
    \( -iname '*lineage*' -o -iname '*crdroid*' \) \
    -prune -print 2>/dev/null)

[ -e /system/addon.d ] && EXPOSE="/system/addon.d
$EXPOSE"

until cmd package list packages >/dev/null 2>&1; do sleep 1; done

# get uid list
PKG_LIST=$(cmd package list packages -U)
for pkg in $HIDE_FROM; do
    app_uid=$(echo "$PKG_LIST" | sed -n "s/^package:$pkg uid://p")
    [ -n "$app_uid" ] && UID_LIST="$UID_LIST $app_uid"
done

# nothing to do
[ -z "$UID_LIST" ] && exit 0
[ -z "$EXPOSE" ] && exit 0

for uid in $UID_LIST; do
    while read -r file; do
        [ -n "$file" ] && $NM_BIN rule add --whiteout "$file" --uid "$uid"
    done <<EOF
$EXPOSE
EOF
done
