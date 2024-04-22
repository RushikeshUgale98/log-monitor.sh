# log-monitor.sh
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
•	This defines a function monitor_log_file() which takes one argument ($1, the log file path).
•	Inside the function:
•	It initializes log_file with the provided argument (log file path).
•	It defines keywords array containing strings "ERROR" and "HTTP".
•	Displays a message indicating that the log file is being monitored.
•	Uses tail -n0 -f "$log_file" to continuously stream new lines from the log file.
•	For each line read from the log file (read line), it loops through each keyword in keywords.
•	If the line contains a keyword, it echoes the line to the console.
 

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

•	This defines a function analyze_log_file() which takes one argument ($1, the log file path).
•	Inside the function:
•	It initializes log_file with the provided argument (log file path).
•	It defines keywords array containing strings "ERROR" and "HTTP".
•	Displays a message indicating that the log file is being analyzed.
•	Initializes an associative array occurrences to store keyword occurrences.
•	Loops through each keyword in keywords and uses grep -o "$keyword" "$log_file" | wc -l to count occurrences of each keyword in the log file.
•	Stores the count of occurrences in the occurrences array.
•	Displays a summary report showing the count of occurrences for each keyword.

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
wait $pid

•	It checks if the script is called with exactly one argument (the log file path).
•	If the argument count ($#) is not 1, it displays a usage message and exits with status 1.
•	It sets the log_file_path variable to the provided log file path.
•	It checks if the specified log file exists (-f "$log_file_path").
•	If the log file does not exist, it displays an error message and exits with status 1.
•	It calls monitor_log_file "$log_file_path" & to start monitoring the log file in the background (&) and stores the PID ($!) of the background process.
•	It sets up a trap to catch SIGINT (Ctrl+C) and defines a cleanup procedure:
•	When SIGINT is caught, it kills the background monitoring process (kill $pid).
•	It displays a message indicating monitoring is stopped.
•	It calls analyze_log_file "$log_file_path" to analyze the log file.
•	Finally, it exits the script with status 0 (success) after the monitoring process ($pid) is finished (wait $pid).

