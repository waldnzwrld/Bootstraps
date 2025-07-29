#!/bin/bash

# Network Scanner Script for Headless Linux Machine
# This script scans the local network to find active devices

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to get the local IP and subnet
get_network_info() {
    echo -e "${BLUE}Detecting network information...${NC}"
    
    # Try to get the local IP address
    LOCAL_IP=$(ipconfig getifaddr en0)
    
    if [ -z "$LOCAL_IP" ]; then
        LOCAL_IP=$(hostname -I | awk '{print $1}')
    fi
    
    if [ -z "$LOCAL_IP" ]; then
        echo -e "${RED}Could not determine local IP address${NC}"
        exit 1
    fi
    
    # Extract the network prefix (first 3 octets)
    NETWORK_PREFIX=$(echo $LOCAL_IP | cut -d. -f1-3)
    
    echo -e "${GREEN}Local IP: $LOCAL_IP${NC}"
    echo -e "${GREEN}Scanning network: $NETWORK_PREFIX.0/24${NC}"
    echo ""
}

# Function to scan the network
scan_network() {
    local network_prefix=$1
    local active_hosts=()
    local total_hosts=255
    local current=0
    
    echo -e "${YELLOW}Starting network scan...${NC}"
    echo -e "${YELLOW}This may take a few minutes.${NC}"
    echo ""
    
    # Create a temporary file to store results
    TEMP_FILE=$(mktemp)
    
    # Scan each IP address from 1 to 255
    for i in {1..255}; do
        current=$((current + 1))
        ip="$network_prefix.$i"
        
        # Show progress
        printf "\r${BLUE}Progress: %d/%d (%.1f%%) - Testing: %s${NC}" $current $total_hosts $((current * 100 / total_hosts)) $ip
        
        # Ping the IP address with a short timeout
        if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
            echo -e "\n${GREEN}✓ Found active host: $ip${NC}"
            active_hosts+=("$ip")
            echo "$ip" >> "$TEMP_FILE"
        fi
    done
    
    echo ""
    echo ""
    
    # Display results
    if [ ${#active_hosts[@]} -eq 0 ]; then
        echo -e "${RED}No active hosts found on the network.${NC}"
    else
        echo -e "${GREEN}Found ${#active_hosts[@]} active host(s):${NC}"
        echo "----------------------------------------"
        cat "$TEMP_FILE" | while read ip; do
            echo -e "${GREEN}• $ip${NC}"
        done
        echo "----------------------------------------"
        echo ""
        
        # Try to identify potential SSH hosts
        echo -e "${YELLOW}Attempting to identify SSH-enabled hosts...${NC}"
        for ip in "${active_hosts[@]}"; do
            if timeout 3 bash -c "</dev/tcp/$ip/22" 2>/dev/null; then
                echo -e "${GREEN}✓ SSH port (22) open on: $ip${NC}"
            fi
        done
    fi
    
    # Clean up
    rm -f "$TEMP_FILE"
}

# Function to attempt SSH connection
try_ssh_connection() {
    local ip=$1
    echo -e "${YELLOW}Attempting SSH connection to $ip...${NC}"
    echo -e "${BLUE}You can try: ssh username@$ip${NC}"
    echo ""
}

# Main script
main() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Network Scanner for Headless Linux${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
    
    # Check if running as root (optional, for better results)
    if [ "$EUID" -eq 0 ]; then
        echo -e "${YELLOW}Running as root - this may provide better results${NC}"
    else
        echo -e "${YELLOW}Not running as root - some hosts might not respond${NC}"
    fi
    echo ""
    
    # Get network information
    get_network_info
    
    # Ask user if they want to proceed
    echo -e "${YELLOW}Do you want to scan the network? (y/n)${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Scan cancelled.${NC}"
        exit 0
    fi
    
    # Perform the scan
    scan_network "$NETWORK_PREFIX"
    
    echo ""
    echo -e "${BLUE}Scan complete!${NC}"
    echo -e "${YELLOW}To connect to your headless machine:${NC}"
    echo -e "${BLUE}1. Try SSH to each IP address found${NC}"
    echo -e "${BLUE}2. Use: ssh username@IP_ADDRESS${NC}"
    echo -e "${BLUE}3. Common usernames: pi, ubuntu, admin, root${NC}"
}

# Run the main function
main "$@" 