#!/bin/bash -e

# 1. Define variables for clarity
URL="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"
RAW_FILE="earthquakes_raw.json"
FORMATTED_FILE="earthquakes_formatted.pipe"

echo "Fetching fresh data from USGS..."
# -s hides the progress bar, -S shows errors if they occur
curl -sS "$URL" -o "$RAW_FILE"

echo "Converting JSON to pipe-delimited format..."
# We extract Mag, Place, Time, Longitude, and Latitude
jq -r '.features[] | "\(.properties.mag)|\(.properties.place)|\(.properties.time)|\(.geometry.coordinates[0])|\(.geometry.coordinates[1])"' "$RAW_FILE" > "$FORMATTED_FILE"

echo "Feeding data into Chimera via cliapp..."
# This command assumes 'cliapp' is in your PATH and takes the file as an argument
cliapp load "$FORMATTED_FILE"

echo "Update complete!"