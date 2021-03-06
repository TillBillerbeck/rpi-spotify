FROM balenalib/rpi-raspbian:buster-20201118

#alsa install
RUN apt-get update && \
    apt-get install alsa-utils libasound2-plugin-equal gettext -y

#raspotify install
RUN apt-get update && \
    apt-get -y install curl apt-transport-https && \
    curl -sSLk https://dtcooper.github.io/raspotify/key.asc | apt-key add -v - && \
    echo "deb https://dtcooper.github.io/raspotify raspotify main" | tee /etc/apt/sources.list.d/raspotify.list && \
    apt-get update && \
    apt-get -y install raspotify 

ENV SPOTIFY_NAME RaspotifySpeaker
ENV BACKEND_NAME 'alsa'
ENV ALSA_SOUND_LEVEL '100%'
ENV VERBOSE 'false'
ENV EQUALIZATION ''
ENV NORMALIZE_AUDIO 'false'

ADD /asound.conf /
ADD /equalizer.sh /

ADD /startup.sh /
CMD /startup.sh
