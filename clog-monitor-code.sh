#!/bin/bash

# Function to monitor log file
monitor_log_file() {
    log_file="$1"
    keywords=("ERROR" "HTTP")

    echo "Monitoring log file: $log_file. Press Ctrl+C to stop."

    # Continuously monitor log file for new entries
    tail -n0 -f "$log_file" | while read line; do
        for keyword in "${keywords[@]}"; do
            if [[ $line == "$keyword" ]]; then
                echo "$line"
            fi
        done
    done
}

# Function to analyze log file
analyze_log_file() {
    log_file="$1"
    keywords=("ERROR" "HTTP")

    echo "Analyzing log file: $log_file"

    # Count occurrences of keywords in log file
    declare -A occurrences
    for keyword in "${keywords[@]}"; do
        occurrences["$keyword"]=$(grep -o "$keyword" "$log_file" | wc -l)
    done

    # Display summary report
    echo -e "\nSummary Report:"
    for keyword in "${keywords[@]}"; do
        echo "$keyword: ${occurrences[$keyword]} occurrences"
    done
}

# Main script
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_file_path>"
    exit 1
fi

log_file_path="$1"

# Check if log file exists
if [ ! -f "$log_file_path" ]; then
    echo "Error: Log file '$log_file_path' not found."
    exit 1
fi

# Perform log monitoring and analysis
monitor_log_file "$log_file_path" &
pid=$!

# Trap Ctrl+C to stop monitoring
trap "kill $pid; echo 'Monitoring stopped.'; analyze_log_file '$log_file_path'; exit 0" SIGINT

# Wait for the monitoring process
wait $pid
