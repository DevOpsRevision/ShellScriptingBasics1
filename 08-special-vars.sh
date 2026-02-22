#!/bin/bash

echo "The name of the script is: $0"
echo "The first argument is: $1"
echo "The second argument is: $2"
echo "The total number of arguments is: $#"
echo "All arguments passed to the script: $@"
echo "The process ID of the current script is: $$"
sleep 5 &
echo "The process ID of the last background command is $!"
echo "The exit status of the last command is: $?"
