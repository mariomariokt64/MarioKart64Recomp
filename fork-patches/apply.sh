#!/bin/sh
# Applies the patches in fork-patches/<name>/ to the submodule each <name> stands for.
#
#   sh fork-patches/apply.sh          apply every patch that is not applied yet
#   sh fork-patches/apply.sh --check  only check that every patch applies (or already is applied)
#
# A patch that neither applies nor is already applied FAILS the run: a patch that silently dropped out
# would ship a build without its fix. Delete a patch once the submodule's own history has the fix.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
mode=apply
[ "${1:-}" = "--check" ] && mode=check

status=0

apply_dir() {
    name=$1
    dir=$2
    for patch in "$root"/fork-patches/"$name"/*.patch; do
        [ -e "$patch" ] || continue
        if git -C "$root/$dir" apply --check --reverse "$patch" >/dev/null 2>&1; then
            echo "already applied: fork-patches/$name/$(basename "$patch")"
            continue
        fi
        if ! git -C "$root/$dir" apply --check "$patch"; then
            echo "DOES NOT APPLY: fork-patches/$name/$(basename "$patch") (to $dir)" >&2
            status=1
            continue
        fi
        if [ "$mode" = "apply" ]; then
            git -C "$root/$dir" apply "$patch"
            echo "applied: fork-patches/$name/$(basename "$patch")"
        else
            echo "applies: fork-patches/$name/$(basename "$patch")"
        fi
    done
}

# <name> <submodule path>
apply_dir plume lib/rt64/src/contrib/plume

exit $status
