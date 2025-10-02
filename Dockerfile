FROM ubuntu:noble

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		gnupg \
		wget \
	; \
	export GNUPGHOME="$(mktemp -d)"; \
	wget -O KEYS 'https://pgp.mongodb.com/server-8.0.asc'; \
	gpg --batch --import KEYS; \
	mkdir -p /etc/apt/keyrings; \
	gpg --batch --export --armor '4B0752C1BCA238C0B4EE14DC41DE058A4E7DCA05' > /etc/apt/keyrings/mongodb.asc; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" KEYS; \
	\
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

ENV MONGO_MAJOR 8.0
ENV MONGO_VERSION 8.0.15

RUN set -x \
    && echo "deb [ signed-by=/etc/apt/keyrings/mongodb.asc ] http://repo.mongodb.org/apt/ubuntu noble/mongodb-org/$MONGO_MAJOR multiverse" | tee "/etc/apt/sources.list.d/mongodb-org.list" \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
	    ca-certificates \
		mongodb-org-server=$MONGO_VERSION \
		mongodb-mongosh \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mongodb \
	&& mv /etc/mongod.conf /etc/mongod.conf.orig \
	&& ln -s /usr/bin/mongosh /usr/bin/mongo

VOLUME /data/db /data/configdb

ENV HOME /data/db

ENV GLIBC_TUNABLES glibc.pthread.rseq=0

EXPOSE 27017
CMD ["mongod"]
