FROM alpine:3.3
MAINTAINER Steve Hibit <sdhibit@gmail.com>

# Install apk packages
RUN apk --update upgrade \
 && apk add \
  openjdk8-jre-base \
  unzip \
  wget \
 && rm /var/cache/apk/*

# Set Madsonic Package Information
ENV PKG_NAME madsonic 
ENV PKG_VER 6.2.8920
ENV PKG_DATE 20161125
ENV APP_PKGNAME ${PKG_DATE}_${PKG_NAME}-${PKG_VER}-standalone.zip 
ENV TRAN_PKGNAME ${PKG_DATE}_${PKG_NAME}-transcode-linux-x64.zip 
ENV APP_PATH /var/madsonic

# Copy & Install Madsonic

RUN mkdir -p "${APP_PATH}/transcode"
ADD ${APP_PKGNAME} "${APP_PATH}/madsonic.zip"
ADD ${TRAN_PKGNAME} "${APP_PATH}/transcode/transcode.zip"

RUN unzip "${APP_PATH}/madsonic.zip" -d ${APP_PATH} \
 && unzip "${APP_PATH}/transcode/transcode.zip" -d "${APP_PATH}/transcode" \
 && rm "${APP_PATH}/madsonic.zip" \
 && rm "${APP_PATH}/transcode/transcode.zip" 

# Create user and change ownership
RUN mkdir /config \
 && addgroup -g 666 -S madsonic \
 && adduser -u 666 -SHG madsonic madsonic \
 && chown -R madsonic:madsonic \
    ${APP_PATH} \
    "/config"

VOLUME ["/config"]

# HTTP ports
EXPOSE 4443

# Add run script
ADD madsonic.sh /madsonic.sh
RUN chmod +x /madsonic.sh
RUN chmod +x ${APP_PATH}/transcode/transcode/ffmpeg
# Removed??
#RUN chmod +x ${APP_PATH}/transcode/transcode/lame
#RUN chmod +x ${APP_PATH}/transcode/transcode/xmp

USER madsonic
WORKDIR /var/madsonic

CMD ["/madsonic.sh"]
