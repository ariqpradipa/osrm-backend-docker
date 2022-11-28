FROM ghcr.io/project-osrm/osrm-backend:v5.27.1

WORKDIR /osrm
RUN mkdir ./data

# Get osm data for your region of interest
RUN apt-get update
RUN apt-get -y install curl
RUN curl http://download.geofabrik.de/asia/indonesia/java-latest.osm.pbf --output "data/java-latest.osm.pbf"

# create a routable graph
RUN osrm-extract -p /opt/car.lua data/java-latest.osm.pbf
    # Multi-Level Dijkstra: Build is fast but API response is slowly than CH
    # osrm-partition data/$REGION_VERSION.osm.pbf
    # osrm-customize data/$REGION_VERSION.osm.pbf
    # Contraction Hierarchies: Longer build time but faster API response
RUN osrm-contract data/java-latest.osrm

# Set the entrypoint
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5000
