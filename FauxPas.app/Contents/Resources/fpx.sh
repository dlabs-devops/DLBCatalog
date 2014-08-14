#!/bin/sh
#
# Helper for using the command-line interface of {{APP_NAME}}.
# {{APP_COPYRIGHT}}
#

echoerr() { echo "$@" 1>&2; }

APP_BUNDLE_PATH="{{APP_PATH}}"
if [ ! -e "$APP_BUNDLE_PATH" ]; then
    echoerr "Error: Cannot find {{APP_NAME}} at: $APP_BUNDLE_PATH"
    exit 1
fi

PROGRAM_NAME=$(basename "$0") "$APP_BUNDLE_PATH/Contents/MacOS/{{SAFE_APP_NAME}}" cli "$@"
