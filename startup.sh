#!/bin/bash

set -x
set -e

echo "Preparing container..."

echo "SPOTIFY_NAME=$SPOTIFY_NAME"
echo "BACKEND_NAME=$BACKEND_NAME"
echo "NORMALIZATION=$NORMALIZE_AUDIO"
BACKEND=""
VERB=""
NORMALIZATION="--initial-volume=100"
if [ "$VERBOSE" == "true" ]; then
  VERB="-v"
fi

if [ "$BACKEND_NAME" != "" ]; then
  BACKEND="--backend $BACKEND_NAME"
fi

if [ "$NORMALIZE_AUDIO" == "true" ]; then
  NORMALIZATION="--enable-volume-normalisation --initial-volume=100"
fi

echo "/etc/asound.conf"
envsubst < /asound.conf > /etc/asound.conf
cat /etc/asound.conf
echo ''

if [ "$EQUALIZATION" != "" ]; then
  echo "Applying equalization $EQUALIZATION"
  /equalizer.sh "$EQUALIZATION"
fi

set +e
#if [ "$ALSA_SOUND_LEVEL" != "" ]; then
#  echo "Applying sound level to $ALSA_SOUND_LEVEL"
  #TODO: enhance this logic
#  amixer cset numid=1 "$ALSA_SOUND_LEVEL"
#  amixer cset numid=2 "$ALSA_SOUND_LEVEL"
#  amixer cset numid=3 "$ALSA_SOUND_LEVEL"
#  amixer cset numid=4 "$ALSA_SOUND_LEVEL"
#  amixer cset numid=5 "$ALSA_SOUND_LEVEL"
#  amixer cset numid=6 "$ALSA_SOUND_LEVEL"
#  amixer cset numid=7 "$ALSA_SOUND_LEVEL"
#  amixer cset numid=8 "$ALSA_SOUND_LEVEL"
#fi
set -e

echo "Starting Raspotify..."
librespot $VERB --name "$SPOTIFY_NAME" $BACKEND $DEVICE --bitrate 320 --disable-audio-cache $NORMALIZATION

