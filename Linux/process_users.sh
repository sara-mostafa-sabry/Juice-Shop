#!/bin/bash

# Input file path
FILE_PATH="$1"

# Check if the file exists
if [ -e "$FILE_PATH" ]; then

    # Check if the file is empty
    if [ ! -s "$FILE_PATH" ]; then
        echo "The file '$FILE_PATH' exists but is empty."
    else

        line_number=0

        # Process the input file line by line
        while IFS=, read -r name email id || [[ -n "$name" ]]; do

            # Increment the line counter
            ((line_number++))

            # Skip the first line (header)
            if [ "$line_number" -eq 1 ]; then
                continue
            fi

            # Trim any leading or trailing spaces from the fields
            name=$(echo $name | xargs)
            email=$(echo $email | xargs)
            id=$(echo $id | xargs)

            # Initialize a flag to track validity
            is_valid=true
            error_message=""
            
            # Check for missing or invalid email
            if [[ -z "$email" ]]; then
                is_valid=false
                error_message+="Missing the email. "
            elif ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
                is_valid=false
                error_message+="Not routable email. "
            fi

            # Check for missing or invalid ID
            if [[ -z "$id" ]]; then
                is_valid=false
                error_message+="Missing the ID. "
            elif ! [[ "$id" =~ ^[0-9]+$ ]]; then
                is_valid=false
                error_message+="ID is not numeric; "
            fi

            # If the user has invalid parameters, print the detailed error message and continue
            if [[ "$is_valid" == false ]]; then
                echo "Warning: Invalid parameters for user $name. Issues: $error_message"
                continue
            fi

            # Determine if ID is even or odd
            if (( id % 2 == 0 )); then
                result="even"
            else
                result="odd"
            fi

            # Print the result in the required format
            echo "The ID of $email is $result number."
        done < "$FILE_PATH"  # Read lines from the specified input file
    fi
    # For example, you could read the file or perform other operations
else
    echo "Error: The file '$FILE_PATH' does not exist."
    exit 1
fi