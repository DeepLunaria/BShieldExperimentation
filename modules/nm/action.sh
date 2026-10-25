#!/system/bin/sh

MODDIR="${0%/*}"
NM_BIN=/data/adb/modules/nomount/bin/nm

$NM_BIN version >/dev/null 2>&1 || { echo "- NoMount userspace module not found / NoMount has not been integrated into your kernel!"; exit 1; }

echo "- NoMount version: $($NM_BIN version)"

sh "$MODDIR/boot-completed.sh" && echo "- NoMount rules re-added!"

