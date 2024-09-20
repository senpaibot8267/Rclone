#!/bin/bash

# Function to unmount remotes
cleanup() {
    echo "Unmounting remotes..."
    fusermount -u /home/senpai/Cloud/animemovies
    fusermount -u /home/senpai/Cloud/animemovies1
    fusermount -u /home/senpai/Cloud/animeshows
    fusermount -u /home/senpai/Cloud/animeshows1
    fusermount -u /home/senpai/Cloud/movies
    fusermount -u /home/senpai/Cloud/movies1
    fusermount -u /home/senpai/Cloud/movies2
    fusermount -u /home/senpai/Cloud/rss
    fusermount -u /home/senpai/Cloud/tvshows
    fusermount -u /home/senpai/Cloud/tvshows1
    fusermount -u /home/senpai/JellyCloud/animemovies
    fusermount -u /home/senpai/JellyCloud/animeshows
    fusermount -u /home/senpai/JellyCloud/movies
    fusermount -u /home/senpai/JellyCloud/tvshows
}

# Trap exit signal to call cleanup function
trap cleanup EXIT

# Common rclone mount options
RCLONE_MOUNT_OPTIONS="--vfs-cache-mode full --allow-other --allow-non-empty"

# Common MergerFS options
MERGERFS_OPTIONS="-o async_read=true,use_ino,allow_other,auto_cache,func.getattr=newest,cache.files=off,dropcacheonclose=true,category.create=mfs"

# Create mount points if they don't exist
mkdir -p /home/senpai/Cloud/{animemovies,animemovies1,animeshows,animeshows1,movies,movies1,movies2,rss,tvshows,tvshows1}
mkdir -p /home/senpai/JellyCloud/{animemovies,animeshows,movies,tvshows}

# Mount all remotes
rclone mount $RCLONE_MOUNT_OPTIONS -v animemovies: /home/senpai/Cloud/animemovies &
rclone mount $RCLONE_MOUNT_OPTIONS -v animemovies1: /home/senpai/Cloud/animemovies1 &
rclone mount $RCLONE_MOUNT_OPTIONS -v animeshows: /home/senpai/Cloud/animeshows &
rclone mount $RCLONE_MOUNT_OPTIONS -v animeshows1: /home/senpai/Cloud/animeshows1 &
rclone mount $RCLONE_MOUNT_OPTIONS -v movies: /home/senpai/Cloud/movies &
rclone mount $RCLONE_MOUNT_OPTIONS -v movies1: /home/senpai/Cloud/movies1 &
rclone mount $RCLONE_MOUNT_OPTIONS -v movies2: /home/senpai/Cloud/movies2 &
rclone mount $RCLONE_MOUNT_OPTIONS -v rss: /home/senpai/Cloud/rss &
rclone mount $RCLONE_MOUNT_OPTIONS -v tvshows: /home/senpai/Cloud/tvshows &
rclone mount $RCLONE_MOUNT_OPTIONS -v tvshows1: /home/senpai/Cloud/tvshows1 &

# Merge directories
sudo mergerfs $MERGERFS_OPTIONS -o fsname=animemovies /home/senpai/Cloud/animemovies:/home/senpai/Cloud/animemovies1 /home/senpai/JellyCloud/animemovies &
sudo mergerfs $MERGERFS_OPTIONS -o fsname=animeshows /home/senpai/Cloud/animeshows:/home/senpai/Cloud/animeshows1 /home/senpai/JellyCloud/animeshows &
sudo mergerfs $MERGERFS_OPTIONS -o fsname=movies /home/senpai/Cloud/movies:/home/senpai/Cloud/movies1:/home/senpai/Cloud/movies2 /home/senpai/JellyCloud/movies &
sudo mergerfs $MERGERFS_OPTIONS -o fsname=tvshows /home/senpai/Cloud/tvshows:/home/senpai/Cloud/tvshows1 /home/senpai/JellyCloud/tvshows &

# Wait for mounts to be ready
sleep 10

# Keep the container running
while :; do sleep 1; done
