#!/bin/sh

set -e 

# Function to display usage
usage() {
    echo "Usage: $0 -n <name> -p <password>"
    echo "  -n: Set the name"
    echo "  -p: Set the password"
    echo "  -x: Set this to any value if the network is hidden"
    exit 1
}

# Parse command line arguments
while getopts "n:p:x:h" opt; do
    case $opt in
        n)
            NETWORK="$OPTARG"
            ;;
        p)
            PASSWORD="$OPTARG"
            ;;
        x)
            HIDDEN="$OPTARG"
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
nmcli dev wifi connect "$NETWORK" password "$PASSWORD" "$HIDDEN"


