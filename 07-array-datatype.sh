#!/bin/bash

MOVIES=("Movie1", "Movie2", "Movie3")

echo "The first movie in the array is: ${MOVIES[0]}"
echo "The second movie in the array is: ${MOVIES[1]}"
echo "The third movie in the array is: ${MOVIES[2]}"
echo "All movies in the array: ${MOVIES[@]}"
echo "Number of movies in the array: ${#MOVIES[@]}"
