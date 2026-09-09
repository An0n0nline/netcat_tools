#!/bin/bash

# Display Header
display_header() {
    echo
    echo "///// NETCAT TOOLS /////"
    echo "= = = UNENCRYPTED = = ="
    echo
}

# Main menu function
main_menu() {
    display_header
    echo "Please make a selection from the following options:"
    echo "(1) NETCAT CHAT - Start a chat session"
    echo "(2) NETCAT SEND - Send or receive files"
    echo "(3) NETCAT STREAM - Send or receive stream data"
    echo "(4) EXIT - Quit the program"
    read -p "Enter your choice (1-4): " SELECTION1
    
    case $SELECTION1 in
        1) chat_menu ;;
        2) file_menu ;;
        3) stream_menu ;;
        4) echo "Thank you for using Netcat Tools! Goodbye."; exit 0 ;;
        *) echo "Invalid selection. Please try again."; main_menu ;;
    esac
}

# Chat function
chat_menu() {
    display_header
    echo "Netcat Chat - Unencrypted Communication"
    echo "Choose whether you want to listen or connect:"
    read -p "(1) LISTEN or (2) CLIENT: " LOC
    
    if [ "$LOC" = "1" ]; then
        read -p "Enter PORT to listen on (1-65535): " PORT1
        if [[ ! "$PORT1" =~ ^[0-9]+$ ]] || [ "$PORT1" -lt 1 ] || [ "$PORT1" -gt 65535 ]; then
            echo "Invalid port number!"
            chat_menu
            return
        fi
        echo "Listening on port $PORT1 (press Ctrl+C to exit)..."
        nc -l -p $PORT1
    elif [ "$LOC" = "2" ]; then
        read -p "Enter IP address: " IP
        read -p "Enter PORT (1-65535): " PORT2
        if [[ ! "$PORT2" =~ ^[0-9]+$ ]] || [ "$PORT2" -lt 1 ] || [ "$PORT2" -gt 65535 ]; then
            echo "Invalid port number!"
            chat_menu
            return
        fi
        echo "Connecting to $IP:$PORT2 (press Ctrl+C to exit)..."
        nc $IP $PORT2
    else
        echo "Invalid selection!"
        chat_menu
    fi
    return_to_menu
}

# File transfer function
file_menu() {
    display_header
    echo "Netcat File Send/Receive - Unencrypted Data Transfer"
    read -p "(1) SEND a file or (2) RECEIVE a file: " DIRECTION
    
    if [ "$DIRECTION" = "1" ]; then
        read -p "Enter PORT to send on (1-65535): " PORT1
        read -p "Enter FILE NAME to send: " FILE1
        if [ ! -f "$FILE1" ]; then
            echo "File '$FILE1' does not exist!"
            file_menu
            return
        fi
        echo "Sending file '$FILE1' on port $PORT1..."
        nc -l -p $PORT1 < "$FILE1"
    elif [ "$DIRECTION" = "2" ]; then
        read -p "Enter PORT to receive on (1-65535): " PORT2
        read -p "Enter IP address of sender: " IP1
        read -p "Enter FILE NAME to save as: " FILE2
        echo "Receiving file from $IP1:$PORT2, saving as '$FILE2'..."
        nc $IP1 $PORT2 > "$FILE2"
        echo "File received successfully!"
    else
        echo "Invalid selection!"
        file_menu
    fi
    return_to_menu
}

# Stream function
stream_menu() {
    display_header
    echo "Netcat Stream Transfer - Unencrypted Data Stream"
    read -p "(1) SEND stream data or (2) RECEIVE stream data: " DIRECTION
    
    if [ "$DIRECTION" = "1" ]; then
        read -p "Enter PORT to send from (1-65535): " PORT1
        read -p "Enter STREAM DATA to send: " DATA1
        echo "Sending stream data on port $PORT1..."
        echo "$DATA1" | nc -l -p $PORT1
    elif [ "$DIRECTION" = "2" ]; then
        read -p "Enter PORT to receive on (1-65535): " PORT2
        read -p "Enter IP address of sender: " IP1
        echo "Receiving stream data from $IP1:$PORT2..."
        nc $IP1 $PORT2
    else
        echo "Invalid selection!"
        stream_menu
    fi
    return_to_menu
}

# Return to menu function
return_to_menu() {
    echo "====================================="
    read -p "Press Enter to return to the menu or 'q' to quit: " ANSWER
    if [ "$ANSWER" = "q" ] || [ "$ANSWER" = "Q" ]; then
        echo "Thank you for using Netcat Tools! Goodbye."
        exit 0
    else
        main_menu
    fi
}

# Start the script
main_menu
