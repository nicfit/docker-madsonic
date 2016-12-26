.PHONY: image clean madsonic

IMG_NAME ?= madsonic
CONT_NAME ?= madsonic
MUSIC_DIR ?= ~/Music
DATA_DIR ?= /opt/madsonic

image:
	docker build -t ${IMG_NAME} .

clean:
	docker rmi ${IMG_NAME}

madsonic: image
	docker create --name ${CONT_NAME} --net="host" \
           --volume /etc/localtime:/etc/localtime:ro \
           --volume ${DATA_DIR}:/config \
           --volume ${MUSIC_DIR}:/media \
           --publish 4443:4443 \
           ${IMG_NAME}

