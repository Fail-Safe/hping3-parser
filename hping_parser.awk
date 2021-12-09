#!/usr/bin/awk -f
# Set defaults for the record set
BEGIN {
    RS = ""
    FS = " "
    # Set an arbitrary high MIN value to compare against
    min_uplink_time = min_downlink_time = 999999999
}

# Main loop to iterate over each record in the record set
{
    # RTT
    rtt = $6
    sub(/rtt=/, "", rtt) # Remove 'rtt=' from field

    # Originate
    orig = $10
    sub(/Originate=/, "", orig) # Remove 'Originate=' from field

    # Receive
    rx = $11
    sub(/Receive=/, "", rx) # Remove 'Receive=' from field

    # Transmit
    tx = $12
    sub(/Transmit=/, "", tx) # Remove 'Transmit=' from field

    # Calculate uplink and downlink times
    uplink_time = rx - orig
    downlink_time = orig + rtt - tx

    # Evaluate if new MINs have been achieved
    min_uplink_time = uplink_time < min_uplink_time ? uplink_time : min_uplink_time
    min_downlink_time = downlink_time < min_downlink_time ? downlink_time : min_downlink_time
}

# Final actions once record set has been iterated
END { 
    print min_uplink_time, min_downlink_time
}
