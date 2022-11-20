FROM ghcr.io/project-osrm/osrm-backend:v5.27.1

WORKDIR /osrm
RUN mkdir ./data

# Get osm data for your region of interest
RUN <<EOF
    apt-get update
    apt-get -y install curl
    curl http://download.geofabrik.de/asia/indonesia/java-latest.osm.pbf --output "data/#1"
EOF

# create a routable graph
RUN <<EOF
    osrm-extract -p /opt/car.lua data/java-latest.osm.pbf
    # Multi-Level Dijkstra: Build is fast but API response is slowly than CH
    # osrm-partition data/$REGION_VERSION.osm.pbf
    # osrm-customize data/$REGION_VERSION.osm.pbf
    # Contraction Hierarchies: Longer build time but faster API response
    osrm-contract data/java-latest.osm.pbf
EOF
