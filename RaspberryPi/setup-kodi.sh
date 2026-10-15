#!/bin/bash

set -e 

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../Linux/pkg.sh"

pkg_update
if [ "$PKG_MGR" = apt ]; then
    pkg_install kodi libwidevinecdm0
else
    pkg_install kodi
fi

echo "Done"

