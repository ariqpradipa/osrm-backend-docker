#!/bin/bash

# # Defaults
# OSRM_DATA_PATH=${OSRM_DATA_PATH:="/data"}
# OSRM_DATA_LABEL=${OSRM_DATA_LABEL:="java-latest"}
# OSRM_GRAPH_PROFILE=${OSRM_GRAPH_PROFILE:="car"}
# OSRM_GRAPH_PROFILE_URL=${OSRM_GRAPH_PROFILE_URL:=""}
# OSRM_PBF_URL=${OSRM_PBF_URL:="http://download.geofabrik.de/asia/indonesia/java-latest.osm.pbf"}
# OSRM_MAX_TABLE_SIZE=${OSRM_MAX_TABLE_SIZE:="8000"}

_sig() {
  kill -TERM $child 2>/dev/null
}
trap _sig SIGKILL SIGTERM SIGHUP SIGINT EXIT

# # Retrieve the PBF file
# curl -L $OSRM_PBF_URL --create-dirs -o $OSRM_DATA_PATH/$OSRM_DATA_LABEL.osm.pbf

# # Set the graph profile path
# OSRM_GRAPH_PROFILE_PATH="/opt/$OSRM_GRAPH_PROFILE.lua"

# # If the URL to a custom profile is provided override the default profile
# if [ ! -z "$OSRM_GRAPH_PROFILE_URL" ]; then
#     # Set the custom graph profile path
#     OSRM_GRAPH_PROFILE_PATH="/opt/custom-profile.lua"
#     # Retrieve the custom graph profile
#     curl -L $OSRM_GRAPH_PROFILE_URL --create-dirs -o $OSRM_GRAPH_PROFILE_PATH
# fi

# # Build the graph
# osrm-extract $OSRM_DATA_PATH/$OSRM_DATA_LABEL.osm.pbf -p $OSRM_GRAPH_PROFILE_PATH
# osrm-contract $OSRM_DATA_PATH/$OSRM_DATA_LABEL.osrm

# Start serving requests
osrm-routed data/java-latest.osrm --max-table-size 8000 &
child=$!
wait "$child"
