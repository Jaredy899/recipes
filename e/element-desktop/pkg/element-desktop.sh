#!/usr/bin/env sh
# Launches element-desktop with flags specified in $XDG_CONFIG_HOME/element-desktop-flags.conf

set -e

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

if [ -r "${XDG_CONFIG_HOME}/element-desktop-flags.conf" ]; then
    ELEMENT_DESKTOP_FLAGS="$(cat "$XDG_CONFIG_HOME/element-desktop-flags.conf")"
fi

if [ -z "${ELEMENT_NO_WAYLAND+set}" ]; then
    if [ -z "${ELECTRON_OZONE_PLATFORM_HINT+set}" ]; then
        export ELECTRON_OZONE_PLATFORM_HINT="auto"
    fi
fi

# shellcheck disable=SC2086
exec /usr/lib/element-desktop/element-desktop $ELEMENT_DESKTOP_FLAGS "$@"
