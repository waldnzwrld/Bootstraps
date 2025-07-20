#!/bin/bash
#

set -e
xargs -a packages.txt sudo apt-get install


# Need to cp the NNN directory changer to it's appropriate locale
# Need to move zshrc into place
#
