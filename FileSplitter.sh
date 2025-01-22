#!/bin/bash
#set +x
LOG_FILE="Splitter_log.txt"
echo "Log started at $(date)" > "$LOG_FILE"

simplify_ratio() {
    local a=$1
    local b=$2
    while [ $b -ne 0 ]; do
        local temp=$b
        b=$((a % b))
        a=$temp
    done
    echo $(( $1 / a )):$(( $2 / a ))
}

show_loading_and_count_lines() {
    local file=$1
    #(while true; do echo -n "."; sleep 0.5; done) &
    #local loading_pid=$!
    local line_count=$(wc -l < "$file" | tr -d '[:space:]')
    #kill $loading_pid > /dev/null 2>&1
    #wait $loading_pid 2>/dev/null

    if [[ ! "$line_count" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid line count for $file" | tee -a "$LOG_FILE"
        echo "0"
    else
        echo "$line_count"
    fi
}

process_file() {
    local file=$1
    local choice=$2
    local line_count=$(show_loading_and_count_lines "$file")
    echo -e "\nProcessing file: $file" | tee -a "$LOG_FILE"
    echo "Number of lines: $line_count" | tee -a "$LOG_FILE"

    if [[ "$line_count" -le 0 ]]; then
        echo "Error: Invalid line count for $file" | tee -a "$LOG_FILE"
        return
    fi

    case $choice in
        1)
            HALF=$((line_count / 2))
            split -l $HALF "$file" half
            mv halfaa "half1_${file}"
            mv halfab "half2_${file}"
            echo "Split into two equal parts." | tee -a "$LOG_FILE"

            HALF1_COUNT=$(show_loading_and_count_lines "half1_${file}")
            HALF2_COUNT=$(show_loading_and_count_lines "half2_${file}")
            echo "Lines in half1: $HALF1_COUNT, Lines in half2: $HALF2_COUNT" | tee -a "$LOG_FILE"
            RATIO=$(simplify_ratio $HALF1_COUNT $HALF2_COUNT)
            if [[ -z "$HALF1_COUNT" || -z "$HALF2_COUNT" || "$HALF2_COUNT" -eq 0 ]]; then
                echo "Error: Invalid line counts for division in $file" | tee -a "$LOG_FILE"
            else
                DIVISION_RESULT=$(echo "scale=2; $HALF1_COUNT / $HALF2_COUNT" | bc)
                echo "Simplified Ratio: $RATIO" | tee -a "$LOG_FILE"
                echo "Division Result: $DIVISION_RESULT" | tee -a "$LOG_FILE"
            fi
            ;;
        2)
            ONE_THIRD=$((line_count / 3))
            TWO_THIRDS=$((line_count - ONE_THIRD))
            head -n $ONE_THIRD "$file" > "one_third_${file}"
            tail -n $TWO_THIRDS "$file" > "two_thirds_${file}"
            echo "Split into one-third and two-thirds." | tee -a "$LOG_FILE"

            ONE_THIRD_COUNT=$(show_loading_and_count_lines "one_third_${file}")
            TWO_THIRDS_COUNT=$(show_loading_and_count_lines "two_thirds_${file}")
            echo "Lines in one_third: $ONE_THIRD_COUNT, Lines in two_thirds: $TWO_THIRDS_COUNT" | tee -a "$LOG_FILE"
            RATIO=$(simplify_ratio $ONE_THIRD_COUNT $TWO_THIRDS_COUNT)
            if [[ -z "$ONE_THIRD_COUNT" || -z "$TWO_THIRDS_COUNT" || "$TWO_THIRDS_COUNT" -eq 0 ]]; then
                echo "Error: Invalid line counts for division in $file" | tee -a "$LOG_FILE"
            else
                DIVISION_RESULT=$(echo "scale=2; $ONE_THIRD_COUNT / $TWO_THIRDS_COUNT" | bc)
                echo "Simplified Ratio: $RATIO" | tee -a "$LOG_FILE"
                echo "Division Result: $DIVISION_RESULT" | tee -a "$LOG_FILE"
            fi
            ;;
        3)
            ONE_QUARTER=$((line_count / 4))
            THREE_QUARTERS=$((line_count - ONE_QUARTER))
            head -n $ONE_QUARTER "$file" > "one_quarter_${file}"
            tail -n $THREE_QUARTERS "$file" > "three_quarters_${file}"
            echo "Split into one-quarter and three-quarters." | tee -a "$LOG_FILE"

            ONE_QUARTER_COUNT=$(show_loading_and_count_lines "one_quarter_${file}")
            THREE_QUARTERS_COUNT=$(show_loading_and_count_lines "three_quarters_${file}")
            echo "Lines in one_quarter: $ONE_QUARTER_COUNT, Lines in three_quarters: $THREE_QUARTERS_COUNT" | tee -a "$LOG_FILE"
            RATIO=$(simplify_ratio $ONE_QUARTER_COUNT $THREE_QUARTERS_COUNT)
            if [[ -z "$ONE_QUARTER_COUNT" || -z "$THREE_QUARTERS_COUNT" || "$THREE_QUARTERS_COUNT" -eq 0 ]]; then
                echo "Error: Invalid line counts for division in $file" | tee -a "$LOG_FILE"
            else
                DIVISION_RESULT=$(echo "scale=2; $ONE_QUARTER_COUNT / $THREE_QUARTERS_COUNT" | bc)
                echo "Simplified Ratio: $RATIO" | tee -a "$LOG_FILE"
                echo "Division Result: $DIVISION_RESULT" | tee -a "$LOG_FILE"
            fi
            ;;
        *)
            echo "Invalid option for file: $file" | tee -a "$LOG_FILE"
            ;;
    esac
}

echo "Files in the current directory:" | tee -a "$LOG_FILE"
files=(*.csv)
for i in "${!files[@]}"; do
    echo "$((i+1))) ${files[i]}" | tee -a "$LOG_FILE"
done

declare -A file_choices
while true; do
    read -p "Enter the file number (or 'done' to finish): " file_num
    if [[ "$file_num" == "done" ]]; then
        break
    fi
    if [[ "$file_num" =~ ^[0-9]+$ ]] && ((file_num > 0 && file_num <= ${#files[@]})); then
        file=${files[file_num-1]}
        read -p "Choose how to split $file: (1: split into two halves, 2: split into one-third and two-thirds, 3: split into one-quarter and three-quarters): " choice
        file_choices[$file]=$choice
    else
        echo "Invalid file number." | tee -a "$LOG_FILE"
    fi
done

for file in "${!file_choices[@]}"; do
    process_file "$file" "${file_choices[$file]}"
done

echo "Log ended at $(date)" >> "$LOG_FILE"
