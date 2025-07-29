#!/bin/sh

set -e 

# Function to display usage
usage() {
    echo "Usage: $0 -n <name> -p <password>"
    echo "  -n: Set the name"
    echo "  -p: Set the password"
    exit 1
}

# Parse command line arguments
while getopts "n:p:h" opt; do
    case $opt in
        n)
            NETWORK="$OPTARG"
            ;;
        p)
            PASSWORD="$OPTARG"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Check if both required arguments are provided
if [ -z "$NETWORK" ] || [ -z "$PASSWORD" ]; then
    echo "Error: Both name and password are required."
    usage
fi

if [ -z "$HIDDEN" ]; then
    HIDDEN=""
else
    HIDDEN="hidden yes"
fi


echo "Attempting to connect to $NETWORK"
sudo nmcli c add type wifi con-name "$NETWORK" ifname wlan0 ssid "$NETWORK"
sudo nmcli con modify "$NETWORK" wifi-sec.key-mgmt wpa-psk
sudo nmcli con modify "$NETWORK" wifi-sec.psk "$PASSWORD"
sudo nmcli con up "$NETWORK"

