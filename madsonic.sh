#!/bin/sh

#create folders on config
mkdir -p /config/media/incoming
mkdir -p /config/media/podcast
mkdir -p /config/playlists/import
mkdir -p /config/playlists/export
mkdir -p /config/playlists/backup
mkdir -p /config/transcode

#copy transcode to config directory - transcode directory is subdir of path set from --home flag, do not alter
cp /var/madsonic/transcode/transcode/* /config/transcode/

# Force Madsonic to run in foreground
sed -i 's/-jar madsonic-booter.jar > \${LOG} 2>\&1 \&/-jar madsonic-booter.jar > \${LOG} 2>\&1/g' /var/madsonic/madsonic.sh

if [ -z "$CONTEXT" ]; then
  CONTEXT=/
fi

PORTS="--https-port=4443"

/var/madsonic/madsonic.sh \
  --home=/config \
  --context-path=$CONTEXT \
  --default-music-folder=/media \
  --default-podcast-folder=/config/media/podcast \
  --default-playlist-import-folder=/config/playlists/import \
  --default-playlist-export-folder=/config/playlists/export \
  --default-playlist-backup-folder=/config/playlists/backup \
  ${PORTS}
