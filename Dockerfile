# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Install rclone, mergerfs, and other dependencies
RUN apt-get update && \
    apt-get install -y rclone mergerfs && \
    apt-get clean

# Copy the bash script into the container
COPY mount-and-merge.sh /usr/local/bin/mount-and-merge.sh

# Make the script executable
RUN chmod +x /usr/local/bin/mount-and-merge.sh

# Set the entrypoint to run the script
ENTRYPOINT ["/usr/local/bin/mount-and-merge.sh"]
