#!/usr/bin/env bash
# Restart kanata (and its focus watcher) every time the system wakes from sleep.
#
# Why: the T2 internal keyboard is torn down and re-enumerated on resume. kanata
# loses the device mid-stream (no key-release events), so any key/modifier/layer
# that was "held" at suspend can stay latched in kanata's virtual keyboard and
# leave the system unusable. A fresh process grabs the new device cleanly.
#
# Listens for logind's PrepareForSleep signal on the system bus (no root needed);
# "false" means "just resumed". Supervised by kanata-resume.service.

set -uo pipefail

gdbus monitor --system --dest org.freedesktop.login1 --object-path /org/freedesktop/login1 \
  | while IFS= read -r line; do
      if [[ "$line" == *"PrepareForSleep (false,)"* ]]; then
        sleep 1   # let the keyboard finish re-enumerating
        systemctl --user restart kanata.service
        systemctl --user restart kanata-watch.service
      fi
    done
